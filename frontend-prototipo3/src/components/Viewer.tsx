import { useEffect, useMemo, useRef, useState } from 'react';
import { api, type CatalogSource, type Epoch } from '../api';
import { useI18n } from '../i18n';
import { angularSepArcsec, offsetToSky, type SkyCoord } from '../lib/coords';
import { buildFrames, diffReference, frameEpochParam, type FrameGroup } from '../lib/frames';
import { targetAt, targetOffsetAt } from '../lib/targets';
import { buildQuery, type ViewParams } from '../lib/urlState';
import { emitSkyEvent, throttleFrame, useSkyCommands } from '../integrations/skyBus';
import { ExternalModel, HAS_MODEL } from '../integrations/ExternalModel';
import { useChannelLabel } from './BandPicker';
import { DemoBadge, LangToggle, Logo } from './Chrome';
import type { CursorInfo } from './CursorPanel';
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

const yearOf = (iso: string) => {
  const d = new Date(iso + 'T00:00:00Z');
  return d.getUTCFullYear() + (d.getUTCMonth() + d.getUTCDate() / 31) / 12;
};

export function Viewer({ params, onChange, onOpen, onHome }: Props) {
  const { t, lang } = useI18n();
  const label = useFrameLabel();
  const channelLabel = useChannelLabel();
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
  const [cursor, setCursor] = useState<SkyCoord | null>(null);
  const [copied, setCopied] = useState(false);
  const [fullscreen, setFullscreen] = useState(false);
  const [view, setView] = useState<'image' | 'model'>('image');

  // 1) Épocas disponibles para esta zona (NEOWISE + SPHEREx)
  useEffect(() => {
    let alive = true;
    setEpochs(null);
    setEpochError(false);
    setSelected(null);
    setCursor(null);
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

  // 2) Cuadros de la animación: por año (por defecto) o por época
  const frames = useMemo(() => (epochs ? buildFrames(epochs, group) : []), [epochs, group]);
  useEffect(() => setIndex((i) => Math.min(i, Math.max(0, frames.length - 1))), [frames.length]);

  const requests = useMemo(() => {
    if (!frames.length) return [];
    if (mode === 'sum') return [{ epochId: 'all', ref: undefined as string | undefined }];
    return frames.map((f) => ({
      epochId: frameEpochParam(f),
      ref: mode === 'diff' ? frameEpochParam(diffReference(frames, f)) : undefined,
    }));
  }, [frames, mode]);

  useEffect(() => {
    if (!requests.length) {
      setImages([]);
      return;
    }
    let alive = true;
    setImageError(false);
    setImages(requests.map(() => null));
    requests.forEach(({ epochId, ref }, i) => {
      api
        .getFrameUrl({ ra, dec, fov, detector: det, epochId, mode, refEpochId: ref })
        .then(async (url) => {
          await preload(url);
          if (alive) setImages((prev) => prev.map((v, j) => (j === i ? url : v)));
        })
        .catch(() => alive && setImageError(true));
    });
    return () => {
      alive = false;
    };
  }, [requests, ra, dec, fov, det, mode]);

  // 3) Banderas de calidad
  useEffect(() => {
    if (!layers.flags || !requests.length) {
      setFlags([]);
      return;
    }
    let alive = true;
    setFlags(requests.map(() => null));
    requests.forEach(({ epochId }, i) => {
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

  // 6) Atajos de teclado globales. Sobre la imagen, las flechas mueven el cursor (lo maneja SkyImage).
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const el = e.target as HTMLElement;
      if (['INPUT', 'SELECT', 'TEXTAREA'].includes(el.tagName) || el.getAttribute('role') === 'slider') return;
      if (el.closest?.('.sky') || !canPlay) return;
      const step = (d: number) => {
        setPlaying(false);
        setIndex((i) => (i + d + n) % n);
      };
      if (e.key === ' ') {
        e.preventDefault();
        setPlaying((p) => !p);
      } else if (e.key === 'ArrowRight' || e.key === ']') step(1);
      else if (e.key === 'ArrowLeft' || e.key === '[') step(-1);
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [canPlay, n]);

  const imgIdx = mode === 'sum' ? 0 : Math.min(index, Math.max(0, images.length - 1));
  // Si el cuadro actual aún no carga, muestra otro disponible para no dejar la imagen en negro.
  const frameUrl = images[imgIdx] ?? images.find(Boolean) ?? null;
  const flagsUrl = layers.flags ? flags[imgIdx] ?? null : null;
  const currentFrame = frames[Math.min(index, n - 1)] ?? null;
  const mission = mode === 'sum' ? 'spherex' : currentFrame?.mission ?? 'spherex';

  const status: 'loading' | 'error' | 'empty' | 'ready' =
    epochError || imageError ? 'error' : !epochs ? 'loading' : epochs.length === 0 ? 'empty' : frameUrl ? 'ready' : 'loading';

  // 7) Información del panel de coordenadas: ¿el cursor está sobre el objeto de prueba?
  const target = useMemo(() => targetAt(center), [center]);
  const cursorInfo: CursorInfo = useMemo(() => {
    const epochText = mode === 'sum' || !currentFrame ? t('allSurveys') : `${label(currentFrame).title} · ${label(currentFrame).sub}`;
    const info: CursorInfo = { light: channelLabel(det, mission), epoch: epochText };
    if (target && cursor && currentFrame) {
      const off = targetOffsetAt(target, yearOf(currentFrame.mid));
      const pos = offsetToSky(center, off.x, off.y);
      const tolerance = Math.max(12, ((fov * 60) / 200) * 4);
      if (angularSepArcsec(pos, cursor) < tolerance) {
        info.objectName = target.name;
        info.objectKind = target.desc[lang];
      }
    } else if (cursor && angularSepArcsec(center, cursor) < 6 && !target) {
      info.objectName = t('cursorCenter');
    }
    return info;
    // label y channelLabel dependen solo del idioma
  }, [cursor, currentFrame, det, mission, mode, target, center, fov, lang]);

  // 8) Sincronización con otros visores (modelo 3D del equipo). Ver INTEGRACION_MODELO.md
  useEffect(() => {
    emitSkyEvent({
      type: 'view',
      ra,
      dec,
      fov,
      channel: det,
      frame: currentFrame && mode !== 'sum' ? { year: currentFrame.year, mission: currentFrame.mission, mid: currentFrame.mid } : null,
    });
  }, [ra, dec, fov, det, mode, currentFrame]);

  const emitCursor = useRef(throttleFrame((c: SkyCoord) => emitSkyEvent({ type: 'cursor', ra: c.ra, dec: c.dec }))).current;
  const updateCursor = (c: SkyCoord | null) => {
    setCursor(c);
    if (c) emitCursor(c);
  };
  const select = (c: SkyCoord) => {
    setSelected(c);
    emitSkyEvent({ type: 'select', ra: c.ra, dec: c.dec });
  };

  useSkyCommands((c) => {
    if (c.type === 'goto') onOpen({ ...params, ra: c.ra, dec: c.dec, fov: c.fov ?? params.fov, name: c.name });
    else if (c.type === 'cursor') setCursor({ ra: c.ra, dec: c.dec });
    else if (c.type === 'select') setSelected({ ra: c.ra, dec: c.dec });
  });

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
      onSelect={select}
      cursor={cursor}
      onCursor={updateCursor}
      cursorInfo={cursorInfo}
      badge={channelLabel(det, mission)}
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
          {HAS_MODEL && (
            <div className="segmented view-switch" role="tablist">
              <button role="tab" aria-selected={view === 'image'} className={view === 'image' ? 'active' : ''} onClick={() => setView('image')}>
                {t('viewImage')}
              </button>
              <button role="tab" aria-selected={view === 'model'} className={view === 'model' ? 'active' : ''} onClick={() => setView('model')}>
                {t('viewModel')}
              </button>
            </div>
          )}
          {view === 'model' && HAS_MODEL ? (
            <div className="model-wrap">
              <ExternalModel ra={ra} dec={dec} fov={fov} title={t('viewModel')} />
            </div>
          ) : (
            sky(false)
          )}
          {timeline}
          <Toolbar params={params} onChange={onChange} layers={layers} onLayers={setLayers} />
          <p className="shortcuts">{t('shortcuts')}</p>
        </section>

        <SidePanel
          center={center}
          fov={fov}
          name={params.name}
          frame={mode === 'sum' ? null : currentFrame}
          mode={mode}
          detector={det}
          layers={layers}
          selected={selected}
          onChannel={(c) => onChange({ det: c })}
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
