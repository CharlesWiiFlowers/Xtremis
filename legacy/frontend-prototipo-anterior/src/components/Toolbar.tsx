import { useI18n } from '../i18n';
import { DETECTORS, detectorRange, type DetectorId } from '../lib/detectors';
import { FOV_OPTIONS, type ViewMode, type ViewParams } from '../lib/urlState';

export interface Layers {
  gaia: boolean;
  wise: boolean;
  flags: boolean;
}

interface Props {
  params: ViewParams;
  onChange: (patch: Partial<ViewParams>) => void;
  layers: Layers;
  onLayers: (l: Layers) => void;
}

export function Toolbar({ params, onChange, layers, onLayers }: Props) {
  const { t } = useI18n();
  const modes: { id: ViewMode; label: string; help: string }[] = [
    { id: 'animate', label: t('modeAnimate'), help: t('modeHelpAnimate') },
    { id: 'diff', label: t('modeDiff'), help: t('modeHelpDiff') },
    { id: 'sum', label: t('modeSum'), help: t('modeHelpSum') },
  ];
  const current = modes.find((m) => m.id === params.mode)!;

  return (
    <div className="toolbar">
      <div className="toolbar-group">
        <span className="toolbar-label">{t('mode')}</span>
        <div className="segmented" role="radiogroup" aria-label={t('mode')}>
          {modes.map((m) => (
            <button
              key={m.id}
              role="radio"
              aria-checked={params.mode === m.id}
              className={params.mode === m.id ? 'active' : ''}
              onClick={() => onChange({ mode: m.id })}
              title={m.help}
            >
              {m.label}
            </button>
          ))}
        </div>
      </div>

      <label className="toolbar-group">
        <span className="toolbar-label">{t('detector')}</span>
        <select value={params.det} onChange={(e) => onChange({ det: e.target.value as DetectorId })}>
          <option value="all">{t('detAll', { range: detectorRange('all') })}</option>
          {DETECTORS.map((d) => (
            <option key={d.id} value={d.id}>
              {t('detN', { n: d.id, range: detectorRange(d.id) })}
            </option>
          ))}
        </select>
      </label>

      <label className="toolbar-group">
        <span className="toolbar-label">{t('fov')}</span>
        <select value={params.fov} onChange={(e) => onChange({ fov: Number(e.target.value) })}>
          {FOV_OPTIONS.map((f) => (
            <option key={f} value={f}>
              {f}′
            </option>
          ))}
        </select>
      </label>

      <div className="toolbar-group">
        <span className="toolbar-label">{t('layers')}</span>
        <div className="chips">
          {(
            [
              ['gaia', t('layerGaia')],
              ['wise', t('layerWise')],
              ['flags', t('layerFlags')],
            ] as const
          ).map(([key, label]) => (
            <button
              key={key}
              className={`chip chip-${key} ${layers[key] ? 'active' : ''}`}
              aria-pressed={layers[key]}
              onClick={() => onLayers({ ...layers, [key]: !layers[key] })}
            >
              <span className="chip-dot" />
              {label}
            </button>
          ))}
        </div>
      </div>

      <p className="toolbar-help">{current.help}</p>
    </div>
  );
}
