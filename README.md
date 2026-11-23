# CygnusX — watch the infrared sky change over time

**NASA Space Apps Challenge 2026 · Challenge: *Planet X and SPHEREx***

CygnusX is a free, public web tool that shows NASA **SPHEREx** infrared images of any patch of sky as a short video, so anyone can spot stars that move or change brightness.

**Website:** [cygnusx.earth](https://cygnusx.earth) — hosted on an Azure free-tier subscription for the hackathon, so it may no longer be online. The screenshots below record how it looked and worked.

![CygnusX home page](docs/screenshots/01-home.jpg)

## Contents

1. [The challenge](#the-challenge)
2. [What problem it solves](#what-problem-it-solves)
3. [Tour of the app](#tour-of-the-app)
4. [The five challenge test objects](#the-five-challenge-test-objects)
5. [ORBITAL: the solar system section](#orbital-the-solar-system-section)
6. [Benefits, creativity and design decisions](#benefits-creativity-and-design-decisions)
7. [Technical documentation](#technical-documentation)

---

## The challenge

> Your challenge is to create a public-facing web tool to display images of the sky from the SPHEREx mission, making it easy for anyone to quickly see how they change over time. Users will enter the coordinates of a patch of sky (Right Ascension and declination). Your tool will display a series of images of that patch like a little video, making it easy to spot moving objects.
>
> Test your tool on Barnard's Star, Epsilon Indi B (a pair of brown dwarfs orbiting a star), WISE 0855 (a fast-moving brown dwarf Right Ascension 08h55m10.831s, declination -7d14m42.53s), and variable stars RW Aurigae and R Draconis.

[Challenge page](https://www.spaceappschallenge.org/2026/challenges/planet-x-and-spherex/?tab=details)

## What problem it solves

SPHEREx photographs the whole sky every six months in 102 infrared colors (0.75–5 µm). The data is public, but using it normally takes archive queries, FITS files, astronomy software and experience.

CygnusX hides all of that behind a search box:

1. **Type coordinates or a name.** RA/Dec in degrees or sexagesimal (`08h55m10.831s -7d14m42.53s`), or an object name.
2. **Watch the video.** Every SPHEREx survey of that spot plays in order on a timeline that starts in 2025.
3. **Look for changes.** Subtract epochs to highlight what moved, click a star to see its spectrum and light curve.

It works in English and Spanish, with plain-language explanations, so students, teachers and amateur astronomers can use it, not just specialists.

---

## Tour of the app

### Home page

A search box, one-click examples for the five challenge objects and a short "how it works" guide, over an animated galaxy drawn in Canvas.

<table>
<tr>
<td width="50%"><img src="docs/screenshots/02-home-full.jpg" alt="Full home page"></td>
<td width="50%"><img src="docs/screenshots/03-home-es.jpg" alt="Home page in Spanish"></td>
</tr>
<tr><td align="center">Full home page</td><td align="center">Same page in Spanish</td></tr>
</table>

### The sky viewer

The viewer has the image, a timeline with a planet-shaped slider, the toolbar, and a side panel with field details, spectrum and light curve. Real SPHEREx data for Barnard's Star, played as a video:

![Barnard's Star in the viewer](docs/screenshots/04-viewer-barnard.png)

<p align="center"><img src="docs/screenshots/barnard-animation.gif" alt="Barnard's Star field, SPHEREx surveys 1 to 3" width="420"><br><em>The three SPHEREx surveys of the Barnard's Star field (Aug 2025 – Sep 2026), looped.</em></p>

### Three ways to look for change: Animate, Subtract, Stack

- **Animate** plays the epochs in order, by year or by individual survey, at 0.5×–4× speed.
- **Subtract** removes everything that stayed the same. New position or brightness shows in **blue**, the old one in **gold**.
- **Stack** averages all epochs to reduce noise and bring out faint stars.

<table>
<tr>
<td width="50%"><img src="docs/screenshots/05-subtract.png" alt="Subtract mode"></td>
<td width="50%"><img src="docs/screenshots/06-stack.png" alt="Stack mode"></td>
</tr>
<tr><td align="center">Subtract: 2026 minus 2025</td><td align="center">Stack: all surveys averaged</td></tr>
</table>

### Spectrum and light curve on click

Click any star and the backend measures it in all 102 SPHEREx bands (spectrum) and in every observation (light curve). Clicking a point of the spectrum shows that band in the image. Both charts open full screen.

![R Draconis spectrum and light curve](docs/screenshots/08-spectrum-lightcurve.png)

### Catalog overlays and contamination flags

**Gaia** DR3 (green circles), **WISE**/CatWISE2020 (pink squares) and SPHEREx **flags** (pixels that may be contaminated, e.g. by saturation) can be layered over the image.

![Gaia, WISE and flag overlays on Barnard's Star, 5′ field](docs/screenshots/07-layers.png)

### 102 infrared bands

The **Light** selector picks what to display: all 102 bands summed (the sharpest image), one of the 6 detectors, a single band (slider 1–102 with its wavelength), or a false-color composite (blue = detectors 1–2, green = 3–4, red = 5–6).

<table>
<tr>
<td width="33%"><img src="docs/screenshots/11-wise0855-detector6.png" alt="Detector 6"></td>
<td width="33%"><img src="docs/screenshots/09-band-picker.png" alt="Single band"></td>
<td width="33%"><img src="docs/screenshots/10-false-color.png" alt="False color"></td>
</tr>
<tr><td align="center">WISE 0855 in detector 6 (4.42–5.00 µm), real data</td><td align="center">Single band, Simulated mode</td><td align="center">False color, Simulated mode</td></tr>
</table>

### Search by coordinates, explore, share

- Coordinates are accepted in degrees or sexagesimal. Names are resolved too.
- The field of view goes from 5′ to 40′; the image zooms (wheel or + −) and pans (drag).
- An **exploration aim** moves with the arrow keys and shows RA/Dec, galactic coordinates and offset from center. Near the edge, the next patch of sky loads automatically.
- The whole view lives in the URL (`?ra=…&dec=…&fov=…&det=…&mode=…`), so **Share** copies a link that reopens the same view and can be embedded.

<table>
<tr>
<td width="50%"><img src="docs/screenshots/14-coordinate-search.png" alt="Typing WISE 0855 coordinates"></td>
<td width="50%"><img src="docs/screenshots/15-coordinate-result.png" alt="Result of the coordinate search"></td>
</tr>
<tr><td align="center">Typing the challenge coordinates for WISE 0855</td><td align="center">The resulting field, real SPHEREx data</td></tr>
</table>

### Full screen, Simulated mode, Spanish and mobile

- **Full screen** for the image and both charts.
- **Simulated | Real** toggle: Simulated answers instantly with synthetic data (always labeled) for demos; Real queries NASA archives. It switches without reloading.
- Every text is available in **English and Spanish**.
- The layout adapts to phones.

<table>
<tr>
<td width="50%"><img src="docs/screenshots/16-fullscreen.png" alt="Full screen image"></td>
<td width="50%"><img src="docs/screenshots/17-simulated-mode.png" alt="Simulated mode"></td>
</tr>
<tr><td align="center">Full-screen image</td><td align="center">Simulated mode</td></tr>
<tr>
<td width="50%"><img src="docs/screenshots/18-viewer-es.png" alt="Viewer in Spanish"></td>
<td width="50%">
<img src="docs/screenshots/25-mobile-home.png" alt="Home on a phone" width="48%">
<img src="docs/screenshots/26-mobile-viewer.png" alt="Viewer on a phone" width="48%">
</td>
</tr>
<tr><td align="center">Viewer in Spanish (R Draconis)</td><td align="center">Home and viewer on a phone</td></tr>
</table>

---

## The five challenge test objects

All five load from the home page or from the chips above the viewer.

| Object | Why it is a test | RA / Dec (J2000) | Screenshot |
|---|---|---|---|
| Barnard's Star | Largest known proper motion, ~10.4″/yr | 17h57m48.50s +04°41′36.2″ | [viewer](docs/screenshots/04-viewer-barnard.png) |
| Epsilon Indi B | Pair of brown dwarfs orbiting Epsilon Indi, ~4.7″/yr | 22h04m10.52s −56°46′57.7″ | [viewer](docs/screenshots/12-epsilon-indi-b.png) |
| WISE 0855−0714 | Coldest known brown dwarf, ~8.1″/yr, almost only visible in detector 6 | 08h55m10.83s −07°14′42.5″ | [detector 6](docs/screenshots/11-wise0855-detector6.png) |
| RW Aurigae | Young star in dust, irregular brightness changes | 05h07m49.54s +30°24′05.1″ | [viewer](docs/screenshots/13-rw-aurigae.png) |
| R Draconis | Mira variable, ~245-day cycle | 16h32m40.18s +66°45′17.9″ | [spectrum + light curve](docs/screenshots/08-spectrum-lightcurve.png) |

<table>
<tr>
<td width="50%"><img src="docs/screenshots/12-epsilon-indi-b.png" alt="Epsilon Indi B"></td>
<td width="50%"><img src="docs/screenshots/13-rw-aurigae.png" alt="RW Aurigae"></td>
</tr>
<tr><td align="center">Epsilon Indi B</td><td align="center">RW Aurigae</td></tr>
</table>

Barnard's Star, R Draconis and most of RW Aurigae are bright enough to saturate SPHEREx, so they are marked with contamination flags instead of being shown as clean measurements.

---

## ORBITAL: the solar system section

The **Solar system** tab is a 2D simulator of the Sun and six planets (Mercury to Saturn) on Keplerian orbits with approximate JPL J2000 elements, plus a lab of 180 synthetic objects in an outer ring. Click any body for a full detail card. Time runs at 1× to 10,000× days per second. It works offline.

<table>
<tr>
<td width="50%"><img src="docs/screenshots/19-orbital.png" alt="ORBITAL overview"></td>
<td width="50%"><img src="docs/screenshots/20-orbital-earth-card.png" alt="Earth detail card"></td>
</tr>
<tr><td align="center">Overview inside CygnusX</td><td align="center">Earth detail card</td></tr>
<tr>
<td width="50%"><img src="docs/screenshots/21-orbital-jupiter-fast.png" alt="Jupiter at 1000x"></td>
<td width="50%"><img src="docs/screenshots/22-orbital-lab.png" alt="Synthetic lab object"></td>
</tr>
<tr><td align="center">Jupiter selected, 1,000× speed</td><td align="center">Synthetic lab object (filtered by class)</td></tr>
</table>

ORBITAL also runs as a standalone page at `/orbital/`:

![ORBITAL standalone page](docs/screenshots/23-orbital-standalone.png)

---

## Benefits, creativity and design decisions

### Benefits and intended impact

SPHEREx data normally takes specialist tools to use. CygnusX puts it in a browser, in two languages, with plain explanations. People can see the infrared sky change, learn what spectra and light curves show, and maybe notice something new, such as a nearby brown dwarf like WISE 0855.

### Creativity

- The sky is a video you scrub with a planet-shaped slider, not a static archive.
- Subtraction makes motion visible at a glance.
- Clicking the spectrum shows that band in the image, linking the physics to the picture.
- The solar system simulator next to real survey data connects what students learn about orbits with what telescopes observe.

### Factors we considered

- **Speed and reliability:** IRSA can be slow or fail intermittently. A new area takes 1–3 minutes the first time and then loads from cache in under 0.1 s. The backend retries failed requests and falls back to a backup Gaia source.
- **Demo mode:** Simulated mode responds instantly for demonstrations; Real mode switches to live NASA data without reloading. An offline package covers the five test objects.
- **Scientific honesty:** saturated objects are marked with contamination flags, and synthetic data is always labeled as synthetic.
- **Easy updates:** new SPHEREx releases appear automatically through IRSA's services.
- **Accessibility and design:** bilingual, keyboard-friendly and high-contrast, refined with feedback from mentors and the team.

---

## Technical documentation

### Tech stack

| Layer | Tools |
|---|---|
| Front end | React, TypeScript and Vite. No UI or chart libraries: charts, timeline and galaxy are hand-built with SVG and Canvas |
| SPHEREx API | Python, FastAPI and Astropy: cutouts, epoch stacks, 102-band spectra, light curves, file cache |
| Live queries | Python service for NASA/IPAC IRSA (SPHEREx SIA2 DR1 + QR3, AllWISE) and MAST (Gaia DR3) |
| ORBITAL | Node.js server and `/api/v1` API, Canvas 2D front end |
| Data | MySQL 8.4 (catalog and orbits) |
| Serving | Nginx as the single entry point; Caddy for automatic HTTPS; Docker Compose |
| Testing | Node's test runner and Playwright |
| Hosting (hackathon) | Azure free-tier VM at [cygnusx.earth](https://cygnusx.earth) |

No special hardware: the app runs in any modern browser.

### Architecture

```
browser ──► web (Nginx :8080)
             ├─ /                     React viewer (static build)
             ├─ /orbital/  ─┐
             ├─ /api/v1/   ─┴─► orbital (Node.js) ─► python (Gaia/WISE/IRSA queries) ─┐
             ├─ /api/      ───► backend (FastAPI: images, spectra, cache)             ├─► mysql
             └─ /docs      ───► backend (interactive API docs)                         ┘
```

| Service | Folder | Purpose |
|---|---|---|
| `web` | `viewer/` | React viewer + Nginx, the **only door** to the outside |
| `backend` | `Backend/` | SPHEREx cutouts, 102-band spectra, Gaia/WISE for the viewer. Uses `Database/scripts` |
| `orbital` | `orbital/` | Simulator (`public/`) and `/api/v1` API (`server/`) |
| `python` | `python/` | Live queries to Gaia (MAST), WISE and SPHEREx (IRSA); loads the catalog into MySQL |
| `mysql` | `Database/mysql/schema.sql` | Schema created automatically on first start |
| `caddy` (optional) | `deploy/Caddyfile` | Automatic HTTPS in front of `web` (profile `https`) |

Only `web` (8080), ORBITAL (3010) and MySQL (`127.0.0.1:3307`, for inspecting it with a client) are published; everything else stays on Docker's internal network.

The interactive API docs (FastAPI/Swagger) are served at `/docs`:

![SPHEREx API docs](docs/screenshots/24-api-docs.png)

### Running it

One program, one command, one address:

```bash
docker compose up --build
```

Open **http://localhost:8080**. The first run takes a few minutes (it builds the viewer and installs Astropy and friends).

| Address | What it is |
|---|---|
| `http://localhost:8080/` | **CygnusX**, one program with two sections (selector at the top: *Sky images* · *Solar system*) |
| ↳ *Sky images* | SPHEREx viewer: images played as a video, 102-band spectrum, light curve, Gaia/WISE layers |
| ↳ *Solar system* (`/?view=orbital`) | ORBITAL inside the same interface |
| `http://localhost:8080/orbital/` | ORBITAL as a standalone page |
| `http://localhost:3010/` | Same ORBITAL, direct access (redirects to `/orbital/`) |
| `http://localhost:8080/api/…` | SPHEREx API (FastAPI) |
| `http://localhost:8080/docs` | Interactive SPHEREx API docs |
| `http://localhost:8080/api/v1/…` | ORBITAL API (status, orbits, live Gaia/WISE/SPHEREx, catalog stored in MySQL) |

### Day-to-day use

```bash
docker compose up -d --build     # run in the background
docker compose ps                # status and healthchecks
docker compose logs -f backend   # logs for one service
docker compose down              # stop (keeps MySQL and the cache)
docker compose down -v           # stop and DELETE MySQL and the cache
```

### Configuration (optional)

Set these in a `.env` file at the repo root:

| Variable | Default | Meaning |
|---|---|---|
| `WEB_PORT` | `8080` | Public port of `web` |
| `ORBITAL_PORT` | `3010` | Direct port for ORBITAL |
| `MYSQL_HOST_PORT` | `3307` | MySQL port on `127.0.0.1` |
| `CYGNUSX_OFFLINE` | `0` | `1` = no internet: serves only cached data. The demo package (`Backend/offline/demo_cache.tar.gz`) covers the 5 test objects at their home-screen positions with a 10′ field; any other coordinate returns 503 immediately |
| `CYGNUSX_DOWNLOAD_WORKERS` | `8` | Parallel downloads from IRSA |
| `VITE_USE_MOCK` | `true` | Viewer's initial data source. `true` = **Simulated** (instant, synthetic); `false` = real data from the backend. The **Simulated \| Real** toggle switches it without rebuilding (remembered in the browser; also `?data=real`) |
| `VITE_API_URL` | empty | Backend base URL when the viewer is hosted separately (e.g. on Vercel). Leave empty when served by the bundled Nginx |
| `VITE_MODEL_URL` | empty | Only to embed ANOTHER external model in the viewer (ORBITAL is already a section). See `docs/INTEGRACION_MODELO.md` |
| `DOMAIN` | `localhost` | Domain for Caddy's HTTPS certificate |

Change the MySQL passwords before publishing to the internet.

Publishing with a domain and automatic HTTPS (how [cygnusx.earth](https://cygnusx.earth) was deployed):

```bash
DOMAIN=cygnusx.earth docker compose --profile https up -d
```

### Operating notes

- A new (uncached) coordinate takes **1–3 min** the first time, because it downloads cutouts from IRSA; afterwards it responds in under 0.1 s from the `spherex_cache` volume.
- IRSA and the Gaia archive fail intermittently; the backend retries and uses a backup Gaia source (see `Backend/README.md`).
- In Real mode the backend renders images for *All* and detectors 1–6. *Single band* and *False color* images are rendered in Simulated mode; the 102-band information in Real mode comes through the spectrum.
- MySQL is optional for the viewer: ORBITAL opens and works even while the database is still starting.
- Barnard's Star, R Draconis and most of RW Aurigae saturate SPHEREx: they are shown with a contamination flag.

### Tests

```bash
node --test tests/*.test.mjs        # orbital math and object detail cards
python tests/browser-smoke.py       # ORBITAL simulator in Chromium (requires playwright)
```

### Repository layout

```
docker-compose.yml   one-command stack          deploy/Caddyfile   HTTPS for a public domain
viewer/    SPHEREx viewer (React + Vite) + Dockerfile + nginx.conf (single entry point)
orbital/   ORBITAL simulator (public/) + Node API (server/)
Backend/   SPHEREx API (FastAPI)                python/    live queries + catalog seed
Database/  Gaia/SPHEREx scripts, docs and mysql/schema.sql            catalog/   API catalog
docs/      project context, external model integration, screenshots   tests/
legacy/    earlier prototype and Vite template (no longer used; kept for history)
```

Viewer ⇄ external model integration via `postMessage`: `docs/INTEGRACION_MODELO.md`.

---

<details>
<summary><sub>About the repository name</sub></summary>

<sub>*Xtremis* was the project's codename during the hackathon, which is why the repository (and the logo in the screenshots, taken from the deployment) still say Xtremis. The project's name is CygnusX, and the repository will be renamed to CygnusX later.</sub>

</details>
