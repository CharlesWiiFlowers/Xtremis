import test from 'node:test';
import assert from 'node:assert/strict';
import { buildLabInspection, buildPlanetInspection, buildSunInspection, labScenePosition, PLANET_PHYSICAL } from '../orbital/public/object-details.mjs';

const NAMES = { Earth: 'Earth', Mercury: 'Mercury' };

test('la ficha del planeta integra datos orbitales originales y datos físicos JPL', () => {
  const body = { name: 'Earth', a_au: 1, e: 0.0167, i_deg: 0, node_deg: 0, peri_deg: 102.94, mean_anomaly_deg: 357.53, source: 'approx J2000', color: '#4f9dff' };
  const details = buildPlanetInspection(body, 10, NAMES);
  assert.equal(details.Name, 'Earth');
  assert.equal(details['Semi-major axis (AU)'], 1);
  assert.equal(details['Eccentricity'], 0.0167);
  assert.equal(details['Mass (10²⁴ kg)'], PLANET_PHYSICAL.Earth.massE24Kg);
  assert.ok(details['Computed orbital period (days)'] > 365);
  assert.ok(details['Approximate orbital speed (km/s)'] > 20);
  assert.equal(details['Elapsed simulation time (days)'], 10);
  assert.ok(details['Heliocentric position X (AU)'] !== undefined);
});

test('la ficha conserva campos extra agregados por una fuente de datos futura', () => {
  const body = { name: 'Mercury', a_au: 0.387, e: 0.2056, extra_metadata: 'preserve-me' };
  const details = buildPlanetInspection(body, 0, NAMES);
  assert.equal(details['Parameter · Extra Metadata'], 'preserve-me');
});

test('el Sol tiene ficha seleccionable con propiedades de referencia', () => {
  const details = buildSunInspection();
  assert.equal(details.Identifier, 'SUN');
  assert.equal(details['Spectral class'], 'G2 V');
  assert.equal(details['Mean radius (km)'], 695700);
  assert.equal(details['Heliocentric coordinate X (AU)'], 0);
});

test('todos los campos locales se muestran y se identifican como sintéticos', () => {
  const star = { id: 'LAB-0001', x: 0.5, y: -0.25, magnitude: 6.2, temperature: 5800, spectralType: 'Main sequence', colorIndex: 0.65, distancePc: 24.5 };
  const details = buildLabInspection(star, 6.4);
  assert.equal(details.Identifier, 'LAB-0001');
  assert.equal(details['Simulated temperature (K)'], 5800);
  const position = labScenePosition(star);
  assert.equal(details['Visual position X (scale AU)'], position.x);
  assert.ok(position.radiusAu >= 6.2 && position.radiusAu <= 8.8);
  assert.match(details['Scientific note'], /not observations/);
});
