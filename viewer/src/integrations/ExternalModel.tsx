// Vista opcional del modelo 3D del equipo, incrustado como <iframe>.
// Solo aparece si se define VITE_MODEL_URL (ver INTEGRACION_MODELO.md). Sin esa variable,
// CygnusX funciona igual que siempre y esta pestaña no se muestra.

import { useEffect, useRef, useState } from 'react';
import { registerModelWindow } from './skyBus';

export const MODEL_URL = (import.meta.env.VITE_MODEL_URL ?? '').trim();
export const HAS_MODEL = MODEL_URL.length > 0;

interface Props {
  ra: number;
  dec: number;
  fov: number;
  title: string;
}

export function ExternalModel({ ra, dec, fov, title }: Props) {
  const ref = useRef<HTMLIFrameElement>(null);

  // Al cargar, el modelo recibe la posición inicial por la URL; después, por mensajes (skyBus).
  const [src] = useState(() => {
    try {
      const u = new URL(MODEL_URL, window.location.href);
      u.searchParams.set('ra', ra.toFixed(5));
      u.searchParams.set('dec', dec.toFixed(5));
      u.searchParams.set('fov', String(fov));
      return u.toString();
    } catch {
      return MODEL_URL;
    }
  });

  useEffect(() => {
    const win = ref.current?.contentWindow;
    if (!win) return;
    return registerModelWindow(win);
  }, []);

  if (!HAS_MODEL) return null;
  // La URL inicial solo se usa al montar; los cambios posteriores viajan por mensajes.
  return <iframe ref={ref} className="model-frame" src={src} title={title} allow="fullscreen" />;
}
