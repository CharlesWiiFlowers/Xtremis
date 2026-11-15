"""SPHEREx image pipeline: search -> group by detector/epoch -> cached cutouts -> coadd -> PNG.

All remote access goes through ``spherex_adapter`` (IRSA SIA2 search and IRSA cutout service).
Every frame is reprojected onto a common north-up TAN grid centred on the target, so per-frame,
per-epoch and per-detector images are pixel-aligned and can be used directly in a time-lapse viewer.
"""
import hashlib
import io
import json
import logging
import os
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np
from astropy.io import fits
from astropy.time import Time
from astropy.visualization import ZScaleInterval
from astropy.wcs import WCS
from matplotlib import colormaps
from PIL import Image
from reproject import reproject_interp
from scipy import ndimage

from . import spherex_adapter as spherex

logger = logging.getLogger(__name__)

CACHE_DIR = Path(os.environ.get("XTREMIS_CACHE_DIR", Path(__file__).resolve().parents[1] / "cache"))
CUTOUT_DIR = CACHE_DIR / "cutouts"
SEARCH_DIR = CACHE_DIR / "searches"
RENDER_DIR = CACHE_DIR / "renders"

DETECTORS = [f"D{i}" for i in range(1, 7)]
PIPELINE_VERSION = 4
SEARCH_RADIUS_DEG = 0.0005          # only images that actually contain the target
DOWNLOAD_WORKERS = int(os.environ.get("XTREMIS_DOWNLOAD_WORKERS", "8"))
MIN_PNG_SIZE_PX = 512
CUTOUT_EXTENSIONS = ("IMAGE", "FLAGS", "VARIANCE", "ZODI", "WCS-WAVE")   # EPSF (~4 MB) is dropped

_request_locks: dict[str, threading.Lock] = {}
_request_locks_guard = threading.Lock()


@dataclass
class ImageRequest:
    ra: float
    dec: float
    fov_arcmin: float = 10.0
    frames_per_group: int = 4
    epoch_gap_days: float = 45.0
    rgb: tuple[str, str, str] = ("D5", "D3", "D1")
    cmap: str = "gray"
    collections: list[str] = field(default_factory=lambda: list(spherex.DEFAULT_COLLECTIONS))

    @property
    def fov_deg(self) -> float:
        return self.fov_arcmin / 60.0

    def key(self) -> str:
        payload = json.dumps([PIPELINE_VERSION, round(self.ra, 6), round(self.dec, 6), self.fov_arcmin,
                              self.frames_per_group, self.epoch_gap_days, list(self.rgb), self.cmap,
                              sorted(self.collections)])
        return hashlib.sha1(payload.encode()).hexdigest()[:16]


# ---------------------------------------------------------------- search and grouping
def _detector_label(band_name: str) -> str:
    """'SPHEREx-D3' -> 'D3'."""
    return str(band_name).rsplit("-", 1)[-1]


def mjd_to_iso(mjd: float) -> str:
    return Time(mjd, format="mjd").isot[:19] + "Z"


def search_frames(ra: float, dec: float, collections: list[str]) -> list[dict]:
    """SIA2 search (cached on disk), returned as plain dicts sorted chronologically."""
    SEARCH_DIR.mkdir(parents=True, exist_ok=True)
    key = hashlib.sha1(json.dumps([round(ra, 6), round(dec, 6), sorted(collections)]).encode()).hexdigest()[:16]
    path = SEARCH_DIR / f"{key}.json"
    if path.exists():
        return json.loads(path.read_text())
    table = spherex.search_images(ra, dec, SEARCH_RADIUS_DEG, collections)
    frames = []
    for row in table:
        if str(row["dataproduct_type"]) != "image":
            continue
        frames.append({
            "obs_publisher_did": str(row["obs_publisher_did"]),
            "obs_id": str(row["obs_id"]),
            "collection": str(row["obs_collection"]),
            "detector": _detector_label(row["energy_bandpassname"]),
            "mjd_start": float(row["t_min"]),
            "mjd_end": float(row["t_max"]),
            "wavelength_min_um": float(row["em_min"]) * 1e6,
            "wavelength_max_um": float(row["em_max"]) * 1e6,
            "access_url": str(row["access_url"]),
        })
    frames.sort(key=lambda f: (f["mjd_start"], f["detector"]))
    path.write_text(json.dumps(frames))
    return frames


def assign_epochs(frames: list[dict], gap_days: float) -> list[dict]:
    """Split the chronological frame list into epochs wherever consecutive frames are > gap_days apart."""
    epochs: list[dict] = []
    for frame in sorted(frames, key=lambda f: f["mjd_start"]):
        if not epochs or frame["mjd_start"] - epochs[-1]["mjd_end"] > gap_days:
            epochs.append({"index": len(epochs), "mjd_start": frame["mjd_start"], "mjd_end": frame["mjd_end"]})
        epoch = epochs[-1]
        epoch["mjd_end"] = max(epoch["mjd_end"], frame["mjd_end"])
        frame["epoch"] = epoch["index"]
    return epochs


