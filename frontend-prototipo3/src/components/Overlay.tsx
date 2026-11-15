// Vista a pantalla completa reutilizable (imagen del cielo y gráficas).
// Cubre toda la ventana y, si el navegador lo permite, activa también el
// modo pantalla completa real. Esc o el botón Cerrar la cierran.

import { useEffect, useRef, type ReactNode } from 'react';
import { createPortal } from 'react-dom';
import { useI18n } from '../i18n';

interface Props {
  open: boolean;
  onClose: () => void;
  title: ReactNode;
  children: ReactNode;
}

/** Llamar desde el clic que abre la vista (los navegadores lo exigen). */
export function requestRealFullscreen() {
  try {
    const p = document.documentElement.requestFullscreen?.();
    p?.catch(() => undefined);
  } catch {
    /* no disponible: se queda la vista ampliada dentro de la ventana */
  }
}

function exitRealFullscreen() {
  try {
    if (document.fullscreenElement) document.exitFullscreen().catch(() => undefined);
  } catch {
    /* ignorar */
  }
}

export function Overlay({ open, onClose, title, children }: Props) {
  const { t } = useI18n();
  const closeRef = useRef(onClose);
  closeRef.current = onClose;

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') closeRef.current();
    };
    // Si el usuario sale del modo pantalla completa del navegador, cerramos también la vista.
    const onFs = () => {
      if (!document.fullscreenElement) closeRef.current();
    };
    window.addEventListener('keydown', onKey);
    document.addEventListener('fullscreenchange', onFs);
    document.body.classList.add('no-scroll');
    return () => {
      window.removeEventListener('keydown', onKey);
      document.removeEventListener('fullscreenchange', onFs);
      document.body.classList.remove('no-scroll');
      exitRealFullscreen();
    };
  }, [open]);

  if (!open) return null;
  return createPortal(
    <div className="overlay" role="dialog" aria-modal="true">
      <div className="overlay-head">
        <div className="overlay-title">{title}</div>
        <button className="btn btn-ghost" onClick={onClose}>
          <svg width="14" height="14" viewBox="0 0 24 24" aria-hidden="true">
            <path d="M6 6l12 12M18 6L6 18" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" />
          </svg>
          {t('close')} <kbd>Esc</kbd>
        </button>
      </div>
      <div className="overlay-body">{children}</div>
    </div>,
    document.body,
  );
}

export function ExpandButton({ onClick, label }: { onClick: () => void; label: string }) {
  return (
    <button
      className="expand-btn"
      onClick={(e) => {
        e.stopPropagation();
        requestRealFullscreen();
        onClick();
      }}
      aria-label={label}
      title={label}
    >
      <svg width="16" height="16" viewBox="0 0 24 24" aria-hidden="true">
        <path d="M4 9V4h5M20 9V4h-5M4 15v5h5M20 15v5h-5" stroke="currentColor" strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round" />
      </svg>
    </button>
  );
}
