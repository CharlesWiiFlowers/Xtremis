-- Agregados calculados en el servidor (no se descargan filas individuales)
SELECT FLOOR(phot_g_mean_mag) AS mag_g, COUNT(*) AS n
FROM gaiadr3.gaia_source
WHERE phot_g_mean_mag < 10
GROUP BY mag_g
ORDER BY mag_g
