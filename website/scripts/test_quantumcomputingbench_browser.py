#!/usr/bin/env python3
"""Real-browser reader acceptance; screenshots are not mathematical certification."""
from __future__ import annotations

import argparse
import functools
import http.server
import json
from pathlib import Path
import sys
import threading

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from website.scripts.quantumcomputingbench import HUB, check_site
from website.scripts.research_browser_contract import THEMES
from website.scripts.test_research_browser import QuietHandler


def run(root, output, channel=None):
    from playwright.sync_api import sync_playwright
    root, output = root.resolve(), output.resolve()
    check_site(root)
    output.mkdir(parents=True, exist_ok=True)
    manifest = json.loads((root / "data/quantumcomputingbench/reader.json").read_text(encoding="utf-8"))
    catalog = json.loads((root / "data/quantumcomputingbench/cores.json").read_text(encoding="utf-8"))
    server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), functools.partial(QuietHandler, directory=str(root)))
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    base = f"http://127.0.0.1:{server.server_port}/"
    rows, failures = [], []
    checks = {k: False for k in ("mobile_no_overflow", "desktop_no_overflow", "themes", "solution_disclosure", "graph_links", "search_excludes_answers")}
    core_route = HUB + "cores/" + catalog["cores"][0]["core_id"] + "/index.html"
    routes = [HUB + "index.html", HUB + "non-lean/index.html", HUB + "lean/index.html",
              HUB + "non-lean/state-preparation/structured_preparation/index.html",
              HUB + "lean/warmups/index.html", core_route]
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(channel=channel)
            page = browser.new_page()
            page.on("pageerror", lambda e: failures.append(str(e)))
            for width in (390, 1280):
                page.set_viewport_size({"width": width, "height": 900})
                for theme in THEMES:
                    for n, route in enumerate(routes):
                        page.goto(base + route, wait_until="networkidle")
                        page.evaluate("theme => document.documentElement.dataset.theme = theme", theme)
                        if page.evaluate("document.documentElement.scrollWidth > innerWidth + 2"):
                            failures.append(f"overflow: {route} {width} {theme}")
                        if page.locator("mjx-merror").count():
                            failures.append("math rendering error: " + route)
                        if route == core_route:
                            solution = page.locator('#solution')
                            if solution.get_attribute("open") is not None:
                                failures.append("solution exposed by default")
                            solution.locator("summary").focus()
                            page.keyboard.press("Enter")
                            if solution.get_attribute("open") is None:
                                failures.append("keyboard solution disclosure failed")
                            if page.evaluate("document.documentElement.scrollWidth > innerWidth + 2"):
                                failures.append("expanded solution overflow")
                        page.screenshot(path=str(output / f"reader-{n}-{width}-{theme}.png"), full_page=False)
                        rows.append({"route": route, "width": width, "theme": theme})
            # Every core, not merely one flattering sample: folded defaults and layout.
            page.set_viewport_size({"width": 390, "height": 900})
            for core in catalog["cores"]:
                route = HUB + "cores/" + core["core_id"] + "/index.html"
                page.goto(base + route, wait_until="domcontentloaded")
                if page.locator('.qcb-disclosure[open]').count():
                    failures.append("unfolded answer/evidence: " + route)
                if page.evaluate("document.documentElement.scrollWidth > innerWidth + 2"):
                    failures.append("core overflow: " + route)
            page.goto(base + HUB + "non-lean/state-preparation/structured_preparation/index.html", wait_until="networkidle")
            total = page.locator('[data-qcb-card]').count()
            page.locator('[data-qcb-query]').fill('not-a-real-exercise-29815')
            if page.locator('[data-qcb-card]:visible').count():
                failures.append("empty search not respected")
            page.locator('[data-qcb-query]').fill('')
            if page.locator('[data-qcb-card]:visible').count() != total:
                failures.append("search reset lost questions")
            page.goto(base + core_route, wait_until="networkidle")
            graph = page.locator('[data-qcb-graph]').first
            if not graph.count():
                failures.append("no actual graph link")
            else:
                graph.click()
                page.wait_for_load_state("networkidle")
                page.wait_for_function("document.body.textContent.includes('Focused exact shared identity:')")
            browser.close()
        if not failures:
            checks = {key: True for key in checks}
    finally:
        server.shutdown()
        server.server_close()
    report = {"schema_version": 1, "catalog_hash": manifest["catalog_hash"],
              "reader_source_digest": manifest["reader_source_digest"], "source_commit": manifest["source_commit"],
              "browser_channel": channel or "playwright-chromium", "checks": checks,
              "route_viewport_theme_checks": rows, "all_core_mobile_checks": len(catalog["cores"]),
              "failures": failures, "manual_visual_review": "not asserted by this script",
              "question_only_search": "Exact question summaries checked by check_site; reference answers are not indexed."}
    (output / "browser-report.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    if failures:
        raise SystemExit("Reader browser failures:\n" + "\n".join(failures))
    print(f"QCB browser checks passed: {len(rows)} combinations, {len(catalog['cores'])} core pages")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=Path("_out/qcb-browser"))
    parser.add_argument("--browser-channel", choices=("chrome", "msedge"))
    args = parser.parse_args()
    run(args.root, args.output, args.browser_channel)
