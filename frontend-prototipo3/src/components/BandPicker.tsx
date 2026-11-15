// Selector de "luz": todas las bandas, un detector, una de las 102 bandas, o color falso.

import { useI18n } from '../i18n';
import {
  BANDS,
  DETECTORS,
  N_BANDS,
  bandOf,
  detectorRange,
  wavelengthColor,
  wiseBandFor,
  type Channel,
  type DetectorId,
} from '../lib/detectors';
import type { Mission } from '../api/types';

type Kind = 'all' | 'detector' | 'band' | 'rgb';

const kindOf = (c: Channel): Kind => (c === 'all' ? 'all' : c === 'rgb' ? 'rgb' : bandOf(c) ? 'band' : 'detector');

/** Texto corto del canal, p. ej. "Banda 57 · 3.12 µm" o "NEOWISE W1 3.4 µm". */
export function useChannelLabel() {
  const { t } = useI18n();
  return (channel: Channel, mission: Mission = 'spherex') => {
    if (mission === 'neowise') {
      const wb = wiseBandFor(channel);
      const txt = wb === 'W1' ? 'W1 · 3.4 µm' : wb === 'W2' ? 'W2 · 4.6 µm' : wb === 'rgb' ? `${t('chRgb')} W1/W2` : 'W1 + W2';
      return `${t('missionNeowise')} · ${txt}`;
    }
    const band = bandOf(channel);
    if (band) return `${t('missionSpherex')} · ${t('bandN', { n: band.n })} · ${band.center.toFixed(2)} µm`;
    if (channel === 'rgb') return `${t('missionSpherex')} · ${t('chRgb')}`;
    if (channel === 'all') return `${t('missionSpherex')} · ${t('chAll')} (102)`;
    return `${t('missionSpherex')} · ${t('chDetector')} ${channel} · ${detectorRange(channel as DetectorId)} µm`;
  };
}

// Degradado de la regla de bandas: cada tramo con su color "de mentira".
const GRADIENT = `linear-gradient(90deg, ${BANDS.filter((_, i) => i % 6 === 0)
  .map((b, i, arr) => `${wavelengthColor(b.center)} ${((i / (arr.length - 1)) * 100).toFixed(1)}%`)
  .join(', ')})`;

interface Props {
  value: Channel;
  onChange: (c: Channel) => void;
}

export function BandPicker({ value, onChange }: Props) {
  const { t } = useI18n();
  const kind = kindOf(value);
  const band = bandOf(value);
  const lastBand = band?.n ?? 57;
  const lastDetector = kind === 'detector' ? value : '1';

  const setKind = (k: Kind) => {
    if (k === kind) return;
    if (k === 'all') onChange('all');
    else if (k === 'rgb') onChange('rgb');
    else if (k === 'detector') onChange(band ? band.detector : lastDetector);
    else onChange(`b${kind === 'detector' ? (Number(value) - 1) * 17 + 9 : lastBand}`);
  };

  const help =
    kind === 'all'
      ? t('chAllHelp')
      : kind === 'rgb'
        ? t('rgbHelp')
        : kind === 'detector'
          ? t('chDetectorHelp', { range: detectorRange(value as DetectorId) })
          : t('bandHelp', { l: band!.center.toFixed(2), d: band!.detector });

  return (
    <div className="band-picker">
      <div className="toolbar-group">
        <span className="toolbar-label">{t('channel')}</span>
        <div className="segmented" role="radiogroup" aria-label={t('channel')}>
          {(
            [
              ['all', t('chAll')],
              ['detector', t('chDetector')],
              ['band', t('chBand')],
              ['rgb', t('chRgb')],
            ] as const
          ).map(([k, label]) => (
            <button key={k} role="radio" aria-checked={kind === k} className={kind === k ? 'active' : ''} onClick={() => setKind(k)}>
              {label}
            </button>
          ))}
        </div>

        {kind === 'detector' && (
          <div className="det-buttons" role="radiogroup" aria-label={t('chDetector')}>
            {DETECTORS.map((d) => (
              <button
                key={d.id}
                role="radio"
                aria-checked={value === d.id}
                className={value === d.id ? 'active' : ''}
                onClick={() => onChange(d.id)}
                title={`${d.min.toFixed(2)}–${d.max.toFixed(2)} µm`}
                style={{ ['--dot' as string]: wavelengthColor((d.min + d.max) / 2) }}
              >
                D{d.id}
              </button>
            ))}
          </div>
        )}
      </div>

      {kind === 'band' && band && (
        <div className="band-slider">
          <button className="icon-btn icon-btn-sm" onClick={() => onChange(`b${Math.max(1, band.n - 1)}`)} disabled={band.n <= 1} aria-label={t('prevBand')}>
            <svg width="14" height="14" viewBox="0 0 24 24"><path d="M15 5l-7 7 7 7" stroke="currentColor" strokeWidth="2.4" fill="none" strokeLinecap="round" /></svg>
          </button>
          <div className="band-track" style={{ ['--grad' as string]: GRADIENT }}>
            <input
              type="range"
              min={1}
              max={N_BANDS}
              step={1}
              value={band.n}
              onChange={(e) => onChange(`b${Number(e.target.value)}`)}
              aria-label={t('chBand')}
              aria-valuetext={`${t('bandN', { n: band.n })}, ${band.center.toFixed(2)} µm`}
              style={{ ['--thumb' as string]: wavelengthColor(band.center) }}
            />
            <div className="band-ticks" aria-hidden="true">
              {DETECTORS.map((d, i) => (
                <span key={d.id} style={{ left: `${((i * 17) / (N_BANDS - 1)) * 100}%` }}>
                  D{d.id}
                </span>
              ))}
            </div>
          </div>
          <button className="icon-btn icon-btn-sm" onClick={() => onChange(`b${Math.min(N_BANDS, band.n + 1)}`)} disabled={band.n >= N_BANDS} aria-label={t('nextBand')}>
            <svg width="14" height="14" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7" stroke="currentColor" strokeWidth="2.4" fill="none" strokeLinecap="round" /></svg>
          </button>
          <div className="band-readout">
            <span className="band-swatch" style={{ background: wavelengthColor(band.center) }} />
            <strong>{t('bandN', { n: band.n })}</strong>
            <span className="mono">{band.center.toFixed(3)} µm</span>
            <span className="muted">D{band.detector}</span>
          </div>
        </div>
      )}

      <p className="toolbar-help">{help}</p>
    </div>
  );
}
