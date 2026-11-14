"""Consulta SPHEREx (NASA/IPAC IRSA + AWS Open Data) y lo integra con Gaia DR3 en la base local.

Comandos:
  imagenes  Busca imágenes espectrales con SIA2 (posición, colección, longitud de onda, fechas).
  tap       Ejecuta ADQL en el TAP de IRSA (spherex.obscore, spherex.plane, splices, gaia.gaia_dr3_source...).
  recorte   Descarga recortes FITS pequeños (cutouts) en vez de imágenes completas de ~70 MB.
  espectro  Extrae el espectro SPHEREx (0.75-5 µm) de fuentes Gaia leyendo solo los píxeles necesarios de S3.
  s3        Lista o descarga archivos del bucket público s3://nasa-irsa-spherex (sin cuenta AWS).

Ejemplos:
  python3 spherex_api.py imagenes --ra 56.75 --dec 24.12 --radio 0.05 --colecciones spherex_qr3 --db postgresql:///gaia_spherex_v2
  python3 spherex_api.py tap "SELECT TOP 10 * FROM spherex.plane" --salida planos.csv
  python3 spherex_api.py recorte --ra 56.75 --dec 24.12 --tamano 0.02 --max 6 --dir recortes --db sqlite:///gaia.db
  python3 spherex_api.py espectro --ids 65207709611941376 --db postgresql:///gaia_spherex_v2 --salida espectro.csv
  python3 spherex_api.py s3 ls dr1/
  python3 spherex_api.py s3 get qr3/spectral_channels/cal-sch-v2-2026-229/spectral_channels_spx_cal-sch-v2-2026-229.fits --dir cal
"""
import argparse
import json
import re
import sys
import time
import urllib.error
import urllib.request
import warnings
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import numpy as np
from astropy import log
from astropy.table import Table, unique, vstack

sys.path.insert(0, str(Path(__file__).resolve().parent))
from comun import (COLECCIONES_SPHEREX, ESQUEMA_PROYECTO, ESQUEMA_SPHEREX, IRSA_SIA, IRSA_TAP,  # noqa: E402
                   S3_BUCKET, TABLAS_V2)
from gaia_api import Destino, ejecutar_adql, guardar_archivo  # noqa: E402

log.setLevel("ERROR")
warnings.simplefilter("ignore")

COLUMNAS_IMAGENES = [c[0] for c in next(t for t in TABLAS_V2 if t[1] == "imagenes")[5]]
COLUMNAS_RECORTES = [c[0] for c in next(t for t in TABLAS_V2 if t[1] == "recortes")[5]]
OMEGA_PIXEL_SR = (6.15 / 206264.806) ** 2          # píxel nominal SPHEREx de 6.15"
MJD_J2016 = 57388.5                                 # época de referencia de Gaia DR3
BITS_GRAVES = sum(1 << b for b in (0, 1, 2, 6, 9, 10, 11, 15, 17, 19))


# ---------------------------------------------------------------- SIA2 / TAP
def buscar_imagenes(ra, dec, radio, colecciones, banda=None, tiempo=None, maxrec=None):
    from pyvo.dal.sia2 import SIA2Service
    sia = SIA2Service(IRSA_SIA)
    partes = []
    for c in colecciones:
        kw = {"pos": (ra, dec, radio), "collection": c}
        if banda:
            kw["band"] = tuple(banda)
        if tiempo:
            from astropy.time import Time
            kw["time"] = tuple(Time(t, format="mjd") for t in tiempo)
        if maxrec:
            kw["maxrec"] = maxrec
        t = sia.search(**kw).to_table()
        if len(t):
            partes.append(t[[c for c in COLUMNAS_IMAGENES if c in t.colnames]])
    if not partes:
        return Table(names=COLUMNAS_IMAGENES)
    res = vstack(partes, metadata_conflicts="silent")
    for c in res.colnames:
        if res[c].dtype.kind in "OSU":
            res[c] = [str(v) if v is not None and v is not np.ma.masked else None for v in res[c]]
    return res


