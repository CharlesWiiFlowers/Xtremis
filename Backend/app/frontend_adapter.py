"""HTTP contract of the team's React viewer (``frontend/README.md``, ``frontend/src/api/types.ts``).

A thin layer over the cached image and spectrum pipelines; the richer ``/api/sky/*`` routes stay unchanged.
"""
from __future__ import annotations

import hashlib
import json
import logging
import math
import re
import threading
import time
from collections import OrderedDict
from dataclasses import dataclass
from pathlib import Path
from typing import Annotated, Literal

import numpy as np
import pyvo
from astropy.coordinates import SkyCoord
from astropy.io import fits
from astropy.visualization import ZScaleInterval
from astropy.wcs import WCS
from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import FileResponse
from PIL import Image
from reproject import reproject_interp

from . import image_processor as images
from . import spectrum_processor as spectra
from . import spherex_adapter as spherex
from . import targets

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api", tags=["frontend"])

FRONTEND_DIR = images.CACHE_DIR / "frontend"
ADAPTER_VERSION = 1
FIELD_CACHE_SIZE = 6            # aligned frame stacks kept in memory
CLICK_MATCH_ARCSEC = 12.0       # clicks within ~2 SPHEREx pixels of a benchmark target reuse its proper-motion spectrum
FOUND_SNR = 3.0                 # median channel S/N above which a source counts as found
FLAG_MAJORITY = 0.5             # a pixel is drawn as flagged when flagged in at least this fraction of frames
FLAG_RGBA = (255, 64, 160, 170)
DIFF_SCALE = 2.0                # diff images saturate at DIFF_SCALE x the fixed display range
DIFF_NEW_RGB = np.array([0x7C, 0xB7, 0xFF]) / 255   # galaxy blue: new position / brighter
DIFF_OLD_RGB = np.array([0xF2, 0xB4, 0x5F]) / 255   # gold: earlier position / fainter
CATWISE_SCS = "https://irsa.ipac.caltech.edu/SCS?table=catwise_2020"
PRESET_RETRY_S = 600.0
FLUX_UNIT = "µJy"
PNG_HEADERS = {"Cache-Control": "public, max-age=86400"}

Ra = Annotated[float, Query(ge=0, lt=360, description="Right ascension (deg, ICRS)")]
Dec = Annotated[float, Query(ge=-90, le=90, description="Declination (deg, ICRS)")]
Fov = Annotated[float, Query(ge=1, le=60, description="Field of view (arcmin)")]
Det = Annotated[Literal["all", "1", "2", "3", "4", "5", "6"], Query(description="Detector 1-6 or 'all'")]
Mode = Annotated[Literal["animate", "diff", "sum"], Query(description="animate | diff | sum")]
FieldRa = Annotated[float | None, Query(description="Field centre RA (deg); informational")]
FieldDec = Annotated[float | None, Query(description="Field centre Dec (deg); informational")]


def _offset_arcsec(ra0: float, dec0: float, ra: float, dec: float) -> tuple[float, float]:
    """Gnomonic offset (east, north) in arcsec of (ra, dec) from (ra0, dec0), as in frontend/src/lib/coords.ts."""
    a0, d0, a, d = (math.radians(v) for v in (ra0, dec0, ra, dec))
    cosc = math.sin(d0) * math.sin(d) + math.cos(d0) * math.cos(d) * math.cos(a - a0)
    x = math.cos(d) * math.sin(a - a0) / cosc
    y = (math.cos(d0) * math.sin(d) - math.sin(d0) * math.cos(d) * math.cos(a - a0)) / cosc
    return math.degrees(x) * 3600.0, math.degrees(y) * 3600.0


def _sep_arcsec(ra1: float, dec1: float, ra2: float, dec2: float) -> float:
    return math.hypot(*_offset_arcsec(ra1, dec1, ra2, dec2))


def _number(value) -> float | None:
    if value is None or np.ma.is_masked(value):
        return None
    value = float(value)
    return value if math.isfinite(value) else None


# ---------------------------------------------------------------- benchmark targets
_presets: dict[str, targets.Target] = {}
_preset_failures: dict[str, float] = {}
_presets_lock = threading.Lock()


