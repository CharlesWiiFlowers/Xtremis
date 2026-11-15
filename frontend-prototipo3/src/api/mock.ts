// MODO DEMO: simula el backend generando campos de estrellas sintéticos.
// Sirve para diseñar y probar la interfaz sin depender de IRSA ni del backend.
// Los objetos de prueba del reto se colocan en el centro con su movimiento
// propio, variabilidad y "color" infrarrojo aproximados.
//
// Línea de tiempo simulada: solo SPHEREx, desde 2025 (un barrido cada ~6 meses, 102 bandas).
// El soporte para NEOWISE (2015–2024) queda en el código pero DESACTIVADO (INCLUDE_NEOWISE = false).

import { angularSepArcsec, offsetToSky, skyToOffset, type SkyCoord } from '../lib/coords';
import { BANDS, DETECTORS, bandOf, wiseBandFor, type Channel } from '../lib/detectors';
import { TARGETS, findTargetByName, type SedType, type Target, type Variability } from '../lib/targets';
import type {
  CatalogSource,
  Epoch,
  FieldQuery,
  FrameQuery,
  LightCurve,
  Mission,
  PointQuery,
  SkyApi,
  Spectrum,
} from './types';

const N = 200; // píxeles por lado de cada imagen
const PSF_FWHM = 9; // arcsec
const NOISE = 1;
const T_REF = 2026.0; // época en la que el objeto central está exactamente en el centro
const FIELD_HALF = 1300; // arcsec: se generan estrellas en ±21′ (cubre el FOV máximo de 40′)

const pad = (n: number) => String(n).padStart(2, '0');
const shift = (iso: string, days: number) => new Date(Date.parse(iso + 'T00:00:00Z') + days * 86400000).toISOString().slice(0, 10);

/** NEOWISE observó cada zona del cielo dos veces por año hasta mediados de 2024. */
const NEOWISE_EPOCHS: Epoch[] = Array.from({ length: 2024 - 2015 + 1 }, (_, i) => 2015 + i).flatMap((y, i) =>
  [1, 7].map((month, k) => {
    const mid = `${y}-${pad(month)}-20`;
    return { id: `w${y}${k ? 'b' : 'a'}`, mission: 'neowise' as const, index: i * 2 + k + 1, start: shift(mid, -3), end: shift(mid, 3), mid, nExposures: 12 };
  }),
);

const SPHEREX_EPOCHS: Epoch[] = [
  { id: 's1', mission: 'spherex', index: 1, start: '2025-05-01', end: '2025-11-01', mid: '2025-08-01', nExposures: 14 },
  { id: 's2', mission: 'spherex', index: 2, start: '2025-11-01', end: '2026-05-01', mid: '2026-02-01', nExposures: 15 },
  { id: 's3', mission: 'spherex', index: 3, start: '2026-05-01', end: '2026-11-01', mid: '2026-08-01', nExposures: 13 },
];

/** Cambiar a true para extender la línea de tiempo hacia atrás con NEOWISE (2015–2024). */
const INCLUDE_NEOWISE = false;

const EPOCHS: Epoch[] = INCLUDE_NEOWISE ? [...NEOWISE_EPOCHS, ...SPHEREX_EPOCHS] : SPHEREX_EPOCHS;

