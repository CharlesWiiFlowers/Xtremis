-- Imágenes cuyo polígono contiene un punto (equivalente a SIA2 POS=CIRCLE ra dec 0)
SELECT obs_publisher_did, energy_bandpassname, t_min, access_url
FROM spherex.obscore
WHERE 1 = CONTAINS(POINT('ICRS', 56.75, 24.12), s_region)
