#!/usr/bin/env python3
"""Serve Quantumlib with loopback-only Lean and optional translation APIs."""

from __future__ import annotations

import argparse
import json
import shlex
import subprocess
import tempfile
import threading
import time
from functools import partial
from http import HTTPStatus
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlsplit


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_SITE = ROOT / "_site"
CACHE_ROOT = ROOT / "_out" / "workspace-cache"
MAX_BODY_BYTES = 200_000
EXECUTION_LOCK = threading.Lock()


def tool_version() -> str:
    try:
        result = subprocess.run(
            ["lake", "env", "lean", "--version"],
            cwd=ROOT,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=30,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        return f"Lean unavailable: {error}"
    return (result.stdout or result.stderr).strip().splitlines()[0]


class WorkspaceHandler(SimpleHTTPRequestHandler):
    server_version = "QuantumlibWorkspace/0.1"
    lean_version_text = "Lean version not checked"
    compile_timeout = 120
    translator_timeout = 180
    translator_command: list[str] | None = None

    def end_headers(self) -> None:
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("Referrer-Policy", "same-origin")
        self.send_header("X-Frame-Options", "DENY")
        super().end_headers()

    def send_json(self, status: int, payload: dict[str, object]) -> None:
        body = (json.dumps(payload, ensure_ascii=False) + "\n").encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def read_payload(self) -> dict[str, object] | None:
        try:
            length = int(self.headers.get("Content-Length", "0"))
        except ValueError:
            length = 0
        if length <= 0 or length > MAX_BODY_BYTES:
            self.send_json(
                HTTPStatus.REQUEST_ENTITY_TOO_LARGE,
                {"ok": False, "output": f"Request must be between 1 and {MAX_BODY_BYTES} bytes."},
            )
            return None
        try:
            value = json.loads(self.rfile.read(length).decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            self.send_json(
                HTTPStatus.BAD_REQUEST,
                {"ok": False, "output": "Request body is not valid UTF-8 JSON."},
            )
            return None
        if not isinstance(value, dict):
            self.send_json(
                HTTPStatus.BAD_REQUEST,
                {"ok": False, "output": "Request body must be a JSON object."},
            )
            return None
        return value

    def do_GET(self) -> None:  # noqa: N802
        if urlsplit(self.path).path == "/api/health":
            self.send_json(
                HTTPStatus.OK,
                {
                    "ok": True,
                    "mode": "loopback-local",
                    "lean_version": self.lean_version_text,
                    "translator_available": bool(self.translator_command),
                    "source_writes": False,
                },
            )
            return
        super().do_GET()

    def do_POST(self) -> None:  # noqa: N802
        endpoint = urlsplit(self.path).path
        if endpoint not in {"/api/compile", "/api/translate"}:
            self.send_json(HTTPStatus.NOT_FOUND, {"ok": False, "output": "Unknown API endpoint."})
            return
        payload = self.read_payload()
        if payload is None:
            return
        if not EXECUTION_LOCK.acquire(blocking=False):
            self.send_json(
                HTTPStatus.TOO_MANY_REQUESTS,
                {"ok": False, "output": "Another local workspace request is running."},
            )
            return
        try:
            if endpoint == "/api/compile":
                self.compile_snippet(payload)
            else:
                self.translate_statement(payload)
        finally:
            EXECUTION_LOCK.release()

    def compile_snippet(self, payload: dict[str, object]) -> None:
        code = payload.get("code")
        if not isinstance(code, str) or not code.strip():
            self.send_json(HTTPStatus.BAD_REQUEST, {"ok": False, "output": "`code` must be nonempty."})
            return
        started = time.perf_counter()
        CACHE_ROOT.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="lean-", dir=CACHE_ROOT) as temp_name:
            source = Path(temp_name) / "Main.lean"
            source.write_text(code, encoding="utf-8", newline="\n")
            try:
                result = subprocess.run(
                    ["lake", "env", "lean", str(source)],
                    cwd=ROOT,
                    capture_output=True,
                    text=True,
                    encoding="utf-8",
                    errors="replace",
                    timeout=self.compile_timeout,
                    check=False,
                )
                output = "\n".join(
                    part for part in (result.stdout.strip(), result.stderr.strip()) if part
                )
                output = output.replace(str(source), "Main.lean").replace(temp_name, "<temporary>")
                ok = result.returncode == 0
                if not output:
                    output = "Lean accepted the snippet." if ok else f"Lean exited with code {result.returncode}."
                status = HTTPStatus.OK
            except subprocess.TimeoutExpired:
                ok = False
                output = f"Lean compilation exceeded {self.compile_timeout} seconds."
                status = HTTPStatus.REQUEST_TIMEOUT
            except OSError as error:
                ok = False
                output = f"Could not start the pinned Lean toolchain: {error}"
                status = HTTPStatus.SERVICE_UNAVAILABLE
        self.send_json(
            status,
            {
                "ok": ok,
                "output": output,
                "duration_ms": round((time.perf_counter() - started) * 1000),
            },
        )

    def translate_statement(self, payload: dict[str, object]) -> None:
        latex = payload.get("latex")
        if not isinstance(latex, str) or not latex.strip():
            self.send_json(HTTPStatus.BAD_REQUEST, {"ok": False, "output": "`latex` must be nonempty."})
            return
        if not self.translator_command:
            self.send_json(
                HTTPStatus.SERVICE_UNAVAILABLE,
                {"ok": False, "output": "No local translator command is configured."},
            )
            return
        request = {
            "task": "Translate the mathematical statement into a reviewable Lean 4 draft for ASPBE.",
            "rules": [
                "Import QuantumBlockEncoding unless a narrower import is sufficient.",
                "Expose every assumption; do not replace the proposition with True.",
                "Return JSON with string fields code and plain.",
                "Compilation and human mathematical review remain separate gates.",
            ],
            "latex": latex,
            "reviewed_context": payload.get("reviewed_context"),
        }
        try:
            result = subprocess.run(
                self.translator_command,
                cwd=ROOT,
                input=json.dumps(request, ensure_ascii=False),
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                timeout=self.translator_timeout,
                check=False,
            )
        except subprocess.TimeoutExpired:
            self.send_json(HTTPStatus.REQUEST_TIMEOUT, {"ok": False, "output": "Local translation timed out."})
            return
        except OSError as error:
            self.send_json(HTTPStatus.SERVICE_UNAVAILABLE, {"ok": False, "output": f"Could not start translator: {error}"})
            return
        if result.returncode != 0:
            self.send_json(
                HTTPStatus.BAD_REQUEST,
                {"ok": False, "output": (result.stderr or result.stdout or "Translator failed.").strip()},
            )
            return
        try:
            response = json.loads(result.stdout)
        except json.JSONDecodeError:
            self.send_json(HTTPStatus.BAD_REQUEST, {"ok": False, "output": "Translator did not return JSON."})
            return
        code = response.get("code") if isinstance(response, dict) else None
        if not isinstance(code, str) or not code.strip():
            self.send_json(HTTPStatus.BAD_REQUEST, {"ok": False, "output": "Translator JSON has no nonempty `code` field."})
            return
        self.send_json(
            HTTPStatus.OK,
            {"ok": True, "code": code, "plain": str(response.get("plain", ""))},
        )

    def log_message(self, format: str, *args: object) -> None:
        # The access log receives request metadata only, never submitted source.
        super().log_message(format, *args)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8000)
    parser.add_argument("--directory", type=Path, default=DEFAULT_SITE)
    parser.add_argument("--compile-timeout", type=int, default=120)
    parser.add_argument("--translator-timeout", type=int, default=180)
    parser.add_argument(
        "--translator-command",
        help="Optional local command that reads request JSON on stdin and returns {code, plain} JSON.",
    )
    args = parser.parse_args()
    if args.host not in {"127.0.0.1", "localhost", "::1"}:
        raise SystemExit("The workspace server is intentionally loopback-only.")
    directory = args.directory.resolve()
    if not (directory / "index.html").is_file():
        raise SystemExit(f"Built site not found at {directory}; build Quantumlib first.")
    WorkspaceHandler.lean_version_text = tool_version()
    WorkspaceHandler.compile_timeout = max(1, args.compile_timeout)
    WorkspaceHandler.translator_timeout = max(1, args.translator_timeout)
    WorkspaceHandler.translator_command = (
        shlex.split(args.translator_command) if args.translator_command else None
    )
    handler = partial(WorkspaceHandler, directory=str(directory))
    server = ThreadingHTTPServer((args.host, args.port), handler)
    print(f"Quantumlib workspace: http://{args.host}:{args.port}/ide/")
    print(f"Lean service: {WorkspaceHandler.lean_version_text}")
    print(f"Local translator: {'enabled' if WorkspaceHandler.translator_command else 'disabled'}")
    print("Security: loopback only; temporary snippets are deleted after compilation.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
