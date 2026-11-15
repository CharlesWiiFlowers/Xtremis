# Guía de APIs: Gaia DR3 + SPHEREx

Versión 2 del proyecto. Explica **todas las APIs** que usa el proyecto: qué datos tiene cada una, sus endpoints, el método HTTP, los parámetros y ejemplos con `curl` y Python. Todas son **gratuitas, públicas y no piden cuenta**. Una cuenta del Archivo Gaia es opcional y da límites más altos.

Fecha de verificación: 14 de noviembre de 2026. Cada endpoint de esta guía se probó con una petición real; los resultados de esas pruebas están en el apartado 9.

---

## 1. Resumen

| # | API | Organismo | Qué da | Endpoint base | Método | Protocolo |
|---|---|---|---|---|---|---|
| 1 | Gaia TAP | ESA | Tablas Gaia DR3 (91 en `gaiadr3`) con SQL/ADQL | `https://gea.esac.esa.int/tap-server/tap` | GET / POST | IVOA TAP 1.1 |
| 2 | Gaia DataLink | ESA | Espectros XP/RVS, curvas de luz y MCMC por `source_id` | `https://gea.esac.esa.int/data-server/data` | GET / POST | DataLink (ESA) |
| 3 | Gaia CDN (bulk) | ESA | Archivos `.csv.gz` completos (~9.75 TB) | `https://cdn.gea.esac.esa.int/Gaia/gdr3/` | GET | HTTP / S3 |
| 4 | IRSA TAP | NASA/IPAC | Tablas SPHEREx (`spherex.*`, `splices`), Gaia DR3 espejo, 2MASS, WISE, Euclid… (~1,015 tablas) | `https://irsa.ipac.caltech.edu/TAP` | GET / POST | IVOA TAP 1.1 |
| 5 | IRSA SIA2 | NASA/IPAC | Búsqueda de imágenes SPHEREx (DR1, QR3, cubo) | `https://irsa.ipac.caltech.edu/SIA` | GET | IVOA SIA 2.0 |
| 6 | IRSA IBE Cutouts | NASA/IPAC | Recortes de imágenes SPHEREx | `https://irsa.ipac.caltech.edu/ibe/data/spherex/...fits?center=&size=` | GET | HTTP |
| 7 | IRSA IBE directorios | NASA/IPAC | Todos los archivos SPHEREx navegables | `https://irsa.ipac.caltech.edu/ibe/data/spherex/` | GET | HTTP |
| 8 | AWS S3 (Open Data) | NASA/IPAC en AWS | Copia de todos los archivos SPHEREx (~208 TB) | `s3://nasa-irsa-spherex` = `https://nasa-irsa-spherex.s3.amazonaws.com/` | GET (+ Range) | S3 REST |

Herramientas del proyecto que envuelven estas APIs:

- `scripts/gaia_api.py`: APIs 1 y 2.
- `scripts/spherex_api.py`: APIs 4, 5, 6 y 8. El comando `espectro` combina las APIs 1, 5 y 8.

---

## 2. Conceptos comunes

### 2.1 TAP y ADQL

**TAP** (Table Access Protocol) es el estándar IVOA para consultar tablas astronómicas por HTTP. El lenguaje de consulta es **ADQL**, que es SQL con extensiones geométricas:

| ADQL | Equivalente / nota |
|---|---|
| `SELECT TOP 100 ...` | `LIMIT 100` |
| `1 = CONTAINS(POINT('ICRS', ra, dec), CIRCLE('ICRS', 56.75, 24.12, 0.5))` | búsqueda en cono (grados) |
| `1 = INTERSECTS(s_region, CIRCLE(...))` | regiones que se tocan |
| `DISTANCE(POINT(...), POINT(...))` | separación angular en grados |
| `GROUP BY alias` | en el Archivo Gaia agrupa por alias, no por expresión |

**Modos de un servicio TAP:**

| Modo | URL | Uso |
|---|---|---|
| Síncrono | `<base>/sync` | La respuesta llega en la misma petición. Para consultas cortas. |
| Asíncrono (UWS) | `<base>/async` | Se crea un *job*, se consulta su estado y luego se descarga el resultado. Para consultas largas o grandes. |
| Metadatos | `<base>/tables`, `<base>/capabilities`, `<base>/availability`, `<base>/examples` | Lista de tablas/columnas, capacidades y ejemplos del servicio. |
| TAP_SCHEMA | consulta ADQL a `TAP_SCHEMA.tables` / `TAP_SCHEMA.columns` | Lo mismo que `/tables`, pero como tabla filtrable. |