def ejecutar_tap_irsa(consulta, asincrono):
    import pyvo
    servicio = pyvo.dal.TAPService(IRSA_TAP)
    print("Consultando el TAP de IRSA...", file=sys.stderr)
    r = servicio.run_async(consulta) if asincrono else servicio.run_sync(consulta)
    t = r.to_table()
    print(f"{len(t)} filas recibidas", file=sys.stderr)
    return t


# ---------------------------------------------------------------- fotometría sobre píxeles en S3
def abrir_fits(img):
    from astropy.io import fits
    try:
        nube = json.loads(img["cloud_access"])["aws"]
        return fits.open(f"s3://{nube['bucket_name']}/{nube['key']}", use_fsspec=True,
                         fsspec_kwargs={"anon": True, "default_block_size": 2 ** 16})
    except (TypeError, KeyError, ValueError):
        return fits.open(img["access_url"], use_fsspec=True, fsspec_kwargs={"block_size": 2 ** 16})


def fotometria(img, fuentes, r_ap, r_in, r_out):
    from astropy.wcs import WCS
    filas = []
    with abrir_fits(img) as h:
        cab = h["IMAGE"].header
        wcs, wcs_onda = WCS(cab), WCS(cab, key="W", fobj=h)
        mjd = cab.get("MJD-AVG") or (img["t_min"] + img["t_max"]) / 2
        ny, nx = cab["NAXIS2"], cab["NAXIS1"]
        mitad = int(np.ceil(r_out)) + 1
        for f in fuentes:
            dt = (mjd - MJD_J2016) / 365.25
            pmra = f["pmra"] if f["pmra"] == f["pmra"] else 0.0
            pmdec = f["pmdec"] if f["pmdec"] == f["pmdec"] else 0.0
            dec = f["dec"] + pmdec * dt / 3.6e6
            ra = f["ra"] + pmra * dt / 3.6e6 / np.cos(np.radians(f["dec"]))
            x, y = (float(v) for v in wcs.world_to_pixel_values(ra, dec))
            xi, yi = int(round(x)), int(round(y))
            if not (mitad <= xi < nx - mitad and mitad <= yi < ny - mitad):
                continue
            s = np.s_[yi - mitad:yi + mitad + 1, xi - mitad:xi + mitad + 1]
            im = h["IMAGE"].section[s].astype(float)
            var = h["VARIANCE"].section[s].astype(float)
            flg = h["FLAGS"].section[s].astype(np.int64)
            zod = h["ZODI"].section[s].astype(float)
            yy, xx = np.mgrid[yi - mitad:yi + mitad + 1, xi - mitad:xi + mitad + 1]
            d = np.hypot(xx - x, yy - y)
            ap, anillo = d <= r_ap, (d >= r_in) & (d <= r_out) & np.isfinite(im)
            fondo = float(np.nanmedian(im[anillo])) if anillo.any() else 0.0
            neto = np.nansum(im[ap] - fondo)
            error = np.sqrt(np.nansum(var[ap]) + ap.sum() ** 2 * np.nanvar(im[anillo]) / max(anillo.sum(), 1))
            onda, banda = (float(v) for v in wcs_onda.pixel_to_world_values(x, y))
            bits = int(np.bitwise_or.reduce(flg[ap]))
            filas.append({
                "source_id": f["source_id"], "obs_publisher_did": img["obs_publisher_did"],
                "obs_collection": img["obs_collection"], "detector": int(cab.get("DETECTOR", 0)), "mjd": mjd,
                "ra_epoca": ra, "dec_epoca": dec, "x_pix": x, "y_pix": y,
                "longitud_onda_um": onda, "ancho_banda_um": banda,
                "flujo_ujy": neto * OMEGA_PIXEL_SR * 1e12, "error_flujo_ujy": error * OMEGA_PIXEL_SR * 1e12,
                "brillo_pico_mjy_sr": float(im[mitad, mitad]), "fondo_mjy_sr": fondo,
                "zodi_mjy_sr": float(zod[mitad, mitad]), "radio_apertura_pix": r_ap,
                "flags": bits, "flag_malo": bool(bits & BITS_GRAVES)})
    return filas


