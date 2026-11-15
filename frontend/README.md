# SkyBlink · Frontend v1

Visor web público de imágenes de SPHEREx (NASA Space Apps Challenge 2026, reto *Planet X and SPHEREx*).
React + TypeScript + Vite, sin librerías de UI ni de gráficas: solo `react` y `react-dom`.

## Arrancar

```bash
cd frontend
npm install
npm run dev        # http://localhost:5173
npm run build      # genera dist/ (estático, se puede subir a GitHub Pages, Netlify, Vercel…)
```

Por defecto corre en **modo demo**: las imágenes, espectros y curvas de luz son **simulados**
(`src/api/mock.ts`) para poder trabajar la interfaz sin backend. Se muestra un aviso "Datos simulados".

Para usar el backend real, crea `.env.local`:

```
VITE_USE_MOCK=false
VITE_API_URL=            # vacío = mismo origen; en dev Vite redirige /api a localhost:8000
```

## Pantallas

1. **Inicio**: buscador (nombre o coordenadas) y tarjetas con los 5 objetos de prueba del reto.
2. **Visor**: imagen grande (con pantalla completa) + regla de tiempo con un planeta arrastrable, por año o por barrido, con Play, modos Animar / Restar / Sumar, selector de detector (1–6 o todos),
   campo de visión (5′–40′), capas Gaia / WISE / banderas de contaminación, y panel con espectro y curva de luz
   (ampliables a pantalla completa) al hacer clic en una estrella.

Todo el estado del visor vive en la URL, así que cualquier vista se puede compartir o incrustar:

```
/?ra=133.79513&dec=-7.24515&fov=10&det=6&mode=diff&name=WISE%200855
```

Formatos de coordenadas aceptados en el buscador: `133.795 -7.245`, `08h55m10.831s -07d14m42.53s`,
`08:55:10.831 -07:14:42.53`, `08 55 10.831 -07 14 42.53`.

## Contrato de API (lo que debe implementar el backend)

Todos los endpoints son `GET`. `fov` está en minutos de arco; `ra`/`dec` en grados.

| Endpoint | Parámetros | Respuesta |
|---|---|---|
| `/api/resolve` | `name` | `{ name, ra, dec }` (404 si no existe). Sugerencia: Sesame de CDS vía astroquery. |
| `/api/epochs` | `ra, dec, fov` | `[{ id, index, start, end, mid, nExposures? }]`, una entrada por barrido de ~6 meses. |
| `/api/frame` | `ra, dec, fov, det, epoch, mode, ref?` | **PNG** listo para mostrar. `det` = `all` o `1`…`6`. `mode` = `animate` \| `diff` \| `sum`. `epoch` es uno o varios barridos separados por coma (`s2,s3`) que se **apilan**: así se forman los cuadros "por año". Con `mode=sum`, `epoch=all`. Con `mode=diff`, `ref` = barrido(s) que se restan. |
| `/api/flags` | igual que `/api/frame` | **PNG transparente** con los píxeles marcados en la capa FLAGS. |
| `/api/catalog` | `ra, dec, fov, cat` (`gaia` \| `wise`) | `[{ ra, dec, id?, mag? }]` |
| `/api/spectrum` | `ra, dec, det, fra, fdec` | `{ found, unit, points: [{ wavelength, flux, err }] }` |
| `/api/lightcurve` | `ra, dec, det, fra, fdec` | `{ found, unit, points: [{ date, flux, err }] }` |

`ra/dec` en spectrum/lightcurve es el punto clicado; `fra/fdec` es el centro del campo.

### Reglas importantes para `/api/frame`

- **Misma rejilla para todas las épocas**: reproyectar los cutouts al mismo WCS (paquete `reproject`); si no, el video tiembla.
- **Mismo estiramiento de brillo para todas las épocas** (asinh/log con límites fijos calculados una vez). Si cada cuadro se
  normaliza por separado, el parpadeo inventa cambios.
- `mode=diff`: época actual menos la primera. Positivo = cian, negativo = naranja (o devolver escala divergente).
- Cachear en disco: los cutouts de IRSA tardan.

### Fuentes de datos

- SPHEREx: IRSA SIA2, colección `spherex_qr2` (`astroquery.ipac.irsa.Irsa.query_sia`) + servicio de cutouts de IRSA.
- Gaia DR3: `astroquery.gaia` o TAP de ESA. WISE/CatWISE: IRSA TAP.

## Estructura

```
src/
  api/        types.ts (contrato) · http.ts (backend real) · mock.ts (modo demo)
  lib/        coords.ts · detectors.ts · targets.ts · urlState.ts
  components/ Home · Viewer · Toolbar · SkyImage · Timeline · SidePanel · LineChart · SearchBar · Chrome
  i18n.tsx    textos en español e inglés
  styles.css
```

## Pendiente / ideas v2

- Conectar el backend real y validar con los 5 objetos de prueba.
- Propagar el movimiento propio: Barnard's Star y WISE 0855 ya no están en su posición de catálogo J2000.
- Integrar Aladin Lite como mapa de contexto alrededor del recorte.
- Mostrar cada exposición individual, no solo un apilado por barrido.
- Verificar los rangos de longitud de onda por detector contra el SPHEREx Explanatory Supplement.
