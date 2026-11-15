# Xtremis — Space Apps Challenge 2026

Proyecto del reto **Planet X and SPHEREx**. El visor web está desarrollado con React, TypeScript y Vite.

## Ejecutar con Docker desde la carpeta principal

Requisitos: Docker Desktop instalado y en ejecución (incluye Docker Compose).

En una terminal, entra a la carpeta principal del proyecto —la que contiene este `docker-compose.yml`— y ejecuta:

```bash
docker compose up --build
```

Cuando termine la compilación, abre:

**http://localhost:8080**

El frontend corre dentro del contenedor `xtremis-frontend`; Docker publica el puerto `8080` de tu computadora hacia el puerto `80` del contenedor. El proyecto queda en modo demo (`VITE_USE_MOCK=true`), por lo que no necesita levantar un backend ni una base de datos. Las nuevas zonas se muestran con estrellas simuladas hasta conectar el backend SPHEREx/IRSA.

Para detenerlo, presiona `Ctrl + C`. Si lo levantaste en segundo plano, usa:

```bash
docker compose down
```

Para volver a levantarlo en segundo plano:

```bash
docker compose up --build -d
```

Para ver los registros:

```bash
docker compose logs -f
```

## Estructura principal

- `docker-compose.yml`: orquesta el contenedor desde la raíz.
- `frontend-prototipo3/`: aplicación React + Vite.
- `frontend-prototipo3/Dockerfile`: compila la aplicación y crea la imagen de producción.
- `frontend-prototipo3/nginx.conf`: configura Nginx para servir el frontend.
- `Frontend/`: prototipo separado que se conserva en el repositorio; el Compose raíz levanta el visor de `frontend-prototipo3/`.

## Controles del visor

- Flechas: mover la cruz dorada (mira de exploración) por el campo.
- Al acercarse a un borde: el visor recentra la coordenada apuntada y carga otra zona del cielo, con solapamiento.
- `Shift` + flechas: movimiento rápido.
- `Enter`: seleccionar el punto actual.
- `Espacio`: reproducir o pausar.
- `[` y `]`: cambiar de año.
- `Esc`: salir de pantalla completa.

## Ejecutar sin Docker (opcional)

```bash
cd frontend-prototipo3
npm install
npm run dev
```

Vite muestra la dirección local en la terminal, normalmente `http://localhost:5173`.
