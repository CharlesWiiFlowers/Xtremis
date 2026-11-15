"""Pruebas locales del cliente MAST Gaia; no hacen llamadas de red."""
from __future__ import annotations

import unittest
from unittest.mock import patch

from app import upstream


class FakeResponse:
    def __init__(self, status_code=200, content=b"<VOTABLE/>", content_type="application/x-votable+xml"):
        self.status_code = status_code
        self.content = content
        self.text = content.decode("utf-8", "replace")
        self.headers = {"Content-Type": content_type}
        self.ok = 200 <= status_code < 400


class FakeSession:
    def __init__(self, response):
        self.response = response
        self.calls = []

    def post(self, url, *, data, timeout):
        self.calls.append({"url": url, "data": data, "timeout": timeout})
        return self.response


class GaiaMastTests(unittest.TestCase):
    def test_query_uses_mast_gaia_catalog_and_icrs_geometry(self):
        response = FakeResponse()
        session = FakeSession(response)
        catalog_rows = [{
            "source_id": 123456789,
            "ra": 12.5,
            "dec": -4.0,
            "parallax": 10.0,
            "phot_bp_mean_mag": 11.0,
            "phot_rp_mean_mag": 10.0,
            "bp_rp": None,
            "phot_g_mean_mag": 10.5,
            "teff_gspphot": 5100.0,
            "logg_gspphot": 4.4,
            "mh_gspphot": -0.1,
        }]

        with patch.object(upstream, "_preflight") as preflight, \
             patch.object(upstream, "_http_session", return_value=session), \
             patch.object(upstream, "_read_table", return_value=catalog_rows):
            rows = upstream.query_gaia(12.5, -4.0, 0.03, limit=7, provider="mast", max_mag=18)

        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0]["source_id"], 123456789)
        self.assertEqual(rows[0]["distance_pc"], 100.0)
        self.assertAlmostEqual(rows[0]["bp_rp"], 1.0)
        self.assertEqual(rows[0]["teff"], 5100.0)
        self.assertEqual(rows[0]["logg"], 4.4)
        self.assertEqual(rows[0]["metallicity"], -0.1)
        self.assertEqual(rows[0]["provider"], "mast")

        self.assertEqual(len(session.calls), 1)
        call = session.calls[0]
        self.assertEqual(call["url"], "https://mast.stsci.edu/vo-tap/api/v0.1/gaiadr3/sync")
        self.assertEqual(call["data"]["REQUEST"], "doQuery")
        self.assertEqual(call["data"]["LANG"], "ADQL")
        self.assertEqual(call["data"]["FORMAT"], "votable")
        self.assertEqual(call["timeout"], (4, 18))
        adql = call["data"]["QUERY"]
        self.assertEqual(upstream.MAST_GAIA_TABLE, "dbo.gaia_source")
        self.assertIn("SELECT TOP 7", adql)
        self.assertIn("FROM dbo.gaia_source", adql)
        self.assertIn("POINT('ICRS', ra, dec)", adql)
        self.assertIn("CIRCLE('ICRS', 12.50000000, -4.00000000, 0.030000)", adql)
        self.assertNotIn("POINT(ra, dec)", adql)
        self.assertNotIn("CIRCLE(12.50000000", adql)
        preflight.assert_called_once_with("https://mast.stsci.edu/vo-tap/api/v0.1/gaiadr3/sync")

    def test_400_body_preserves_mast_query_error(self):
        xml = b'''<?xml version="1.0"?>
        <VOTABLE><RESOURCE><INFO name="QUERY_STATUS" value="ERROR">
        Unknown geometry function signature: POINT expects 2 arguments.
        </INFO></RESOURCE></VOTABLE>'''
        response = FakeResponse(status_code=400, content=xml)
        session = FakeSession(response)

        with patch.object(upstream, "_preflight"), \
             patch.object(upstream, "_http_session", return_value=session):
            with self.assertRaisesRegex(RuntimeError, "HTTP 400.*POINT expects 2 arguments"):
                upstream._tap_sync_rows(upstream.GAIA_MAST_TAP, "SELECT TOP 1 source_id FROM dbo.gaia_source")

    def test_error_body_html_is_sanitized(self):
        class HtmlResponse:
            text = "<html><body><h1>Bad Request</h1><p>Invalid ADQL expression</p></body></html>"
            content = text.encode()

        detail = upstream._tap_error_detail(HtmlResponse())
        self.assertIn("Bad Request", detail)
        self.assertIn("Invalid ADQL expression", detail)
        self.assertNotIn("<html>", detail)

    def test_legacy_or_invalid_table_setting_is_normalized(self):
        self.assertEqual(upstream._resolve_mast_gaia_table("gaiadr3.gaia_source"), "dbo.gaia_source")
        self.assertEqual(upstream._resolve_mast_gaia_table(""), "dbo.gaia_source")
        self.assertEqual(upstream._resolve_mast_gaia_table("unsafe; DROP TABLE x"), "dbo.gaia_source")
        self.assertEqual(upstream._resolve_mast_gaia_table("dbo.gaia_source"), "dbo.gaia_source")

    def test_table_limit_is_clamped(self):
        response = FakeResponse()
        session = FakeSession(response)
        with patch.object(upstream, "_preflight"), \
             patch.object(upstream, "_http_session", return_value=session), \
             patch.object(upstream, "_read_table", return_value=[]):
            upstream.query_gaia(370, 15, 0.03, limit=9999)
        self.assertIn("SELECT TOP 1000", session.calls[0]["data"]["QUERY"])
        self.assertIn("CIRCLE('ICRS', 10.00000000, 15.00000000, 0.030000)", session.calls[0]["data"]["QUERY"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
