# Contexto del proyecto (para Devin y nuevos colaboradores)

## El reto
NASA Space Apps Challenge 2026 — **Planet X and SPHEREx**
https://www.spaceappschallenge.org/2026/challenges/planet-x-and-spherex/?tab=details

Crear una herramienta web **pública** que muestre imágenes del cielo de la misión SPHEREx (NASA) y permita ver
cómo cambian con el tiempo:

- El usuario escribe coordenadas (Ascensión Recta y Declinación).
- La herramienta muestra una serie de imágenes de esa zona **como un video corto** para detectar objetos que se mueven.
- **Objetos de prueba obligatorios:** Barnard's Star, Epsilon Indi B, WISE 0855 (RA 08h55m10.831s, Dec −7d14m42.53s),
  RW Aurigae y R Draconis.
- Puntos extra (opcionales): fácil de actualizar con datos nuevos; aprovechar las 102 bandas (sumar por detector, espectros
  al vuelo); sumar o restar épocas; campo de visión elegible; superponer Gaia y WISE; coordenadas en la URL (para incrustar);
  mostrar banderas de contaminación; usar Astropy y Aladin.

Datos clave de SPHEREx: mapea todo el cielo cada ~6 meses, 102 bandas entre 0.75 y 5.0 µm, 6 detectores.
Las imágenes se publican cada semana en IRSA (colección SIA2 `spherex_qr2`), con servicio de cutouts.

## División del trabajo (IMPORTANTE)
- **Frontend (carpeta `frontend/`):** a cargo de Alisson, en su propia rama. Es la ÚNICA parte que se trabaja desde esta rama.
- **Backend y base de datos:** a cargo de otros compañeros del equipo, en sus propias ramas.
- Desde la rama de frontend **no se debe crear ni modificar** nada fuera de `frontend/` (ni backend, ni base de datos,
  ni archivos de configuración de la raíz) sin acordarlo antes con el equipo.
- El punto de unión entre frontend y backend es el **contrato de API** de `frontend/README.md`. Si el backend define
  otro formato, se adapta `frontend/src/api/http.ts`, no el resto de la interfaz.

## Stack
- **Frontend:** React + TypeScript + Vite (carpeta `frontend/`). Sin librerías de UI ni de gráficas.
- **Backend (lo hacen otros compañeros):** Python con microservicios, para consultar IRSA y generar las imágenes.

## Estado actual: frontend prototipo 3 (funciona con datos SIMULADOS)
Ver `frontend/README.md` para correrlo y para el **contrato de API** completo que el backend debe implementar.

- Modo demo activo por defecto (`src/api/mock.ts`): genera campos de estrellas sintéticos y coloca los 5 objetos de prueba
  con su movimiento propio, variabilidad y "color" infrarrojo aproximados. La interfaz muestra la etiqueta "Datos simulados".
- Para usar el backend real: `VITE_USE_MOCK=false` en `frontend/.env.local`.

### Pantallas
1. **Inicio:** fondo de galaxia animado (canvas, sin imágenes externas), título "Descubre lo que se mueve en el cielo",
   buscador "Pon tu coordenada aquí" con botón dorado, y una regla dorada con los 5 objetos de prueba.
2. **Visor:** imagen grande con botón de pantalla completa → línea de tiempo con un **planeta deslizable** marcado por años
   → barra de herramientas (modo Animar/Restar/Sumar, detector 1–6, campo de visión 5′–40′, capas Gaia/WISE/banderas).
   Panel lateral con datos del campo, leyenda, **espectro** y **curva de luz** (ambas ampliables a pantalla completa).
   El estado vive en la URL: `?ra=…&dec=…&fov=…&det=…&mode=…&name=…`. Español/inglés.

### Novedades del prototipo 3
- **Panel de coordenadas de la mira de exploración** sobre la imagen (estilo Stellarium): RA/Dec, grados, galácticas,
  desplazamiento desde el centro, banda y época. Las **flechas** mueven la cruz dorada; al acercarse al borde, el visor
  recentra la observación y consulta otro recorte con solapamiento para explorar regiones contiguas del cielo.
  Shift acelera el movimiento y Enter selecciona el punto apuntado.
- **Línea de tiempo desde 2025**, cuando SPHEREx empezó a observar. El código soporta extenderla con NEOWISE
  (2015–2024), pero el equipo decidió dejarla solo con SPHEREx (`INCLUDE_NEOWISE = false` en `src/api/mock.ts`).
- **102 bandas**: selector Todas / Detector / Banda (deslizador 1–102 con su longitud de onda) / Color falso.
  Al hacer clic en el espectro se muestra esa banda en la imagen.
- **Integración con el modelo 3D del compañero preparada** (no activada): ver `frontend/INTEGRACION_MODELO.md`.

### Decisiones de diseño (feedback del equipo y de mentores)
- Paleta inspirada en una referencia tipo "atlas del cosmos": negro profundo, **dorado** (#f2b45f) para acciones y la regla
  de tiempo, **azul galaxia** (#7cb7ff). Tipografía Manrope.
- Se eliminó una pantalla intermedia de lista: solo hay Inicio y Visor.
- La línea de tiempo empieza en 2025 (inicio de SPHEREx) y el visor debe poder mostrar las 102 bandas.
- Habrá una alianza con el modelo 3D de un compañero (globo tipo "OSIRIS"); se integrará más adelante.
- La barra de herramientas va **debajo** de la imagen.
- La línea de tiempo es **por año** por defecto (se apilan los barridos de cada año); se puede cambiar a "por barrido".
- Imagen y gráficas deben poder verse **grandes / en pantalla completa**.
- En el modo Restar: azul = posición o brillo nuevo, dorado = anterior.

## Pendiente en el frontend
1. Coordinar con el equipo de backend el contrato de API (`frontend/README.md`) y ajustar `frontend/src/api/http.ts` si cambia.
2. Cuando el backend esté listo: probar con `VITE_USE_MOCK=false` y los 5 objetos de prueba.
3. Verificar los rangos de longitud de onda por detector (`frontend/src/lib/detectors.ts`) contra el SPHEREx Explanatory Supplement.
4. Pulir según el feedback que siga llegando (accesibilidad, celular, textos).
5. Conectar el modelo 3D del compañero cuando tenga URL (`VITE_MODEL_URL`).
6. Opcional: Aladin Lite como mapa de contexto.

## Notas para el equipo de backend (referencia, no se implementa desde esta rama)
- Consultar IRSA SIA2 (`astroquery.ipac.irsa.Irsa.query_sia`, colección `spherex_qr2`) y pedir cutouts.
- Reproyectar todas las épocas a la misma rejilla (`reproject`) y usar el mismo estiramiento de brillo en todas.
- El parámetro `epoch` puede traer varios barridos separados por coma (`s2,s3`) que se apilan: así se forman los cuadros "por año".
- Barnard's Star y WISE 0855 tienen gran movimiento propio: ya no están en sus coordenadas de catálogo.
- `/api/epochs` devuelve épocas de SPHEREx con `mission: 'spherex'`; `det` puede ser `b1…b102` o `rgb`.

## Comandos
```bash
cd frontend
npm install
npm run dev        # http://localhost:5173
npm run typecheck  # verificación de tipos
npm run build      # genera dist/
```
