# Xtremis SPHEREx backend

FastAPI service that serves real SPHEREx images and 102-channel spectra (IRSA + public AWS S3) and Gaia DR3 data to
the React viewer in `../viewer`. It reuses the IRSA/S3/Gaia query code in `../Database/scripts` through
`app/spherex_adapter.py`.

## Setup

Python 3.12+ and no accounts or API keys. With [uv](https://docs.astral.sh/uv/) (recommended; it also installs
Python 3.12 if missing):

```bash
cd Backend
uv venv --python 3.12
source .venv/bin/activate            # Windows: .venv\Scripts\activate
uv pip install -r requirements.txt
```

Without uv: `python3.12 -m venv .venv`, activate it, then `pip install -r requirements.txt`.

> En el programa unificado este backend corre como el servicio `backend` del `docker-compose.yml` de la raíz
> (ver `../README.md`). Lo de abajo es solo para desarrollarlo por separado.

## Offline / API outages

IRSA (502 Proxy Error on `/SIA/capabilities`) and the ESA Gaia archive (`ConnectTimeout` on `/tap-server/tap/sync`)
fail intermittently. The backend handles this with:

- **Bundled demo dataset** `offline/demo_cache.tar.gz`, copied into `Backend/cache/` on every start (missing files
  only). It holds everything the React viewer requests for the 5 benchmark targets at their Home-card position,
  10′ field: epochs, frames for all detectors in animate/diff/sum, flag overlays, Gaia + WISE overlays, spectra and
  light curves.
- **Bundled Gaia DR3 rows** for the presets (`app/data/gaia/`): resolving a benchmark target never needs Gaia.
- **Gaia fallback chain** for other lookups: ESA async (`gaia_api.ejecutar_adql`) → MAST mirror → ESA sync, each
  with a 45 s deadline. IRSA searches are retried.
- **Offline mode** `XTREMIS_OFFLINE=1`: no network calls at all. Cached requests are served as usual; anything else
  returns HTTP 503 immediately instead of waiting for timeouts.

```bash
XTREMIS_OFFLINE=1 uvicorn app.main:app --port 8000     # Windows PowerShell: $env:XTREMIS_OFFLINE=1; uvicorn ...
curl http://localhost:8000/api/health                  # {"status":"ok","offline":true,"demo_bundle":true}
```

To refresh or share your own cache: `python warm_cache.py --export offline/demo_cache.tar.gz` (add `--full` to
include the large FITS cutouts and `/api/sky/images` renders), and `python -m app.offline import <bundle>` to load one.

## Pre-warm the cache (online, optional)

```bash
python warm_cache.py                          # 5 benchmark targets: images, spectra and all viewer frames
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
cd ../viewer
echo "VITE_USE_MOCK=false" > .env.local       # leave VITE_API_URL empty: Vite proxies /api to localhost:8000
npm install
npm run dev                                   # http://localhost:5173
```

## Endpoints

| Route | Purpose |
|---|---|
| `GET /api/resolve`, `/api/epochs`, `/api/frame`, `/api/flags`, `/api/catalog`, `/api/spectrum`, `/api/lightcurve` | Contract of the React viewer (`viewer/README.md`), in `app/frontend_adapter.py` |
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
- A spectrum for a new (uncached) position takes about 1–2 minutes and needs IRSA; see "Offline / API outages".
