-- SPLICES: lista de fuentes objetivo para hielos (2MASS/WISE/Spitzer) en 1° alrededor de las Pléyades
SELECT source_id, designation, ra, dec, j, h, k, w1, w2
FROM splices
WHERE 1 = CONTAINS(POINT('ICRS', ra, dec), CIRCLE('ICRS', 56.75, 24.12, 1))
