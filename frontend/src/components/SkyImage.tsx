import { useEffect, useRef, useState, type KeyboardEvent, type MouseEvent, type PointerEvent } from 'react';
import type { CatalogSource } from '../api';
import { useI18n } from '../i18n';
import { offsetToSky, skyToOffset, type SkyCoord } from '../lib/coords';
import { ExpandButton } from './Overlay';

interface Props {
  center: SkyCoord;
  fov: number; // arcmin
  frameUrl: string | null;
  flagsUrl: string | null;
  gaia: CatalogSource[] | null;
  wise: CatalogSource[] | null;
  selected: SkyCoord | null;
  onSelect: (c: SkyCoord) => void;
  status: 'loading' | 'error' | 'empty' | 'ready';
  /** Si se pasa, muestra el botón de pantalla completa. */
  onExpand?: () => void;
  large?: boolean;
}

const ZOOM_MIN = 1;
const ZOOM_MAX = 8;
const ZOOM_STEP = 1.5; // factor por clic en + / −
const DRAG_PX = 4; // un arrastre menor que esto cuenta como clic

interface View {
  z: number; // aumento
  cx: number; // centro visible, fracción de la imagen (0–1, x a la derecha)
  cy: number; // (0–1, y hacia abajo)
}

const clamp = (v: number, lo: number, hi: number) => Math.min(hi, Math.max(lo, v));

/** Mantiene el área visible dentro de la imagen. */
function bounded(v: View): View {
  const z = clamp(v.z, ZOOM_MIN, ZOOM_MAX);
  const half = 0.5 / z;
  return { z, cx: clamp(v.cx, half, 1 - half), cy: clamp(v.cy, half, 1 - half) };
}

/** Zoom a `z` manteniendo fijo el punto de pantalla (fx, fy) (fracciones del recuadro). */
function zoomAt(v: View, z: number, fx = 0.5, fy = 0.5): View {
  const px = (fx - 0.5) / v.z + v.cx;
  const py = (fy - 0.5) / v.z + v.cy;
  const nz = clamp(z, ZOOM_MIN, ZOOM_MAX);
  return bounded({ z: nz, cx: px - (fx - 0.5) / nz, cy: py - (fy - 0.5) / nz });
}

/** Barra de escala "redonda" para el campo visible (arcmin). */
function scaleFor(visibleArcmin: number): { arcmin: number; label: string } {
  const steps = [0.25, 0.5, 1, 2, 5, 10];
  const arcmin = [...steps].reverse().find((s) => s <= visibleArcmin / 4) ?? steps[0];
  return { arcmin, label: arcmin < 1 ? `${Math.round(arcmin * 60)}″` : `${arcmin}′` };
}

const RESET: View = { z: 1, cx: 0.5, cy: 0.5 };

