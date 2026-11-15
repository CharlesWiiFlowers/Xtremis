// Los 6 detectores de SPHEREx y su rango aproximado de longitud de onda (µm).
// Verificar contra el SPHEREx Explanatory Supplement antes de la entrega final.

export type DetectorId = 'all' | '1' | '2' | '3' | '4' | '5' | '6';

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

export function detectorRange(id: DetectorId): string {
  if (id === 'all') return `${WAVELENGTH_MIN}–${WAVELENGTH_MAX.toFixed(1)}`;
  const d = DETECTORS.find((x) => x.id === id)!;
  return `${d.min.toFixed(2)}–${d.max.toFixed(2)}`;
}
