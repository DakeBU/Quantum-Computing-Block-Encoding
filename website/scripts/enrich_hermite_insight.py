#!/usr/bin/env python3
"""Add the Hermite case's mathematical insight layer after final case publication.

This pass changes exposition only. It never changes proof status, theorem roots,
resource certificates, or the generated Lean graph evidence class. The special
case presentation is deliberately late in the website pipeline because
``publish_extensions.py`` re-renders the Hermite page after the generic casebook
passes have already run.
"""

from __future__ import annotations

import argparse
import html
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DATA_PATH = ROOT / "website" / "hermite-insight.json"
CASE_SLUG = "hermite-smooth-state-preparation"


def load_data() -> dict[str, object]:
    data = json.loads(DATA_PATH.read_text(encoding="utf-8"))
    if data.get("schemaVersion") != 1 or data.get("caseSlug") != CASE_SLUG:
        raise RuntimeError("unsupported Hermite insight data")
    for key in (
        "headline", "thesis", "profileFormula", "compressionFormula",
        "resourceFormula", "oldFormula", "newFormula", "mechanisms",
        "crossPollination", "topology", "trustBoundary",
    ):
        if not data.get(key):
            raise RuntimeError(f"Hermite insight data lacks {key}")
    return data


def math_block(tex: str, class_name: str = "hermite-insight-formula") -> str:
    return f'<div class="{class_name}">\\[{html.escape(tex, quote=False)}\\]</div>'


def inline_math(tex: str) -> str:
    return f"\\({html.escape(tex, quote=False)}\\)"


def ensure_css(text: str, href: str) -> str:
    if "hermite-insight.css" in text:
        return text
    marker = "</head>"
    if marker not in text:
        raise RuntimeError("page has no </head> marker")
    return text.replace(
        marker,
        f'  <link rel="stylesheet" href="{html.escape(href, quote=True)}">\n{marker}',
        1,
    )


def render_case_insight(data: dict[str, object]) -> str:
    mechanisms = "".join(
        f"""<article class="hermite-mechanism">
  <p class="eyebrow">{html.escape(str(item['tag']))}</p>
  <h3>{html.escape(str(item['title']))}</h3>
  <p>{html.escape(str(item['body']))}</p>
  <div class="math-line">{inline_math(str(item['formula']))}</div>
</article>"""
        for item in data["mechanisms"]
    )
    fields = "".join(
        f"""<article class="hermite-field-step">
  <p class="eyebrow">{html.escape(str(item['field']))}</p>
  <h3>{html.escape(str(item['field']))}</h3>
  <p>{html.escape(str(item['idea']))}</p>
</article>"""
        for item in data["crossPollination"]
    )
    return f"""<section class="hermite-insight" id="hermite-insight">
  <div class="hermite-insight-hero">
    <p class="eyebrow">Core insight · read this first</p>
    <h2>{html.escape(str(data['headline']))}</h2>
    <p class="hermite-insight-thesis">{html.escape(str(data['thesis']))}</p>
    {math_block(str(data['compressionFormula']))}
    <div class="hermite-comparison">
      <article><p class="eyebrow">Generic loading</p><h3>Forget the function, list every amplitude</h3><p>The generic route expands the analytic profile into a table before compiling it.</p><div class="math-line">{inline_math(str(data['oldFormula']))}</div></article>
      <article><p class="eyebrow">Structure-aware loading</p><h3>Keep the function's short internal memory</h3><p>The new route carries a bounded state while reading the address bits.</p><div class="math-line">{inline_math(str(data['newFormula']))}</div></article>
    </div>
  </div>
  <section class="hermite-insight-section" id="hermite-four-moves">
    <div class="section-heading"><p class="eyebrow">Why the compression works</p><h2>Four moves replace an exponential amplitude table</h2><p>No single trick does the job. The proof preserves analytic structure until it can be compiled locally.</p></div>
    <div class="hermite-mechanism-grid">{mechanisms}</div>
  </section>
  <section class="hermite-insight-section" id="hermite-cross-pollination">
    <div class="section-heading"><p class="eyebrow">Mathematical cross-pollination</p><h2>The construction crosses four mathematical languages</h2><p>The useful invariant changes as the proof moves from a smooth function to a quantum circuit.</p></div>
    <div class="hermite-field-flow">{fields}</div>
    {math_block(str(data['resourceFormula']))}
    <aside class="hermite-trust"><strong>Certified boundary.</strong> {html.escape(str(data['trustBoundary']))}</aside>
    <div class="hermite-topology-link"><a class="button" href="../../lean-graph/index.html#hermite-topology">See the proof-topology contribution</a><span>BRIDGE · SHORTCUT · HUB · REORGANIZATION</span></div>
  </section>
</section>"""