def select_frames(frames: list[dict], per_group: int) -> list[dict]:
    """Keep up to ``per_group`` frames per (epoch, detector), evenly spread in time."""
    groups: dict[tuple[int, str], list[dict]] = {}
    for frame in frames:
        groups.setdefault((frame["epoch"], frame["detector"]), []).append(frame)
    selected = []
    for members in groups.values():
        if len(members) <= per_group:
            selected += members
        else:
            idx = np.unique(np.linspace(0, len(members) - 1, per_group).round().astype(int))
            selected += [members[i] for i in idx]
    return sorted(selected, key=lambda f: (f["mjd_start"], f["detector"]))


# ---------------------------------------------------------------- cutouts (disk cache)
def _frame_cutout_dir(frame: dict) -> Path:
    return CUTOUT_DIR / hashlib.sha1(frame["obs_publisher_did"].encode()).hexdigest()[:16]


def fetch_cutout(frame: dict, ra: float, dec: float, size_deg: float) -> Path:
    """Download an IRSA cutout once and keep a slim copy (no EPSF table) in ``cache/cutouts/<frame>/``."""
    folder = _frame_cutout_dir(frame)
    folder.mkdir(parents=True, exist_ok=True)
    key = hashlib.sha1(f"{ra:.6f}|{dec:.6f}|{size_deg:.6f}".encode()).hexdigest()[:16]
    path = folder / f"{key}.fits"
    if path.exists():
        return path
    raw = spherex.download(spherex.cutout_url(frame["access_url"], ra, dec, size_deg))
    with fits.open(io.BytesIO(raw)) as hdul:
        slim = fits.HDUList([fits.PrimaryHDU()] + [hdul[name].copy() for name in CUTOUT_EXTENSIONS if name in hdul])
        tmp = path.with_suffix(f".{threading.get_ident()}.tmp")
        slim.writeto(tmp, overwrite=True)
    tmp.replace(path)
    return path


def find_cached_cutout(frame: dict, ra: float, dec: float, margin_px: int) -> Path | None:
    """Any cached cutout of this frame that contains (ra, dec) at least ``margin_px`` pixels from its edges."""
    folder = _frame_cutout_dir(frame)
    if not folder.is_dir():
        return None
    for path in sorted(folder.glob("*.fits")):
        header = fits.getheader(path, "IMAGE")
        x, y = (float(v) for v in WCS(header).world_to_pixel_values(ra, dec))
        if margin_px <= x <= header["NAXIS1"] - 1 - margin_px and margin_px <= y <= header["NAXIS2"] - 1 - margin_px:
            return path
    return None


def target_wcs(ra: float, dec: float, fov_deg: float) -> tuple[WCS, tuple[int, int]]:
    """North-up, east-left TAN grid at the native SPHEREx pixel scale."""
    scale = spherex.PIXEL_SCALE_ARCSEC / 3600.0
    n = max(8, int(np.ceil(fov_deg / scale)))
    wcs = WCS(naxis=2)
    wcs.wcs.ctype = ["RA---TAN", "DEC--TAN"]
    wcs.wcs.crval = [ra, dec]
    wcs.wcs.crpix = [(n + 1) / 2, (n + 1) / 2]
    wcs.wcs.cdelt = [-scale, scale]
    return wcs, (n, n)


def load_frame(path: Path, wcs: WCS, shape: tuple[int, int]) -> tuple[np.ndarray, np.ndarray]:
    """Zodi-subtracted surface brightness (MJy/sr) on the target grid.

    Returns ``(clean, raw)``: ``clean`` has severe-flag pixels set to NaN, ``raw`` keeps them
    (used only to fill holes such as saturated star cores in the rendered images).
    """
    with fits.open(path) as hdul:
        header = hdul["IMAGE"].header
        raw = hdul["IMAGE"].data.astype(float)
        if "ZODI" in hdul:
            raw -= hdul["ZODI"].data
        clean = raw.copy()
        if "FLAGS" in hdul:
            clean[(hdul["FLAGS"].data.astype(np.int64) & spherex.SEVERE_FLAG_BITS) != 0] = np.nan
        frame_wcs = WCS(header, naxis=2)
    layers, footprint = reproject_interp((np.stack([clean, raw]), frame_wcs), wcs, shape_out=shape)
    layers[:, footprint[0] == 0] = np.nan
    return layers[0], layers[1]


def _nanmedian(cube: np.ndarray) -> np.ndarray:
    result = np.full(cube.shape[1:], np.nan)
    valid = np.isfinite(cube).any(axis=0)
    result[valid] = np.nanmedian(cube[:, valid], axis=0)
    return result


