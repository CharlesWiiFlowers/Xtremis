/** Pure 2D math for ORBITAL: no WebGL or external dependencies. */
export function solveKepler(meanAnomaly, eccentricity) {
  const e = Math.max(0, Math.min(0.999999, Number(eccentricity) || 0));
  let M = Number(meanAnomaly) || 0;
  M = ((M + Math.PI) % (2 * Math.PI) + 2 * Math.PI) % (2 * Math.PI) - Math.PI;
  let E = e < 0.8 ? M : Math.sign(M || 1) * Math.PI;
  for (let i = 0; i < 18; i += 1) {
    const f = E - e * Math.sin(E) - M;
    const fp = 1 - e * Math.cos(E);
    const step = f / fp;
    E -= step;
    if (Math.abs(step) < 1e-11) break;
  }
  return E;
}

export function orbitalPeriodDays(body) {
  const a = Number(body?.a_au);
  if (!Number.isFinite(a) || a <= 0) throw new RangeError('The semi-major axis must be positive.');
  return 365.256363004 * Math.sqrt(a ** 3);
}

/** Heliocentric position projected onto the 2D plane (AU). */
export function orbitalPosition(body, elapsedDays = 0) {
  const a = Number(body?.a_au);
  const e = Math.max(0, Math.min(0.999999, Number(body?.e) || 0));
  if (!Number.isFinite(a) || a <= 0) throw new RangeError('The semi-major axis must be positive.');
  const period = orbitalPeriodDays(body);
  const m0 = Number(body?.mean_anomaly_deg ?? body?.mean_anomaly ?? 0) * Math.PI / 180;
  const M = m0 + (2 * Math.PI * Number(elapsedDays || 0)) / period;
  const E = solveKepler(M, e);
  const xOrb = a * (Math.cos(E) - e);
  const yOrb = a * Math.sqrt(1 - e * e) * Math.sin(E);
  const longitudePerihelion = body?.longitude_peri_deg ?? (Number(body?.node_deg ?? 0) + Number(body?.peri_deg ?? body?.arg_perihelion_deg ?? 0));
  const angle = Number(longitudePerihelion) * Math.PI / 180;
  return {
    x: xOrb * Math.cos(angle) - yOrb * Math.sin(angle),
    y: xOrb * Math.sin(angle) + yOrb * Math.cos(angle),
    distanceAu: Math.hypot(xOrb, yOrb),
    meanAnomalyRad: ((M % (2 * Math.PI)) + 2 * Math.PI) % (2 * Math.PI),
    periodDays: period,
  };
}

/** Gnomonic (tangent) projection of RA/Dec onto a flat field centered on RA0/Dec0. */
export function projectSky(raDeg, decDeg, ra0Deg, dec0Deg) {
  const rad = Math.PI / 180;
  const ra = Number(raDeg) * rad;
  const dec = Number(decDeg) * rad;
  const ra0 = Number(ra0Deg) * rad;
  const dec0 = Number(dec0Deg) * rad;
  if (![ra, dec, ra0, dec0].every(Number.isFinite)) return null;
  const delta = Math.atan2(Math.sin(ra - ra0), Math.cos(ra - ra0));
  const denom = Math.sin(dec0) * Math.sin(dec) + Math.cos(dec0) * Math.cos(dec) * Math.cos(delta);
  if (denom <= 0) return null; // outside the visible hemisphere of the projection
  const x = Math.cos(dec) * Math.sin(delta) / denom;
  const y = (Math.cos(dec0) * Math.sin(dec) - Math.sin(dec0) * Math.cos(dec) * Math.cos(delta)) / denom;
  return { xDeg: x / rad, yDeg: y / rad };
}

/** Reproducible local field for the offline lab. */
export function createDemoStars(count = 180, seed = 0x0b17a1) {
  let state = seed >>> 0;
  const random = () => {
    state = (1664525 * state + 1013904223) >>> 0;
    return state / 4294967296;
  };
  const classes = ['Red dwarf', 'Main sequence', 'Giant', 'White dwarf'];
  return Array.from({ length: Math.max(1, Math.min(2000, Math.floor(count))) }, (_, i) => {
    const angle = random() * Math.PI * 2;
    const radius = Math.sqrt(random()) * 0.96;
    const spectral = random();
    const spectralClass = spectral < 0.48 ? 'Red dwarf' : spectral < 0.84 ? 'Main sequence' : spectral < 0.95 ? 'Giant' : 'White dwarf';
    return {
      id: `LAB-${String(i + 1).padStart(4, '0')}`,
      x: Math.cos(angle) * radius,
      y: Math.sin(angle) * radius,
      magnitude: Number((2.2 + random() * 10.5).toFixed(2)),
      temperature: Math.round(2600 + random() * 9500),
      spectralType: spectralClass,
      colorIndex: Number((random() * 2.8 - 0.35).toFixed(2)),
      distancePc: Number((4 + random() * 950).toFixed(1)),
    };
  });
}
