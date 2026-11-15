-- source_id de fuentes con espectro RVS (útil para: gaia_api.py datalink --ids-adql ...)
SELECT TOP 100 source_id
FROM gaiadr3.gaia_source
WHERE has_rvs = 'True' AND phot_g_mean_mag < 9
