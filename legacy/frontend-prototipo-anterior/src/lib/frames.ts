// Un "cuadro" de la animación. Por defecto se agrupa por AÑO: todos los barridos
// de SPHEREx cuyo punto medio cae en el mismo año calendario se apilan juntos.
// También se puede ver barrido por barrido (~6 meses).

import type { Epoch } from '../api/types';

export type FrameGroup = 'year' | 'survey';

export interface Frame {
  id: string;
  kind: FrameGroup;
  year: number;
  surveys: Epoch[];
  start: string;
  end: string;
  mid: string;
}

const ms = (iso: string) => Date.parse(iso + 'T00:00:00Z');
const iso = (t: number) => new Date(t).toISOString().slice(0, 10);

export function buildFrames(epochs: Epoch[], group: FrameGroup): Frame[] {
  if (group === 'survey') {
    return epochs.map((e) => ({
      id: e.id,
      kind: 'survey',
      year: new Date(ms(e.mid)).getUTCFullYear(),
      surveys: [e],
      start: e.start,
      end: e.end,
      mid: e.mid,
    }));
  }
  const byYear = new Map<number, Epoch[]>();
  for (const e of epochs) {
    const y = new Date(ms(e.mid)).getUTCFullYear();
    byYear.set(y, [...(byYear.get(y) ?? []), e]);
  }
  return [...byYear.entries()]
    .sort(([a], [b]) => a - b)
    .map(([year, list]) => ({
      id: `y${year}`,
      kind: 'year',
      year,
      surveys: list,
      start: list.map((e) => e.start).sort()[0],
      end: list.map((e) => e.end).sort().slice(-1)[0],
      mid: iso(list.reduce((s, e) => s + ms(e.mid), 0) / list.length),
    }));
}

/** Valor del parámetro `epoch` para la API: lista de barridos separados por coma. */
export const frameEpochParam = (f: Frame) => f.surveys.map((s) => s.id).join(',');
