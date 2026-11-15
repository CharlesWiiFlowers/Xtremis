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
from . import spherex_adapter as spherex

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")

app = FastAPI(title="Xtremis SPHEREx API", version="0.1.0",
              description="SPHEREx infrared images (IRSA/AWS) for the NASA Space Apps 2026 Xtremis project.")
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


@app.get("/api/health")
def health():
    return {"status": "ok"}


@app.get("/api/sky/images")
def sky_images(
    request: Request,
    ra: Annotated[float, Query(ge=0, lt=360, description="Right ascension (deg, ICRS)")],
    dec: Annotated[float, Query(ge=-90, le=90, description="Declination (deg, ICRS)")],
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
    collections = collections or list(spherex.DEFAULT_COLLECTIONS)
    unknown = sorted(set(collections) - set(spherex.COLLECTIONS))
    if unknown:
        raise HTTPException(422, f"unknown collections {unknown}; valid: {spherex.COLLECTIONS}")

    req = images.ImageRequest(ra=ra, dec=dec, fov_arcmin=fov, frames_per_group=frames_per_group,
                              rgb=channels, cmap=cmap, collections=list(collections))
    try:
        result = images.build_sky_images(req)
    except Exception as exc:
        logging.getLogger(__name__).exception("sky images failed")
        raise HTTPException(502, f"SPHEREx upstream error: {exc}") from exc
    return _absolute_urls(result, request)
