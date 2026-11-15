// Sección "Sistema solar": el simulador ORBITAL dentro del mismo programa, con la misma barra superior.
import { LangToggle, Logo, SectionNav, type Section } from './Chrome';

const ORBITAL_URL = '/orbital/?embed=1';

export function OrbitalSection({ onHome, onSection }: { onHome: () => void; onSection: (s: Section) => void }) {
  return (
    <div className="viewer orbital-section">
      <header className="topbar">
        <Logo onClick={onHome} />
        <SectionNav current="orbital" onSelect={onSection} />
        <div className="topbar-right">
          <LangToggle />
        </div>
      </header>
      <iframe className="orbital-frame" src={ORBITAL_URL} title="ORBITAL" allow="fullscreen" />
    </div>
  );
}