def fuentes_gaia(args):
    if args.ra is not None:
        return [{"source_id": None, "ra": args.ra, "dec": args.dec, "pmra": 0.0, "pmdec": 0.0}]
    ids = list(args.ids or [])
    if args.ids_adql:
        ids += [int(x) for x in ejecutar_adql(args.ids_adql)["source_id"]]
    if not ids:
        sys.exit("Indica --ids, --ids-adql o --ra/--dec")
    lista = ",".join(str(i) for i in dict.fromkeys(ids))
    t = ejecutar_adql(f"SELECT source_id, ra, dec, pmra, pmdec FROM gaiadr3.gaia_source WHERE source_id IN ({lista})")
    return [{c: (None if t[c][i] is np.ma.masked else t[c][i].item()) for c in t.colnames} for i in range(len(t))]


def espectro(args):
    fuentes = fuentes_gaia(args)
    imagenes, por_imagen, tablas = {}, {}, []
    for f in fuentes:
        t = buscar_imagenes(f["ra"], f["dec"], 0.0005, args.colecciones)
        tablas.append(t)
        print(f"source_id {f['source_id']}: {len(t)} imágenes SPHEREx", file=sys.stderr)
        for img in t:
            did = img["obs_publisher_did"]
            imagenes[did] = img
            por_imagen.setdefault(did, []).append(f)
    if args.max_imagenes:
        por_imagen = dict(list(por_imagen.items())[:args.max_imagenes])
    filas, errores = [], 0
    with ThreadPoolExecutor(args.hilos) as pool:
        trabajos = {pool.submit(fotometria, imagenes[d], fs, args.apertura, args.anillo[0], args.anillo[1]): d
                    for d, fs in por_imagen.items()}
        for i, tr in enumerate(as_completed(trabajos), 1):
            try:
                filas += tr.result()
            except Exception as e:  # una imagen dañada o caída de red no detiene el resto
                errores += 1
                print(f"  error en {trabajos[tr]}: {e}", file=sys.stderr)
            if i % 25 == 0 or i == len(trabajos):
                print(f"  {i}/{len(trabajos)} imágenes procesadas", file=sys.stderr)
    columnas = [c[0] for c in next(t for t in TABLAS_V2 if t[1] == "espectro_spherex")[5]]
    tabla = Table(rows=[[f[c] for c in columnas] for f in filas], names=columnas) if filas else Table(names=columnas)
    if len(tabla):
        tabla.sort(["source_id", "longitud_onda_um"] if fuentes[0]["source_id"] else ["longitud_onda_um"])
    print(f"{len(tabla)} mediciones espectrales ({errores} imágenes con error)", file=sys.stderr)
    usadas = vstack([t for t in tablas if len(t)], metadata_conflicts="silent") if imagenes else None
    if usadas is not None:
        usadas = unique(usadas, keys="obs_publisher_did")
        usadas = usadas[[d in por_imagen for d in usadas["obs_publisher_did"]]]
    return tabla, usadas


# ---------------------------------------------------------------- recortes
def descargar(url, intentos=5):
    """GET con reintentos: el servicio de recortes de IRSA responde 503 de forma intermitente."""
    for i in range(intentos):
        try:
            return urllib.request.urlopen(url, timeout=300).read()
        except urllib.error.HTTPError as e:
            if e.code not in (429, 500, 502, 503, 504) or i == intentos - 1:
                raise
            time.sleep(2 * (i + 1))


