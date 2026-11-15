import { orbitalPosition, orbitalPeriodDays, solveKepler } from './orbital-math.mjs';

const SOLAR_DAY = 365.256363004;
const AU_KM = 149_597_870.7;
const SOLAR_ORBITAL_SPEED_KMS = 29.7846918;
const LAB_RING_INNER_AU = 6.2;
const LAB_RING_WIDTH_AU = 2.6;

/**
 * Reference physical data published by JPL Solar System Dynamics.
 * Visual magnitudes and albedos are tabulated values, not live measurements.
 */
export const PLANET_PHYSICAL = Object.freeze({
  Mercury: Object.freeze({ equatorialRadiusKm: 2440.53, meanRadiusKm: 2439.4, massE24Kg: 0.330103, densityGcm3: 5.4289, rotationDays: 58.6462, siderealPeriodYears: 0.2408467, visualMagnitudeV10: -0.60, geometricAlbedo: 0.106, equatorialGravityMs2: 3.70, escapeVelocityKms: 4.25 }),
  Venus: Object.freeze({ equatorialRadiusKm: 6051.8, meanRadiusKm: 6051.8, massE24Kg: 4.86731, densityGcm3: 5.243, rotationDays: -243.018, siderealPeriodYears: 0.61519726, visualMagnitudeV10: -4.47, geometricAlbedo: 0.65, equatorialGravityMs2: 8.87, escapeVelocityKms: 10.36 }),
  Earth: Object.freeze({ equatorialRadiusKm: 6378.1366, meanRadiusKm: 6371.0084, massE24Kg: 5.97217, densityGcm3: 5.5134, rotationDays: 0.99726968, siderealPeriodYears: 1.0000174, visualMagnitudeV10: -3.86, geometricAlbedo: 0.367, equatorialGravityMs2: 9.80, escapeVelocityKms: 11.19 }),
  Mars: Object.freeze({ equatorialRadiusKm: 3396.19, meanRadiusKm: 3389.50, massE24Kg: 0.641691, densityGcm3: 3.9340, rotationDays: 1.02595676, siderealPeriodYears: 1.8808476, visualMagnitudeV10: -1.52, geometricAlbedo: 0.150, equatorialGravityMs2: 3.71, escapeVelocityKms: 5.03 }),
  Jupiter: Object.freeze({ equatorialRadiusKm: 71492, meanRadiusKm: 69911, massE24Kg: 1898.125, densityGcm3: 1.3262, rotationDays: 0.41354, siderealPeriodYears: 11.862615, visualMagnitudeV10: -9.40, geometricAlbedo: 0.52, equatorialGravityMs2: 24.79, escapeVelocityKms: 60.20 }),
  Saturn: Object.freeze({ equatorialRadiusKm: 60268, meanRadiusKm: 58232, massE24Kg: 568.317, densityGcm3: 0.6871, rotationDays: 0.44401, siderealPeriodYears: 29.447498, visualMagnitudeV10: -8.88, geometricAlbedo: 0.47, equatorialGravityMs2: 10.44, escapeVelocityKms: 36.09 }),
});

const PLANET_FIELD_LABELS = Object.freeze({
  a_au: 'Semi-major axis (AU)',
  e: 'Eccentricity',
  i_deg: 'Orbital inclination (°)',
  node_deg: 'Longitude of ascending node (°)',
  peri_deg: 'Argument / longitude of perihelion (°)',
  longitude_peri_deg: 'Longitude of perihelion (°)',
  mean_anomaly_deg: 'Initial mean anomaly (°)',
  source: 'Orbital elements source',
  color: 'Display color',
});

function niceName(value) {
  return String(value ?? '').replaceAll('_', ' ').replace(/\b\w/g, (letter) => letter.toUpperCase());
}

/** Returns the available Sun data for the selection card. */
export function buildSunInspection() {
  return {
    Identifier: 'SUN',
    Name: 'Sun',
    Type: 'Star · main sequence',
    'Spectral class': 'G2 V',
    'Mass (kg)': 1.9884e30,
    'Mean radius (km)': 695700,
    'Mean density (kg/m³)': 1408,
    'Effective temperature (K)': 5772,
    'Luminosity (W)': 3.828e26,
    'Equatorial gravity (m/s²)': 274,
    'Escape velocity (km/s)': 617.6,
    'Reference rotation period (h)': 609.12,
    'Approximate age (billion years)': 4.57,
    'Heliocentric coordinate X (AU)': 0,
    'Heliocentric coordinate Y (AU)': 0,
    'Data source': 'NASA NSSDC · Sun Fact Sheet',
  };
}

/**
 * Combines all of the body's original fields with its reference physical
 * properties and quantities derived from the current Keplerian orbit.
 */
