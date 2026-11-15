-- Consultas sobre la base local v2 (PostgreSQL) después de usar gaia_api.py y spherex_api.py

-- 1. Espectro SPHEREx de una estrella con sus datos Gaia, sin mediciones con flags graves
SELECT g.source_id, g.phot_g_mean_mag, g.bp_rp, e.longitud_onda_um, e.flujo_ujy, e.error_flujo_ujy, e.detector
FROM proyecto.espectro_spherex e
JOIN gaiadr3.gaia_source g USING (source_id)
WHERE NOT e.flag_malo
ORDER BY g.source_id, e.longitud_onda_um;

-- 2. Flujo medio por banda SPHEREx y por estrella
SELECT source_id, detector, COUNT(*) AS n, AVG(longitud_onda_um) AS um_medio, AVG(flujo_ujy) AS flujo_medio_ujy
FROM proyecto.espectro_spherex
WHERE NOT flag_malo
GROUP BY source_id, detector
ORDER BY source_id, detector;

-- 3. Imágenes SPHEREx guardadas por colección y detector
SELECT obs_collection, energy_bandpassname, COUNT(*) AS imagenes, MIN(t_min) AS primera_mjd, MAX(t_max) AS ultima_mjd
FROM spherex.imagenes
GROUP BY 1, 2 ORDER BY 1, 2;

-- 4. Qué tablas y columnas hay (metadatos)
SELECT esquema, categoria_es, COUNT(*) AS tablas, SUM(columnas) AS columnas
FROM meta.catalogo_tablas GROUP BY 1, 2 ORDER BY 1, 2;
