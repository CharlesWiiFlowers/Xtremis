// Piezas pequeñas compartidas: logo, selector de idioma y aviso de modo demo.

import { IS_MOCK } from '../api';
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
    <div className="lang-toggle" role="group" aria-label="Idioma / Language">
      {(['es', 'en'] as const).map((l) => (
        <button key={l} className={l === lang ? 'active' : ''} onClick={() => setLang(l)} aria-pressed={l === lang}>
          {l.toUpperCase()}
        </button>
      ))}
    </div>
  );
}

export function DemoBadge() {
  const { t } = useI18n();
  if (!IS_MOCK) return null;
  return (
    <span className="demo-badge" title={t('demoTooltip')}>
      {t('demoBadge')}
    </span>
  );
}
