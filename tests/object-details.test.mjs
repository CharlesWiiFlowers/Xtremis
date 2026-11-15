import test from 'node:test';
import assert from 'node:assert/strict';
import { buildLabInspection, buildPlanetInspection, buildSunInspection, labScenePosition, PLANET_PHYSICAL } from '../web/object-details.mjs';

const NAMES = { Earth: 'Tierra', Mercury: 'Mercurio' };

test('la ficha del planeta integra datos orbitales originales y datos físicos JPL', () => {
  const body = { name: 'Earth', a_au: 1, e: 0.0167, i_deg: 0, node_deg: 0, peri_deg: 102.94, mean_anomaly_deg: 357.53, source: 'approx J2000', color: '#4f9dff' };
  const details = buildPlanetInspection(body, 10, NAMES);
  assert.equal(details.Nombre, 'Tierra');
  assert.equal(details['Semieje mayor (UA)'], 1);
  assert.equal(details['Excentricidad'], 0.0167);
  assert.equal(details['Masa (10²⁴ kg)'], PLANET_PHYSICAL.Earth.massE24Kg);
  assert.ok(details['Periodo orbital calculado (días)'] > 365);
  assert.ok(details['Velocidad orbital aproximada (km/s)'] > 20);
  assert.equal(details['Tiempo transcurrido en simulación (días)'], 10);
  assert.ok(details['Posición heliocéntrica X (UA)'] !== undefined);
});

test('la ficha conserva campos extra agregados por una fuente de datos futura', () => {
  const body = { name: 'Mercury', a_au: 0.387, e: 0.2056, extra_metadata: 'preserve-me' };
  const details = buildPlanetInspection(body, 0, NAMES);
  assert.equal(details['Parámetro · Extra Metadata'], 'preserve-me');
});

test('el Sol tiene ficha seleccionable con propiedades de referencia', () => {
  const details = buildSunInspection();
  assert.equal(details.Identificador, 'SUN');
  assert.equal(details['Clase espectral'], 'G2 V');
  assert.equal(details['Radio medio (km)'], 695700);
  assert.equal(details['Coordenada heliocéntrica X (UA)'], 0);
});

test('todos los campos locales se muestran y se identifican como sintéticos', () => {
  const star = { id: 'LAB-0001', x: 0.5, y: -0.25, magnitude: 6.2, temperature: 5800, spectralType: 'Secuencia principal', colorIndex: 0.65, distancePc: 24.5 };
  const details = buildLabInspection(star, 6.4);
  assert.equal(details.Identificador, 'LAB-0001');
  assert.equal(details['Temperatura simulada (K)'], 5800);
  const position = labScenePosition(star);
  assert.equal(details['Posición visual X (UA de escala)'], position.x);
  assert.ok(position.radiusAu >= 6.2 && position.radiusAu <= 8.8);
  assert.match(details['Nota científica'], /no son observaciones/);
});
