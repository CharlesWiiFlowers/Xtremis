// Conversión de coordenadas ecuatoriales (J2000) a galácticas (l, b).
// Matriz de rotación estándar (IAU 1958 / Hipparcos, J2000).

import type { SkyCoord } from './coords';

const D2R = Math.PI / 180;
const M = [
  [-0.0548755604, -0.8734370902, -0.4838350155],
  [0.4941094279, -0.44482963, 0.7469822445],
  [-0.867666149, -0.1980763734, 0.4559837762],
];

export function toGalactic({ ra, dec }: SkyCoord): { l: number; b: number } {
  const a = ra * D2R;
  const d = dec * D2R;
  const v = [Math.cos(d) * Math.cos(a), Math.cos(d) * Math.sin(a), Math.sin(d)];
  const g = M.map((row) => row[0] * v[0] + row[1] * v[1] + row[2] * v[2]);
  const l = Math.atan2(g[1], g[0]) / D2R;
  const b = Math.asin(Math.max(-1, Math.min(1, g[2]))) / D2R;
  return { l: (l + 360) % 360, b };
}