// ---------- aleatoriedad reproducible ----------
function mulberry32(seed: number) {
  let s = seed >>> 0;
  return () => {
    s = (s + 0x6d2b79f5) | 0;
    let t = Math.imul(s ^ (s >>> 15), 1 | s);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
function hashStr(str: string): number {
  let h = 2166136261;
  for (let i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return h >>> 0;
}
function gauss(rand: () => number): number {
  let u = 0;
  while (u === 0) u = rand();
  return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * rand());
}
const wait = (ms: number) => new Promise((r) => setTimeout(r, ms));

// ---------- física de juguete ----------
const SED_WEIGHTS: Record<SedType, number[]> = {
  star: [1.0, 0.75, 0.5, 0.3, 0.2, 0.15],
  red: [0.8, 1.0, 0.9, 0.6, 0.45, 0.35],
  brown: [0.15, 0.5, 0.6, 0.25, 0.35, 0.5],
  cold: [0.0, 0.01, 0.02, 0.04, 0.12, 1.0],
};
const DET_CENTERS = DETECTORS.map((d) => (d.min + d.max) / 2);

function continuum(sed: SedType, lambda: number): number {
  const w = SED_WEIGHTS[sed];
  if (lambda <= DET_CENTERS[0]) return w[0];
  for (let i = 0; i < DET_CENTERS.length - 1; i++) {
    if (lambda <= DET_CENTERS[i + 1]) {
      const f = (lambda - DET_CENTERS[i]) / (DET_CENTERS[i + 1] - DET_CENTERS[i]);
      return w[i] * (1 - f) + w[i + 1] * f;
    }
  }
  return w[w.length - 1];
}

function absorption(sed: SedType, lambda: number): number {
  const dip = (center: number, width: number, depth: number) =>
    1 - depth * Math.exp(-(((lambda - center) / width) ** 2));
  switch (sed) {
    case 'cold':
      return dip(3.3, 0.25, 0.85) * dip(4.35, 0.1, 0.4); // CH4, CO2
    case 'brown':
      return dip(1.4, 0.08, 0.5) * dip(2.2, 0.15, 0.45) * dip(3.3, 0.25, 0.7); // H2O, CH4
    case 'red':
      return dip(2.7, 0.2, 0.15) * dip(4.6, 0.12, 0.12); // H2O, CO
    default:
      return 1;
  }
}

/** Brillo relativo de un tipo de estrella en una longitud de onda (con sus bandas de absorción). */
function lambdaWeight(sed: SedType, lambda: number): number {
  return continuum(sed, lambda) * absorption(sed, lambda);
}

/** Brillo relativo de una estrella en el canal elegido, según la misión que observa. */
function chanWeight(sed: SedType, channel: Channel, mission: Mission): number {
  if (mission === 'neowise') {
    const w1 = lambdaWeight(sed, 3.4);
    const w2 = lambdaWeight(sed, 4.6);
    const wb = wiseBandFor(channel);
    return wb === 'W1' ? w1 : wb === 'W2' ? w2 : (w1 + w2) / 2;
  }
  const w = SED_WEIGHTS[sed];
  if (channel === 'all' || channel === 'rgb') return w.reduce((a, b) => a + b, 0) / w.length;
  const band = bandOf(channel);
  if (band) return lambdaWeight(sed, band.center);
  return w[Number(channel) - 1];
}

/** Pesos de los 3 colores del modo color falso: [rojo, verde, azul]. */
function rgbWeights(sed: SedType, mission: Mission): [number, number, number] {
  if (mission === 'neowise') {
    const w1 = lambdaWeight(sed, 3.4);
    const w2 = lambdaWeight(sed, 4.6);
    return [w2, (w1 + w2) / 2, w1];
  }
  const w = SED_WEIGHTS[sed];
  return [(w[4] + w[5]) / 2, (w[2] + w[3]) / 2, (w[0] + w[1]) / 2];
}

/** Ruido: una sola banda recibe menos luz que la suma de muchas, por eso se ve más "granulada". */
function noiseFor(channel: Channel, mission: Mission): number {
  const base = mission === 'neowise' ? 1.25 : 1;
  if (bandOf(channel) && mission === 'spherex') return base * 1.7;
  if (channel !== 'all' && channel !== 'rgb') return base * 1.15;
  return base;
}

function decimalYear(iso: string): number {
  const d = new Date(iso + 'T00:00:00Z');
  const y = d.getUTCFullYear();
  const start = Date.UTC(y, 0, 1);
  const end = Date.UTC(y + 1, 0, 1);
  return y + (d.getTime() - start) / (end - start);
}

function varFactor(v: Variability | undefined, tYear: number): number {
  if (!v) return 1;
  const days = (tYear - 2025) * 365.25;
  if (v.periodDays > 0) return 1 + v.amp * Math.sin((2 * Math.PI * days) / v.periodDays);
  return 1 + v.amp * (0.6 * Math.sin((2 * Math.PI * days) / 37) + 0.4 * Math.sin((2 * Math.PI * days) / 11.3 + 1));
}

// ---------- campos de estrellas ----------
interface MockStar {
  x0: number; // arcsec al Este del centro en T_REF
  y0: number; // arcsec al Norte
  flux: number;
  sed: SedType;
  pm: { ra: number; dec: number };
  variability?: Variability;
}

interface MockField {
  key: string;
  center: SkyCoord;
  seed: number;
  stars: MockStar[];
  target?: Target;
}

const fieldCache = new Map<string, MockField>();

function getField(c: SkyCoord): MockField {
  const key = `${c.ra.toFixed(4)},${c.dec.toFixed(4)}`;
  const cached = fieldCache.get(key);
  if (cached) return cached;

  const seed = hashStr(key);
  const r = mulberry32(seed);
  const stars: MockStar[] = [];
  for (let i = 0; i < 900; i++) {
    const roll = r();
    stars.push({
      x0: (r() * 2 - 1) * FIELD_HALF,
      y0: (r() * 2 - 1) * FIELD_HALF,
      flux: Math.pow(10, r() * r() * 2.4) * 0.9,
      sed: roll < 0.55 ? 'star' : roll < 0.94 ? 'red' : 'brown',
      pm: { ra: gauss(r) * 0.03, dec: gauss(r) * 0.03 },
    });
  }
  const target = TARGETS.find((t) => angularSepArcsec(t, c) < 90);
  if (target) {
    stars.push({
      x0: 0,
      y0: 0,
      flux: target.sed === 'cold' ? 70 : target.kind === 'variable' ? 150 : 120,
      sed: target.sed,
      pm: target.pm ?? { ra: 0, dec: 0 },
      variability: target.variability,
    });
  }
  const field: MockField = { key, center: c, seed, stars, target };
  fieldCache.set(key, field);
  return field;
}

function starPos(s: MockStar, tYear: number) {
  const dt = tYear - T_REF;
  return { x: s.x0 + s.pm.ra * dt, y: s.y0 + s.pm.dec * dt };
}

function renderImage(
  field: MockField,
  fov: number,
  tYear: number,
  mission: Mission,
  noise: number,
  seedKey: string,
  weight: (s: MockStar) => number,
): Float32Array {
  const scale = (fov * 60) / N; // arcsec por píxel
  const fwhm = mission === 'neowise' ? 6.5 : PSF_FWHM;
  const sig = Math.max(0.7, fwhm / 2.355 / scale);
  const img = new Float32Array(N * N);
  const r = mulberry32(field.seed ^ hashStr(`${seedKey}|${tYear.toFixed(3)}|${fov}`));
  for (let i = 0; i < img.length; i++) img[i] = gauss(r) * noise * NOISE;

  const halfView = fov * 30 + 4 * sig * scale;
  const box = Math.ceil(4 * sig);
  for (const s of field.stars) {
    const p = starPos(s, tYear);
    if (Math.abs(p.x) > halfView || Math.abs(p.y) > halfView) continue;
    const peak = s.flux * weight(s) * varFactor(s.variability, tYear) * 0.6;
    if (peak < 0.05) continue;
    const cx = N / 2 - p.x / scale;
    const cy = N / 2 - p.y / scale;
    const x0 = Math.max(0, Math.floor(cx - box));
    const x1 = Math.min(N - 1, Math.ceil(cx + box));
    const y0 = Math.max(0, Math.floor(cy - box));
    const y1 = Math.min(N - 1, Math.ceil(cy + box));
    for (let y = y0; y <= y1; y++) {
      for (let x = x0; x <= x1; x++) {
        const d2 = (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2;
        img[y * N + x] += peak * Math.exp(-d2 / (2 * sig * sig));
      }
    }
  }
  return img;
}

/** Devuelve 1 plano (gris) o 3 planos [R, G, B] para el color falso. */
function renderEpoch(field: MockField, fov: number, channel: Channel, e: Epoch): Float32Array[] {
  const t = decimalYear(e.mid);
  const noise = noiseFor(channel, e.mission);
  if (channel === 'rgb') {
    return [0, 1, 2].map((k) =>
      renderImage(field, fov, t, e.mission, noise, `rgb${k}`, (s) => rgbWeights(s.sed, e.mission)[k]),
    );
  }
  return [renderImage(field, fov, t, e.mission, noise, channel, (s) => chanWeight(s.sed, channel, e.mission))];
}

// ---------- imagen -> PNG ----------
const clamp01 = (v: number) => Math.min(1, Math.max(0, v));

function toDataUrl(rgba: Uint8ClampedArray<ArrayBuffer>): string {
  const canvas = document.createElement('canvas');
  canvas.width = N;
  canvas.height = N;
  const ctx = canvas.getContext('2d')!;
  ctx.putImageData(new ImageData(rgba, N, N), 0, 0);
  return canvas.toDataURL('image/png');
}

/** Estiramiento asinh FIJO: el mismo para todas las épocas, así el parpadeo no inventa cambios. */
function stretchSingle(img: Float32Array): Uint8ClampedArray<ArrayBuffer> {
  const out = new Uint8ClampedArray(N * N * 4);
  const norm = Math.asinh(120 / 2);
  for (let i = 0; i < img.length; i++) {
    const v = Math.pow(clamp01(Math.asinh(Math.max(0, img[i] - 0.8) / 2) / norm), 0.95);
    out[i * 4] = 10 + v * 225;
    out[i * 4 + 1] = 12 + v * 230;
    out[i * 4 + 2] = 20 + v * 235;
    out[i * 4 + 3] = 255;
  }
  return out;
}

/** Color falso: cada plano se estira igual que en gris y se asigna a rojo, verde o azul. */
function stretchRgb(planes: Float32Array[]): Uint8ClampedArray<ArrayBuffer> {
  const out = new Uint8ClampedArray(N * N * 4);
  const norm = Math.asinh(90 / 2);
  for (let i = 0; i < N * N; i++) {
    for (let k = 0; k < 3; k++) {
      const v = Math.pow(clamp01(Math.asinh(Math.max(0, planes[k][i] - 0.8) / 2) / norm), 0.9);
      out[i * 4 + k] = 8 + v * 247;
    }
    out[i * 4 + 3] = 255;
  }
  return out;
}

/** Resta: azul = brillo/posición nueva, dorado = brillo/posición anterior. */
function stretchDiff(diff: Float32Array): Uint8ClampedArray<ArrayBuffer> {
  const out = new Uint8ClampedArray(N * N * 4);
  const norm = Math.asinh(60 / 2);
  for (let i = 0; i < diff.length; i++) {
    const d = Math.sign(diff[i]) * Math.max(0, Math.abs(diff[i]) - 2); // oculta el ruido
    const s = Math.max(-1, Math.min(1, Math.asinh(d / 2) / norm));
    const a = Math.abs(s);
    const [cr, cg, cb] = s >= 0 ? [124, 183, 255] : [242, 179, 107];
    out[i * 4] = 18 + a * (cr - 18);
    out[i * 4 + 1] = 22 + a * (cg - 22);
    out[i * 4 + 2] = 32 + a * (cb - 32);
    out[i * 4 + 3] = 255;
  }
  return out;
}

const frameCache = new Map<string, string>();
const flagCache = new Map<string, string>();

function epochIds(param: string): Epoch[] {
  if (param === 'all') return EPOCHS;
  const list = EPOCHS.filter((e) => param.split(',').includes(e.id));
  return list.length ? list : [EPOCHS[EPOCHS.length - 1]];
}

function epochYear(param: string): number {
  const list = epochIds(param);
  return list.reduce((s, e) => s + decimalYear(e.mid), 0) / list.length;
}

/** Apila (promedia) las épocas indicadas: así se forma un cuadro "por año". */
function renderStack(field: MockField, fov: number, channel: Channel, param: string): Float32Array[] {
  const list = epochIds(param);
  const nPlanes = channel === 'rgb' ? 3 : 1;
  const acc = Array.from({ length: nPlanes }, () => new Float32Array(N * N));
  for (const e of list) {
    const planes = renderEpoch(field, fov, channel, e);
    planes.forEach((img, k) => {
      for (let i = 0; i < img.length; i++) acc[k][i] += img[i] / list.length;
    });
  }
  return acc;
}

function buildFrame(q: FrameQuery): Float32Array[] {
  return renderStack(getField(q), q.fov, q.detector, q.mode === 'sum' ? 'all' : q.epochId);
}

/** Un solo plano con la luz total (para banderas y resta en color falso). */
const luminance = (planes: Float32Array[]) => {
  if (planes.length === 1) return planes[0];
  const out = new Float32Array(N * N);
  for (let i = 0; i < out.length; i++) out[i] = (planes[0][i] + planes[1][i] + planes[2][i]) / 3;
  return out;
};

const frameKey = (q: FrameQuery) =>
  `${q.ra.toFixed(5)}|${q.dec.toFixed(5)}|${q.fov}|${q.detector}|${q.epochId}|${q.mode}|${q.refEpochId ?? ''}`;

// ---------- API simulada ----------
export const mockApi: SkyApi = {
  async resolve(name) {
    await wait(250);
    const t = findTargetByName(name);
    if (!t) throw new Error('not found');
    return { name: t.name, ra: t.ra, dec: t.dec };
  },

  async getEpochs() {
    await wait(200);
    return EPOCHS;
  },

  async getFrameUrl(q) {
    const key = frameKey(q);
    const hit = frameCache.get(key);
    if (hit) return hit;
    await wait(60);
    let rgba: Uint8ClampedArray<ArrayBuffer>;
    if (q.mode === 'diff') {
      const field = getField(q);
      const cur = luminance(renderStack(field, q.fov, q.detector, q.epochId));
      const ref = luminance(renderStack(field, q.fov, q.detector, q.refEpochId ?? EPOCHS[0].id));
      const diff = new Float32Array(N * N);
      for (let i = 0; i < diff.length; i++) diff[i] = cur[i] - ref[i];
      rgba = stretchDiff(diff);
    } else {
      const planes = buildFrame(q);
      rgba = planes.length === 3 ? stretchRgb(planes) : stretchSingle(planes[0]);
    }
    const url = toDataUrl(rgba);
    frameCache.set(key, url);
    return url;
  },

  async getFlagsUrl(q) {
    const key = frameKey(q);
    const hit = flagCache.get(key);
    if (hit) return hit;
    await wait(40);
    const img = luminance(buildFrame({ ...q, mode: q.mode === 'diff' ? 'animate' : q.mode }));
    const r = mulberry32(hashStr(key));
    const out = new Uint8ClampedArray(N * N * 4);
    const mark = (i: number) => {
      out[i * 4] = 255;
      out[i * 4 + 1] = 60;
      out[i * 4 + 2] = 90;
      out[i * 4 + 3] = 150;
    };
    for (let i = 0; i < img.length; i++) if (img[i] > 70) mark(i); // saturación
    for (let k = 0; k < 25; k++) mark(Math.floor(r() * N * N)); // píxeles calientes / rayos cósmicos
    const url = toDataUrl(out);
    flagCache.set(key, url);
    return url;
  },

  async getCatalog(q: FieldQuery, cat) {
    await wait(150);
    const field = getField(q);
    const half = q.fov * 30;
    const tYear = cat === 'gaia' ? 2016.0 : 2010.5;
    const out: CatalogSource[] = [];
    for (const s of field.stars) {
      // Gaia es óptico: no ve enanas marrones frías. WISE sí.
      if (cat === 'gaia' && (s.flux < 6 || s.sed === 'cold' || s.sed === 'brown')) continue;
      if (cat === 'wise' && s.flux < 12) continue;
      const p = starPos(s, tYear);
      if (Math.abs(p.x) > half || Math.abs(p.y) > half) continue;
      out.push(offsetToSky(field.center, p.x, p.y));
    }
    return out;
  },

  async getSpectrum(q: PointQuery): Promise<Spectrum> {
    await wait(250);
    const field = getField(q.field);
    const star = nearestStar(field, q);
    const r = mulberry32(hashStr(`spec|${q.point.ra}|${q.point.dec}`));
    const tYear = pointYear(q);
    const points = BANDS.map((b) => {
      const f = star ? star.flux * 0.6 * lambdaWeight(star.sed, b.center) * varFactor(star.variability, tYear) : 0;
      const err = 1.2 + 0.03 * f;
      return { wavelength: b.center, flux: f + gauss(r) * err, err };
    });
    return { found: !!star, unit: 'relativo', points };
  },

  async getLightCurve(q: PointQuery): Promise<LightCurve> {
    await wait(250);
    const field = getField(q.field);
    const star = nearestStar(field, q);
    const r = mulberry32(hashStr(`lc|${q.point.ra}|${q.point.dec}|${q.detector}`));
    const points = EPOCHS.flatMap((e) => {
      const mid = new Date(e.mid + 'T00:00:00Z').getTime();
      // SPHEREx observa cada zona durante ~2 semanas; NEOWISE durante ~1–2 días.
      const spread = e.mission === 'spherex' ? 10 : 1.5;
      const count = e.mission === 'spherex' ? 6 : 4;
      return Array.from({ length: count }, () => {
        const t = mid + (r() * 2 - 1) * spread * 86400000;
        const iso = new Date(t).toISOString().slice(0, 10);
        const f = star
          ? star.flux * 0.6 * chanWeight(star.sed, q.detector, e.mission) * varFactor(star.variability, decimalYear(iso))
          : 0;
        const err = (e.mission === 'neowise' ? 2 : 1.5) + 0.02 * f;
        return { date: iso, flux: f + gauss(r) * err, err, mission: e.mission };
      });
    }).sort((a, b) => a.date.localeCompare(b.date));
    return { found: !!star, unit: 'relativo', points };
  },
};

function nearestStar(field: MockField, q: PointQuery): MockStar | null {
  const off = skyToOffset(field.center, q.point);
  const tYear = pointYear(q);
  let best: MockStar | null = null;
  let bestD = Math.max(2 * PSF_FWHM, ((q.field.fov * 60) / N) * 4); // tolerancia del clic
  for (const s of field.stars) {
    const p = starPos(s, tYear);
    const d = Math.hypot(p.x - off.x, p.y - off.y);
    if (d < bestD && s.flux * chanWeight(s.sed, 'all', 'spherex') > 2) {
      best = s;
      bestD = d;
    }
  }
  return best;
}

/** Año de la época que se está viendo (para ubicar estrellas que se mueven). */
function pointYear(q: PointQuery): number {
  return epochYear(q.epochId ?? SPHEREX_EPOCHS[SPHEREX_EPOCHS.length - 1].id);
}