**Parámetros de `/sync` y `/async` (POST `application/x-www-form-urlencoded` o GET con query string):**

| Parámetro | Valores | Obligatorio |
|---|---|---|
| `REQUEST` | `doQuery` | Gaia: sí. IRSA: opcional. |
| `LANG` | `ADQL` | sí |
| `QUERY` | texto ADQL (URL-encoded) | sí |
| `FORMAT` (o `RESPONSEFORMAT`) | `votable`, `csv`, `json`, `fits`, `ipac` (IRSA) | no (por defecto VOTable) |
| `MAXREC` | máximo de filas | no |
| `PHASE` | `RUN` (solo `/async`, arranca el job al crearlo) | no |

**Ciclo de vida de un job asíncrono (UWS):**

```text
POST <base>/async  (QUERY=..., PHASE=RUN)  -> 303 See Other, Location: <base>/async/<jobid>
GET  <base>/async/<jobid>/phase            -> PENDING | QUEUED | EXECUTING | COMPLETED | ERROR | ABORTED
GET  <base>/async/<jobid>/results/result   -> la tabla de resultados
GET  <base>/async/<jobid>/error            -> mensaje de error (si phase=ERROR)
DELETE <base>/async/<jobid>                 -> borra el job (o POST ACTION=DELETE)
```

### 2.2 VOTable, CSV, FITS

- **VOTable**: XML con tipos, unidades y UCD por columna. Es el formato más completo y el que usan astroquery/pyvo.
- **CSV**: el más simple, pero sin unidades.
- **FITS**: binario astronómico. SPHEREx entrega sus imágenes en FITS multi-extensión (MEF).

### 2.3 Identificadores que enlazan todo

| Llave | Dónde | Enlaza |
|---|---|---|
| `source_id` (BIGINT) | Gaia | `gaiadr3.*`, productos DataLink, `proyecto.espectro_spherex`, espejo `gaia.gaia_dr3_source` en IRSA |
| `obs_publisher_did` | SPHEREx | `spherex.obscore`, `spherex.plane`, `spherex.imagenes`, `spherex.recortes`, `proyecto.espectro_spherex` |
| `obs_id` | SPHEREx | Exposición: `<periodo>_<giro grande>_<giro pequeño>`, p. ej. `2026W34_2A_0036_1` |
| `ra`, `dec` (ICRS, grados) | ambos | Cruce espacial entre misiones |

---

## 3. API 1: Gaia TAP (ESA)

**Qué tiene:** las 91 tablas del esquema `gaiadr3`. Las principales son `gaia_source` (1,811,709,771 fuentes, 152 columnas), `astrophysical_parameters`, variabilidad (`vari_*`), binarias (`nss_*`), QSO y galaxias, sistema solar, cruces con 2MASS/AllWISE/Pan-STARRS/SDSS/Hipparcos, etc. El detalle está en `docs/catalogo_tablas.md` y `docs/diccionario_columnas.csv`.

| Recurso | Método | URL |
|---|---|---|
| Consulta síncrona | GET/POST | `https://gea.esac.esa.int/tap-server/tap/sync` |
| Consulta asíncrona | POST (crear), GET (estado/resultado), DELETE | `https://gea.esac.esa.int/tap-server/tap/async` |
| Tablas y columnas | GET | `https://gea.esac.esa.int/tap-server/tap/tables` |
| Capacidades | GET | `https://gea.esac.esa.int/tap-server/tap/capabilities` |
| Disponibilidad | GET | `https://gea.esac.esa.int/tap-server/tap/availability` |
| Ejemplos oficiales | GET | `https://gea.esac.esa.int/tap-server/tap/examples/` |
| Interfaz web | navegador | `https://gea.esac.esa.int/archive/` → *Search* → *Advanced (ADQL)* |

