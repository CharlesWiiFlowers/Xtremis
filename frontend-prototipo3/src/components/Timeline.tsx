// Línea de tiempo: un planeta que se desliza por una regla dorada marcada por años.
// Se puede arrastrar, hacer clic en la regla o usar las flechas del teclado.

import { useRef, useState, type KeyboardEvent, type PointerEvent } from 'react';
import { useI18n } from '../i18n';
import type { Frame, FrameGroup } from '../lib/frames';

interface Props {
  frames: Frame[];
  index: number;
  onIndex: (i: number) => void;
  playing: boolean;
  onTogglePlay: () => void;
  speed: number;
  onSpeed: (s: number) => void;
  group: FrameGroup;
  onGroup: (g: FrameGroup) => void;
  disabled: boolean;
}

export const SPEEDS = [0.5, 1, 2, 4];

const ms = (iso: string) => Date.parse(iso + 'T00:00:00Z');

export function formatRange(start: string, end: string, lang: string): string {
  const fmt = (iso: string) =>
    new Date(ms(iso)).toLocaleDateString(lang, { month: 'short', year: 'numeric', timeZone: 'UTC' });
  return `${fmt(start)} – ${fmt(end)}`;
}

/** Título y subtítulo de un cuadro, según se agrupe por año o por época. */
export function useFrameLabel() {
  const { t, lang } = useI18n();
  return (f: Frame) => {
    const mission = f.mission === 'neowise' ? t('missionNeowise') : t('missionSpherex');
    const nums = f.surveys.map((s) => s.index).join(', ');
    if (f.kind === 'year') {
      const detail =
        f.mission === 'neowise'
          ? t('visitsN', { n: f.surveys.length })
          : f.surveys.length > 1
            ? t('surveysList', { list: nums })
            : t('surveyOne', { n: nums });
      return { title: String(f.year), sub: `${mission} · ${detail}` };
    }
    const one = f.mission === 'neowise' ? t('visitN', { n: nums }) : t('surveyOne', { n: nums });
    const date =
      f.mission === 'neowise'
        ? new Date(ms(f.mid)).toLocaleDateString(lang, { month: 'short', year: 'numeric', timeZone: 'UTC' })
        : formatRange(f.start, f.end, lang);
    return { title: one, sub: `${mission} · ${date}` };
  };
}

