"""Descarga los metadatos oficiales de Gaia DR3 (no descarga datos de estrellas).

- data/tap_tables.csv, data/tap_columns.csv: tablas y columnas del esquema gaiadr3 del Archivo Gaia (TAP).
- data/cabeceras_datalink/*.ecsv: definición de columnas de los productos DataLink (espectros, curvas de luz, MCMC).
- data/tamanos_cdn.json: número de archivos y bytes por tabla en el repositorio de descarga masiva.
"""
import json
import re
import urllib.parse
import urllib.request
import zlib

from comun import DATA, DATALINK, TAP_URL

LISTADO = "https://gaia.eu-1.cdn77-storage.com/"


def tap(consulta, destino):
    datos = urllib.parse.urlencode({"REQUEST": "doQuery", "LANG": "ADQL", "FORMAT": "csv",
                                    "MAXREC": "1000000", "QUERY": consulta}).encode()
    (DATA / destino).write_bytes(urllib.request.urlopen(TAP_URL + "/sync", datos, timeout=300).read())


def listar_cdn(prefijo):
    archivos, marcador = [], ""
    while True:
        url = f"{LISTADO}?prefix={prefijo}" + ("&marker=" + urllib.parse.quote(marcador) if marcador else "")
        xml = urllib.request.urlopen(url, timeout=60).read().decode()
        fs = [(k, int(s)) for k, s in re.findall(r"<Key>([^<]*)</Key>.*?<Size>(\d+)</Size>", xml, re.S)]
        archivos += fs
        if "<IsTruncated>true" not in xml:
            return archivos
        marcador = fs[-1][0]


def cabecera_ecsv(url):
    paso, inicio, texto = 1 << 20, 0, ""
    dec = zlib.decompressobj(16 + zlib.MAX_WBITS)
    while True:
        req = urllib.request.Request(url, headers={"Range": f"bytes={inicio}-{inicio + paso - 1}"})
        crudo = urllib.request.urlopen(req, timeout=120).read()
        texto += dec.decompress(crudo).decode(errors="replace")
        lineas = texto.split("\n")
        if any(not l.startswith("#") for l in lineas[:-1]) or len(crudo) < paso:
            return "\n".join(l for l in lineas if l.startswith("#")) + "\n"
        inicio += paso


if __name__ == "__main__":
    tap("SELECT * FROM tap_schema.tables WHERE schema_name='gaiadr3'", "tap_tables.csv")
    tap("SELECT * FROM tap_schema.columns WHERE table_name LIKE 'gaiadr3.%'", "tap_columns.csv")
    print("metadatos TAP actualizados")

    tamanos = {}
    for k, s in listar_cdn("Gaia/gdr3/"):
        if k.endswith(".csv.gz"):
            carpeta = k.rsplit("/", 1)[0] + "/"
            t = tamanos.setdefault(carpeta.rstrip("/").split("/")[-1], {"carpeta": carpeta, "archivos": 0, "bytes": 0})
            t["archivos"] += 1
            t["bytes"] += s
    (DATA / "tamanos_cdn.json").write_text(json.dumps(tamanos, indent=1))
    print(f"tamaños CDN: {len(tamanos)} tablas")

    (DATA / "cabeceras_datalink").mkdir(exist_ok=True)
    for tabla in DATALINK.values():
        primero = min(k for k, _ in listar_cdn(tamanos[tabla]["carpeta"]) if k.endswith(".csv.gz"))
        (DATA / "cabeceras_datalink" / f"{tabla}.ecsv").write_text(cabecera_ecsv("https://cdn.gea.esac.esa.int/" + primero))
        print("cabecera", tabla)
