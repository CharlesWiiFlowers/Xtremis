// Un "cuadro" de la animación. Por defecto se agrupa por AÑO: todas las épocas de la misma misión
// cuyo punto medio cae en el mismo año calendario se apilan juntas. También se puede ver época por época.
// Las épocas de misiones distintas (NEOWISE y SPHEREx) nunca se mezclan en un mismo cuadro.

import type { Epoch, Mission } from '../api/types';

export type FrameGroup = 'year' | 'survey';

export interface Frame {
  id: string;
  kind: FrameGroup;
  mission: Mission;
  year: number;
  surveys: Epoch[];
  start: string;
  end: string;
  mid: string;
}

const ms = (iso: string) => Date.parse(iso + 'T00:00:00Z');
const iso = (t: number) => new Date(t).toISOString().slice(0, 10);
const yearOf = (e: Epoch) => new Date(ms(e.mid)).getUTCFullYear();

export function buildFrames(epochs: Epoch[], group: FrameGroup): Frame[] {
  const sorted = [...epochs].sort((a, b) => a.mid.localeCompare(b.mid));
  if (group === 'survey') {
    return sorted.map((e) => ({
      id: e.id,
      kind: 'survey',
      mission: e.mission,
      year: yearOf(e),
      surveys: [e],
      start: e.start,
      end: e.end,
      mid: e.mid,
    }));
  }
  const groups = new Map<string, Epoch[]>();
  for (const e of sorted) {
    const key = `${yearOf(e)}|${e.mission}`;
    groups.set(key, [...(groups.get(key) ?? []), e]);
  }
  return [...groups.values()]
    .map((list) => ({
      id: `y${yearOf(list[0])}-${list[0].mission}`,
      kind: 'year' as const,
      mission: list[0].mission,
      year: yearOf(list[0]),
      surveys: list,
      start: list.map((e) => e.start).sort()[0],
      end: list.map((e) => e.end).sort().slice(-1)[0],
      mid: iso(list.reduce((s, e) => s + ms(e.mid), 0) / list.length),
    }))
    .sort((a, b) => a.mid.localeCompare(b.mid));
}

/** Valor del parámetro `epoch` para la API: lista de épocas separadas por coma. */
export const frameEpochParam = (f: Frame) => f.surveys.map((s) => s.id).join(',');

/** Referencia para el modo Restar: el primer cuadro de la MISMA misión (no se restan instrumentos distintos). */
export function diffReference(frames: Frame[], current: Frame): Frame {
  return frames.find((f) => f.mission === current.mission) ?? frames[0];
}