def preset_targets() -> dict[str, targets.Target]:
    """Benchmark targets resolved once (Gaia rows are cached on disk); unreachable ones are retried later."""
    with _presets_lock:
        for preset in targets.BENCHMARKS:
            if preset in _presets or time.time() - _preset_failures.get(preset, 0.0) < PRESET_RETRY_S:
                continue
            try:
                _presets[preset] = targets.resolve(target_name=preset)
            except Exception as exc:  # noqa: BLE001 - a Gaia outage must not break unrelated requests
                logger.warning("could not resolve preset %s: %s", preset, exc)
                _preset_failures[preset] = time.time()
        return dict(_presets)


# ---------------------------------------------------------------- aligned field stacks
@dataclass
class Field:
    key: str
    ra: float
    dec: float
    fov: float
    shape: tuple[int, int]
    frames: list[dict]                                        # detector + pipeline epoch index per layer
    layers: list[tuple[np.ndarray, np.ndarray, np.ndarray]]   # (clean, raw, severe-flag mask) on the field grid
    epochs: list[dict]                                        # frontend ``Epoch`` objects
    epoch_index: dict[str, int]                               # frontend epoch id ('s1') -> pipeline epoch index
    limits: dict[str, tuple[float, float]]                    # fixed display range per detector and 'all'


_fields: OrderedDict[str, Field] = OrderedDict()
_fields_lock = threading.Lock()


def _load_layers(path: Path, wcs: WCS, shape: tuple[int, int]) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    clean, raw = images.load_frame(path, wcs, shape)
    with fits.open(path) as hdul:
        frame_wcs = WCS(hdul["IMAGE"].header, naxis=2)
        if "FLAGS" in hdul:
            bad = ((hdul["FLAGS"].data.astype(np.int64) & spherex.SEVERE_FLAG_BITS) != 0).astype(float)
        else:
            bad = np.zeros(hdul["IMAGE"].data.shape)
    mask, footprint = reproject_interp((bad, frame_wcs), wcs, shape_out=shape, order="nearest-neighbor")
    mask[footprint == 0] = np.nan
    return clean, raw, mask


def _zscale(data: np.ndarray | None) -> tuple[float, float]:
    finite = data[np.isfinite(data)] if data is not None else np.array([])
    if not finite.size:
        return 0.0, 1.0
    lo, hi = (float(v) for v in ZScaleInterval().get_limits(finite))
    return lo, hi if hi > lo else lo + 1e-9


def _detector_image(field: Field, det: str, epochs: set[int]) -> np.ndarray | None:
    return images.coadd([(c, r) for f, (c, r, _) in zip(field.frames, field.layers)
                         if f["detector"] == det and f["epoch"] in epochs])


def _combined_image(field: Field, epochs: set[int]) -> np.ndarray | None:
    """All detectors together: each detector coadd scaled by its own display range, then averaged."""
    parts = []
    for det in images.DETECTORS:
        img = _detector_image(field, det, epochs)
        if img is not None and det in field.limits:
            lo, hi = field.limits[det]
            parts.append((img - lo) / (hi - lo))
    if not parts:
        return None
    cube = np.stack(parts)
    count = np.isfinite(cube).sum(axis=0)
    return np.where(count > 0, np.nansum(cube, axis=0) / np.maximum(count, 1), np.nan)


def _image(field: Field, det: str, epochs: set[int]) -> np.ndarray | None:
    return _combined_image(field, epochs) if det == "all" else _detector_image(field, f"D{det}", epochs)


def _field_key(ra: float, dec: float, fov: float) -> str:
    return hashlib.sha1(json.dumps([round(ra, 6), round(dec, 6), round(fov, 3), ADAPTER_VERSION]).encode()).hexdigest()[:16]


def field_meta(ra: float, dec: float, fov: float) -> dict:
    """Survey epochs of a view (``key``, ``epochs``, ``epoch_index``), cached on disk."""
    key = _field_key(ra, dec, fov)
    path = FRONTEND_DIR / "fields" / f"{key}.json"
    with images.lock_for(f"meta-{key}"):
        if path.exists():
            return json.loads(path.read_text())
        try:
            result = images.build_sky_images(images.ImageRequest(ra=ra, dec=dec, fov_arcmin=fov))
            found = images.search_frames(ra, dec, list(spherex.DEFAULT_COLLECTIONS))
        except Exception as exc:
            logger.exception("field metadata failed")
            raise HTTPException(502, f"SPHEREx upstream error: {exc}") from exc
        images.assign_epochs(found, images.ImageRequest.epoch_gap_days)
        exposures: dict[int, set[str]] = {}
        for f in found:
            exposures.setdefault(f["epoch"], set()).add(f["obs_id"])
        epochs, epoch_index = [], {}
        for n, ep in enumerate(result["epochs"], start=1):
            epoch_id = f"s{n}"
            epoch_index[epoch_id] = ep["index"]
            epochs.append({
                "id": epoch_id, "index": n,
                "start": images.mjd_to_iso(ep["mjd_start"])[:10],
                "end": images.mjd_to_iso(ep["mjd_end"])[:10],
                "mid": images.mjd_to_iso((ep["mjd_start"] + ep["mjd_end"]) / 2)[:10],
                "nExposures": len(exposures.get(ep["index"], ())),
                "detectors": sorted({f["detector"][1:] for f in result["frames"] if f["epoch"] == ep["index"]}),
            })
        meta = {"key": key, "epochs": epochs, "epoch_index": epoch_index, "frames": result["frames"]}
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(meta))
        return meta


