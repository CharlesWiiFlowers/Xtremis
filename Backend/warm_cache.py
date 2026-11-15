"""Pre-compute images and spectra for the challenge benchmark targets so live demo requests hit the cache.

Run from the Backend/ folder:
    python warm_cache.py                          # all 5 presets, fov 10', images + spectra + React viewer PNGs
    python warm_cache.py --targets barnard rdra --fov 10 20 --no-spectrum
"""
import argparse
import logging
import sys
import time

from app import frontend_adapter, targets
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
        # The React viewer opens benchmark targets on their approximate J2000 position (frontend/src/lib/targets.ts):
        # exact values from the Home cards, 5-decimal values when the view is reloaded from its URL.
        exact = targets.BENCHMARKS[preset]["frontend_center"]
        for fra, fdec in dict.fromkeys([exact, tuple(round(v, 5) for v in exact)]):
            for fov in fovs:
                started = time.time()
                pngs = frontend_adapter.warm_view(fra, fdec, fov)
                print(f"   viewer  fov={fov:g}' centre {fra} {fdec:+}: {pngs} PNGs, {time.time() - started:.1f}s",
                      flush=True)
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
    print("done" if not failed else f"failed: {failed}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
