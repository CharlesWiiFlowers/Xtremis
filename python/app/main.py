"""API FastAPI para consultas rápidas y cacheadas a archivos astronómicos oficiales."""
from __future__ import annotations

from fastapi import FastAPI, HTTPException, Query
import math
import threading
import time

from requests import Timeout as RequestsTimeout

from . import upstream
from .db import log_ingest, upsert_many, ensure_schema_updates

app = FastAPI(title="ORBITAL Astro Data API", version="2.0.0")
CACHE_TTL = {"gaia": 600, "wise": 600, "spherex": 1800}
_cache: dict[str, tuple[float, list[dict]]] = {}
_cache_lock = threading.RLock()
_cache_stats = {"hits": 0, "misses": 0}
_inflight: dict[str, dict] = {}


@app.on_event("startup")
def migrate_gaia_schema():
    try:
        ensure_schema_updates()
    except Exception as exc:
        print(f"Warning: Gaia migration skipped (MySQL not available yet): {exc}")


GAIA_COLS = ["source_id", "ra", "dec", "parallax", "parallax_error", "pmra", "pmdec",
             "phot_g_mean_mag", "bp_rp", "phot_bp_mean_mag", "phot_rp_mean_mag", "radial_velocity", "teff", "logg", "metallicity", "ruwe", "astrometric_excess_noise",
             "distance_pc", "x_pc", "y_pc", "z_pc", "provider"]
WISE_COLS = ["designation", "catalog", "ra", "dec", "w1mpro", "w2mpro", "w3mpro", "w4mpro", "pmra", "pmdec"]
SPX_COLS = ["uri_hash", "uri", "query_ra", "query_dec", "bandpass", "t_obs_mjd"]


def _pick(rows, cols):
    return [{c: r.get(c) for c in cols} for r in rows]


def _validate_position(ra: float, dec: float):
    if not math.isfinite(ra) or not math.isfinite(dec):
        raise HTTPException(400, "RA and Dec must be finite numeric coordinates.")
    if not -90 <= dec <= 90:
        raise HTTPException(400, "Declination must be between -90° and 90°.")


def _run(fn, *args, **kwargs):
    try:
        return fn(*args, **kwargs)
    except ValueError as exc:
        raise HTTPException(400, str(exc)) from exc
    except (TimeoutError, RequestsTimeout) as exc:
        raise HTTPException(504, f"The astronomical archive query timed out: {exc}") from exc
    except Exception as exc:
        from requests.exceptions import ConnectionError as RequestsConnectionError
        if isinstance(exc, RequestsConnectionError) or isinstance(exc, ConnectionError):
            raise HTTPException(502, f"No connection to the external archive: {str(exc)[:350]}") from exc
        message = str(exc).strip() or exc.__class__.__name__
        raise HTTPException(502, f"External archive error: {message[:500]}") from exc


def _cached(layer: str, key: str, fn, *args, **kwargs):
    """Caché TTL con single-flight: una petición externa por consulta simultánea."""
    while True:
        now = time.monotonic()
        with _cache_lock:
            entry = _cache.get(key)
            if entry and entry[0] > now:
                _cache_stats["hits"] += 1
                return [dict(r) for r in entry[1]]
            _cache.pop(key, None)
            flight = _inflight.get(key)
            if flight is None:
                flight = {"event": threading.Event(), "rows": None, "error": None}
                _inflight[key] = flight
                _cache_stats["misses"] += 1
                owner = True
            else:
                owner = False

        if not owner:
            if not flight["event"].wait(timeout=32):
                raise HTTPException(504, "The same query is still running. Wait a few seconds or reduce the radius/rows.")
            if flight["error"] is not None:
                raise flight["error"]
            return [dict(r) for r in (flight["rows"] or [])]

        try:
            rows = _run(fn, *args, **kwargs)
            with _cache_lock:
                flight["rows"] = [dict(r) for r in rows]
                _cache[key] = (time.monotonic() + CACHE_TTL[layer], flight["rows"])
                # La caché es efímera y acotada: evita crecimiento ilimitado en sesiones largas.
                if len(_cache) > 96:
                    oldest = sorted(_cache, key=lambda k: _cache[k][0])[:24]
                    for old_key in oldest:
                        _cache.pop(old_key, None)
            return rows
        except Exception as exc:
            with _cache_lock:
                flight["error"] = exc
            raise
        finally:
            with _cache_lock:
                _inflight.pop(key, None)
                flight["event"].set()


