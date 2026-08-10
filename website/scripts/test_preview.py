#!/usr/bin/env python3
"""Integration tests for authenticated preview headers."""

from __future__ import annotations

import base64
import os
import socket
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import ProxyHandler, Request, build_opener


ROOT = Path(__file__).resolve().parents[2]


def free_port() -> int:
    with socket.socket() as sock:
        sock.bind(("127.0.0.1", 0))
        return int(sock.getsockname()[1])


class PreviewTest(unittest.TestCase):
    def test_basic_auth_and_security_headers(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "index.html").write_text("QuantumComputinglib preview", encoding="utf-8")
            port = free_port()
            env = {
                **os.environ,
                "ASPBE_PREVIEW_USERNAME": "reviewer",
                "ASPBE_PREVIEW_PASSWORD": "test-only-secret",
            }
            process = subprocess.Popen(
                [
                    sys.executable,
                    str(ROOT / "website" / "scripts" / "serve_preview.py"),
                    "--root",
                    str(root),
                    "--port",
                    str(port),
                ],
                cwd=ROOT,
                env=env,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            try:
                url = f"http://127.0.0.1:{port}/"
                opener = build_opener(ProxyHandler({}))
                for _ in range(50):
                    try:
                        opener.open(url, timeout=0.2)
                    except HTTPError as error:
                        if error.code == 401:
                            break
                    except OSError:
                        time.sleep(0.05)
                else:
                    self.fail("preview server did not become ready")

                with self.assertRaises(HTTPError) as unauthorized:
                    opener.open(url, timeout=2)
                self.assertEqual(unauthorized.exception.code, 401)
                self.assertEqual(
                    unauthorized.exception.headers["Cache-Control"], "no-store"
                )

                token = base64.b64encode(
                    b"reviewer:test-only-secret"
                ).decode("ascii")
                request = Request(url, headers={"Authorization": f"Basic {token}"})
                with opener.open(request, timeout=2) as response:
                    self.assertEqual(response.status, 200)
                    self.assertEqual(response.headers["Cache-Control"], "no-store")
                    self.assertEqual(response.headers["X-Frame-Options"], "DENY")
                    self.assertIn(b"QuantumComputinglib preview", response.read())
            finally:
                process.terminate()
                process.wait(timeout=5)


if __name__ == "__main__":
    unittest.main()
