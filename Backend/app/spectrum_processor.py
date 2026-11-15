"""On-the-fly 102-channel SPHEREx spectrum at a sky position.

Every SPHEREx frame covering the position is measured with the legacy ``fotometria`` aperture
photometry (through spherex_adapter) on a cached IRSA cutout. The measurements are then binned
into the 102 official spectral channels (6 detectors x 17 channels, 0.75-5.0 um), overall and per epoch.
"""
from __future__ import annotations

import hashlib
import json
import logging
import math
import time
from collections import Counter, defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np

from . import image_processor as images
from . import offline
from . import spherex_adapter as spherex

logger = logging.getLogger(__name__)

SPECTRUM_DIR = images.CACHE_DIR / "spectra"
SPECTRUM_VERSION = 1
CHANNELS: list[dict] = json.loads((Path(__file__).with_name("data") / "spectral_channels.json").read_text())["channels"]
CHANNELS_BY_DETECTOR: dict[str, list[dict]] = defaultdict(list)
for _channel in CHANNELS:
    CHANNELS_BY_DETECTOR[_channel["detector"]].append(_channel)
CHANNEL_WAVELENGTH = {c["channel"]: c["wavelength_um"] for c in CHANNELS}

DEFAULT_R_AP_PIX = 2.0           # same defaults as `spherex_api.py espectro`
DEFAULT_ANNULUS_PIX = (4.0, 7.0)
CUTOUT_SIZE_ARCMIN = 3.0         # size of cutouts fetched when no cached cutout covers the position
GAIA_EPOCH = 2016.0              # epoch expected by fotometria for proper-motion propagation
SEARCH_EPOCH = 2026.0            # mid-survey epoch, only used to pick the covering frames
MJD_J2000 = 51544.5


def mjd_to_year(mjd: float) -> float:
    return 2000.0 + (mjd - MJD_J2000) / 365.25


@dataclass
class SpectrumRequest:
    ra: float
    dec: float
    r_ap: float = DEFAULT_R_AP_PIX
    r_in: float = DEFAULT_ANNULUS_PIX[0]
    r_out: float = DEFAULT_ANNULUS_PIX[1]
    pmra: float = 0.0                # mas/yr, includes cos(dec)
    pmdec: float = 0.0               # mas/yr
    ref_epoch: float = GAIA_EPOCH    # Julian year of (ra, dec)
    epoch_gap_days: float = 45.0
    collections: list[str] = field(default_factory=lambda: list(spherex.DEFAULT_COLLECTIONS))

    def position_at(self, year: float) -> tuple[float, float]:
        """Linear proper-motion propagation of (ra, dec) from ``ref_epoch`` to ``year``."""
        dt = year - self.ref_epoch
        ra = self.ra + self.pmra * dt / 3.6e6 / math.cos(math.radians(self.dec))
        return ra % 360.0, self.dec + self.pmdec * dt / 3.6e6

    def key(self) -> str:
        payload = json.dumps([SPECTRUM_VERSION, round(self.ra, 6), round(self.dec, 6), self.r_ap, self.r_in,
                              self.r_out, self.pmra, self.pmdec, self.ref_epoch, self.epoch_gap_days,
                              sorted(self.collections)])
        return hashlib.sha1(payload.encode()).hexdigest()[:16]


def assign_channel(detector: str, wavelength_um: float | None) -> int | None:
    """Closest of the detector's 17 channels, if the wavelength falls within (or half a bandwidth of) it."""
    if wavelength_um is None:
        return None
    best = None
    for ch in CHANNELS_BY_DETECTOR.get(detector, ()):
        half = ch["bandwidth_um"] / 2
        if ch["wavelength_min_um"] - half <= wavelength_um <= ch["wavelength_max_um"] + half:
            distance = abs(wavelength_um - ch["wavelength_um"])
            if best is None or distance < best[0]:
                best = (distance, ch["channel"])
    return best[1] if best else None


def _finite(value) -> float | None:
    value = float(value)
    return value if math.isfinite(value) else None


