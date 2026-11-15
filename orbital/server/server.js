// ORBITAL (Node.js): /api/v1 API (MySQL + proxy to the Python query service) and 2D simulator at /orbital/.
import 'dotenv/config';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import express from 'express';
import cors from 'cors';
import mysql from 'mysql2/promise';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PY = process.env.PYTHON_SERVICE_URL || 'http://127.0.0.1:8001';

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST || '127.0.0.1',
  port: Number(process.env.MYSQL_PORT || 3306),
  user: process.env.MYSQL_USER || 'astro',
  password: process.env.MYSQL_PASSWORD || '',
  database: process.env.MYSQL_DATABASE || 'astro',
  connectionLimit: 10,
});

const app = express();
app.set('trust proxy', 1); // behind Caddy/Nginx
// CORS_ORIGIN: '*' or a comma-separated list (e.g. https://astro.mydomain.com)
const origins = (process.env.CORS_ORIGIN || '*').split(',').map((s) => s.trim()).filter(Boolean);
app.use(cors({ origin: origins.includes('*') ? true : origins }));
app.use(express.json());
// The simulator lives at /orbital/ (so it shares one domain with the SPHEREx viewer).
const PUBLIC_DIR = process.env.WEB_ROOT || path.join(__dirname, '../public');
app.use('/orbital', express.static(PUBLIC_DIR));
app.get('/', (_req, res) => res.redirect('/orbital/'));
// Reference values let the explorer open even if MySQL has not started yet.
const ORBITS = [
  { name:'Mercury', a_au:.387, e:.2056, i_deg:7, node_deg:48.33, peri_deg:29.12, color:'#b5b5b5' },
  { name:'Venus', a_au:.723, e:.0068, i_deg:3.39, node_deg:76.68, peri_deg:54.88, color:'#e6c36a' },
  { name:'Earth', a_au:1, e:.0167, i_deg:0, node_deg:0, peri_deg:102.94, color:'#4f9dff' },
  { name:'Mars', a_au:1.524, e:.0934, i_deg:1.85, node_deg:49.56, peri_deg:286.5, color:'#e0643c' },
  { name:'Jupiter', a_au:5.203, e:.0484, i_deg:1.3, node_deg:100.46, peri_deg:273.87, color:'#d9a066' },
  { name:'Saturn', a_au:9.537, e:.0539, i_deg:2.49, node_deg:113.66, peri_deg:339.39, color:'#e3cf9a' },
];

const num = (v, d) => (v === undefined || v === '' || Number.isNaN(Number(v)) ? d : Number(v));
const wrap = (fn) => (req, res) => fn(req, res).catch((e) => res.status(500).json({ error: e.message }));

// ---- Python proxy: live queries to IRSA / MAST ---------------------------------------------
async function proxy(pathname, req, res) {
  const qs = new URLSearchParams(req.query).toString();
  const controller = new AbortController();
  const configuredTimeout = Number(process.env.UPSTREAM_TIMEOUT_MS || 40000);
  const timeoutMs = Math.max(5000, Math.min(Number.isFinite(configuredTimeout) ? configuredTimeout : 40000, 40000));
  const timeout = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const r = await fetch(`${PY}${pathname}?${qs}`, { signal: controller.signal, headers: { accept: 'application/json' } });
    const body = await r.json().catch(() => ({ error: `Non-JSON response from the query service (${r.status}).` }));
    res.status(r.status).json(body);
  } catch (e) {
    const timedOut = e.name === 'AbortError';
    res.status(timedOut ? 504 : 502).json({ error: timedOut
      ? `The external query exceeded ${Math.round(timeoutMs / 1000)} s. Check DNS/HTTPS connectivity and try a 0.03° radius with 100 rows.`
      : `Query service unavailable: ${e.message}` });
  } finally { clearTimeout(timeout); }
}
app.get('/api/v1/connectivity', wrap(async (_req, res) => {
  const r = await fetch(`${PY}/connectivity`, { signal: AbortSignal.timeout(10000), headers: { accept: 'application/json' } });
  const body = await r.json().catch(() => ({}));
  res.status(r.status).json(body);
}));
app.get('/api/v1/gaia/stars', wrap((req, res) => proxy('/gaia/stars', req, res)));
app.get('/api/v1/gaia/diagnostic', wrap((req, res) => proxy('/gaia/diagnostic', req, res)));
app.get('/api/v1/wise/sources', wrap((req, res) => proxy('/wise/sources', req, res)));
app.get('/api/v1/spherex/images', wrap((req, res) => proxy('/spherex/images', req, res)));
app.get('/api/v1/status', async (_req, res) => {
  let database = false, python = false;
  try { await pool.query('SELECT 1'); database = true; } catch {}
  try { const r = await fetch(`${PY}/health`, { signal: AbortSignal.timeout(3000) }); python = r.ok; } catch {}
  res.status(python ? 200 : 503).json({ ok: python, database, storage: database, query_service: python, upstreams: { gaia: { provider: 'MAST Gaia DR3 TAP', configured: true }, wise: { provider: 'IRSA AllWISE SCS', configured: true }, spherex: { provider: 'IRSA SPHEREx SIA2 (DR1 + QR3)', configured: true } } });
});