def render_contract(data: dict[str, object]) -> str:
    return f"""<div class="hermite-contract-reading">
  <strong>Exact target.</strong>
  {math_block(str(data['profileFormula']), 'math-line')}
  <strong>Certified quantum resource statement.</strong>
  {math_block(str(data['resourceFormula']), 'math-line')}
  <p>The samples themselves are amplitudes, not probabilities. The construction uses zero oracle calls and no postselection, and the bond register is clean at output. The exact-real quantum bound is certified separately from finite-bit implementation cost.</p>
</div>"""


def _route(items: list[object]) -> str:
    answer: list[str] = []
    for index, item in enumerate(items):
        if index:
            answer.append('<span class="hermite-route-arrow" aria-hidden="true">→</span>')
        answer.append(f'<span class="hermite-route-node">{html.escape(str(item))}</span>')
    return '<div class="hermite-route">' + "".join(answer) + '</div>'


def render_topology_lens(data: dict[str, object]) -> str:
    topo = dict(data["topology"])
    cards = "".join(
        f"""<article class="hermite-topology-card">
  <span class="hermite-topology-kind">{html.escape(str(item['kind']))}</span>
  <h3>{html.escape(str(item['title']))}</h3>
  <p>{html.escape(str(item['body']))}</p>
</article>"""
        for item in topo["contributions"]
    )
    corridor = " → ".join(html.escape(str(item)) for item in topo["moduleCorridor"])
    return f"""<section class="content-section hermite-topology-lens" id="hermite-topology">
  <div class="section-heading">
    <p class="eyebrow">Case lens · proof digestion</p>
    <h2>{html.escape(str(topo['title']))}</h2>
    <p class="hermite-topology-summary">{html.escape(str(topo['summary']))}</p>
  </div>
  <div class="hermite-topology-lanes">
    <article class="hermite-topology-lane old"><p class="eyebrow">Old factorization</p><h3>Correct, but it destroys structure early</h3>{_route(list(topo['oldRoute']))}</article>
    <article class="hermite-topology-lane new"><p class="eyebrow">New factorization</p><h3>Preserve structure until local compilation</h3>{_route(list(topo['newRoute']))}</article>
  </div>
  <div class="hermite-topology-grid">{cards}</div>
  <div class="hermite-module-corridor"><strong>Checked module corridor.</strong><br><code>{corridor}</code></div>
  <p class="hermite-evidence-boundary"><strong>Evidence boundary.</strong> {html.escape(str(topo['evidenceBoundary']))}</p>
  <div class="link-row"><a class="button" href="../example-cases/{CASE_SLUG}/index.html#hermite-insight">Read the Hermite construction</a><button class="button secondary" type="button" data-show-hermite-graph>Filter the interactive graph to Hermite</button></div>
</section>
<script>
(() => {{
  const button = document.querySelector('[data-show-hermite-graph]');
  if (!button) return;
  button.addEventListener('click', () => {{
    const search = document.querySelector('[data-graph-search]');
    const track = document.querySelector('[data-graph-track]');
    if (search) {{ search.value = 'Hermite'; search.dispatchEvent(new Event('input', {{bubbles: true}})); }}
    if (track) {{ track.value = 'state-preparation'; track.dispatchEvent(new Event('change', {{bubbles: true}})); }}
    document.querySelector('#interactive-graph')?.scrollIntoView({{behavior: 'smooth', block: 'start'}});
  }});
}})();
</script>"""


