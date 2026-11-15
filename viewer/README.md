# Xtremis · Frontend (prototipo 3)

> **Xtremis** es un nombre tentativo. Para cambiarlo: `appName` en `src/i18n.tsx` (español e inglés) y el `<title>` y el texto de carga en `index.html`.

Visor web público de imágenes de SPHEREx (NASA Space Apps Challenge 2026, reto *Planet X and SPHEREx*).
React + TypeScript + Vite, sin librerías de UI ni de gráficas: solo `react` y `react-dom`.

## Ejecutar el proyecto con Docker desde la raíz

Desde la carpeta principal del repositorio (donde está `docker-compose.yml`):

```bash
docker compose up --build
```

Abre **http://localhost:8080**. El contenedor `xtremis-frontend` sirve la versión compilada mediante Nginx (puerto 80 del contenedor publicado como puerto 8080 en tu equipo). El modo demo está activado, así que no requiere backend. Para detenerlo, usa `Ctrl + C` o ejecuta `docker compose down` desde la raíz.

## Arrancar

```bash
cd viewer
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

1. **Inicio**: fondo de galaxia animado, buscador "Pon tu coordenada aquí" y una regla dorada con los 5 objetos de prueba.
2. **Visor**:
   - Imagen grande con botón de pantalla completa y **panel de coordenadas de la mira** (RA/Dec, grados, galácticas,
     desplazamiento desde el centro, banda y época). Las **flechas** mueven la cruz dorada; al acercarse a un borde,
     el visor centra y consulta otra zona del cielo con solapamiento para continuar la exploración. (Shift = rápido; Enter = seleccionar.)
   - **Línea de tiempo desde 2025** (inicio de SPHEREx) con un planeta arrastrable, por año o por barrido.
     El código ya soporta NEOWISE (2015–2024) para extenderla hacia atrás, pero está desactivado
     (`INCLUDE_NEOWISE` en `src/api/mock.ts`).
   - **Luz**: todas las bandas, un detector (1–6), **cualquiera de las 102 bandas** (deslizador con su longitud de onda)
     o **color falso** (azul = D1–2, verde = D3–4, rojo = D5–6).
   - Modos Animar / Restar / Sumar, campo de visión (5′–40′), capas Gaia / WISE / banderas.
   - Panel con **espectro** (102 puntos; clic en el espectro = ver esa banda) y **curva de luz**,
     ambos ampliables a pantalla completa.
   - Preparado para sincronizarse con el **modelo 3D del equipo**: ver [INTEGRACION_MODELO.md](INTEGRACION_MODELO.md).

Atajos: flechas = mover la mira dorada y explorar nuevas zonas del cielo (sin hacer clic antes) · Shift + flechas = movimiento rápido · al llegar cerca del borde se solicita otro campo con solapamiento · Enter = seleccionar · Espacio = reproducir · `[` `]` = cambiar de año · Esc = salir de pantalla completa.

Todo el estado del visor vive en la URL, así que cualquier vista se puede compartir o incrustar:

```
/?ra=133.79513&dec=-7.24515&fov=10&det=6&mode=diff&name=WISE%200855
```

`det` acepta: `all`, `1`…`6` (detector), `b1`…`b102` (banda), `rgb` (color falso).

Formatos de coordenadas aceptados en el buscador: `133.795 -7.245`, `08h55m10.831s -07d14m42.53s`,
`08:55:10.831 -07:14:42.53`, `08 55 10.831 -07 14 42.53`.

## Contrato de API (lo que debe implementar el backend)

Todos los endpoints son `GET`. `fov` está en minutos de arco; `ra`/`dec` en grados.

| Endpoint | Parámetros | Respuesta |
|---|---|---|
| `/api/resolve` | `name` | `{ name, ra, dec }` (404 si no existe). Sugerencia: Sesame de CDS vía astroquery. |
| `/api/epochs` | `ra, dec, fov` | `[{ id, mission, index, start, end, mid, nExposures? }]`. `mission` = `spherex` (un barrido cada ~6 meses desde 2025). Opcional a futuro: `neowise` (2015–2024). |
| `/api/frame` | `ra, dec, fov, det, epoch, mode, ref?` | **PNG** listo para mostrar. `det` = `all`, `1`…`6`, `b1`…`b102` o `rgb` (en épocas NEOWISE usar la banda W1 3.4 µm o W2 4.6 µm más cercana; en `rgb`, azul = W1 y rojo = W2). `mode` = `animate` \| `diff` \| `sum`. `epoch` es uno o varios barridos separados por coma (`s2,s3`) que se **apilan**: así se forman los cuadros "por año". Con `mode=sum`, `epoch=all`. Con `mode=diff`, `ref` = época(s) que se restan (el frontend siempre manda una referencia de la misma misión). |
| `/api/flags` | igual que `/api/frame` | **PNG transparente** con los píxeles marcados en la capa FLAGS. |
| `/api/catalog` | `ra, dec, fov, cat` (`gaia` \| `wise`) | `[{ ra, dec, id?, mag? }]` |
| `/api/spectrum` | `ra, dec, det, fra, fdec, epoch?` | `{ found, unit, points: [{ wavelength, flux, err }] }` |
| `/api/lightcurve` | `ra, dec, det, fra, fdec, epoch?` | `{ found, unit, points: [{ date, flux, err, mission? }] }` (puede incluir puntos de NEOWISE y SPHEREx) |

`ra/dec` en spectrum/lightcurve es el punto clicado; `fra/fdec` es el centro del campo; `epoch` es la época que se ve (para ubicar estrellas que se mueven).

### Reglas importantes para `/api/frame`

- **Misma rejilla para todas las épocas**: reproyectar los cutouts al mismo WCS (paquete `reproject`); si no, el video tiembla.
- **Mismo estiramiento de brillo para todas las épocas** (asinh/log con límites fijos calculados una vez). Si cada cuadro se
  normaliza por separado, el parpadeo inventa cambios.
- `mode=diff`: época actual menos la primera. Positivo = cian, negativo = naranja (o devolver escala divergente).
- Cachear en disco: los cutouts de IRSA tardan.

### Fuentes de datos

- SPHEREx: IRSA SIA2, colección `spherex_qr2` (`astroquery.ipac.irsa.Irsa.query_sia`) + servicio de cutouts de IRSA.
- (Opcional, desactivado) NEOWISE (2015–2024): imágenes de una sola exposición o *unWISE time-domain coadds* (época por época), también en IRSA.
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

## Pendiente / ideas

- Conectar el backend real y validar con los 5 objetos de prueba.
- Propagar el movimiento propio: Barnard's Star y WISE 0855 ya no están en su posición de catálogo J2000.
- Integrar Aladin Lite como mapa de contexto alrededor del recorte.
- Mostrar cada exposición individual, no solo un apilado por barrido.
- Verificar los rangos de longitud de onda por detector y los centros de las 102 bandas (`src/lib/detectors.ts`) contra el SPHEREx Explanatory Supplement.
- Conectar el modelo 3D del equipo cuando tenga URL (ver INTEGRACION_MODELO.md).