def _to_measurement(frame: dict, row: dict) -> dict:
    detector = f"D{row['detector']}" if row.get("detector") else frame["detector"]
    wavelength = _finite(row["longitud_onda_um"])
    return {
        "obs_id": frame["obs_id"],
        "obs_publisher_did": frame["obs_publisher_did"],
        "collection": frame["collection"],
        "detector": detector,
        "channel": assign_channel(detector, wavelength),
        "epoch": None,
        "mjd": round(float(row["mjd"]), 6),
        "date_utc": images.mjd_to_iso(float(row["mjd"])),
        "ra": _finite(row["ra_epoca"]),
        "dec": _finite(row["dec_epoca"]),
        "x_pix": _finite(row["x_pix"]),
        "y_pix": _finite(row["y_pix"]),
        "wavelength_um": wavelength,
        "bandwidth_um": _finite(row["ancho_banda_um"]),
        "flux_ujy": _finite(row["flujo_ujy"]),
        "flux_err_ujy": _finite(row["error_flujo_ujy"]),
        "peak_mjy_sr": _finite(row["brillo_pico_mjy_sr"]),
        "background_mjy_sr": _finite(row["fondo_mjy_sr"]),
        "zodi_mjy_sr": _finite(row["zodi_mjy_sr"]),
        "aperture_radius_pix": float(row["radio_apertura_pix"]),
        "flags": int(row["flags"]),
        "bad_flag": bool(row["flag_malo"]),
    }


def measure_frame(frame: dict, req: SpectrumRequest, margin_px: int, size_deg: float) -> list[dict]:
    """Aperture photometry of the target in one frame, reusing any cached cutout that covers it."""
    ra, dec = req.position_at(mjd_to_year((frame["mjd_start"] + frame["mjd_end"]) / 2))
    path = images.find_cached_cutout(frame, ra, dec, margin_px)
    if path is None:
        path = images.fetch_cutout(frame, round(ra, 5), round(dec, 5), size_deg)
    image_row = {
        "access_url": str(path),
        "cloud_access": None,   # makes abrir_fits read the local cutout
        "t_min": frame["mjd_start"],
        "t_max": frame["mjd_end"],
        "obs_publisher_did": frame["obs_publisher_did"],
        "obs_collection": frame["collection"],
    }
    ra16, dec16 = req.position_at(GAIA_EPOCH)
    source = {"source_id": None, "ra": ra16, "dec": dec16, "pmra": req.pmra, "pmdec": req.pmdec}
    rows = spherex.photometry(image_row, [source], req.r_ap, req.r_in, req.r_out)
    return [_to_measurement(frame, row) for row in rows]


def combine(measurements: list[dict]) -> dict:
    """Inverse-variance mean of the unflagged measurements (falls back to flagged ones if that is all there is)."""
    usable = [m for m in measurements if m["flux_ujy"] is not None and (m["flux_err_ujy"] or 0) > 0]
    good = [m for m in usable if not m["bad_flag"]]
    use = good or usable
    stats = {"n_measurements": len(measurements), "n_good": len(good)}
    if not use:
        return {"flux_ujy": None, "flux_err_ujy": None, "flux_std_ujy": None, **stats, "quality": "empty"}
    flux = np.array([m["flux_ujy"] for m in use])
    weight = 1.0 / np.array([m["flux_err_ujy"] for m in use]) ** 2
    return {
        "flux_ujy": float(np.sum(weight * flux) / np.sum(weight)),
        "flux_err_ujy": float(1.0 / np.sqrt(np.sum(weight))),
        "flux_std_ujy": float(np.std(flux, ddof=1)) if len(flux) > 1 else None,
        **stats,
        "quality": "good" if good else "flagged",
    }


def bin_channels(measurements: list[dict]) -> list[dict]:
    by_channel: dict[int, list[dict]] = defaultdict(list)
    for m in measurements:
        if m["channel"] is not None:
            by_channel[m["channel"]].append(m)
    return [{**ch, **combine(by_channel[ch["channel"]])} for ch in CHANNELS]


def epoch_breakdown(measurements: list[dict], gap_days: float) -> list[dict]:
    """Group measurements into survey epochs and bin each epoch separately (only non-empty channels)."""
    stamps = [{"mjd_start": m["mjd"], "mjd_end": m["mjd"], "measurement": m} for m in measurements]
    epochs = images.assign_epochs(stamps, gap_days)
    for stamp in stamps:
        stamp["measurement"]["epoch"] = stamp["epoch"]
    result = []
    for epoch in epochs:
        members = [m for m in measurements if m["epoch"] == epoch["index"]]
        channels = [
            {"channel": ch["channel"], "detector": ch["detector"], "wavelength_um": ch["wavelength_um"], **ch_stats}
            for ch, ch_stats in ((c, combine([m for m in members if m["channel"] == c["channel"]])) for c in CHANNELS)
            if ch_stats["n_measurements"]
        ]
        result.append({
            "index": epoch["index"],
            "mjd_start": epoch["mjd_start"],
            "mjd_end": epoch["mjd_end"],
            "date_start": images.mjd_to_iso(epoch["mjd_start"]),
            "date_end": images.mjd_to_iso(epoch["mjd_end"]),
            "n_measurements": len(members),
            "channels": channels,
        })
    return result


