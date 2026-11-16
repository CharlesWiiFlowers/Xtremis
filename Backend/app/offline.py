"""Offline / outage fallback: a no-network mode and a portable cache bundle.

``CYGNUSX_OFFLINE=1`` makes every IRSA, S3, Gaia and Sesame call fail fast with ``OfflineError`` (HTTP 503), so the
API serves only what is already in ``Backend/cache`` instead of hanging on timeouts. On startup the cache is
seeded (missing files only) from the committed demo dataset ``Backend/offline/demo_cache.tar.gz``.

    python -m app.offline export [--full] [--output offline/demo_cache.tar.gz]
    python -m app.offline import offline/demo_cache.tar.gz
"""
from __future__ import annotations

import argparse
import logging
import os
import tarfile
from pathlib import Path

from fastapi import HTTPException

logger = logging.getLogger(__name__)

ENABLED = os.environ.get("CYGNUSX_OFFLINE", "").strip().lower() in {"1", "true", "yes", "on"}
BACKEND_DIR = Path(__file__).resolve().parents[1]
DEMO_BUNDLE = BACKEND_DIR / "offline" / "demo_cache.tar.gz"
SEED_GAIA_DIR = Path(__file__).resolve().parent / "data" / "gaia"   # Gaia DR3 rows of the benchmark presets
BUNDLE_DIRS = ("frontend", "spectra", "gaia", "searches")          # everything the React viewer needs
FULL_EXTRA_DIRS = ("renders", "cutouts")                           # /api/sky/images PNGs and raw FITS (large)


class OfflineError(RuntimeError):
    """A request needs an external archive while offline mode is on."""


def guard(what: str) -> None:
    if ENABLED:
        raise OfflineError(f"offline mode (CYGNUSX_OFFLINE=1): {what} is not available from the local cache")


MAX_FAILED_FRACTION = 0.1   # results with more failed frames than this are not cached (upstream outage)


def check_complete(failed: int, total: int, what: str) -> None:
    """Refuse to cache a result built while archives were unreachable (offline mode: any missing frame)."""
    if failed and ENABLED:
        raise OfflineError(f"{failed} SPHEREx cutouts of this {what} are not in the local cache")
    if failed > MAX_FAILED_FRACTION * max(total, 1):
        raise RuntimeError(f"{failed} of {total} SPHEREx cutouts of this {what} could not be downloaded "
                           "(archive outage?); not caching a partial result")


def upstream_error(exc: Exception, source: str) -> HTTPException:
    """HTTP error for a failed upstream call: 503 while offline, 502 for a real archive failure."""
    if isinstance(exc, OfflineError):
        return HTTPException(503, str(exc))
    return HTTPException(502, f"{source} upstream error: {exc}")


def export_bundle(cache_dir: Path, dest: Path, full: bool = False) -> int:
    """Pack the cache into a .tar.gz (viewer data only unless ``full``). Returns the number of files."""
    dest.parent.mkdir(parents=True, exist_ok=True)
    count = 0
    with tarfile.open(dest, "w:gz") as tar:
        for name in BUNDLE_DIRS + (FULL_EXTRA_DIRS if full else ()):
            root = cache_dir / name
            if not root.is_dir():
                continue
            for path in sorted(root.rglob("*")):
                if path.is_file() and ".tmp" not in path.suffixes:
                    tar.add(path, arcname=str(path.relative_to(cache_dir)))
                    count += 1
    return count


def import_bundle(cache_dir: Path, bundle: Path) -> int:
    """Extract a cache bundle, keeping files that already exist. Returns the number of files added."""
    added = 0
    with tarfile.open(bundle, "r:gz") as tar:
        for member in tar.getmembers():
            if member.isfile() and not (cache_dir / member.name).exists():
                tar.extract(member, cache_dir, filter="data")
                added += 1
    return added


def seed_cache(cache_dir: Path) -> int:
    """Copy the committed demo dataset into the cache (missing files only)."""
    if not DEMO_BUNDLE.exists():
        return 0
    try:
        added = import_bundle(cache_dir, DEMO_BUNDLE)
    except (OSError, tarfile.TarError) as exc:
        logger.warning("could not read %s: %s", DEMO_BUNDLE, exc)
        return 0
    if added:
        logger.info("seeded %d cache files from %s", added, DEMO_BUNDLE.relative_to(BACKEND_DIR))
    return added


def main() -> None:
    from .image_processor import CACHE_DIR

    parser = argparse.ArgumentParser(description="Export or import a Backend/cache bundle")
    sub = parser.add_subparsers(dest="command", required=True)
    export = sub.add_parser("export", help="pack the cache into a .tar.gz")
    export.add_argument("--output", type=Path, default=DEMO_BUNDLE)
    export.add_argument("--full", action="store_true", help="also include renders/ and the raw FITS cutouts")
    imp = sub.add_parser("import", help="extract a bundle into the cache (existing files are kept)")
    imp.add_argument("bundle", type=Path)
    args = parser.parse_args()
    if args.command == "export":
        n = export_bundle(CACHE_DIR, args.output, args.full)
        print(f"{n} files -> {args.output} ({args.output.stat().st_size / 1e6:.1f} MB)")
    else:
        print(f"{import_bundle(CACHE_DIR, args.bundle)} files added to {CACHE_DIR}")


if __name__ == "__main__":
    main()
