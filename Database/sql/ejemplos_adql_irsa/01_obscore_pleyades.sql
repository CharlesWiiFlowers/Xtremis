-- Imágenes SPHEREx QR3 cuyo centro está a menos de 2° de las Pléyades (TAP IRSA, tabla ObsCore)
SELECT obs_publisher_did, obs_id, obs_collection, energy_bandpassname, s_ra, s_dec,
       em_min, em_max, t_min, access_url
FROM spherex.obscore
WHERE obs_collection = 'spherex_qr3'
  AND 1 = CONTAINS(POINT('ICRS', s_ra, s_dec), CIRCLE('ICRS', 56.75, 24.12, 2))
