"""Target resolution: Gaia DR3 lookups (through Database/scripts/gaia_api.py) and the 5 challenge benchmark presets."""
from __future__ import annotations

import json
import logging
import math
import re
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass

import numpy as np
import pyvo

from . import image_processor as images
from . import spherex_adapter as spherex

GAIA_DIR = images.CACHE_DIR / "gaia"
GAIA_TAP_URL = "https://gea.esac.esa.int/tap-server/tap"
_GAIA_POOL = ThreadPoolExecutor(max_workers=4, thread_name_prefix="gaia")
logger = logging.getLogger(__name__)
VIEW_EPOCH = 2026.0   # mid-survey epoch: image views of moving targets are centred on this position
GAIA_COLUMNS = ("source_id, designation, ra, dec, ra_error, dec_error, pmra, pmdec, parallax, ref_epoch, "
                "phot_g_mean_mag, phot_bp_mean_mag, phot_rp_mean_mag, ruwe")

# ``frontend_center``: approximate J2000 position the React app (frontend/src/lib/targets.ts) opens the view on.
BENCHMARKS: dict[str, dict] = {
    "barnard": {
        "name": "Barnard's Star",
        "aliases": ["barnard", "barnardsstar", "gj699"],
        "frontend_center": (269.452075, 4.693391),
        "gaia_source_id": 4472832130942575872,
    },
    "epsindib": {
        "name": "Epsilon Indi B",
        "aliases": ["epsilonindib", "epsindib", "epsindiba", "epsilonindiba"],
        "frontend_center": (331.043833, -56.782694),
        "gaia_source_id": 6412596012146801152,
    },
    "wise0855": {
        "name": "WISE 0855-0714",
        "aliases": ["wise0855", "wise08550714", "wisej085510830714442"],
        "frontend_center": (133.795129, -7.245147),
        "gaia_source_id": None,   # too cold/faint for Gaia
        # Challenge coordinates (08h55m10.831s -07d14m42.53s), taken as epoch J2000, with the
        # Luhman & Esplin (2016) proper motion. Not cross-checked against CatWISE yet.
        "fallback": {"ra": 133.795129, "dec": -7.245147, "pmra": -8118.0, "pmdec": 680.0, "ref_epoch": 2000.0,
                     "source": "literature"},
    },
    "rwaur": {
        "name": "RW Aurigae",
        "aliases": ["rwaurigae", "rwaur", "rwaura"],
        "frontend_center": (76.956417, 30.401417),
        "gaia_source_id": 156430817820015232,
    },
    "rdra": {
        "name": "R Draconis",
        "aliases": ["rdraconis", "rdra"],
        "frontend_center": (248.167417, 66.754972),
        "gaia_source_id": 1648328016354496384,
    },
}


@dataclass
class Target:
    ra: float
    dec: float
    pmra: float = 0.0          # mas/yr, includes cos(dec)
    pmdec: float = 0.0         # mas/yr
    ref_epoch: float = 2016.0  # Julian year of (ra, dec)
    source: str = "coordinates"
    name: str | None = None
    preset: str | None = None
    gaia: dict | None = None

    def position_at(self, year: float) -> tuple[float, float]:
        dt = year - self.ref_epoch
        ra = self.ra + self.pmra * dt / 3.6e6 / math.cos(math.radians(self.dec))
        return ra % 360.0, self.dec + self.pmdec * dt / 3.6e6

    def view_center(self) -> tuple[float, float]:
        return self.position_at(VIEW_EPOCH)

    def metadata(self) -> dict:
        ra_view, dec_view = self.view_center()
        return {
            "name": self.name, "preset": self.preset, "source": self.source,
            "ra": self.ra, "dec": self.dec, "pmra_mas_yr": self.pmra, "pmdec_mas_yr": self.pmdec,
            "ref_epoch": self.ref_epoch, "view_epoch": VIEW_EPOCH,
            "ra_view": round(ra_view, 7), "dec_view": round(dec_view, 7), "gaia": self.gaia,
        }


