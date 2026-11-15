"""Rutas, categorías y mapeos de tipos compartidos por los scripts del proyecto Gaia DR3."""
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
DATA = RAIZ / "data"
DOCS = RAIZ / "docs"
SQL = RAIZ / "sql"
CDN = "https://cdn.gea.esac.esa.int/Gaia/gdr3/"
TAP_URL = "https://gea.esac.esa.int/tap-server/tap"
ESQUEMA = "gaiadr3"
ESQUEMA_PROYECTO = "proyecto"

# Productos DataLink: no son tablas consultables por ADQL; se piden por source_id.
DATALINK = {
    "EPOCH_PHOTOMETRY": "epoch_photometry",
    "XP_CONTINUOUS": "xp_continuous_mean_spectrum",
    "XP_SAMPLED": "xp_sampled_mean_spectrum",
    "RVS": "rvs_mean_spectrum",
    "MCMC_GSPPHOT": "mcmc_samples_gsp_phot",
    "MCMC_MSC": "mcmc_samples_msc",
}
CARPETA_DATALINK = {
    "epoch_photometry": "Photometry", "xp_continuous_mean_spectrum": "Spectroscopy",
    "xp_sampled_mean_spectrum": "Spectroscopy", "rvs_mean_spectrum": "Spectroscopy",
    "mcmc_samples_gsp_phot": "Astrophysical_parameters", "mcmc_samples_msc": "Astrophysical_parameters",
}

CATEGORIAS_ES = {
    "gaia_source": "Catálogo principal",
    "Astrophysical_parameters": "Parámetros astrofísicos",
    "Cross-match": "Cruce con catálogos externos",
    "Extra-galactic": "Extragaláctico",
    "Non-single_stars": "Estrellas no simples (binarias)",
    "Performance_verification": "Verificación de rendimiento",
    "Photometry": "Fotometría por época",
    "Reference_frame": "Marco de referencia",
    "Science_alerts": "Alertas científicas",
    "Solar_system": "Sistema solar",
    "Spectroscopy": "Espectroscopía",
    "Variability": "Variabilidad",
    "Simulation": "Simulación",
    "Auxiliary": "Auxiliar",
}

# Tipo -> (PostgreSQL, SQLite)
TIPOS = {
    "boolean": ("boolean", "INTEGER"), "bool": ("boolean", "INTEGER"),
    "short": ("smallint", "INTEGER"), "int8": ("smallint", "INTEGER"), "int16": ("smallint", "INTEGER"),
    "int": ("integer", "INTEGER"), "int32": ("integer", "INTEGER"),
    "long": ("bigint", "INTEGER"), "int64": ("bigint", "INTEGER"),
    "float": ("real", "REAL"), "float32": ("real", "REAL"),
    "double": ("double precision", "REAL"), "float64": ("double precision", "REAL"),
    "char": ("text", "TEXT"), "string": ("text", "TEXT"),
}

# ---------------------------------------------------------------- SPHEREx (IRSA, NASA/IPAC)
IRSA_TAP = "https://irsa.ipac.caltech.edu/TAP"
IRSA_SIA = "https://irsa.ipac.caltech.edu/SIA"
IRSA_IBE = "https://irsa.ipac.caltech.edu/ibe/data/spherex/"
S3_BUCKET = "nasa-irsa-spherex"
ESQUEMA_SPHEREX = "spherex"
COLECCIONES_SPHEREX = ["spherex_dr1", "spherex_dr1_deep", "spherex_qr3", "spherex_qr3_deep", "spherex_dr1_cube"]

CATEGORIAS_ES.update({
    "SPHEREx_TAP": "SPHEREx: tablas TAP de IRSA",
    "SPHEREx_local": "SPHEREx: resultados de API guardados localmente",
    "Proyecto": "Integración Gaia DR3 + SPHEREx",
})

