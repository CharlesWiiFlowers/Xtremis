import { orbitalPosition, orbitalPeriodDays, solveKepler } from './orbital-math.mjs';

const SOLAR_DAY = 365.256363004;
const AU_KM = 149_597_870.7;
const SOLAR_ORBITAL_SPEED_KMS = 29.7846918;
const LAB_RING_INNER_AU = 6.2;
const LAB_RING_WIDTH_AU = 2.6;

/**
 * Datos físicos de referencia publicados por JPL Solar System Dynamics.
 * Las magnitudes visuales y albedos son valores tabulados; no son mediciones en vivo.
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
  a_au: 'Semieje mayor (UA)',
  e: 'Excentricidad',
  i_deg: 'Inclinación orbital (°)',
  node_deg: 'Longitud del nodo ascendente (°)',
  peri_deg: 'Argumento / longitud del perihelio (°)',
  longitude_peri_deg: 'Longitud del perihelio (°)',
  mean_anomaly_deg: 'Anomalía media inicial (°)',
  source: 'Fuente de los elementos orbitales',
  color: 'Color de representación',
});

function niceName(value) {
  return String(value ?? '').replaceAll('_', ' ').replace(/\b\w/g, (letter) => letter.toUpperCase());
}

/** Devuelve los datos disponibles del Sol para la ficha de selección. */
export function buildSunInspection() {
  return {
    Identificador: 'SUN',
    Nombre: 'Sol',
    Tipo: 'Estrella · secuencia principal',
    'Clase espectral': 'G2 V',
    'Masa (kg)': 1.9884e30,
    'Radio medio (km)': 695700,
    'Densidad media (kg/m³)': 1408,
    'Temperatura efectiva (K)': 5772,
    'Luminosidad (W)': 3.828e26,
    'Gravedad ecuatorial (m/s²)': 274,
    'Velocidad de escape (km/s)': 617.6,
    'Periodo de rotación de referencia (h)': 609.12,
    'Edad aproximada (miles de millones de años)': 4.57,
    'Coordenada heliocéntrica X (UA)': 0,
    'Coordenada heliocéntrica Y (UA)': 0,
    'Origen de datos': 'NASA NSSDC · Sun Fact Sheet',
  };
}

/**
 * Combina todos los campos originales del cuerpo con sus propiedades físicas
 * de referencia y magnitudes derivadas de la órbita kepleriana actual.
 */
export function buildPlanetInspection(body, elapsedDays = 0, planetNames = {}) {
  if (!body || typeof body !== 'object') throw new TypeError('Se requiere un cuerpo orbital.');
  const name = String(body.name ?? 'Cuerpo sin nombre');
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
    Identificador: name,
    Nombre: planetNames[name] || name,
    Tipo: 'Planeta · modelo heliocéntrico',
  };

  for (const [key, value] of Object.entries(body)) {
    if (key.startsWith('_') || key === 'name' || value === undefined) continue;
    details[PLANET_FIELD_LABELS[key] || `Parámetro · ${niceName(key)}`] = value;
  }

  const physical = PLANET_PHYSICAL[name];
  if (physical) {
    Object.assign(details, {
      'Radio ecuatorial (km)': physical.equatorialRadiusKm,
      'Radio medio (km)': physical.meanRadiusKm,
      'Masa (10²⁴ kg)': physical.massE24Kg,
      'Densidad media (g/cm³)': physical.densityGcm3,
      'Rotación sideral (días)': physical.rotationDays,
      'Periodo orbital sideral de referencia (años)': physical.siderealPeriodYears,
      'Magnitud visual V(1,0)': physical.visualMagnitudeV10,
      'Albedo geométrico': physical.geometricAlbedo,
      'Gravedad ecuatorial (m/s²)': physical.equatorialGravityMs2,
      'Velocidad de escape (km/s)': physical.escapeVelocityKms,
    });
  }

  Object.assign(details, {
    'Periodo orbital calculado (días)': periodDays,
    'Periodo orbital calculado (años)': periodDays / SOLAR_DAY,
    'Perihelio (UA)': a * (1 - e),
    'Afelio (UA)': a * (1 + e),
    'Distancia actual al Sol (UA)': position.distanceAu,
    'Velocidad orbital aproximada (km/s)': orbitalSpeed,
    'Anomalía media actual (°)': position.meanAnomalyRad * 180 / Math.PI,
    'Anomalía verdadera actual (°)': ((trueAnomaly * 180 / Math.PI) + 360) % 360,
    'Posición heliocéntrica X (UA)': position.x,
    'Posición heliocéntrica Y (UA)': position.y,
    'Tiempo transcurrido en simulación (días)': Number(elapsedDays) || 0,
    'Tiempo transcurrido en simulación (años)': (Number(elapsedDays) || 0) / SOLAR_DAY,
    'Modelo dinámico': 'Problema de dos cuerpos · masa solar implícita',
    'Escala de la vista': 'Representación cenital 2D · no a escala de tamaño',
    'Distancia de referencia (km)': position.distanceAu * AU_KM,
    'Fuente de datos físicos': physical ? 'JPL Solar System Dynamics · Planetary Physical Parameters' : 'No disponible en el conjunto local',
  });
  return details;
}

/** Posiciona los objetos sintéticos en un anillo exterior visual, no físico. */
export function labScenePosition(star) {
  if (!star || typeof star !== 'object') throw new TypeError('Se requiere un objeto del laboratorio.');
  const angle = Math.atan2(Number(star.y) || 0, Number(star.x) || 0);
  const normalizedRadius = Math.min(1, Math.hypot(Number(star.x) || 0, Number(star.y) || 0));
  const radiusAu = LAB_RING_INNER_AU + normalizedRadius * LAB_RING_WIDTH_AU;
  return { x: Math.cos(angle) * radiusAu, y: Math.sin(angle) * radiusAu, radiusAu };
}

/** Todos los datos locales se muestran y se identifican explícitamente como sintéticos. */
export function buildLabInspection(star) {
  if (!star || typeof star !== 'object') throw new TypeError('Se requiere un objeto del laboratorio.');
  const position = labScenePosition(star);
  return {
    Identificador: star.id,
    'Tipo de objeto': 'Orbe experimental sintético',
    'Origen': 'Laboratorio local · generado en este dispositivo',
    'Clase espectral simulada': star.spectralType,
    'Temperatura simulada (K)': star.temperature,
    'Magnitud simulada': star.magnitude,
    'Distancia simulada (pc)': star.distancePc,
    'Índice de color simulado': star.colorIndex,
    'Coordenada local X (normalizada)': star.x,
    'Coordenada local Y (normalizada)': star.y,
    'Radio de representación en el anillo (UA visuales)': position.radiusAu,
    'Posición visual X (UA de escala)': position.x,
    'Posición visual Y (UA de escala)': position.y,
    'Región visual': 'Anillo experimental exterior · coordenadas normalizadas',
    'Nota científica': 'Datos demostrativos sintéticos; no son observaciones ni una órbita física medida.',
  };
}