def mathify_reader_prose(text: str) -> str:
    """Fix known Hermite formulas while never rewriting source/code panels."""
    protected = re.compile(
        r'(<(?:pre|code|script|style|textarea)\b[^>]*>.*?</(?:pre|code|script|style|textarea)>)',
        re.IGNORECASE | re.DOTALL,
    )
    replacements = (
        ("48 n_p (2k+6)^3 Ry/CNOT", r"\(48\,n_p(2k+6)^3\) \(R_y/\mathrm{CNOT}\)"),
        ("ceil(log2(2k+6))", r"\(\lceil\log_2(2k+6)\rceil\)"),
        ("O(n_p (k+1)^3)", r"\(O(n_p(k+1)^3)\)"),
        ("2^n_p", r"\(2^{n_p}\)"),
        ("degree-2k+1", r"degree-\(2k+1\)"),
        ("width 2k+6", r"width \(2k+6\)"),
    )
    parts = protected.split(text)
    for index in range(0, len(parts), 2):
        for old, new in replacements:
            parts[index] = parts[index].replace(old, new)
    return "".join(parts)


def enrich_case(path: Path, data: dict[str, object]) -> None:
    if not path.is_file():
        raise RuntimeError(f"Hermite case page missing: {path}")
    text = path.read_text(encoding="utf-8")
    text = ensure_css(text, "../../static/hermite-insight.css")
    if 'id="hermite-insight"' not in text:
        marker = '<section class="casebook-tutorial"'
        index = text.find(marker)
        if index < 0:
            raise RuntimeError("Hermite tutorial marker missing")
        text = text[:index] + render_case_insight(data) + "\n" + text[index:]
    contract = re.compile(r'<p class="contract-reading">.*?</p>', re.DOTALL)
    if contract.search(text):
        text = contract.sub(render_contract(data), text, count=1)
    if '<div class="case-status-line">' in text:
        status_pattern = re.compile(r'(<div class="case-status-line">.*?<span>).*?(</span></div>)', re.DOTALL)
        replacement = (
            r'\1Prepare the same state by exploiting bond dimension '
            + inline_math("D=2k+6")
            + ': for fixed '
            + inline_math("k")
            + ', the exact-real gate bound is linear in '
            + inline_math("n_p")
            + ', not in the '
            + inline_math("2^{n_p}")
            + r' amplitudes.\2'
        )
        text = status_pattern.sub(replacement, text, count=1)
    text = text.replace(
        "Their joint input is |g_k&gt; tensor |u_0&gt;.",
        "Their joint input is " + inline_math(r"\lvert g_k\rangle_p\otimes\lvert u_0\rangle") + ".",
    )
    text = mathify_reader_prose(text)
    path.write_text(text, encoding="utf-8")


def enrich_graph(path: Path, data: dict[str, object]) -> None:
    if not path.is_file():
        raise RuntimeError(f"Lean graph page missing: {path}")
    text = path.read_text(encoding="utf-8")
    text = ensure_css(text, "../static/hermite-insight.css")
    if 'id="hermite-topology"' not in text:
        marker = '<section class="content-section lean-graph-app" id="interactive-graph"'
        index = text.find(marker)
        if index < 0:
            raise RuntimeError("interactive Lean graph marker missing")
        text = text[:index] + render_topology_lens(data) + "\n" + text[index:]
    path.write_text(text, encoding="utf-8")


def enrich(root: Path) -> None:
    data = load_data()
    enrich_case(root / "example-cases" / CASE_SLUG / "index.html", data)
    enrich_graph(root / "lean-graph" / "index.html", data)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    enrich(args.root)


if __name__ == "__main__":
    main()
