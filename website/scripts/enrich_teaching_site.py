#!/usr/bin/env python3
"""Add concept-first textbook layers to the generated QuantumComputinglib pages.

The Lean-driven builder remains the source of proof/status pages. This pass
adds a beginner narrative above those proofs and gives readers three views:
Concept, Math, and Lean. Every chapter stays statically readable; JavaScript
only switches which already-rendered layer is visible.
"""

from __future__ import annotations

import argparse
import html
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "website" / "textbook-lessons.json"
QUOTE_SOURCE_FOR_SLUG = {
    "linear-algebra": "ibm-basics",
    "circuit-semantics": "nielsen-chuang",
    "block-encoding": "lin-notes",
    "automation-and-roadmap": "mermin",
}


def load_data() -> dict[str, object]:
    return json.loads(DATA.read_text(encoding="utf-8"))


def math_block(tex: str) -> str:
    return f'<div class="reader-formula">\\[{html.escape(tex, quote=False)}\\]</div>'


def source_cards(
    source_keys: list[str], sources: dict[str, dict[str, object]], quote_key: str | None
) -> str:
    cards: list[str] = []
    for key in source_keys:
        source = sources[key]
        quote = source.get("quote") if key == quote_key else None
        quote_html = (
            f'<blockquote>“{html.escape(str(quote))}”</blockquote>' if quote else ""
        )
        cards.append(
            f"""<article class="textbook-source">
  <p class="eyebrow">Textbook / teaching anchor</p>
  <h4><a href="{html.escape(str(source['url']), quote=True)}">{html.escape(str(source['title']))}</a></h4>
  <p class="source-authors">{html.escape(str(source['authors']))}</p>
  {quote_html}
  <p>{html.escape(str(source['role']))}</p>
</article>"""
        )
    return '<div class="textbook-source-grid">' + "".join(cards) + "</div>"


def circuit_html(circuit: dict[str, object]) -> str:
    wires: list[str] = []
    for wire in circuit.get("wires", []):
        gates = "".join(
            '<span class="learning-gate empty" aria-hidden="true"></span>'
            if not gate
            else f'<span class="learning-gate">{html.escape(str(gate))}</span>'
            for gate in wire.get("gates", [])
        )
        wires.append(
            f"""<div class="learning-wire-row">
  <span class="wire-name">{html.escape(str(wire.get('label', 'q')))}</span>
  <span class="wire-input">{html.escape(str(wire.get('input', '')))}</span>
  <span class="learning-wire"><i></i>{gates}</span>
  <span class="wire-output">{html.escape(str(wire.get('output', '')))}</span>
</div>"""
        )
    return f"""<figure class="learning-circuit">
  <figcaption>{html.escape(str(circuit.get('caption', 'Circuit intuition')))}</figcaption>
  <div class="learning-circuit-body">{''.join(wires)}</div>
</figure>"""


def steps_html(steps: list[list[str]]) -> str:
    return '<ol class="intuition-steps">' + "".join(
        f'<li><strong>{html.escape(str(title))}</strong><span>{html.escape(str(text))}</span></li>'
        for title, text in steps
    ) + "</ol>"


def mode_switch() -> str:
    return """<div class="reader-mode-switch" data-reader-mode-switch>
  <span>Reading mode</span>
  <button type="button" data-reader-mode-choice="concept" aria-pressed="true">Concept</button>
  <button type="button" data-reader-mode-choice="math" aria-pressed="false">Math</button>
  <button type="button" data-reader-mode-choice="lean" aria-pressed="false">Lean</button>
  <small>Start visually; reveal formalism only when you want it.</small>
</div>"""


