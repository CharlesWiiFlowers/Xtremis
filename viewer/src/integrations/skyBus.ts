// Puente de comunicación entre CygnusX y otros visores (p. ej. el modelo 3D del equipo).
//
// CygnusX EMITE eventos cada vez que cambia lo que el usuario ve:
//   { source: 'cygnusx', type: 'view',   ra, dec, fov, channel, frame }   ← cambió zona, banda o año
//   { source: 'cygnusx', type: 'cursor', ra, dec }                        ← el cursor se movió
//   { source: 'cygnusx', type: 'select', ra, dec }                        ← el usuario eligió un punto
//
// CygnusX ESCUCHA comandos de otros visores:
//   { source: 'cygnusx-model', type: 'goto',   ra, dec, fov?, name? }     ← ir a una zona del cielo
//   { source: 'cygnusx-model', type: 'cursor', ra, dec }                  ← mover el cursor
//   { source: 'cygnusx-model', type: 'select', ra, dec }                  ← seleccionar un punto
//
// Funciona en tres casos sin cambiar código:
//   1. Dentro de la misma app (módulos que llamen a onSkyEvent / sendSkyCommand).
//   2. El modelo incrustado como <iframe> dentro de CygnusX (ver ExternalModel.tsx).
//   3. CygnusX incrustado como <iframe> dentro de la página del modelo (se avisa a window.parent).
// Documentación completa: INTEGRACION_MODELO.md

import { useEffect, useRef } from 'react';
import type { Mission } from '../api/types';
import type { Channel } from '../lib/detectors';

export interface ViewEvent {
  type: 'view';
  ra: number;
  dec: number;
  fov: number;
  channel: Channel;
  frame: { year: number; mission: Mission; mid: string } | null;
}
export interface PointEvent {
  type: 'cursor' | 'select';
  ra: number;
  dec: number;
}
export type SkyEvent = ViewEvent | PointEvent;

export type SkyCommand =
  | { type: 'goto'; ra: number; dec: number; fov?: number; name?: string }
  | { type: 'cursor' | 'select'; ra: number; dec: number };

type Listener<T> = (msg: T) => void;
const eventListeners = new Set<Listener<SkyEvent>>();
const commandListeners = new Set<Listener<SkyCommand>>();
const frames = new Set<Window>();

/** Registra la ventana de un iframe (el modelo) para enviarle los eventos. */
export function registerModelWindow(win: Window): () => void {
  frames.add(win);
  return () => frames.delete(win);
}

export function emitSkyEvent(e: SkyEvent): void {
  eventListeners.forEach((l) => l(e));
  const msg = { source: 'cygnusx', ...e };
  try {
    if (window.parent && window.parent !== window) window.parent.postMessage(msg, '*');
    frames.forEach((w) => w.postMessage(msg, '*'));
  } catch {
    /* sin acceso a la otra ventana: se ignora */
  }
}

export function onSkyEvent(l: Listener<SkyEvent>): () => void {
  eventListeners.add(l);
  return () => eventListeners.delete(l);
}

/** Envía un comando a CygnusX desde código de la misma página. */
export function sendSkyCommand(c: SkyCommand): void {
  commandListeners.forEach((l) => l(c));
}

const isNum = (v: unknown): v is number => typeof v === 'number' && Number.isFinite(v);

function parseCommand(data: unknown): SkyCommand | null {
  if (!data || typeof data !== 'object') return null;
  const d = data as Record<string, unknown>;
  if (d.source !== 'cygnusx-model' || !isNum(d.ra) || !isNum(d.dec)) return null;
  if (d.ra < 0 || d.ra >= 360 || d.dec < -90 || d.dec > 90) return null;
  if (d.type === 'goto') {
    return {
      type: 'goto',
      ra: d.ra,
      dec: d.dec,
      fov: isNum(d.fov) ? d.fov : undefined,
      name: typeof d.name === 'string' ? d.name.slice(0, 80) : undefined,
    };
  }
  if (d.type === 'cursor' || d.type === 'select') return { type: d.type, ra: d.ra, dec: d.dec };
  return null;
}

/** Hook: ejecuta `handler` con cada comando recibido (desde código o por postMessage). */
export function useSkyCommands(handler: (c: SkyCommand) => void): void {
  const ref = useRef(handler);
  ref.current = handler;
  useEffect(() => {
    const local: Listener<SkyCommand> = (c) => ref.current(c);
    commandListeners.add(local);
    const onMessage = (e: MessageEvent) => {
      const c = parseCommand(e.data);
      if (c) ref.current(c);
    };
    window.addEventListener('message', onMessage);
    return () => {
      commandListeners.delete(local);
      window.removeEventListener('message', onMessage);
    };
  }, []);
}

/** Limita la frecuencia de eventos del cursor a uno por cuadro de pantalla. */
export function throttleFrame<T>(fn: (v: T) => void): (v: T) => void {
  let pending: T | null = null;
  let scheduled = false;
  return (v: T) => {
    pending = v;
    if (scheduled) return;
    scheduled = true;
    requestAnimationFrame(() => {
      scheduled = false;
      if (pending !== null) fn(pending);
    });
  };
}
