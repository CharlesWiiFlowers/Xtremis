# Xtremis SPHEREx backend

FastAPI service that serves real SPHEREx images and 102-channel spectra (IRSA + public AWS S3) and Gaia DR3 data to
the React viewer in `../frontend`. It reuses the IRSA/S3/Gaia query code in `../Database/scripts` through
`app/spherex_adapter.py`.

## Setup

Python 3.11+ (tested with 3.12). No accounts or API keys are needed.

```bash
cd Backend
python -m venv .venv
source .venv/bin/activate            # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

## Pre-warm the cache (recommended before a demo)

```bash
python warm_cache.py                          # 5 benchmark targets: images, spectra and the viewer's first frames
python warm_cache.py --targets barnard rdra   # a subset (barnard, epsindib, wise0855, rwaur, rdra)
python warm_cache.py --fov 10 20              # several fields of view (arcmin)
```

A cold target takes 1.5–3 minutes (cutouts are downloaded from IRSA); afterwards its requests are answered from
`Backend/cache/` in under 0.1 s. The cache is plain files: delete the folder to reset it, or set
`XTREMIS_CACHE_DIR` to move it.

## Run

```bash
uvicorn app.main:app --reload --port 8000
```

Interactive API docs: http://localhost:8000/docs

## Frontend against the real backend

```bash
cd ../frontend
echo "VITE_USE_MOCK=false" > .env.local       # leave VITE_API_URL empty: Vite proxies /api to localhost:8000
npm install
npm run dev                                   # http://localhost:5173
```

## Endpoints

| Route | Purpose |
|---|---|
| `GET /api/resolve`, `/api/epochs`, `/api/frame`, `/api/flags`, `/api/catalog`, `/api/spectrum`, `/api/lightcurve` | Contract of the React viewer (`frontend/README.md`), in `app/frontend_adapter.py` |
| `GET /api/flags/definitions` | SPHEREx FLAGS bit names and which bits count as severe |
| `GET /api/targets` | The 5 benchmark presets |
| `GET /api/sky/images` | Detector coadds, per-epoch and false-color PNGs plus frame metadata |
| `GET /api/sky/spectrum` | Full 102-channel spectrum with raw measurements and per-epoch breakdown |

`/api/sky/*` accept `ra`/`dec`, `gaia_source_id` or `target_name` (e.g. `Barnard's Star`); with a Gaia source or
preset the position is propagated with its proper motion.

## Notes

- Benchmark stars that are very bright (Barnard's Star, R Draconis, most of RW Aurigae) saturate SPHEREx; their
  measurements are returned but flagged (`flagged` / `bad_flag`).
- WISE 0855−0714 has no Gaia DR3 entry; its preset uses literature coordinates and proper motion (unverified).
- IRSA and the ESA Gaia archive fail intermittently; searches are retried and Gaia lookups fall back to a
  synchronous TAP query. A spectrum for a new (uncached) position takes about 1–2 minutes.
