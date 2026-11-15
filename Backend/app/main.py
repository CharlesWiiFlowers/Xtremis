"""Xtremis SPHEREx backend (FastAPI).

Run from the Backend/ folder:  uvicorn app.main:app --reload --port 8000
"""
import logging
from typing import Annotated

from fastapi import FastAPI, HTTPException, Query, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from matplotlib import colormaps

from . import image_processor as images
from . import spectrum_processor as spectra
from . import spherex_adapter as spherex
from . import targets

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")

app = FastAPI(title="Xtremis SPHEREx API", version="0.1.0",
              description="SPHEREx infrared images and 102-channel spectra (IRSA/AWS) for the NASA Space Apps 2026 Xtremis project.")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

images.RENDER_DIR.mkdir(parents=True, exist_ok=True)
app.mount("/static", StaticFiles(directory=images.RENDER_DIR), name="static")


def _absolute_urls(result: dict, request: Request) -> dict:
    """Turn PNG paths relative to RENDER_DIR into absolute URLs served under /static."""
    def url(rel):
        return str(request.url_for("static", path=rel)) if rel else None

    for det in result["detectors"]:
        det["coadd_png"] = url(det["coadd_png"])
    for epoch in result["epochs"]:
        epoch["detector_pngs"] = {d: url(p) for d, p in epoch["detector_pngs"].items()}
    for frame in result["frames"]:
        frame["png"] = url(frame["png"])
    if result["false_color"]:
        result["false_color"]["png"] = url(result["false_color"]["png"])
    return result


def _resolve_target(ra, dec, gaia_source_id, target_name) -> targets.Target:
    try:
        return targets.resolve(ra, dec, gaia_source_id, target_name)
    except LookupError as exc:   # unknown preset name or Gaia source_id
        raise HTTPException(404, str(exc.args[0])) from exc
    except ValueError as exc:
        raise HTTPException(422, str(exc)) from exc
    except Exception as exc:
        logging.getLogger(__name__).exception("Gaia lookup failed")
        raise HTTPException(502, f"Gaia archive error: {exc}") from exc


GaiaSourceId = Annotated[int | None, Query(ge=1, description="Gaia DR3 source_id (overrides ra/dec)")]
TargetName = Annotated[str | None, Query(description="Benchmark preset, e.g. 'Barnard's Star' (see /api/targets)")]


@app.get("/api/targets")
def benchmark_targets():
    return targets.list_presets()


@app.get("/api/health")
def health():
    return {"status": "ok"}


@app.get("/api/sky/images")
def sky_images(
    request: Request,
    ra: Annotated[float | None, Query(ge=0, lt=360, description="Right ascension (deg, ICRS)")] = None,
    dec: Annotated[float | None, Query(ge=-90, le=90, description="Declination (deg, ICRS)")] = None,
    gaia_source_id: GaiaSourceId = None,
    target_name: TargetName = None,
    fov: Annotated[float, Query(ge=1, le=60, description="Field of view (arcmin)")] = 10.0,
    frames_per_group: Annotated[int, Query(ge=1, le=20, description="Max frames per (epoch, detector)")] = 4,
    rgb: Annotated[str, Query(description="Detectors for the red,green,blue channels")] = "D5,D3,D1",
    cmap: Annotated[str, Query(description="Matplotlib colormap for single-detector PNGs")] = "gray",
    collections: Annotated[list[str] | None, Query(description="SPHEREx SIA2 collections")] = None,
):
    channels = tuple(c.strip().upper() for c in rgb.split(","))
    if len(channels) != 3 or any(c not in images.DETECTORS for c in channels):
        raise HTTPException(422, "rgb must be three detectors from D1..D6, e.g. 'D5,D3,D1'")
    if cmap not in colormaps:
        raise HTTPException(422, f"unknown colormap '{cmap}'")
    collections = _validated_collections(collections)
    target = _resolve_target(ra, dec, gaia_source_id, target_name)
    ra, dec = target.view_center()
    req = images.ImageRequest(ra=ra, dec=dec, fov_arcmin=fov, frames_per_group=frames_per_group,
                              rgb=channels, cmap=cmap, collections=collections)
    try:
        result = images.build_sky_images(req)
    except Exception as exc:
        logging.getLogger(__name__).exception("sky images failed")
        raise HTTPException(502, f"SPHEREx upstream error: {exc}") from exc
    return {**_absolute_urls(result, request), "resolved_target": target.metadata()}


