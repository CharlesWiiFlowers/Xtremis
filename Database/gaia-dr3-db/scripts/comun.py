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
