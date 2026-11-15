// Utilidades de coordenadas celestes (todo en grados salvo que se indique).

export interface SkyCoord {
  ra: number; // Ascensión recta, grados [0, 360)
  dec: number; // Declinación, grados [-90, 90]
}

const D2R = Math.PI / 180;

/**
 * Interpreta texto como coordenadas. Acepta:
 *   "133.795 -7.245"            (grados decimales)
 *   "08h55m10.831s -07d14m42.53s"
 *   "08:55:10.831 -07:14:42.53"
 *   "08 55 10.831 -07 14 42.53"
 * Devuelve null si el texto no son coordenadas (p. ej. un nombre).
 */
export function parseCoords(input: string): SkyCoord | null {
  const raw = input.trim();
  if (!raw) return null;
  const cleaned = raw.replace(/[hHdDmMsS°'′"″:,]/g, ' ').trim();
  if (/[^0-9+\-.\s]/.test(cleaned)) return null;
  const tokens = cleaned.split(/\s+/).filter(Boolean);
  if (tokens.some((t) => Number.isNaN(Number(t)))) return null;

  let ra: number;
  let dec: number;
  if (tokens.length === 2) {
    ra = Number(tokens[0]);
    dec = Number(tokens[1]);
  } else if (tokens.length === 6) {
    const [h, m, s, dd, dm, ds] = tokens.map(Number);
    ra = (h + m / 60 + s / 3600) * 15;
    const negative = tokens[3].startsWith('-');
    dec = (Math.abs(dd) + dm / 60 + ds / 3600) * (negative ? -1 : 1);
  } else {
    return null;
  }
  if (!(ra >= 0 && ra < 360 && dec >= -90 && dec <= 90)) return null;
  return { ra, dec };
}

const pad2 = (n: number) => String(n).padStart(2, '0');

export function formatRA(deg: number): string {
  const totalSec = Math.round((((deg % 360) + 360) % 360) / 15 * 3600 * 100) / 100;
  const h = Math.floor(totalSec / 3600);
  const m = Math.floor((totalSec - h * 3600) / 60);
  const s = totalSec - h * 3600 - m * 60;
  return `${pad2(h % 24)}h${pad2(m)}m${s.toFixed(2).padStart(5, '0')}s`;
}

export function formatDec(deg: number): string {
  const sign = deg < 0 ? '-' : '+';
  const totalSec = Math.round(Math.abs(deg) * 3600 * 10) / 10;
  const d = Math.floor(totalSec / 3600);
  const m = Math.floor((totalSec - d * 3600) / 60);
  const s = totalSec - d * 3600 - m * 60;
  return `${sign}${pad2(d)}°${pad2(m)}′${s.toFixed(1).padStart(4, '0')}″`;
}

/** Proyección gnómica: desplazamiento (arcsec) de p respecto al centro c. x = Este, y = Norte. */
export function skyToOffset(c: SkyCoord, p: SkyCoord): { x: number; y: number } {
  const a0 = c.ra * D2R;
  const d0 = c.dec * D2R;
  const a = p.ra * D2R;
  const d = p.dec * D2R;
  const cosc = Math.sin(d0) * Math.sin(d) + Math.cos(d0) * Math.cos(d) * Math.cos(a - a0);
  const x = (Math.cos(d) * Math.sin(a - a0)) / cosc;
  const y = (Math.cos(d0) * Math.sin(d) - Math.sin(d0) * Math.cos(d) * Math.cos(a - a0)) / cosc;
  return { x: (x / D2R) * 3600, y: (y / D2R) * 3600 };
}

/** Inversa de skyToOffset. */
export function offsetToSky(c: SkyCoord, x: number, y: number): SkyCoord {
  const xi = (x / 3600) * D2R;
  const eta = (y / 3600) * D2R;
  const a0 = c.ra * D2R;
  const d0 = c.dec * D2R;
  const rho = Math.hypot(xi, eta);
  if (rho === 0) return { ra: c.ra, dec: c.dec };
  const cc = Math.atan(rho);
  const dec = Math.asin(Math.cos(cc) * Math.sin(d0) + (eta * Math.sin(cc) * Math.cos(d0)) / rho);
  const ra =
    a0 +
    Math.atan2(xi * Math.sin(cc), rho * Math.cos(d0) * Math.cos(cc) - eta * Math.sin(d0) * Math.sin(cc));
  return { ra: (((ra / D2R) % 360) + 360) % 360, dec: dec / D2R };
}

/** Separación angular en arcsec (fórmula de haversine). */
export function angularSepArcsec(a: SkyCoord, b: SkyCoord): number {
  const d1 = a.dec * D2R;
  const d2 = b.dec * D2R;
  const dd = d2 - d1;
  const da = (b.ra - a.ra) * D2R;
  const h = Math.sin(dd / 2) ** 2 + Math.cos(d1) * Math.cos(d2) * Math.sin(da / 2) ** 2;
  return (2 * Math.asin(Math.min(1, Math.sqrt(h))) / D2R) * 3600;
}
