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
PROJECT_URL = "https://github.com/DakeBU/Quantum-Computing-Block-Encoding"


def load_data() -> dict[str, object]:
    data = json.loads(DATA_PATH.read_text(encoding="utf-8"))
    if data.get("schemaVersion") != 2 or data.get("caseSlug") != CASE_SLUG:
        raise RuntimeError("unsupported Hermite insight data")
    for key in (
        "headline", "thesis", "targetFormula", "profileFormula",
        "compressionFormula", "resourceFormula", "baselineObjects",
        "question", "compressionSteps", "crossPollination", "evolution",
        "topology", "trustBoundary",
    ):
        if not data.get(key):
            raise RuntimeError(f"Hermite insight data lacks {key}")
    evolution = dict(data["evolution"])
    if len(list(evolution.get("stages", []))) < 2:
        raise RuntimeError("Hermite insight must publish baseline and structural stages")
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
    baseline = "".join(
        f"""<article class="hermite-object-card">
  <p class="eyebrow">Define this first</p>
  <h3>{html.escape(str(item['term']))}</h3>
  <div class="math-line">{inline_math(str(item['formula']))}</div>
  <p>{html.escape(str(item['body']))}</p>
</article>"""
        for item in data["baselineObjects"]
    )
    steps = "".join(
        f"""<article class="hermite-mechanism">
  <p class="eyebrow">{html.escape(str(item['tag']))}</p>
  <h3>{html.escape(str(item['title']))}</h3>
  <p>{html.escape(str(item['body']))}</p>
  <div class="math-line">{inline_math(str(item['formula']))}</div>
</article>"""
        for item in data["compressionSteps"]
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
    <p class="eyebrow">Core insight · start from the mathematical object</p>
    <h2>{html.escape(str(data['headline']))}</h2>
    <p class="hermite-insight-thesis">{html.escape(str(data['thesis']))}</p>
    {math_block(str(data['targetFormula']))}
  </div>
  <section class="hermite-insight-section hermite-baseline" id="hermite-baseline-objects">
    <div class="section-heading">
      <p class="eyebrow">What the reference method actually stores</p>
      <h2>“Amplitude list” and “mass tree” are concrete objects, not jargon</h2>
      <p>The reference construction is easiest to understand if we name the two objects that make it generic.</p>
    </div>
    <div class="hermite-object-grid">{baseline}</div>
    <div class="hermite-question"><strong>The structural question.</strong> {html.escape(str(data['question']))}</div>
  </section>
  <section class="hermite-insight-section" id="hermite-compression">
    <div class="section-heading">
      <p class="eyebrow">What is special about this family?</p>
      <h2>The samples come from one short piecewise function</h2>
      <p>Before discussing MPS, bond dimension or compilation, keep the source formula visible:</p>
    </div>
    {math_block(str(data['profileFormula']))}
    <div class="hermite-compression-arrow" aria-hidden="true">preserve this structure while reading the address bits ↓</div>
    <div class="hermite-mechanism-grid">{steps}</div>
    <div class="hermite-compression-conclusion">
      <strong>The compression theorem in one line</strong>
      {math_block(str(data['compressionFormula']), 'math-line')}
      <p>The matrices are local updates selected by the address bits. The important number is the internal width {inline_math('D=2k+6')}, not the number {inline_math('2^{n_p}')} of output amplitudes.</p>
    </div>
  </section>
  <section class="hermite-insight-section" id="hermite-cross-pollination">
    <div class="section-heading">
      <p class="eyebrow">Mathematical cross-pollination</p>
      <h2>Each field supplies one indispensable interface</h2>
      <p>The proof is not “use MPS” as a black box. It changes representation four times, and each change preserves a precise invariant.</p>
    </div>
    <div class="hermite-field-flow">{fields}</div>
    <div class="hermite-result-box"><strong>Certified quantum consequence</strong>{math_block(str(data['resourceFormula']), 'math-line')}</div>
    <aside class="hermite-trust"><strong>Certified boundary.</strong> {html.escape(str(data['trustBoundary']))}</aside>
    <div class="hermite-topology-link"><a class="button" href="../../lean-graph/index.html#hermite-topology">See the proof-topology contribution</a><span>BRIDGE · SHORTCUT · HUB · REORGANIZATION</span></div>
  </section>
</section>"""


def render_contract(data: dict[str, object]) -> str:
    return f"""<div class="hermite-contract-reading">
  <strong>Exact source profile.</strong>
  {math_block(str(data['profileFormula']), 'math-line')}
  <strong>Prepared state.</strong>
  {math_block(str(data['targetFormula']), 'math-line')}
  <strong>Certified quantum resource statement.</strong>
  {math_block(str(data['resourceFormula']), 'math-line')}
  <p>The samples themselves are amplitudes, not probabilities. The construction uses zero oracle calls and no postselection, and the bond register is clean at output. The exact-real quantum bound is certified separately from finite-bit implementation cost.</p>
</div>"""


def render_circuit_reading() -> str:
    steps = [
        (
            "Two registers have different jobs",
            "The data register has " + inline_math("n_p") + " output qubits. The bond register has "
            + inline_math("q=\\lceil\\log_2(2k+6)\\rceil")
            + " temporary qubits and must return to " + inline_math("|0^q\\rangle") + ".",
        ),
        (
            "One local stage emits one address bit",
            "The symbolic tensor train is read most-significant-bit first. Stage "
            + inline_math("V_s") + " updates the small bond state and emits the next data bit; it does not look up an entry in a length-"
            + inline_math("2^{n_p}") + " table.",
        ),
        (
            "The bond stores function state, not sample values",
            "For the tails the update is scalar. For the polynomial branch it carries Bernstein coefficients plus boundary bookkeeping. Before binary padding the total internal dimension is "
            + inline_math("D=2k+6") + ".",
        ),
        (
            "Local algebra becomes elementary gates",
            "Thin LQ/canonicalization makes each stage an isometry; reachable columns are completed to a real unitary and compiled to "
            + inline_math("R_y") + " and CNOT gates. The final bond sector is clean.",
        ),
    ]
    rendered = "".join(
        f'<article><span>{index}</span><div><strong>{title}</strong><p>{body}</p></div></article>'
        for index, (title, body) in enumerate(steps, start=1)
    )
    formula = math_block(
        r"|0^{n_p}\rangle|0^q\rangle\xrightarrow{\;V_1V_2\cdots V_{n_p}\;}|g_k\rangle|0^q\rangle",
        "casebook-formula",
    )
    return f"""<section class="casebook-subsection hermite-circuit-reading">
  <p class="eyebrow">Read the new circuit first</p>
  <h2>Follow the data register and the reusable bond register</h2>
  {formula}
  <div class="casebook-circuit-guide">{rendered}</div>
  <p class="casebook-pointer">The historical mass-tree/UCRY circuit is retained below as the reference construction. The certified evolution panel shows both routes side by side.</p>
</section>"""


def render_evolution_flow(flow: list[object]) -> str:
    items: list[str] = []
    for index, raw in enumerate(flow):
        label, formula = list(raw)
        if index:
            items.append('<span class="hermite-evolution-arrow" aria-hidden="true">→</span>')
        items.append(
            '<span class="hermite-evolution-node">'
            f'<small>{html.escape(str(label))}</small>'
            f'<strong>{inline_math(str(formula))}</strong></span>'
        )
    return '<div class="hermite-evolution-flow">' + "".join(items) + '</div>'


def render_evolution(data: dict[str, object]) -> str:
    evolution = dict(data["evolution"])
    stages = []
    for stage in evolution["stages"]:
        commit = str(stage["commit"])
        stages.append(f"""<article class="hermite-evolution-stage">
  <div class="hermite-evolution-meta">
    <p class="eyebrow">{html.escape(str(stage['label']))}</p>
    <h3>{html.escape(str(stage['short']))}</h3>
    <dl>
      <div><dt>Certified</dt><dd>{html.escape(str(stage['certifiedAt']))}</dd></div>
      <div><dt>Repository elapsed</dt><dd>{html.escape(str(stage['elapsed']))}</dd></div>
      <div><dt>Commit</dt><dd><a href="{PROJECT_URL}/commit/{html.escape(commit)}"><code>{html.escape(commit[:12])}</code></a></dd></div>
    </dl>
  </div>
  <p class="hermite-evolution-scope"><strong>Scope.</strong> {html.escape(str(stage['scope']))}</p>
  {math_block(str(stage['scoreFormula']), 'hermite-evolution-score')}
  <p>{html.escape(str(stage['reading']))}</p>
  <div class="hermite-logical-circuit">
    <p class="eyebrow">Logical dataflow</p>
    {render_evolution_flow(list(stage['flow']))}
    {math_block(str(stage['circuitFormula']), 'hermite-circuit-formula')}
  </div>
  <a class="theorem-root" href="../../library/index.html"><span>Lean root</span><code>{html.escape(str(stage['leanRoot']))}</code></a>
</article>""")
    return f"""<section class="content-section hermite-certified-evolution" id="evolution">
  <div class="section-heading">
    <p class="eyebrow">Auditable evolution · certified milestones</p>
    <h2>{html.escape(str(evolution['title']))}</h2>
    <p>The project keeps the usual score order {inline_math('(\\text{gates},\\text{depth},\\text{auxiliary qubits},\\text{oracle calls})')}, but it does not compare unlike scopes as if they were one finite benchmark.</p>
  </div>
  <div class="hermite-evolution-provenance"><strong>What “time to solution” means here.</strong> {html.escape(str(evolution['provenance']))}</div>
  <div class="hermite-evolution-grid">{''.join(stages)}</div>
  <div class="callout warning"><strong>Comparison boundary.</strong> {html.escape(str(evolution['comparisonBoundary']))}</div>
</section>"""


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
    <article class="hermite-topology-lane old"><p class="eyebrow">Reference factorization</p><h3>Expand first, then synthesize</h3>{_route(list(topo['oldRoute']))}</article>
    <article class="hermite-topology-lane new"><p class="eyebrow">Structure-aware factorization</p><h3>Preserve the source representation until local compilation</h3>{_route(list(topo['newRoute']))}</article>
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
    """Typeset reviewed Hermite prose while never rewriting source/code panels."""
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
        ("degree-at-most 2k+1", r"degree at most \(2k+1\)"),
        ("width 2k+6", r"width \(2k+6\)"),
        ("A_k keeps the first k+1 coefficients of exp(t)/(1−t)^(k+1).", r"\(A_k\) keeps the first \(k+1\) coefficients of \(\exp(t)/(1-t)^{k+1}\)."),
        ("A factor t^(k+1) kills the first k derivatives at t=0.", r"A factor \(t^{k+1}\) kills the first \(k\) derivatives at \(t=0\)."),
        ("Reflect t to 1−t", r"Reflect \(t\) to \(1-t\)"),
        ("t^(k+1)(1−t)^(k+1)", r"\(t^{k+1}(1-t)^{k+1}\)"),
        ("through order k", r"through order \(k\)"),
        ("For every natural k, n_p at least 1 and positive L", r"For every natural \(k\), \(n_p\ge1\) and \(L>0\)"),
        ("D states", r"\(D\) states"),
        ("Fixed k", r"Fixed \(k\)"),
        ("in n_p", r"in \(n_p\)"),
        ("For k=1, P''(0)=−10+8/e", r"For \(k=1\), \(P''(0)=-10+8/e\)"),
        ("second derivative 1", r"second derivative \(1\)"),
        ("q0 is the low bit. Label j is the sum of 2^r q_r; the rightmost bit in a ket is q0.", r"\(q_0\) is the low bit. The label is \(j=\sum_r2^r q_r\); the rightmost bit in a ket is \(q_0\)."),
        ("At layer d, the already prepared low bits choose an angle on qubit qd.", r"At layer \(d\), the already prepared low bits choose an angle on qubit \(q_d\)."),
        (">k, n, L<", r">\(k,n,L\)<"),
        (">g_k(p_j)<", r">\(g_k(p_j)\)<"),
        (">m(d,s)<", r">\(m_{d,s}\)<"),
        (">UCRY_0<", r">\(\mathrm{UCRY}_0\)<"),
        (">UCRY_1<", r">\(\mathrm{UCRY}_1\)<"),
        (">UCRY_(n−1)<", r">\(\mathrm{UCRY}_{n-1}\)<"),
        (">|g_k&gt;<", r">\(|g_k\rangle\)<"),
        ("Example k=1, n=3, L=1", r"Example \(k=1\), \(n=3\), \(L=1\)"),
    )
    parts = protected.split(text)
    for index in range(0, len(parts), 2):
        for old, new in replacements:
            parts[index] = parts[index].replace(old, new)
    return "".join(parts)


def replace_circuit_reading(text: str) -> str:
    pattern = re.compile(
        r'<section class="casebook-subsection">\s*'
        r'<p class="eyebrow">Read the circuit</p>.*?</section>',
        re.DOTALL,
    )
    if not pattern.search(text):
        raise RuntimeError("Hermite tutorial circuit-reading section missing")
    return pattern.sub(lambda _match: render_circuit_reading(), text, count=1)


def replace_evolution(text: str, data: dict[str, object]) -> str:
    pattern = re.compile(
        r'<section class="content-section" id="evolution">.*?</section>',
        re.DOTALL,
    )
    if not pattern.search(text):
        raise RuntimeError("Hermite evolution section missing")
    return pattern.sub(lambda _match: render_evolution(data), text, count=1)


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
    if 'class="hermite-circuit-reading"' not in text:
        text = replace_circuit_reading(text)
    if 'class="content-section hermite-certified-evolution"' not in text:
        text = replace_evolution(text, data)
    contract = re.compile(r'<p class="contract-reading">.*?</p>', re.DOTALL)
    if contract.search(text):
        text = contract.sub(lambda _match: render_contract(data), text, count=1)
    if '<div class="case-status-line">' in text:
        status_pattern = re.compile(r'(<div class="case-status-line">.*?<span>).*?(</span></div>)', re.DOTALL)
        summary = (
            "Prepare the same state with internal width "
            + inline_math("D=2k+6")
            + ": for fixed "
            + inline_math("k")
            + ", the certified exact-real quantum bound grows linearly with "
            + inline_math("n_p")
            + " rather than with the "
            + inline_math("2^{n_p}")
            + " amplitudes."
        )
        text = status_pattern.sub(
            lambda match: match.group(1) + summary + match.group(2), text, count=1
        )
    text = text.replace(
        "Their joint input is |g_k&gt; tensor |u_0&gt;.",
        "Their joint input is "
        + inline_math(r"\lvert g_k\rangle_p\otimes\lvert u_0\rangle")
        + ".",
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
