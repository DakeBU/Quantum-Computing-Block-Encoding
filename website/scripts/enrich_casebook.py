#!/usr/bin/env python3
"""Turn generated case/status pages into beginner-first theorem-linked lessons.

The normal site builder remains the source of proof/status HTML.  This pass adds
an explanatory layer before the technical cards, keeps Lean optional behind
native <details>, and moves low-level source-audit decisions out of the novice
reading path.  It never changes proof status or declaration data.
"""

from __future__ import annotations

import argparse
import html
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TEACHING_PATH = ROOT / "website" / "case-teaching.json"
INVENTORY_PATH = ROOT / "web" / "library" / "declarations.json"
TEXTBOOK_PATH = ROOT / "website" / "textbook-lessons.json"


def load_json(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


def math_block(tex: str, class_name: str = "casebook-formula") -> str:
    return f'<div class="{class_name}">\\[{html.escape(tex, quote=False)}\\]</div>'


def source_map() -> dict[str, dict[str, object]]:
    data = load_json(TEXTBOOK_PATH)
    return dict(data["sources"])


def declaration_map() -> dict[str, dict[str, object]]:
    data = load_json(INVENTORY_PATH)
    return {str(item["fullName"]): item for item in data["declarations"]}


def root_link(root: str, declarations: dict[str, dict[str, object]], prefix: str) -> str:
    declaration = declarations[root]
    local = str(declaration.get("localSourceUrl") or "")
    href = prefix + local if local else "#"
    return (
        f'<li><a href="{html.escape(href, quote=True)}">'
        f'<code>{html.escape(root)}</code></a></li>'
    )


def lean_details(
    roots: list[str], declarations: dict[str, dict[str, object]], prefix: str,
    title: str = "Show the Lean proof checkpoints",
) -> str:
    links = "".join(root_link(root, declarations, prefix) for root in roots)
    return f"""<details class="casebook-lean">
  <summary>{html.escape(title)}</summary>
  <p>The mathematical explanation above is the reading layer. These compiled declarations are the proof authority.</p>
  <ul>{links}</ul>
</details>"""


def proof_steps(steps: list[list[str]]) -> str:
    return '<ol class="casebook-proof-steps">' + "".join(
        f'<li><strong>{html.escape(str(title))}</strong><span>{html.escape(str(body))}</span></li>'
        for title, body in steps
    ) + '</ol>'


def circuit_steps(steps: list[list[str]]) -> str:
    return '<div class="casebook-circuit-guide">' + "".join(
        f'<article><span>{index}</span><div><strong>{html.escape(str(title))}</strong>'
        f'<p>{html.escape(str(body))}</p></div></article>'
        for index, (title, body) in enumerate(steps, start=1)
    ) + '</div>'


def source_box(source: dict[str, object]) -> str:
    if not source:
        return ""
    quote = str(source.get("shortQuote") or "")
    quote_html = f'<blockquote>“{html.escape(quote)}”</blockquote>' if quote else ""
    query = str(source.get("queryFormula") or "")
    query_html = math_block(query, "casebook-query-formula") if query else ""
    return f"""<aside class="casebook-source-box">
  <p class="eyebrow">Source-paper motivation</p>
  <h3><a href="{html.escape(str(source.get('url', '')), quote=True)}">{html.escape(str(source.get('title', 'Source')))}</a></h3>
  <p>{html.escape(str(source.get('authors', '')))}</p>
  {quote_html}
  {query_html}
  <p>{html.escape(str(source.get('queryExplanation', '')))}</p>
</aside>"""


def theorem_card(
    theorem: dict[str, object], declarations: dict[str, dict[str, object]], prefix: str,
) -> str:
    return f"""<article class="casebook-theorem">
  <p class="eyebrow">{html.escape(str(theorem['label']))}</p>
  <h3>{html.escape(str(theorem['title']))}</h3>
  {math_block(str(theorem['statementFormula']))}
  <p class="casebook-theorem-reading">{html.escape(str(theorem['statementProse']))}</p>
  <h4>Proof story</h4>
  {proof_steps(list(theorem['proofSteps']))}
  {lean_details(list(theorem['leanRoots']), declarations, prefix)}
</article>"""


def improvement_card(
    improvement: dict[str, object], declarations: dict[str, dict[str, object]], prefix: str,
) -> str:
    if not improvement:
        return ""
    return f"""<section class="casebook-improvement" id="case-improvement">
  <p class="eyebrow">What ASPBE improves</p>
  <h2>{html.escape(str(improvement['title']))}</h2>
  {math_block(str(improvement['statementFormula']))}
  <p class="casebook-theorem-reading">{html.escape(str(improvement['statementProse']))}</p>
  <h3>Why the proof is allowed to say “better”</h3>
  {proof_steps(list(improvement['proofSteps']))}
  {lean_details(list(improvement['leanRoots']), declarations, prefix, 'Show the Lean winner/comparison theorems')}
</section>"""


def pipeline_html(pipeline: list[list[str]]) -> str:
    if not pipeline:
        return ""
    return '<div class="casebook-pipeline">' + "".join(
        f'<article><strong>{html.escape(str(title))}</strong><p>{html.escape(str(body))}</p></article>'
        for title, body in pipeline
    ) + '</div>'


def render_case_tutorial(
    slug: str,
    teaching: dict[str, object],
    declarations: dict[str, dict[str, object]],
) -> str:
    prefix = "../../"
    source = dict(teaching.get("source") or {})
    pipeline = list(teaching.get("pipeline") or [])
    theorems = "".join(
        theorem_card(dict(item), declarations, prefix)
        for item in teaching.get("theorems", [])
    )
    bridge = dict(teaching.get("benchmarkBridge") or {})
    bridge_html = ""
    if bridge:
        bridge_html = f"""<aside class="casebook-bridge">
  <strong>{html.escape(str(bridge['title']))}</strong>
  <p>{html.escape(str(bridge['body']))}</p>
</aside>"""
    return f"""<section class="casebook-tutorial" id="case-tutorial" data-casebook="{html.escape(slug)}">
  <div class="casebook-opening">
    <p class="eyebrow">Read this before the proof dashboard</p>
    <h2>{html.escape(str(teaching['readerGoal']))}</h2>
    <p class="casebook-lead">{html.escape(str(teaching['whyThisCase']))}</p>
    <p>{html.escape(str(teaching['algorithmContext']))}</p>
    {source_box(source)}
  </div>
  {('<section class="casebook-subsection"><p class="eyebrow">Whole algorithm first</p><h2>Where this block encoding sits in the quantum algorithm</h2>' + pipeline_html(pipeline) + '</section>') if pipeline else ''}
  <section class="casebook-subsection">
    <p class="eyebrow">Read the circuit</p>
    <h2>What the wires and stages are doing</h2>
    {circuit_steps(list(teaching['circuitReading']))}
    <p class="casebook-pointer">The detailed circuit diagrams generated from the case record appear below this tutorial.</p>
  </section>
  <section class="casebook-subsection" id="case-theorems">
    <p class="eyebrow">Statement → proof → optional Lean</p>
    <h2>The mathematical claims, in the order a human would prove them</h2>
    {theorems}
  </section>
  {bridge_html}
  {improvement_card(dict(teaching.get('improvement') or {}), declarations, prefix)}
</section>"""


def render_foundation(data: dict[str, object], sources: dict[str, dict[str, object]]) -> str:
    foundation = dict(data["foundation"])
    access = "".join(
        f"""<article class="access-model-card">
  <h3>{html.escape(str(item['name']))}</h3>
  {math_block(str(item['formula']), 'access-model-formula')}
  <p><strong>Contract.</strong> {html.escape(str(item['plain']))}</p>
  <p><strong>Why it matters.</strong> {html.escape(str(item['why']))}</p>
  <p class="casebook-example">{html.escape(str(item['example']))}</p>
</article>"""
        for item in foundation["accessModels"]
    )
    legend = "".join(
        f'<li><code>{html.escape(str(symbol))}</code><span>{html.escape(str(text))}</span></li>'
        for symbol, text in foundation["circuitLegend"]
    )
    source_cards = "".join(
        f'<a class="casebook-source-link" href="{html.escape(str(sources[key]["url"]), quote=True)}">'
        f'<strong>{html.escape(str(sources[key]["title"]))}</strong>'
        f'<span>{html.escape(str(sources[key]["authors"]))}</span></a>'
        for key in foundation.get("sourceAnchors", [])
    )
    return f"""<section class="casebook-foundation" id="quantum-access-models">
  <p class="eyebrow">Foundation lesson · do not skip this if you are new</p>
  <h2>{html.escape(str(foundation['title']))}</h2>
  <p class="casebook-lead">{html.escape(str(foundation['lead']))}</p>
  <div class="access-model-grid">{access}</div>
  <aside class="access-model-contrast">
    <strong>Do not mix these interfaces.</strong>
    <p>A digital query oracle writes an entry value into a register. A block encoding hides the matrix as amplitudes in a clean sub-block of a unitary. State preparation creates an input state. A theorem may assume one of these and still leave the others as real implementation costs.</p>
  </aside>
  <section class="circuit-reading-lesson">
    <p class="eyebrow">How to read a quantum circuit</p>
    <h3>Follow the state from left to right</h3>
    <div class="circuit-demo" aria-label="Simple quantum circuit example">
      <div class="circuit-demo-row"><span>q0: |0></span><i></i><b>H</b><i></i><b class="control-dot">●</b><i></i><span>measurement</span></div>
      <div class="circuit-demo-row"><span>q1: |0></span><i></i><b class="empty-gate"></b><i></i><b>⊕</b><i></i><span>measurement</span></div>
    </div>
    <ul class="circuit-legend">{legend}</ul>
    <p>The H-plus-CNOT circuit above prepares the Bell state \((|00\\rangle+|11\\rangle)/\\sqrt2\). The same visual grammar is used in the case studies; larger diagrams only add named registers and uncomputation.</p>
  </section>
  <div class="casebook-source-strip"><span>Suggested background</span>{source_cards}</div>
</section>"""


def ensure_css(text: str, href: str) -> str:
    if "casebook.css" in text:
        return text
    marker = "</head>"
    if marker not in text:
        raise RuntimeError("page has no </head> marker")
    return text.replace(marker, f'  <link rel="stylesheet" href="{href}">\n{marker}', 1)


def inject_after_hero(text: str, fragment: str) -> str:
    hero_start = text.find('<header class="hero case-hero">')
    if hero_start < 0:
        raise RuntimeError("case hero marker missing")
    hero_end = text.find("</header>", hero_start)
    if hero_end < 0:
        raise RuntimeError("case hero closing tag missing")
    hero_end += len("</header>")
    return text[:hero_end] + "\n" + fragment + text[hero_end:]


def collapse_source_audit(text: str) -> str:
    pattern = re.compile(
        r'<section class="content-section" id="source-interpretation">.*?</section>',
        re.DOTALL,
    )
    match = pattern.search(text)
    if not match:
        return text
    old = match.group(0).replace("Source interpretation decisions", "Advanced source-fidelity notes")
    # Keep the public fragment on the outer <details>; remove it from the
    # nested section so every generated page has one unique navigation target.
    old = old.replace(' id="source-interpretation"', '', 1)
    wrapped = (
        '<details class="advanced-source-audit" id="source-interpretation">'
        '<summary>Advanced source-fidelity notes (implementation details)</summary>'
        '<p class="advanced-audit-intro">You do not need these notes to understand the theorem. They record conventions, transcription discrepancies, and full-space implementation choices for readers reproducing the source circuit.</p>'
        + old + '</details>'
    )
    return text[:match.start()] + wrapped + text[match.end():]


def enrich_case_pages(root: Path, data: dict[str, object], declarations: dict[str, dict[str, object]]) -> None:
    teaching_cases = dict(data["cases"])
    for slug, teaching in teaching_cases.items():
        path = root / "example-cases" / slug / "index.html"
        if not path.is_file():
            raise RuntimeError(f"case page missing: {slug}")
        text = path.read_text(encoding="utf-8")
        text = ensure_css(text, "../../static/casebook.css")
        if 'id="case-tutorial"' not in text:
            text = inject_after_hero(text, render_case_tutorial(slug, dict(teaching), declarations))
        text = collapse_source_audit(text)
        path.write_text(text, encoding="utf-8")


def inject_foundation_page(path: Path, fragment: str, css_href: str) -> None:
    text = path.read_text(encoding="utf-8")
    text = ensure_css(text, css_href)
    if 'id="quantum-access-models"' in text:
        path.write_text(text, encoding="utf-8")
        return
    marker = '<main id="main-content">'
    if marker not in text:
        raise RuntimeError(f"main marker missing: {path}")
    text = text.replace(marker, marker + "\n" + fragment, 1)
    path.write_text(text, encoding="utf-8")


def enrich_learning_pages(root: Path, data: dict[str, object]) -> None:
    fragment = render_foundation(data, source_map())
    inject_foundation_page(root / "learning" / "index.html", fragment, "../static/casebook.css")
    # The two application landing pages receive the same access-model comparison
    # so readers who enter via a direct link still understand the interface.
    inject_foundation_page(root / "state-preparation" / "index.html", fragment, "../static/casebook.css")
    inject_foundation_page(root / "block-encoding" / "index.html", fragment, "../static/casebook.css")


def robin_paper_tutorial(
    teaching: dict[str, object], declarations: dict[str, dict[str, object]],
) -> str:
    source = dict(teaching["source"])
    theorems = "".join(
        theorem_card(dict(item), declarations, "../") for item in teaching["theorems"]
    )
    return f"""<section class="casebook-paper-intro" id="paper-beginner-guide">
  <p class="eyebrow">Read the paper map as a quantum-algorithm story</p>
  <h2>Why does this paper build block encodings at all?</h2>
  <p class="casebook-lead">{html.escape(str(teaching['whyThisCase']))}</p>
  {source_box(source)}
  <h3>From the PDE to something a quantum circuit can simulate</h3>
  {pipeline_html(list(teaching.get('pipeline') or []))}
  <h3>Figure 4 without the notation overload</h3>
  {circuit_steps(list(teaching['circuitReading']))}
  <div class="casebook-theorem-stack">{theorems}</div>
  <aside class="casebook-bridge"><strong>{html.escape(str(teaching['benchmarkBridge']['title']))}</strong><p>{html.escape(str(teaching['benchmarkBridge']['body']))}</p></aside>
  {improvement_card(dict(teaching['improvement']), declarations, '../')}
</section>"""


def enrich_robin_paper_map(root: Path, data: dict[str, object], declarations: dict[str, dict[str, object]]) -> None:
    path = root / "case-studies" / "robin" / "index.html"
    if not path.is_file():
        raise RuntimeError("Robin paper-map page missing")
    text = path.read_text(encoding="utf-8")
    text = ensure_css(text, "../../static/casebook.css")
    tutorial = robin_paper_tutorial(dict(data["cases"]["robin-ghl-one-term"]), declarations)
    if 'id="paper-beginner-guide"' not in text:
        marker = '<main id="main-content">'
        text = text.replace(marker, marker + "\n" + tutorial, 1)
    text = collapse_source_audit(text)
    text = text.replace("homogeneous-Robin fourth-derivative matrix", "fourth-order-accurate second-derivative stencil")
    path.write_text(text, encoding="utf-8")


def enrich_example_index(root: Path, data: dict[str, object]) -> None:
    path = root / "example-cases" / "index.html"
    if not path.is_file():
        raise RuntimeError("example-case index missing")
    text = path.read_text(encoding="utf-8")
    text = ensure_css(text, "../static/casebook.css")
    if 'id="casebook-reading-order"' not in text:
        marker = '<main id="main-content">'
        guide = """<section class="casebook-reading-order" id="casebook-reading-order">
  <p class="eyebrow">New reading rule</p>
  <h2>Every case now follows the same theorem-first path</h2>
  <ol><li>Why would a quantum algorithm need this state or operator?</li><li>How should you read the circuit?</li><li>What is the exact theorem statement?</li><li>What is the proof idea in human mathematics?</li><li>Only then, optionally open the Lean checkpoints.</li><li>If ASPBE improves a circuit, the comparison theorem appears after correctness.</li></ol>
</section>"""
        text = text.replace(marker, marker + "\n" + guide, 1)
    path.write_text(text, encoding="utf-8")


def enrich(root: Path) -> None:
    data = load_json(TEACHING_PATH)
    declarations = declaration_map()
    for slug, teaching in data["cases"].items():
        for theorem in teaching.get("theorems", []):
            for root_name in theorem.get("leanRoots", []):
                if root_name not in declarations:
                    raise RuntimeError(f"unknown Lean root in case teaching: {slug}: {root_name}")
        for root_name in (teaching.get("improvement") or {}).get("leanRoots", []):
            if root_name not in declarations:
                raise RuntimeError(f"unknown Lean improvement root: {slug}: {root_name}")
    enrich_case_pages(root, data, declarations)
    enrich_learning_pages(root, data)
    enrich_robin_paper_map(root, data, declarations)
    enrich_example_index(root, data)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    enrich(args.root)


if __name__ == "__main__":
    main()
