# Etapa 1: instalar dependencias y compilar el frontend
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# El prototipo funciona en modo demo sin necesitar un backend.
ARG VITE_USE_MOCK=true
ARG VITE_API_URL=
ARG VITE_MODEL_URL=
ENV VITE_USE_MOCK=${VITE_USE_MOCK}
ENV VITE_API_URL=${VITE_API_URL}
ENV VITE_MODEL_URL=${VITE_MODEL_URL}

RUN npm run build

# Etapa 2: servir la aplicación compilada con Nginx
FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
