// Cliente del backend real. Cada método corresponde a un endpoint documentado en README.md.

import type { FieldQuery, FrameQuery, PointQuery, SkyApi } from './types';

const BASE = (import.meta.env.VITE_API_URL ?? '').replace(/\/$/, '');

function qs(params: Record<string, string | number>): string {
  return new URLSearchParams(Object.entries(params).map(([k, v]) => [k, String(v)])).toString();
}

async function getJson<T>(path: string): Promise<T> {
  const res = await fetch(`${BASE}${path}`);
  if (!res.ok) throw new Error(`HTTP ${res.status} en ${path}`);
  return (await res.json()) as T;
}

const field = (q: FieldQuery) => ({ ra: q.ra, dec: q.dec, fov: q.fov });
const frame = (q: FrameQuery) => ({
  ...field(q),
  det: q.detector,
  epoch: q.epochId,
  mode: q.mode,
  ...(q.refEpochId ? { ref: q.refEpochId } : {}),
});
const point = (q: PointQuery) => ({
  ra: q.point.ra,
  dec: q.point.dec,
  det: q.detector,
  fra: q.field.ra,
  fdec: q.field.dec,
  ...(q.epochId ? { epoch: q.epochId } : {}),
});

export const httpApi: SkyApi = {
  resolve: (name) => getJson(`/api/resolve?${qs({ name })}`),
  getEpochs: (q) => getJson(`/api/epochs?${qs(field(q))}`),
  getFrameUrl: async (q) => `${BASE}/api/frame?${qs(frame(q))}`,
  getFlagsUrl: async (q) => `${BASE}/api/flags?${qs(frame(q))}`,
  getCatalog: (q, cat) => getJson(`/api/catalog?${qs({ ...field(q), cat })}`),
  getSpectrum: (q) => getJson(`/api/spectrum?${qs(point(q))}`),
  getLightCurve: (q) => getJson(`/api/lightcurve?${qs(point(q))}`),
};
