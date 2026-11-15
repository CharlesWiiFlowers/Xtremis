"""Clientes con límites estrictos para Gaia DR3, AllWISE y SPHEREx (IRSA/MAST)."""
from __future__ import annotations

import hashlib
import io
import math
import os
import socket
import threading
import time
import re
import html
import xml.etree.ElementTree as ET
from urllib.parse import urlencode, urlparse

import requests

IRSA_SCS = "https://irsa.ipac.caltech.edu/SCS"
IRSA_SIA = "https://irsa.ipac.caltech.edu/SIA"
GAIA_MAST_TAP = "https://mast.stsci.edu/vo-tap/api/v0.1/gaiadr3/"


def _resolve_mast_gaia_table(value: str | None = None) -> str:
    """Normaliza también el nombre de tabla erróneo usado en versiones previas."""
    configured = (os.getenv("MAST_GAIA_TABLE", "") if value is None else value).strip()
    if not configured or configured.lower() == "gaiadr3.gaia_source":
        return "dbo.gaia_source"
    if not re.fullmatch(r"[A-Za-z0-9_]+\.[A-Za-z0-9_]+", configured):
        return "dbo.gaia_source"
    return configured


MAST_GAIA_TABLE = _resolve_mast_gaia_table()
WISE_TABLE = os.getenv("WISE_TABLE", "allwise_p3as_psd")

_HTTP_LOCAL = threading.local()
_DNS_LOCK = threading.Lock()
_DNS_CACHE: dict[str, tuple[float, list[str]]] = {}


def _http_session():
    """Sesión por hilo; respeta proxies configurados en el entorno del usuario."""
    session = getattr(_HTTP_LOCAL, "session", None)
    if session is None:
        session = requests.Session()
        session.headers.update({
            "User-Agent": "ORBITAL-AstroDataStudio/2.1 (public MAST/IRSA archive client)",
            "Accept": "application/x-votable+xml,text/csv,*/*;q=0.8",
        })
        _HTTP_LOCAL.session = session
    return session


def _bounded_dns(host: str, timeout: float = 2.5) -> list[str]:
    """Resuelve DNS con límite propio (el timeout HTTP de requests no limita getaddrinfo)."""
    now = time.monotonic()
    with _DNS_LOCK:
        cached = _DNS_CACHE.get(host)
        if cached and cached[0] > now:
            return cached[1]

    done = threading.Event()
    outcome: dict = {}

    def resolve():
        try:
            info = socket.getaddrinfo(host, 443, type=socket.SOCK_STREAM)
            outcome["ips"] = list(dict.fromkeys(item[4][0] for item in info))
        except Exception as exc:  # noqa: BLE001 - se convierte a diagnóstico legible
            outcome["error"] = exc
        finally:
            done.set()

    threading.Thread(target=resolve, name=f"orbital-dns-{host}", daemon=True).start()
    if not done.wait(timeout):
        raise TimeoutError(f"DNS de {host} no respondió en {timeout:.1f} s. Revisa DNS/salida a internet de Docker.")
    if "error" in outcome:
        raise ConnectionError(f"No se pudo resolver {host}: {outcome['error']}") from outcome["error"]
    ips = outcome.get("ips") or []
    if not ips:
        raise ConnectionError(f"DNS de {host} no devolvió direcciones IP.")
    with _DNS_LOCK:
        _DNS_CACHE[host] = (time.monotonic() + 60, ips)
    return ips


def _preflight(url: str):
    host = urlparse(url).hostname
    if not host:
        raise ConnectionError(f"URL externa no válida: {url}")
    # Si el usuario usa un proxy HTTPS, DNS lo resolverá requests para el proxy.
    proxy = requests.utils.get_environ_proxies(url).get("https")
    dns_host = urlparse(proxy).hostname if proxy else host
    if not dns_host:
        raise ConnectionError(f"No se pudo identificar el host DNS de {url}.")
    ips = _bounded_dns(dns_host)
    return dns_host, ips


