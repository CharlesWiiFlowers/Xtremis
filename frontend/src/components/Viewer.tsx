import { useEffect, useMemo, useState } from 'react';
import { api, type CatalogSource, type Epoch } from '../api';
import { useI18n } from '../i18n';
import type { SkyCoord } from '../lib/coords';
import { buildFrames, frameEpochParam, type FrameGroup } from '../lib/frames';
import { buildQuery, type ViewParams } from '../lib/urlState';
import { DemoBadge, LangToggle, Logo } from './Chrome';
import { Overlay } from './Overlay';
import { SearchBar } from './SearchBar';
import { SidePanel } from './SidePanel';
import { SkyImage } from './SkyImage';
import { Timeline, useFrameLabel } from './Timeline';
import { Toolbar, type Layers } from './Toolbar';

interface Props {
  params: ViewParams;
  onChange: (patch: Partial<ViewParams>) => void;
  onOpen: (p: ViewParams) => void;
  onHome: () => void;
}

/** Precarga una imagen para que la animación no parpadee al cambiar de cuadro. */
function preload(url: string): Promise<void> {
  return new Promise((resolve) => {
    const img = new Image();
    img.onload = () => resolve();
    img.onerror = () => resolve();
    img.src = url;
  });
}

export function Viewer({ params, onChange, onOpen, onHome }: Props) {
  const { t } = useI18n();
  const label = useFrameLabel();
  const { ra, dec, fov, det, mode } = params;
  const center = useMemo<SkyCoord>(() => ({ ra, dec }), [ra, dec]);

  const [epochs, setEpochs] = useState<Epoch[] | null>(null);
  const [epochError, setEpochError] = useState(false);
  const [group, setGroup] = useState<FrameGroup>('year');
  const [index, setIndex] = useState(0);
  const [playing, setPlaying] = useState(false);
  const [speed, setSpeed] = useState(1);
  const [images, setImages] = useState<(string | null)[]>([]);
  const [imageError, setImageError] = useState(false);
  const [flags, setFlags] = useState<(string | null)[]>([]);
  const [layers, setLayers] = useState<Layers>({ gaia: false, wise: false, flags: false });
  const [gaia, setGaia] = useState<CatalogSource[] | null>(null);
  const [wise, setWise] = useState<CatalogSource[] | null>(null);
  const [selected, setSelected] = useState<SkyCoord | null>(null);
  const [copied, setCopied] = useState(false);
  const [fullscreen, setFullscreen] = useState(false);

  // 1) Barridos disponibles para esta zona
  useEffect(() => {
    let alive = true;
    setEpochs(null);
    setEpochError(false);
    setSelected(null);
    setPlaying(false);
    api
      .getEpochs({ ra, dec, fov })
      .then((e) => {
        if (!alive) return;
        setEpochs(e);
        setIndex(0);
        setPlaying(e.length > 1); // arranca reproduciendo: es "un video"
      })
      .catch(() => alive && setEpochError(true));
    return () => {
      alive = false;
    };
  }, [ra, dec, fov]);

  // 2) Cuadros de la animación: por año (por defecto) o por barrido
  const frames = useMemo(() => (epochs ? buildFrames(epochs, group) : []), [epochs, group]);
  useEffect(() => setIndex((i) => Math.min(i, Math.max(0, frames.length - 1))), [frames.length]);

  const requests = useMemo(() => {
    if (!frames.length) return [];
    if (mode === 'sum') return ['all'];
    return frames.map(frameEpochParam);
  }, [frames, mode]);
  const ref = frames.length ? frameEpochParam(frames[0]) : undefined;

  useEffect(() => {
    if (!requests.length) {
      setImages([]);
      return;
    }
    let alive = true;
    setImageError(false);
    setImages(requests.map(() => null));
    requests.forEach((epochId, i) => {
      api
        .getFrameUrl({ ra, dec, fov, detector: det, epochId, mode, refEpochId: mode === 'diff' ? ref : undefined })
        .then(async (url) => {
          await preload(url);
          if (alive) setImages((prev) => prev.map((v, j) => (j === i ? url : v)));
        })
        .catch(() => alive && setImageError(true));
    });
    return () => {
      alive = false;
    };
  }, [requests, ref, ra, dec, fov, det, mode]);

  // 3) Banderas de calidad
  useEffect(() => {
    if (!layers.flags || !requests.length) {
      setFlags([]);
      return;
    }
    let alive = true;
    setFlags(requests.map(() => null));
    requests.forEach((epochId, i) => {
      api
        .getFlagsUrl({ ra, dec, fov, detector: det, epochId, mode })
        .then((url) => alive && setFlags((prev) => prev.map((v, j) => (j === i ? url : v))))
        .catch(() => undefined);
    });
    return () => {
      alive = false;
    };
  }, [layers.flags, requests, ra, dec, fov, det, mode]);

  // 4) Catálogos externos
  useEffect(() => {
    let alive = true;
    if (layers.gaia) api.getCatalog({ ra, dec, fov }, 'gaia').then((s) => alive && setGaia(s)).catch(() => undefined);
    else setGaia(null);
    return () => {
      alive = false;
    };
  }, [layers.gaia, ra, dec, fov]);

  useEffect(() => {
    let alive = true;
    if (layers.wise) api.getCatalog({ ra, dec, fov }, 'wise').then((s) => alive && setWise(s)).catch(() => undefined);
    else setWise(null);
    return () => {
      alive = false;
    };
  }, [layers.wise, ra, dec, fov]);

  // 5) Reproducción
  const n = frames.length;
  const canPlay = mode !== 'sum' && n > 1;
  useEffect(() => {
    if (!playing || !canPlay) return;
    const id = window.setInterval(() => setIndex((i) => (i + 1) % n), 1000 / speed);
    return () => window.clearInterval(id);
  }, [playing, canPlay, n, speed]);

  // 6) Atajos de teclado
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const el = e.target as HTMLElement;
      if (['INPUT', 'SELECT', 'TEXTAREA'].includes(el.tagName) || el.getAttribute('role') === 'slider' || !canPlay) return;
      if (e.key === ' ') {
        e.preventDefault();
        setPlaying((p) => !p);
      } else if (e.key === 'ArrowRight') {
        setPlaying(false);
        setIndex((i) => (i + 1) % n);
      } else if (e.key === 'ArrowLeft') {
        setPlaying(false);
        setIndex((i) => (i - 1 + n) % n);
      }
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [canPlay, n]);

  const imgIdx = mode === 'sum' ? 0 : Math.min(index, Math.max(0, images.length - 1));
  // Si el cuadro actual aún no carga, muestra otro disponible para no dejar la imagen en negro.
  const frameUrl = images[imgIdx] ?? images.find(Boolean) ?? null;
  const flagsUrl = layers.flags ? flags[imgIdx] ?? null : null;
  const currentFrame = frames[Math.min(index, n - 1)] ?? null;

  const status: 'loading' | 'error' | 'empty' | 'ready' =
    epochError || imageError ? 'error' : !epochs ? 'loading' : epochs.length === 0 ? 'empty' : frameUrl ? 'ready' : 'loading';

  const share = async () => {
    const url = `${window.location.origin}${window.location.pathname}?${buildQuery(params)}`;
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      window.setTimeout(() => setCopied(false), 1800);
    } catch {
      /* portapapeles bloqueado: no hacemos nada */
    }
  };

  const sky = (large: boolean) => (
    <SkyImage
      center={center}
      fov={fov}
      frameUrl={frameUrl}
      flagsUrl={flagsUrl}
      gaia={gaia}
      wise={wise}
      selected={selected}
      onSelect={setSelected}
      status={status}
      large={large}
      onExpand={large ? undefined : () => setFullscreen(true)}
    />
  );

  const timeline =
    frames.length > 0 ? (
      <Timeline
        frames={frames}
        index={mode === 'sum' ? 0 : index}
        onIndex={(i) => {
          setPlaying(false);
          setIndex(i);
        }}
        playing={playing && canPlay}
        onTogglePlay={() => setPlaying((p) => !p)}
        speed={speed}
        onSpeed={setSpeed}
        group={group}
        onGroup={(g) => {
          setGroup(g);
          setIndex(0);
        }}
        disabled={mode === 'sum'}
      />
    ) : null;

  return (
    <div className="viewer">
      <header className="topbar">
        <Logo onClick={onHome} />
        <div className="topbar-search">
          <SearchBar onOpen={onOpen} current={params} size="sm" />
        </div>
        <div className="topbar-right">
          <DemoBadge />
          <button className="btn btn-ghost" onClick={share}>
            <svg width="15" height="15" viewBox="0 0 24 24" aria-hidden="true">
              <path d="M10 14a5 5 0 0 0 7 0l3-3a5 5 0 0 0-7-7l-1 1M14 10a5 5 0 0 0-7 0l-3 3a5 5 0 0 0 7 7l1-1" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" />
            </svg>
            {copied ? t('copied') : t('share')}
          </button>
          <LangToggle />
        </div>
      </header>

      <main className="viewer-main">
        <section className="stage">
          {sky(false)}
          {timeline}
          <Toolbar params={params} onChange={onChange} layers={layers} onLayers={setLayers} />
          <p className="shortcuts">{t('shortcuts')}</p>
        </section>

        <SidePanel
          center={center}
          fov={fov}
          name={params.name}
          frame={currentFrame}
          mode={mode}
          detector={det}
          layers={layers}
          selected={selected}
        />
      </main>

      <Overlay
        open={fullscreen}
        onClose={() => setFullscreen(false)}
        title={
          <>
            <strong>{params.name ?? t('panelField')}</strong>
            {currentFrame && mode !== 'sum' && <span className="muted"> · {label(currentFrame).title}</span>}
          </>
        }
      >
        <div className="overlay-sky">
          {sky(true)}
          {timeline}
        </div>
      </Overlay>
    </div>
  );
}
