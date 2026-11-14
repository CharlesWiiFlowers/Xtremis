# Base de datos v2: Gaia DR3 + SPHEREx (solo API)

Paquete ligero que integra **Gaia DR3** (ESA) y **SPHEREx** (NASA/IPAC, DR1 + QR3) **sin descargar los catálogos completos**. Gaia DR3 ocupa ~9.75 TB; SPHEREx DR1 + QR3 ocupan ~110 TB en `s3://nasa-irsa-spherex`. Los datos se quedan en los servidores de la ESA, IRSA y AWS. Localmente guardas solo el esquema, los metadatos y lo que consultes.

**Documento principal: [`docs/guia_apis.md`](docs/guia_apis.md)** (también en PDF). Explica las 8 APIs: qué contienen, sus endpoints, el método HTTP, los parámetros, los límites y ejemplos con curl y Python.

## Qué hay de nuevo respecto a la v1

| | v1 | v2 |
|---|---|---|
| Fuentes | Gaia DR3 | Gaia DR3 + SPHEREx (IRSA TAP, SIA2, cutouts, S3) |
| Tablas en el esquema | 97 | 106 (`gaiadr3` 97, `spherex` 8, `proyecto` 1) |
| Columnas documentadas | 2,205 | 2,583 |
| Scripts | `gaia_api.py` | `gaia_api.py` + `spherex_api.py` |
| Integración | — | `proyecto.espectro_spherex`: espectro SPHEREx de 0.75–5 µm por `source_id` de Gaia |

## Contenido

```
gaia-spherex-v2/
├── docs/
│   ├── guia_apis.md / .pdf        guía de todas las APIs
│   ├── catalogo_tablas.md / .csv  una fila por tabla (esquema, categoría, acceso, columnas, filas, URL)
│   ├── diccionario_columnas.csv   una fila por columna (tipo origen, PostgreSQL, SQLite, unidad, UCD, descripción)
│   └── gaia_spherex_v2.xlsx       catálogo + diccionario en Excel
├── sql/
│   ├── 01_esquema_postgres.sql    esquemas gaiadr3, spherex, proyecto (tablas vacías, comentadas)
│   ├── 01_esquema_sqlite.sql      lo mismo para SQLite (spherex_* y proyecto_* como prefijos)
│   ├── 02_metadatos_*.sql         meta.catalogo_tablas y meta.diccionario_columnas con datos
│   ├── ejemplos_adql/             consultas ADQL para Gaia (gaia_api.py)
│   ├── ejemplos_adql_irsa/        consultas ADQL para IRSA/SPHEREx (spherex_api.py tap)
│   └── ejemplos_locales_v2.sql    consultas SQL sobre la base local (JOIN Gaia + SPHEREx)
├── data/                          metadatos crudos: TAP_SCHEMA de Gaia e IRSA, cabeceras DataLink, tamaños CDN y S3
└── scripts/
    ├── gaia_api.py                Gaia TAP + DataLink
    ├── spherex_api.py             SPHEREx: imagenes | tap | recorte | espectro | s3
    ├── 01_actualizar_metadatos.py vuelve a bajar metadatos Gaia
    └── 02_generar_esquema.py      regenera sql/ y docs/
```

## Instalación

```bash
pip install -r requirements.txt

# PostgreSQL (opcional)
createdb gaia_spherex_v2
psql -d gaia_spherex_v2 -f sql/01_esquema_postgres.sql
psql -d gaia_spherex_v2 -f sql/02_metadatos_postgres.sql

# o SQLite (sin servidor)
python3 -c "import sqlite3; c = sqlite3.connect('gaia.db'); \
  [c.executescript(open(f).read()) for f in ('sql/01_esquema_sqlite.sql', 'sql/02_metadatos_sqlite.sql')]"
```

## Uso rápido

```bash
cd scripts
DB=postgresql:///gaia_spherex_v2        # o sqlite:///../gaia.db

# Gaia
python3 gaia_api.py adql --archivo ../sql/ejemplos_adql/02_cono_pleyades.sql --db $DB --tabla pleyades
python3 gaia_api.py datalink --ids 233786241137174272 --tipos XP_SAMPLED RVS --db $DB

# SPHEREx
python3 spherex_api.py imagenes --ra 56.75 --dec 24.12 --radio 0.01 --db $DB          # SIA2
python3 spherex_api.py recorte  --ra 56.75 --dec 24.12 --tamano 0.02 --max 6 --dir recortes --db $DB
python3 spherex_api.py tap --archivo ../sql/ejemplos_adql_irsa/03_splices_region.sql --salida splices.csv
python3 spherex_api.py s3 ls dr1/

# Gaia + SPHEREx: espectro infrarrojo de estrellas Gaia
python3 spherex_api.py espectro --ids 65207709611941376 65231486552803328 --db $DB --salida espectro.csv
python3 spherex_api.py espectro --ids-adql "SELECT TOP 20 source_id FROM gaiadr3.gaia_source
      WHERE 1=CONTAINS(POINT(ra,dec),CIRCLE(56.75,24.12,0.5)) AND phot_g_mean_mag BETWEEN 10 AND 13" --db $DB
```

Ayuda de cada comando: `python3 spherex_api.py espectro -h`.

## Límites a tener en cuenta

- **Gaia, sin cuenta**: 50,000 filas por consulta, 1 min por consulta asíncrona y 50 fuentes por petición DataLink. Con una cuenta gratuita no hay límite de filas, las consultas pueden durar 120 min y DataLink acepta 5,000 fuentes. El script usa la cuenta si defines `GAIA_USUARIO` y `GAIA_CONTRASENA`.
- **SPHEREx** no tiene todavía catálogo de fuentes (sale en 2027). `espectro` hace una fotometría de apertura simple sobre los píxeles, útil para explorar. Las estrellas con G ≲ 8 saturan en las bandas cortas (`flag_malo = true`).
- **IRSA TAP** puede quedarse en cola cuando está saturado. Para buscar imágenes usa `imagenes` (SIA2), que es rápido.
- Los detalles están en la guía de APIs.

## Licencias y cita

- Gaia: ESA/Gaia/DPAC. Licencia: <https://www.cosmos.esa.int/web/gaia-users/license>. Cómo citar: <https://www.cosmos.esa.int/web/gaia-users/credits>.
- SPHEREx: NASA/IPAC IRSA. Términos: <https://irsa.ipac.caltech.edu/data_use_terms.html>. Agradecimiento sugerido: "This publication makes use of data products from the Spectro-Photometer for the History of the Universe, Epoch of Reionization and Ices Explorer (SPHEREx), which is a joint project of the Jet Propulsion Laboratory and the California Institute of Technology, and is funded by the National Aeronautics and Space Administration."
