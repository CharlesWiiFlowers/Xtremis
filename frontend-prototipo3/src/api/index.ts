import { httpApi } from './http';
import { mockApi } from './mock';
import type { SkyApi } from './types';

/** Modo demo activo salvo que VITE_USE_MOCK=false. */
export const IS_MOCK = import.meta.env.VITE_USE_MOCK !== 'false';

export const api: SkyApi = IS_MOCK ? mockApi : httpApi;

export type * from './types';