def coadd(stack: list[tuple[np.ndarray, np.ndarray]]) -> np.ndarray | None:
    """Median coadd of clean frames (robust to transients); holes are filled from the raw median."""
    if not stack:
        return None
    clean = _nanmedian(np.stack([c for c, _ in stack]))
    raw = _nanmedian(np.stack([r for _, r in stack]))
    return np.where(np.isfinite(clean), clean, raw)


# ---------------------------------------------------------------- rendering
def fill_holes(data: np.ndarray, bright_level: float, max_iterations: int = 20) -> np.ndarray:
    """Fill NaN holes left by saturated star cores with the brightest neighbour (display only).

    A NaN region is filled when it is fully enclosed by data, or when its rim is brighter than
    ``bright_level`` (a saturated star clipped by the cutout edge). Off-footprint regions are kept.
    """
    finite = np.isfinite(data)
    labels, count = ndimage.label(~finite)
    if not count:
        return data
    enclosed = ndimage.binary_fill_holes(finite) & ~finite
    holes = np.zeros_like(finite)
    for index in range(1, count + 1):
        region = labels == index
        rim = ndimage.binary_dilation(region) & finite
        if enclosed[region].all() or (rim.any() and np.percentile(data[rim], 75) > bright_level):
            holes |= region
    if not holes.any():
        return data
    filled = data.copy()
    for _ in range(max_iterations):
        grown = ndimage.grey_dilation(np.where(np.isfinite(filled), filled, -np.inf), size=3)
        todo = holes & ~np.isfinite(filled) & np.isfinite(grown)
        if not todo.any():
            break
        filled[todo] = grown[todo]
    return filled


def normalize(data: np.ndarray) -> np.ndarray:
    """ZScale contrast stretch to [0, 1]; saturated-core holes are filled, remaining NaNs become 0."""
    finite = np.isfinite(data)
    if not finite.any():
        return np.zeros_like(data)
    vmin, vmax = ZScaleInterval().get_limits(data[finite])
    data = fill_holes(data, vmax)
    if vmax <= vmin:
        vmax = vmin + 1e-9
    return np.nan_to_num(np.clip((data - vmin) / (vmax - vmin), 0, 1))


def png_pixel_to_world(ra: float, dec: float, fov_deg: float, x: float, y: float) -> tuple[float, float] | None:
    """Sky position of pixel (x, y) (origin top-left) in a PNG rendered for a view centred on (ra, dec)."""
    wcs, (ny, nx) = target_wcs(ra, dec, fov_deg)
    factor = max(1, int(np.ceil(MIN_PNG_SIZE_PX / max(nx, ny))))
    col = (x + 0.5) / factor - 0.5
    row = ny - 1 - ((y + 0.5) / factor - 0.5)
    if not (-0.5 <= col < nx - 0.5 and -0.5 <= row < ny - 0.5):
        return None
    lon, lat = (float(v) for v in wcs.pixel_to_world_values(col, row))
    return lon % 360.0, lat


def _save_png(rgb: np.ndarray, path: Path) -> None:
    """Write an (H, W, 3) float [0, 1] array, flipped to north-up and upscaled with nearest neighbour."""
    img = Image.fromarray((np.flipud(rgb) * 255).round().astype(np.uint8), mode="RGB")
    factor = max(1, int(np.ceil(MIN_PNG_SIZE_PX / max(img.size))))
    if factor > 1:
        img = img.resize((img.width * factor, img.height * factor), Image.Resampling.NEAREST)
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, optimize=True)


def render_gray(data: np.ndarray, path: Path, cmap: str = "gray") -> None:
    _save_png(colormaps[cmap](normalize(data))[..., :3], path)


def render_rgb(red: np.ndarray, green: np.ndarray, blue: np.ndarray, path: Path) -> None:
    _save_png(np.dstack([normalize(red), normalize(green), normalize(blue)]), path)


# ---------------------------------------------------------------- pipeline
def lock_for(key: str) -> threading.Lock:
    with _request_locks_guard:
        return _request_locks.setdefault(key, threading.Lock())


def build_sky_images(req: ImageRequest) -> dict:
    """Run (or load from cache) the full pipeline. PNG locations are relative to ``RENDER_DIR``."""
    key = req.key()
    out_dir = RENDER_DIR / key
    result_path = out_dir / "result.json"
    with lock_for(key):
        if result_path.exists():
            return {**json.loads(result_path.read_text()), "cached": True}
        started = time.time()
        result = _run_pipeline(req, key, out_dir)
        result["elapsed_s"] = round(time.time() - started, 2)
        out_dir.mkdir(parents=True, exist_ok=True)
        result_path.write_text(json.dumps(result))
        return {**result, "cached": False}