def recortes(args):
    if args.url:
        imgs = Table(rows=[[args.url, args.url, "", ""]], names=["access_url", "obs_publisher_did", "obs_id",
                                                                   "energy_bandpassname"])
    else:
        imgs = buscar_imagenes(args.ra, args.dec, 0.0005, args.colecciones)
        if args.max:
            imgs = imgs[:args.max]
    carpeta = Path(args.dir)
    carpeta.mkdir(parents=True, exist_ok=True)
    filas = []
    for img in imgs:
        url = f"{img['access_url']}?center={args.ra},{args.dec}&size={args.tamano}"
        nombre = carpeta / (Path(str(img["access_url"]).split("?")[0]).stem + f"_cut_{args.ra:.5f}_{args.dec:+.5f}.fits")
        datos = descargar(url)
        nombre.write_bytes(datos)
        filas.append([img["obs_publisher_did"], img["obs_id"], img["energy_bandpassname"], args.ra, args.dec,
                      args.tamano, url, str(nombre), len(datos)])
        print(f"  {nombre} ({len(datos) / 1e6:.1f} MB)", file=sys.stderr)
    return Table(rows=filas, names=COLUMNAS_RECORTES) if filas else Table(names=COLUMNAS_RECORTES)


# ---------------------------------------------------------------- S3
def s3(args):
    import s3fs
    fs = s3fs.S3FileSystem(anon=True)
    ruta = f"{S3_BUCKET}/{args.ruta.lstrip('/')}"
    if args.accion == "ls":
        for e in fs.ls(ruta, detail=True):
            tam = f"{e['size'] / 1e6:10.1f} MB" if e["type"] == "file" else "   (carpeta)"
            print(f"{tam}  s3://{e['name']}")
    else:
        destino = Path(args.dir) / Path(ruta).name
        destino.parent.mkdir(parents=True, exist_ok=True)
        fs.get(ruta, str(destino))
        print(f"descargado {destino} ({destino.stat().st_size / 1e6:.1f} MB)", file=sys.stderr)


# ---------------------------------------------------------------- CLI
def sin_repetidos(destino, datos, esquema, tabla, llave="obs_publisher_did"):
    """Quita filas cuya llave ya está en la tabla local (para no duplicar imágenes al repetir búsquedas)."""
    if not len(datos) or llave not in datos.colnames or llave not in destino.columnas(esquema, tabla):
        return datos
    cur = destino.conn.cursor()
    cur.execute(f"SELECT {llave} FROM {destino.nombre(esquema, tabla)}")
    ya = {r[0] for r in cur.fetchall()}
    return datos[[str(v) not in ya for v in datos[llave]]]


