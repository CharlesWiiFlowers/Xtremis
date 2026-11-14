-- IRSA también sirve Gaia DR3 (esquema gaia): estrellas brillantes en las Pléyades sin salir del TAP de IRSA
SELECT source_id, ra, dec, parallax, phot_g_mean_mag
FROM gaia.gaia_dr3_source
WHERE 1 = CONTAINS(POINT('ICRS', ra, dec), CIRCLE('ICRS', 56.75, 24.12, 0.5))
  AND phot_g_mean_mag < 10
