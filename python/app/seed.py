"""Carga catalog/api_catalog.json en la tabla api_services.  Uso: python -m app.seed"""
import json
import os
import pathlib

from .db import upsert_many

# En Docker se monta en /catalog (CATALOG_PATH); en local se usa ../catalog
CATALOG = pathlib.Path(os.getenv("CATALOG_PATH") or
                       pathlib.Path(__file__).resolve().parents[2] / "catalog" / "api_catalog.json")

if __name__ == "__main__":
    items = json.loads(CATALOG.read_text(encoding="utf-8"))
    cols = ["slug", "mission", "provider", "protocol", "category", "upstream_url",
            "internal_route", "description", "verified", "source_doc"]
    rows = [{c: (int(i[c]) if c == "verified" else i.get(c)) for c in cols} for i in items]
    print(f"{upsert_many('api_services', rows)} servicios cargados")
