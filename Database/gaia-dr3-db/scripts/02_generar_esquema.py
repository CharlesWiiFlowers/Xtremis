"""Genera el esquema SQL (PostgreSQL y SQLite), el catálogo de tablas y el diccionario de columnas.

Entradas: data/tap_tables.csv, data/tap_columns.csv, data/cabeceras_datalink/*.ecsv, data/tamanos_cdn.json
Salidas:  sql/01_esquema_postgres.sql, sql/01_esquema_sqlite.sql, sql/02_metadatos_postgres.sql,
          sql/02_metadatos_sqlite.sql, docs/catalogo_tablas.{csv,md}, docs/diccionario_columnas.csv,
          docs/gaia_dr3_v1.xlsx
"""
import csv
import json

import pandas as pd
import yaml

from comun import (CARPETA_DATALINK, CATEGORIAS_ES, DATA, DATALINK, DOCS, ESQUEMA, SQL, TIPOS)

DATALINK_INV = {v: k for k, v in DATALINK.items()}


def categoria(tabla, carpeta_cdn):
    if carpeta_cdn:
        partes = carpeta_cdn.strip("/").split("/")
        return partes[2] if len(partes) > 3 else "gaia_source"
    if tabla in CARPETA_DATALINK:
        return CARPETA_DATALINK[tabla]
    if tabla in ("gaia_source_lite",):
        return "gaia_source"
    if tabla in ("gaia_source_simulation", "gaia_universe_model"):
        return "Simulation"
    if tabla == "commanded_scan_law":
        return "Auxiliary"
    if tabla in ("agn_cross_id", "frame_rotator_source"):
        return "Reference_frame"
    if tabla.startswith("science_alert"):
        return "Science_alerts"
    return "Cross-match"


def limpiar(texto):
    return " ".join(str(texto if texto is not None and texto == texto else "").split())


def leer_tap():
    tablas = {}
    for r in csv.DictReader(open(DATA / "tap_tables.csv")):
        tablas[r["table_name"].split(".", 1)[1]] = {"descripcion": limpiar(r["description"]),
                                                     "filas": int(r["size"]) if r["size"] else None,
                                                     "acceso": "TAP (ADQL)", "columnas": []}
    for r in sorted(csv.DictReader(open(DATA / "tap_columns.csv")), key=lambda r: int(r["column_index"] or 0)):
        base = r["datatype"]
        arreglo = r["arraysize"] == "*" and base != "char"
        tablas[r["table_name"].split(".", 1)[1]]["columnas"].append({
            "columna": r["column_name"], "tipo_origen": base + ("[]" if arreglo else ""),
            "base": base, "arreglo": arreglo, "unidad": limpiar(r["unit"]), "ucd": limpiar(r["ucd"]),
            "descripcion": limpiar(r["description"]), "indexada_en_archivo": r["indexed"] == "1"})
    return tablas


def leer_datalink(tablas):
    for tabla in DATALINK.values():
        lineas = (DATA / "cabeceras_datalink" / f"{tabla}.ecsv").read_text().split("\n")
        meta = yaml.safe_load("\n".join(l[2:] if l.startswith("# ") else l[1:]
                                        for l in lineas if l.startswith("#") and not l.startswith("# %ECSV")))
        info = dict(meta["meta"])
        cols = []
        for c in meta["datatype"]:
            sub = c.get("subtype")
            base = sub.split("[")[0] if sub else c["datatype"]
            cols.append({"columna": c["name"], "tipo_origen": base + ("[]" if sub else ""), "base": base,
                         "arreglo": bool(sub), "unidad": limpiar(c.get("unit")),
                         "ucd": limpiar((c.get("meta") or {}).get("ucd")),
                         "descripcion": limpiar(c.get("description")), "indexada_en_archivo": False})
        tablas[tabla] = {"descripcion": limpiar(info.get("DESCRIPTION")), "filas": None,
                         "acceso": f"DataLink ({DATALINK_INV[tabla]})", "columnas": cols}


def tipo(col, dialecto):
    pg, lite = TIPOS[col["base"]]
    if col["arreglo"]:
        return pg + "[]" if dialecto == "pg" else "TEXT"
    return pg if dialecto == "pg" else lite


