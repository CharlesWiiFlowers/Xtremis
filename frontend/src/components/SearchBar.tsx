import { useState, type FormEvent } from 'react';
import { api } from '../api';
import { useI18n } from '../i18n';
import { parseCoords } from '../lib/coords';
import { findTargetByName, matchTargets, TARGETS, type Target } from '../lib/targets';
import { DEFAULT_FOV, type ViewParams } from '../lib/urlState';

interface Props {
  onOpen: (p: ViewParams) => void;
  current?: ViewParams;
  /** 'hero' = grande con botón dorado (inicio); 'sm' = compacto (barra del visor). */
  size?: 'hero' | 'sm';
  inputId?: string;
  /** Chips con los 5 objetos de prueba debajo del buscador (por defecto, solo en el visor). */
  suggestions?: boolean;
}

export function SearchBar({ onOpen, current, size = 'sm', inputId, suggestions = size === 'sm' }: Props) {
  const { t } = useI18n();
  const hero = size === 'hero';
  const [query, setQuery] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [focused, setFocused] = useState(false);

  const base = {
    fov: current?.fov ?? DEFAULT_FOV,
    det: current?.det ?? 'all',
    mode: current?.mode ?? 'animate',
  } as const;

  const openTarget = (target: Target) => {
    setError(null);
    setQuery('');
    onOpen({ ...base, mode: 'animate', det: target.suggestedDetector, ra: target.ra, dec: target.dec, name: target.name });
  };

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    const q = query.trim();
    if (!q) {
      if (inputId) document.getElementById(inputId)?.focus();
      return;
    }
    setError(null);

    const coords = parseCoords(q);
    if (coords) {
      onOpen({ ...base, ...coords });
      setQuery('');
      return;
    }

    const preset = findTargetByName(q);
    if (preset) {
      openTarget(preset);
      return;
    }

    setBusy(true);
    try {
      const r = await api.resolve(q);
      const target = findTargetByName(r.name);
      onOpen({ ...base, det: target?.suggestedDetector ?? base.det, ra: r.ra, dec: r.dec, name: r.name });
      setQuery('');
    } catch {
      setError(t('searchError'));
    } finally {
      setBusy(false);
    }
  };

  const placeholder = hero ? t('heroPlaceholder') : t('searchPlaceholder');
  const matches = focused ? matchTargets(query) : [];

  return (
    <form className={`search search-${size}`} onSubmit={submit} role="search">
      <div className="search-field">
        <div className="search-row">
          <svg className="search-icon" width="18" height="18" viewBox="0 0 24 24" aria-hidden="true">
            <circle cx="11" cy="11" r="7" fill="none" stroke="currentColor" strokeWidth="2" />
            <path d="M20 20l-4-4" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
          </svg>
          <input
            id={inputId}
            value={query}
            onChange={(e) => {
              setQuery(e.target.value);
              setError(null);
            }}
            onFocus={() => setFocused(true)}
            onBlur={() => setFocused(false)}
            placeholder={placeholder}
            aria-label={placeholder}
            aria-autocomplete="list"
            aria-expanded={matches.length > 0}
            spellCheck={false}
            autoComplete="off"
          />
          <button type="submit" className={`btn btn-gold ${hero ? 'btn-pill' : ''}`} disabled={busy}>
            {busy ? t('searching') : hero ? t('heroButton') : t('searchButton')}
            {hero && !busy && (
              <svg width="16" height="16" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M5 12h13M13 6l6 6-6 6" stroke="currentColor" strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            )}
          </button>
        </div>
        {matches.length > 0 && (
          <ul className="search-dropdown" role="listbox">
            {matches.map((target) => (
              <li key={target.id} role="option" aria-selected={false}>
                {/* onMouseDown: elegir antes de que el input pierda el foco y cierre la lista */}
                <button type="button" onMouseDown={(e) => e.preventDefault()} onClick={() => openTarget(target)}>
                  <strong>{target.name}</strong>
                  <span>
                    {target.ra.toFixed(3)} {target.dec >= 0 ? '+' : ''}
                    {target.dec.toFixed(3)}
                  </span>
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>
      {suggestions && (
        <div className="search-suggestions" aria-label={t('quickTargets')}>
          {TARGETS.map((target) => (
            <button
              key={target.id}
              type="button"
              className={`chip ${current?.name === target.name ? 'active' : ''}`}
              onClick={() => openTarget(target)}
              aria-pressed={current?.name === target.name}
            >
              {target.name}
            </button>
          ))}
        </div>
      )}
      {error && (
        <p className="search-error" role="alert">
          {error}
        </p>
      )}
    </form>
  );
}
