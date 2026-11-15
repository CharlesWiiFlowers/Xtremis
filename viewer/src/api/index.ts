import { httpApi } from './http';
import { mockApi } from './mock';
import type { SkyApi } from './types';

/**
 * Fuente de datos del visor:
 *   demo  = imágenes simuladas, instantáneas (modo de la primera versión; no necesita backend)
 *   real  = backend SPHEREx (IRSA/AWS); una zona nueva puede tardar minutos
 * Se elige en el interruptor de la barra superior (se recuerda en el navegador) o con ?data=demo|real.
 * El valor inicial viene de VITE_USE_MOCK (true = demo).
 */
export type DataSource = 'demo' | 'real';
const KEY = 'xtremis-data';
const DEFAULT_SOURCE: DataSource = import.meta.env.VITE_USE_MOCK === 'false' ? 'real' : 'demo';

function readSource(): DataSource {
  try {
    const q = new URLSearchParams(window.location.search).get('data');
    if (q === 'demo' || q === 'real') {
      window.localStorage.setItem(KEY, q);
      return q;
    }
    const saved = window.localStorage.getItem(KEY);
    if (saved === 'demo' || saved === 'real') return saved;
  } catch {
    /* sin almacenamiento: se usa el valor por defecto */
  }
  return DEFAULT_SOURCE;
}

export const DATA_SOURCE: DataSource = readSource();
export const IS_MOCK = DATA_SOURCE === 'demo';

export function setDataSource(next: DataSource): void {
  try {
    window.localStorage.setItem(KEY, next);
    const u = new URL(window.location.href);
    u.searchParams.delete('data');
    window.history.replaceState(null, '', u.toString());
  } catch {
    /* ignorar */
  }
  window.location.reload();
}

export const api: SkyApi = IS_MOCK ? mockApi : httpApi;

export type * from './types';
