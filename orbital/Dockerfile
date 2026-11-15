# ORBITAL: API /api/v1 (Node.js) + simulador 2D estático en /orbital/
FROM node:20-slim
ENV NODE_ENV=production WEB_ROOT=/app/public PORT=3010
WORKDIR /app
COPY orbital/package.json ./
RUN npm install --omit=dev --ignore-scripts
COPY orbital/server ./server
COPY orbital/public ./public
EXPOSE 3010
HEALTHCHECK --interval=15s --timeout=4s --start-period=10s --retries=5 \
  CMD node -e "fetch('http://127.0.0.1:3010/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
USER node
CMD ["node", "server/server.js"]
