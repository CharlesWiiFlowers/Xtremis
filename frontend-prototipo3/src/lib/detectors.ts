// Detectores, 102 bandas y "canales" de visualización.
//
// SPHEREx tiene 6 detectores; cada uno se divide en 17 canales espectrales → 6 × 17 = 102 bandas
// entre 0.75 y 5.0 µm. Los rangos y centros aquí son APROXIMADOS (espaciado logarítmico dentro de cada
// detector): verificarlos contra el SPHEREx Explanatory Supplement antes de la entrega final.

export type DetectorId = 'all' | '1' | '2' | '3' | '4' | '5' | '6';

/**
 * Qué se muestra en la imagen:
 *   'all'          → suma de las 102 bandas (máxima señal)
 *   '1'…'6'        → suma de las 17 bandas de un detector
 *   'b1'…'b102'    → una sola banda
 *   'rgb'          → color falso: azul = detectores 1–2, verde = 3–4, rojo = 5–6
 */
export type Channel = DetectorId | 'rgb' | `b${number}`;

export interface Detector {
  id: Exclude<DetectorId, 'all'>;
  min: number;
  max: number;
}

export const DETECTORS: Detector[] = [
  { id: '1', min: 0.75, max: 1.09 },
  { id: '2', min: 1.1, max: 1.62 },
  { id: '3', min: 1.63, max: 2.41 },
  { id: '4', min: 2.42, max: 3.82 },
  { id: '5', min: 3.83, max: 4.41 },
  { id: '6', min: 4.42, max: 5.0 },
];

export const WAVELENGTH_MIN = 0.75;
export const WAVELENGTH_MAX = 5.0;
export const BANDS_PER_DETECTOR = 17;
export const N_BANDS = DETECTORS.length * BANDS_PER_DETECTOR; // 102

export interface Band {
  n: number; // 1…102
  detector: Detector['id'];
  center: number; // µm
  min: number;
  max: number;
}

export const BANDS: Band[] = DETECTORS.flatMap((d, di) =>
  Array.from({ length: BANDS_PER_DETECTOR }, (_, k) => {
    const ratio = d.max / d.min;
    const lo = d.min * Math.pow(ratio, k / BANDS_PER_DETECTOR);
    const hi = d.min * Math.pow(ratio, (k + 1) / BANDS_PER_DETECTOR);
    return { n: di * BANDS_PER_DETECTOR + k + 1, detector: d.id, center: Math.sqrt(lo * hi), min: lo, max: hi };
  }),
);

export function bandOf(channel: Channel): Band | null {
  const m = /^b(\d{1,3})$/.exec(channel);
  if (!m) return null;
  return BANDS[Number(m[1]) - 1] ?? null;
}

export function isChannel(v: string): v is Channel {
  if (['all', '1', '2', '3', '4', '5', '6', 'rgb'].includes(v)) return true;
  const m = /^b(\d{1,3})$/.exec(v);
  return !!m && Number(m[1]) >= 1 && Number(m[1]) <= N_BANDS;
}

export function nearestBand(lambda: number): Band {
  return BANDS.reduce((best, b) => (Math.abs(b.center - lambda) < Math.abs(best.center - lambda) ? b : best), BANDS[0]);
}

export function detectorRange(id: DetectorId): string {
  if (id === 'all') return `${WAVELENGTH_MIN}–${WAVELENGTH_MAX.toFixed(1)}`;
  const d = DETECTORS.find((x) => x.id === id)!;
  return `${d.min.toFixed(2)}–${d.max.toFixed(2)}`;
}

/** Rango de longitud de onda (µm) que cubre un canal: [min, max]. */
export function channelRange(channel: Channel): [number, number] {
  const b = bandOf(channel);
  if (b) return [b.min, b.max];
  if (channel === 'all' || channel === 'rgb') return [WAVELENGTH_MIN, WAVELENGTH_MAX];
  const d = DETECTORS.find((x) => x.id === channel)!;
  return [d.min, d.max];
}

/**
 * Color "de mentira" para representar una longitud de onda infrarroja (invisible) en pantalla:
 * las más cortas en violeta/azul y las más largas en rojo, como un arcoíris estirado.
 */
export function wavelengthColor(lambda: number): string {
  const t = Math.min(1, Math.max(0, (Math.log(lambda) - Math.log(WAVELENGTH_MIN)) / (Math.log(WAVELENGTH_MAX) - Math.log(WAVELENGTH_MIN))));
  const hue = 265 - t * 265; // 265 (violeta) → 0 (rojo)
  return `hsl(${hue.toFixed(0)} 90% 62%)`;
}

// ---- WISE / NEOWISE (2010–2024), usado para extender la línea de tiempo antes de SPHEREx ----
export const WISE_BANDS = [
  { id: 'W1', center: 3.4 },
  { id: 'W2', center: 4.6 },
] as const;

/** Banda de NEOWISE más parecida a lo que el usuario eligió para SPHEREx. */
export function wiseBandFor(channel: Channel): 'W1' | 'W2' | 'W1+W2' | 'rgb' {
  if (channel === 'rgb') return 'rgb';
  if (channel === 'all') return 'W1+W2';
  const [lo, hi] = channelRange(channel);
  const mid = Math.sqrt(lo * hi);
  return mid < 4.0 ? 'W1' : 'W2';
}
