#!/usr/bin/env python3
"""Build QuantumComputinglib from the ASPBE Lean inventory and teaching content."""

from __future__ import annotations

import argparse
import datetime as dt
import html
import json
import os
import re
import shutil
import subprocess
import sys
from collections import Counter
from pathlib import Path
from urllib.parse import quote


ROOT = Path(__file__).resolve().parents[2]
WEBSITE_ROOT = ROOT / "website"
sys.path.insert(0, str(WEBSITE_ROOT))

from content import (  # noqa: E402
    CHAPTERS,
    IMPLEMENTATION_MAP,
    LESSONS,
    ROADMAP,
    STATUS_ORDER,
    WORKFLOW_STAGES,
)


NAVIGATION = [
    ("Home", ""),
    ("Book map", "learning/"),
    ("Lean library", "library/"),
    ("Implementation map", "implementation-map/"),
    ("Robin paper map", "case-studies/robin/"),
    ("Live workspace", "ide/"),
    ("Run with your API", "task-builder/"),
    ("Quantum ecosystem", "ecosystem/"),
    ("Progress", "roadmap/"),
    ("Contribute", "community/"),
    ("Contributors", "contributors/"),
    ("Organizers", "organizers/"),
]


def run_git(*args: str) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip() if result.returncode == 0 else ""


def github_repository(remote: str) -> str | None:
    patterns = [
        r"^https://github\.com/(?P<repo>[^/]+/[^/]+?)(?:\.git)?$",
        r"^git@github\.com:(?P<repo>[^/]+/[^/]+?)(?:\.git)?$",
        r"^ssh://git@github\.com/(?P<repo>[^/]+/[^/]+?)(?:\.git)?$",
    ]
    for pattern in patterns:
        match = re.match(pattern, remote)
        if match:
            return match.group("repo")
    return None


def git_context() -> dict[str, object]:
    commit = run_git("rev-parse", "HEAD")
    short_commit = run_git("rev-parse", "--short=12", "HEAD")
    branch = run_git("branch", "--show-current") or os.getenv("GITHUB_REF_NAME", "detached")
    remote = run_git("remote", "get-url", "origin")
    repository = github_repository(remote)
    remote_branches = run_git("branch", "-r", "--contains", commit).splitlines()
    github_sha = os.getenv("GITHUB_SHA", "")
    published = bool(
        commit
        and repository
        and (
            any(line.strip().startswith("origin/") for line in remote_branches)
            or github_sha == commit
        )
    )
    return {
        "commit": commit,
        "shortCommit": short_commit,
        "branch": branch,
        "remote": remote,
        "repository": repository,
        "publishedRef": published,
    }


def path_is_clean(path: str) -> bool:
    return not run_git("status", "--porcelain", "--", path)


def path_exists_at_head(path: str) -> bool:
    result = subprocess.run(
        ["git", "cat-file", "-e", f"HEAD:{path}"],
        cwd=ROOT,
        check=False,
        capture_output=True,
    )
    return result.returncode == 0


def external_source_url(
    source: str, line: int, context: dict[str, object]
) -> str | None:
    repository = context["repository"]
    commit = context["commit"]
    if (
        not context["publishedRef"]
        or not repository
        or not commit
        or not path_is_clean(source)
        or not path_exists_at_head(source)
    ):
        return None
    return f"https://github.com/{repository}/blob/{commit}/{quote(source)}#L{line}"


