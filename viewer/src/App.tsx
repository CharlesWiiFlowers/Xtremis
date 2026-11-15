import { useEffect, useState } from 'react';
import type { Section } from './components/Chrome';
import { Home } from './components/Home';
import { OrbitalSection } from './components/OrbitalSection';
import { Viewer } from './components/Viewer';
import { readParams, writeParams, type ViewParams } from './lib/urlState';

// Un solo programa, dos secciones:
//   · Imágenes del cielo: inicio (sin ra/dec en la URL) y visor (con ra/dec).
//   · Sistema solar: simulador ORBITAL (?view=orbital).
const readSection = (): Section => (new URLSearchParams(window.location.search).get('view') === 'orbital' ? 'orbital' : 'sky');

export default function App() {
  const [section, setSection] = useState<Section>(readSection);
  const [params, setParams] = useState<ViewParams | null>(() => readParams());

  useEffect(() => {
    const onPop = () => {
      setSection(readSection());
      setParams(readParams());
    };
    window.addEventListener('popstate', onPop);
    return () => window.removeEventListener('popstate', onPop);
  }, []);

  const open = (p: ViewParams) => {
    writeParams(p, true);
    setSection('sky');
    setParams(p);
    window.scrollTo(0, 0);
  };

  const update = (patch: Partial<ViewParams>) => {
    if (!params) return;
    const next = { ...params, ...patch };
    writeParams(next, false);
    setParams(next);
  };

  const goHome = () => {
    writeParams(null, true);
    setSection('sky');
    setParams(null);
  };

  // Cambiar de sección conserva el campo del cielo en el que estabas.
  const goSection = (s: Section) => {
    if (s === 'orbital') {
      try {
        window.history.pushState(null, '', `${window.location.pathname}?view=orbital`);
      } catch {
        /* sin history */
      }
      setSection('orbital');
    } else {
      writeParams(params, true);
      setSection('sky');
    }
    window.scrollTo(0, 0);
  };

  if (section === 'orbital') return <OrbitalSection onHome={goHome} onSection={goSection} />;
  return params ? (
    <Viewer params={params} onChange={update} onOpen={open} onHome={goHome} onSection={goSection} />
  ) : (
    <Home onOpen={open} onSection={goSection} />
  );
}
