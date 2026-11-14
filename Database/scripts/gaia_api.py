"""Consulta Gaia DR3 por API (Archivo Gaia de la ESA) y guarda el resultado en archivo o base de datos local.

Ejemplos:
  # Consulta ADQL -> PostgreSQL (si las columnas pertenecen a gaiadr3.gaia_source se insertan ahí)
  python3 gaia_api.py adql "SELECT TOP 1000 source_id, ra, dec, parallax FROM gaiadr3.gaia_source" \
      --db postgresql:///gaia_dr3

  # Consulta con columnas calculadas -> tabla propia (proyecto.brillantes)
  python3 gaia_api.py adql --archivo ../sql/ejemplos_adql/02_cono_pleyades.sql --db sqlite:///gaia.db --tabla brillantes

  # Espectros / curvas de luz (DataLink) de fuentes concretas
  python3 gaia_api.py datalink --ids 233786241137174272 --tipos EPOCH_PHOTOMETRY XP_SAMPLED --db postgresql:///gaia_dr3

  # Solo guardar a archivo
  python3 gaia_api.py adql "SELECT TOP 10 * FROM gaiadr3.vari_cepheid" --salida cefeidas.csv

Credenciales opcionales (cuenta gratuita del Archivo Gaia, más cuota): variables GAIA_USUARIO y GAIA_CONTRASENA.
"""
import argparse
import csv
import io
import json
import math
import os
import re
import sqlite3
import sys
from pathlib import Path
from urllib.parse import urlparse

import numpy as np
from astropy.table import vstack

sys.path.insert(0, str(Path(__file__).resolve().parent))
from comun import DATALINK, ESQUEMA, ESQUEMA_PROYECTO  # noqa: E402

TIPOS_NUMPY = {"b": ("boolean", "INTEGER"), "i1": ("smallint", "INTEGER"), "i2": ("smallint", "INTEGER"),
               "u1": ("smallint", "INTEGER"), "i4": ("integer", "INTEGER"), "u2": ("integer", "INTEGER"),
               "i8": ("bigint", "INTEGER"), "u4": ("bigint", "INTEGER"), "f4": ("real", "REAL"),
               "f8": ("double precision", "REAL")}


def gaia():
    from astroquery.gaia import Gaia
    if os.environ.get("GAIA_USUARIO"):
        Gaia.login(user=os.environ["GAIA_USUARIO"], password=os.environ["GAIA_CONTRASENA"])
    return Gaia


# ---------------------------------------------------------------- obtención de datos
def ejecutar_adql(consulta):
    print("Consultando el Archivo Gaia...", file=sys.stderr)
    tabla = gaia().launch_job_async(consulta).get_results()
    print(f"{len(tabla)} filas recibidas", file=sys.stderr)
    return tabla


def leer_ids(args):
    ids = list(args.ids or [])
    if args.ids_archivo:
        ids += [int(x) for x in re.findall(r"\d+", Path(args.ids_archivo).read_text())]
    if args.ids_adql:
        ids += [int(x) for x in ejecutar_adql(args.ids_adql)["source_id"]]
    if not ids:
        sys.exit("Indica --ids, --ids-archivo o --ids-adql")
    return list(dict.fromkeys(ids))


def descargar_datalink(ids, tipos, lote):
    g = gaia()
    resultados = {DATALINK[t]: [] for t in tipos}
    tipo_api = "ALL" if len(tipos) == len(DATALINK) else None
    for i in range(0, len(ids), lote):
        parte = ids[i:i + lote]
        print(f"DataLink: fuentes {i + 1}-{i + len(parte)} de {len(ids)}", file=sys.stderr)
        for t in ([tipo_api] if tipo_api else tipos):
            datos = g.load_data(ids=parte, data_release="Gaia DR3", retrieval_type=t,
                                data_structure="DATAMODEL_GAIA", format="votable")
            for clave, elementos in datos.items():
                producto = next((p for p in DATALINK if clave.startswith(p + "_")), None)
                if producto is None or DATALINK[producto] not in resultados:
                    continue
                for e in elementos:
                    resultados[DATALINK[producto]].append(e.to_table() if hasattr(e, "to_table") else e)
    return {n: vstack(ts, metadata_conflicts="silent") for n, ts in resultados.items() if ts}