def salida(args, datos, tabla_local, esquema):
    if args.salida:
        guardar_archivo(datos, args.salida)
    if args.db and len(datos):
        destino = Destino(args.db)
        if tabla_local == "imagenes" and not args.tabla and not args.reemplazar:
            datos = sin_repetidos(destino, datos, esquema, tabla_local)
        destino.guardar(datos, tabla_local, args.tabla, args.reemplazar, esquema_origen=esquema)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="comando", required=True)

    i = sub.add_parser("imagenes", help="busca imágenes SPHEREx con SIA2")
    i.add_argument("--ra", type=float, required=True)
    i.add_argument("--dec", type=float, required=True)
    i.add_argument("--radio", type=float, default=0.01, help="grados (default 0.01)")
    i.add_argument("--banda", type=float, nargs=2, metavar=("MIN_M", "MAX_M"), help="longitud de onda en metros")
    i.add_argument("--tiempo", type=float, nargs=2, metavar=("MJD_INI", "MJD_FIN"))
    i.add_argument("--maxrec", type=int)

    t = sub.add_parser("tap", help="consulta ADQL en el TAP de IRSA")
    t.add_argument("consulta", nargs="?")
    t.add_argument("--archivo")
    t.add_argument("--sync", action="store_true", help="consulta síncrona (rápida, para resultados pequeños)")

    r = sub.add_parser("recorte", help="descarga recortes FITS de imágenes SPHEREx")
    r.add_argument("--ra", type=float, required=True)
    r.add_argument("--dec", type=float, required=True)
    r.add_argument("--tamano", type=float, default=0.02, help="lado en grados (default 0.02 = 72\")")
    r.add_argument("--url", help="recortar una imagen concreta (access_url)")
    r.add_argument("--max", type=int, help="máximo de recortes")
    r.add_argument("--dir", default="recortes")

    e = sub.add_parser("espectro", help="espectro SPHEREx de fuentes Gaia (fotometría de apertura)")
    e.add_argument("--ids", nargs="*", type=int, help="source_id de Gaia DR3")
    e.add_argument("--ids-adql", help="consulta ADQL a Gaia que devuelve source_id")
    e.add_argument("--ra", type=float, help="posición manual (sin source_id)")
    e.add_argument("--dec", type=float)
    e.add_argument("--apertura", type=float, default=2.0, help="radio en píxeles (default 2)")
    e.add_argument("--anillo", type=float, nargs=2, default=[4.0, 7.0], help="radios del anillo de fondo en píxeles")
    e.add_argument("--hilos", type=int, default=8)
    e.add_argument("--max-imagenes", type=int, help="limita el número de imágenes (pruebas)")

    for p, defecto in ((i, ["spherex_dr1", "spherex_qr3"]), (r, ["spherex_dr1", "spherex_qr3"]),
                       (e, ["spherex_dr1", "spherex_qr3"])):
        p.add_argument("--colecciones", nargs="*", choices=COLECCIONES_SPHEREX, default=defecto)
    for p in (i, t, r, e):
        p.add_argument("--db", help="postgresql://usuario@host/base  o  sqlite:///ruta/archivo.db")
        p.add_argument("--tabla", help="tabla propia de destino (esquema proyecto)")
        p.add_argument("--reemplazar", action="store_true")
        p.add_argument("--salida", help="archivo .csv, .ecsv o .parquet")

    s = sub.add_parser("s3", help="lista o descarga archivos del bucket público")
    s.add_argument("accion", choices=["ls", "get"])
    s.add_argument("ruta", nargs="?", default="")
    s.add_argument("--dir", default=".")
    args = ap.parse_args()

    if args.comando == "s3":
        return s3(args)
    if not (args.db or args.salida):
        ap.error("indica --db y/o --salida")
    if args.comando == "imagenes":
        datos = buscar_imagenes(args.ra, args.dec, args.radio, args.colecciones, args.banda, args.tiempo, args.maxrec)
        print(f"{len(datos)} imágenes encontradas", file=sys.stderr)
        salida(args, datos, "imagenes", ESQUEMA_SPHEREX)
    elif args.comando == "tap":
        consulta = Path(args.archivo).read_text() if args.archivo else args.consulta
        if not consulta:
            ap.error("falta la consulta ADQL")
        datos = ejecutar_tap_irsa(consulta, not args.sync)
        m = set(re.findall(r"\bspherex\.(\w+)", consulta, re.I)) or set(re.findall(r"\bFROM\s+(splices)\b", consulta, re.I))
        salida(args, datos, m.pop().lower() if len(m) == 1 else None, ESQUEMA_SPHEREX)
    elif args.comando == "recorte":
        if args.ra is None:
            ap.error("faltan --ra/--dec")
        salida(args, recortes(args), "recortes", ESQUEMA_SPHEREX)
    else:
        datos, imagenes = espectro(args)
        if args.db and imagenes is not None and len(imagenes):
            destino = Destino(args.db)
            nuevas = sin_repetidos(destino, imagenes, ESQUEMA_SPHEREX, "imagenes")
            if len(nuevas):
                destino.guardar(nuevas, "imagenes", None, False, esquema_origen=ESQUEMA_SPHEREX)
        salida(args, datos, "espectro_spherex", ESQUEMA_PROYECTO)


if __name__ == "__main__":
    main()
