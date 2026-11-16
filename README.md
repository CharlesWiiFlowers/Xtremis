# CygnusX — Space Apps Challenge 2026 · *Planet X and SPHEREx*

**Website:** [cygnus.earth](https://cygnus.earth)

## What it does and how it works

CygnusX is a public web app for exploring NASA's SPHEREx infrared sky survey over time. You type coordinates (RA/Dec) or an object's name, and the app gathers every SPHEREx observation of that area and plays the images in order, like a short video, on a timeline that starts in 2025. Three viewing modes help you spot change:

- **Animate** plays the epochs in sequence.
- **Subtract** removes everything that stayed the same, so moving or variable objects stand out in blue (new) and gold (old).
- **Stack** averages all epochs to bring out faint stars.

You can view all 102 bands together, one detector, a single band, or a false-color composite. Clicking a star calculates its 102-band spectrum and its light curve. You can also overlay Gaia and WISE positions and SPHEREx contamination flags, choose a field of view from 5′ to 40′, and move an exploration crosshair with the arrow keys. When the crosshair reaches the edge, the next patch of sky loads. Each view is saved in the URL, so it can be shared or embedded.

A second section, **ORBITAL**, is a 2D solar system simulator. Planets follow Keplerian orbits based on JPL data, with full detail cards for each body, plus a lab of 180 synthetic objects. It works offline.

## Benefits and intended impact

SPHEREx data normally takes specialist tools and astronomy experience to use. CygnusX puts it in a browser, in English and Spanish, with plain-language explanations. Students, teachers and amateur astronomers can see the infrared sky change, learn what spectra and light curves show, and maybe notice something new, such as a nearby brown dwarf like WISE 0855. All five challenge test objects work out of the box.

## Tools and technologies

- **Front end:** React, TypeScript and Vite, with no UI or chart libraries. The charts, timeline and animated galaxy are hand-built with SVG and Canvas.
- **Back end:** Python with FastAPI and Astropy for image cutouts, spectra and caching. A second Python service queries NASA/IPAC IRSA (SPHEREx, WISE) and MAST (Gaia DR3). ORBITAL's server and API run on Node.js.
- **Data and deployment:** MySQL stores the catalog and orbits. Nginx is the single entry point, and the whole system starts with one Docker Compose command. Caddy adds automatic HTTPS for the public site at [cygnus.earth](https://cygnus.earth).
- **Testing:** Node's test runner and Playwright browser tests.
- **Hardware:** no special hardware. The app runs in any modern browser.

## Creativity

Instead of a static image archive, CygnusX treats the sky as a video you can scrub with a planet-shaped slider. Subtraction makes motion visible at a glance. Clicking the spectrum shows that band in the image, which links the physics to the picture. Placing a solar system simulator next to the real survey data connects what students learn about orbits with what telescopes actually observe.

## Factors we considered

- **Speed and reliability:** IRSA can be slow or fail intermittently. A new area takes 1–3 minutes the first time and then loads from cache in under 0.1 s. The backend retries failed requests and falls back to a backup Gaia source.
- **Demo mode:** a Simulated mode responds instantly for demonstrations, and a Real mode switches to live NASA data without reloading. An offline package covers the five test objects.
- **Scientific honesty:** saturated objects such as Barnard's Star and R Draconis are marked with contamination flags, and synthetic data is always labeled as synthetic.
- **Easy updates:** new SPHEREx releases appear automatically through IRSA's services.
- **Accessibility and design:** the interface is bilingual, keyboard-friendly and high-contrast, and we refined it with feedback from mentors and our team.

---

## Running it

One program, one command, one address:

```bash
docker compose up --build
```

Open **http://localhost:8080**. The first run takes a few minutes (it builds the viewer and installs Astropy and friends).

| Address | What it is |
|---|---|
| `http://localhost:8080/` | **CygnusX, one program with two sections** (selector at the top: *Sky images* · *Solar system*) |
| ↳ *Sky images* | SPHEREx viewer: real images played as a "video", 102-band spectrum, light curve, Gaia/WISE layers |
| ↳ *Solar system* (`/?view=orbital`) | ORBITAL: 2D planet simulator and synthetic-object lab, inside the same interface |
| `http://localhost:8080/orbital/` | ORBITAL as a standalone full page |
| `http://localhost:3010/` | Same ORBITAL, direct access (redirects to `/orbital/`) |
| `http://localhost:8080/api/…` | SPHEREx API (FastAPI). Interactive docs at `/docs` |
| `http://localhost:8080/api/v1/…` | ORBITAL API (status, orbits, live Gaia/WISE/SPHEREx, catalog stored in MySQL) |

## Architecture

```
            browser ──► web (Nginx :8080)
                         ├─ /            React viewer (static build)
                         ├─ /orbital/ ─┐
                         ├─ /api/v1/ ──┴─► orbital (Node.js) ─► python (Gaia/WISE/IRSA queries) ─┐
                         └─ /api/ ───────► backend (FastAPI: images, spectra, cache)            ├─► mysql
                                                                                                ┘
```

| Service | Folder | Purpose |
|---|---|---|
| `web` | `viewer/` | React viewer + Nginx, the **only door** to the outside |
| `backend` | `Backend/` | SPHEREx cutouts, 102-band spectra, Gaia/WISE for the viewer. Uses `Database/scripts` |
| `orbital` | `orbital/` | Simulator (`public/`) and `/api/v1` API (`server/`) |
| `python` | `python/` | Live queries to Gaia (MAST), WISE and SPHEREx (IRSA); loads the catalog into MySQL |
| `mysql` | `Database/mysql/schema.sql` | Schema created automatically on first start |

Only `web` (8080), ORBITAL (3010) and MySQL (`127.0.0.1:3307`, so you can inspect it with a client) are published; everything else stays on Docker's internal network.

## Day-to-day use

```bash
docker compose up -d --build     # run in the background
docker compose ps                # status and healthchecks
docker compose logs -f backend   # logs for one service
docker compose down              # stop (keeps MySQL and the cache)
docker compose down -v           # stop and DELETE MySQL and the cache
```

## Configuration (optional)

Set these in a `.env` file at the repo root:

- `WEB_PORT=8080`: public port.
- `CYGNUSX_OFFLINE=1`: no internet. Serves only what is cached; the demo package (`Backend/offline/demo_cache.tar.gz`) covers the 5 test objects at their home-screen positions with a 10′ field. Any other coordinate returns 503 immediately.
- `CYGNUSX_DOWNLOAD_WORKERS=8`: parallel downloads from IRSA.
- `VITE_USE_MOCK=true|false`: the viewer's initial data source. `true` (default) = **Simulated**: instant, moves with the arrow keys and loads zone by zone. `false` = real data from the backend. The **Simulated | Real** toggle in the top bar switches it without rebuilding (remembered in the browser; also `?data=real`).
- `VITE_API_URL=`: backend base URL when the viewer is hosted separately (e.g. on Vercel). Leave empty when served by the bundled Nginx.
- `VITE_MODEL_URL=`: only to embed ANOTHER external model in the viewer (ORBITAL is already a section).
- MySQL passwords: change them before publishing to the internet.

With a domain and automatic HTTPS: `DOMAIN=cygnus.earth docker compose --profile https up -d`.

## Operating notes

- A new (uncached) coordinate takes **1–3 min** the first time, because it downloads cutouts from IRSA; afterwards it responds in under 0.1 s from the `spherex_cache` volume.
- IRSA and the Gaia archive fail intermittently; the backend retries and uses a backup Gaia source (see `Backend/README.md`).
- MySQL is optional for the viewer: ORBITAL opens and works even while the database is still starting.
- Barnard's Star, R Draconis and most of RW Aurigae saturate SPHEREx: they are shown with a contamination flag.

## Tests

```bash
node --test tests/*.test.mjs        # orbital math and object detail cards
python tests/browser-smoke.py       # simulator in Chromium (requires playwright)
```

## Repository layout

```
docker-compose.yml  deploy/Caddyfile
viewer/    SPHEREx viewer (React + Vite) + Dockerfile + nginx.conf (single entry point)
orbital/   ORBITAL simulator (public/) + Node API (server/)
Backend/   SPHEREx API (FastAPI)          python/   live queries + seed
Database/  Gaia/SPHEREx scripts, docs and mysql/schema.sql      catalog/  API catalog
docs/      project context, external model integration          tests/
legacy/    earlier prototype and Vite template (no longer used; kept for history)
```

Viewer ⇄ external model integration via `postMessage`: `docs/INTEGRACION_MODELO.md`.
