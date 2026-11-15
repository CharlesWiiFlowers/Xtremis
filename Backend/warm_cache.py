"""Pre-compute images and spectra for the challenge benchmark targets so live demo requests hit the cache.

Run from the Backend/ folder:
    python warm_cache.py                          # all 5 presets, fov 10': images, spectra, React viewer PNGs
    python warm_cache.py --targets barnard rdra --fov 10 20 --no-spectrum
    python warm_cache.py --export offline/demo_cache.tar.gz   # then pack the cache as the offline dataset
"""
import argparse
import logging
import sys
import time
from pathlib import Path

from app import frontend_adapter, offline, targets
from app import image_processor as images
from app import spectrum_processor as spectra


def warm(preset: str, fovs: list[float], with_spectrum: bool, with_viewer: bool) -> bool:
    target = targets.resolve(target_name=preset)
    ra, dec = target.view_center()
    print(f"== {target.name} ({target.source}) view centre {ra:.5f} {dec:+.5f}", flush=True)
    ok = True
    for fov in fovs:
        started = time.time()
        result = images.build_sky_images(images.ImageRequest(ra=ra, dec=dec, fov_arcmin=fov))
        summary = result["summary"]
        ok &= summary["frames_rendered"] > 0
        print(f"   images  fov={fov:g}'  {summary['frames_rendered']}/{summary['frames_selected']} frames, "
              f"{summary['epochs']} epochs, cached={result['cached']}, {time.time() - started:.1f}s", flush=True)
    if with_viewer:
        # The React viewer opens benchmark targets on their approximate J2000 position (frontend/src/lib/targets.ts)
        fra, fdec = targets.BENCHMARKS[preset]["frontend_center"]
        for fov in fovs:
            started = time.time()
            pngs = frontend_adapter.warm_view(fra, fdec, fov, frontend_adapter.DETECTOR_OPTIONS)
            print(f"   viewer  fov={fov:g}' centre {fra} {fdec:+}: {pngs} PNGs, {time.time() - started:.1f}s", flush=True)
    if with_spectrum:
        started = time.time()
        result = spectra.build_spectrum(spectra.SpectrumRequest(
            ra=target.ra, dec=target.dec, pmra=target.pmra, pmdec=target.pmdec, ref_epoch=target.ref_epoch))
        summary = result["summary"]
        ok &= summary["measurements"] > 0
        print(f"   spectrum  {summary['measurements']} measurements ({summary['good_measurements']} good), "
              f"{summary['channels_filled']}/102 channels, cached={result['cached']}, {time.time() - started:.1f}s",
              flush=True)
    return ok


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--targets", nargs="+", default=list(targets.BENCHMARKS), choices=list(targets.BENCHMARKS))
    parser.add_argument("--fov", nargs="+", type=float, default=[10.0], help="image fields of view (arcmin)")
    parser.add_argument("--no-spectrum", action="store_true", help="skip the spectra")
    parser.add_argument("--no-viewer", action="store_true", help="skip the React viewer (/api/frame) PNGs")
    parser.add_argument("--export", type=Path, help="afterwards, pack the cache into this .tar.gz (offline dataset)")
    parser.add_argument("--full", action="store_true", help="with --export: also include renders/ and FITS cutouts")
    args = parser.parse_args()
    logging.basicConfig(level=logging.WARNING)
    failed = []
    for preset in args.targets:
        try:
            if not warm(preset, args.fov, not args.no_spectrum, not args.no_viewer):
                failed.append(preset)
        except Exception as exc:  # noqa: BLE001 - keep warming the other targets
            print(f"   FAILED: {exc}", flush=True)
            failed.append(preset)
    if args.export:
        n = offline.export_bundle(images.CACHE_DIR, args.export, args.full)
        print(f"exported {n} files -> {args.export} ({args.export.stat().st_size / 1e6:.1f} MB)")
    print("done" if not failed else f"failed: {failed}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
