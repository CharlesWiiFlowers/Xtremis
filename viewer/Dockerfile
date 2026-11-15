# Visor SPHEREx (React + Vite) servido por Nginx, que además hace de puerta única (ver nginx.conf).
FROM node:20-alpine AS build
WORKDIR /app
COPY viewer/package*.json ./
RUN npm ci
COPY viewer/ .

# Fuente inicial de datos: true = simulados (como la primera versión), false = reales del backend.
# En la interfaz hay un interruptor Simulados | Reales que cambia esto sin recompilar.
ARG VITE_USE_MOCK=true
ARG VITE_API_URL=
# Solo para incrustar OTRO modelo externo en el visor (ORBITAL ya es una sección propia).
ARG VITE_MODEL_URL=
ENV VITE_USE_MOCK=${VITE_USE_MOCK} VITE_API_URL=${VITE_API_URL} VITE_MODEL_URL=${VITE_MODEL_URL}
RUN npm run build

FROM nginx:1.27-alpine
COPY viewer/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/healthz || exit 1
