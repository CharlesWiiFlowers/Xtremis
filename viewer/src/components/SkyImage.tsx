import { useRef, useState, type KeyboardEvent, type MouseEvent } from 'react';
import type { CatalogSource } from '../api';
import { useI18n } from '../i18n';
import { offsetToSky, skyToOffset, type SkyCoord } from '../lib/coords';
import { CursorPanel, type CursorInfo } from './CursorPanel';
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
  /** Posición del cursor (ratón o teclado). */
  cursor: SkyCoord | null;
  onCursor: (c: SkyCoord | null) => void;
  onKeyboardMove: (dx: number, dy: number, fast: boolean) => void;
  cursorInfo: CursorInfo;
  /** Etiqueta abajo a la derecha: misión y banda que se están viendo. */
  badge?: string;
  status: 'loading' | 'error' | 'empty' | 'ready';
  /** Si se pasa, muestra el botón de pantalla completa. */
  onExpand?: () => void;
  large?: boolean;
}

export function SkyImage(props: Props) {
  const { center, fov, frameUrl, flagsUrl, gaia, wise, selected, onSelect, cursor, onCursor, onKeyboardMove, cursorInfo, badge, status, onExpand, large } =
    props;
  const { t } = useI18n();
  const ref = useRef<HTMLDivElement>(null);
  const [panelOpen, setPanelOpen] = useState(true);
  const [usingKeys, setUsingKeys] = useState(false);
  const span = fov * 60; // arcsec que cubre la imagen de lado a lado

  // Cielo -> % dentro de la imagen (Norte arriba, Este a la izquierda)
  const toPct = (c: SkyCoord) => {
    const o = skyToOffset(center, c);
    return { x: 50 - (o.x / span) * 100, y: 50 - (o.y / span) * 100 };
  };

  const fromEvent = (e: MouseEvent<HTMLDivElement>): SkyCoord | null => {
    if (!ref.current) return null;
    const rect = ref.current.getBoundingClientRect();
    const fx = (e.clientX - rect.left) / rect.width;
    const fy = (e.clientY - rect.top) / rect.height;
    if (fx < 0 || fx > 1 || fy < 0 || fy > 1) return null;
    return offsetToSky(center, (0.5 - fx) * span, (0.5 - fy) * span);
  };

  const handleClick = (e: MouseEvent<HTMLDivElement>) => {
    ref.current?.focus({ preventScroll: true });
    if (status !== 'ready') return;
    const c = fromEvent(e);
    if (c) {
      onCursor(c);
      onSelect(c);
    }
  };

  const handleMove = (e: MouseEvent<HTMLDivElement>) => {
    if (usingKeys) setUsingKeys(false);
    const c = fromEvent(e);
    if (c) onCursor(c);
  };

  // Flechas: mueven el cursor (Shift = 8 veces más rápido). Enter: selecciona el punto.
  const handleKey = (e: KeyboardEvent<HTMLDivElement>) => {
    const target = e.target as HTMLElement;
    // Los botones flotantes del visor conservan su comportamiento nativo.
    if (target !== e.currentTarget && target.closest('button, a, input, select, textarea, [contenteditable="true"]')) return;

    const dirs: Record<string, [number, number]> = {
      ArrowLeft: [1, 0], // Este está a la izquierda
      ArrowRight: [-1, 0],
      ArrowUp: [0, 1],
      ArrowDown: [0, -1],
    };
    if (e.key in dirs) {
      e.preventDefault();
      e.stopPropagation();
      setUsingKeys(true);
      const [dx, dy] = dirs[e.key];
      onKeyboardMove(dx, dy, e.shiftKey);
    } else if (e.key === 'Enter') {
      e.preventDefault();
      e.stopPropagation();
      onSelect(cursor ?? center);
    }
  };

  const scaleArcmin = fov <= 10 ? 1 : 5;
  const scalePct = (scaleArcmin / fov) * 100;
  const sel = selected ? toPct(selected) : null;
  const cur = cursor ? toPct(cursor) : null;
  const aim = cur ?? { x: 50, y: 50 };

  return (
    <div className="sky-wrap">
      <div
        className={`sky ${large ? 'sky-large' : ''} ${usingKeys ? 'is-keyboard' : ''}`}
        ref={ref}
        tabIndex={0}
        role="application"
        aria-label={t('cursorHint')}
        onClick={handleClick}
        onMouseMove={handleMove}
        onMouseLeave={() => !usingKeys && onCursor(null)}
        onKeyDown={handleKey}
      >
        {frameUrl && <img className="sky-frame" src={frameUrl} alt="" draggable={false} />}
        {flagsUrl && <img className="sky-frame sky-flags" src={flagsUrl} alt="" draggable={false} />}

        <svg className="sky-overlay" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
          {/* La cruz dorada es la mira de exploración: sigue ratón o teclado. */}
          <g className={`crosshair ${usingKeys ? 'keyboard' : ''}`} transform={`translate(${aim.x - 50} ${aim.y - 50})`}>
            <line x1="50" y1="43" x2="50" y2="47" />
            <line x1="50" y1="53" x2="50" y2="57" />
            <line x1="43" y1="50" x2="47" y2="50" />
            <line x1="53" y1="50" x2="57" y2="50" />
          </g>
          {gaia?.map((s, i) => {
            const p = toPct(s);
            return <circle key={`g${i}`} className="mark-gaia" cx={p.x} cy={p.y} r="1.6" />;
          })}
          {wise?.map((s, i) => {
            const p = toPct(s);
            return <rect key={`w${i}`} className="mark-wise" x={p.x - 1.5} y={p.y - 1.5} width="3" height="3" />;
          })}
          {sel && <circle className="mark-selected" cx={sel.x} cy={sel.y} r="2.6" />}
        </svg>

        {onExpand && <ExpandButton onClick={onExpand} label={t('expand')} />}

        <CursorPanel
          cursor={cursor}
          center={center}
          info={cursorInfo}
          variant="overlay"
          collapsed={!panelOpen}
          onToggle={() => setPanelOpen((o) => !o)}
        />

        <div className="compass" aria-hidden="true">
          <span className="compass-n">N</span>
          <span className="compass-e">E</span>
          <svg width="34" height="34" viewBox="0 0 34 34">
            <path d="M28 28 L28 6 M28 28 L6 28" stroke="currentColor" strokeWidth="1.5" fill="none" />
          </svg>
        </div>

        <div className="scalebar" aria-hidden="true">
          <div className="scalebar-line" style={{ width: `${scalePct}%` }} />
          <span>{scaleArcmin}′</span>
        </div>

        {badge && <div className="sky-badge">{badge}</div>}

        {status !== 'ready' && (
          <div className={`sky-status sky-status-${status}`}>
            {status === 'loading' && <span className="spinner" aria-hidden="true" />}
            <span>{status === 'loading' ? t('loading') : status === 'error' ? t('loadError') : t('noEpochs')}</span>
          </div>
        )}
      </div>
      <CursorPanel cursor={cursor} center={center} info={cursorInfo} variant="strip" />
    </div>
  );
}
