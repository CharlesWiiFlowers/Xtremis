// Fondo animado del inicio: galaxia espiral, estrellas y el borde de un planeta,
// todo generado por código (sin imágenes externas). Respeta prefers-reduced-motion.

import { useEffect, useRef } from 'react';

function mulberry32(seed: number) {
  let s = seed >>> 0;
  return () => {
    s = (s + 0x6d2b79f5) | 0;
    let t = Math.imul(s ^ (s >>> 15), 1 | s);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function gauss(r: () => number) {
  let u = 0;
  while (u === 0) u = r();
  return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * r());
}

/** Galaxia vista de frente, dibujada una sola vez en un canvas fuera de pantalla. */
function renderGalaxy(S: number): HTMLCanvasElement {
  const c = document.createElement('canvas');
  c.width = c.height = S;
  const g = c.getContext('2d')!;
  const r = mulberry32(42);
  const C = S / 2;
  const R = S * 0.48;

  g.globalCompositeOperation = 'lighter';

  // Halo difuso
  const halo = g.createRadialGradient(C, C, 0, C, C, R);
  halo.addColorStop(0, 'rgba(120,140,220,0.18)');
  halo.addColorStop(0.6, 'rgba(60,70,140,0.06)');
  halo.addColorStop(1, 'rgba(0,0,0,0)');
  g.fillStyle = halo;
  g.fillRect(0, 0, S, S);

  // Brazos espirales
  const arms = 2;
  for (let i = 0; i < 52000; i++) {
    const arm = i % arms;
    const t = Math.pow(r(), 0.75);
    const rad = t * R;
    const theta =
      arm * ((2 * Math.PI) / arms) + Math.log(1 + rad / (R * 0.06)) * 1.75 + gauss(r) * (0.32 - t * 0.12);
    const x = C + rad * Math.cos(theta) + gauss(r) * R * 0.012;
    const y = C + rad * Math.sin(theta) + gauss(r) * R * 0.012;
    const roll = r();
    let col: string;
    if (t < 0.22) col = '255,205,150';
    else if (roll < 0.1) col = '255,120,200';
    else if (roll < 0.2) col = '255,225,190';
    else col = '150,190,255';
    const a = (0.12 + r() * 0.45) * (1 - t * 0.35);
    const size = 0.9 + r() * (t < 0.2 ? 1.6 : 2.4);
    g.fillStyle = `rgba(${col},${a.toFixed(3)})`;
    g.fillRect(x, y, size, size);
  }

  // Núcleo brillante
  const core = g.createRadialGradient(C, C, 0, C, C, R * 0.3);
  core.addColorStop(0, 'rgba(255,240,215,0.95)');
  core.addColorStop(0.15, 'rgba(255,205,140,0.7)');
  core.addColorStop(0.5, 'rgba(255,160,90,0.18)');
  core.addColorStop(1, 'rgba(255,140,80,0)');
  g.fillStyle = core;
  g.fillRect(0, 0, S, S);

  // Carriles de polvo (oscurecen el borde interno de los brazos)
  g.globalCompositeOperation = 'source-over';
  for (let i = 0; i < 9000; i++) {
    const arm = i % arms;
    const t = 0.12 + Math.pow(r(), 0.9) * 0.7;
    const rad = t * R;
    const theta = arm * ((2 * Math.PI) / arms) + Math.log(1 + rad / (R * 0.06)) * 1.75 - 0.22 + gauss(r) * 0.06;
    const x = C + rad * Math.cos(theta) + gauss(r) * R * 0.006;
    const y = C + rad * Math.sin(theta) + gauss(r) * R * 0.006;
    g.fillStyle = `rgba(20,10,6,${(0.12 + r() * 0.25).toFixed(3)})`;
    g.fillRect(x, y, 1.6, 1.6);
  }

  // Resplandor: una copia desenfocada sumada encima da el brillo difuso de los brazos
  const glow = document.createElement('canvas');
  glow.width = glow.height = S;
  const gg = glow.getContext('2d')!;
  gg.filter = 'blur(10px)';
  gg.drawImage(c, 0, 0);
  g.globalCompositeOperation = 'lighter';
  g.globalAlpha = 0.9;
  g.drawImage(glow, 0, 0);
  g.globalAlpha = 1;
  return c;
}

function renderStars(w: number, h: number, dpr: number): HTMLCanvasElement {
  const c = document.createElement('canvas');
  c.width = w * dpr;
  c.height = h * dpr;
  const g = c.getContext('2d')!;
  g.scale(dpr, dpr);
  const r = mulberry32(7);
  const n = Math.round((w * h) / 2600);
  for (let i = 0; i < n; i++) {
    const x = r() * w;
    const y = r() * h;
    const big = r() < 0.04;
    const a = 0.25 + r() * 0.65;
    const tint = r() < 0.2 ? '255,220,180' : r() < 0.4 ? '190,215,255' : '255,255,255';
    g.fillStyle = `rgba(${tint},${a.toFixed(2)})`;
    g.beginPath();
    g.arc(x, y, big ? 1.3 : 0.6, 0, Math.PI * 2);
    g.fill();
  }
  return c;
}

export function GalaxyCanvas() {
  const ref = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = ref.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d')!;
    const reduced = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ?? false;
    const galaxy = renderGalaxy(1100);
    let stars: HTMLCanvasElement | null = null;
    let w = 0;
    let h = 0;
    let dpr = 1;
    let spin = 0;
    let raf = 0;

    const resize = () => {
      const rect = canvas.getBoundingClientRect();
      dpr = Math.min(2, window.devicePixelRatio || 1);
      w = rect.width;
      h = rect.height;
      if (w < 1 || h < 1) return; // desmontado u oculto
      canvas.width = Math.round(w * dpr);
      canvas.height = Math.round(h * dpr);
      stars = renderStars(w, h, dpr);
      draw();
    };

    const draw = () => {
      if (w < 1 || h < 1) return;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx.clearRect(0, 0, w, h);
      if (stars) ctx.drawImage(stars, 0, 0, w, h);

      const narrow = w < 760;
      const gx = narrow ? w * 0.62 : w * 0.7;
      const gy = narrow ? h * 0.24 : h * 0.47;
      const gr = narrow ? w * 0.8 : Math.min(w * 0.45, h * 0.8);

      // Galaxia inclinada y girando lentamente
      ctx.save();
      ctx.globalCompositeOperation = 'lighter';
      ctx.translate(gx, gy);
      ctx.rotate(-0.38);
      ctx.scale(1, 0.56);
      ctx.rotate(spin);
      ctx.drawImage(galaxy, -gr, -gr, gr * 2, gr * 2);
      ctx.restore();

      // Órbita tenue
      ctx.save();
      ctx.strokeStyle = 'rgba(255,255,255,0.10)';
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.ellipse(w * 0.55, h * 0.62, w * 0.55, h * 0.2, -0.22, 0, Math.PI * 2);
      ctx.stroke();
      ctx.restore();

      // Borde de un planeta abajo a la derecha
      const pr = narrow ? w * 0.9 : Math.max(w * 0.42, h * 0.75);
      const px = narrow ? w * 0.95 : w * 0.86;
      const py = h + pr * (narrow ? 0.62 : 0.55);
      const body = ctx.createRadialGradient(px - pr * 0.3, py - pr * 0.6, pr * 0.1, px, py, pr);
      body.addColorStop(0, '#1d3557');
      body.addColorStop(0.55, '#0b1628');
      body.addColorStop(1, '#03060d');
      ctx.fillStyle = body;
      ctx.beginPath();
      ctx.arc(px, py, pr, 0, Math.PI * 2);
      ctx.fill();
      const rim = ctx.createRadialGradient(px, py, pr * 0.96, px, py, pr * 1.04);
      rim.addColorStop(0, 'rgba(94,224,255,0)');
      rim.addColorStop(0.5, 'rgba(120,200,255,0.55)');
      rim.addColorStop(1, 'rgba(94,224,255,0)');
      ctx.fillStyle = rim;
      ctx.beginPath();
      ctx.arc(px, py, pr * 1.04, 0, Math.PI * 2);
      ctx.fill();
    };

    const loop = () => {
      spin += 0.0006;
      draw();
      raf = requestAnimationFrame(loop);
    };

    resize();
    const ro = new ResizeObserver(resize);
    ro.observe(canvas);
    if (!reduced) raf = requestAnimationFrame(loop);
    return () => {
      cancelAnimationFrame(raf);
      ro.disconnect();
    };
  }, []);

  return <canvas ref={ref} className="galaxy-canvas" aria-hidden="true" />;
}
