#!/usr/bin/env python3
"""Browser-level publication checks; screenshots are artifacts, not human review."""
from __future__ import annotations

import argparse
import functools
import http.server
import json
import threading
from pathlib import Path


class QuietHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        pass


def run(root: Path, output: Path) -> None:
    from playwright.sync_api import sync_playwright
    output.mkdir(parents=True, exist_ok=True)
    server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), functools.partial(QuietHandler, directory=str(root.resolve())))
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    base = f"http://127.0.0.1:{server.server_port}"
    records = []
    failures = []
    routes = ["mathematical-methods", "functor-hypergraph", "state-preparation-wiki", "progress", "lean-graph"]
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch()
            context = browser.new_context(permissions=["clipboard-read", "clipboard-write"])
            page = context.new_page()
            page.on("pageerror", lambda error: failures.append(str(error)))
            for width in (390, 1280):
                page.set_viewport_size({"width": width, "height": 900})
                for theme in ("blueprint", "modern", "bold"):
                    for route in routes:
                        page.goto(f"{base}/{route}/index.html", wait_until="networkidle", timeout=90000)
                        page.evaluate("theme => document.documentElement.dataset.theme = theme", theme)
                        page.wait_for_function("Boolean(window.MathJax && window.MathJax.startup && window.MathJax.startup.promise)", timeout=60000)
                        page.evaluate("async () => { await MathJax.startup.promise; await MathJax.typesetPromise(); }")
                        size = page.evaluate("({width: innerWidth, scroll: document.documentElement.scrollWidth})")
                        if size["scroll"] > width + 2:
                            failures.append(f"global horizontal overflow {route} {width} {theme}: {size}")
                        math_errors = page.locator("mjx-merror").count()
                        if math_errors:
                            failures.append(f"MathJax errors {route}: {math_errors}; " + str(page.locator("mjx-merror").all_text_contents()))
                        if route == "functor-hypergraph":
                            page.wait_for_selector('svg[data-edge-id]', timeout=30000)
                            select = page.locator("[data-ra-edge]")
                            select.select_option("transport:tt-to-sp")
                            page.wait_for_function("document.querySelector('[data-ra-svg]').dataset.tailCount === '3'")
                            if page.locator("[data-ra-svg] a").count() != 4:
                                failures.append("AND input set was dropped from the TT-to-SP graph")
                            page.locator("[data-ra-svg] a").first.focus()
                            if not page.evaluate("document.activeElement.closest('[data-ra-svg]') !== null"):
                                failures.append("SVG nodes are not keyboard-focusable")
                        if route == "mathematical-methods":
                            page.locator("[data-ra-search]").fill("Bernstein")
                            if not page.locator("[data-ra-item]:visible").count():
                                failures.append("mechanism search lost Bernstein")
                            page.locator("[data-ra-search]").fill("a-string-not-present-in-any-card")
                            if page.locator("[data-ra-item]:visible").count():
                                failures.append("mechanism search did not filter cards")
                            page.locator("[data-ra-search]").fill("")
                        page.screenshot(path=str(output / f"{route}-{width}-{theme}.png"), full_page=False)
                        records.append({"route": route, "width": width, "theme": theme, "math_errors": math_errors, "scroll_width": size["scroll"]})
            # Inspect every authored formula route, including source and long-code disclosures.
            for path in sorted((root / "mathematical-methods").glob("*/index.html")) + sorted((root / "state-preparation-wiki").glob("*/index.html")):
                relative = path.relative_to(root).as_posix()
                page.set_viewport_size({"width": 390, "height": 900})
                page.goto(f"{base}/{relative}", wait_until="networkidle", timeout=90000)
                page.wait_for_function("Boolean(window.MathJax && window.MathJax.startup && window.MathJax.startup.promise)", timeout=60000)
                page.evaluate("async () => { await MathJax.startup.promise; await MathJax.typesetPromise(); }")
                if page.locator("mjx-merror").count():
                    failures.append("MathJax error in " + relative)
                if page.evaluate("document.documentElement.scrollWidth > innerWidth + 2"):
                    failures.append("mobile overflow in " + relative)
            page.goto(f"{base}/mathematical-methods/hermite-bernstein/index.html", wait_until="networkidle", timeout=90000)
            details = page.locator("details.ra-code").first
            details.locator("summary").click()
            if page.evaluate("document.documentElement.scrollWidth > innerWidth + 2"):
                failures.append("expanded Lean source causes page overflow")
            # Exercise the exact declaration link and real imported-edge delta, not only cards.
            name = "QuantumBlockEncoding.ConstructiveHermitePreparation.prepare_spec"
            from urllib.parse import quote
            page.goto(f"{base}/lean-graph/index.html?focus=" + quote("declaration:" + name, safe=""), wait_until="networkidle", timeout=90000)
            page.wait_for_function("document.body.textContent.includes('Focused exact shared identity: declaration:QuantumBlockEncoding.ConstructiveHermitePreparation.prepare_spec')", timeout=30000)
            page.screenshot(path=str(output / "exact-lean-focus.png"), full_page=False)
            page.goto(f"{base}/functor-hypergraph/index.html", wait_until="networkidle", timeout=90000)
            page.wait_for_function("Number(document.querySelector('[data-ra-delta-svg]').dataset.edgeCount) > 0", timeout=30000)
            for width in (390, 1280):
                page.set_viewport_size({"width": width, "height": 900})
                page.locator('[data-ra-hypergraph]').scroll_into_view_if_needed()
                page.screenshot(path=str(output / f"and-graph-{width}.png"), full_page=False)
                page.locator('[data-ra-delta]').scroll_into_view_if_needed()
                page.screenshot(path=str(output / f"contribution-graph-{width}.png"), full_page=False)
            with page.expect_download() as download_event:
                page.locator('[data-ra-download-svg]').click()
            download_event.value.save_as(output / "transport-export.svg")
            context.close()
            browser.close()
    finally:
        server.shutdown()
        server.server_close()
    report = {"automated_browser_checks": records, "failures": failures, "manual_visual_review": "not asserted by this script"}
    (output / "browser-report.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    if failures:
        raise SystemExit("Research browser checks failed:\n" + "\n".join(failures))
    print(f"Research browser checks passed: {len(records)} route/viewport/theme combinations and all authored formula pages")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=Path("_out/research-browser"))
    args = parser.parse_args()
    run(args.root.resolve(), args.output)