def _build_field(ra: float, dec: float, fov: float, meta: dict) -> Field:
    found = images.search_frames(ra, dec, list(spherex.DEFAULT_COLLECTIONS))
    by_did = {f["obs_publisher_did"]: f for f in found}
    fov_deg = fov / 60.0
    wcs, shape = images.target_wcs(ra, dec, fov_deg)

    frames, layers = [], []
    for item in meta["frames"]:
        frame = by_did.get(item["obs_publisher_did"])
        if frame is None:
            continue
        try:
            layers.append(_load_layers(images.fetch_cutout(frame, ra, dec, fov_deg), wcs, shape))
            frames.append({"detector": item["detector"], "epoch": item["epoch"]})
        except Exception as exc:  # noqa: BLE001 - one bad frame must not break the view
            logger.warning("frame %s skipped: %s", item["obs_publisher_did"], exc)

    field = Field(meta["key"], ra, dec, fov, shape, frames, layers, meta["epochs"], meta["epoch_index"], {})
    every = set(field.epoch_index.values())
    for det in images.DETECTORS:
        img = _detector_image(field, det, every)
        if img is not None:
            field.limits[det] = _zscale(img)
    field.limits["all"] = _zscale(_combined_image(field, every))
    return field


def get_field(ra: float, dec: float, fov: float) -> Field:
    meta = field_meta(ra, dec, fov)
    key = meta["key"]
    with images.lock_for(f"field-{key}"):
        with _fields_lock:
            if key in _fields:
                _fields.move_to_end(key)
                return _fields[key]
        try:
            field = _build_field(ra, dec, fov, meta)
        except Exception as exc:
            logger.exception("field build failed")
            raise HTTPException(502, f"SPHEREx upstream error: {exc}") from exc
        with _fields_lock:
            _fields[key] = field
            while len(_fields) > FIELD_CACHE_SIZE:
                _fields.popitem(last=False)
        return field


def _parse_epochs(epoch_index: dict[str, int], value: str) -> set[int]:
    if value.strip() == "all":
        return set(epoch_index.values())
    ids = [v.strip() for v in value.split(",") if v.strip()]
    unknown = [v for v in ids if v not in epoch_index]
    if unknown or not ids:
        raise HTTPException(422, f"unknown epoch(s) {unknown or value!r}; available: {sorted(epoch_index)}")
    return {epoch_index[v] for v in ids}


# ---------------------------------------------------------------- PNG rendering
def _save_rgba(rgba: np.ndarray, path: Path) -> None:
    img = Image.fromarray(np.flipud(rgba), mode="RGBA")
    factor = max(1, math.ceil(images.MIN_PNG_SIZE_PX / max(img.size)))
    if factor > 1:
        img = img.resize((img.width * factor, img.height * factor), Image.Resampling.NEAREST)
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, optimize=True)


def _render_frame(field: Field, det: str, epochs: set[int], mode: str, ref: set[int], path: Path) -> None:
    lo, hi = field.limits.get("all" if det == "all" else f"D{det}", (0.0, 1.0))
    current = _image(field, det, epochs)
    if current is None:
        rgb = np.zeros((*field.shape, 3))
    elif mode == "diff":
        reference = _image(field, det, ref)
        diff = np.nan_to_num(current - reference) if reference is not None else np.zeros_like(current)
        scale = DIFF_SCALE * (hi - lo)
        rgb = (np.clip(diff / scale, 0, 1)[..., None] * DIFF_NEW_RGB
               + np.clip(-diff / scale, 0, 1)[..., None] * DIFF_OLD_RGB)
    else:
        data = images.fill_holes(current, hi)
        rgb = np.repeat(np.nan_to_num(np.clip((data - lo) / (hi - lo), 0, 1))[..., None], 3, axis=2)
    images.save_png(np.clip(rgb, 0, 1), path)


