import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// base './' permite servir el build desde cualquier subcarpeta (GitHub Pages, etc.)
export default defineConfig({
  base: './',
  plugins: [react()],
  server: {
    // En desarrollo, /api se redirige al backend de Python (FastAPI en :8000)
    proxy: {
      '/api/v1': 'http://localhost:3010',
      '/orbital': 'http://localhost:3010',
      '/api': 'http://localhost:8000',
    },
  },
});
