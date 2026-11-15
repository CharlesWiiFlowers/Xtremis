import { createContext, useContext, useMemo, useState, type ReactNode } from 'react';

export type Lang = 'es' | 'en';

const es = {
  heroEyebrow: 'Visor infrarrojo de SPHEREx · NASA',
  heroTitleA: 'Descubre lo que',
  heroTitleB: 'se mueve en el cielo.',
  heroPlaceholder: 'Pon tu coordenada aquí (ej. 133.79 -7.24)',
  heroButton: 'Explorar',
  seeExample: 'Ver un ejemplo',
  navExplore: 'Explorar',
  navExamples: 'Ejemplos',
  navHow: 'Cómo funciona',
  openViewer: 'Abrir visor',
  startAnywhere: 'Empieza donde quieras',
  perYear: '{v}″ por año',
  irregular: 'Variación irregular',
  periodDays: 'Ciclo de {n} días',
  expand: 'Pantalla completa',
  close: 'Cerrar',
  groupBy: 'Ver por',
  byYear: 'Año',
  bySurvey: 'Barrido',
  yearN: 'Año {y}',
  surveysList: 'Barridos {list}',
  surveyOne: 'Barrido {n}',
  dragHint: 'Arrastra el planeta',
  appName: 'SkyBlink',
  tagline: 'El cielo infrarrojo de SPHEREx, en movimiento',
  heroTitle: 'Descubre lo que se mueve en el cielo',
  heroSub:
    'La misión SPHEREx de la NASA fotografía todo el cielo cada seis meses en 102 colores infrarrojos. Escribe unas coordenadas o el nombre de un objeto y mira sus imágenes como un video.',
  searchPlaceholder: "Nombre (Barnard's Star) o coordenadas (08h55m10.8s -07d14m42s)",
  searchButton: 'Ver',
  searching: 'Buscando…',
  searchError: 'No encontramos ese objeto. Prueba con coordenadas RA y Dec.',
  examplesTitle: 'Empieza con un ejemplo',
  kindMoving: 'Se mueve',
  kindVariable: 'Cambia de brillo',
  howTitle: '¿Cómo funciona?',
  how1Title: 'Elige un punto del cielo',
  how1: 'Escribe coordenadas (RA y Dec) o el nombre de un objeto.',
  how2Title: 'Mira el video',
  how2: 'Las imágenes de cada barrido de SPHEREx se reproducen en orden.',
  how3Title: 'Busca lo que cambia',
  how3: 'Resta imágenes, cambia de detector y haz clic en una estrella para ver su espectro.',
  footer: 'Proyecto para NASA Space Apps Challenge 2026 · Datos: NASA/IPAC IRSA (SPHEREx)',
  demoBadge: 'Datos simulados',
  demoTooltip: 'Modo demo: las imágenes son simuladas hasta conectar el backend.',
  share: 'Compartir',
  copied: '¡Enlace copiado!',
  home: 'Inicio',
  mode: 'Modo',
  modeAnimate: 'Animar',
  modeDiff: 'Restar',
  modeSum: 'Sumar',
  modeHelpAnimate: 'Reproduce las imágenes en orden, año por año.',
  modeHelpDiff: 'Cada año menos el primero: lo que cambió aparece en color.',
  modeHelpSum: 'Promedio de todos los barridos: menos ruido, más estrellas débiles.',
  detector: 'Detector',
  detAll: 'Todos ({range} µm)',
  detN: 'Detector {n} ({range} µm)',
  fov: 'Campo',
  layers: 'Capas',
  layerGaia: 'Gaia',
  layerWise: 'WISE',
  layerFlags: 'Banderas',
  play: 'Reproducir',
  pause: 'Pausar',
  prev: 'Barrido anterior',
  next: 'Barrido siguiente',
  speed: 'Velocidad',
  survey: 'Barrido {n}',
  loading: 'Cargando imágenes…',
  loadError: 'No se pudieron cargar las imágenes. Intenta de nuevo.',
  noEpochs: 'SPHEREx aún no tiene imágenes de esta zona.',
  panelField: 'Zona del cielo',
  fieldCenter: 'Centro',
  fieldFov: 'Campo de visión',
  currentEpoch: 'Mostrando',
  allSurveys: 'Todos los barridos',
  legendTitle: 'Cómo leer la imagen',
  legendNew: 'Brillo o posición nueva (azul)',
  legendOld: 'Brillo o posición anterior (dorado)',
  legendFlags: 'Píxel con bandera (posible contaminación)',
  legendGaia: 'Gaia (posición en 2016)',
  legendWise: 'WISE (posición ~2010)',
  legendCenter: 'Centro de la búsqueda',
  pointTitle: 'Punto seleccionado',
  clickHint: 'Haz clic en una estrella de la imagen para ver su espectro y su curva de luz.',
  tabSpectrum: 'Espectro',
  tabLightcurve: 'Curva de luz',
  noSource: 'No hay una fuente clara en ese punto; se muestra solo el ruido de fondo.',
  wavelength: 'Longitud de onda (µm)',
  flux: 'Flujo',
  date: 'Fecha',
  spectrumHelp: 'Cuánta luz emite el objeto en cada color infrarrojo. Las caídas revelan moléculas como agua o metano.',
  lightcurveHelp: 'Brillo del objeto en cada observación. Si sube y baja, es una estrella variable.',
  shortcuts: 'Atajos: Espacio = reproducir · ← → = avanzar o retroceder · Esc = salir de pantalla completa',
  loadingChart: 'Calculando…',
} as const;

export type I18nKey = keyof typeof es;

