import { useEffect, useState } from 'react';
import { api, type LightCurve, type Spectrum } from '../api';
import { useI18n } from '../i18n';
import { formatDec, formatRA, type SkyCoord } from '../lib/coords';
import { DETECTORS, type DetectorId } from '../lib/detectors';
import type { Frame } from '../lib/frames';
import type { ViewMode } from '../lib/urlState';
import { LineChart } from './LineChart';
import { ExpandButton, Overlay } from './Overlay';
import { useFrameLabel } from './Timeline';
import type { Layers } from './Toolbar';

interface Props {
  center: SkyCoord;
  fov: number;
  name?: string;
  frame: Frame | null;
  mode: ViewMode;
  detector: DetectorId;
  layers: Layers;
  selected: SkyCoord | null;
}

type ChartId = 'spectrum' | 'lightcurve';

export function SidePanel({ center, fov, name, frame, mode, detector, layers, selected }: Props) {
  const { t, lang } = useI18n();
  const label = useFrameLabel();
  const [spectrum, setSpectrum] = useState<Spectrum | null>(null);
  const [curve, setCurve] = useState<LightCurve | null>(null);
  const [busy, setBusy] = useState(false);
  const [expanded, setExpanded] = useState<ChartId | null>(null);

  useEffect(() => {
    if (!selected) {
      setSpectrum(null);
      setCurve(null);
      return;
    }
    let alive = true;
    setBusy(true);
    const q = { field: { ra: center.ra, dec: center.dec, fov }, point: selected, detector };
    Promise.all([api.getSpectrum(q), api.getLightCurve(q)])
      .then(([s, c]) => {
        if (!alive) return;
        setSpectrum(s);
        setCurve(c);
      })
      .catch(() => {
        if (alive) {
          setSpectrum(null);
          setCurve(null);
        }
      })
      .finally(() => alive && setBusy(false));
    return () => {
      alive = false;
    };
  }, [selected, center.ra, center.dec, fov, detector]);

  const dateFmt = (v: number) => new Date(v).toLocaleDateString(lang, { month: 'short', year: '2-digit', timeZone: 'UTC' });
  const curveTimes = curve?.points.map((p) => Date.parse(p.date + 'T00:00:00Z')) ?? [];
  const curveTicks = curveTimes.length ? quarterTicks(Math.min(...curveTimes), Math.max(...curveTimes)) : [];
  const frameText = frame ? label(frame) : null;

  const renderChart = (id: ChartId, size: 'normal' | 'large') => {
    if (id === 'spectrum' && spectrum) {
      return (
        <LineChart
          points={spectrum.points.map((p) => ({ x: p.wavelength, y: p.flux, err: p.err }))}
          xLabel={t('wavelength')}
          yLabel={t('flux')}
          bands={DETECTORS.map((d) => ({ from: d.min, to: d.max, label: `D${d.id}` }))}
          line
          size={size}
        />
      );
    }
    if (id === 'lightcurve' && curve) {
      return (
        <LineChart
          points={curve.points.map((p, i) => ({ x: curveTimes[i], y: p.flux, err: p.err }))}
          xLabel={t('date')}
          yLabel={t('flux')}
          xFormat={dateFmt}
          xTicks={curveTicks}
          color="var(--gold)"
          size={size}
        />
      );
    }
    return null;
  };

  const chartCard = (id: ChartId) => {
    const data = id === 'spectrum' ? spectrum : curve;
    const title = id === 'spectrum' ? t('tabSpectrum') : t('tabLightcurve');
    const help = id === 'spectrum' ? t('spectrumHelp') : t('lightcurveHelp');
    return (
      <section className="panel-card chart-card" key={id}>
        <div className="card-head">
          <h4>{title}</h4>
          {data && !busy && <ExpandButton onClick={() => setExpanded(id)} label={`${t('expand')}: ${title}`} />}
        </div>
        {!selected ? (
          <p className="muted hint-box">{t('clickHint')}</p>
        ) : busy ? (
          <div className="chart-skeleton">{t('loadingChart')}</div>
        ) : (
          <>
            {data?.found === false && <p className="warn small">{t('noSource')}</p>}
            {renderChart(id, 'normal')}
            <p className="muted small chart-help">{help}</p>
          </>
        )}
      </section>
    );
  };

  return (
    <aside className="panel">
      <section className="panel-card">
        <h3>{name ?? t('panelField')}</h3>
        <dl className="facts">
          <dt>{t('fieldCenter')}</dt>
          <dd className="mono">
            {formatRA(center.ra)} {formatDec(center.dec)}
          </dd>
          <dt>{t('fieldFov')}</dt>
          <dd>
            {fov}′ × {fov}′
          </dd>
          <dt>{t('currentEpoch')}</dt>
          <dd>
            {mode === 'sum' || !frameText ? (
              t('allSurveys')
            ) : (
              <>
                {frameText.title} <span className="muted">· {frameText.sub}</span>
              </>
            )}
          </dd>
          {selected && (
            <>
              <dt>{t('pointTitle')}</dt>
              <dd className="mono">
                {formatRA(selected.ra)} {formatDec(selected.dec)}
              </dd>
            </>
          )}
        </dl>
        <ul className="legend">
          <li>
            <span className="lg lg-center" />
            {t('legendCenter')}
          </li>
          {mode === 'diff' && (
            <>
              <li>
                <span className="lg lg-new" />
                {t('legendNew')}
              </li>
              <li>
                <span className="lg lg-old" />
                {t('legendOld')}
              </li>
            </>
          )}
          {layers.gaia && (
            <li>
              <span className="lg lg-gaia" />
              {t('legendGaia')}
            </li>
          )}
          {layers.wise && (
            <li>
              <span className="lg lg-wise" />
              {t('legendWise')}
            </li>
          )}
          {layers.flags && (
            <li>
              <span className="lg lg-flags" />
              {t('legendFlags')}
            </li>
          )}
        </ul>
      </section>

      {chartCard('spectrum')}
      {chartCard('lightcurve')}

      <Overlay
        open={expanded !== null}
        onClose={() => setExpanded(null)}
        title={
          <>
            <strong>{expanded === 'spectrum' ? t('tabSpectrum') : t('tabLightcurve')}</strong>
            <span className="muted">
              {' '}
              · {name ?? t('panelField')}
              {selected ? ` · ${formatRA(selected.ra)} ${formatDec(selected.dec)}` : ''}
            </span>
          </>
        }
      >
        <div className="overlay-chart">
          {expanded && renderChart(expanded, 'large')}
          <p className="muted">{expanded === 'spectrum' ? t('spectrumHelp') : t('lightcurveHelp')}</p>
        </div>
      </Overlay>
    </aside>
  );
}

/** Marcas cada 3 meses entre dos instantes (ms). */
function quarterTicks(min: number, max: number): number[] {
  const out: number[] = [];
  const d = new Date(min);
  let y = d.getUTCFullYear();
  let m = Math.ceil((d.getUTCMonth() + 1) / 3) * 3;
  for (;;) {
    if (m >= 12) {
      y += Math.floor(m / 12);
      m %= 12;
    }
    const tt = Date.UTC(y, m, 1);
    if (tt > max) break;
    out.push(tt);
    m += 3;
  }
  return out;
}