def _clean(v):
    """Convierte valores Astropy/numpy (masked, NaN) a tipos seguros para JSON."""
    try:
        if hasattr(v, "mask") and v.mask:
            return None
        v = v.item() if hasattr(v, "item") else v
    except Exception:
        return None
    if isinstance(v, float) and (math.isnan(v) or math.isinf(v)):
        return None
    if isinstance(v, bytes):
        return v.decode("utf-8", "ignore")
    return v


def _rows(result) -> list[dict]:
    names = list(result.colnames) if hasattr(result, "colnames") else list(result.fieldnames)
    return [{str(n): _clean(row[n]) for n in names} for row in result]


def _read_table(content: bytes, content_type: str = "") -> list[dict]:
    """Acepta CSV o VOTable según lo que realmente devuelva el archivo."""
    if not content.strip():
        return []
    # Astropy solo se importa al procesar una respuesta tabular; así los módulos
    # de API y las pruebas de construcción ADQL no requieren cargarlo al arrancar.
    from astropy.table import Table
    errors = []
    formats = (["votable", "ascii.csv"] if "xml" in content_type.lower() or b"VOTABLE" in content[:500].upper()
               else ["ascii.csv", "votable"])
    for fmt in formats:
        try:
            return _rows(Table.read(io.BytesIO(content), format=fmt))
        except Exception as exc:  # noqa: BLE001
            errors.append(f"{fmt}: {exc}")
    raise RuntimeError("No se pudo interpretar la tabla del archivo externo: " + " | ".join(errors))


def _tap_error_detail(response) -> str:
    """Extrae el error ADQL que MAST devuelve dentro del cuerpo XML/HTML."""
    body = getattr(response, "text", "") or ""
    if not body:
        content = getattr(response, "content", b"") or b""
        body = content.decode("utf-8", "replace")
    if not body.strip():
        return "MAST no incluyó detalles en el cuerpo de la respuesta."

    # En TAP los errores suelen venir como INFO QUERY_STATUS=ERROR en VOTable.
    try:
        root = ET.fromstring(body)
        for element in root.iter():
            tag = element.tag.rsplit("}", 1)[-1].upper()
            if tag == "INFO":
                name = str(element.attrib.get("name", "")).upper()
                value = str(element.attrib.get("value", "")).upper()
                if name == "QUERY_STATUS" and value == "ERROR":
                    detail = " ".join(" ".join(element.itertext()).split())
                    if detail:
                        return detail[:700]
            elif tag in {"ERROR", "MESSAGE"}:
                detail = " ".join(" ".join(element.itertext()).split())
                if detail:
                    return detail[:700]
    except ET.ParseError:
        pass

    # Algunos errores de infraestructura se devuelven como página HTML.
    plain = html.unescape(re.sub(r"<[^>]*>", " ", body))
    plain = " ".join(plain.split())
    return (plain or "MAST devolvió una respuesta vacía.")[:700]


def _tap_sync_rows(service_url: str, adql: str, timeout=(4, 18)) -> list[dict]:
    """TAP síncrono: para búsquedas cónicas pequeñas evita jobs async huérfanos/polling."""
    endpoint = service_url.rstrip("/") + "/sync"
    _preflight(endpoint)
    response = _http_session().post(
        endpoint,
        data={"REQUEST": "doQuery", "LANG": "ADQL", "FORMAT": "votable", "QUERY": adql},
        timeout=timeout,
    )
    if not response.ok:
        detail = _tap_error_detail(response)
        raise RuntimeError(f"MAST TAP respondió HTTP {response.status_code}: {detail}")
    return _read_table(response.content, response.headers.get("Content-Type", ""))


def equatorial_to_xyz(ra_deg: float, dec_deg: float, parallax_mas: float):
    """Posición cartesiana heliocéntrica en parsecs a partir de paralaje en mas."""
    distance = 1000.0 / parallax_mas
    ra, dec = math.radians(ra_deg), math.radians(dec_deg)
    return distance, distance * math.cos(dec) * math.cos(ra), distance * math.cos(dec) * math.sin(ra), distance * math.sin(dec)


