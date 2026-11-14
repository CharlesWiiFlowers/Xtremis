-- Estrellas a menos de 20 pc con buena astrometría
SELECT source_id, ra, dec, parallax, parallax_error, phot_g_mean_mag, bp_rp
FROM gaiadr3.gaia_source
WHERE parallax > 50 AND parallax_over_error > 10
