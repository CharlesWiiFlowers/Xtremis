FROM node:20-slim
ENV NODE_ENV=production WEB_ROOT=/web
WORKDIR /app
COPY web /web
COPY node/package.json ./
RUN npm install --omit=dev --ignore-scripts
COPY node/src ./src
EXPOSE 3010
CMD ["node", "src/server.js"]
