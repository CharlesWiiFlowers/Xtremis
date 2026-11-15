import { useRef, type MouseEvent } from 'react';
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

export function SkyImage({ center, fov, frameUrl, flagsUrl, gaia, wise, selected, onSelect, status, onExpand, large }: Props) {
  const { t } = useI18n();
  const ref = useRef<HTMLDivElement>(null);
  const span = fov * 60; // arcsec que cubre la imagen de lado a lado

  // Cielo -> % dentro de la imagen (Norte arriba, Este a la izquierda)
  const toPct = (c: SkyCoord) => {
    const o = skyToOffset(center, c);
    return { x: 50 - (o.x / span) * 100, y: 50 - (o.y / span) * 100 };
  };

  const handleClick = (e: MouseEvent<HTMLDivElement>) => {
    if (!ref.current || status !== 'ready') return;
    const rect = ref.current.getBoundingClientRect();
    const fx = (e.clientX - rect.left) / rect.width;
    const fy = (e.clientY - rect.top) / rect.height;
    onSelect(offsetToSky(center, (0.5 - fx) * span, (0.5 - fy) * span));
  };

  const scaleArcmin = fov <= 10 ? 1 : 5;
  const scalePct = (scaleArcmin / fov) * 100;
  const sel = selected ? toPct(selected) : null;

  return (
    <div className="sky-wrap">
      <div className={`sky ${large ? 'sky-large' : ''}`} ref={ref} onClick={handleClick}>
        {frameUrl && <img className="sky-frame" src={frameUrl} alt="" draggable={false} />}
        {flagsUrl && <img className="sky-frame sky-flags" src={flagsUrl} alt="" draggable={false} />}

        <svg className="sky-overlay" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
          {/* cruz del centro, con hueco para no tapar el objeto */}
          <g className="crosshair">
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