def _render_flags(field: Field, det: str, epochs: set[int], path: Path) -> None:
    masks = [m for f, (_, _, m) in zip(field.frames, field.layers)
             if f["epoch"] in epochs and (det == "all" or f["detector"] == f"D{det}")]
    rgba = np.zeros((*field.shape, 4), dtype=np.uint8)
    if masks:
        cube = np.stack(masks)
        count = np.isfinite(cube).sum(axis=0)
        fraction = np.nansum(cube, axis=0) / np.maximum(count, 1)
        rgba[(count > 0) & (fraction >= FLAG_MAJORITY)] = FLAG_RGBA
    _save_rgba(rgba, path)


def frame_png(ra: float, dec: float, fov: float, det: str, epoch: str, mode: str, ref: str | None,
              kind: Literal["frame", "flags"] = "frame") -> Path:
    meta = field_meta(ra, dec, fov)
    index = meta["epoch_index"]
    epochs = _parse_epochs(index, "all" if mode == "sum" else epoch)
    first = {min(index.values())} if index else set()
    reference = (_parse_epochs(index, ref) if ref else first) if mode == "diff" and kind == "frame" else set()
    name = hashlib.sha1(json.dumps([meta["key"], kind, det, sorted(epochs), mode if kind == "frame" else "",
                                    sorted(reference), ADAPTER_VERSION]).encode()).hexdigest()[:20]
    path = FRONTEND_DIR / kind / f"{name}.png"
    if path.exists():
        return path
    field = get_field(ra, dec, fov)
    with images.lock_for(str(path)):
        if not path.exists():
            if kind == "flags":
                _render_flags(field, det, epochs, path)
            else:
                _render_frame(field, det, epochs, mode, reference, path)
    return path


def year_groups(epochs: list[dict]) -> list[str]:
    """``epoch`` parameters the viewer sends for its default by-year timeline (frontend/src/lib/frames.ts)."""
    by_year: dict[str, list[str]] = {}
    for e in epochs:
        by_year.setdefault(e["mid"][:4], []).append(e["id"])
    return [",".join(ids) for _, ids in sorted(by_year.items())]


def warm_view(ra: float, dec: float, fov: float) -> int:
    """Pre-render the PNGs the viewer requests first (all detectors; by year and by survey). Returns the count."""
    meta = field_meta(ra, dec, fov)
    count = 0
    for groups in (year_groups(meta["epochs"]), [e["id"] for e in meta["epochs"]]):
        if not groups:
            continue
        for epoch in groups:
            for mode in ("animate", "diff"):
                frame_png(ra, dec, fov, "all", epoch, mode, groups[0] if mode == "diff" else None)
                count += 1
    frame_png(ra, dec, fov, "all", "all", "sum", None)
    return count + 1


# ---------------------------------------------------------------- spectra and light curves
def _point_request(ra: float, dec: float) -> tuple[spectra.SpectrumRequest, str | None]:
    best = None
    for preset, target in preset_targets().items():
        sep = _sep_arcsec(ra, dec, *target.view_center())
        if sep <= CLICK_MATCH_ARCSEC and (best is None or sep < best[0]):
            best = (sep, preset, target)
    if best is None:
        return spectra.SpectrumRequest(ra=ra, dec=dec), None
    target = best[2]
    return spectra.SpectrumRequest(ra=target.ra, dec=target.dec, pmra=target.pmra, pmdec=target.pmdec,
                                   ref_epoch=target.ref_epoch), best[1]


def point_spectrum(ra: float, dec: float) -> tuple[dict, str | None]:
    req, preset = _point_request(ra, dec)
    try:
        return spectra.build_spectrum(req), preset
    except Exception as exc:
        logger.exception("spectrum failed")
        raise HTTPException(502, f"SPHEREx upstream error: {exc}") from exc


def _channels(result: dict, det: str) -> list[dict]:
    return [c for c in result["channels_102"]
            if c["flux_ujy"] is not None and (det == "all" or c["detector"] == f"D{det}")]


def _found(channels: list[dict]) -> bool:
    snr = [c["flux_ujy"] / c["flux_err_ujy"] for c in channels if c["flux_err_ujy"]]
    return bool(snr) and float(np.median(snr)) >= FOUND_SNR


