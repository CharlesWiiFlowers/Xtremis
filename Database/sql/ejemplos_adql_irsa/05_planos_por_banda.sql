-- Tabla CAOM plane: rango espectral y calidad por imagen/banda
SELECT obs_publisher_did, energy_bandpassname, energy_bounds_lower, energy_bounds_upper,
       energy_resolvingpower, time_exposure, quality_flag
FROM spherex.plane
WHERE energy_bandpassname = 'SPHEREx-D4'