def normalize_name(name: str) -> str:
    return re.sub(r"[^a-z0-9]", "", name.lower())


def find_preset(name: str) -> str | None:
    key = normalize_name(name)
    for preset, info in BENCHMARKS.items():
        if key == preset or key == normalize_name(info["name"]) or key in info["aliases"]:
            return preset
    return None


def _plain(value):
    if value is np.ma.masked:
        return None
    if isinstance(value, bytes):
        return value.decode()
    if isinstance(value, np.generic):
        value = value.item()
    if isinstance(value, float) and not math.isfinite(value):
        return None
    return value


def gaia_query(adql: str, attempts: int = 2, timeout_s: float = 60.0):
    """Run ADQL with the legacy ``gaia_api.ejecutar_adql``; fall back to a synchronous TAP query.

    The ESA archive intermittently answers async jobs with HTTP 500 or stops answering job-phase polls
    (astroquery sets no socket timeout), so each attempt runs in a worker thread with a deadline.
    """
    for _ in range(attempts):
        future = _GAIA_POOL.submit(spherex.gaia_adql, adql)
        try:
            return future.result(timeout=timeout_s)
        except Exception as exc:  # noqa: BLE001 - includes TimeoutError
            logger.warning("Gaia async query failed (%s); retrying", type(exc).__name__)
    logger.warning("Falling back to a synchronous Gaia TAP query")
    return pyvo.dal.TAPService(GAIA_TAP_URL).run_sync(adql).to_table()


def gaia_source(source_id: int) -> dict:
    """One Gaia DR3 ``gaia_source`` row (cached on disk), queried with the legacy ``gaia_api.ejecutar_adql``."""
    path = GAIA_DIR / f"{int(source_id)}.json"
    with images.lock_for(f"gaia-{int(source_id)}"):
        if path.exists():
            return json.loads(path.read_text())
        table = gaia_query(f"SELECT {GAIA_COLUMNS} FROM gaiadr3.gaia_source WHERE source_id = {int(source_id)}")
        if not len(table):
            raise LookupError(f"Gaia DR3 source_id {source_id} not found")
        row = {name: _plain(table[name][0]) for name in table.colnames}
        GAIA_DIR.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(row))
        return row


def from_gaia(source_id: int, name: str | None = None, preset: str | None = None) -> Target:
    row = gaia_source(source_id)
    return Target(ra=row["ra"], dec=row["dec"], pmra=row["pmra"] or 0.0, pmdec=row["pmdec"] or 0.0,
                  ref_epoch=row["ref_epoch"] or 2016.0, source="gaia_dr3", name=name or row.get("designation"),
                  preset=preset, gaia=row)


def resolve(ra: float | None = None, dec: float | None = None, gaia_source_id: int | None = None,
            target_name: str | None = None) -> Target:
    """Target from (in priority order) a benchmark name, a Gaia DR3 source_id, or plain coordinates.

    Raises KeyError for an unknown name and ValueError when nothing usable is given.
    """
    if target_name:
        preset = find_preset(target_name)
        if preset is None:
            raise KeyError(f"unknown target '{target_name}'; presets: {sorted(BENCHMARKS)}")
        info = BENCHMARKS[preset]
        if info["gaia_source_id"]:
            return from_gaia(info["gaia_source_id"], info["name"], preset)
        return Target(**info["fallback"], name=info["name"], preset=preset)
    if gaia_source_id is not None:
        return from_gaia(gaia_source_id)
    if ra is None or dec is None:
        raise ValueError("give ra and dec, gaia_source_id or target_name")
    return Target(ra=ra, dec=dec)


def list_presets() -> list[dict]:
    return [{"id": preset, "name": info["name"], "aliases": info["aliases"],
             "gaia_source_id": str(info["gaia_source_id"]) if info["gaia_source_id"] else None}
            for preset, info in BENCHMARKS.items()]