def query_gaia(ra, dec, radius, limit=100, provider="mast", max_mag=18.0):
    ra, dec, radius = float(ra) % 360.0, float(dec), float(radius)
    limit = max(1, min(int(limit), 1000))
    radius = max(0.001, min(radius, 3.0))
    if provider != "mast":
        raise ValueError("El proveedor disponible para ORBITAL es MAST · Gaia DR3.")
    magnitude_filter = f"AND phot_g_mean_mag <= {float(max_mag)}" if max_mag is not None else ""
    # En el servicio Gaia DR3 específico de MAST la tabla publicada es dbo.gaia_source
    # (no gaiadr3.gaia_source, nombre común en otros archivos TAP). Los ejemplos
    # oficiales de este endpoint usan POINT/CIRCLE con el marco ICRS explícito.
    # Sin ORDER BY: TOP + círculo pequeño evita ordenar una región grande en TAP.
    adql = f"""
    SELECT TOP {limit}
        source_id, ra, dec, parallax, parallax_error, pmra, pmdec,
        phot_g_mean_mag, phot_bp_mean_mag, phot_rp_mean_mag, bp_rp,
        radial_velocity, teff_gspphot, logg_gspphot,
        mh_gspphot, ruwe, astrometric_excess_noise
    FROM {MAST_GAIA_TABLE}
    WHERE CONTAINS(
        POINT('ICRS', ra, dec),
        CIRCLE('ICRS', {ra:.8f}, {dec:.8f}, {radius:.6f})
    ) = 1
      {magnitude_filter}
    """
    rows = _tap_sync_rows(GAIA_MAST_TAP, adql, timeout=(4, 18))
    for row in rows:
        # Nombres de salida estables para el frontend y la persistencia.
        row.setdefault("teff", row.get("teff_gspphot"))
        row.setdefault("logg", row.get("logg_gspphot"))
        row.setdefault("metallicity", row.get("mh_gspphot"))
        bp, rp = row.get("phot_bp_mean_mag"), row.get("phot_rp_mean_mag")
        if row.get("bp_rp") is None and bp is not None and rp is not None:
            row["bp_rp"] = bp - rp
        parallax = row.get("parallax")
        if parallax is not None and parallax > 0.05 and row.get("ra") is not None and row.get("dec") is not None:
            distance, x, y, z = equatorial_to_xyz(row["ra"], row["dec"], parallax)
            row.update(distance_pc=distance, x_pc=x, y_pc=y, z_pc=z)
        else:
            row.update(distance_pc=None, x_pc=None, y_pc=None, z_pc=None)
        row["provider"] = provider
    return rows


def query_wise(ra, dec, radius, limit=100):
    """AllWISE vía SCS oficial de IRSA, con consulta de cono pequeña y timeout estricto."""
    ra, dec, radius = float(ra) % 360.0, float(dec), float(radius)
    limit = max(1, min(int(limit), 500))
    if radius > 1.0:
        raise ValueError("Para AllWISE utiliza un radio de 1° o menor.")
    _preflight(IRSA_SCS)
    params = {
        "table": WISE_TABLE,
        "RA": f"{ra:.8f}",
        "DEC": f"{dec:.8f}",
        "SR": f"{radius:.6f}",
        "FORMAT": "csv",
        "MAXREC": limit,
    }
    response = _http_session().get(IRSA_SCS, params=params, timeout=(4, 18))
    response.raise_for_status()
    rows = _read_table(response.content, response.headers.get("Content-Type", ""))[:limit]
    if rows and not {str(k).lower() for k in rows[0]}.issuperset({"ra", "dec"}):
        raise RuntimeError("IRSA SCS no devolvió las columnas RA y DEC de AllWISE.")
    output = []
    for row in rows:
        normalized = dict(row)
        for key, value in row.items():
            normalized.setdefault(str(key).lower(), value)
        normalized["catalog"] = WISE_TABLE
        output.append(normalized)
    return output