@app.get("/health")
def health():
    return {"ok": True, "service": "query-api"}


@app.get("/connectivity")
def connectivity():
    return upstream.probe_connectivity()


@app.get("/cache")
def cache_status():
    with _cache_lock:
        return {"entries": len(_cache), "ttl_seconds": CACHE_TTL, **_cache_stats}


@app.get("/gaia/stars")
def gaia(ra: float, dec: float, radius: float = Query(0.03, gt=0, le=3),
         limit: int = Query(100, ge=1, le=1000), provider: str = "mast",
         max_mag: float = Query(18, ge=0, le=25), store: bool = False):
    _validate_position(ra, dec)
    cache_key = f"gaia:{ra % 360:.5f}:{dec:.5f}:{radius:.4f}:{limit}:{provider}:{max_mag:.2f}"
    rows = _cached("gaia", cache_key, upstream.query_gaia, ra, dec, radius, limit, provider, max_mag)
    stored = False
    if store:
        n = upsert_many("gaia_stars", _pick([r for r in rows if r.get("distance_pc")], GAIA_COLS))
        log_ingest("gaia", ra, dec, radius, n, provider)
        stored = True
    return {"count": len(rows), "stored": stored, "cache": cache_key in _cache, "rows": rows}




@app.get("/gaia/diagnostic")
def gaia_diagnostic(ra: float = 304.6935, dec: float = 42.4437):
    """Ejecuta una consulta TAP mínima real para probar ADQL y el endpoint de Gaia."""
    _validate_position(ra, dec)
    rows = _run(upstream.query_gaia, ra, dec, 0.001, 1, "mast", 20.0)
    return {
        "ok": True,
        "provider": "MAST / STScI Gaia DR3 TAP",
        "query_test": "ADQL cone search",
        "returned": len(rows),
        "message": "TAP responded correctly. Zero rows is also a valid response.",
    }


@app.get("/wise/sources")
def wise(ra: float, dec: float, radius: float = Query(0.03, gt=0, le=1),
         limit: int = Query(100, ge=1, le=500), store: bool = False):
    _validate_position(ra, dec)
    cache_key = f"wise:{ra % 360:.5f}:{dec:.5f}:{radius:.4f}:{limit}"
    rows = _cached("wise", cache_key, upstream.query_wise, ra, dec, radius, limit)
    stored = False
    if store:
        n = upsert_many("wise_sources", _pick(rows, WISE_COLS))
        log_ingest("wise", ra, dec, radius, n)
        stored = True
    return {"count": len(rows), "stored": stored, "cache": cache_key in _cache, "rows": rows}


@app.get("/spherex/images")
def spherex(ra: float, dec: float, radius: float = Query(0.03, gt=0, le=1),
            limit: int = Query(80, ge=1, le=200), bandpass: str | None = None,
            store: bool = False):
    _validate_position(ra, dec)
    if bandpass and bandpass not in {f"SPHEREx-D{i}" for i in range(1, 7)}:
        raise HTTPException(400, "Invalid band. Use SPHEREx-D1 to SPHEREx-D6.")
    cache_key = f"spherex:{ra % 360:.5f}:{dec:.5f}:{radius:.4f}:{limit}:{bandpass or 'all'}"
    rows = _cached("spherex", cache_key, upstream.query_spherex, ra, dec, limit, bandpass, radius)
    stored = False
    if store:
        n = upsert_many("spherex_images", _pick(rows, SPX_COLS))
        log_ingest("spherex", ra, dec, radius, n)
        stored = True
    return {"count": len(rows), "stored": stored, "cache": cache_key in _cache, "rows": rows}