export function Timeline(props: Props) {
  const { frames, index, onIndex, playing, onTogglePlay, speed, onSpeed, group, onGroup, disabled } = props;
  const { t } = useI18n();
  const label = useFrameLabel();
  const trackRef = useRef<HTMLDivElement>(null);
  const [dragging, setDragging] = useState(false);
  const n = frames.length;
  if (n === 0) return null;

  // Escala de tiempo: desde el 1 de enero del primer año hasta el 1 de enero siguiente al último.
  const firstYear = new Date(ms(frames[0].start)).getUTCFullYear();
  const lastYear = new Date(ms(frames[n - 1].end) - 86400000).getUTCFullYear();
  const t0 = Date.UTC(firstYear, 0, 1);
  const t1 = Date.UTC(lastYear + 1, 0, 1);
  const pct = (time: number) => ((time - t0) / (t1 - t0)) * 100;
  const years = Array.from({ length: lastYear - firstYear + 2 }, (_, i) => firstYear + i);
  // Tramos de la regla por misión (NEOWISE antes, SPHEREx después)
  const missions = (['neowise', 'spherex'] as const)
    .map((mission) => {
      const list = frames.filter((f) => f.mission === mission);
      if (!list.length) return null;
      return { mission, from: pct(ms(list[0].start)), to: pct(ms(list[list.length - 1].end)) };
    })
    .filter((m): m is { mission: 'neowise' | 'spherex'; from: number; to: number } => m !== null);

  const current = frames[Math.min(index, n - 1)];
  const planetLeft = pct(ms(current.mid));
  const head = label(current);

  const nearest = (clientX: number) => {
    const rect = trackRef.current!.getBoundingClientRect();
    const time = t0 + ((clientX - rect.left) / rect.width) * (t1 - t0);
    let best = 0;
    frames.forEach((f, i) => {
      if (Math.abs(ms(f.mid) - time) < Math.abs(ms(frames[best].mid) - time)) best = i;
    });
    return best;
  };

  const onDown = (e: PointerEvent<HTMLDivElement>) => {
    if (disabled) return;
    e.currentTarget.setPointerCapture(e.pointerId);
    setDragging(true);
    onIndex(nearest(e.clientX));
  };
  const onMove = (e: PointerEvent<HTMLDivElement>) => {
    if (!dragging) return;
    const i = nearest(e.clientX);
    if (i !== index) onIndex(i);
  };
  const onUp = () => setDragging(false);

  const onKey = (e: KeyboardEvent) => {
    if (e.key === 'ArrowRight' || e.key === 'ArrowUp') onIndex(Math.min(n - 1, index + 1));
    else if (e.key === 'ArrowLeft' || e.key === 'ArrowDown') onIndex(Math.max(0, index - 1));
    else if (e.key === 'Home') onIndex(0);
    else if (e.key === 'End') onIndex(n - 1);
    else return;
    e.preventDefault();
    e.stopPropagation();
  };

  return (
    <div className={`timeline ${disabled ? 'is-disabled' : ''}`}>
      <div className="timeline-head">
        <div className="timeline-controls">
          <button className="icon-btn" onClick={() => onIndex((index - 1 + n) % n)} disabled={disabled || n < 2} aria-label={t('prev')} title={t('prev')}>
            <svg width="16" height="16" viewBox="0 0 24 24"><path d="M15 5l-7 7 7 7" stroke="currentColor" strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round" /></svg>
          </button>
          <button className="icon-btn play-btn" onClick={onTogglePlay} disabled={disabled || n < 2} aria-label={playing ? t('pause') : t('play')} title={playing ? t('pause') : t('play')}>
            {playing ? (
              <svg width="18" height="18" viewBox="0 0 24 24"><rect x="6" y="5" width="4" height="14" rx="1" fill="currentColor" /><rect x="14" y="5" width="4" height="14" rx="1" fill="currentColor" /></svg>
            ) : (
              <svg width="18" height="18" viewBox="0 0 24 24"><path d="M7 4.5v15l13-7.5z" fill="currentColor" /></svg>
            )}
          </button>
          <button className="icon-btn" onClick={() => onIndex((index + 1) % n)} disabled={disabled || n < 2} aria-label={t('next')} title={t('next')}>
            <svg width="16" height="16" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7" stroke="currentColor" strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round" /></svg>
          </button>
        </div>

        <div className="timeline-now" aria-live="polite">
          <span className="now-title">{disabled ? t('allSurveys') : head.title}</span>
          {!disabled && <span className="now-sub">{head.sub}</span>}
        </div>

        <div className="timeline-options">
          <div className="segmented segmented-sm" role="radiogroup" aria-label={t('groupBy')}>
            {(['year', 'survey'] as const).map((g) => (
              <button key={g} role="radio" aria-checked={group === g} className={group === g ? 'active' : ''} onClick={() => onGroup(g)}>
                {g === 'year' ? t('byYear') : t('bySurvey')}
              </button>
            ))}
          </div>
          <label className="speed">
            <span className="sr-only">{t('speed')}</span>
            <select value={speed} onChange={(e) => onSpeed(Number(e.target.value))} disabled={disabled} title={t('speed')}>
              {SPEEDS.map((s) => (
                <option key={s} value={s}>
                  {s}×
                </option>
              ))}
            </select>
          </label>
        </div>
      </div>

      <div
        className={`ruler ${dragging ? 'is-dragging' : ''}`}
        ref={trackRef}
        onPointerDown={onDown}
        onPointerMove={onMove}
        onPointerUp={onUp}
        onPointerCancel={onUp}
      >
        <div className="ruler-line" aria-hidden="true" />
        {missions.map((m) => (
          <div
            key={m.mission}
            className={`ruler-mission ruler-mission-${m.mission}`}
            style={{ left: `${m.from}%`, width: `${m.to - m.from}%` }}
            aria-hidden="true"
          />
        ))}
        <div className="ruler-fill" style={{ width: `${planetLeft}%` }} aria-hidden="true" />

        {years.map((y) => (
          <div
            key={y}
            className={`ruler-year ${(y - firstYear) % 2 ? 'minor' : ''}`}
            style={{ left: `${pct(Date.UTC(y, 0, 1))}%` }}
            aria-hidden="true"
          >
            <span className="ruler-year-tick" />
            <span className="ruler-year-label">{y}</span>
          </div>
        ))}

        {frames.map((f, i) => (
          <span
            key={f.id}
            className={`ruler-stop ruler-stop-${f.mission} ${i === index ? 'active' : ''} ${i < index ? 'past' : ''}`}
            style={{ left: `${pct(ms(f.mid))}%` }}
            aria-hidden="true"
          />
        ))}

        <div
          className="planet"
          style={{ left: `${planetLeft}%` }}
          role="slider"
          tabIndex={disabled ? -1 : 0}
          aria-label={t('dragHint')}
          aria-valuemin={0}
          aria-valuemax={n - 1}
          aria-valuenow={index}
          aria-valuetext={`${head.title} · ${head.sub}`}
          onKeyDown={onKey}
          title={t('dragHint')}
        >
          <span className="planet-ring" aria-hidden="true" />
          <span className="planet-body" aria-hidden="true" />
        </div>
      </div>
      <div className="ruler-legend">
        {missions.some((m) => m.mission === 'neowise') && (
          <span>
            <i className="lg-dot lg-dot-neowise" /> {t('timelineNeowise')}
          </span>
        )}
        <span>
          <i className="lg-dot lg-dot-spherex" /> {t('timelineSpherex')}
        </span>
        {missions.some((m) => m.mission === 'neowise') && <span className="muted">{t('timelineNote')}</span>}
      </div>
    </div>
  );
}