export function SkyImage({ center, fov, frameUrl, flagsUrl, gaia, wise, selected, onSelect, status, onExpand, large }: Props) {
  const { t } = useI18n();
  const ref = useRef<HTMLDivElement>(null);
  const [view, setView] = useState<View>(RESET);
  const drag = useRef<{ x: number; y: number; view: View; moved: boolean } | null>(null);
  const span = fov * 60; // arcsec que cubre la imagen de lado a lado
  const { z } = view;

  // Un campo nuevo empieza sin zoom
  useEffect(() => setView(RESET), [center.ra, center.dec, fov]);

  // Rueda del ratón: listener no pasivo para poder evitar el scroll de la página
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const onWheel = (e: WheelEvent) => {
      e.preventDefault();
      const rect = el.getBoundingClientRect();
      const fx = (e.clientX - rect.left) / rect.width;
      const fy = (e.clientY - rect.top) / rect.height;
      setView((v) => zoomAt(v, v.z * Math.exp(-e.deltaY * 0.0015), fx, fy));
    };
    el.addEventListener('wheel', onWheel, { passive: false });
    return () => el.removeEventListener('wheel', onWheel);
  }, []);

  // Teclas + / − / 0 mientras el puntero está sobre la imagen o tiene el foco
  const onKeyDown = (e: KeyboardEvent<HTMLDivElement>) => {
    if (e.key === '+' || e.key === '=') setView((v) => zoomAt(v, v.z * ZOOM_STEP));
    else if (e.key === '-' || e.key === '_') setView((v) => zoomAt(v, v.z / ZOOM_STEP));
    else if (e.key === '0') setView(RESET);
    else return;
    e.preventDefault();
  };

  // Cielo -> % dentro de la imagen completa (Norte arriba, Este a la izquierda)
  const toPct = (c: SkyCoord) => {
    const o = skyToOffset(center, c);
    return { x: 50 - (o.x / span) * 100, y: 50 - (o.y / span) * 100 };
  };

  const onPointerDown = (e: PointerEvent<HTMLDivElement>) => {
    if (e.button !== 0) return;
    drag.current = { x: e.clientX, y: e.clientY, view, moved: false };
  };
  const onPointerMove = (e: PointerEvent<HTMLDivElement>) => {
    const d = drag.current;
    if (!d || !ref.current || d.view.z <= 1) return;
    const dx = e.clientX - d.x;
    const dy = e.clientY - d.y;
    if (!d.moved && Math.hypot(dx, dy) < DRAG_PX) return;
    if (!d.moved) ref.current.setPointerCapture(e.pointerId);
    d.moved = true;
    const rect = ref.current.getBoundingClientRect();
    setView(bounded({ ...d.view, cx: d.view.cx - dx / rect.width / d.view.z, cy: d.view.cy - dy / rect.height / d.view.z }));
  };
  const onPointerUp = () => {
    // drag.current se limpia en el clic, para que un arrastre no seleccione una estrella
    if (drag.current && !drag.current.moved) drag.current = null;
  };

  const handleClick = (e: MouseEvent<HTMLDivElement>) => {
    const dragged = drag.current?.moved;
    drag.current = null;
    if (dragged || !ref.current || status !== 'ready') return;
    const rect = ref.current.getBoundingClientRect();
    const fx = (e.clientX - rect.left) / rect.width;
    const fy = (e.clientY - rect.top) / rect.height;
    // pantalla -> fracción de la imagen completa, deshaciendo el zoom
    const px = (fx - 0.5) / z + view.cx;
    const py = (fy - 0.5) / z + view.cy;
    onSelect(offsetToSky(center, (0.5 - px) * span, (0.5 - py) * span));
  };

  const scale = scaleFor(fov / z);
  const scalePct = (scale.arcmin / (fov / z)) * 100;
  const sel = selected ? toPct(selected) : null;
  // Marcas y trazos con tamaño constante en pantalla
  const k = 1 / z;
  const contentStyle = {
    transform: `translate(${(0.5 - view.cx * z) * 100}%, ${(0.5 - view.cy * z) * 100}%) scale(${z})`,
  };

  return (
    <div className="sky-wrap">
      <div
        className={`sky ${large ? 'sky-large' : ''} ${z > 1 ? 'sky-zoomed' : ''}`}
        ref={ref}
        onClick={handleClick}
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={onPointerUp}
        onKeyDown={onKeyDown}
        tabIndex={0}
      >
        <div className="sky-content" style={contentStyle}>
          {frameUrl && <img className="sky-frame" src={frameUrl} alt="" draggable={false} />}
          {flagsUrl && <img className="sky-frame sky-flags" src={flagsUrl} alt="" draggable={false} />}

          <svg className="sky-overlay" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
            {/* cruz del centro, con hueco para no tapar el objeto */}
            <g className="crosshair" style={{ strokeWidth: 0.35 * k }}>
              <line x1="50" y1={50 - 7 * k} x2="50" y2={50 - 3 * k} />
              <line x1="50" y1={50 + 3 * k} x2="50" y2={50 + 7 * k} />
              <line x1={50 - 7 * k} y1="50" x2={50 - 3 * k} y2="50" />
              <line x1={50 + 3 * k} y1="50" x2={50 + 7 * k} y2="50" />
            </g>
            {gaia?.map((s, i) => {
              const p = toPct(s);
              return <circle key={`g${i}`} className="mark-gaia" cx={p.x} cy={p.y} r={1.6 * k} style={{ strokeWidth: 0.3 * k }} />;
            })}
            {wise?.map((s, i) => {
              const p = toPct(s);
              return (
                <rect
                  key={`w${i}`}
                  className="mark-wise"
                  x={p.x - 1.5 * k}
                  y={p.y - 1.5 * k}
                  width={3 * k}
                  height={3 * k}
                  style={{ strokeWidth: 0.3 * k }}
                />
              );
            })}
            {sel && <circle className="mark-selected" cx={sel.x} cy={sel.y} r={2.6 * k} style={{ strokeWidth: 0.5 * k }} />}
          </svg>
        </div>

        {onExpand && <ExpandButton onClick={onExpand} label={t('expand')} />}

        <div className="compass" aria-hidden="true">
          <span className="compass-n">N</span>
          <span className="compass-e">E</span>
          <svg width="34" height="34" viewBox="0 0 34 34">
            <path d="M28 28 L28 6 M28 28 L6 28" stroke="currentColor" strokeWidth="1.5" fill="none" />
          </svg>
        </div>

        <div className="scalebar" aria-hidden="true">
          <div className="scalebar-line" style={{ width: `${scalePct}%` }} />
          <span>{scale.label}</span>
        </div>

        <div
          className="zoom-controls"
          onClick={(e) => e.stopPropagation()}
          onPointerDown={(e) => e.stopPropagation()}
        >
          <button type="button" onClick={() => setView((v) => zoomAt(v, v.z / ZOOM_STEP))} disabled={z <= ZOOM_MIN} aria-label={t('zoomOut')} title={t('zoomOut')}>
            −
          </button>
          <input
            type="range"
            min={ZOOM_MIN}
            max={ZOOM_MAX}
            step={0.1}
            value={z}
            onChange={(e) => setView((v) => zoomAt(v, Number(e.target.value)))}
            aria-label={t('zoom')}
          />
          <button type="button" onClick={() => setView((v) => zoomAt(v, v.z * ZOOM_STEP))} disabled={z >= ZOOM_MAX} aria-label={t('zoomIn')} title={t('zoomIn')}>
            +
          </button>
          <button type="button" className="zoom-level" onClick={() => setView(RESET)} disabled={z === 1} title={t('zoomReset')} aria-label={t('zoomReset')}>
            {z.toFixed(1)}×
          </button>
        </div>

        {status !== 'ready' && (
          <div className={`sky-status sky-status-${status}`}>
            {status === 'loading' && <span className="spinner" aria-hidden="true" />}
            <span>
              {status === 'loading' ? t('loading') : status === 'error' ? t('loadError') : t('noEpochs')}
            </span>
          </div>
        )}
      </div>
    </div>
  );
}