def slug(text: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")


def module_slug(source: str) -> str:
    return slug(source.removeprefix("QuantumBlockEncoding/").removesuffix(".lean"))


def declaration_anchor(full_name: str) -> str:
    return f"decl-{slug(full_name)}"


def status_class(status: str) -> str:
    return f"status status-{slug(status)}"


def badge(status: str) -> str:
    return f'<span class="{status_class(status)}">{html.escape(status)}</span>'


def prefix_for(route: str) -> str:
    depth = len([part for part in route.strip("/").split("/") if part])
    return "../" * depth if depth else "./"


def page_url(prefix: str, route: str) -> str:
    return f"{prefix}{route}index.html" if route else f"{prefix}index.html"


def module_url(prefix: str, declaration: dict[str, object]) -> str:
    source = str(declaration["source"])
    return (
        f"{prefix}library/modules/{module_slug(source)}/"
        f"index.html#{declaration_anchor(str(declaration['fullName']))}"
    )


def blueprint_url(prefix: str, declaration: dict[str, object]) -> str:
    target = str(declaration["blueprintUrl"]).removeprefix("../")
    return f"{prefix}{target}"


def load_json(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


def parse_literature_registry() -> list[dict[str, str]]:
    source = (ROOT / "QuantumBlockEncoding" / "Literature.lean").read_text(
        encoding="utf-8"
    )
    entries: list[dict[str, str]] = []
    for block in re.findall(r"\{\s*key := .*?\n\s*\}", source, flags=re.S):
        item: dict[str, str] = {}
        for field in ("key", "title", "authors", "targetFile", "url", "note"):
            match = re.search(field + r' := "([^"]*)"', block)
            if match:
                item[field] = match.group(1)
        for field, pattern in (
            ("year", r"year := ([0-9]+)"),
            ("role", r"role := PaperRole\.([A-Za-z]+)"),
            ("status", r"status := ImplementationStatus\.([A-Za-z]+)"),
        ):
            match = re.search(pattern, block)
            if match:
                item[field] = match.group(1)
        if "key" in item:
            entries.append(item)
    return entries


def load_gate_report(path: Path, context: dict[str, object]) -> dict[str, object]:
    if not path.exists():
        raise SystemExit(
            f"Lean gate report is missing: {path}. Run the Lean gate before publishing."
        )
    report = load_json(path)
    if report.get("commit") != context["commit"] or report.get("passed") is not True:
        raise SystemExit("Lean gate report does not certify the current checkout.")
    return report


def source_statement(preview: str) -> str:
    lines = preview.splitlines()
    kept: list[str] = []
    for line in lines:
        kept.append(line)
        if ":= by" in line or line.rstrip().endswith(":= by"):
            break
        if line.strip() in {"sorry", "by"}:
            break
        if len(kept) >= 11:
            break
    return "\n".join(kept)


def site_header(prefix: str, current: str) -> str:
    links: list[str] = []
    for label, route in NAVIGATION:
        current_attr = ' aria-current="page"' if current == route else ""
        links.append(
            f'<a href="{page_url(prefix, route)}"{current_attr}>{html.escape(label)}</a>'
        )
    chapter_links = []
    for chapter in CHAPTERS:
        route = f"chapters/{chapter['slug']}/"
        current_attr = ' aria-current="page"' if current == route else ""
        chapter_links.append(
            f'<a href="{page_url(prefix, route)}"{current_attr}>'
            f'<span>{int(chapter["number"]):02d}</span>'
            f'{html.escape(str(chapter["title"]))}</a>'
        )
    return f"""
<a class="skip-link" href="#main-content">Skip to content</a>
<header class="mobile-header">
    <a class="brand" href="{page_url(prefix, '')}">
      <span class="brand-word">QuantumComputinglib</span>
      <span class="brand-subtitle">learn · inspect · formalize</span>
    </a>
    <button class="icon-button mobile-menu" type="button" data-menu-button
            aria-label="Open book navigation" aria-expanded="false">&#9776;</button>
</header>
<aside class="site-sidebar" data-main-nav aria-label="QuantumComputinglib book navigation">
  <div class="sidebar-head">
    <a class="brand" href="{page_url(prefix, '')}">
      <span class="brand-word">QuantumComputinglib</span>
      <span class="brand-subtitle">A formal quantum computing textbook</span>
    </a>
    <p><strong>ASPBE</strong><br>Automatic State Preparation and Block Encoding for Quantum Computing</p>
  </div>
  <div class="sidebar-search search-shell">
    <label class="visually-hidden" for="global-search">Search declarations and chapters</label>
    <input id="global-search" class="global-search" type="search"
           placeholder="Search QuantumComputinglib" data-global-search>
    <div class="search-results" data-search-results hidden></div>
  </div>
  <nav class="book-nav">
    <strong class="nav-group-label">Explore</strong>
    {''.join(links)}
    <strong class="nav-group-label">Chapters</strong>
    <div class="chapter-nav">{''.join(chapter_links)}</div>
    <strong class="nav-group-label">Reference</strong>
    <a href="{page_url(prefix, 'workflow/')}">ASPBE harness</a>
    <a href="{page_url(prefix, 'blueprint/')}">Verso Blueprint</a>
  </nav>
  <div class="sidebar-footer">
    <div class="theme-switcher" aria-label="Reading style">
      <button type="button" data-theme-choice="blueprint" aria-pressed="true">Book</button>
      <button type="button" data-theme-choice="modern" aria-pressed="false">Sans</button>
      <button type="button" data-theme-choice="bold" aria-pressed="false">High contrast</button>
    </div>
  </div>
</aside>"""


def verification_strip(
    prefix: str,
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    return f"""
<div class="verification-strip">
  <div class="verification-inner">
    <strong>Checked on this commit</strong>
    <span>{int(coverage['publicDeclarationCount']):,} public declarations</span>
    <span>commit <code>{html.escape(str(context['shortCommit']))}</code></span>
    <a href="{prefix}build-report.json">Build record</a>
  </div>
</div>"""


def page_template(
    *,
    title: str,
    route: str,
    current: str,
    body: str,
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
    toc: list[tuple[str, str]] | None = None,
    description: str = "QuantumComputinglib: a formal quantum computing textbook and the ASPBE Lean library",
    extra_scripts: tuple[str, ...] = (),
) -> str:
    prefix = prefix_for(route)
    toc_html = ""
    shell_class = "page-shell"
    if toc:
        toc_html = (
            '<aside class="toc" aria-label="On this page"><strong>On this page</strong>'
            + "".join(
                f'<a href="#{html.escape(anchor)}">{html.escape(label)}</a>'
                for anchor, label in toc
            )
            + "</aside>"
        )
    else:
        shell_class += " no-toc"
    extra_script_html = "".join(
        f'<script src="{prefix}{html.escape(path)}"></script>' for path in extra_scripts
    )
    return f"""<!doctype html>
<html lang="en" data-theme="blueprint">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="{html.escape(description)}">
  <title>{html.escape(title)} | QuantumComputinglib</title>
  <link rel="icon" href="{prefix}static/favicon.svg" type="image/svg+xml">
  <link rel="stylesheet" href="{prefix}static/site.css">
  <script>
    window.MathJax = {{
      tex: {{inlineMath: [['\\\\(', '\\\\)']], displayMath: [['\\\\[', '\\\\]']]}},
      options: {{skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']}}
    }};
  </script>
  <script defer src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>
<body data-site-root="{prefix}">
  {site_header(prefix, current)}
  {verification_strip(prefix, coverage, gate, context)}
  <div class="{shell_class}">
    <main id="main-content">{body}</main>
    {toc_html}
  </div>
  <footer class="site-footer">
    <div><strong>QuantumComputinglib</strong> · Generated from the current ASPBE Lean inventory.</div>
    <nav aria-label="Footer">
      <a href="{page_url(prefix, 'implementation-map/')}">Implementation map</a>
      <a href="{page_url(prefix, 'workflow/')}">ASPBE harness</a>
      <a href="{page_url(prefix, 'blueprint/')}">Verso Blueprint</a>
      <a href="{page_url(prefix, 'attribution/')}">Attribution</a>
    </nav>
  </footer>
  <script src="{prefix}static/site.js"></script>
  {extra_script_html}
  <script type="module">
    import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
    if (window.matchMedia("(max-width: 760px)").matches) {{
      document.querySelectorAll(".mermaid").forEach((node) => {{
        node.textContent = node.textContent.replace(/^flowchart LR/m, "flowchart TB");
      }});
    }}
    mermaid.initialize({{
      startOnLoad: true,
      securityLevel: "strict",
      theme: "base",
      flowchart: {{curve: "linear", htmlLabels: true}},
      themeVariables: {{
        primaryColor: "#eaf1f2",
        primaryTextColor: "#1e2c36",
        primaryBorderColor: "#007e84",
        lineColor: "#71868e",
        secondaryColor: "#ffffff",
        tertiaryColor: "#f4f7f8",
        fontFamily: "system-ui, sans-serif"
      }}
    }});
  </script>
</body>
</html>
"""


def diagram(prefix: str, name: str, title: str) -> str:
    source = (WEBSITE_ROOT / "diagrams" / f"{name}.mmd").read_text(encoding="utf-8")
    return f"""
<figure class="diagram-panel" id="diagram-{html.escape(name)}">
  <figcaption class="diagram-toolbar">
    <strong>{html.escape(title)}</strong>
    <a href="{prefix}diagrams/{html.escape(name)}.mmd">editable Mermaid source</a>
  </figcaption>
  <pre class="mermaid">{html.escape(source)}</pre>
</figure>"""


TRACK_ORDER = (
    "Shared foundations",
    "State preparation",
    "Block encoding",
    "System and evidence",
)


def render_chapter_groups(
    link_prefix: str, tracks: tuple[str, ...] = TRACK_ORDER
) -> str:
    groups: list[str] = []
    for track in tracks:
        chapters = [chapter for chapter in CHAPTERS if chapter["track"] == track]
        links = "".join(
            f"""
<a class="chapter-link" href="{link_prefix}chapters/{chapter['slug']}/index.html">
  <span class="chapter-number">{int(chapter['number']):02d}</span>
  <span class="chapter-copy">
    <strong>{html.escape(str(chapter['title']))}</strong>
    <span>{html.escape(str(chapter['summary']))}</span>
  </span>
  <span class="chapter-arrow" aria-hidden="true">&#8594;</span>
</a>"""
            for chapter in chapters
        )
        groups.append(
            f'<section class="reading-track"><h3>{html.escape(track)}</h3>'
            f'<div class="chapter-list">{links}</div></section>'
        )
    return '<div class="reading-tracks">' + "".join(groups) + "</div>"


def render_gate_examples() -> str:
    return r"""
<div class="gate-example-grid" aria-label="One-qubit state-preparation examples">
  <article class="gate-example state-example">
    <div class="wire" aria-hidden="true"><span>|0&gt;</span><b>H</b><span>|+&gt;</span></div>
    <h3>Hadamard prepares a superposition</h3>
    <div class="example-math">\(H|0\rangle=(|0\rangle+|1\rangle)/\sqrt{2}\)</div>
    <p>The two computational-basis amplitudes have equal magnitude.</p>
  </article>
  <article class="gate-example x-example">
    <div class="wire" aria-hidden="true"><span>|0&gt;</span><b>X</b><span>|1&gt;</span></div>
    <h3>Pauli X swaps the basis states</h3>
    <div class="example-math">\(X|0\rangle=|1\rangle,\quad X|1\rangle=|0\rangle\)</div>
    <p>This is a basis-state preparation, not an arbitrary superposition.</p>
  </article>
</div>"""


def render_home(
    inventory: dict[str, object],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    prefix = "./"
    declarations = inventory["declarations"]
    experimental = sum(bool(item["experimental"]) for item in declarations)
    open_proofs = sum(bool(item.get("openProof")) for item in declarations)
    body = rf"""
<section class="hero home-hero">
  <p class="eyebrow">Formal quantum computing, read alongside Lean</p>
  <h1>QuantumComputinglib</h1>
  <p class="lede">QuantumComputinglib is the textbook and declaration browser for ASPBE.
  ASPBE studies two different construction problems. State preparation
  asks a unitary to produce one target state. Block encoding asks a larger unitary
  to expose a target operator through a clean ancilla block. This site keeps their
  contracts, proof routes, and completion status separate.</p>
  <div class="hero-actions">
    <a class="button state-button" href="state-preparation/index.html">Start with state preparation</a>
    <a class="button block-button" href="block-encoding/index.html">Study block encoding</a>
    <a class="text-link" href="learning/index.html">See the full reading guide &#8594;</a>
  </div>
</section>
<section class="content-section" id="applications">
  <div class="section-heading">
    <p class="eyebrow">Choose the problem first</p>
    <h2>Two applications, two acceptance contracts</h2>
    <p>The problems share finite matrix foundations and the same proof discipline,
    but neither is presented as a special case of the other.</p>
  </div>
  <div class="application-paths">
    <article class="application-path state-path">
      <p class="path-label">Application 1</p>
      <h3>State preparation</h3>
      <div class="contract-equation">\[U|0^n\rangle=|\psi\rangle\]</div>
      <p>Fix a normalized target state, construct a unitary, and prove that its
      action on the all-zero state gives exactly those amplitudes.</p>
      <a href="state-preparation/index.html">Read the state-preparation route &#8594;</a>
    </article>
    <article class="application-path block-path">
      <p class="path-label">Application 2</p>
      <h3>Block encoding</h3>
      <div class="contract-equation">\[\Pi U\Pi^\dagger=A/\alpha\]</div>
      <p>Fix an operator, normalization, ancilla convention, and register order;
      then prove that the projected block of a larger unitary has the requested value.</p>
      <a href="block-encoding/index.html">Read the block-encoding route &#8594;</a>
    </article>
  </div>
</section>
<section class="content-section process-section state-section" id="state-process">
  <div class="section-heading">
    <p class="eyebrow">State-preparation workflow</p>
    <h2>From a target vector to a preparation certificate</h2>
    <p>Normalization, unitarity, and state action are separate obligations. The
    first-column identity is the matrix form of the same state-action equation.</p>
  </div>
  {diagram(prefix, "state-preparation-flow", "State-preparation proof and export flow")}
</section>
<section class="content-section process-section block-section" id="block-process">
  <div class="section-heading">
    <p class="eyebrow">Block-encoding workflow</p>
    <h2>From an operator contract to a clean-block certificate</h2>
    <p>This route introduces choices that state preparation does not need: ancilla
    count, a clean projector, register layout, normalization \(\alpha\), and an
    exact or approximate block norm.</p>
  </div>
  {diagram(prefix, "block-encoding-flow", "Block-encoding proof and export flow")}
</section>
<section class="content-section" id="evidence">
  <div class="section-heading">
    <p class="eyebrow">Current checkout</p>
    <h2>What this build actually certifies</h2>
  </div>
  <div class="metric-strip">
    <div class="metric"><strong>{int(coverage['publicDeclarationCount']):,}</strong><span>explicit public declarations</span></div>
    <div class="metric"><strong>{int(coverage['sourceDocstringCount']):,}</strong><span>source docstrings</span></div>
    <div class="metric"><strong>{experimental:,}</strong><span>experimental declarations</span></div>
    <div class="metric"><strong>{open_proofs:,}</strong><span>explicit incomplete proofs</span></div>
    <div class="metric"><strong>{len(CHAPTERS)}</strong><span>guided learning chapters</span></div>
  </div>
  <p class="evidence-note"><strong>Compiled</strong> means the Lean and test gates
  passed on commit <code>{html.escape(str(context['shortCommit']))}</code>. A contract
  record may compile even when a concrete construction route is still partial; the
  site shows those two statuses separately.</p>
</section>
<section class="content-section" id="pipeline">
  <div class="section-heading">
    <p class="eyebrow">Shared evidence discipline</p>
    <h2>What happens after either contract is fixed</h2>
    <p>ASPBE explores candidates, records why routes fail, and lets Lean decide
    formal promotion. A Qiskit check is useful finite evidence after certification;
    it does not prove a symbolic family.</p>
  </div>
  {diagram(prefix, "certificate-pipeline", "Shared certification and feedback loop")}
</section>
<section class="content-section" id="use">
  <div class="section-heading">
    <p class="eyebrow">Use the project</p>
    <h2>Read, formalize, or submit a construction</h2>
    <p>The public site is not only a declaration catalog. It keeps the original
    user-facing task builder, the local-compilation workspace, and the reviewed
    contribution route beside the textbook.</p>
  </div>
  <div class="use-paths">
    <article><span>Read</span><h3>Learn from a checked chapter</h3><p>Follow a formula from its physical meaning to the exact Lean declaration.</p><a href="learning/index.html">Open the book map &#8594;</a></article>
    <article><span>Formalize</span><h3>Compare LaTeX and Lean</h3><p>Edit a theorem, inspect dependencies, and compile temporary code with the local companion.</p><a href="ide/index.html">Open the workspace &#8594;</a></article>
    <article><span>Run</span><h3>Build an ASPBE task packet</h3><p>Describe a target state or operator, choose a harness, and export a reproducible task packet.</p><a href="task-builder/index.html">Open the task builder &#8594;</a></article>
  </div>
</section>
<section class="content-section" id="news">
  <div class="section-heading">
    <p class="eyebrow">Project record</p>
    <h2>News and auditable priority</h2>
    <p>The dates below are repository milestones. They do not replace the
    generated proof-status pages.</p>
  </div>
  <ol class="milestone-list">
    <li><time datetime="2026-08-10">10 August 2026</time><div><strong>ASPBE and QuantumComputinglib.</strong><p>The two application tracks, local workspace, task builder, and contributor review path are presented in one site.</p></div></li>
    <li><time datetime="2026-07">July 2026</time><div><strong>Blueprint and Library Explorer.</strong><p>One generated inventory now drives the checked Blueprint catalog and searchable declaration browser.</p></div></li>
    <li><time datetime="2026-06">June 2026</time><div><strong>Public testing preview.</strong><p>The site exposed separate State Preparation and Block Encoding directions and the user task builder.</p></div></li>
    <li><time datetime="2026-05-17">17 May 2026</time><div><strong>Earliest repository record.</strong><p>The <a href="https://github.com/DakeBU/Quantum-Computing-Block-Encoding/commit/af59b03c58c2cedec52b14a80b4d909031d62521">initial commit</a> and <a href="https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/af59b03c58c2cedec52b14a80b4d909031d62521/MANIFEST.md">timestamped manifest</a> begin the public, auditable project history. No earlier date is asserted without evidence.</p></div></li>
  </ol>
</section>
<section class="content-section" id="chapters">
  <div class="section-heading">
    <p class="eyebrow">Reading guide</p>
    <h2>Follow one application without losing the shared foundations</h2>
  </div>
  {render_chapter_groups('')}
</section>
<section class="content-section" id="navigation">
  <div class="section-heading">
    <p class="eyebrow">Audit the source</p>
    <h2>Explanation, inventory, and checked Blueprint</h2>
    <p>The chapters teach selected results. The Library Explorer inventories every
    explicit public declaration. The Verso Blueprint resolves its Lean references
    during the build.</p>
  </div>
  <div class="link-row">
    <a class="button secondary" href="implementation-map/index.html">Implementation map</a>
    <a class="button secondary" href="library/index.html">Library Explorer</a>
    <a class="button secondary" href="blueprint/html-multi/index.html">Verso Blueprint</a>
    <a class="text-link" href="task-builder/index.html">Task builder &#8594;</a>
  </div>
</section>"""
    toc = [
        ("applications", "Two applications"),
        ("state-process", "State preparation"),
        ("block-process", "Block encoding"),
        ("evidence", "Build evidence"),
        ("pipeline", "Shared verification"),
        ("use", "Use the project"),
        ("news", "News"),
        ("chapters", "Learning chapters"),
        ("navigation", "Source views"),
    ]
    return page_template(
        title="Overview",
        route="",
        current="",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=toc,
    )


def render_state_preparation(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    body = rf"""
<section class="hero application-hero state-hero">
  <p class="eyebrow">Application 1</p>
  <h1>State preparation</h1>
  <p class="lede">Given a normalized target \(|\psi\rangle\), construct a unitary
  \(U\) that sends the all-zero state to it. ASPBE treats this as its own synthesis
  and proof problem, with its own exact and approximate acceptance predicates.</p>
  <div class="hero-contract">\[U|0^n\rangle=|\psi\rangle\]</div>
</section>
<section class="content-section" id="first-example">
  <div class="section-heading">
    <p class="eyebrow">One qubit is enough to see the contract</p>
    <h2>Two familiar gates, two concrete targets</h2>
    <p>The Hadamard statement is correct: it prepares the equal superposition from
    \(|0\rangle\). Pauli \(X\) exchanges \(|0\rangle\) and \(|1\rangle\).</p>
  </div>
  {render_gate_examples()}
</section>
<section class="content-section" id="preparation-flow">
  <div class="section-heading">
    <p class="eyebrow">Independent proof route</p>
    <h2>What ASPBE has to establish</h2>
    <p>The target must be normalized. The proposed matrix must be unitary. Finally,
    its action on the zero ket, equivalently its first column, must match every
    target amplitude.</p>
  </div>
  {diagram('../', 'state-preparation-flow', 'State-preparation proof and export flow')}
</section>
<section class="content-section" id="certificate-anatomy">
  <div class="section-heading">
    <p class="eyebrow">Certificate anatomy</p>
    <h2>Three facts travel together</h2>
  </div>
  <dl class="concept-list">
    <div><dt>Normalized target</dt><dd>The requested amplitude vector has unit norm.</dd></div>
    <div><dt>Unitary candidate</dt><dd>The circuit matrix preserves inner products, not merely the first column.</dd></div>
    <div><dt>State action</dt><dd>Applying the candidate to \(|0^n\rangle\) returns the requested vector.</dd></div>
  </dl>
  <p>A preparation circuit may later become a PREPARE component in an LCU or
  purification construction. That downstream block-encoding theorem remains a
  separate proof obligation.</p>
</section>
<section class="content-section" id="state-reading">
  <div class="section-heading">
    <p class="eyebrow">Continue reading</p>
    <h2>State-preparation chapters</h2>
  </div>
  {render_chapter_groups('../', ('State preparation',))}
</section>"""
    return page_template(
        title="State preparation",
        route="state-preparation/",
        current="state-preparation/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[
            ("first-example", "One-qubit examples"),
            ("preparation-flow", "Proof route"),
            ("certificate-anatomy", "Certificate anatomy"),
            ("state-reading", "Chapters"),
        ],
    )


def render_block_encoding(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    body = rf"""
<section class="hero application-hero block-hero">
  <p class="eyebrow">Application 2</p>
  <h1>Block encoding</h1>
  <p class="lede">Given an operator \(A\), place the scaled operator inside a
  larger unitary. The contract says exactly which ancilla block is selected and
  how normalization and approximation are interpreted.</p>
  <div class="hero-contract">\[\left\|A-\alpha\Pi U\Pi^\dagger\right\|\le\varepsilon\]</div>
</section>
<section class="content-section" id="block-contract">
  <div class="section-heading">
    <p class="eyebrow">Read the notation before the circuit</p>
    <h2>Four choices determine the contract</h2>
  </div>
  <dl class="concept-list block-concepts">
    <div><dt>Ancillas</dt><dd>Extra qubits make room for the larger unitary and are projected onto a declared clean state.</dd></div>
    <div><dt>Register order</dt><dd>The index convention identifies which matrix rows and columns form the signal block.</dd></div>
    <div><dt>Normalization \(\alpha\)</dt><dd>The selected block represents \(A/\alpha\), so the scale is part of correctness.</dd></div>
    <div><dt>Error \(\varepsilon\)</dt><dd>Exact encoding has zero error; approximate routes must name both a norm and a tolerance.</dd></div>
  </dl>
</section>
<section class="content-section" id="encoding-flow">
  <div class="section-heading">
    <p class="eyebrow">Independent proof route</p>
    <h2>What ASPBE has to establish</h2>
    <p>A candidate is not accepted because one small matrix looks right. The layout,
    unitarity, projected block, scale, and declared resource record are checked as
    separate obligations.</p>
  </div>
  {diagram('../', 'block-encoding-flow', 'Block-encoding proof and export flow')}
</section>
<section class="content-section" id="connection">
  <div class="section-heading">
    <p class="eyebrow">A useful connection, not an identification</p>
    <h2>Where prepared states can help</h2>
  </div>
  <p>A certified state-preparation circuit can supply a PREPARE oracle for an LCU,
  Gram, or purification-based construction. Its first-column theorem becomes a
  dependency; it does not by itself prove the clean-block identity.</p>
  <div class="link-row">
    <a class="button block-button" href="../chapters/block-encoding/index.html">Read the block contract</a>
    <a class="button secondary" href="../chapters/classic-routes/index.html">Compare construction routes</a>
    <a class="text-link" href="../chapters/certified-cases/index.html">See certified cases &#8594;</a>
  </div>
</section>"""
    return page_template(
        title="Block encoding",
        route="block-encoding/",
        current="block-encoding/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[
            ("block-contract", "Contract terms"),
            ("encoding-flow", "Proof route"),
            ("connection", "Prepared-state inputs"),
        ],
    )


def result_card(
    result: dict[str, object],
    declaration: dict[str, object],
    prefix: str,
) -> str:
    dependencies = []
    for dependency in result["dependencies"]:
        dependencies.append(f"<code>{html.escape(str(dependency))}</code>")
    steps = "".join(
        "<tr>"
        f"<td>{html.escape(natural)}</td>"
        f"<td><code>{html.escape(lean)}</code></td>"
        "</tr>"
        for natural, lean in result["correspondence"]
    )
    external = declaration.get("sourceUrl")
    source_links = (
        f'<a href="{html.escape(str(external))}">commit-pinned GitHub source</a>'
        if external
        else "<span class=\"muted\">No external source link: this file is not publishable at the detected ref.</span>"
    )
    return f"""
<article class="result" id="{declaration_anchor(str(result['declaration']))}">
  <div class="result-header">
    <div>
      <p class="eyebrow">Lean result</p>
      <h3>{html.escape(str(result['title']))}</h3>
      <code class="declaration-name">{html.escape(str(result['declaration']))}</code>
    </div>
    <div class="status-pair">
      <span><small>Declaration</small>{badge(str(result['local_status']))}</span>
      <span><small>Full route</small>{badge(str(result['route_status']))}</span>
    </div>
  </div>
  <div class="math-block">\\[{html.escape(str(result['math']))}\\]</div>
  <div class="result-story">
    <section>
      <h4>What it says</h4>
      <p>{html.escape(str(result['plain']))}</p>
    </section>
    <section>
      <h4>Why it matters</h4>
      <p>{html.escape(str(result['intuition']))} {html.escape(str(result['why']))}</p>
    </section>
    <section>
      <h4>How the proof goes</h4>
      <p>{html.escape(str(result['proof_idea']))}</p>
    </section>
  </div>
  <dl class="result-notes">
    <div><dt>Uses</dt><dd>{'; '.join(dependencies)}</dd></div>
    <div><dt>Still outside this result</dt><dd>{html.escape(str(result['missing']))}</dd></div>
  </dl>
  <h4 class="proof-heading">Natural-language steps and Lean objects</h4>
  <table class="proof-steps">
    <thead><tr><th>Mathematical step</th><th>Lean object or step</th></tr></thead>
    <tbody>{steps}</tbody>
  </table>
  <details class="source-panel">
    <summary>Open the Lean statement and source links</summary>
    <pre><code>{html.escape(source_statement(str(declaration['sourcePreview'])))}</code></pre>
    <p>
      <a href="{module_url(prefix, declaration)}">Local declaration</a> ·
      <a href="{blueprint_url(prefix, declaration)}">Verso Blueprint</a> ·
      {source_links}
    </p>
  </details>
</article>"""


def load_robin_paper_map(
    declarations: dict[str, dict[str, object]],
) -> dict[str, object]:
    data = load_json(WEBSITE_ROOT / "robin-paper-map.json")
    missing: list[str] = []
    for row in data["rows"]:
        for status_key in ("localStatus", "routeStatus"):
            if row[status_key] not in STATUS_ORDER:
                raise SystemExit(
                    f"Unknown Robin paper-map status: {row[status_key]}"
                )
        for name in row["declarations"]:
            if name not in declarations:
                missing.append(str(name))
    if missing:
        raise SystemExit(
            "Robin paper map names declarations absent from inventory:\n  "
            + "\n  ".join(sorted(set(missing)))
        )
    return data


def render_robin_paper_map(
    data: dict[str, object],
    declarations: dict[str, dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    route = "case-studies/robin/"
    prefix = prefix_for(route)
    paper = data["paper"]
    rows: list[str] = []
    toc = [
        ("paper-contract", "Paper contract"),
        ("how-to-read", "How to read the map"),
    ]
    for row in data["rows"]:
        row_id = str(row["id"])
        toc.append((row_id, str(row["paperAnchor"])))
        declaration_links: list[str] = []
        statement_panels: list[str] = []
        for name in row["declarations"]:
            declaration = declarations[str(name)]
            declaration_links.append(
                f'<li><a href="{module_url(prefix, declaration)}">'
                f'<code>{html.escape(str(name))}</code></a></li>'
            )
            statement_panels.append(
                f"""<details class="source-panel">
  <summary>{html.escape(str(name))}</summary>
  <pre><code>{html.escape(source_statement(str(declaration['sourcePreview'])))}</code></pre>
  <p><a href="{module_url(prefix, declaration)}">Open local declaration</a> ·
  <a href="{blueprint_url(prefix, declaration)}">Open in the Verso Blueprint</a></p>
</details>"""
            )
        rows.append(
            f"""<article class="result paper-correspondence" id="{html.escape(row_id)}">
  <div class="result-header">
    <div>
      <p class="eyebrow">{html.escape(str(row['paperAnchor']))}</p>
      <h3>{html.escape(str(row['plain']))}</h3>
    </div>
    <div class="status-pair">
      <span><small>Local declarations</small>{badge(str(row['localStatus']))}</span>
      <span><small>Paper-wide route</small>{badge(str(row['routeStatus']))}</span>
    </div>
  </div>
  <div class="math-block">\\[{html.escape(str(row['latex']))}\\]</div>
  <div class="paper-reading">
    <h4>What Lean currently establishes</h4>
    <p>{html.escape(str(row['reading']))}</p>
  </div>
  <h4>Corresponding declarations</h4>
  <ul class="declaration-list">{''.join(declaration_links)}</ul>
  <details class="source-panel paper-latex">
    <summary>Show the paper-side LaTeX</summary>
    <pre><code>{html.escape(str(row['latex']))}</code></pre>
  </details>
  {''.join(statement_panels)}
</article>"""
        )
    body = f"""
<section class="hero" id="paper-contract">
  <p class="eyebrow">Paper reproduction · source-to-Lean reading map</p>
  <h1>Robin one-term block encoding</h1>
  <p class="lede">Read the construction in the paper's order, then inspect the
  exact Lean structures used to represent each step. This page presents the
  compiled baseline before any claim of resource evolution.</p>
  <div class="link-row">
    <a class="button" href="{html.escape(str(paper['url']))}">Open the source paper</a>
    <a class="button secondary" href="{prefix}sources/ghl2025-robin-excerpts.tex">Download the LaTeX excerpts</a>
  </div>
</section>
<section class="content-section" id="how-to-read">
  <div class="section-heading">
    <p class="eyebrow">Status discipline</p>
    <h2>A compiled declaration is not automatically the paper theorem</h2>
  </div>
  <p>The left badge says that the named Lean object compiles in this checkout.
  The right badge says whether the entire paper route is closed. Contract
  records, transcript equalities, finite diagnostics, and counterexamples are
  valuable formal results, but they do not replace the final projected-block
  theorem.</p>
  <div class="callout warning">
    <strong>Current conclusion.</strong>
    The register model, theorem data, indicator unitary, circuit transcript,
    many finite projection lemmas, and a decisive counterexample compile.
    The paper-wide gate-level construction remains partial because several
    oracle semantics and the boundary rotation convention are still external
    or blocked.
  </div>
</section>
<section class="content-section paper-map" id="correspondence">
  <div class="section-heading">
    <p class="eyebrow">{html.escape(str(paper['shortName']))}</p>
    <h2>Paper statement to Lean structure</h2>
    <p>Expand a row to compare the source LaTeX, the exact Lean statement, and
    its location in the Library Explorer and Blueprint.</p>
  </div>
  {''.join(rows)}
</section>"""
    return page_template(
        title="Robin paper map",
        route=route,
        current=route,
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=toc,
        description=(
            "Guseynov-Huang-Liu Robin block-encoding statements mapped to "
            "compiled ASPBE Lean declarations and open paper-route obligations."
        ),
    )


def render_textbook_lesson(slug: str) -> str:
    lesson = LESSONS[slug]
    objectives = "".join(
        f"<li>{html.escape(str(item))}</li>" for item in lesson["objectives"]
    )
    sections = "".join(
        f"""<article class="lesson-step">
  <h3>{html.escape(str(title))}</h3>
  <div class="lesson-equation">\\[{html.escape(str(math))}\\]</div>
  <p>{html.escape(str(explanation))}</p>
</article>"""
        for title, math, explanation in lesson["sections"]
    )
    return f"""
<section class="content-section textbook-lesson" id="lesson">
  <div class="lesson-opening">
    <div>
      <p class="eyebrow">Textbook lesson</p>
      <h2>Build the idea before opening the proof</h2>
      <p class="lesson-lead">{html.escape(str(lesson['lead']))}</p>
    </div>
    <aside class="lesson-objectives" aria-label="Learning objectives">
      <h3>By the end</h3>
      <ul>{objectives}</ul>
    </aside>
  </div>
  <div class="lesson-steps">{sections}</div>
  <div class="lesson-checkpoint">
    <strong>Check your understanding</strong>
    <p>{html.escape(str(lesson['checkpoint']))}</p>
  </div>
  <p class="source-note">Mathematical order and conventions adapted from Lin,
  <a href="https://arxiv.org/abs/2201.08309">Lecture Notes on Quantum Algorithms for Scientific Computation</a>.
  The formal checkpoints and ASPBE status distinctions are specific to this library.</p>
</section>"""


def render_chapter(
    chapter: dict[str, object],
    declarations: dict[str, dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    route = f"chapters/{chapter['slug']}/"
    prefix = prefix_for(route)
    result_html = []
    toc = [
        ("orientation", "Orientation"),
        ("lesson", "Textbook lesson"),
        ("dependency-view", "Route at a glance"),
    ]
    for item in chapter["results"]:
        declaration = declarations[str(item["declaration"])]
        result_html.append(result_card(item, declaration, prefix))
        toc.append((declaration_anchor(str(item["declaration"])), str(item["title"])))
    modules = "".join(f"<li><code>{html.escape(module)}</code></li>" for module in chapter["modules"])
    body = f"""
<section class="hero" id="orientation">
  <p class="eyebrow">{html.escape(str(chapter['track']))} · Chapter {chapter['number']} of {len(CHAPTERS)}</p>
  <h1>{html.escape(str(chapter['title']))}</h1>
  <p class="lede">{html.escape(str(chapter['summary']))}</p>
  <details class="module-list">
    <summary>Lean modules used in this chapter</summary>
    <ul>{modules}</ul>
  </details>
</section>
{render_textbook_lesson(str(chapter['slug']))}
<section class="content-section" id="dependency-view">
  <div class="section-heading">
    <p class="eyebrow">Route at a glance</p>
    <h2>Where these results sit</h2>
  </div>
  {diagram(prefix, str(chapter['diagram']), f"{chapter['track']}: {chapter['title']}")}
</section>
<section class="content-section" id="important-results">
  <div class="section-heading">
    <p class="eyebrow">Selected declarations</p>
    <h2>Read the mathematics beside the Lean statement</h2>
    <p>The declaration badge reports what compiles locally. The route badge reports
    whether the larger construction is complete.</p>
  </div>
  {''.join(result_html)}
</section>"""
    return page_template(
        title=str(chapter["title"]),
        route=route,
        current=route,
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=toc,
        description=str(chapter["summary"]),
    )


def render_learning(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    body = f"""
<section class="hero">
  <p class="eyebrow">Guided reading</p>
  <h1>One foundation, two application tracks</h1>
  <p class="lede">Learn the finite matrix and circuit conventions once. Then follow
  State Preparation or Block Encoding as a separate construction problem. The final
  chapters explain how ASPBE searches, verifies, exports, and reports both.</p>
  <div class="hero-actions">
    <a class="button state-button" href="../state-preparation/index.html">State-preparation guide</a>
    <a class="button block-button" href="../block-encoding/index.html">Block-encoding guide</a>
  </div>
</section>
<section class="content-section" id="reading-map">
  <div class="section-heading">
    <p class="eyebrow">Reading map</p>
    <h2>The tracks meet only where the mathematics really meets</h2>
    <p>A prepared state can supply a component to some block-encoding routes. The
    acceptance contracts remain distinct.</p>
  </div>
  {diagram("../", "learning-path", "Shared foundations and separate application tracks")}
</section>
<section class="content-section" id="chapter-list">
  {render_chapter_groups('../')}
</section>"""
    return page_template(
        title="Guided learning",
        route="learning/",
        current="learning/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[("reading-map", "Reading map"), ("chapter-list", "All chapters")],
    )


def render_implementation_map(
    declarations: dict[str, dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    prefix = "../"
    chapter_tracks = {
        str(chapter["slug"]): str(chapter["track"]) for chapter in CHAPTERS
    }
    grouped_rows: dict[str, list[str]] = {track: [] for track in TRACK_ORDER}
    for item in IMPLEMENTATION_MAP:
        declaration = declarations[str(item["declaration"])]
        track = chapter_tracks[str(item["chapter"])]
        grouped_rows[track].append(
            f"""<tr>
  <td>{html.escape(str(item['goal']))}</td>
  <td>\\({html.escape(str(item['contract']))}\\)</td>
  <td>{html.escape(str(item['obligation']))}</td>
  <td><a href="{module_url(prefix, declaration)}"><code>{html.escape(str(item['declaration']))}</code></a></td>
  <td><code>{html.escape(str(declaration['source']))}:{int(declaration['line'])}</code></td>
  <td>{html.escape(str(item['dependencies']))}</td>
  <td>{badge(str(item['status']))}</td>
  <td>{html.escape(str(item['missing']))}</td>
  <td><a href="../chapters/{html.escape(str(item['chapter']))}/index.html">chapter</a> ·
      <a href="{blueprint_url(prefix, declaration)}">Blueprint</a></td>
</tr>"""
        )
    tables = []
    for track in TRACK_ORDER:
        if not grouped_rows[track]:
            continue
        tables.append(
            f"""
<section class="map-group">
  <h2>{html.escape(track)}</h2>
  <div class="table-wrap">
    <table class="data-table">
      <thead><tr>
        <th>Mathematical goal</th><th>Contract</th><th>Proof obligation</th>
        <th>Lean declaration</th><th>Module / line</th><th>Dependencies</th>
        <th>Status</th><th>Missing step</th><th>Reader links</th>
      </tr></thead>
      <tbody>{''.join(grouped_rows[track])}</tbody>
    </table>
  </div>
</section>"""
        )
    body = f"""
<section class="hero">
  <p class="eyebrow">Generated links · Curated route status</p>
  <h1>Implementation Map</h1>
  <p class="lede">Trace a mathematical statement to the exact Lean declaration,
  source line, dependencies, current status, and work that remains. The map is
  grouped by the same learning tracks used throughout the site.</p>
</section>
<section class="content-section map-groups">
  {''.join(tables)}
</section>"""
    return page_template(
        title="Implementation Map",
        route="implementation-map/",
        current="implementation-map/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def declaration_status(declaration: dict[str, object]) -> str:
    return str(declaration["localStatus"])


def render_library(
    inventory: dict[str, object],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    declarations = inventory["declarations"]
    kinds = sorted({str(item["kind"]) for item in declarations})
    catalogs = sorted({str(item["catalog"]) for item in declarations})
    statuses = [status for status in STATUS_ORDER if any(declaration_status(item) == status for item in declarations)]
    options = lambda values: "".join(
        f'<option value="{html.escape(value)}">{html.escape(value)}</option>'
        for value in values
    )
    rows = []
    for declaration in declarations:
        search = " ".join(
            str(declaration.get(field, ""))
            for field in ("fullName", "readerLabel", "plainEnglish", "source", "catalog")
        ).lower()
        rows.append(
            f"""
<article class="declaration-row" data-declaration-row
  data-search="{html.escape(search, quote=True)}"
  data-kind="{html.escape(str(declaration['kind']), quote=True)}"
  data-catalog="{html.escape(str(declaration['catalog']), quote=True)}"
  data-status="{html.escape(declaration_status(declaration), quote=True)}">
  <div>
    <h3><a href="{module_url('../', declaration)}"><code>{html.escape(str(declaration['fullName']))}</code></a></h3>
    <p>{html.escape(str(declaration['plainEnglish']))}</p>
  </div>
  <div class="status-pair">{badge(declaration_status(declaration))}{badge(str(declaration['routeStatus']))}</div>
</article>"""
        )
    body = f"""
<section class="hero">
  <p class="eyebrow">Lean Declaration Catalog / Library Explorer</p>
  <h1>Search every explicit public declaration</h1>
  <p class="lede">The inventory is generated from <code>QuantumBlockEncoding/</code>.
  Private declarations follow the repository's existing exclusion rule and are
  counted in the build report, not displayed as public API.</p>
</section>
<section class="content-section" data-library>
  <div class="filter-bar">
    <label><span class="visually-hidden">Search library</span>
      <input type="search" placeholder="Name, source, docstring, catalog" data-library-query>
    </label>
    <label><span class="visually-hidden">Declaration kind</span>
      <select data-library-kind><option value="">All kinds</option>{options(kinds)}</select>
    </label>
    <label><span class="visually-hidden">Catalog</span>
      <select data-library-catalog><option value="">All catalogs</option>{options(catalogs)}</select>
    </label>
    <label><span class="visually-hidden">Local status</span>
      <select data-library-status><option value="">All local statuses</option>{options(statuses)}</select>
    </label>
  </div>
  <p class="muted" data-library-count>{len(declarations):,} declarations shown</p>
  <div class="declaration-list">{''.join(rows)}</div>
</section>"""
    return page_template(
        title="Lean Library Explorer",
        route="library/",
        current="library/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def render_module_page(
    source: str,
    declarations: list[dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    route = f"library/modules/{module_slug(source)}/"
    prefix = prefix_for(route)
    entries = []
    for declaration in declarations:
        external = declaration.get("sourceUrl")
        external_html = (
            f'<a href="{html.escape(str(external))}">commit-pinned source</a>'
            if external
            else '<span class="muted">No publishable external source link</span>'
        )
        entries.append(
            f"""
<article class="module-declaration" id="{declaration_anchor(str(declaration['fullName']))}">
  <div class="result-header">
    <div>
      <p class="eyebrow">{html.escape(str(declaration['kind']))} · line {int(declaration['line'])}</p>
      <h3><code>{html.escape(str(declaration['fullName']))}</code></h3>
    </div>
    <div class="status-pair">
      {badge(declaration_status(declaration))}
      {badge(str(declaration['routeStatus']))}
    </div>
  </div>
  <p>{html.escape(str(declaration['plainEnglish']))}</p>
  <pre><code>{html.escape(source_statement(str(declaration['sourcePreview'])))}</code></pre>
  <p>{external_html} · <a href="{blueprint_url(prefix, declaration)}">Verso Blueprint panel</a></p>
</article>"""
        )
    body = f"""
<section class="hero">
  <p class="eyebrow">Lean source module</p>
  <h1><code>{html.escape(source)}</code></h1>
  <p class="lede">{len(declarations):,} explicit public declarations in source order.</p>
  <a class="button secondary" href="{prefix}library/index.html">Back to Library Explorer</a>
</section>
<section class="content-section">
  {''.join(entries)}
</section>"""
    return page_template(
        title=source,
        route=route,
        current="library/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def render_roadmap(
    inventory: dict[str, object],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    route_counts = Counter(str(item["routeStatus"]) for item in inventory["declarations"])
    rows = "".join(
        f"<tr><td>{html.escape(label)}</td><td>{badge(status)}</td></tr>"
        for label, status in ROADMAP
    )
    stats = "".join(
        f'<div class="metric"><strong>{route_counts.get(status, 0):,}</strong><span>{html.escape(status)} route labels</span></div>'
        for status in STATUS_ORDER
    )
    literature_status = {
        "formalized": "Compiled",
        "skeleton": "Partial route",
        "planned": "Planned",
    }
    literature_rows = "".join(
        f"""<tr>
  <td>{badge(literature_status.get(item.get('status', ''), 'Experimental'))}</td>
  <td><a href="{html.escape(item.get('url', ''), quote=True)}">{html.escape(item.get('title', 'Untitled'))}</a><br><span class="muted">{html.escape(item.get('authors', ''))} ({html.escape(item.get('year', ''))})</span></td>
  <td><code>{html.escape(item.get('role', ''))}</code></td>
  <td><code>{html.escape(item.get('targetFile', ''))}</code><br>{html.escape(item.get('note', ''))}</td>
</tr>"""
        for item in parse_literature_registry()
    )
    body = f"""
<section class="hero">
  <p class="eyebrow">Progress and Roadmap</p>
  <h1>Local proof completion is not route completion</h1>
  <p class="lede">Counts below are generated from the declaration inventory.
  Milestones are curated against the actual modules and openly name partial,
  experimental, planned, and blocked work.</p>
</section>
<section class="content-section">
  <div class="metric-grid">{stats}</div>
  {diagram("../", "roadmap", "Milestone status and open routes")}
  <div class="table-wrap">
    <table class="data-table">
      <thead><tr><th>Milestone</th><th>Broader route status</th></tr></thead>
      <tbody>{rows}</tbody>
    </table>
  </div>
</section>
<section class="content-section" id="paper-reproduction-queue">
  <div class="section-heading">
    <p class="eyebrow">Paper reproduction queue</p>
    <h2>What has been reproduced, and what has not</h2>
    <p>This table is generated from the Lean-compiled literature registry. A
    compiled local lemma does not promote a paper-wide route unless its circuit,
    oracle, projection, normalization, and resource obligations are all closed.</p>
  </div>
  <div class="table-wrap">
    <table class="data-table">
      <thead><tr><th>Status</th><th>Paper</th><th>Role</th><th>Target and next step</th></tr></thead>
      <tbody>{literature_rows}</tbody>
    </table>
  </div>
</section>
<section class="content-section" id="memory-transfer-protocol">
  <div class="section-heading">
    <p class="eyebrow">Planned longitudinal experiment</p>
    <h2>Does a larger certified memory actually help?</h2>
  </div>
  <p>Each newly reproduced paper adds memory cards only after its named Lean
  roots compile. Earlier cold and warm benchmarks are then replayed in fresh,
  isolated worktrees with the same model, prompt budget, target, tolerance
  ladder, and acceptance gates. We compare solve rate, accepted-cycle count,
  token proxy, wall time, and invalid-route count. Historical run artifacts are
  never injected into the cold arm.</p>
</section>"""
    return page_template(
        title="Progress and Roadmap",
        route="roadmap/",
        current="roadmap/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def render_workflow(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    steps = "".join(
        f'<article class="workflow-step"><h3>{html.escape(title)}</h3><p>{html.escape(text)}</p></article>'
        for title, text in WORKFLOW_STAGES
    )
    body = f"""
<section class="hero">
  <p class="eyebrow">ASPBE harness</p>
  <h1>Search, prove, validate, and retain evidence</h1>
  <p class="lede">The upper layer controls decomposition and budget; the middle
  layer maintains a diverse population and feedback; focused workers discharge
  bounded obligations. Tolerance is relaxed by an explicit schedule, not silently.</p>
</section>
<section class="content-section">
  {diagram("../", "candidate-lifecycle", "Candidate generation, scoring, verification, and acceptance")}
  <div class="workflow-list">{steps}</div>
  <div class="callout"><strong>Evidence boundary.</strong> Harness declarations
  formalize controller data and acceptance policy. They do not prove that an
  external agent run was efficient. Run logs, token accounting, and Qiskit outputs
  remain engineering evidence attached after the Lean gate.</div>
</section>"""
    return page_template(
        title="ASPBE harness",
        route="workflow/",
        current="workflow/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def render_organizers(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    people = (
        ("Dake Bu", "City University of Hong Kong · A*STAR"),
        ("Xiajie Huang", "Shanghai Jiao Tong University"),
        ("Nana Liu", "Shanghai Jiao Tong University"),
        ("Atsushi Nitanda", "A*STAR · Nanyang Technological University"),
        ("Hau-san Wong", "City University of Hong Kong"),
        ("Qingfu Zhang", "City University of Hong Kong"),
    )
    cards = "".join(
        f'<article class="person-row"><h3>{html.escape(name)}</h3>'
        f'<p>{html.escape(affiliation)}</p></article>'
        for name, affiliation in people
    )
    body = f"""
<section class="hero" id="organizers">
  <p class="eyebrow">People</p>
  <h1>Organizers</h1>
  <p class="lede">QuantumComputinglib is maintained with ASPBE by the current project
  authors. Contributor credit is recorded separately and follows each accepted
  lemma or teaching contribution.</p>
</section>
<section class="content-section" id="team">
  <div class="people-list">{cards}</div>
</section>
<section class="content-section" id="credits">
  <h2>Contributor credit</h2>
  <p>New contributors choose a preferred public credit line in their lemma
  packet. Integration keeps the mathematical source, compiler evidence, and
  contributor attribution together.</p>
  <a class="button secondary" href="../community/index.html">Submit a contribution</a>
</section>"""
    return page_template(
        title="Organizers",
        route="organizers/",
        current="organizers/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[("organizers", "Organizers"), ("team", "Current authors"), ("credits", "Contributor credit")],
    )


def render_ecosystem(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    body = """
<section class="hero" id="ecosystem">
  <p class="eyebrow">Quantum Lean ecosystem</p>
  <h1>One reading map, honest dependency boundaries</h1>
  <p class="lede">QuantumComputinglib brings ASPBE declarations, selected external
  quantum-formalization references, and textbook explanations into one map.
  “Indexed” does not mean “imported”: every row states how the source is used.</p>
</section>
<section class="content-section" id="catalog">
  <h2>Libraries represented in QuantumComputinglib</h2>
  <div class="ecosystem-list">
    <article><div><h3>ASPBE</h3><p>State preparation, block encoding, finite circuit semantics, construction routes, resource records, automation, and certified cases.</p></div><span class="status status-compiled">Built here</span></article>
    <article><div><h3>Mathlib</h3><p>Finite types, matrices, algebra, norms, finite sums, and proof infrastructure used by the local Lean package.</p></div><span class="status status-compiled">Imported</span></article>
    <article><div><h3><a href="https://github.com/duckki/quantum-computing-lean">quantum-computing-lean</a></h3><p>Named states, gates, projectors, gate actions, decompositions, and compact finite-dimensional module organization.</p></div><span class="status status-partial-route">Reference atlas</span></article>
    <article><div><h3><a href="https://github.com/Timeroot/Lean-QuantumInfo">Lean-QuantumInfo</a></h3><p>Finite-dimensional quantum and classical information, channels, distributions, entropy, and capacity.</p></div><span class="status status-partial-route">Reference atlas</span></article>
    <article><div><h3><a href="https://github.com/Hayata-Yamasaki-Group/lean-quantum">lean-quantum</a></h3><p>Quantum states, channels, qudits, operator conventions, and higher-level quantum-information semantics.</p></div><span class="status status-partial-route">Reference atlas</span></article>
  </div>
</section>
<section class="content-section" id="policy">
  <h2>How an external result enters the library</h2>
  <ol class="numbered-reading">
    <li><strong>Reference.</strong> Record the upstream repository, license, module, and exact declaration.</li>
    <li><strong>Adapter.</strong> State the narrow ASPBE bridge without copying incompatible APIs.</li>
    <li><strong>Compile.</strong> Import or prove the adapter under the pinned toolchain.</li>
    <li><strong>Teach.</strong> Add the formula, plain-language reading, assumptions, and source link.</li>
  </ol>
  <p>This prevents a survey entry or theorem card from appearing as a locally
  compiled result.</p>
</section>"""
    return page_template(
        title="Quantum Lean ecosystem",
        route="ecosystem/",
        current="ecosystem/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[("ecosystem", "Ecosystem"), ("catalog", "Libraries"), ("policy", "Import policy")],
    )


def render_community(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    repository = context.get("repository") or "DakeBU/Quantum-Computing-Block-Encoding"
    issue_url = f"https://github.com/{repository}/issues/new?template=lemma-contribution.yml"
    pull_url = f"https://github.com/{repository}/compare"
    body = f"""
<section class="hero" id="contribute">
  <p class="eyebrow">Contribute to QuantumComputinglib</p>
  <h1>Bring one sourced statement to one checked Lean declaration</h1>
  <p class="lede">Submit teaching corrections, external-library mappings, or
  new state-preparation and block-encoding lemmas. Large changes begin with a
  proposal so assumptions and module ownership are agreed before proof work.</p>
  <div class="hero-actions">
    <a class="button state-button" href="../ide/index.html">Draft in the live workspace</a>
    <a class="button secondary" href="{html.escape(issue_url)}">Open a lemma proposal</a>
    <a class="text-link" href="{html.escape(pull_url)}">Prepare a pull request &#8594;</a>
  </div>
</section>
<section class="content-section" id="before">
  <h2>Before writing Lean</h2>
  <p>A small correction or isolated lemma can go directly to a pull request.
  Start with a proposal when the work adds a module, dependency, public API,
  mathematical contract, or substantial construction route.</p>
  <div class="contribution-paths">
    <article><span>01</span><h3>Fix the scope</h3><p>Record the source, exact statement, conventions, owning module, and whether the wider route is complete.</p></article>
    <article><span>02</span><h3>Reuse before adding</h3><p>Search the declaration catalog and external atlas. Prefer a narrow adapter to a duplicate API.</p></article>
    <article><span>03</span><h3>Choose the evidence class</h3><p>Separate a Lean certificate, finite executable check, imported contract, and exploratory argument.</p></article>
  </div>
</section>
<section class="content-section" id="steps">
  <h2>Four steps from idea to an indexed contribution</h2>
  <ol class="contributor-steps">
    <li><span>1</span><div><h3>Scope</h3><p>Agree on the mathematical boundary, source, conventions, owner module, and public API.</p></div></li>
    <li><span>2</span><div><h3>Develop</h3><p>Add the smallest focused declaration. Do not use <code>sorry</code>, <code>admit</code>, a new <code>axiom</code>, or a weakened placeholder proposition.</p></div></li>
    <li><span>3</span><div><h3>Verify</h3><pre><code>lake build
lake build ABEISTests
python3 tools/qbe.py check
bash scripts/build-all.sh</code></pre><p>Report a gate you could not run; do not mark it passed.</p></div></li>
    <li><span>4</span><div><h3>Submit and receive credit</h3><p>Open a focused PR with source, API choices, local and route status, exact gate results, and preferred public credit.</p></div></li>
  </ol>
  <p>Read the repository-wide <a href="../CONTRIBUTING.md">contribution policy</a>
  and <a href="../contributors/index.html">integrated contributor record</a>.</p>
</section>
<section class="content-section" id="packet">
  <h2>Workspace packet and pull request serve different stages</h2>
  <p>The workspace exports a versioned JSON packet for discussion and review.
  A pull request carries the implementation. Neither marks itself integrated:
  maintainers check mathematical equivalence, assumptions, API fit, provenance,
  license, and the complete ASPBE gate.</p>
  <p><a href="contribution.schema.json">Machine-readable packet schema</a> ·
  <a href="{html.escape(issue_url)}">Open a proposal</a> ·
  <a href="{html.escape(pull_url)}">Open a pull request</a></p>
</section>
<section class="content-section" id="status">
  <h2>Status words are not interchangeable</h2>
  <div class="status-key">
    <p><span class="status status-planned">Proposed</span> statement or code awaits review.</p>
    <p><span class="status status-partial-route">Lean checked</span> the submitted snippet compiled locally.</p>
    <p><span class="status status-compiled">Integrated</span> the declaration passed the repository gate and entered the generated inventory.</p>
  </div>
</section>"""
    return page_template(
        title="Contribute",
        route="community/",
        current="community/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[("contribute", "Contribute"), ("before", "Before you begin"), ("steps", "Four steps"), ("packet", "Packet and PR"), ("status", "Statuses")],
    )


def render_contributors(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    data = load_json(WEBSITE_ROOT / "community" / "contributors.json")
    contributors = data.get("contributors", [])
    records = []
    for contributor in contributors:
        items = "".join(
            f"<li>{html.escape(str(item))}</li>"
            for item in contributor.get("contributions", [])
        )
        records.append(
            '<article class="contributor-record">'
            f'<h3>{html.escape(str(contributor["name"]))}</h3>'
            f'<p>{html.escape(str(contributor.get("credit", "")))}</p>'
            f'<ul>{items}</ul></article>'
        )
    if not records:
        records.append(
            '<article class="contributor-record contributor-invitation">'
            '<p class="eyebrow">Your name here</p>'
            '<h3>The first external integrated contribution is open</h3>'
            '<p>Accepted theorem, adapter, chapter, validation, and tooling work '
            'will be listed with a precise contribution summary and preferred credit.</p>'
            '<a href="../community/index.html">Read the contribution process &#8594;</a>'
            '</article>'
        )
    body = f"""
<section class="hero" id="contributors">
  <p class="eyebrow">People whose work has entered the repository</p>
  <h1>Contributors</h1>
  <p class="lede">This page lists integrated external contributions, not open
  proposals or locally compiling drafts. Organizers are listed separately.</p>
</section>
<section class="content-section" id="accepted-work">
  <h2>Integrated work</h2>
  <div class="contributor-list">{''.join(records)}</div>
</section>
<section class="content-section" id="recognition">
  <h2>How credit is recorded</h2>
  <p>Each accepted entry names the contributor and the concrete theorem,
  chapter, adapter, executable check, or tool improvement that entered the
  repository. Commit authorship and co-authorship are preserved in Git.</p>
  <a class="button secondary" href="../community/index.html">Become a contributor</a>
</section>"""
    return page_template(
        title="Contributors",
        route="contributors/",
        current="contributors/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[("contributors", "Contributors"), ("accepted-work", "Integrated work"), ("recognition", "Credit")],
    )


def workspace_items(
    declarations: dict[str, dict[str, object]],
) -> list[dict[str, object]]:
    items: list[dict[str, object]] = []
    for chapter in CHAPTERS:
        for result in chapter["results"]:
            declaration = declarations[str(result["declaration"])]
            dependencies = []
            for name in result["dependencies"]:
                dependency = declarations.get(str(name))
                dependencies.append(
                    {
                        "name": str(name),
                        "url": module_url("../", dependency) if dependency else "",
                    }
                )
            local_url = module_url("../", declaration)
            items.append(
                {
                    "name": str(declaration["fullName"]),
                    "chapter": str(chapter["title"]),
                    "plain": str(result["plain"]),
                    "latex": rf"\[{result['math']}\]",
                    "statement": source_statement(str(declaration["sourcePreview"])),
                    "module": str(declaration["source"])
                    .removesuffix(".lean")
                    .replace("/", "."),
                    "url": local_url,
                    "source_url": declaration.get("sourceUrl") or local_url,
                    "dependencies": dependencies,
                    "compile_source": (
                        "import QuantumBlockEncoding\n\n"
                        "-- Ask Lean for the reviewed declaration's exact type.\n"
                        f"#check {declaration['fullName']}\n"
                    ),
                }
            )
    return items


def render_ide(
    declarations: dict[str, dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    body = """
<section class="hero" id="formalization-workspace">
  <p class="eyebrow">Live formalization workspace</p>
  <h1>Read the formula, inspect the Lean statement, then compile</h1>
  <p class="lede">Load a reviewed QuantumComputinglib mapping or edit your own snippet.
  Formula rendering and declaration navigation work on the static site. Real
  compilation is available only through the loopback companion server.</p>
</section>
<section class="content-section" id="execution-boundary">
  <div class="workspace-mode" data-ide-mode>
    <span class="mode-dot" aria-hidden="true"></span>
    <div><strong data-ide-mode-title>Checking the local Lean service</strong>
    <p data-ide-mode-detail>The teaching workspace remains available without code execution.</p></div>
  </div>
  <p class="security-note"><strong>Execution boundary.</strong> GitHub Pages never
  runs submitted code. <code>ide_server.py</code> binds only to loopback, compiles
  temporary files under the pinned ASPBE toolchain, and never edits project source.</p>
</section>
<section class="content-section" id="workspace">
  <div class="workspace-toolbar">
    <label>Reviewed mapping<select data-ide-declaration><option>Loading declarations</option></select></label>
    <button class="button secondary" type="button" data-ide-load>Reload mapping</button>
    <button class="button secondary" type="button" data-ide-translate>Translate with local agent</button>
    <button class="button secondary" type="button" data-ide-scaffold>Start an honest draft</button>
    <label class="auto-check"><input type="checkbox" data-ide-auto> Compile after edits</label>
  </div>
  <div class="workspace-grid" data-ide-app data-ide-data="../ide-data.json">
    <article class="workspace-pane math-pane">
      <header><span>01</span><h2>Mathematical statement</h2><b data-translation-status>Reviewed mapping</b></header>
      <label for="ide-latex">LaTeX</label>
      <textarea id="ide-latex" data-ide-latex spellcheck="false"></textarea>
      <h3>Rendered statement</h3>
      <div class="math-preview" data-ide-math-preview></div>
      <p data-ide-plain></p>
    </article>
    <article class="workspace-pane lean-pane">
      <header><span>02</span><h2>Lean source</h2><button class="button state-button" type="button" data-ide-compile>Compile</button></header>
      <label for="ide-lean">Editable snippet</label>
      <textarea id="ide-lean" data-ide-lean spellcheck="false"></textarea>
      <p class="source-actions"><a data-ide-declaration-link href="#">Declaration page</a> · <a data-ide-source-link href="#">Source</a></p>
    </article>
  </div>
  <div class="workspace-output">
    <article class="workspace-pane"><header><span>03</span><h2>Lean diagnostics</h2><b data-ide-duration></b></header><pre data-ide-diagnostics aria-live="polite">Local compiler not contacted.</pre></article>
    <article class="workspace-pane"><header><span>04</span><h2>Dependencies</h2><b data-ide-tree-summary></b></header><div class="dependency-tree" data-ide-tree></div></article>
  </div>
</section>
<section class="content-section" id="submit">
  <h2>Request review without overstating the result</h2>
  <div class="submit-fields">
    <label>Name<input type="text" data-contributor-name placeholder="Required for submission"></label>
    <label>Preferred credit<input type="text" data-contributor-credit placeholder="How QuantumComputinglib should credit you"></label>
    <label>Source or citation<input type="text" data-contributor-source placeholder="URL, DOI, book, or original result"></label>
  </div>
  <div class="hero-actions">
    <button class="button secondary" type="button" data-ide-export>Download lemma packet</button>
    <button class="button block-button" type="button" data-ide-submit>Request submission on GitHub</button>
  </div>
  <p class="submission-note" data-ide-export-note>Only the exact Lean text most
  recently accepted by the local compiler is labeled Lean checked. Editing it
  invalidates that status.</p>
</section>"""
    return page_template(
        title="Live formalization workspace",
        route="ide/",
        current="ide/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[
            ("formalization-workspace", "Workspace"),
            ("execution-boundary", "Execution boundary"),
            ("workspace", "Editors"),
            ("submit", "Submit"),
        ],
        extra_scripts=("static/workspace.js",),
    )


def render_attribution(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    body = """
<section class="hero">
  <p class="eyebrow">Attribution</p>
  <h1>Tools, libraries, and project boundaries</h1>
  <p class="lede">QuantumComputinglib is generated from this repository's ASPBE Lean
  source and curated quantum-computing explanations.</p>
</section>
<section class="content-section">
  <h2>Formalization stack</h2>
  <ul>
    <li><a href="https://lean-lang.org/">Lean</a> and
        <a href="https://github.com/leanprover-community/mathlib4">Mathlib</a>
        provide the proof language and mathematical library.</li>
    <li><a href="https://github.com/leanprover/verso">Verso</a> and
        <a href="https://github.com/leanprover/verso-blueprint">Verso Blueprint</a>
        build the checked Blueprint pages.</li>
    <li><a href="https://mermaid.js.org/">Mermaid</a> renders editable dependency
        diagrams; <a href="https://www.mathjax.org/">MathJax</a> renders mathematics.</li>
    <li><a href="https://www.ibm.com/quantum/qiskit">Qiskit</a> is used only where
        an executable validation route requests it; it is not a substitute for Lean.</li>
  </ul>
  <h2>Content boundary</h2>
  <p>This site is tailored to ASPBE state preparation, block encoding, circuit
  semantics, resource evaluation, and automation records. It does not import
  unrelated application terminology or status data from reference documentation.</p>
  <h2>Interface inspiration</h2>
  <p><a href="https://statsmllib.github.io/">StatsMLlib</a> demonstrates a useful
  textbook organization: a persistent book map, selected formulas, natural-language
  readings, source locations, organizers, and a visible contribution path.
  QuantumComputinglib uses independently written templates, CSS, JavaScript, diagrams, and
  quantum-computing content.</p>
  <p>The local-compiler boundary and reviewed LaTeX-to-Lean workspace follow the
  proven design used by
  <a href="https://github.com/DakeBU/Auto-Bandit-RL-Proof-In-Sleep">Auto-Bandit-RL-Proof-In-Sleep</a>:
  the public site is static, while a loopback-only companion server may invoke the
  pinned Lean toolchain on temporary snippets. No bandit chapters, declarations,
  statuses, or theorem data are copied into QuantumComputinglib.</p>
</section>"""
    return page_template(
        title="Attribution",
        route="attribution/",
        current="",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def render_blueprint_entry(
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    body = """
<section class="hero">
  <p class="eyebrow">Stable Blueprint entry</p>
  <h1>ASPBE Verso Blueprint</h1>
  <p class="lede">The Blueprint resolves Lean declaration references during its
  own build. The unified site adds guided chapters and implementation status while
  retaining the existing multi-page Blueprint URL.</p>
  <div class="hero-actions">
    <a class="button" href="html-multi/index.html">Open multi-page Blueprint</a>
    <a class="button secondary" href="../library/index.html">Open Library Explorer</a>
  </div>
</section>"""
    return page_template(
        title="Verso Blueprint",
        route="blueprint/",
        current="",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def write_page(output: Path, route: str, content: str) -> None:
    destination = output / route / "index.html" if route else output / "index.html"
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(content, encoding="utf-8", newline="\n")


def copy_task_builder(output: Path) -> None:
    destination = output / "task-builder"
    destination.mkdir(parents=True, exist_ok=True)
    source_html = (ROOT / "web" / "index.html").read_text(encoding="utf-8")
    source_html = source_html.replace('href="library/', 'href="../library/')
    source_html = source_html.replace('href="blueprint/', 'href="../blueprint/')
    (destination / "index.html").write_text(
        source_html, encoding="utf-8", newline="\n"
    )
    for name in ("styles.css", "app.js"):
        shutil.copy2(ROOT / "web" / name, destination / name)
    assets = ROOT / "web" / "assets"
    if assets.exists():
        shutil.copytree(assets, destination / "assets", dirs_exist_ok=True)
    shutil.copy2(
        ROOT / "docs" / "assets" / "aspbe_harness_flow.svg",
        destination / "assets" / "aspbe-harness-flow.svg",
    )


def build_search_index(
    output: Path,
    declarations: list[dict[str, object]],
) -> dict[str, object]:
    entries: list[dict[str, str]] = []
    for declaration in declarations:
        entries.append(
            {
                "type": "declaration",
                "kind": str(declaration["kind"]),
                "title": str(declaration["fullName"]),
                "summary": str(declaration["plainEnglish"]),
                "url": (
                    f"library/modules/{module_slug(str(declaration['source']))}/"
                    f"index.html#{declaration_anchor(str(declaration['fullName']))}"
                ),
            }
        )
    page_entries = [
        ("QuantumComputinglib", "Formal quantum computing chapters, declarations, and tools", "index.html"),
        ("State preparation", "Prepare a normalized target state from the all-zero basis state", "state-preparation/index.html"),
        ("Block encoding", "Encode a scaled operator in the clean block of a larger unitary", "block-encoding/index.html"),
        ("Implementation Map", "Mathematical goals connected to exact Lean declarations", "implementation-map/index.html"),
        ("Robin paper map", "Original Robin construction statements mapped to compiled Lean structures and open obligations", "case-studies/robin/index.html"),
        ("Lean Library Explorer", "Search the complete public declaration inventory", "library/index.html"),
        ("Progress and Roadmap", "Compiled, partial, experimental, planned, and blocked routes", "roadmap/index.html"),
        ("ASPBE harness", "Candidate generation, resource scoring, proof, and validation", "workflow/index.html"),
        ("Live formalization workspace", "Compare LaTeX with Lean and compile through the local companion server", "ide/index.html"),
        ("Quantum Lean ecosystem", "ASPBE and selected external formalization libraries", "ecosystem/index.html"),
        ("Contribute", "Develop and submit a sourced teaching, theorem, adapter, or validation contribution", "community/index.html"),
        ("Contributors", "Integrated external contributions and public credit", "contributors/index.html"),
        ("Organizers", "Current ASPBE authors and contributor credit policy", "organizers/index.html"),
    ]
    page_entries.extend(
        (
            str(chapter["title"]),
            str(chapter["summary"]),
            f"chapters/{chapter['slug']}/index.html",
        )
        for chapter in CHAPTERS
    )
    entries.extend(
        {"type": "page", "kind": "page", "title": title, "summary": summary, "url": url}
        for title, summary, url in page_entries
    )
    payload = {
        "schemaVersion": 1,
        "declarationEntryCount": len(declarations),
        "pageEntryCount": len(page_entries),
        "entryCount": len(entries),
        "entries": entries,
    }
    (output / "search-index.json").write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return payload


def validate_curated_declarations(
    declaration_map: dict[str, dict[str, object]]
) -> None:
    missing: list[str] = []
    for chapter in CHAPTERS:
        for item in chapter["results"]:
            if item["declaration"] not in declaration_map:
                missing.append(str(item["declaration"]))
            if item["local_status"] not in STATUS_ORDER:
                raise SystemExit(f"Unknown local status: {item['local_status']}")
            if item["route_status"] not in STATUS_ORDER:
                raise SystemExit(f"Unknown route status: {item['route_status']}")
    for item in IMPLEMENTATION_MAP:
        if item["declaration"] not in declaration_map:
            missing.append(str(item["declaration"]))
    if missing:
        raise SystemExit(
            "Curated website content names declarations absent from inventory:\n  "
            + "\n  ".join(sorted(set(missing)))
        )


def enrich_inventory(
    inventory: dict[str, object],
    context: dict[str, object],
) -> list[dict[str, object]]:
    enriched: list[dict[str, object]] = []
    for raw in inventory["declarations"]:
        declaration = dict(raw)
        declaration["sourceUrl"] = external_source_url(
            str(declaration["source"]), int(declaration["line"]), context
        )
        enriched.append(declaration)
    inventory["declarations"] = enriched
    return enriched


def build(args: argparse.Namespace) -> None:
    inventory = load_json(args.inventory)
    coverage = load_json(args.coverage)
    if inventory["publicDeclarationCount"] != coverage["publicDeclarationCount"]:
        raise SystemExit("Inventory and coverage declaration counts differ.")
    context = git_context()
    gate = load_gate_report(args.lean_gate_report, context)
    declarations = enrich_inventory(inventory, context)
    declaration_map = {str(item["fullName"]): item for item in declarations}
    validate_curated_declarations(declaration_map)
    robin_paper_map = load_robin_paper_map(declaration_map)
    replay_report = load_json(
        ROOT / "reports" / "public-case-replay" / "latest.json"
    )
    if replay_report.get("passed") is not True:
        raise SystemExit("The public-case replay report is missing or did not pass.")
    if replay_report.get("cold_start_claim") is not False:
        raise SystemExit("Public-case replay must not be labeled as cold-start search.")

    output: Path = args.output
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    shutil.copytree(WEBSITE_ROOT / "static", output / "static")
    shutil.copytree(WEBSITE_ROOT / "diagrams", output / "diagrams")
    shutil.copy2(ROOT / "CONTRIBUTING.md", output / "CONTRIBUTING.md")
    sources = output / "sources"
    sources.mkdir(parents=True, exist_ok=True)
    shutil.copy2(
        ROOT / "paper-notes" / "GHL2025" / "source-excerpts.tex",
        sources / "ghl2025-robin-excerpts.tex",
    )
    data = output / "data"
    data.mkdir(parents=True, exist_ok=True)
    (data / "public-case-replay.json").write_text(
        json.dumps(replay_report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    if (WEBSITE_ROOT / "community").exists():
        shutil.copytree(WEBSITE_ROOT / "community", output / "community")

    write_page(output, "", render_home(inventory, coverage, gate, context))
    write_page(
        output,
        "state-preparation",
        render_state_preparation(coverage, gate, context),
    )
    write_page(
        output,
        "block-encoding",
        render_block_encoding(coverage, gate, context),
    )
    write_page(
        output,
        "implementation-map",
        render_implementation_map(declaration_map, coverage, gate, context),
    )
    write_page(
        output,
        "case-studies/robin",
        render_robin_paper_map(
            robin_paper_map, declaration_map, coverage, gate, context
        ),
    )
    write_page(output, "learning", render_learning(coverage, gate, context))
    for chapter in CHAPTERS:
        write_page(
            output,
            f"chapters/{chapter['slug']}",
            render_chapter(chapter, declaration_map, coverage, gate, context),
        )
    write_page(output, "library", render_library(inventory, coverage, gate, context))
    by_source: dict[str, list[dict[str, object]]] = {}
    for declaration in declarations:
        by_source.setdefault(str(declaration["source"]), []).append(declaration)
    for source, source_declarations in sorted(by_source.items()):
        write_page(
            output,
            f"library/modules/{module_slug(source)}",
            render_module_page(
                source, source_declarations, coverage, gate, context
            ),
        )
    write_page(output, "roadmap", render_roadmap(inventory, coverage, gate, context))
    write_page(output, "workflow", render_workflow(coverage, gate, context))
    write_page(output, "ecosystem", render_ecosystem(coverage, gate, context))
    write_page(output, "community", render_community(coverage, gate, context))
    write_page(output, "contributors", render_contributors(coverage, gate, context))
    write_page(output, "organizers", render_organizers(coverage, gate, context))
    write_page(
        output,
        "ide",
        render_ide(declaration_map, coverage, gate, context),
    )
    (output / "ide-data.json").write_text(
        json.dumps(
            {"schemaVersion": 1, "items": workspace_items(declaration_map)},
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    write_page(output, "attribution", render_attribution(coverage, gate, context))
    write_page(
        output,
        "blueprint",
        render_blueprint_entry(coverage, gate, context),
    )
    copy_task_builder(output)

    search = build_search_index(output, declarations)
    inventory_path = output / "library" / "declarations.json"
    inventory_path.write_text(
        json.dumps(inventory, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    status_counts = Counter(declaration_status(item) for item in declarations)
    route_counts = Counter(str(item["routeStatus"]) for item in declarations)
    source_link_count = sum(bool(item.get("sourceUrl")) for item in declarations)
    metadata = {
        "schemaVersion": 1,
        "generatedAtUtc": dt.datetime.now(dt.timezone.utc).isoformat(),
        "commit": context["commit"],
        "shortCommit": context["shortCommit"],
        "branch": context["branch"],
        "publishedRef": context["publishedRef"],
        "declarationCount": len(declarations),
        "chapterCount": len(CHAPTERS),
        "diagramCount": len(list((WEBSITE_ROOT / "diagrams").glob("*.mmd"))),
        "modulePageCount": len(by_source),
        "sourceLinkCount": source_link_count,
        "localStatusCounts": dict(sorted(status_counts.items())),
        "routeStatusCounts": dict(sorted(route_counts.items())),
        "searchEntryCount": search["entryCount"],
        "leanGate": gate,
        "publicCaseReplay": {
            "passed": replay_report["passed"],
            "scope": replay_report["replay_scope"],
            "coldStartClaim": replay_report["cold_start_claim"],
            "sourceDigest": replay_report["source_digest"],
        },
    }
    (output / "site-metadata.json").write_text(
        json.dumps(metadata, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    (output / "build-report.json").write_text(
        json.dumps(
            {
                **metadata,
                "coverage": coverage,
                "sourceLinkPolicy": (
                    "External source links use the detected GitHub repository and "
                    "current commit SHA only when that commit is present on origin "
                    "and the source file is clean and exists in the commit."
                ),
            },
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    print(
        f"built {output}: {len(declarations)} declarations, "
        f"{len(CHAPTERS)} chapters, {len(by_source)} module pages, "
        f"{source_link_count} commit-pinned source links"
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--inventory",
        type=Path,
        default=ROOT / "web" / "library" / "declarations.json",
    )
    parser.add_argument(
        "--coverage",
        type=Path,
        default=ROOT / "docs" / "blueprint-coverage.json",
    )
    parser.add_argument(
        "--lean-gate-report",
        type=Path,
        default=ROOT / "_out" / "lean-gate.json",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "_out" / "site",
    )
    build(parser.parse_args())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