def build_spectrum(req: SpectrumRequest) -> dict:
    """Compute (or load from cache) the spectrum JSON for one request."""
    key = req.key()
    path = SPECTRUM_DIR / f"{key}.json"
    with images.lock_for(f"spectrum-{key}"):
        if path.exists():
            return {**json.loads(path.read_text()), "cached": True}
        started = time.time()
        result = _compute(req)
        offline.check_complete(len(result["errors"]), result["summary"]["frames_found"], "spectrum")
        result["elapsed_s"] = round(time.time() - started, 2)
        SPECTRUM_DIR.mkdir(parents=True, exist_ok=True)
        tmp = path.with_suffix(".tmp")
        tmp.write_text(json.dumps(result))
        tmp.replace(path)
        return {**result, "cached": False}


def _compute(req: SpectrumRequest) -> dict:
    frames = images.search_frames(*req.position_at(SEARCH_EPOCH), req.collections)
    margin_px = math.ceil(req.r_out) + 2
    size_deg = CUTOUT_SIZE_ARCMIN / 60.0
    measurements: list[dict] = []
    errors: list[dict] = []
    outside = 0
    with ThreadPoolExecutor(images.DOWNLOAD_WORKERS) as pool:
        jobs = {pool.submit(measure_frame, f, req, margin_px, size_deg): f for f in frames}
        for job in as_completed(jobs):
            frame = jobs[job]
            try:
                rows = job.result()
            except Exception as exc:  # noqa: BLE001 - one bad frame must not break the whole spectrum
                logger.warning("spectrum: frame %s failed: %s", frame["obs_id"], exc)
                errors.append({"obs_id": frame["obs_id"], "detector": frame["detector"], "error": str(exc)})
                continue
            outside += not rows
            measurements += rows
    measurements.sort(key=lambda m: (m["wavelength_um"] is None, m["wavelength_um"] or 0.0, m["mjd"]))
    epochs = epoch_breakdown(measurements, req.epoch_gap_days)
    channels = bin_channels(measurements)

    wavelengths = [m["wavelength_um"] for m in measurements if m["wavelength_um"] is not None]
    ra16, dec16 = req.position_at(GAIA_EPOCH)
    return {
        "target": {
            "ra": req.ra, "dec": req.dec, "ref_epoch": req.ref_epoch,
            "pmra_mas_yr": req.pmra, "pmdec_mas_yr": req.pmdec,
            "ra_j2016": round(ra16, 7), "dec_j2016": round(dec16, 7),
        },
        "query": {
            "aperture_radius_pix": req.r_ap,
            "background_annulus_pix": [req.r_in, req.r_out],
            "pixel_scale_arcsec": spherex.PIXEL_SCALE_ARCSEC,
            "cutout_size_arcmin": CUTOUT_SIZE_ARCMIN,
            "epoch_gap_days": req.epoch_gap_days,
            "collections": req.collections,
            "units": {"wavelength": "um", "flux": "uJy", "surface_brightness": "MJy/sr"},
        },
        "summary": {
            "frames_found": len(frames),
            "frames_measured": len(frames) - len(errors) - outside,
            "frames_off_edge": outside,
            "measurements": len(measurements),
            "good_measurements": sum(not m["bad_flag"] for m in measurements),
            "channels_total": len(CHANNELS),
            "channels_filled": sum(c["quality"] != "empty" for c in channels),
            "channels_good": sum(c["quality"] == "good" for c in channels),
            "wavelength_min_um": min(wavelengths, default=None),
            "wavelength_max_um": max(wavelengths, default=None),
            "measurements_per_detector": dict(sorted(Counter(m["detector"] for m in measurements).items())),
            "epochs": len(epochs),
            "errors": len(errors),
        },
        "channels_102": channels,
        "epochs": epochs,
        "raw_measurements": measurements,
        "errors": errors,
    }
