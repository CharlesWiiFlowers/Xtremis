/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_USE_MOCK?: string;
  readonly VITE_API_URL?: string;
  /** URL del modelo 3D del equipo (opcional). Si existe, aparece la pestaña "Modelo 3D". */
  readonly VITE_MODEL_URL?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
