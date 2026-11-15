-- Búsqueda en cono: 1 grado alrededor de las Pléyades con parámetros astrofísicos (usar --tabla)
SELECT g.source_id, g.ra, g.dec, g.parallax, 1000/g.parallax AS distancia_pc,
       g.phot_g_mean_mag, a.teff_gspphot, a.logg_gspphot, a.mh_gspphot
FROM gaiadr3.gaia_source AS g
JOIN gaiadr3.astrophysical_parameters AS a USING (source_id)
WHERE 1 = CONTAINS(POINT(g.ra, g.dec), CIRCLE(56.75, 24.12, 1))
  AND g.parallax > 6 AND g.parallax_over_error > 10