def _validated_collections(collections: list[str] | None) -> list[str]:
    collections = collections or list(spherex.DEFAULT_COLLECTIONS)
    unknown = sorted(set(collections) - set(spherex.COLLECTIONS))
    if unknown:
        raise HTTPException(422, f"unknown collections {unknown}; valid: {spherex.COLLECTIONS}")
    return list(collections)


@app.get("/api/sky/spectrum")
def sky_spectrum(
    ra: Annotated[float | None, Query(ge=0, lt=360, description="Right ascension (deg, ICRS); view centre if x/y are given")] = None,
    dec: Annotated[float | None, Query(ge=-90, le=90, description="Declination (deg, ICRS); view centre if x/y are given")] = None,
    gaia_source_id: GaiaSourceId = None,
    target_name: TargetName = None,
    x: Annotated[float | None, Query(ge=0, description="Pixel column in a /api/sky/images PNG (origin top-left)")] = None,
    y: Annotated[float | None, Query(ge=0, description="Pixel row in a /api/sky/images PNG (origin top-left)")] = None,
    fov: Annotated[float, Query(ge=1, le=60, description="Field of view (arcmin) of the PNG that x/y refer to")] = 10.0,
    r_ap: Annotated[float, Query(ge=1, le=6, description="Aperture radius (SPHEREx pixels of 6.15 arcsec)")]
    = spectra.DEFAULT_R_AP_PIX,
    pmra: Annotated[float, Query(description="Proper motion in RA*cos(dec) (mas/yr)")] = 0.0,
    pmdec: Annotated[float, Query(description="Proper motion in Dec (mas/yr)")] = 0.0,
    ref_epoch: Annotated[float, Query(ge=1900, le=2100, description="Epoch of ra/dec (Julian year)")]
    = spectra.GAIA_EPOCH,
    collections: Annotated[list[str] | None, Query(description="SPHEREx SIA2 collections")] = None,
):
    collections = _validated_collections(collections)
    if (x is None) != (y is None):
        raise HTTPException(422, "x and y must be given together")
    target = _resolve_target(ra, dec, gaia_source_id, target_name)
    pixel = None
    if x is not None:
        view_ra, view_dec = target.view_center()
        point = images.png_pixel_to_world(view_ra, view_dec, fov / 60.0, x, y)
        if point is None:
            raise HTTPException(422, "x/y fall outside the image view")
        pixel = {"x": x, "y": y, "view_ra": view_ra, "view_dec": view_dec, "view_fov_arcmin": fov}
        ra, dec, pmra, pmdec, ref_epoch = *point, 0.0, 0.0, spectra.GAIA_EPOCH
    elif target.source != "coordinates":
        ra, dec, pmra, pmdec, ref_epoch = target.ra, target.dec, target.pmra, target.pmdec, target.ref_epoch

    r_in = max(spectra.DEFAULT_ANNULUS_PIX[0], r_ap + 2.0)
    r_out = max(spectra.DEFAULT_ANNULUS_PIX[1], r_in + 3.0)
    req = spectra.SpectrumRequest(ra=ra, dec=dec, r_ap=r_ap, r_in=r_in, r_out=r_out, pmra=pmra, pmdec=pmdec,
                                  ref_epoch=ref_epoch, collections=collections)
    try:
        result = spectra.build_spectrum(req)
    except Exception as exc:
        logging.getLogger(__name__).exception("sky spectrum failed")
        raise HTTPException(502, f"SPHEREx upstream error: {exc}") from exc
    if pixel:
        result["target"]["pixel"] = pixel
    return {**result, "resolved_target": target.metadata()}
