// Panel con las coordenadas del punto bajo el cursor (o del cursor de teclado),
// inspirado en las fichas de planetarios como Stellarium.

import { useI18n } from '../i18n';
import { formatDec, formatRA, skyToOffset, type SkyCoord } from '../lib/coords';
import { toGalactic } from '../lib/galactic';

export interface CursorInfo {
  /** Nombre del objeto si el cursor está sobre él. */
  objectName?: string;
  objectKind?: string;
  /** Texto de la luz que se está viendo (misión y banda). */
  light: string;
  /** Texto de la época (año y misión). */
  epoch: string;
}

interface Props {
  cursor: SkyCoord | null;
  center: SkyCoord;
  info: CursorInfo;
  variant: 'overlay' | 'strip';
  collapsed?: boolean;
  onToggle?: () => void;
}

const sign = (v: number, digits = 1) => `${v >= 0 ? '+' : '−'}${Math.abs(v).toFixed(digits)}`;

export function CursorPanel({ cursor, center, info, variant, collapsed, onToggle }: Props) {
  const { t } = useI18n();

  if (variant === 'overlay' && collapsed) {
    return (
      <button className="cursor-chip" onClick={onToggle} title={t('cursorShow')} aria-label={t('cursorShow')}>
        <svg width="14" height="14" viewBox="0 0 24 24" aria-hidden="true">
          <circle cx="12" cy="12" r="7" fill="none" stroke="currentColor" strokeWidth="2" />
          <path d="M12 2v5M12 17v5M2 12h5M17 12h5" stroke="currentColor" strokeWidth="2" />
        </svg>
        {cursor ? `${formatRA(cursor.ra)} ${formatDec(cursor.dec)}` : t('cursorTitle')}
      </button>
    );
  }

  const off = cursor ? skyToOffset(center, cursor) : null;
  const gal = cursor ? toGalactic(cursor) : null;

  if (variant === 'strip') {
    return (
      <div className="cursor-strip mono" aria-live="off">
        {cursor ? (
          <>
            <span>{formatRA(cursor.ra)}</span>
            <span>{formatDec(cursor.dec)}</span>
            {info.objectName && <strong>{info.objectName}</strong>}
          </>
        ) : (
          <span className="muted">{t('cursorIdle')}</span>
        )}
      </div>
    );
  }

  return (
    <div className="cursor-panel" onClick={(e) => e.stopPropagation()} onMouseMove={(e) => e.stopPropagation()}>
      <div className="cursor-head">
        <span className="cursor-icon" aria-hidden="true">
          <svg width="22" height="22" viewBox="0 0 24 24">
            <circle cx="12" cy="12" r="6.5" fill="none" stroke="currentColor" strokeWidth="1.8" />
            <path d="M12 1.5v5M12 17.5v5M1.5 12h5M17.5 12h5" stroke="currentColor" strokeWidth="1.8" />
          </svg>
        </span>
        <div className="cursor-title">
          <strong>{info.objectName ?? t('cursorTitle')}</strong>
          <span>{info.objectKind ?? info.epoch}</span>
        </div>
        {onToggle && (
          <button className="cursor-close" onClick={onToggle} aria-label={t('cursorHide')} title={t('cursorHide')}>
            <svg width="12" height="12" viewBox="0 0 24 24"><path d="M6 6l12 12M18 6L6 18" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" /></svg>
          </button>
        )}
      </div>

      {cursor && off && gal ? (
        <dl className="cursor-facts">
          <dt>{t('cursorRaDec')}</dt>
          <dd className="mono">
            {formatRA(cursor.ra)}
            <br />
            {formatDec(cursor.dec)}
          </dd>
          <dt>{t('cursorDeg')}</dt>
          <dd className="mono">
            {cursor.ra.toFixed(5)}° {sign(cursor.dec, 5)}°
          </dd>
          <dt>{t('cursorGal')}</dt>
          <dd className="mono">
            l {gal.l.toFixed(3)}° b {sign(gal.b, 3)}°
          </dd>
          <dt>{t('cursorOffset')}</dt>
          <dd className="mono">
            Δα {sign(off.x)}″ Δδ {sign(off.y)}″
          </dd>
          <dt>{t('cursorLight')}</dt>
          <dd>{info.light}</dd>
          {info.objectKind && (
            <>
              <dt>{t('cursorEpoch')}</dt>
              <dd>{info.epoch}</dd>
            </>
          )}
        </dl>
      ) : (
        <p className="cursor-idle">{t('cursorIdle')}</p>
      )}
      <p className="cursor-hint">{t('cursorHint')}</p>
    </div>
  );
}