def lit(texto):
    return "'" + limpiar(texto).replace("'", "''") + "'"


def main():
    tablas = leer_tap()
    leer_datalink(tablas)
    tamanos = json.loads((DATA / "tamanos_cdn.json").read_text())
    # En el CDN la tabla se llama science_alert; en el archivo, science_alerts.
    tamanos["science_alerts"] = tamanos.pop("science_alert")

    catalogo, diccionario = [], []
    for nombre, t in tablas.items():
        cdn = tamanos.get(nombre, {})
        cat = categoria(nombre, cdn.get("carpeta"))
        catalogo.append({
            "categoria": cat, "categoria_es": CATEGORIAS_ES[cat], "tabla": nombre, "acceso": t["acceso"],
            "descripcion": t["descripcion"], "columnas": len(t["columnas"]), "filas_gaia_dr3": t["filas"],
            "gb_comprimido_cdn": round(cdn["bytes"] / 1e9, 3) if cdn else None,
            "url_cdn": "https://cdn.gea.esac.esa.int/?prefix=" + cdn["carpeta"] if cdn else
            "(solo en el Archivo Gaia; bulk en https://cdn.gea.esac.esa.int/?prefix=Gaia/gedr3/)",
        })
        for i, c in enumerate(t["columnas"], 1):
            diccionario.append({"tabla": nombre, "posicion": i, "columna": c["columna"],
                                "tipo_origen": c["tipo_origen"], "tipo_postgres": tipo(c, "pg"),
                                "tipo_sqlite": tipo(c, "lite"), "unidad": c["unidad"], "ucd": c["ucd"],
                                "indexada_en_archivo": c["indexada_en_archivo"], "descripcion": c["descripcion"]})
    catalogo.sort(key=lambda f: (list(CATEGORIAS_ES).index(f["categoria"]), f["tabla"]))

    pg = ["-- Esquema Gaia DR3 v1 para PostgreSQL. Generado por scripts/02_generar_esquema.py",
          f"CREATE SCHEMA IF NOT EXISTS {ESQUEMA};", "CREATE SCHEMA IF NOT EXISTS proyecto;", ""]
    lite = ["-- Esquema Gaia DR3 v1 para SQLite (arreglos guardados como texto JSON, booleanos como 0/1).",
            "-- Generado por scripts/02_generar_esquema.py", ""]
    for f in catalogo:
        n, t = f["tabla"], tablas[f["tabla"]]
        cabecera = f"-- [{f['categoria_es']}] {n} — acceso: {f['acceso']}"
        pg += [cabecera, f"CREATE TABLE IF NOT EXISTS {ESQUEMA}.{n} (",
               ",\n".join(f"    {c['columna']} {tipo(c, 'pg')}" for c in t["columnas"]), ");",
               f"COMMENT ON TABLE {ESQUEMA}.{n} IS {lit(t['descripcion'])};"]
        for c in t["columnas"]:
            comentario = c["descripcion"] + (f" [{c['unidad']}]" if c["unidad"] else "")
            pg.append(f"COMMENT ON COLUMN {ESQUEMA}.{n}.{c['columna']} IS {lit(comentario)};")
        if any(c["columna"] == "source_id" for c in t["columnas"]):
            pg.append(f"CREATE INDEX IF NOT EXISTS {n}_source_id_idx ON {ESQUEMA}.{n} (source_id);")
            lite_idx = f"CREATE INDEX IF NOT EXISTS {n}_source_id_idx ON {n} (source_id);"
        else:
            lite_idx = None
        pg.append("")
        lite += [cabecera, f"CREATE TABLE IF NOT EXISTS {n} (",
                 ",\n".join(f"    {c['columna']} {tipo(c, 'lite')}" for c in t["columnas"]), ");"]
        lite += [lite_idx, ""] if lite_idx else [""]

    SQL.mkdir(exist_ok=True)
    DOCS.mkdir(exist_ok=True)
    (SQL / "01_esquema_postgres.sql").write_text("\n".join(pg) + "\n")
    (SQL / "01_esquema_sqlite.sql").write_text("\n".join(lite) + "\n")

    for archivo, filas in (("catalogo_tablas.csv", catalogo), ("diccionario_columnas.csv", diccionario)):
        with open(DOCS / archivo, "w", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=list(filas[0]))
            w.writeheader()
            w.writerows(filas)
    escribir_metadatos_sql(catalogo, diccionario)
    escribir_markdown(catalogo)
    with pd.ExcelWriter(DOCS / "gaia_dr3_v1.xlsx", engine="openpyxl") as xw:
        pd.DataFrame(catalogo).to_excel(xw, sheet_name="catalogo_tablas", index=False)
        pd.DataFrame(diccionario).to_excel(xw, sheet_name="diccionario_columnas", index=False)
        for hoja in xw.sheets.values():
            hoja.freeze_panes = "A2"
            hoja.auto_filter.ref = hoja.dimensions
    print(f"{len(catalogo)} tablas, {len(diccionario)} columnas")