# Tablas propias v2: (esquema, tabla, categoría, acceso, descripción, [(columna, tipo, unidad, descripción)])
TABLAS_V2 = [
    (ESQUEMA_SPHEREX, "imagenes", "SPHEREx_local", "SIA2 IRSA (spherex_api.py imagenes)",
     "Imágenes espectrales SPHEREx encontradas con SIA2 (una fila por imagen/detector). No guarda los píxeles, "
     "solo metadatos y las URLs para descargarlas o recortarlas.", [
        ("obs_publisher_did", "char", "", "Identificador IVOA único de la imagen (ivo://irsa.ipac/<colección>?<obs_id>/D<detector>)"),
        ("obs_id", "char", "", "Observation ID: periodo de planeación + contador de giro grande + giro pequeño"),
        ("obs_collection", "char", "", "Colección SIA2: spherex_dr1, spherex_dr1_deep, spherex_qr3, spherex_qr3_deep, spherex_dr1_cube"),
        ("energy_bandpassname", "char", "", "Detector/banda (SPHEREx-D1 ... SPHEREx-D6)"),
        ("dataproduct_type", "char", "", "Tipo de producto (image, cube)"),
        ("calib_level", "short", "", "Nivel de calibración ObsCore (2 = imagen calibrada, 3 = cubo)"),
        ("s_ra", "double", "deg", "AR del centro de la imagen (ICRS)"),
        ("s_dec", "double", "deg", "Dec del centro de la imagen (ICRS)"),
        ("s_fov", "double", "deg", "Campo de visión"),
        ("s_region", "char", "deg", "Polígono que cubre la imagen en el cielo (ICRS)"),
        ("s_pixel_scale", "double", "arcsec", "Tamaño de píxel"),
        ("em_min", "double", "m", "Longitud de onda mínima cubierta por la imagen"),
        ("em_max", "double", "m", "Longitud de onda máxima cubierta por la imagen"),
        ("em_res_power", "double", "", "Poder de resolución espectral R"),
        ("t_min", "double", "d", "Inicio de la exposición (MJD)"),
        ("t_max", "double", "d", "Fin de la exposición (MJD)"),
        ("t_exptime", "double", "s", "Tiempo de exposición"),
        ("target_name", "char", "", "Campo SPHEREx"),
        ("obs_release_date", "char", "", "Fecha de publicación"),
        ("access_url", "char", "", "URL HTTPS de la imagen completa en IRSA (acepta ?center=ra,dec&size=grados para recortes)"),
        ("access_estsize", "long", "kbyte", "Tamaño estimado de la descarga"),
        ("cloud_access", "char", "", "JSON con bucket y key de la copia en AWS S3"),
    ]),
    (ESQUEMA_SPHEREX, "recortes", "SPHEREx_local", "IBE Cutouts IRSA (spherex_api.py recorte)",
     "Recortes FITS (MEF con IMAGE, FLAGS, VARIANCE, ZODI, EPSF, WCS-WAVE) descargados localmente.", [
        ("obs_publisher_did", "char", "", "Imagen de origen (spherex.imagenes.obs_publisher_did)"),
        ("obs_id", "char", "", "Observation ID"),
        ("energy_bandpassname", "char", "", "Detector/banda"),
        ("ra", "double", "deg", "AR del centro del recorte"),
        ("dec", "double", "deg", "Dec del centro del recorte"),
        ("tamano_deg", "double", "deg", "Lado del recorte"),
        ("url_recorte", "char", "", "URL usada para pedir el recorte"),
        ("archivo", "char", "", "Ruta local del FITS"),
        ("bytes", "long", "byte", "Tamaño del archivo"),
    ]),
    (ESQUEMA_PROYECTO, "espectro_spherex", "Proyecto", "Calculado (spherex_api.py espectro)",
     "Espectro infrarrojo SPHEREx (0.75-5 µm) de fuentes Gaia: una fila por fuente y por imagen donde aparece. "
     "Fotometría de apertura sobre los píxeles leídos directamente de S3. Enlaza con gaiadr3.* por source_id.", [
        ("source_id", "long", "", "Identificador Gaia DR3 (NULL si se dio una posición manual)"),
        ("obs_publisher_did", "char", "", "Imagen SPHEREx usada (spherex.imagenes)"),
        ("obs_collection", "char", "", "Colección SPHEREx"),
        ("detector", "short", "", "Detector 1-6 (1-3 SWIR, 4-6 MWIR)"),
        ("mjd", "double", "d", "Fecha media de la exposición (MJD-AVG)"),
        ("ra_epoca", "double", "deg", "AR de la fuente propagada a la fecha de la imagen con el movimiento propio de Gaia"),
        ("dec_epoca", "double", "deg", "Dec de la fuente propagada a la fecha de la imagen"),
        ("x_pix", "double", "pix", "Posición X en la imagen (0-based)"),
        ("y_pix", "double", "pix", "Posición Y en la imagen (0-based)"),
        ("longitud_onda_um", "double", "um", "Longitud de onda central en la posición de la fuente (WCS-WAVE)"),
        ("ancho_banda_um", "double", "um", "Ancho de banda en la posición de la fuente"),
        ("flujo_ujy", "double", "uJy", "Flujo en apertura menos fondo local (incluye corrección de zodiacal vía anillo)"),
        ("error_flujo_ujy", "double", "uJy", "Error del flujo a partir de la extensión VARIANCE"),
        ("brillo_pico_mjy_sr", "double", "MJy/sr", "Brillo superficial del píxel central"),
        ("fondo_mjy_sr", "double", "MJy/sr", "Mediana del anillo de fondo"),
        ("zodi_mjy_sr", "double", "MJy/sr", "Modelo de luz zodiacal en el píxel central"),
        ("radio_apertura_pix", "double", "pix", "Radio de la apertura"),
        ("flags", "long", "", "OR de los bits FLAGS dentro de la apertura (definición en la cabecera FLAGS: MSKN/MSKM)"),
        ("flag_malo", "boolean", "", "True si algún píxel de la apertura tiene un bit grave (transitorio, saturación, no funcional, caliente/frío, no lineal, persistencia, outlier, faltante)"),
    ]),
]
