// El estado del visor vive en la URL para poder compartir e incrustar:
//   ?ra=133.7951&dec=-7.2451&fov=10&det=6&mode=diff&name=WISE%200855
//   det = all | 1…6 (detector) | b1…b102 (banda) | rgb (color falso)

import { isChannel, type Channel } from './detectors';

export type ViewMode = 'animate' | 'diff' | 'sum';

export interface ViewParams {
  ra: number;
  dec: number;
  fov: number; // minutos de arco
  det: Channel;
  mode: ViewMode;
  name?: string;
}

export const FOV_OPTIONS = [5, 10, 20, 40];
export const DEFAULT_FOV = 10;

const MODES: ViewMode[] = ['animate', 'diff', 'sum'];

export function readParams(search: string = window.location.search): ViewParams | null {
  const q = new URLSearchParams(search);
  const ra = Number(q.get('ra'));
  const dec = Number(q.get('dec'));
  if (!q.has('ra') || !q.has('dec') || !Number.isFinite(ra) || !Number.isFinite(dec)) return null;
  if (ra < 0 || ra >= 360 || dec < -90 || dec > 90) return null;

  const fovRaw = Number(q.get('fov'));
  const fov = FOV_OPTIONS.includes(fovRaw) ? fovRaw : DEFAULT_FOV;
  const detRaw = q.get('det');
  const det: Channel = detRaw && isChannel(detRaw) ? detRaw : 'all';
  const modeRaw = q.get('mode') as ViewMode | null;
  const mode = modeRaw && MODES.includes(modeRaw) ? modeRaw : 'animate';
  const name = q.get('name') ?? undefined;
  return { ra, dec, fov, det, mode, name: name || undefined };
}

export function buildQuery(p: ViewParams): string {
  const q = new URLSearchParams();
  q.set('ra', p.ra.toFixed(5));
  q.set('dec', p.dec.toFixed(5));
  q.set('fov', String(p.fov));
  q.set('det', p.det);
  q.set('mode', p.mode);
  if (p.name) q.set('name', p.name);
  return q.toString();
}

export function writeParams(p: ViewParams | null, push: boolean): void {
  const url = p ? `${window.location.pathname}?${buildQuery(p)}` : window.location.pathname;
  try {
    if (push) window.history.pushState(null, '', url);
    else window.history.replaceState(null, '', url);
  } catch {
    /* algunos entornos (iframes sandbox) no permiten history */
  }
}
