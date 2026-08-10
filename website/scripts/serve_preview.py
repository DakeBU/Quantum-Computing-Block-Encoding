#!/usr/bin/env python3
"""Serve a private static preview with environment-only Basic Auth."""

from __future__ import annotations

import argparse
import base64
import hmac
import os
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


USERNAME_ENV = "ASPBE_PREVIEW_USERNAME"
PASSWORD_ENV = "ASPBE_PREVIEW_PASSWORD"
LEGACY_USERNAME_ENV = "ABEIS_PREVIEW_USERNAME"
LEGACY_PASSWORD_ENV = "ABEIS_PREVIEW_PASSWORD"


class PreviewHandler(SimpleHTTPRequestHandler):
    username = ""
    password = ""

    def expected_authorization(self) -> str:
        raw = f"{self.username}:{self.password}".encode("utf-8")
        return "Basic " + base64.b64encode(raw).decode("ascii")

    def authenticated(self) -> bool:
        supplied = self.headers.get("Authorization", "")
        return hmac.compare_digest(supplied, self.expected_authorization())

    def do_GET(self) -> None:
        if not self.authenticated():
            self.send_response(401)
            self.send_header("WWW-Authenticate", 'Basic realm="QuantumComputinglib preview"')
            self.end_headers()
            self.wfile.write(b"Authentication required.\n")
            return
        super().do_GET()

    def do_HEAD(self) -> None:
        if not self.authenticated():
            self.send_response(401)
            self.send_header("WWW-Authenticate", 'Basic realm="QuantumComputinglib preview"')
            self.end_headers()
            return
        super().do_HEAD()

    def end_headers(self) -> None:
        self.send_security_headers()
        super().end_headers()

    def send_security_headers(self) -> None:
        self.send_header("Cache-Control", "no-store")
        self.send_header("Pragma", "no-cache")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")
        self.send_header("Referrer-Policy", "no-referrer")
        self.send_header(
            "Content-Security-Policy",
            "default-src 'self'; "
            "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; "
            "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; "
            "font-src 'self' https://cdn.jsdelivr.net data:; "
            "img-src 'self' data:; connect-src 'self'; frame-ancestors 'none'",
        )

    def log_message(self, format: str, *args: object) -> None:
        # Never include headers or credentials; standard request path/status is enough.
        super().log_message(format, *args)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path("_site"))
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8765)
    args = parser.parse_args()
    username = os.environ.get(USERNAME_ENV) or os.environ.get(LEGACY_USERNAME_ENV)
    password = os.environ.get(PASSWORD_ENV) or os.environ.get(LEGACY_PASSWORD_ENV)
    if not username or not password:
        raise SystemExit(
            f"Set {USERNAME_ENV} and {PASSWORD_ENV}; credentials are never read from files."
        )
    root = args.root.resolve()
    if not (root / "index.html").is_file():
        raise SystemExit(f"Preview root has no index.html: {root}")

    PreviewHandler.username = username
    PreviewHandler.password = password
    handler = lambda *handler_args, **kwargs: PreviewHandler(  # noqa: E731
        *handler_args, directory=str(root), **kwargs
    )
    server = ThreadingHTTPServer((args.host, args.port), handler)
    print(f"Serving private QuantumComputinglib preview at http://{args.host}:{args.port}/")
    print("Authentication is required; credentials came from environment variables.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