**Límites oficiales** ([Gaia Archive user quotas](https://www.cosmos.esa.int/web/gaia-users/archive/collaborate#GaiaArchiveUserQuotas)):

| Concepto | Anónimo | Con cuenta (gratis) |
|---|---|---|
| Time-out consulta síncrona | 60 s | 60 s |
| Time-out consulta asíncrona | 1 min | 120 min |
| Filas por consulta | 50,000 | sin límite |
| Fuentes por petición DataLink | 50 | 5,000 |
| Retención de jobs | 24 h | ilimitada |
| Espacio de usuario (resultados / tablas subidas) | — | 20 GB / 1 GB |

**curl, síncrono (POST):**

```bash
curl -s "https://gea.esac.esa.int/tap-server/tap/sync" \
  -d REQUEST=doQuery -d LANG=ADQL -d FORMAT=csv \
  --data-urlencode "QUERY=SELECT TOP 5 source_id, ra, dec, parallax, phot_g_mean_mag
                         FROM gaiadr3.gaia_source WHERE phot_g_mean_mag < 6"
```

**curl, asíncrono:**

```bash
JOB=$(curl -s -o /dev/null -w "%{redirect_url}" "https://gea.esac.esa.int/tap-server/tap/async" \
  -d REQUEST=doQuery -d LANG=ADQL -d FORMAT=csv -d PHASE=RUN \
  --data-urlencode "QUERY=SELECT source_id, ra, dec FROM gaiadr3.gaia_source WHERE parallax > 50")
curl -s "$JOB/phase"                         # repetir hasta COMPLETED
curl -sL "$JOB/results/result" -o cercanas.csv
```

**Listar tablas y columnas con ADQL:**

```sql
SELECT table_name, description, size FROM tap_schema.tables WHERE schema_name = 'gaiadr3';
SELECT column_name, datatype, unit, ucd, description FROM tap_schema.columns
WHERE table_name = 'gaiadr3.gaia_source';
```

**Python (astroquery):**

```python
from astroquery.gaia import Gaia
# Gaia.login(user="...", password="...")   # opcional: cuotas de usuario registrado
job = Gaia.launch_job_async("""
    SELECT source_id, ra, dec, parallax, phot_g_mean_mag
    FROM gaiadr3.gaia_source
    WHERE 1 = CONTAINS(POINT(ra, dec), CIRCLE(56.75, 24.12, 1)) AND parallax > 6
""")
tabla = job.get_results()          # astropy.table.Table
```

**Con el script del proyecto:**

```bash
python3 scripts/gaia_api.py adql --archivo sql/ejemplos_adql/02_cono_pleyades.sql --db postgresql:///gaia_spherex_v2 --tabla pleyades
```

---

## 4. API 2: Gaia DataLink (ESA)

**Qué tiene:** productos por fuente que no son tablas ADQL normales:

| `RETRIEVAL_TYPE` | Tabla local | Contenido |
|---|---|---|
| `EPOCH_PHOTOMETRY` | `gaiadr3.epoch_photometry` | Curvas de luz G, BP, RP por tránsito |
| `XP_CONTINUOUS` | `gaiadr3.xp_continuous_mean_spectrum` | Coeficientes del espectro BP/RP |
| `XP_SAMPLED` | `gaiadr3.xp_sampled_mean_spectrum` | Espectro BP/RP muestreado 336–1020 nm |
| `RVS` | `gaiadr3.rvs_mean_spectrum` | Espectro RVS 846–870 nm |
| `MCMC_GSPPHOT` | `gaiadr3.mcmc_samples_gsp_phot` | Cadenas MCMC de GSP-Phot |
| `MCMC_MSC` | `gaiadr3.mcmc_samples_msc` | Cadenas MCMC de MSC |
| `ALL` | — | Todos los anteriores disponibles |

Para saber si una fuente tiene cada producto, revisa estas columnas de `gaia_source`: `has_epoch_photometry`, `has_xp_continuous`, `has_xp_sampled`, `has_rvs`, `has_mcmc_gspphot`, `has_mcmc_msc`.

| Recurso | Método | URL |
|---|---|---|
| Descarga de productos | GET / POST | `https://gea.esac.esa.int/data-server/data` |
| Lista de enlaces DataLink de una fuente | GET | `https://gea.esac.esa.int/data-server/datalink/links?ID=Gaia+DR3+<source_id>` |

**Parámetros de `/data-server/data`:**

| Parámetro | Valores |
|---|---|
| `ID` | `source_id` separados por comas (máx. 50 anónimo / 5,000 con cuenta) |
| `RELEASE` | `Gaia DR3` |
| `RETRIEVAL_TYPE` | uno de la tabla anterior o `ALL` (no acepta listas separadas por comas) |
| `DATA_STRUCTURE` | `DATAMODEL_STANDARD` o `DATAMODEL_GAIA` (`INDIVIDUAL` y `COMBINED` ya están deprecados/rechazados) |
| `FORMAT` | `votable`, `votable_plain`, `fits`, `csv`, `ecsv` |
| `USE_ZIP_ALWAYS` | `true`: la respuesta es un ZIP con un archivo por producto |

```bash
curl -s "https://gea.esac.esa.int/data-server/data" -o curva.zip \
  -d ID=233786241137174272 -d "RELEASE=Gaia DR3" -d RETRIEVAL_TYPE=EPOCH_PHOTOMETRY \
  -d DATA_STRUCTURE=DATAMODEL_STANDARD -d FORMAT=csv -d USE_ZIP_ALWAYS=true
unzip -l curva.zip     # EPOCH_PHOTOMETRY_Gaia_DR3_233786241137174272.csv
```

```python
from astroquery.gaia import Gaia
datos = Gaia.load_data(ids=[233786241137174272], data_release="Gaia DR3",
                       retrieval_type="ALL", data_structure="DATAMODEL_STANDARD", format="votable")
```

```bash
python3 scripts/gaia_api.py datalink --ids 233786241137174272 --tipos EPOCH_PHOTOMETRY XP_SAMPLED --db postgresql:///gaia_spherex_v2
```

---

## 5. API 3: Gaia CDN (descarga masiva)

**Qué tiene:** las mismas tablas en archivos `.csv.gz` o ECSV partidos por HEALPix: 60 tablas DR3 y ~9.75 TB comprimidos (solo `gaia_source` son 753 GB). Las tablas heredadas de EDR3 están en `Gaia/gedr3/`. Para este proyecto **no se recomienda**. Solo conviene si alguna vez necesitas una tabla completa.

| Recurso | Método | URL |
|---|---|---|
| Navegador | GET | `https://cdn.gea.esac.esa.int/?prefix=Gaia/gdr3/` |
| Archivo directo | GET (admite `Range`) | `https://cdn.gea.esac.esa.int/Gaia/gdr3/<carpeta>/<archivo>.csv.gz` |
| Listado tipo S3 (XML) | GET | `https://gaia.eu-1.cdn77-storage.com/?prefix=Gaia/gdr3/&delimiter=/` |

```bash
curl -s "https://gaia.eu-1.cdn77-storage.com/?prefix=Gaia/gdr3/Variability/&delimiter=/"
```

`scripts/01_actualizar_metadatos.py` usa este CDN solo para leer tamaños y cabeceras: con `Range` lee los primeros KB de cada archivo, sin descargar las tablas.

---

## 6. SPHEREx: qué es y qué datos hay

SPHEREx (NASA, lanzado en marzo de 2025) hace el primer mapa espectral de todo el cielo entre **0.75 y 5 µm**. A diferencia de Gaia, **no publica (todavía) un catálogo de estrellas**: entrega **imágenes espectrales**. Cada imagen tiene 2040×2040 píxeles de 6.15″, y su longitud de onda cambia a lo largo del detector (filtro LVF). El espectro de una estrella se arma juntando muchas imágenes donde cae en posiciones distintas. El catálogo de fuentes está planeado para 2027.

**Publicaciones (releases) disponibles en IRSA/AWS:**

| Release | Contenido | Tamaño en S3 | Estado |
|---|---|---|---|
| `dr1` | Surveys 1 y 2 reprocesados + **All-Sky Cube** (12,288 cubos HEALPix de 102 canales) | 80.8 TB (76.9 TB imágenes, 3.9 TB cubos) | vigente (nov. 2026) |
| `qr3` | Surveys 3 y 4, publicación semanal | 29.2 TB (448,824 archivos) | vigente (desde sep. 2026) |
| `qr2` | Quick Release 2 | 98.0 TB | reemplazado por DR1+QR3; descarga directa hasta feb. 2027, ya no aparece en búsquedas |

**Detectores y bandas** (6 detectores = 6 bandas):

| Detector | λ (µm) | R |
|---|---|---|
| D1 | 0.75–1.09 | 39 |
| D2 | 1.10–1.62 | 41 |
| D3 | 1.63–2.41 | 41 |
| D4 | 2.42–3.82 | 35 |
| D5 | 3.83–4.41 | 112 |
| D6 | 4.42–5.00 | 128 |

**Imagen espectral (MEF, ~70 MB), extensiones:** `IMAGE` (MJy/sr, sin restar zodiacal), `FLAGS` (bits, definidos en la cabecera con `MSKNnnnn`/`MSKMnnnn`), `VARIANCE`, `ZODI` (modelo de luz zodiacal), `EPSF` (PSF efectiva por zona), `WCS-WAVE` (tabla de longitud de onda y ancho de banda por píxel).

**Productos de calibración** (solo por directorios/S3, no por SIA2): `abs_gain_matrix`, `dark`, `dichroic`, `epsf`, `gain_factors`, `nonfunc_v2`, `nonlinear_pars`, `readnoise_pars`, `solid_angle_pixel_map`, `spectral_wcs`, `spectral_channels`, `sip`, plantillas `aurora_template`, `he_template` y `shuttle_glow_template`, `xtalk_class1/2`, `zodi_scaling_v2`, `l3_flux_corrections`. Los tamaños por producto están en `data/spherex/tamanos_s3.csv`.

> El enlace `https://registry.opendata.aws/spherex-qr3/` responde 404. La ficha oficial está en <https://registry.opendata.aws/spherex-qr/>. El bucket es el mismo (`nasa-irsa-spherex`) y ahí están `qr3/` y `dr1/`.

---

## 7. APIs de SPHEREx (NASA/IPAC IRSA)

### 7.1 API 4: IRSA TAP

**Qué tiene (esquema `spherex`):**

| Tabla | Columnas | Contenido |
|---|---|---|
| `spherex.obscore` | 62 | Una fila por producto (imagen por detector, cubo) con posición, polígono `s_region`, rango espectral `em_min/em_max`, tiempos y `access_url`. Estándar IVOA ObsCore. |
| `spherex.plane` | 54 | Modelo CAOM: parámetros por plano/banda (`energy_bounds_*`, `time_exposure`, `quality_flag`, métricas de fondo). |
| `spherex.artifact` | 12 | Archivos asociados a cada plano (`uri`, `contentlength`, `contentchecksum`). |
| `spherex.observation` | 41 | Datos por observación (colección, `target_name`, instrumento, intención). |
| `spherex.provenance_input` | 2 | Relación entre imágenes y archivos de calibración usados. |
| `splices` | 157 | **SPLICES**: lista de 9,925,660 fuentes objetivo para estudiar hielos, con fotometría 2MASS/WISE/Spitzer. |

Además, el mismo servicio tiene **Gaia DR3** (`gaia.gaia_dr3_source`, `gaia.gaia_dr3_astrophys_param`…), **2MASS** (`fp_psc`), **AllWISE** (`allwise_p3as_psd`), **Euclid** (`euclid.*`) y unas 1,000 tablas más. Con eso se pueden hacer cruces entre misiones en una sola consulta.

| Recurso | Método | URL |
|---|---|---|
| Síncrono | GET/POST | `https://irsa.ipac.caltech.edu/TAP/sync` |
| Asíncrono | POST/GET/DELETE | `https://irsa.ipac.caltech.edu/TAP/async` |
| Tablas | GET | `https://irsa.ipac.caltech.edu/TAP/tables` |
| Capacidades | GET | `https://irsa.ipac.caltech.edu/TAP/capabilities` (time-out máx. 259,200 s = 72 h) |
| Ejemplos | GET | `https://irsa.ipac.caltech.edu/TAP/examples` |
| Documentación | — | <https://irsa.ipac.caltech.edu/docs/program_interface/TAP.html> |

```bash
# Metadatos (responde en ~1 s)
curl -s "https://irsa.ipac.caltech.edu/TAP/sync" -d LANG=ADQL -d FORMAT=csv \
  --data-urlencode "QUERY=SELECT table_name, description FROM TAP_SCHEMA.tables WHERE schema_name='spherex'"

# Datos: asíncrono recomendado
JOB=$(curl -s -o /dev/null -w "%{redirect_url}" "https://irsa.ipac.caltech.edu/TAP/async" \
  -d LANG=ADQL -d FORMAT=csv -d PHASE=RUN \
  --data-urlencode "QUERY=$(grep -v '^--' sql/ejemplos_adql_irsa/03_splices_region.sql)")   # sin comentarios
curl -s "$JOB/phase"; curl -sL "$JOB/results/result"
```

```python
import pyvo
tap = pyvo.dal.TAPService("https://irsa.ipac.caltech.edu/TAP")
t = tap.run_async("SELECT TOP 10 * FROM splices").to_table()
```

```bash
python3 scripts/spherex_api.py tap --archivo sql/ejemplos_adql_irsa/01_obscore_pleyades.sql --salida obscore.csv
```

> **Importante (verificado el 14/11/2026):**
> - El TAP de IRSA **no acepta comentarios** `-- ...` en la consulta y responde *"Invalid or unsupported ADQL query string"*. Los scripts del proyecto los quitan automáticamente; si usas `curl` o `pyvo` directo, quítalos tú.
> - Las consultas a tablas de datos tardan **~3 minutos** aunque sean pequeñas, por la cola del servicio. Las de `TAP_SCHEMA` responden en <1 s. Usa el modo asíncrono o un time-out largo; con `curl` y `-m 60` parece que "no carga".
> - Con `pyvo.run_async()` el sondeo largo (`WAIT=59`) provoca **"502 Proxy Error"**. `spherex_api.py tap` hace su propio sondeo cada 5 s y reintenta los 502/503 con espera creciente.
> - No lances muchas consultas a la vez: con 5 en paralelo, IRSA rechazó 3 con 502 al crearlas. En secuencia funcionaron todas.
> - Para buscar imágenes SPHEREx es mejor **SIA2** (1–3 s) que `spherex.obscore` por TAP.

### 7.2 API 5: IRSA SIA2 (búsqueda de imágenes)

**Qué tiene:** las imágenes SPHEREx y los cubos, buscables por posición, banda, tiempo, etc. Devuelve una tabla ObsCore con `access_url` (HTTPS) y `cloud_access` (bucket/key en S3).

| Recurso | Método | URL |
|---|---|---|
| Búsqueda | GET | `https://irsa.ipac.caltech.edu/SIA?COLLECTION=...&POS=...` |
| Documentación | — | <https://irsa.ipac.caltech.edu/ibe/sia.html> |

**Colecciones SPHEREx:** `spherex_dr1` (Wide), `spherex_dr1_deep` (Deep), `spherex_dr1_cube` (All-Sky Cube), `spherex_qr3` (Wide), `spherex_qr3_deep` (Deep).

**Parámetros principales:**

| Parámetro | Ejemplo | Significado |
|---|---|---|
| `COLLECTION` | `spherex_qr3` | obligatorio en la práctica (sin él busca en ~1,000 millones de registros) |
| `POS` | `CIRCLE 56.75 24.12 0.01`, `RANGE ra1 ra2 dec1 dec2`, `POLYGON ...` | región (grados) |
| `BAND` | `2.2e-6`, `1.5e-6 2.5e-6` | longitud de onda en **metros** |
| `TIME` | `61270 61280` | intervalo MJD |
| `CALIB` | `2` | nivel de calibración |
| `ID` | `ivo://irsa.ipac/spherex_qr3?2026W34_2A_0036_1/D1` | producto concreto |
| `CLOSEST` | `COLLECTION` | solo la imagen más cercana al centro por grupo |
| `MAXREC` | `100` | máximo de filas |
| `RESPONSEFORMAT` | `VOTABLE` (defecto), `HTML`, `CSV` | formato |

```bash
curl -s "https://irsa.ipac.caltech.edu/SIA?COLLECTION=spherex_qr3&POS=circle+56.75+24.12+0.01&RESPONSEFORMAT=CSV" -o imagenes.csv
```

```python
from pyvo.dal.sia2 import SIA2Service
sia = SIA2Service("https://irsa.ipac.caltech.edu/SIA")
t = sia.search(pos=(56.75, 24.12, 0.01), collection="spherex_qr3").to_table()
print(t["obs_id", "energy_bandpassname", "access_url"])
# Alternativa: from astroquery.ipac.irsa import Irsa; Irsa.query_sia(pos=..., collection="spherex_qr3")
```

```bash
python3 scripts/spherex_api.py imagenes --ra 56.75 --dec 24.12 --radio 0.01 --db postgresql:///gaia_spherex_v2
```

### 7.3 API 6: IRSA IBE Cutouts (recortes)

**Qué da:** un FITS con las mismas extensiones que la imagen original, pero solo con el recuadro pedido. Un recorte de 0.02° pesa ~4 MB, contra ~70 MB de la imagen completa; casi todo ese peso es la extensión EPSF.

| Recurso | Método | URL |
|---|---|---|
| Recorte | GET | `<access_url>?center=<ra>,<dec>&size=<grados>` |
| Documentación | — | <https://irsa.ipac.caltech.edu/ibe/cutouts.html> |

| Parámetro | Ejemplo | Nota |
|---|---|---|
| `center` | `56.75,24.12` (grados), `570,900pix` | centro |
| `size` | `0.02`, `1arcmin`, `100pix`, `0.02,0.04` | lado (o ancho,alto) |
| `gzip` | `false` | SPHEREx nunca se comprime |

```bash
curl -o recorte.fits "https://irsa.ipac.caltech.edu/ibe/data/spherex/qr3/level2/2026W34_2A/l2b-v27-2026-243/1/level2_2026W34_2A_0036_1D1_spx_l2b-v27-2026-243.fits?center=56.75,24.12&size=0.02"
```

```bash
python3 scripts/spherex_api.py recorte --ra 56.75 --dec 24.12 --tamano 0.02 --max 6 --dir recortes --db postgresql:///gaia_spherex_v2
```

> El servicio a veces responde `503 Service Unavailable` y al reintentar funciona. El script reintenta hasta 5 veces.

### 7.4 API 7: IRSA IBE, directorios navegables

| Recurso | Método | URL |
|---|---|---|
| Raíz SPHEREx | GET | `https://irsa.ipac.caltech.edu/ibe/data/spherex/` |
| Imágenes | GET | `.../<release>/level2/<periodo>/l2b-v<ver>-<fecha>/<detector>/level2_<obs_id>D<det>_spx_l2b-v<ver>-<fecha>.fits` |
| Cubo DR1 | GET | `.../dr1/hips5_cube/hips_20261026/Norder5/Dir<N>/Npix<pix>_cube.fits` |
| Calibraciones | GET | `.../<release>/<producto>/<versión>/<detector>/...` |

### 7.5 API 8: AWS S3 Open Data (`nasa-irsa-spherex`)

**Qué tiene:** copia exacta de los directorios IBE (`dr1/`, `qr3/`, `qr2/`), región `us-east-1`. Es **sin cuenta y sin costo** (`RequesterPays: False`). Admite `Range`, así que se pueden leer solo las cabeceras o unos cuantos píxeles de una imagen. El comando `espectro` del proyecto trabaja así.

| Operación | Método | URL / comando |
|---|---|---|
| Listar carpeta | GET | `https://nasa-irsa-spherex.s3.amazonaws.com/?list-type=2&prefix=qr3/&delimiter=/` |
| Metadatos de archivo | HEAD | `https://nasa-irsa-spherex.s3.amazonaws.com/<key>` |
| Descargar archivo | GET | `https://nasa-irsa-spherex.s3.amazonaws.com/<key>` |
| Leer solo bytes | GET + `Range: bytes=0-28799` | lee la cabecera FITS sin bajar los 70 MB |
| AWS CLI | — | `aws s3 ls --no-sign-request s3://nasa-irsa-spherex/qr3/` |

```bash
curl -s "https://nasa-irsa-spherex.s3.amazonaws.com/?list-type=2&prefix=dr1/&delimiter=/"
curl -s -r 0-28799 "https://nasa-irsa-spherex.s3.amazonaws.com/qr3/level2/2026W34_2A/l2b-v27-2026-243/1/level2_2026W34_2A_0036_1D1_spx_l2b-v27-2026-243.fits" | head -c 2880
```

```python
from astropy.io import fits
url = "s3://nasa-irsa-spherex/qr3/level2/2026W34_2A/l2b-v27-2026-243/1/level2_2026W34_2A_0036_1D1_spx_l2b-v27-2026-243.fits"
with fits.open(url, use_fsspec=True, fsspec_kwargs={"anon": True}) as h:
    trozo = h["IMAGE"].section[700:715, 1475:1490]   # solo descarga esos píxeles
```

```bash
python3 scripts/spherex_api.py s3 ls dr1/
python3 scripts/spherex_api.py s3 get qr3/spectral_channels/cal-sch-v2-2026-229/spectral_channels_spx_cal-sch-v2-2026-229.fits --dir cal
```

### 7.6 SPHEREx Data Explorer (interfaz web)

Interfaz gráfica para buscar, ver y descargar imágenes o recortes: <https://irsa.ipac.caltech.edu/applications/spherex>. No es una API, pero sirve para explorar antes de programar.

---

## 8. Integración Gaia + SPHEREx (v2)

El comando `spherex_api.py espectro` combina las APIs así:

```text
source_id ──(1) Gaia TAP──► ra, dec, pmra, pmdec (época 2016.0)
          ──(5) SIA2──────► imágenes SPHEREx DR1+QR3 que contienen la posición (~330 por estrella en las Pléyades)
          ──(8) S3 Range──► por imagen: cabecera + 15×15 píxeles de IMAGE/VARIANCE/FLAGS/ZODI + tabla WCS-WAVE
          ──local─────────► posición propagada a la fecha de la imagen, λ y ancho de banda en ese píxel,
                            fotometría de apertura (r=2 px) menos fondo (anillo 4–7 px), flujo en µJy
          ──► proyecto.espectro_spherex (una fila por estrella × imagen) + spherex.imagenes
```

Ejemplo:

```bash
python3 scripts/spherex_api.py espectro --ids 65207709611941376 --db postgresql:///gaia_spherex_v2 --salida espectro.csv
```

```sql
SELECT g.source_id, g.phot_g_mean_mag, e.longitud_onda_um, e.flujo_ujy, e.error_flujo_ujy
FROM proyecto.espectro_spherex e JOIN gaiadr3.gaia_source g USING (source_id)
WHERE NOT e.flag_malo ORDER BY e.longitud_onda_um;
```

Notas sobre esta fotometría:

- Es una **fotometría de apertura simple**, útil para explorar. No es la fotometría oficial: el catálogo oficial SPHEREx está planeado para 2027. Para trabajos de precisión, usa la PSF (`EPSF`) siguiendo los tutoriales de IRSA.
- Las estrellas muy brillantes (G ≲ 8) **saturan** en las bandas cortas. Esas mediciones quedan con `flag_malo = true`, y el píxel central puede salir `NaN`.
- Usa el ángulo sólido nominal del píxel (6.15″)². Para mayor exactitud, consulta el producto `solid_angle_pixel_map`.
- Tiempo medido: 1 min 43 s para una estrella con 332 imágenes (8 hilos, ~2.4 s por imagen y por hilo). `--max-imagenes` sirve para hacer pruebas rápidas.

---

## 9. Pruebas realizadas (14/11/2026)

| API | Prueba | Resultado |
|---|---|---|
| Gaia TAP | 6 consultas de ejemplo (`sql/ejemplos_adql/`) | OK; la más grande devolvió 15,021 filas |
| Gaia DataLink | `curl` a `/data-server/data` y `gaia_api.py datalink` con los 6 tipos | OK (ZIP con CSV; arreglos guardados en PostgreSQL) |
| IRSA SIA2 | Pléyades, 5 colecciones | DR1: 227, QR3: 114, cubo: 2, deep: 0; ~1–2 s |
| IRSA Cutouts | 3 recortes de 0.02° | OK, ~4 MB cada uno; un 503 intermitente se resolvió al reintentar |
| AWS S3 | listado, `HEAD`, `Range` y `astropy` `.section` | OK, ~2.4 s por imagen |
| IRSA TAP | `TAP_SCHEMA` | OK (<1 s) |
| IRSA TAP | los 5 ejemplos de `sql/ejemplos_adql_irsa/` | OK con el script corregido: obscore 123 filas, imágenes que contienen el punto 334, splices 732, plane D4 269,707, Gaia en IRSA 41 (entre 1.5 y 7 min cada una) |
| IRSA TAP | `pyvo.run_async()` directo / 5 consultas en paralelo | 502 Proxy Error; corregido con sondeo propio y reintentos |
| IRSA TAP | consulta con comentarios `--` | rechazada por IRSA; corregido en los scripts (se quitan los comentarios) |
| Integración | `espectro` de 2 estrellas de las Pléyades (40 imágenes) | 73 mediciones de 0.74 a 4.39 µm guardadas en `proyecto.espectro_spherex` |
| Integración | `espectro` de 1 estrella con todas sus imágenes (332, DR1+QR3) | 331 mediciones en 1 min 43 s, sin errores |

---

## 10. Referencias

- Archivo Gaia: <https://gea.esac.esa.int/archive/>. Modelo de datos DR3: <https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/>.
- Cuotas Gaia: <https://www.cosmos.esa.int/web/gaia-users/archive/collaborate#GaiaArchiveUserQuotas>. FAQ: <https://www.cosmos.esa.int/web/gaia-users/archive/faq>.
- Licencia y cita Gaia: <https://www.cosmos.esa.int/web/gaia-users/license>, <https://www.cosmos.esa.int/web/gaia-users/credits>.
- SPHEREx en IRSA: <https://irsa.ipac.caltech.edu/Missions/spherex.html>. Guía del archivo: <https://caltech-ipac.github.io/spherex-archive-documentation/>.
- Explanatory Supplement: <https://irsa.ipac.caltech.edu/data/SPHEREx/docs/SPHEREx_Expsupp.pdf>.
- Tutoriales Python: <https://caltech-ipac.github.io/irsa-tutorials/spherex-intro/>.
- Acceso en la nube: <https://irsa.ipac.caltech.edu/cloud_access/>. Registro AWS: <https://registry.opendata.aws/spherex-qr/>.
- Uso de datos IRSA y cita SPHEREx: <https://irsa.ipac.caltech.edu/data_use_terms.html>. DOI QR1: 10.26131/IRSA629; DOI QR2: 10.26131/IRSA652. Consulta en IRSA los DOI de DR1 y QR3.
