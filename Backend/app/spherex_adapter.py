"""Single entry point to the SPHEREx query logic in Database/scripts/spherex_api.py.

The legacy scripts import each other with flat names (``comun``, ``gaia_api``) and mutate
global state on import (``sys.path``, astropy log level, warning filters). This module loads
them under a private ``xtremis_db`` namespace and restores that global state afterwards, so the
rest of the backend never sees those names.
"""
import importlib.util
import logging
import sys
import types
import warnings
from pathlib import Path

from astropy import log as astropy_log

SCRIPTS_DIR = Path(__file__).resolve().parents[2] / "Database" / "scripts"
_NAMESPACE = "xtremis_db"
_FLAT_NAMES = ("comun", "gaia_api")


def _load(name: str, flat_name: str) -> types.ModuleType:
    spec = importlib.util.spec_from_file_location(f"{_NAMESPACE}.{name}", SCRIPTS_DIR / f"{flat_name}.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def _load_legacy_modules():
    saved_path = list(sys.path)
    saved_filters = list(warnings.filters)
    saved_log_level = astropy_log.level
    saved_flat = {n: sys.modules.get(n) for n in _FLAT_NAMES}
    sys.modules.setdefault(_NAMESPACE, types.ModuleType(_NAMESPACE))
    try:
        common = _load("common", "comun")
        sys.modules["comun"] = common
        gaia = _load("gaia_api", "gaia_api")
        sys.modules["gaia_api"] = gaia
        spherex = _load("spherex_api", "spherex_api")
    finally:
        for name, previous in saved_flat.items():
            if previous is None:
                sys.modules.pop(name, None)
            else:
                sys.modules[name] = previous
        sys.path[:] = saved_path
        warnings.filters[:] = saved_filters
        astropy_log.setLevel(saved_log_level)
    return common, gaia, spherex


_common, _gaia, _spherex = _load_legacy_modules()
logger = logging.getLogger(__name__)

# Constants
COLLECTIONS = list(_common.COLECCIONES_SPHEREX)
DEFAULT_COLLECTIONS = ["spherex_dr1", "spherex_qr3"]
S3_BUCKET = _common.S3_BUCKET
IMAGE_COLUMNS = list(_spherex.COLUMNAS_IMAGENES)
PIXEL_SOLID_ANGLE_SR = _spherex.OMEGA_PIXEL_SR
SEVERE_FLAG_BITS = _spherex.BITS_GRAVES
PIXEL_SCALE_ARCSEC = 6.15

# Reused functions (thin English aliases, original behaviour unchanged)
open_fits = _spherex.abrir_fits                 # (image_row) -> HDUList read lazily from S3 / IRSA
photometry = _spherex.fotometria                # (image_row, sources, r_ap, r_in, r_out) -> list[dict]
_download = _spherex.descargar                  # (url, intentos=5) -> bytes
_search_images = _spherex.buscar_imagenes       # (ra, dec, radio, colecciones, banda, tiempo, maxrec) -> Table


def search_images(ra: float, dec: float, radius_deg: float, collections=None, band=None, time=None, maxrec=None):
    """SIA2 search for SPHEREx spectral images covering a position. Returns an astropy Table."""
    return _search_images(ra, dec, radius_deg, collections or DEFAULT_COLLECTIONS, band, time, maxrec)


def download(url: str, attempts: int = 5) -> bytes:
    """HTTP GET with retries on IRSA's intermittent 429/5xx responses."""
    return _download(url, attempts)


def cutout_url(access_url: str, ra: float, dec: float, size_deg: float) -> str:
    """IRSA cutout URL for a SPHEREx image (same convention as ``spherex_api.recortes``)."""
    return f"{str(access_url).split('?')[0]}?center={ra},{dec}&size={size_deg}"
