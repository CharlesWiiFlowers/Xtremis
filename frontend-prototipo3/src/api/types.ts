// Contrato entre el frontend y el backend. El backend de Python debe implementar
// estos endpoints (ver README.md). El modo demo (mock.ts) implementa lo mismo
// con datos simulados.

import type { SkyCoord } from '../lib/coords';
import type { Channel } from '../lib/detectors';
import type { ViewMode } from '../lib/urlState';

export interface FieldQuery {
  ra: number;
  dec: number;
  fov: number; // arcmin
}

export interface FrameQuery extends FieldQuery {
  /** Canal: all | 1…6 | b1…b102 | rgb. En épocas NEOWISE el backend usa la banda W1/W2 más cercana. */
  detector: Channel;
  /** Barrido(s) a apilar, separados por coma (p. ej. "s2,s3"). 'all' cuando mode === 'sum'. */
  epochId: string;
  mode: ViewMode;
  /** Solo para mode === 'diff': barrido(s) de referencia que se restan. */
  refEpochId?: string;
}

export interface PointQuery {
  field: FieldQuery;
  point: SkyCoord;
  detector: Channel;
  /** Época(s) que se están viendo, para ubicar estrellas que se mueven. */
  epochId?: string;
}

/** Misión que tomó las imágenes. SPHEREx desde 2025; NEOWISE (WISE) cubre 2014–2024. */
export type Mission = 'spherex' | 'neowise';

/** Una época = un barrido completo del cielo (~6 meses). */
export interface Epoch {
  id: string;
  mission: Mission;
  index: number; // número de barrido/visita dentro de su misión: 1, 2, 3…
  start: string; // ISO date
  end: string;
  mid: string;
  nExposures?: number;
}

export interface ResolvedTarget {
  name: string;
  ra: number;
  dec: number;
}

export type CatalogId = 'gaia' | 'wise';

export interface CatalogSource {
  ra: number;
  dec: number;
  id?: string;
  mag?: number;
}

export interface SpectrumPoint {
  wavelength: number; // µm
  flux: number;
  err: number;
}

export interface Spectrum {
  found: boolean;
  unit: string;
  points: SpectrumPoint[];
}

export interface LightCurvePoint {
  date: string; // ISO
  flux: number;
  err: number;
  mission?: Mission;
}

export interface LightCurve {
  found: boolean;
  unit: string;
  points: LightCurvePoint[];
}

export interface SkyApi {
  resolve(name: string): Promise<ResolvedTarget>;
  getEpochs(q: FieldQuery): Promise<Epoch[]>;
  /** URL de una imagen PNG lista para mostrar (estiramiento fijo entre épocas). */
  getFrameUrl(q: FrameQuery): Promise<string>;
  /** URL de un PNG transparente con los píxeles marcados por banderas. */
  getFlagsUrl(q: FrameQuery): Promise<string>;
  getCatalog(q: FieldQuery, cat: CatalogId): Promise<CatalogSource[]>;
  getSpectrum(q: PointQuery): Promise<Spectrum>;
  getLightCurve(q: PointQuery): Promise<LightCurve>;
}
