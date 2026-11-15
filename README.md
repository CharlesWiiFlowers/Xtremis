# ORBITAL · Space Intelligence Studio

ORBITAL es un centro de operaciones astronómico con visor WebGL 3D, controles de capas, consulta de archivos científicos y panel de inspección de objetos. Está inspirado en la organización de una consola geoespacial (mapa central, capas y paneles flotantes), pero adaptado a fuentes de astronomía y con diseño propio.

## Inicio rápido con Docker

Requiere Docker Desktop (o Docker Engine) con Docker Compose.

```bash
docker compose up -d --build
```

Abrir **http://localhost:3010**. El visor y su motor Three.js se sirven localmente desde el contenedor; la aplicación no depende de un CDN para renderizar el 3D.

Para comprobar los servicios:

```bash
docker compose ps
curl http://localhost:3010/api/v1/status
curl http://localhost:3010/health
```

## Qué incluye

- **Carta celeste 3D:** esfera de coordenadas, cámara orbital, zoom, selección de objetos y profundidad visual. Gaia usa una distancia aproximada `1000/paralaje (mas)` cuando el paralaje es positivo y suficientemente grande; se comprime en escala logarítmica y no sustituye una estimación astrométrica probabilística. WISE y SPHEREx muestran codificaciones visuales de magnitud/banda, no distancias físicas.
- **Capas independientes:** Gaia DR3, WISE/AllWISE y SPHEREx. Se pueden consultar por separado o simultáneamente; el botón de consulta múltiple las lanza en paralelo.
- **Filtros:** RA, Dec, radio de búsqueda, máximo de filas, magnitud Gaia, texto/ID y banda SPHEREx D1–D6. Los valores iniciales son conservadores: radio 0.03°, 100 filas y magnitud Gaia G≤18.
- **Ficha del objeto:** metadatos devueltos por el archivo y enlace al cutout FITS para imágenes SPHEREx.
- **Cache:** el servicio mantiene respuestas en memoria para evitar repetir consultas idénticas; el navegador mantiene una caché temporal de consultas.
- **PWA:** manifest y service worker; el shell de la app y Three.js se pueden reutilizar desde caché. Las consultas científicas necesitan conexión a internet.
- **Laboratorio local:** escena sintética explícitamente etiquetada como demostración, independiente de archivos externos.
- **Mecánica orbital:** modelo local de referencia de los planetas.

## Fuentes de datos

- **Gaia DR3:** MAST/STScI TAP síncrono para búsquedas cónicas pequeñas. Usa la tabla propia del servicio MAST `dbo.gaia_source` y la geometría ADQL con marco explícito `ICRS`, tal como indican sus ejemplos oficiales; se limita TOP y se evita ordenar catálogos grandes en el servidor. Los errores TAP muestran el motivo devuelto por el archivo.
- **WISE/AllWISE:** IRSA Simple Cone Search sobre `allwise_p3as_psd`. WiseView se ofrece como visor externo de imágenes/blinks unWISE; no se presenta como API de catálogo.
- **SPHEREx:** IRSA SIA2 para imágenes de las colecciones DR1 y QR3 wide. Devuelve metadatos y URL de acceso/cutout; el visor no descarga ni procesa automáticamente los FITS completos.

Los archivos externos pueden responder con latencias distintas, aplicar límites o estar temporalmente no disponibles. ORBITAL reduce el radio/volumen por defecto, usa timeouts estrictos y verifica DNS antes de consultar; no puede controlar la disponibilidad de MAST/IRSA ni corregir bloqueos de red del host.

## Docker y persistencia

Servicios: `node` (web/API gateway), `python` (consultas astronómicas) y `mysql` (persistencia opcional). La interfaz consulta archivos científicos aunque MySQL no esté disponible; el estado de la base de datos se muestra por separado. MySQL conserva resultados solo cuando se habilita **Guardar los resultados en la base de datos**.

```bash
# Ver registros
docker compose logs -f node
docker compose logs -f python
docker compose logs -f mysql

# Detener sin borrar los datos
docker compose down

# Reiniciar desde cero (BORRA MySQL)
docker compose down -v
docker compose up -d --build
```

El puerto de la aplicación es **3010**. MySQL se expone solo en `127.0.0.1:3307` para herramientas locales.

## Diagnóstico

`/api/v1/status` distingue API de consulta y base de datos. El botón **Diagnosticar conexión** prueba DNS y HTTPS desde el contenedor Python hacia MAST e IRSA y ejecuta una consulta ADQL mínima real a Gaia. Las rutas `/api/v1/connectivity` y `/api/v1/gaia/diagnostic` entregan esos resultados; Python expone además `/health` y `/cache` dentro de la red Docker. Si DNS/HTTPS falla desde el contenedor, las consultas externas no pueden responder aunque los contenedores estén saludables. Para ejecutar solo la prueba TAP Gaia desde el host: `curl.exe "http://localhost:3010/api/v1/gaia/diagnostic?ra=304.6935&dec=42.4437"`. Si MAST rechaza ADQL, la respuesta conserva el detalle del archivo externo. En redes que exigen proxy, configúralo en `.env` mediante `HTTP_PROXY` y `HTTPS_PROXY` para que el servicio Python pueda salir.

Si cambias el código o las dependencias, reconstruye:

```bash
docker compose up -d --build --force-recreate
```


## Pruebas del código

Las pruebas unitarias del constructor ADQL de MAST, el nombre de tabla, el límite de filas y el manejo del error HTTP 400 se ejecutan desde la raíz con:

```bash
PYTHONPATH=python python -m unittest discover -s python/tests -v
```
