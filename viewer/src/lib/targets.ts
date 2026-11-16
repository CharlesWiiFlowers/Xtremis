// Objetos de prueba que pide el reto. Coordenadas J2000 aproximadas.
// OJO: las estrellas con gran movimiento propio (Barnard, WISE 0855) ya no están
// exactamente en su posición de catálogo; el backend debería propagar el
// movimiento propio (p. ej. con Gaia) o usar un campo de visión amplio.

import type { Channel } from './detectors';

export type SedType = 'star' | 'red' | 'brown' | 'cold';
export type TargetKind = 'moving' | 'variable';

export interface Variability {
  amp: number; // amplitud relativa (0–1)
  periodDays: number; // 0 = irregular
}

export interface Target {
  id: string;
  name: string;
  aliases: string[];
  ra: number;
  dec: number;
  kind: TargetKind;
  sed: SedType;
  pm?: { ra: number; dec: number }; // movimiento propio, arcsec/año (RA incluye cos dec)
  variability?: Variability;
  suggestedDetector: Channel;
  desc: { es: string; en: string };
}

export const TARGETS: Target[] = [
  {
    id: 'barnard',
    name: "Barnard's Star",
    aliases: ['barnard', 'barnardsstar', 'estrelladebarnard', 'gj699'],
    ra: 269.452075,
    dec: 4.693391,
    kind: 'moving',
    sed: 'red',
    pm: { ra: -0.8, dec: 10.36 },
    suggestedDetector: 'all',
    desc: {
      es: 'Estrella cercana con el mayor movimiento propio conocido: unos 10″ por año.',
      en: 'Nearby star with the largest known proper motion: about 10″ per year.',
    },
  },
  {
    id: 'epsindib',
    name: 'Epsilon Indi B',
    aliases: ['epsilonindib', 'epsindib', 'epsiloninidib', 'epsindiba', 'epsilonindiba'],
    ra: 331.043833,
    dec: -56.782694,
    kind: 'moving',
    sed: 'brown',
    pm: { ra: 3.98, dec: -2.47 },
    suggestedDetector: 'all',
    desc: {
      es: 'Par de enanas marrones que orbitan la estrella Epsilon Indi.',
      en: 'A pair of brown dwarfs orbiting the star Epsilon Indi.',
    },
  },
  {
    id: 'wise0855',
    name: 'WISE 0855−0714',
    aliases: ['wise0855', 'wise08550714', 'wisej08551007142', 'wisej085510830714442'],
    ra: 133.795129,
    dec: -7.245147,
    kind: 'moving',
    sed: 'cold',
    pm: { ra: -8.12, dec: 0.68 },
    suggestedDetector: '6',
    desc: {
      es: 'La enana marrón más fría conocida. Casi invisible salvo en el detector 6 (4.4–5 µm).',
      en: 'The coldest known brown dwarf. Nearly invisible except in detector 6 (4.4–5 µm).',
    },
  },
  {
    id: 'rwaur',
    name: 'RW Aurigae',
    aliases: ['rwaurigae', 'rwaur'],
    ra: 76.956417,
    dec: 30.401417,
    kind: 'variable',
    sed: 'red',
    variability: { amp: 0.5, periodDays: 0 },
    suggestedDetector: 'all',
    desc: {
      es: 'Estrella joven rodeada de polvo; su brillo cambia de forma irregular.',
      en: 'Young star surrounded by dust; its brightness changes irregularly.',
    },
  },
  {
    id: 'rdra',
    name: 'R Draconis',
    aliases: ['rdraconis', 'rdra'],
    ra: 248.167417,
    dec: 66.754972,
    kind: 'variable',
    sed: 'red',
    variability: { amp: 0.75, periodDays: 245 },
    suggestedDetector: 'all',
    desc: {
      es: 'Variable tipo Mira: su brillo sube y baja en un ciclo de unos 245 días.',
      en: 'Mira-type variable: its brightness rises and falls over a ~245-day cycle.',
    },
  },
];

export function normalizeName(s: string): string {
  return s
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9]/g, '');
}

export function findTargetByName(name: string): Target | undefined {
  const n = normalizeName(name);
  return TARGETS.find((t) => normalizeName(t.name) === n || t.aliases.includes(n));
}

/**
 * Época en la que el modo demo coloca al objeto en el centro exacto de la imagen.
 * Con datos reales el backend debe propagar el movimiento propio desde la época del catálogo
 * (J2000 o Gaia 2016) y este valor debe cambiarse a esa época.
 */
export const TARGET_POSITION_EPOCH = 2026.0;

/** Objeto de prueba que corresponde a un centro de búsqueda (si lo hay). */
export function targetAt(c: { ra: number; dec: number }): Target | undefined {
  return TARGETS.find((t) => Math.abs(t.dec - c.dec) < 0.03 && Math.abs(((t.ra - c.ra + 540) % 360) - 180) * Math.cos((c.dec * Math.PI) / 180) < 0.03);
}

/** Desplazamiento (arcsec Este, Norte) del objeto respecto a su posición de referencia en un año dado. */
export function targetOffsetAt(t: Target, year: number): { x: number; y: number } {
  const dt = year - TARGET_POSITION_EPOCH;
  return { x: (t.pm?.ra ?? 0) * dt, y: (t.pm?.dec ?? 0) * dt };
}

/** Objetos de prueba cuyo nombre o alias contiene el texto escrito (para autocompletar). */
export function matchTargets(query: string): Target[] {
  const q = normalizeName(query);
  if (!q) return [];
  return TARGETS.filter((t) => normalizeName(t.name).includes(q) || t.aliases.some((a) => a.includes(q)));
}
