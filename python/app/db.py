import os
import pymysql
from dotenv import load_dotenv

load_dotenv()


def get_conn():
    return pymysql.connect(
        host=os.getenv("MYSQL_HOST", "127.0.0.1"),
        port=int(os.getenv("MYSQL_PORT", "3306")),
        user=os.getenv("MYSQL_USER", "astro"),
        password=os.getenv("MYSQL_PASSWORD", ""),
        database=os.getenv("MYSQL_DATABASE", "astro"),
        charset="utf8mb4",
        autocommit=True,
        cursorclass=pymysql.cursors.DictCursor,
    )


def upsert_many(table: str, rows: list[dict]) -> int:
    """INSERT ... ON DUPLICATE KEY UPDATE para una lista de dicts con las mismas claves."""
    if not rows:
        return 0
    cols = list(rows[0].keys())
    col_sql = ", ".join(f"`{c}`" for c in cols)
    ph = ", ".join(["%s"] * len(cols))
    upd = ", ".join(f"`{c}`=VALUES(`{c}`)" for c in cols)
    sql = f"INSERT INTO `{table}` ({col_sql}) VALUES ({ph}) ON DUPLICATE KEY UPDATE {upd}"
    with get_conn() as conn, conn.cursor() as cur:
        cur.executemany(sql, [tuple(r[c] for c in cols) for r in rows])
    return len(rows)


def log_ingest(mission, ra, dec, radius, n, provider=None):
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
            "INSERT INTO ingest_log (mission, ra, `dec`, radius_deg, rows_upserted, provider) "
            "VALUES (%s,%s,%s,%s,%s,%s)",
            (mission, ra, dec, radius, n, provider),
        )


def ensure_schema_updates():
    """Añade campos Gaia opcionales a instalaciones existentes, sin tocar los datos."""
    additions = {
        "phot_bp_mean_mag": "DOUBLE NULL", "phot_rp_mean_mag": "DOUBLE NULL",
        "logg": "DOUBLE NULL", "metallicity": "DOUBLE NULL", "ruwe": "DOUBLE NULL",
        "astrometric_excess_noise": "DOUBLE NULL",
    }
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute("SHOW COLUMNS FROM gaia_stars")
        existing = {row["Field"] for row in cur.fetchall()}
        for name, definition in additions.items():
            if name not in existing:
                cur.execute(f"ALTER TABLE gaia_stars ADD COLUMN `{name}` {definition}")
