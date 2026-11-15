import test from 'node:test';
import assert from 'node:assert/strict';
import { orbitalPeriodDays, orbitalPosition, projectSky, createDemoStars, solveKepler } from '../orbital/public/orbital-math.mjs';

test('Kepler resuelve la ecuación para una órbita excéntrica', () => {
  const e = 0.5;
  const M = 1.2;
  const E = solveKepler(M, e);
  assert.ok(Math.abs(E - e * Math.sin(E) - M) < 1e-9);
});

test('la Tierra describe una órbita circular unitaria en los puntos cardinales', () => {
  const earth = { a_au: 1, e: 0, peri_deg: 0 };
  const quarter = orbitalPosition(earth, orbitalPeriodDays(earth) / 4);
  assert.ok(Math.abs(quarter.x) < 1e-8);
  assert.ok(Math.abs(quarter.y - 1) < 1e-8);
  assert.ok(Math.abs(quarter.distanceAu - 1) < 1e-8);
});

test('el perihelio y afelio respetan a(1-e) y a(1+e)', () => {
  const body = { a_au: 2, e: 0.25, peri_deg: 0 };
  const peri = orbitalPosition(body, 0);
  const aphelion = orbitalPosition(body, orbitalPeriodDays(body) / 2);
  assert.ok(Math.abs(peri.distanceAu - 1.5) < 1e-8);
  assert.ok(Math.abs(aphelion.distanceAu - 2.5) < 1e-8);
});

test('la proyección celeste resuelve el cruce de 0/360 grados', () => {
  const point = projectSky(0.01, 20, 359.99, 20);
  assert.ok(point);
  assert.ok(point.xDeg > 0 && point.xDeg < 0.03);
  assert.ok(Math.abs(point.yDeg) < 1e-5);
});

test('el punto central se proyecta al origen y el hemisferio trasero queda fuera', () => {
  const center = projectSky(120, -15, 120, -15);
  assert.ok(center);
  assert.ok(Math.abs(center.xDeg) < 1e-10);
  assert.ok(Math.abs(center.yDeg) < 1e-10);
  assert.equal(projectSky(300, 15, 120, -15), null);
});

test('el laboratorio local genera datos repetibles y completos', () => {
  const a = createDemoStars(25, 42);
  const b = createDemoStars(25, 42);
  assert.deepEqual(a, b);
  assert.equal(a.length, 25);
  assert.match(a[0].id, /^LAB-/);
  assert.ok(a.every(row => Number.isFinite(row.x) && Number.isFinite(row.y) && row.spectralType));
});

test('la orientación proyectada incluye nodo ascendente y perihelio', () => {
  const body = { a_au: 1, e: 0, node_deg: 30, peri_deg: 60, mean_anomaly_deg: 0 };
  const position = orbitalPosition(body, 0);
  assert.ok(Math.abs(position.x - Math.cos(Math.PI / 2)) < 1e-8);
  assert.ok(Math.abs(position.y - Math.sin(Math.PI / 2)) < 1e-8);
});