// ---- Data already stored in MySQL (ra/dec box filter) --------------------------------------
const STORED = {
  gaia_stars: { ra: 'ra', dec: '`dec`', order: 'phot_g_mean_mag' },
  wise_sources: { ra: 'ra', dec: '`dec`', order: 'w1mpro' },
  spherex_images: { ra: 'query_ra', dec: 'query_dec', order: 't_obs_mjd' },
};
app.get('/api/v1/stored/:table', wrap(async (req, res) => {
  const t = STORED[req.params.table];
  if (!t) return res.status(404).json({ error: `Unknown table. Use: ${Object.keys(STORED).join(', ')}` });
  const ra = num(req.query.ra, null), dec = num(req.query.dec, null);
  const r = num(req.query.radius, 1), limit = Math.min(num(req.query.limit, 2000), 20000);
  let sql = `SELECT * FROM ${req.params.table}`;
  const args = [];
  if (ra !== null && dec !== null) {
    sql += ` WHERE ${t.dec} BETWEEN ? AND ? AND ${t.ra} BETWEEN ? AND ?`;
    const k = r / Math.max(Math.cos((dec * Math.PI) / 180), 0.01);
    args.push(dec - r, dec + r, ra - k, ra + k);
  }
  sql += ` ORDER BY ${t.order} LIMIT ?`;
  args.push(limit);
  const [rows] = await pool.query(sql, args);
  res.json({ count: rows.length, rows });
}));

// ---- API catalog and auxiliary data ---------------------------------------------------------
app.get('/api/v1/catalog', wrap(async (req, res) => {
  const where = [], args = [];
  if (req.query.mission) { where.push('mission = ?'); args.push(req.query.mission); }
  if (req.query.category) { where.push('category = ?'); args.push(req.query.category); }
  try {
    const [rows] = await pool.query(
      `SELECT * FROM api_services ${where.length ? 'WHERE ' + where.join(' AND ') : ''} ORDER BY mission, slug`, args);
    res.json({ count: rows.length, rows });
  } catch { res.status(503).json({ error: 'The API catalog requires MySQL to be running.' }); }
}));

app.get('/api/v1/orbits', wrap(async (_req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM orbital_bodies ORDER BY a_au');
    res.json({ count: rows.length, rows });
  } catch { res.json({ count: ORBITS.length, rows: ORBITS, source: 'local-fallback' }); }
}));

app.get('/api/v1/spherex/bands', wrap(async (_req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM spherex_bands ORDER BY lambda_min');
    res.json({ count: rows.length, rows });
  } catch {
    const rows = [
      ['SPHEREx-D1',.75,1.09,39],['SPHEREx-D2',1.10,1.62,41],['SPHEREx-D3',1.63,2.41,41],
      ['SPHEREx-D4',2.42,3.82,35],['SPHEREx-D5',3.83,4.41,112],['SPHEREx-D6',4.42,5,128],
    ].map(([bandpass,lambda_min,lambda_max,resolving_power])=>({bandpass,lambda_min,lambda_max,resolving_power}));
    res.json({ count: rows.length, rows, source: 'local-fallback' });
  }
}));

// ---- URL builders (no external requests) ---------------------------------------------------
app.get('/api/v1/spherex/cutout-url', (req, res) => {
  const { access_url } = req.query;
  if (!access_url || !String(access_url).startsWith('https://irsa.ipac.caltech.edu/'))
    return res.status(400).json({ error: 'access_url must be an irsa.ipac.caltech.edu URL' });
  const ra = num(req.query.ra, null), dec = num(req.query.dec, null), size = num(req.query.size, 0.01);
  if (ra === null || dec === null) return res.status(400).json({ error: 'ra and dec are required' });
  res.json({ url: `${access_url}?center=${ra},${dec}d&size=${size}` });
});

app.get('/api/v1/wise/unwise-cutout-url', (req, res) => {
  const ra = num(req.query.ra, null), dec = num(req.query.dec, null);
  if (ra === null || dec === null) return res.status(400).json({ error: 'ra and dec are required' });
  // The unWISE page documents allwise, neo1 and neo2; other versions (neo3-neo6) appear in third-party code.
  const version = ['allwise', 'neo1', 'neo2', 'neo3', 'neo4', 'neo5', 'neo6'].includes(req.query.version)
    ? req.query.version : 'neo1';
  const size = Math.min(num(req.query.size, 100), 1024);
  const bands = ['1', '2', '12'].includes(req.query.bands) ? req.query.bands : '12';
  res.json({ url: `https://unwise.me/cutout_fits?version=${version}&ra=${ra}&dec=${dec}&size=${size}&bands=${bands}` });
});

// WiseView shows unWISE images (it is not a catalog API); build a link
// with coordinates to save the researcher manual steps.
app.get('/api/v1/wise/wiseview-link', (req, res) => {
  const ra = num(req.query.ra, null), dec = num(req.query.dec, null);
  const url = new URL('http://byw.tools/wiseview');
  if (ra !== null) url.searchParams.set('ra', String(ra));
  if (dec !== null) url.searchParams.set('dec', String(dec));
  res.json({ url: url.toString(), note: 'WiseView shows unWISE image blinks; source searches use IRSA.' });
});

app.get('/health', (_req, res) => res.json({ ok: true, service: 'gateway' }));

app.listen(num(process.env.PORT, 3010), '0.0.0.0', () => console.log(`ORBITAL Gateway at http://localhost:${num(process.env.PORT, 3010)}`));
