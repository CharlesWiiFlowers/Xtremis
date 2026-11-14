# Base de datos Gaia DR3 — versión 1 (solo API)

Paquete ligero para trabajar con **Gaia Data Release 3** sin descargar el catálogo completo
(~9.75 TB comprimidos en <https://cdn.gea.esac.esa.int/?prefix=Gaia/gdr3/>; solo `gaia_source` ocupa ~753 GB).

Los datos se quedan en los servidores de la ESA. Localmente solo tienes:

1. **El esquema** de todas las tablas de Gaia DR3 (PostgreSQL y SQLite), sin datos.
2. **El catálogo de tablas y el diccionario de columnas** (qué hay, tipos, unidades, descripciones).
3. **Un script de consultas** (`scripts/gaia_api.py`) que pide a la API de Gaia solo las filas y columnas que
   necesitas y las guarda en tu base local o en un archivo.

## 1. Qué contiene

| Concepto | Valor |
|---|---|
| Tablas `gaiadr3` consultables por API TAP (ADQL) | 91 |
| Productos DataLink (espectros, curvas de luz, MCMC) | 6 |
| Total de tablas en el esquema local | 97 |
| Columnas documentadas | 2,205 (tipo, unidad, UCD, descripción) |
| Peso del paquete | unos pocos MB |

```
gaia-dr3-db/
├── README.md
├── requirements.txt
├── docs/
│   ├── catalogo_tablas.md / .csv   una fila por tabla: categoría, acceso, nº columnas, filas en Gaia, tamaño CDN, descripción
│   ├── diccionario_columnas.csv    una fila por columna: tipo TAP/ECSV, tipo PostgreSQL, tipo SQLite, unidad, UCD, descripción
│   └── gaia_dr3_v1.xlsx            las dos hojas anteriores en Excel
├── sql/
│   ├── 01_esquema_postgres.sql     CREATE TABLE gaiadr3.* (97 tablas vacías, con comentarios por columna)
│   ├── 01_esquema_sqlite.sql       lo mismo para SQLite (los arreglos se guardan como JSON en TEXT)
│   ├── 02_metadatos_postgres.sql   tablas meta.catalogo_tablas y meta.diccionario_columnas con datos
│   ├── 02_metadatos_sqlite.sql     lo mismo para SQLite (meta_catalogo_tablas, meta_diccionario_columnas)
│   └── ejemplos_adql/              consultas ADQL listas para usar
├── data/                           metadatos crudos descargados de Gaia (TAP_SCHEMA, cabeceras DataLink, tamaños CDN)
└── scripts/
    ├── gaia_api.py                 consultas a la API y guardado local
    ├── 01_actualizar_metadatos.py  vuelve a descargar los metadatos desde Gaia
    └── 02_generar_esquema.py       regenera sql/ y docs/ a partir de data/
```

## 2. Las dos formas de pedir datos a Gaia

| Tipo | Qué es | Cómo se pide | Ejemplos |
|---|---|---|---|
| **TAP / ADQL** | Tablas normales; consultas tipo SQL que corren en el servidor de la ESA | `gaia_api.py adql` | `gaia_source`, `astrophysical_parameters`, `vari_*`, `nss_*`, `qso_candidates`, cruces con 2MASS/AllWISE… |
| **DataLink** | Productos por fuente con arreglos grandes; no se pueden filtrar con ADQL, se piden por `source_id` | `gaia_api.py datalink` | `epoch_photometry` (curvas de luz), `xp_continuous_mean_spectrum`, `xp_sampled_mean_spectrum`, `rvs_mean_spectrum`, `mcmc_samples_gsp_phot`, `mcmc_samples_msc` |

Para saber si una fuente tiene producto DataLink usa las columnas `has_epoch_photometry`, `has_xp_continuous`,
`has_xp_sampled`, `has_rvs`, `has_mcmc_gspphot`, `has_mcmc_msc` de `gaia_source`.

La llave común es **`source_id`** (BIGINT): enlaza `gaia_source` con casi todas las demás tablas. Las tablas del
sistema solar usan `number_mp` / `denomination`.

## 3. Instalación

```bash
pip install -r requirements.txt
```

Base local (elige una, es opcional; también puedes guardar solo en archivos):

```bash
# PostgreSQL
createdb gaia_dr3
psql -d gaia_dr3 -f sql/01_esquema_postgres.sql
psql -d gaia_dr3 -f sql/02_metadatos_postgres.sql

# SQLite (no requiere servidor)
python3 -c "import sqlite3; c = sqlite3.connect('gaia.db'); \
  [c.executescript(open(f).read()) for f in ('sql/01_esquema_sqlite.sql', 'sql/02_metadatos_sqlite.sql')]"
```

## 4. Uso de `scripts/gaia_api.py`

```bash
cd scripts

# Consulta ADQL -> PostgreSQL. Si todas las columnas existen en gaiadr3.gaia_source, se insertan ahí.
python3 gaia_api.py adql "SELECT TOP 1000 source_id, ra, dec, parallax, phot_g_mean_mag
                         FROM gaiadr3.gaia_source WHERE phot_g_mean_mag < 8" --db postgresql:///gaia_dr3

# Consulta con JOIN o columnas calculadas -> tabla propia (se crea sola en el esquema "proyecto")
python3 gaia_api.py adql --archivo ../sql/ejemplos_adql/02_cono_pleyades.sql \
        --db postgresql:///gaia_dr3 --tabla pleyades

# Lo mismo en SQLite y además a archivo (.csv, .ecsv o .parquet)
python3 gaia_api.py adql --archivo ../sql/ejemplos_adql/04_cefeidas.sql \
        --db sqlite:///../gaia.db --salida cefeidas.parquet

# DataLink: curvas de luz y espectros XP de fuentes concretas
python3 gaia_api.py datalink --ids 233786241137174272 5937083312263887616 \
        --tipos EPOCH_PHOTOMETRY XP_SAMPLED --db postgresql:///gaia_dr3

# DataLink a partir de una consulta (todos los productos disponibles, guardados en CSV por producto)
python3 gaia_api.py datalink --ids-adql "$(cat ../sql/ejemplos_adql/05_fuentes_con_rvs.sql)" \
        --tipos RVS --salida rvs.csv
```

Opciones comunes: `--db` (`postgresql://usuario:clave@host/base` o `sqlite:///ruta.db`), `--salida`,
`--tabla` (tabla propia de destino), `--reemplazar` (vacía la tabla antes de insertar). Ayuda: `python3 gaia_api.py -h`.

## 5. ADQL en 1 minuto

ADQL es SQL con algunas diferencias:

- `SELECT TOP 100 ...` en lugar de `LIMIT 100`.
- Búsqueda espacial: `WHERE 1 = CONTAINS(POINT(ra, dec), CIRCLE(56.75, 24.12, 1))` (grados).
- Las tablas se escriben con esquema: `gaiadr3.gaia_source`.
- Los agregados (`COUNT`, `AVG`, `GROUP BY`) corren en el servidor: úsalos para estadísticas sin descargar filas.
  En el Archivo Gaia agrupa por el alias (`GROUP BY mag_g`), no por la expresión (`GROUP BY FLOOR(...)` da error 500).

Más ejemplos en `sql/ejemplos_adql/`. Para probar consultas en el navegador: <https://gea.esac.esa.int/archive/> → *Search* → *Advanced (ADQL)*.

## 6. Límites de la API

- Sin cuenta: ~3 millones de filas por consulta y ~1 hora de ejecución. Con cuenta gratuita del Archivo Gaia
  los límites son mayores; el script la usa si defines `GAIA_USUARIO` y `GAIA_CONTRASENA`.
- Selecciona solo las columnas que necesitas (`SELECT *` en `gaia_source` trae 152 columnas).
- DataLink acepta hasta ~5,000 fuentes por petición; el script las envía en lotes de 500 (`--lote`).
- Si el archivo de la ESA está caído, las mismas tablas existen en VizieR y en el TAP del ARI Heidelberg
  (con otros nombres de esquema).

## 7. Actualizar metadatos

```bash
cd scripts
python3 01_actualizar_metadatos.py   # baja TAP_SCHEMA, tamaños del CDN y cabeceras DataLink a data/
python3 02_generar_esquema.py        # regenera sql/ y docs/
```

## Fuente, licencia y cita

Datos: ESA/Gaia/DPAC. Licencia: <https://www.cosmos.esa.int/web/gaia-users/license>.
Cómo citar: <https://www.cosmos.esa.int/web/gaia-users/credits>.
Modelo de datos oficial: <https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/>.
