-- Estrellas más brillantes que G=6 (columnas de gaiadr3.gaia_source -> se guardan en esa tabla)
SELECT source_id, ra, dec, parallax, pmra, pmdec, phot_g_mean_mag, bp_rp, radial_velocity
FROM gaiadr3.gaia_source
WHERE phot_g_mean_mag < 6
