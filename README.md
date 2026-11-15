# ORBITAL · Mecánica orbital integrada 2D

ORBITAL ahora es una sola simulación 2D: **el Sol, los planetas y los orbes del Laboratorio local aparecen juntos en el mismo lienzo**, con un reloj, zoom, desplazamiento y selección compartidos. Se retiró la vista de Campo astronómico de la interfaz.

## Una sola experiencia

- **Sistema orbital:** Sol seleccionable y seis planetas de referencia con órbitas keplerianas, trayectorias elípticas, pausa, paso de tiempo, velocidad y control temporal.
- **Laboratorio local integrado:** 180 orbes sintéticos en un anillo experimental exterior dentro del mismo plano visual. Incluye filtro por clase espectral, búsqueda por ID, regeneración reproducible y opción para ocultar/mostrar los objetos. Los valores se identifican expresamente como sintéticos y no como observaciones reales.
- **Ficha completa al seleccionar:** clic en el Sol, cualquier planeta o cualquier orbe local para desplegar sus datos. Los planetas muestran todos los campos orbitales disponibles, propiedades físicas de referencia y magnitudes dinámicas calculadas; los orbes locales muestran todos sus valores sintéticos.
- **Un solo renderizador:** Canvas 2D, sin Three.js ni WebGL.

Los objetos locales del laboratorio se ubican en un anillo visual exterior para distinguirlos de los planetas y permitir la interacción conjunta. No son distancias heliocéntricas medidas ni órbitas reales. La distancia en parsecs y los datos fotométricos de esos objetos son valores sintéticos independientes.

Los parámetros físicos de los planetas proceden de JPL Solar System Dynamics, *Planetary Physical Parameters*, y los del Sol de NASA NSSDC, *Sun Fact Sheet*. Los valores orbitales de la simulación siguen siendo elementos de referencia aproximados J2000 y el movimiento es un modelo kepleriano de dos cuerpos.

## Inicio rápido con Docker

Requiere Docker Desktop (o Docker Engine) con Docker Compose.

```bash
docker compose up -d --build
```

Abrir **http://localhost:3010**.

Para comprobar los servicios:

```bash
docker compose ps
curl http://localhost:3010/api/v1/status
curl http://localhost:3010/health
```

La interfaz, las fichas y la matemática del simulador se sirven localmente. El frontend no necesita CDN, Three.js, WebGL ni conexión a internet para la simulación integrada.

## Datos de referencia y origen

Las fichas del Sol y los planetas presentan valores físicos de referencia, no telemetría en vivo. Las propiedades planetarias se basan en JPL Solar System Dynamics, *Planetary Physical Parameters*, y los datos del Sol en NASA NSSDC, *Sun Fact Sheet*. Los parámetros orbitales de la escena son elementos aproximados J2000 y la dinámica es un modelo kepleriano de dos cuerpos.

Los objetos del Laboratorio local se generan en el navegador con una semilla reproducible. Su temperatura, magnitud, distancia y coordenadas se etiquetan como sintéticas; no son observaciones ni cuerpos reales del sistema solar.

La vista de catálogos externos ya no forma parte de la interfaz visual. Se conservan los servicios Node/Python/MySQL y las rutas anteriores de API como compatibilidad del despliegue, pero el simulador integrado actual no las invoca.

## Docker y persistencia

Servicios: `node` (web/API gateway), `python` (rutas de consulta heredadas) y `mysql` (persistencia opcional). La interfaz de simulación local funciona aunque MySQL o internet no estén disponibles. Las rutas heredadas de consulta requieren internet; no se activan desde el visor integrado. MySQL permanece para compatibilidad con el despliegue previo.

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

## Compatibilidad y conectividad

La simulación local funciona sin internet y sin MySQL. Los servicios del backend anterior se mantienen en Docker para preservar compatibilidad con el despliegue existente; no son necesarios para mover el Sol, los planetas ni los orbes sintéticos locales.

## Pruebas del código

Pruebas de las órbitas keplerianas, fichas completas del Sol/planetas, orbes locales sintéticos y selección 2D:

```bash
node --test tests/*.test.mjs
```

Pruebas del constructor ADQL de MAST, tabla Gaia, límites y captura de error HTTP 400:

```bash
PYTHONPATH=python python -m unittest discover -s python/tests -v
```

Prueba de navegador real (requiere Playwright y Chromium instalados):

```bash
python -m pip install playwright
playwright install chromium
python tests/browser-smoke.py
```