def _run_pipeline(req: ImageRequest, key: str, out_dir: Path) -> dict:
    found = search_frames(req.ra, req.dec, req.collections)
    epochs = assign_epochs(found, req.epoch_gap_days)
    frames = select_frames(found, req.frames_per_group)
    wcs, shape = target_wcs(req.ra, req.dec, req.fov_deg)

    aligned: dict[int, tuple[np.ndarray, np.ndarray]] = {}
    errors = []
    with ThreadPoolExecutor(DOWNLOAD_WORKERS) as pool:
        jobs = {pool.submit(fetch_cutout, f, req.ra, req.dec, req.fov_deg): i for i, f in enumerate(frames)}
        for job in as_completed(jobs):
            i = jobs[job]
            try:
                aligned[i] = load_frame(job.result(), wcs, shape)
            except Exception as exc:  # noqa: BLE001 - one bad frame must not break the whole request
                logger.warning("frame %s failed: %s", frames[i]["obs_publisher_did"], exc)
                errors.append({"obs_publisher_did": frames[i]["obs_publisher_did"], "error": str(exc)[:200]})

    frame_items = []
    for i, frame in enumerate(frames):
        if i not in aligned or not np.isfinite(aligned[i][1]).any():
            continue
        rel = f"{key}/frames/{len(frame_items):03d}_{frame['detector']}.png"
        render_gray(aligned[i][1], RENDER_DIR / rel, req.cmap)
        mjd = (frame["mjd_start"] + frame["mjd_end"]) / 2
        frame_items.append({
            "index": len(frame_items), "obs_id": frame["obs_id"], "obs_publisher_did": frame["obs_publisher_did"],
            "collection": frame["collection"], "detector": frame["detector"], "epoch": frame["epoch"],
            "mjd": mjd, "date_utc": mjd_to_iso(mjd),
            "wavelength_min_um": round(frame["wavelength_min_um"], 4),
            "wavelength_max_um": round(frame["wavelength_max_um"], 4),
            "png": rel, "_slot": i,
        })

    detectors, coadds = [], {}
    for det in DETECTORS:
        members = [f for f in frame_items if f["detector"] == det]
        coadds[det] = coadd([aligned[f["_slot"]] for f in members])
        rel = None
        if coadds[det] is not None:
            rel = f"{key}/coadd_{det}.png"
            render_gray(coadds[det], RENDER_DIR / rel, req.cmap)
        detectors.append({
            "detector": det, "frames": len(members),
            "wavelength_min_um": min((f["wavelength_min_um"] for f in members), default=None),
            "wavelength_max_um": max((f["wavelength_max_um"] for f in members), default=None),
            "coadd_png": rel,
        })

    epoch_items = []
    for epoch in epochs:
        members = [f for f in frame_items if f["epoch"] == epoch["index"]]
        if not members:
            continue
        pngs = {}
        for det in DETECTORS:
            stack = [aligned[f["_slot"]] for f in members if f["detector"] == det]
            if stack:
                pngs[det] = f"{key}/epochs/{epoch['index']}_{det}.png"
                render_gray(coadd(stack), RENDER_DIR / pngs[det], req.cmap)
        epoch_items.append({
            "index": epoch["index"], "mjd_start": epoch["mjd_start"], "mjd_end": epoch["mjd_end"],
            "date_start_utc": mjd_to_iso(epoch["mjd_start"]), "date_end_utc": mjd_to_iso(epoch["mjd_end"]),
            "frames": len(members), "detector_pngs": pngs,
        })

    false_color = None
    if all(coadds.get(d) is not None for d in req.rgb):
        rel = f"{key}/false_color_{'_'.join(req.rgb)}.png"
        render_rgb(*(coadds[d] for d in req.rgb), RENDER_DIR / rel)
        false_color = {"red": req.rgb[0], "green": req.rgb[1], "blue": req.rgb[2], "png": rel}

    for item in frame_items:
        item.pop("_slot")
    return {
        "target": {"ra": req.ra, "dec": req.dec, "fov_arcmin": req.fov_arcmin,
                   "pixel_scale_arcsec": spherex.PIXEL_SCALE_ARCSEC, "width_px": shape[1], "height_px": shape[0],
                   "orientation": "north-up, east-left"},
        "query": {"collections": req.collections, "frames_per_group": req.frames_per_group,
                  "epoch_gap_days": req.epoch_gap_days, "cmap": req.cmap},
        "summary": {"images_found": len(found), "frames_selected": len(frames), "frames_rendered": len(frame_items),
                    "epochs": len(epoch_items), "errors": len(errors)},
        "detectors": detectors,
        "epochs": epoch_items,
        "frames": frame_items,
        "false_color": false_color,
        "errors": errors,
    }