# ---------------------------------------------------------------- conversión de valores
def a_python(v):
    if v is None or v is np.ma.masked:
        return None
    if isinstance(v, np.ma.MaskedArray):
        v = v.filled(np.nan) if v.dtype.kind == "f" else v.data
    if isinstance(v, np.ndarray):
        return [a_python(x) for x in v.tolist()]
    if isinstance(v, np.generic):
        return v.item()
    if isinstance(v, bytes):
        return v.decode()
    return v


def filas(tabla):
    cols = tabla.colnames
    for fila in tabla:
        yield [a_python(fila[c]) for c in cols]


def literal_pg(v):
    if v is None:
        return r"\N"
    if isinstance(v, bool):
        return "t" if v else "f"
    if isinstance(v, list):
        return "{" + ",".join("NULL" if x is None else ("t" if x is True else "f" if x is False else str(x))
                              for x in v) + "}"
    if isinstance(v, float) and math.isnan(v):
        return "NaN"
    return str(v)


def literal_sqlite(v):
    if isinstance(v, list):
        return json.dumps([None if isinstance(x, float) and math.isnan(x) else x for x in v])
    if isinstance(v, bool):
        return int(v)
    if isinstance(v, float) and math.isnan(v):
        return None
    return v


def tipo_columna(col, dialecto):
    i = 0 if dialecto == "pg" else 1
    if col.dtype.kind == "O":
        muestra = next((a_python(x) for x in col if x is not None and x is not np.ma.masked), None)
        if isinstance(muestra, list):
            e = next((x for x in muestra if x is not None), 0.0)
            base = "boolean" if isinstance(e, bool) else "bigint" if isinstance(e, int) else "double precision"
            return base + "[]" if dialecto == "pg" else "TEXT"
        return "text" if dialecto == "pg" else "TEXT"
    clave = "b" if col.dtype.kind == "b" else f"{col.dtype.kind}{col.dtype.itemsize}"
    return TIPOS_NUMPY.get(clave, ("text", "TEXT"))[i]


# ---------------------------------------------------------------- destino
class Destino:
    def __init__(self, url):
        u = urlparse(url)
        self.dialecto = "pg" if u.scheme.startswith("postgres") else "sqlite" if u.scheme == "sqlite" else None
        if self.dialecto == "pg":
            import psycopg2
            self.conn = psycopg2.connect(url)
        elif self.dialecto == "sqlite":
            self.conn = sqlite3.connect(url[len("sqlite:///"):])
        else:
            sys.exit("--db debe empezar con postgresql:// o sqlite:///")

    def nombre(self, esquema, tabla):
        if self.dialecto == "pg":
            return f"{esquema}.{tabla}"
        return tabla if esquema == ESQUEMA else f"{esquema}_{tabla}"

    def columnas(self, esquema, tabla):
        cur = self.conn.cursor()
        if self.dialecto == "pg":
            cur.execute("SELECT column_name FROM information_schema.columns WHERE table_schema=%s AND table_name=%s",
                        (esquema, tabla))
            return {r[0] for r in cur.fetchall()}
        return {r[1] for r in cur.execute(f"PRAGMA table_info({self.nombre(esquema, tabla)})")}

    def crear(self, esquema, tabla, datos):
        defs = ", ".join(f"{c} {tipo_columna(datos[c], self.dialecto)}" for c in datos.colnames)
        cur = self.conn.cursor()
        if self.dialecto == "pg":
            cur.execute(f"CREATE SCHEMA IF NOT EXISTS {esquema}")
        cur.execute(f"CREATE TABLE IF NOT EXISTS {self.nombre(esquema, tabla)} ({defs})")

    def insertar(self, esquema, tabla, datos, reemplazar):
        destino = self.nombre(esquema, tabla)
        cur = self.conn.cursor()
        if reemplazar:
            cur.execute(f"DELETE FROM {destino}")
        cols = ", ".join(datos.colnames)
        if self.dialecto == "pg":
            buf = io.StringIO()
            w = csv.writer(buf)
            for f in filas(datos):
                w.writerow([literal_pg(v) for v in f])
            buf.seek(0)
            cur.copy_expert(f"COPY {destino} ({cols}) FROM STDIN WITH (FORMAT csv, NULL '\\N')", buf)
        else:
            marcas = ", ".join("?" * len(datos.colnames))
            cur.executemany(f"INSERT INTO {destino} ({cols}) VALUES ({marcas})",
                            ([literal_sqlite(v) for v in f] for f in filas(datos)))
        self.conn.commit()
        print(f"{len(datos)} filas guardadas en {destino}", file=sys.stderr)

    def guardar(self, datos, tabla_gaia=None, tabla_propia=None, reemplazar=False, esquema_origen=ESQUEMA):
        cols = set(datos.colnames)
        if tabla_propia:
            esquema, _, tabla = tabla_propia.rpartition(".")
            esquema = esquema or ESQUEMA_PROYECTO
            if not self.columnas(esquema, tabla):
                self.crear(esquema, tabla, datos)
        elif tabla_gaia and cols <= self.columnas(esquema_origen, tabla_gaia):
            esquema, tabla = esquema_origen, tabla_gaia
        else:
            sys.exit(f"Las columnas no coinciden con una tabla {esquema_origen} local (¿cargaste sql/01_esquema_*.sql?). "
                     "Usa --tabla NOMBRE para guardarlas en una tabla propia.")
        self.insertar(esquema, tabla, datos, reemplazar)