def valor_sql(v, dialecto):
    if v is None:
        return "NULL"
    if isinstance(v, bool):
        return ("true" if v else "false") if dialecto == "pg" else str(int(v))
    if isinstance(v, (int, float)):
        return str(v)
    return lit(v)


def escribir_metadatos_sql(catalogo, diccionario):
    tipos_cat = {"columnas": "integer", "filas_gaia_dr3": "bigint", "gb_comprimido_cdn": "numeric"}
    tipos_dic = {"posicion": "integer", "indexada_en_archivo": "boolean"}
    for dialecto, prefijo, archivo in (("pg", "meta.", "02_metadatos_postgres.sql"),
                                       ("lite", "meta_", "02_metadatos_sqlite.sql")):
        out = ["-- Catálogo de tablas y diccionario de columnas Gaia DR3 (consultables con SQL)."]
        if dialecto == "pg":
            out.append("CREATE SCHEMA IF NOT EXISTS meta;")
        for nombre, filas, tipos, pk in (("catalogo_tablas", catalogo, tipos_cat, "tabla"),
                                         ("diccionario_columnas", diccionario, tipos_dic, "tabla, columna")):
            cols = list(filas[0])
            defs = ", ".join(f"{c} {tipos.get(c, 'text')}" for c in cols)
            out += [f"DROP TABLE IF EXISTS {prefijo}{nombre};",
                    f"CREATE TABLE {prefijo}{nombre} ({defs}, PRIMARY KEY ({pk}));", "BEGIN;"]
            out += [f"INSERT INTO {prefijo}{nombre} VALUES (" + ", ".join(valor_sql(f[c], dialecto) for c in cols) + ");"
                    for f in filas]
            out.append("COMMIT;")
        (SQL / archivo).write_text("\n".join(out) + "\n")


def escribir_markdown(catalogo):
    md = ["# Catálogo de tablas Gaia DR3", "",
          "Generado por `scripts/02_generar_esquema.py`. **Acceso**: `TAP (ADQL)` = se consulta con SQL/ADQL "
          "en el Archivo Gaia; `DataLink (TIPO)` = se pide por `source_id` con `gaia_api.py datalink --tipos TIPO`.", ""]
    actual = None
    for f in catalogo:
        if f["categoria"] != actual:
            actual = f["categoria"]
            md += ["", f"## {f['categoria_es']} (`{actual}`)", "",
                   "| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |",
                   "|---|---|---:|---:|---:|---|"]
        desc = f["descripcion"].replace("|", "/")
        desc = desc[:180] + ("…" if len(desc) > 180 else "")
        filas = f"{f['filas_gaia_dr3']:,}" if f["filas_gaia_dr3"] is not None else "—"
        gb = f["gb_comprimido_cdn"] if f["gb_comprimido_cdn"] is not None else "—"
        md.append(f"| `{f['tabla']}` | {f['acceso']} | {f['columnas']} | {filas} | {gb} | {desc} |")
    (DOCS / "catalogo_tablas.md").write_text("\n".join(md) + "\n")


if __name__ == "__main__":
    main()
