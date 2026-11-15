import { useEffect, useState } from 'react';
import { Home } from './components/Home';
import { Viewer } from './components/Viewer';
import { readParams, writeParams, type ViewParams } from './lib/urlState';

// Dos pantallas: si la URL trae ra/dec se abre el visor; si no, el inicio.
export default function App() {
  const [params, setParams] = useState<ViewParams | null>(() => readParams());

  useEffect(() => {
    const onPop = () => setParams(readParams());
    window.addEventListener('popstate', onPop);
    return () => window.removeEventListener('popstate', onPop);
  }, []);

  const open = (p: ViewParams) => {
    writeParams(p, true);
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
    setParams(null);
  };

  return params ? (
    <Viewer params={params} onChange={update} onOpen={open} onHome={goHome} />
  ) : (
    <Home onOpen={open} />
  );
}
