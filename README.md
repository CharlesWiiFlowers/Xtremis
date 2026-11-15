# Xtremis — Space Apps Challenge 2026 · *Planet X and SPHEREx*

Un solo programa, un solo comando, una sola dirección.

```bash
docker compose up --build
```

Abre **http://localhost:8080**. La primera vez tarda unos minutos (compila el visor e instala astropy y compañía).

| Dirección | Qué es |
|---|---|
| `http://localhost:8080/` | **Xtremis, un solo programa con dos secciones** (selector arriba: *Imágenes del cielo* · *Sistema solar*) |
| ↳ *Imágenes del cielo* | Visor SPHEREx: imágenes reales como "video", espectro de 102 bandas, curva de luz, capas Gaia/WISE |
| ↳ *Sistema solar* (`/?view=orbital`) | ORBITAL: simulador 2D de planetas y laboratorio local, dentro de la misma interfaz |
| `http://localhost:8080/orbital/` | ORBITAL como página completa e independiente |
| `http://localhost:3010/` | Mismo ORBITAL, acceso directo como antes (redirige a `/orbital/`) |
| `http://localhost:8080/api/…` | API SPHEREx (FastAPI). Documentación interactiva en `/docs` |
| `http://localhost:8080/api/v1/…` | API ORBITAL (estado, órbitas, Gaia/WISE/SPHEREx en vivo, catálogo guardado en MySQL) |

## Cómo está armado

```
            navegador ──► web (Nginx :8080)
                           ├─ /            visor React (build estático)
                           ├─ /orbital/ ─┐
                           ├─ /api/v1/ ──┴─► orbital (Node.js) ─► python (consultas Gaia/WISE/IRSA) ─┐
                           └─ /api/ ───────► backend (FastAPI: imágenes, espectros, caché)          ├─► mysql
                                                                                                    ┘
```

| Servicio | Carpeta | Para qué |
|---|---|---|
| `web` | `viewer/` | Visor React + Nginx, que es la **única puerta** hacia afuera |
| `backend` | `Backend/` | Recortes SPHEREx, espectros de 102 bandas, Gaia/WISE para el visor. Usa `Database/scripts` |
| `orbital` | `orbital/` | Simulador (`public/`) y API `/api/v1` (`server/`) |
| `python` | `python/` | Consultas en vivo a Gaia (MAST), WISE y SPHEREx (IRSA); carga el catálogo en MySQL |
| `mysql` | `Database/mysql/schema.sql` | Esquema que se crea solo en el primer arranque |

Solo `web` (8080), ORBITAL (3010) y MySQL (`127.0.0.1:3307`, para que puedas mirarlo con un cliente) quedan publicados; el resto es red interna de Docker.

## Uso diario

```bash
docker compose up -d --build     # segundo plano
docker compose ps                # estado y healthchecks
docker compose logs -f backend   # registros de un servicio
docker compose down              # detener (conserva MySQL y la caché)
docker compose down -v           # detener y BORRAR MySQL y caché
```

## Configuración (opcional)

Copia `.env.example` a `.env`. Lo más útil:

- `WEB_PORT=8080`: puerto público.
- `XTREMIS_OFFLINE=1`: sin internet. Sirve solo lo que está en caché; el paquete demo (`Backend/offline/demo_cache.tar.gz`) cubre los 5 objetos de prueba en su posición de la pantalla de inicio, campo de 10′. Cualquier otra coordenada devuelve 503 de inmediato.
- `VITE_USE_MOCK=true|false`: fuente inicial de datos del visor. `true` (por defecto) = **simulados**, como la primera versión: instantáneos, se mueven con las flechas y cargan zona por zona. `false` = reales del backend. En la barra superior hay un interruptor **Simulados | Reales** que lo cambia sin recompilar (se recuerda en el navegador; también `?data=real`).
- `VITE_MODEL_URL=`: solo si quieres incrustar OTRO modelo externo en el visor (ORBITAL ya es una sección).
- Contraseñas de MySQL: cámbialas antes de publicarlo en internet.

Con dominio y HTTPS automático: `DOMAIN=astro.midominio.com docker compose --profile https up -d`.

## Notas de funcionamiento

- Una coordenada nueva (no cacheada) tarda **1–3 min** la primera vez, porque baja recortes de IRSA; después responde en menos de 0.1 s desde el volumen `spherex_cache`.
- IRSA y el archivo Gaia fallan de forma intermitente; el backend reintenta y usa Gaia de respaldo (ver `Backend/README.md`).
- MySQL es opcional para el visor: ORBITAL abre y funciona aunque la base aún esté iniciando.
- Barnard's Star, R Draconis y casi todo RW Aurigae saturan SPHEREx: se muestran con bandera de contaminación.

## Pruebas

```bash
node --test tests/*.test.mjs        # matemática orbital y fichas de objetos
python tests/browser-smoke.py       # simulador en Chromium (requiere playwright)
```

## Estructura del repo

```
docker-compose.yml  .env.example  deploy/Caddyfile
viewer/    visor SPHEREx (React + Vite) + Dockerfile + nginx.conf (puerta única)
orbital/   simulador ORBITAL (public/) + API Node (server/)
Backend/   API SPHEREx (FastAPI)          python/   consultas en vivo + seed
Database/  scripts Gaia/SPHEREx, docs y mysql/schema.sql      catalog/  catálogo de APIs
docs/      contexto del proyecto, integración del modelo      tests/
legacy/    prototipo anterior y plantilla Vite (ya no se usan; se conservan por historial)
```

Integración visor ⇄ modelo externo por `postMessage`: `docs/INTEGRACION_MODELO.md`.