def _preset_name(preset: str | None) -> str | None:
    return targets.BENCHMARKS[preset]["name"] if preset else None


# ---------------------------------------------------------------- routes
@router.get("/resolve")
def resolve(name: Annotated[str, Query(min_length=1, description="Object name or Gaia DR3 source_id")]):
    gaia_id = re.fullmatch(r"\s*(?:gaia\s*(?:dr3)?\s*)?(\d{6,20})\s*", name, re.IGNORECASE)
    try:
        if targets.find_preset(name):
            target = targets.resolve(target_name=name)
        elif gaia_id:
            target = targets.from_gaia(int(gaia_id.group(1)))
        else:
            target = None
    except LookupError as exc:
        raise HTTPException(404, str(exc.args[0])) from exc
    except Exception as exc:
        raise HTTPException(502, f"Gaia archive error: {exc}") from exc
    if target is not None:
        ra, dec = target.view_center()
        return {"name": target.name, "ra": round(ra, 7), "dec": round(dec, 7), "source": target.source,
                "position_epoch": targets.VIEW_EPOCH, "pmra_mas_yr": target.pmra, "pmdec_mas_yr": target.pmdec,
                "gaia_source_id": str(target.gaia["source_id"]) if target.gaia else None}
    try:
        coord = SkyCoord.from_name(name)
    except Exception as exc:
        raise HTTPException(404, f"could not resolve '{name}'") from exc
    return {"name": name.strip(), "ra": round(float(coord.ra.deg), 7), "dec": round(float(coord.dec.deg), 7),
            "source": "sesame", "position_epoch": 2000.0, "pmra_mas_yr": None, "pmdec_mas_yr": None,
            "gaia_source_id": None}


@router.get("/epochs")
def epochs(ra: Ra, dec: Dec, fov: Fov = 10.0):
    return field_meta(ra, dec, fov)["epochs"]


@router.get("/frame", response_class=FileResponse)
def frame(ra: Ra, dec: Dec, fov: Fov = 10.0, det: Det = "all",
          epoch: Annotated[str, Query(description="Survey id(s), comma separated ('s2,s3'), or 'all'")] = "all",
          mode: Mode = "animate",
          ref: Annotated[str | None, Query(description="mode=diff: reference survey id(s)")] = None):
    return FileResponse(frame_png(ra, dec, fov, det, epoch, mode, ref), media_type="image/png", headers=PNG_HEADERS)


@router.get("/flags", response_class=FileResponse)
def flags(ra: Ra, dec: Dec, fov: Fov = 10.0, det: Det = "all", epoch: str = "all", mode: Mode = "animate",
          ref: str | None = None):
    path = frame_png(ra, dec, fov, det, epoch, mode, ref, kind="flags")
    return FileResponse(path, media_type="image/png", headers=PNG_HEADERS)


_flag_definitions: dict | None = None


@router.get("/flags/definitions")
def flag_definitions():
    """SPHEREx FLAGS bit planes, read from the MSKN/MSKM/MSKD header cards of a cached cutout."""
    global _flag_definitions
    if _flag_definitions is None:
        path = next(images.CUTOUT_DIR.glob("*/*.fits"), None)
        if path is None:
            raise HTTPException(503, "no cached SPHEREx cutout yet; request an image first")
        header = fits.getheader(path, "FLAGS")
        bits = sorted(int(k[4:]) for k in header if k.startswith("MSKN"))
        _flag_definitions = {
            "severe_mask": spherex.SEVERE_FLAG_BITS,
            "overlay_rule": f"pixel drawn when a severe bit is set in >= {FLAG_MAJORITY:.0%} of the stacked frames",
            "bits": [{"bit": b, "mask": 1 << b, "name": header[f"MSKN{b:04d}"],
                      "description": header.get(f"MSKD{b:04d}", ""),
                      "severe": bool(spherex.SEVERE_FLAG_BITS & (1 << b))} for b in bits],
        }
    return _flag_definitions


def _gaia_rows(ra: float, dec: float, radius: float) -> list[dict]:
    table = targets.gaia_query(
        "SELECT TOP 5000 source_id, ra, dec, phot_g_mean_mag FROM gaiadr3.gaia_source WHERE 1 = CONTAINS("
        f"POINT('ICRS', ra, dec), CIRCLE('ICRS', {ra}, {dec}, {radius})) ORDER BY phot_g_mean_mag")
    return [{"ra": float(r["ra"]), "dec": float(r["dec"]), "id": f"Gaia DR3 {int(r['source_id'])}",
             "mag": _number(r["phot_g_mean_mag"])} for r in table]