const en: Record<I18nKey, string> = {
  heroEyebrow: 'SPHEREx infrared viewer · NASA',
  heroTitleA: 'Discover what',
  heroTitleB: 'moves in the sky.',
  heroPlaceholder: 'Enter your coordinates here (e.g. 133.79 -7.24)',
  heroButton: 'Explore',
  seeExample: 'See an example',
  navExplore: 'Explore',
  navExamples: 'Examples',
  navHow: 'How it works',
  openViewer: 'Open viewer',
  startAnywhere: 'Start anywhere',
  perYear: '{v}″ per year',
  irregular: 'Irregular variation',
  periodDays: '{n}-day cycle',
  expand: 'Full screen',
  close: 'Close',
  groupBy: 'View by',
  byYear: 'Year',
  bySurvey: 'Survey',
  yearN: 'Year {y}',
  surveysList: 'Surveys {list}',
  surveyOne: 'Survey {n}',
  dragHint: 'Drag the planet',
  appName: 'SkyBlink',
  tagline: 'The SPHEREx infrared sky, in motion',
  heroTitle: 'Discover what moves in the sky',
  heroSub:
    "NASA's SPHEREx mission photographs the whole sky every six months in 102 infrared colors. Type coordinates or an object's name and watch its images like a video.",
  searchPlaceholder: "Name (Barnard's Star) or coordinates (08h55m10.8s -07d14m42s)",
  searchButton: 'View',
  searching: 'Searching…',
  searchError: "We couldn't find that object. Try RA and Dec coordinates.",
  examplesTitle: 'Start with an example',
  kindMoving: 'Moves',
  kindVariable: 'Changes brightness',
  howTitle: 'How does it work?',
  how1Title: 'Pick a spot in the sky',
  how1: "Type coordinates (RA and Dec) or an object's name.",
  how2Title: 'Watch the video',
  how2: 'Images from each SPHEREx survey play in order.',
  how3Title: 'Look for changes',
  how3: 'Subtract images, switch detectors and click a star to see its spectrum.',
  footer: 'Project for NASA Space Apps Challenge 2026 · Data: NASA/IPAC IRSA (SPHEREx)',
  demoBadge: 'Simulated data',
  demoTooltip: 'Demo mode: images are simulated until the backend is connected.',
  share: 'Share',
  copied: 'Link copied!',
  home: 'Home',
  mode: 'Mode',
  modeAnimate: 'Animate',
  modeDiff: 'Subtract',
  modeSum: 'Stack',
  modeHelpAnimate: 'Plays the images in order, year by year.',
  modeHelpDiff: 'Each year minus the first one: whatever changed shows in color.',
  modeHelpSum: 'Average of all surveys: less noise, more faint stars.',
  detector: 'Detector',
  detAll: 'All ({range} µm)',
  detN: 'Detector {n} ({range} µm)',
  fov: 'Field',
  layers: 'Layers',
  layerGaia: 'Gaia',
  layerWise: 'WISE',
  layerFlags: 'Flags',
  play: 'Play',
  pause: 'Pause',
  prev: 'Previous survey',
  next: 'Next survey',
  speed: 'Speed',
  survey: 'Survey {n}',
  loading: 'Loading images…',
  loadError: 'Images could not be loaded. Please try again.',
  noEpochs: 'SPHEREx has no images of this area yet.',
  panelField: 'Sky area',
  fieldCenter: 'Center',
  fieldFov: 'Field of view',
  currentEpoch: 'Showing',
  allSurveys: 'All surveys',
  legendTitle: 'How to read the image',
  legendNew: 'New brightness or position (blue)',
  legendOld: 'Previous brightness or position (gold)',
  legendFlags: 'Flagged pixel (possible contamination)',
  legendGaia: 'Gaia (2016 position)',
  legendWise: 'WISE (~2010 position)',
  legendCenter: 'Search center',
  pointTitle: 'Selected point',
  clickHint: 'Click a star in the image to see its spectrum and light curve.',
  tabSpectrum: 'Spectrum',
  tabLightcurve: 'Light curve',
  noSource: 'No clear source at that point; showing background noise only.',
  wavelength: 'Wavelength (µm)',
  flux: 'Flux',
  date: 'Date',
  spectrumHelp: 'How much light the object emits in each infrared color. Dips reveal molecules like water or methane.',
  lightcurveHelp: "The object's brightness in each observation. If it rises and falls, it's a variable star.",
  shortcuts: 'Shortcuts: Space = play · ← → = step · Esc = exit full screen',
  loadingChart: 'Computing…',
};

const DICTS: Record<Lang, Record<I18nKey, string>> = { es, en };

interface I18nValue {
  lang: Lang;
  setLang: (l: Lang) => void;
  t: (key: I18nKey, vars?: Record<string, string | number>) => string;
}

const I18nContext = createContext<I18nValue | null>(null);

function initialLang(): Lang {
  try {
    const saved = localStorage.getItem('skyblink.lang');
    if (saved === 'es' || saved === 'en') return saved;
  } catch {
    /* almacenamiento no disponible */
  }
  return navigator.language?.toLowerCase().startsWith('en') ? 'en' : 'es';
}

export function I18nProvider({ children }: { children: ReactNode }) {
  const [lang, setLangState] = useState<Lang>(initialLang);
  const value = useMemo<I18nValue>(
    () => ({
      lang,
      setLang: (l) => {
        setLangState(l);
        document.documentElement.lang = l;
        try {
          localStorage.setItem('skyblink.lang', l);
        } catch {
          /* ignorar */
        }
      },
      t: (key, vars) => {
        let s = DICTS[lang][key];
        if (vars) for (const [k, v] of Object.entries(vars)) s = s.replace(`{${k}}`, String(v));
        return s;
      },
    }),
    [lang],
  );
  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useI18n(): I18nValue {
  const ctx = useContext(I18nContext);
  if (!ctx) throw new Error('useI18n fuera de I18nProvider');
  return ctx;
}
