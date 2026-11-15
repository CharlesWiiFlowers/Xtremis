// Piezas pequeñas compartidas: logo, selector de idioma y aviso de modo demo.

import { DATA_SOURCE, setDataSource, type DataSource } from '../api';
import { useI18n } from '../i18n';

export function Logo({ onClick }: { onClick?: () => void }) {
  const { t } = useI18n();
  const content = (
    <>
      <svg width="34" height="34" viewBox="0 0 40 40" aria-hidden="true">
        <defs>
          <radialGradient id="lg-planet" cx="35%" cy="35%" r="70%">
            <stop offset="0" stopColor="#bfe0ff" />
            <stop offset="0.5" stopColor="#4d7fd1" />
            <stop offset="1" stopColor="#0d1a3a" />
          </radialGradient>
        </defs>
        <circle cx="20" cy="21" r="9" fill="url(#lg-planet)" />
        <ellipse cx="20" cy="21" rx="16" ry="5" fill="none" stroke="var(--gold)" strokeWidth="1.6" transform="rotate(-18 20 21)" />
        <path d="M31 7l1 2.4 2.4 1-2.4 1-1 2.4-1-2.4-2.4-1 2.4-1z" fill="#fff" />
      </svg>
      <span className="logo-text">{t('appName').toUpperCase()}</span>
    </>
  );
  return onClick ? (
    <button className="logo" onClick={onClick} aria-label={t('home')}>
      {content}
    </button>
  ) : (
    <div className="logo">{content}</div>
  );
}

export function LangToggle() {
  const { lang, setLang } = useI18n();
  return (
    <div className="lang-toggle" role="group" aria-label="Language / Idioma">
      {(['en', 'es'] as const).map((l) => (
        <button key={l} className={l === lang ? 'active' : ''} onClick={() => setLang(l)} aria-pressed={l === lang}>
          {l.toUpperCase()}
        </button>
      ))}
    </div>
  );
}

/** Interruptor de datos: simulados (demo, instantáneo) o reales (backend SPHEREx). */
export function DemoBadge() {
  const { t } = useI18n();
  const options: { id: DataSource; label: string }[] = [
    { id: 'demo', label: t('dataDemo') },
    { id: 'real', label: t('dataReal') },
  ];
  return (
    <div className="data-toggle" role="group" aria-label={t('dataSource')} title={DATA_SOURCE === 'demo' ? t('demoTooltip') : t('realTooltip')}>
      {options.map((o) => (
        <button key={o.id} className={o.id === DATA_SOURCE ? 'active' : ''} aria-pressed={o.id === DATA_SOURCE} onClick={() => o.id !== DATA_SOURCE && setDataSource(o.id)}>
          {o.label}
        </button>
      ))}
    </div>
  );
}

export type Section = 'sky' | 'orbital';

/** Selector de sección: Xtremis es un solo programa con dos secciones. */
export function SectionNav({ current, onSelect }: { current: Section; onSelect: (s: Section) => void }) {
  const { t } = useI18n();
  const items: { id: Section; label: string }[] = [
    { id: 'sky', label: t('sectionSky') },
    { id: 'orbital', label: t('sectionOrbital') },
  ];
  return (
    <nav className="section-nav" aria-label={t('sectionNav')}>
      {items.map((it) => (
        <button
          key={it.id}
          className={it.id === current ? 'active' : ''}
          aria-current={it.id === current ? 'page' : undefined}
          onClick={() => it.id !== current && onSelect(it.id)}
        >
          {it.label}
        </button>
      ))}
    </nav>
  );
}