def _wise_rows(ra: float, dec: float, radius: float) -> list[dict]:
    table = spherex.retry(lambda: pyvo.dal.SCSService(CATWISE_SCS).search(pos=(ra, dec), radius=radius).to_table(),
                          4, 5)
    return [{"ra": float(r["ra"]), "dec": float(r["dec"]), "id": f"CatWISE {r['source_name']}",
             "mag": _number(r["w2mpro"])} for r in table]


@router.get("/catalog")
def catalog(ra: Ra, dec: Dec, fov: Fov = 10.0,
            cat: Annotated[Literal["gaia", "wise"], Query(description="gaia (DR3, epoch 2016) | wise (CatWISE2020)")]
            = "gaia"):
    radius = fov / 60.0 / 2.0 * math.sqrt(2.0)
    key = hashlib.sha1(json.dumps([cat, round(ra, 6), round(dec, 6), round(fov, 3)]).encode()).hexdigest()[:16]
    path = FRONTEND_DIR / "catalog" / f"{key}.json"
    with images.lock_for(str(path)):
        if path.exists():
            rows = json.loads(path.read_text())
        else:
            try:
                rows = _gaia_rows(ra, dec, radius) if cat == "gaia" else _wise_rows(ra, dec, radius)
            except Exception as exc:
                logger.exception("catalog query failed")
                raise HTTPException(502, f"{cat} catalog error: {exc}") from exc
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(json.dumps(rows))
    half = fov * 30.0
    return [r for r in rows if max(abs(v) for v in _offset_arcsec(ra, dec, r["ra"], r["dec"])) <= half]


@router.get("/spectrum")
def spectrum(ra: Ra, dec: Dec, det: Det = "all", fra: FieldRa = None, fdec: FieldDec = None):
    result, preset = point_spectrum(ra, dec)
    channels = _channels(result, det)
    return {
        "found": _found(channels), "unit": FLUX_UNIT,
        "points": [{"wavelength": c["wavelength_um"], "flux": c["flux_ujy"], "err": c["flux_err_ujy"] or 0.0,
                    "channel": c["channel"], "detector": c["detector"], "flagged": c["quality"] != "good"}
                   for c in channels],
        "target": _preset_name(preset), "cached": result["cached"],
    }


@router.get("/lightcurve")
def lightcurve(ra: Ra, dec: Dec, det: Det = "all", fra: FieldRa = None, fdec: FieldDec = None):
    """Flux per observing day. For a detected source each measurement is divided by its channel's mean flux,
    so all wavelengths share one scale (1 = average spectrum); otherwise raw µJy are averaged."""
    result, preset = point_spectrum(ra, dec)
    channels = {c["channel"]: c for c in _channels(result, det)}
    rows = [m for m in result["raw_measurements"] if m["flux_ujy"] is not None and m["flux_err_ujy"]
            and (det == "all" or m["detector"] == f"D{det}")]
    rows = [m for m in rows if not m["bad_flag"]] or rows
    found = _found(list(channels.values()))
    samples = []
    for m in rows:
        if not found:
            samples.append((m, m["flux_ujy"], m["flux_err_ujy"]))
            continue
        ch = channels.get(m["channel"])
        if ch and ch["flux_err_ujy"] and abs(ch["flux_ujy"]) > FOUND_SNR * ch["flux_err_ujy"]:
            samples.append((m, m["flux_ujy"] / ch["flux_ujy"], m["flux_err_ujy"] / abs(ch["flux_ujy"])))
    by_day: dict[str, list] = {}
    for m, flux, err in samples:
        by_day.setdefault(m["date_utc"][:10], []).append((m["mjd"], flux, err))
    points = []
    for day in sorted(by_day):
        mjd, flux, err = (np.array(v, dtype=float) for v in zip(*by_day[day]))
        weight = 1.0 / err**2
        points.append({"date": day, "mjd": round(float(mjd.mean()), 5),
                       "flux": float((weight * flux).sum() / weight.sum()), "err": float(weight.sum() ** -0.5),
                       "n": len(flux)})
    return {"found": found, "unit": "relative" if found else FLUX_UNIT, "points": points,
            "target": _preset_name(preset), "cached": result["cached"]}