def query_spherex(ra, dec, limit=80, bandpass=None, radius=0.03):
    """SPHEREx SIA2: consulta DR1/QR3 wide por separado; evita sumar deep collections por defecto."""
    ra, dec, radius = float(ra) % 360.0, float(dec), float(radius)
    limit = max(1, min(int(limit), 200))
    radius = max(0.001, min(radius, 1.0))
    wanted = bandpass.strip() if bandpass else None
    # La documentación IRSA recomienda DR1 + QR3 para toda la cobertura wide.
    # Deep collections se omiten por defecto para mantener las búsquedas interactivas rápidas.
    collections = ("spherex_qr3", "spherex_dr1")
    per_collection = max(1, (limit + len(collections) - 1) // len(collections))
    output = []
    cutout_size = min(0.1, max(0.01, radius * 2.0))

    for collection in collections:
        _preflight(IRSA_SIA)
        params = {
            "COLLECTION": collection,
            "POS": f"circle {ra:.8f} {dec:.8f} {radius:.6f}",
            "MAXREC": per_collection,
        }
        response = _http_session().get(IRSA_SIA, params=params, timeout=(4, 12))
        response.raise_for_status()
        rows = _read_table(response.content, response.headers.get("Content-Type", ""))
        for row in rows:
            bp = row.get("energy_bandpassname")
            if wanted and str(bp or "") != wanted:
                continue
            access_uri = row.get("access_url")
            if not access_uri:
                continue
            cutout_params = urlencode({"center": f"{ra},{dec}", "size": cutout_size})
            uri = f"{access_uri}{'&' if '?' in access_uri else '?'}{cutout_params}"
            row.update({
                "uri": uri,
                "access_uri": access_uri,
                "plane_id": row.get("obs_id") or row.get("upload_row_id"),
                "bandpass": bp,
                "t_obs_mjd": row.get("t_min"),
                "query_ra": ra,
                "query_dec": dec,
                "uri_hash": hashlib.sha1(access_uri.encode()).hexdigest(),
                "catalog": collection,
            })
            output.append(row)

    def _mjd_sort_key(row):
        try:
            return (row.get("t_obs_mjd") is None, -float(row.get("t_obs_mjd") or 0))
        except (TypeError, ValueError):
            return (True, 0.0)
    output.sort(key=_mjd_sort_key)
    return output[:limit]


def _probe_url(url: str) -> dict:
    host = urlparse(url).hostname or "desconocido"
    started = time.monotonic()
    try:
        dns_host, ips = _preflight(url)
        response = _http_session().get(url, timeout=(3, 4), allow_redirects=True)
        # 4xx en una URL de capacidad sin parámetros sigue probando que HTTPS respondió.
        ok = response.status_code < 500
        return {"ok": ok, "host": host, "dns_host": dns_host, "dns": "ok", "https": response.status_code,
                "ips": ips[:3], "elapsed_ms": round((time.monotonic() - started) * 1000)}
    except Exception as exc:  # noqa: BLE001
        return {"ok": False, "host": host, "error": str(exc)[:240],
                "elapsed_ms": round((time.monotonic() - started) * 1000)}


def _probe_bounded(url: str, timeout: float = 8.0) -> dict:
    """No deja que una resolución DNS atascada bloquee el endpoint de diagnóstico."""
    done = threading.Event()
    result: dict = {}

    def run():
        result.update(_probe_url(url))
        done.set()

    threading.Thread(target=run, name="orbital-connectivity-probe", daemon=True).start()
    if not done.wait(timeout):
        host = urlparse(url).hostname or "desconocido"
        return {"ok": False, "host": host, "error": f"Sin respuesta en {timeout:.0f} s (DNS/HTTPS bloqueado)."}
    return result


def probe_connectivity() -> dict:
    """Comprueba que el contenedor puede resolver y abrir HTTPS hacia MAST e IRSA."""
    results: dict = {}
    threads = []
    targets = {
        "mast": "https://mast.stsci.edu/vo-tap/api/v0.1/gaiadr3/availability",
        "irsa": "https://irsa.ipac.caltech.edu/SIA?",
    }
    for name, url in targets.items():
        thread = threading.Thread(target=lambda n=name, u=url: results.update({n: _probe_bounded(u)}), daemon=True)
        thread.start()
        threads.append(thread)
    for thread in threads:
        thread.join(timeout=8.5)
    for name in targets:
        results.setdefault(name, {"ok": False, "error": "La prueba no terminó dentro del límite."})
    return {"ok": all(value.get("ok") for value in results.values()), "services": results}
