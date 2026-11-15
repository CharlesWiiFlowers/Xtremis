import { useI18n, type I18nKey } from '../i18n';
import { TARGETS, type Target } from '../lib/targets';
import { DEFAULT_FOV, type ViewParams } from '../lib/urlState';
import { DemoBadge, LangToggle, Logo, type Section } from './Chrome';
import { GalaxyCanvas } from './GalaxyCanvas';
import { SearchBar } from './SearchBar';

const SEARCH_ID = 'hero-search';

function openTarget(target: Target, onOpen: (p: ViewParams) => void) {
  onOpen({
    ra: target.ra,
    dec: target.dec,
    fov: DEFAULT_FOV,
    det: target.suggestedDetector,
    mode: 'animate',
    name: target.name,
  });
}

export function Home({ onOpen, onSection }: { onOpen: (p: ViewParams) => void; onSection: (s: Section) => void }) {
  const { t, lang } = useI18n();

  const scrollTo = (id: string) => document.getElementById(id)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
  const focusSearch = () => {
    const input = document.getElementById(SEARCH_ID) as HTMLInputElement | null;
    input?.scrollIntoView({ behavior: 'smooth', block: 'center' });
    input?.focus({ preventScroll: true });
  };

  const meta = (target: Target) => {
    if (target.kind === 'moving' && target.pm) {
      return t('perYear', { v: Math.hypot(target.pm.ra, target.pm.dec).toFixed(1) });
    }
    if (target.variability?.periodDays) return t('periodDays', { n: target.variability.periodDays });
    return t('irregular');
  };

  return (
    <div className="home">
      <section className="hero-wrap">
        <GalaxyCanvas />
        <div className="hero-shade" aria-hidden="true" />

        <header className="topbar topbar-home">
          <Logo />
          <span className="nav-sep" aria-hidden="true" />
          <nav className="nav">
            <button onClick={focusSearch}>{t('navExplore')}</button>
            <button onClick={() => scrollTo('ejemplos')}>{t('navExamples')}</button>
            <button onClick={() => scrollTo('como-funciona')}>{t('navHow')}</button>
            <button onClick={() => onSection('orbital')}>{t('sectionOrbital')}</button>
          </nav>
          <div className="topbar-right">
            <DemoBadge />
            <LangToggle />
            <button className="btn btn-gold btn-pill" onClick={focusSearch}>
              <svg width="16" height="16" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M5 15c-1.5 1.5-2 5-2 5s3.5-.5 5-2M14 4c3-1 6-1 6-1s0 3-1 6l-6 6-5-5 6-6zM9 10H5l-2 3 4 1M14 15v4l-3 2-1-4" stroke="currentColor" strokeWidth="1.8" fill="none" strokeLinejoin="round" />
              </svg>
              {t('openViewer')}
            </button>
          </div>
        </header>

        <div className="hero">
          <p className="eyebrow">{t('heroEyebrow')}</p>
          <h1>
            <span>{t('heroTitleA')}</span> <span>{t('heroTitleB')}</span>
          </h1>
          <p className="hero-sub">{t('heroSub')}</p>
          <SearchBar onOpen={onOpen} size="hero" inputId={SEARCH_ID} />
          <button className="link-btn" onClick={() => openTarget(TARGETS[0], onOpen)}>
            <svg width="18" height="18" viewBox="0 0 24 24" aria-hidden="true">
              <circle cx="12" cy="12" r="9.5" fill="none" stroke="currentColor" strokeWidth="1.6" />
              <path d="M10 8.5v7l5.5-3.5z" fill="currentColor" />
            </svg>
            <span>{t('seeExample')}: {TARGETS[0].name}</span>
          </button>

          <div className="scale" id="ejemplos">
            <div className="scale-line" aria-hidden="true" />
            {TARGETS.map((target, i) => {
              const left = (i / (TARGETS.length - 1)) * 100;
              const kindKey: I18nKey = target.kind === 'moving' ? 'kindMoving' : 'kindVariable';
              return (
                <button
                  key={target.id}
                  className={`scale-item ${i % 2 ? 'below' : 'above'}`}
                  style={{ left: `${left}%` }}
                  onClick={() => openTarget(target, onOpen)}
                  title={target.desc[lang]}
                >
                  <span className="scale-tick" />
                  <span className="scale-text">
                    <strong>{target.name}</strong>
                    <span>
                      <i className={`kind-dot kind-${target.kind}`} />
                      {t(kindKey)} · {meta(target)}
                    </span>
                  </span>
                </button>
              );
            })}
          </div>
        </div>
        <p className="start-anywhere">{t('startAnywhere')}</p>
      </section>

      <section className="how" id="como-funciona">
        <h2>{t('howTitle')}</h2>
        <ol className="how-steps">
          {(
            [
              ['how1Title', 'how1'],
              ['how2Title', 'how2'],
              ['how3Title', 'how3'],
            ] as const
          ).map(([title, body], i) => (
            <li key={title}>
              <span className="how-num">0{i + 1}</span>
              <strong>{t(title)}</strong>
              <p>{t(body)}</p>
            </li>
          ))}
        </ol>
        <div className="target-notes">
          {TARGETS.map((target) => (
            <button key={target.id} className="target-note" onClick={() => openTarget(target, onOpen)}>
              <strong>{target.name}</strong>
              <span>{target.desc[lang]}</span>
            </button>
          ))}
        </div>
      </section>

      <footer className="footer">{t('footer')}</footer>
    </div>
  );
}
