import { useState, type FormEvent } from 'react';
import { api } from '../api';
import { useI18n } from '../i18n';
import { parseCoords } from '../lib/coords';
import { findTargetByName } from '../lib/targets';
import { DEFAULT_FOV, type ViewParams } from '../lib/urlState';

interface Props {
  onOpen: (p: ViewParams) => void;
  current?: ViewParams;
  /** 'hero' = grande con botón dorado (inicio); 'sm' = compacto (barra del visor). */
  size?: 'hero' | 'sm';
  inputId?: string;
}

export function SearchBar({ onOpen, current, size = 'sm', inputId }: Props) {
  const { t } = useI18n();
  const hero = size === 'hero';
  const [query, setQuery] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const base = {
    fov: current?.fov ?? DEFAULT_FOV,
    det: current?.det ?? 'all',
    mode: current?.mode ?? 'animate',
  } as const;

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

  return (
    <form className={`search search-${size}`} onSubmit={submit} role="search">
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
          placeholder={placeholder}
          aria-label={placeholder}
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
      {error && (
        <p className="search-error" role="alert">
          {error}
        </p>
      )}
    </form>
  );
}
