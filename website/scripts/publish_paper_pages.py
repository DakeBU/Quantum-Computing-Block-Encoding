#!/usr/bin/env python3
"""Publish source-facing pages for partially reproduced State Preparation papers.

A paper receives a page only after `website/papers.json` supplies numbered source
anchors and named Lean roots.  The page states the finite/formalized boundary
explicitly; it never upgrades a benchmark or resource lemma into a paper-wide
reproduction.
"""

from __future__ import annotations

import argparse
import html
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from website.scripts import build_site  # noqa: E402
from website.scripts import publish_extensions  # noqa: E402

PAPERS_PATH = ROOT / "website" / "papers.json"


def load_json(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


def lean_evidence(
    roots: list[str], declarations: dict[str, dict[str, object]], prefix: str
) -> str:
    rows: list[str] = []
    for root in roots:
        declaration = declarations.get(root)
        if declaration is None:
            raise RuntimeError(f"paper page references unknown Lean root: {root}")
        local = str(declaration.get("localSourceUrl") or "")
        href = prefix + local if local else "#"
        rows.append(
            f'<li><a href="{html.escape(href, quote=True)}"><code>{html.escape(root)}</code></a></li>'
        )
    return (
        '<details class="casebook-lean" open>'
        '<summary>Lean evidence for the formalized surface</summary>'
        '<p>These declarations are the proof authority for the finite theorem or resource lemma described above.</p>'
        f'<ul>{"".join(rows)}</ul></details>'
    )


def render_partial_page(
    item: dict[str, object],
    declarations: dict[str, dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    key = str(item["key"])
    route = str(item["route"])
    roots = [str(root) for root in item.get("leanRoots", [])]
    if not roots:
        raise RuntimeError(f"formalized paper page has no Lean roots: {key}")
    anchors = " ".join(
        f'<span class="status status-compiled">{html.escape(str(anchor))}</span>'
        for anchor in item.get("sourceAnchors", [])
    )
    case_slug = str(item.get("exampleCase") or "")
    case_link = ""
    if case_slug:
        case_link = (
            '<p><a class="button" href="../../example-cases/'
            + html.escape(case_slug, quote=True)
            + '/index.html">Open the primary Example Case</a></p>'
        )
    body = f'''<section class="hero" id="paper-{html.escape(key)}">
  <p class="eyebrow">Papers · State Preparation · {html.escape(publish_extensions.status_label(str(item['status'])))}</p>
  <h1>{html.escape(str(item['title']))}</h1>
  <p class="lede">{html.escape(str(item['authors']))} · {int(item['year'])}. This is a source-facing partial reproduction page: it separates the paper statement, the finite Lean surface already closed in ASPBE, and the paper-wide work still queued.</p>
  <p><a class="text-link" href="{html.escape(str(item['url']), quote=True)}">Open source paper ↗</a></p>
</section>
<section class="content-section" id="source-contract">
  <div class="section-heading"><p class="eyebrow">Source contract</p><h2>Start from the numbered statement in the paper</h2></div>
  <article class="result">
    <p><strong>Source anchors.</strong> {anchors}</p>
    <p><strong>What these source locations say.</strong> {html.escape(str(item.get('sourceStatement', 'See the numbered source locations above.')))}</p>
  </article>
</section>
<section class="content-section" id="formalized-surface">
  <div class="section-heading"><p class="eyebrow">Formalized now</p><h2>The theorem surface ASPBE is allowed to claim today</h2></div>
  <article class="result"><p>{html.escape(str(item['formalized']))}</p>{case_link}</article>
  {lean_evidence(roots, declarations, '../../')}
</section>
<section class="content-section" id="reproduction-boundary">
  <div class="section-heading"><p class="eyebrow">Paper reproduction boundary</p><h2>What is deliberately not claimed yet</h2></div>
  <article class="result"><p>{html.escape(str(item['remaining']))}</p><p><strong>Status rule.</strong> A finite witness, typed circuit, or resource lemma is not silently promoted to the source paper's arbitrary-width or asymptotic theorem.</p></article>
</section>'''
    return build_site.page_template(
        title=f"Paper · {item['title']}",
        route=route,
        current=route,
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[
            (f"paper-{key}", "Paper"),
            ("source-contract", "Source contract"),
            ("formalized-surface", "Formalized now"),
            ("reproduction-boundary", "Remaining scope"),
        ],
    )


def publish(root: Path) -> None:
    papers = load_json(PAPERS_PATH)
    declarations_list, declarations = publish_extensions.declarations_from_site(root)
    del declarations_list
    build_report = load_json(root / "build-report.json")
    coverage = dict(build_report.get("coverage") or {})
    gate = dict(build_report.get("leanGate") or {})
    context = dict(build_report)

    published: list[str] = []
    for raw in papers.get("queue", []):
        item = dict(raw)
        if str(item.get("status")) == "queued":
            continue
        route = str(item.get("route") or "")
        roots = [str(lean_root) for lean_root in item.get("leanRoots", [])]
        anchors = [str(anchor) for anchor in item.get("sourceAnchors", [])]
        if not route or not roots or not anchors:
            raise RuntimeError(f"formalized paper lacks route/roots/anchors: {item.get('key')}")
        for lean_root in roots:
            if lean_root not in declarations:
                raise RuntimeError(
                    f"formalized paper has unknown Lean root: {item.get('key')}: {lean_root}"
                )
        build_site.write_page(
            root,
            route.rstrip("/"),
            render_partial_page(item, declarations, coverage, gate, context),
        )
        published.append(route.rstrip("/"))

    print(f"Published {len(published)} partial paper page(s): {', '.join(published)}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    publish(args.root.resolve())


if __name__ == "__main__":
    main()