def guardar_archivo(datos, ruta, sufijo=""):
    ruta = Path(ruta)
    if sufijo:
        ruta = ruta.with_name(f"{ruta.stem}_{sufijo}{ruta.suffix}")
    copia = datos.copy()
    for c in copia.colnames:
        if copia[c].dtype.kind == "O":
            copia[c] = [json.dumps(a_python(v)) if v is not None and v is not np.ma.masked else "" for v in copia[c]]
    if ruta.suffix == ".parquet":
        copia.to_pandas().to_parquet(ruta, index=False)
    else:
        copia.write(ruta, overwrite=True, format="ascii.ecsv" if ruta.suffix == ".ecsv" else "ascii.csv")
    print(f"{len(datos)} filas guardadas en {ruta}", file=sys.stderr)


# ---------------------------------------------------------------- CLI
def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="comando", required=True)

    a = sub.add_parser("adql", help="ejecuta una consulta ADQL en el Archivo Gaia")
    a.add_argument("consulta", nargs="?")
    a.add_argument("--archivo", help="archivo .sql con la consulta ADQL")

    d = sub.add_parser("datalink", help="descarga espectros, curvas de luz o muestras MCMC por source_id")
    d.add_argument("--ids", nargs="*", type=int)
    d.add_argument("--ids-archivo", help="archivo de texto con un source_id por línea")
    d.add_argument("--ids-adql", help="consulta ADQL que devuelve una columna source_id")
    d.add_argument("--tipos", nargs="*", choices=list(DATALINK), default=list(DATALINK))
    d.add_argument("--lote", type=int, default=50, help="fuentes por petición (anónimo: máx. 50; con cuenta: 5000)")

    for p in (a, d):
        p.add_argument("--db", help="postgresql://usuario@host/base  o  sqlite:///ruta/archivo.db")
        p.add_argument("--tabla", help="tabla propia de destino (por defecto la tabla gaiadr3 equivalente)")
        p.add_argument("--reemplazar", action="store_true", help="vacía la tabla de destino antes de insertar")
        p.add_argument("--salida", help="archivo .csv, .ecsv o .parquet")
    args = ap.parse_args()
    if not (args.db or args.salida):
        ap.error("indica --db y/o --salida")

    destino = Destino(args.db) if args.db else None
    if args.comando == "adql":
        consulta = Path(args.archivo).read_text() if args.archivo else args.consulta
        if not consulta:
            ap.error("falta la consulta ADQL")
        datos = ejecutar_adql(consulta)
        froms = set(re.findall(r"\bgaiadr3\.(\w+)", consulta, re.I))
        if args.salida:
            guardar_archivo(datos, args.salida)
        if destino:
            destino.guardar(datos, froms.pop().lower() if len(froms) == 1 else None, args.tabla, args.reemplazar)
    else:
        for tabla, datos in descargar_datalink(leer_ids(args), args.tipos, args.lote).items():
            if args.salida:
                guardar_archivo(datos, args.salida, tabla)
            if destino:
                destino.guardar(datos, tabla, f"{args.tabla}_{tabla}" if args.tabla else None, args.reemplazar)


if __name__ == "__main__":
    main()