export function buildPlanetInspection(body, elapsedDays = 0, planetNames = {}) {
  if (!body || typeof body !== 'object') throw new TypeError('An orbital body is required.');
  const name = String(body.name ?? 'Unnamed body');
  const a = Number(body.a_au);
  const e = Math.max(0, Math.min(0.999999, Number(body.e) || 0));
  const position = orbitalPosition(body, elapsedDays);
  const periodDays = orbitalPeriodDays(body);
  const eccentricAnomaly = solveKepler(position.meanAnomalyRad, e);
  const trueAnomaly = 2 * Math.atan2(
    Math.sqrt(1 + e) * Math.sin(eccentricAnomaly / 2),
    Math.sqrt(1 - e) * Math.cos(eccentricAnomaly / 2),
  );
  const orbitalSpeed = SOLAR_ORBITAL_SPEED_KMS * Math.sqrt(Math.max(0, 2 / position.distanceAu - 1 / a));
  const details = {
    Identifier: name,
    Name: planetNames[name] || name,
    Type: 'Planet · heliocentric model',
  };

  for (const [key, value] of Object.entries(body)) {
    if (key.startsWith('_') || key === 'name' || value === undefined) continue;
    details[PLANET_FIELD_LABELS[key] || `Parameter · ${niceName(key)}`] = value;
  }

  const physical = PLANET_PHYSICAL[name];
  if (physical) {
    Object.assign(details, {
      'Equatorial radius (km)': physical.equatorialRadiusKm,
      'Mean radius (km)': physical.meanRadiusKm,
      'Mass (10²⁴ kg)': physical.massE24Kg,
      'Mean density (g/cm³)': physical.densityGcm3,
      'Sidereal rotation (days)': physical.rotationDays,
      'Reference sidereal orbital period (years)': physical.siderealPeriodYears,
      'Visual magnitude V(1,0)': physical.visualMagnitudeV10,
      'Geometric albedo': physical.geometricAlbedo,
      'Equatorial gravity (m/s²)': physical.equatorialGravityMs2,
      'Escape velocity (km/s)': physical.escapeVelocityKms,
    });
  }

  Object.assign(details, {
    'Computed orbital period (days)': periodDays,
    'Computed orbital period (years)': periodDays / SOLAR_DAY,
    'Perihelion (AU)': a * (1 - e),
    'Aphelion (AU)': a * (1 + e),
    'Current distance to Sun (AU)': position.distanceAu,
    'Approximate orbital speed (km/s)': orbitalSpeed,
    'Current mean anomaly (°)': position.meanAnomalyRad * 180 / Math.PI,
    'Current true anomaly (°)': ((trueAnomaly * 180 / Math.PI) + 360) % 360,
    'Heliocentric position X (AU)': position.x,
    'Heliocentric position Y (AU)': position.y,
    'Elapsed simulation time (days)': Number(elapsedDays) || 0,
    'Elapsed simulation time (years)': (Number(elapsedDays) || 0) / SOLAR_DAY,
    'Dynamical model': 'Two-body problem · implicit solar mass',
    'View scale': 'Top-down 2D view · sizes not to scale',
    'Reference distance (km)': position.distanceAu * AU_KM,
    'Physical data source': physical ? 'JPL Solar System Dynamics · Planetary Physical Parameters' : 'Not available in the local dataset',
  });
  return details;
}

/** Places synthetic objects on a visual (not physical) outer ring. */
export function labScenePosition(star) {
  if (!star || typeof star !== 'object') throw new TypeError('A lab object is required.');
  const angle = Math.atan2(Number(star.y) || 0, Number(star.x) || 0);
  const normalizedRadius = Math.min(1, Math.hypot(Number(star.x) || 0, Number(star.y) || 0));
  const radiusAu = LAB_RING_INNER_AU + normalizedRadius * LAB_RING_WIDTH_AU;
  return { x: Math.cos(angle) * radiusAu, y: Math.sin(angle) * radiusAu, radiusAu };
}

/** All local data is shown and explicitly labeled as synthetic. */
export function buildLabInspection(star) {
  if (!star || typeof star !== 'object') throw new TypeError('A lab object is required.');
  const position = labScenePosition(star);
  return {
    Identifier: star.id,
    'Object type': 'Synthetic experimental orb',
    'Source': 'Local lab · generated on this device',
    'Simulated spectral class': star.spectralType,
    'Simulated temperature (K)': star.temperature,
    'Simulated magnitude': star.magnitude,
    'Simulated distance (pc)': star.distancePc,
    'Simulated color index': star.colorIndex,
    'Local coordinate X (normalized)': star.x,
    'Local coordinate Y (normalized)': star.y,
    'Display radius on the ring (visual AU)': position.radiusAu,
    'Visual position X (scale AU)': position.x,
    'Visual position Y (scale AU)': position.y,
    'Visual region': 'Outer experimental ring · normalized coordinates',
    'Scientific note': 'Synthetic demonstration data; these are not observations or a measured physical orbit.',
  };
}
