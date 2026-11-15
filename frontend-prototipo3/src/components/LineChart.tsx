import type { MouseEvent } from 'react';

// Gráfica SVG sin dependencias para espectros y curvas de luz.
// `size="large"` se usa en pantalla completa: más ancha y con texto más grande.

export interface ChartPoint {
  x: number;
  y: number;
  err?: number;
  /** Color propio del punto (si no, se usa `color`). */
  color?: string;
}

export interface ChartBand {
  from: number;
  to: number;
  label: string;
}

interface Props {
  points: ChartPoint[];
  xLabel: string;
  yLabel: string;
  xFormat?: (v: number) => string;
  xTicks?: number[];
  bands?: ChartBand[];
  line?: boolean;
  color?: string;
  size?: 'normal' | 'large';
  /** Rango de x resaltado (p. ej. la banda que se ve en la imagen). */
  highlight?: [number, number];
  /** Si se pasa, al hacer clic en la gráfica devuelve el valor de x. */
  onPickX?: (x: number) => void;
}

function niceStep(range: number, count: number): number {
  const raw = range / Math.max(1, count);
  const mag = Math.pow(10, Math.floor(Math.log10(raw)));
  const norm = raw / mag;
  const nice = norm < 1.5 ? 1 : norm < 3 ? 2 : norm < 7 ? 5 : 10;
  return nice * mag;
}

function ticks(min: number, max: number, count = 5): number[] {
  if (!(max > min)) return [min];
  const step = niceStep(max - min, count);
  const out: number[] = [];
  for (let v = Math.ceil(min / step) * step; v <= max + step * 1e-6; v += step) out.push(Number(v.toFixed(10)));
  return out;
}

const fmtNum = (v: number) => (Math.abs(v) >= 10 ? v.toFixed(0) : v.toFixed(1));

export function LineChart({
  points,
  xLabel,
  yLabel,
  xFormat,
  xTicks,
  bands,
  line = false,
  color = 'var(--blue)',
  size = 'normal',
  highlight,
  onPickX,
}: Props) {
  if (points.length === 0) return null;
  const big = size === 'large';
  const W = big ? 1100 : 440;
  const H = big ? 560 : 270;
  const fs = big ? 15 : 11; // tamaño de letra
  const M = { l: big ? 64 : 46, r: 14, t: big ? 26 : 18, b: big ? 58 : 44 };

  const xs = points.map((p) => p.x);
  const lo = points.map((p) => p.y - (p.err ?? 0));
  const hi = points.map((p) => p.y + (p.err ?? 0));
  let xMin = Math.min(...xs);
  let xMax = Math.max(...xs);
  if (bands?.length) {
    xMin = Math.min(xMin, bands[0].from);
    xMax = Math.max(xMax, bands[bands.length - 1].to);
  }
  const xPad = (xMax - xMin) * 0.02 || 1;
  xMin -= xPad;
  xMax += xPad;
  let yMin = Math.min(0, ...lo);
  let yMax = Math.max(...hi);
  const yPad = (yMax - yMin) * 0.08 || 1;
  yMin -= yMin < 0 ? yPad : 0;
  yMax += yPad;

  const sx = (v: number) => M.l + ((v - xMin) / (xMax - xMin)) * (W - M.l - M.r);
  const sy = (v: number) => H - M.b - ((v - yMin) / (yMax - yMin)) * (H - M.t - M.b);
  const yt = ticks(yMin, yMax, big ? 6 : 4);
  const xt = xTicks ?? ticks(xMin, xMax, big ? 9 : 5);
  const path = points.map((p, i) => `${i ? 'L' : 'M'}${sx(p.x).toFixed(1)},${sy(p.y).toFixed(1)}`).join(' ');
  const r = line ? (big ? 2.6 : 1.8) : big ? 4.5 : 3;
  const xFromClient = (e: MouseEvent<SVGRectElement>) => {
    const box = (e.currentTarget.ownerSVGElement as SVGSVGElement).getBoundingClientRect();
    const px = ((e.clientX - box.left) / box.width) * W;
    return xMin + ((px - M.l) / (W - M.l - M.r)) * (xMax - xMin);
  };

  return (
    <svg className={`chart ${big ? 'chart-large' : ''}`} viewBox={`0 0 ${W} ${H}`} role="img" aria-label={`${yLabel} / ${xLabel}`}>
      {bands?.map((b, i) => (
        <g key={b.label}>
          <rect x={sx(b.from)} y={M.t} width={Math.max(0, sx(b.to) - sx(b.from))} height={H - M.t - M.b} className={i % 2 ? 'band band-odd' : 'band'} />
          <text x={(sx(b.from) + sx(b.to)) / 2} y={M.t - 5} className="band-label" textAnchor="middle" fontSize={fs * 0.85}>
            {b.label}
          </text>
        </g>
      ))}

      {highlight && (
        <rect
          x={sx(Math.max(xMin, highlight[0]))}
          y={M.t}
          width={Math.max(2, sx(Math.min(xMax, highlight[1])) - sx(Math.max(xMin, highlight[0])))}
          height={H - M.t - M.b}
          className="chart-highlight"
        />
      )}

      {yt.map((v) => (
        <g key={`y${v}`}>
          <line x1={M.l} x2={W - M.r} y1={sy(v)} y2={sy(v)} className="grid" />
          <text x={M.l - 8} y={sy(v) + fs * 0.35} className="tick" textAnchor="end" fontSize={fs}>
            {fmtNum(v)}
          </text>
        </g>
      ))}
      {xt
        .filter((v) => v >= xMin && v <= xMax)
        .map((v) => (
          <text key={`x${v}`} x={sx(v)} y={H - M.b + fs * 1.6} className="tick" textAnchor="middle" fontSize={fs}>
            {xFormat ? xFormat(v) : fmtNum(v)}
          </text>
        ))}
      <line x1={M.l} x2={W - M.r} y1={H - M.b} y2={H - M.b} className="axis" />

      {points.map((p, i) =>
        p.err ? <line key={`e${i}`} x1={sx(p.x)} x2={sx(p.x)} y1={sy(p.y - p.err)} y2={sy(p.y + p.err)} className="errbar" /> : null,
      )}
      {line && <path d={path} fill="none" stroke={color} strokeWidth={big ? 2.2 : 1.6} strokeOpacity="0.9" />}
      {points.map((p, i) => (
        <circle key={`p${i}`} cx={sx(p.x)} cy={sy(p.y)} r={r} fill={p.color ?? color} />
      ))}

      {onPickX && (
        <rect
          x={M.l}
          y={M.t}
          width={W - M.l - M.r}
          height={H - M.t - M.b}
          fill="transparent"
          className="chart-pick"
          onClick={(e) => onPickX(xFromClient(e))}
        />
      )}

      <text x={(M.l + W - M.r) / 2} y={H - fs * 0.5} className="axis-label" textAnchor="middle" fontSize={fs}>
        {xLabel}
      </text>
      <text
        x={fs}
        y={(M.t + H - M.b) / 2}
        className="axis-label"
        textAnchor="middle"
        fontSize={fs}
        transform={`rotate(-90 ${fs} ${(M.t + H - M.b) / 2})`}
      >
        {yLabel}
      </text>
    </svg>
  );
}