def lesson_html(slug: str, lesson: dict[str, object], sources: dict[str, dict[str, object]]) -> str:
    formulas = "".join(math_block(str(tex)) for tex in lesson.get("formulas", []))
    quote_key = QUOTE_SOURCE_FOR_SLUG.get(slug)
    sources_html = source_cards(list(lesson.get("sourceKeys", [])), sources, quote_key)
    lean = lesson["leanLens"]
    return f"""<section class="concept-first-lesson" data-concept-first-lesson="{html.escape(slug)}">
  {mode_switch()}
  <div class="reader-layer" data-reader-layer="concept">
    <p class="eyebrow">{html.escape(str(lesson['eyebrow']))}</p>
    <h2>{html.escape(str(lesson['title']))}</h2>
    <p class="reader-hook">{html.escape(str(lesson['hook']))}</p>
    {circuit_html(dict(lesson['circuit']))}
    {steps_html(list(lesson['intuitionSteps']))}
    {sources_html}
  </div>
  <div class="reader-layer" data-reader-layer="math">
    <p class="eyebrow">Strict mathematics, after the picture</p>
    <h2>The equations behind the intuition</h2>
    {formulas}
    <p class="reader-note">Every symbol used here is connected below to a compiled declaration or a clearly marked research-source formula.</p>
    {sources_html}
  </div>
  <div class="reader-layer" data-reader-layer="lean">
    <p class="eyebrow">Learn Lean while learning quantum computing</p>
    <h2>{html.escape(str(lean['title']))}</h2>
    <pre class="lean-lens"><code>{html.escape(str(lean['code']))}</code></pre>
    <p>{html.escape(str(lean['explanation']))}</p>
    <p class="reader-note">The full proof-backed declarations for this chapter are shown immediately below.</p>
  </div>
</section>"""


def start_here_html(data: dict[str, object]) -> str:
    intro = dict(data["startHere"])
    sources = dict(data["sources"])
    source_html = source_cards(list(intro["sourceKeys"]), sources, None)
    return f"""<section class="start-here-lesson" id="start-here">
  <p class="eyebrow">New to quantum computing? Start here.</p>
  <h2>{html.escape(str(intro['title']))}</h2>
  <p class="reader-hook">{html.escape(str(intro['hook']))}</p>
  {math_block(str(intro['formula']))}
  {math_block(str(intro['measurementFormula']))}
  {circuit_html(dict(intro['circuit']))}
  {math_block(str(intro['bellFormula']))}
  {steps_html(list(intro['steps']))}
  <div class="callout"><strong>How to read this site.</strong> Read the circuit picture first, switch to Math when the notation feels familiar, and switch to Lean only when you want the machine-checked statement.</div>
  {source_html}
</section>"""


def ensure_learning_css(path: Path, href: str) -> str:
    text = path.read_text(encoding="utf-8")
    if "static/learning.css" not in text:
        marker = '<link rel="stylesheet" href="'
        first = text.find(marker)
        if first < 0:
            raise RuntimeError(f"stylesheet marker missing: {path}")
        end = text.find("\n", first)
        text = text[: end + 1] + f'  <link rel="stylesheet" href="{href}">\n' + text[end + 1 :]
    return text


def inject_after_main(path: Path, fragment: str, css_href: str) -> None:
    text = ensure_learning_css(path, css_href)
    marker = '<main id="main-content">'
    if marker not in text:
        raise RuntimeError(f"main marker missing: {path}")
    if "data-concept-first-lesson=" in text or 'id="start-here"' in text:
        path.write_text(text, encoding="utf-8")
        return
    text = text.replace(marker, marker + "\n" + fragment, 1)
    path.write_text(text, encoding="utf-8")


def enrich(root: Path) -> None:
    data = load_data()
    sources = dict(data["sources"])
    chapters = dict(data["chapters"])

    for slug, lesson in chapters.items():
        path = root / "chapters" / slug / "index.html"
        if not path.is_file():
            raise RuntimeError(f"chapter page missing for textbook lesson: {slug}")
        inject_after_main(path, lesson_html(slug, dict(lesson), sources), "../../static/learning.css")

    for route, slug in (("state-preparation", "state-preparation"), ("block-encoding", "block-encoding")):
        path = root / route / "index.html"
        if path.is_file():
            inject_after_main(path, lesson_html(slug, dict(chapters[slug]), sources), "../static/learning.css")

    learning = root / "learning" / "index.html"
    if not learning.is_file():
        raise RuntimeError("learning page missing")
    inject_after_main(learning, start_here_html(data), "../static/learning.css")

    home = root / "index.html"
    text = ensure_learning_css(home, "static/learning.css")
    if 'href="learning/index.html#start-here"' not in text:
        marker = '<main id="main-content">'
        callout = """<aside class="home-beginner-callout">
  <strong>Never studied quantum computing?</strong>
  <span>Begin with qubits, amplitudes, gates, circuits, and measurement before touching block encoding.</span>
  <a href="learning/index.html#start-here">Start the beginner path →</a>
</aside>"""
        text = text.replace(marker, marker + "\n" + callout, 1)
    home.write_text(text, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    enrich(args.root)


if __name__ == "__main__":
    main()
