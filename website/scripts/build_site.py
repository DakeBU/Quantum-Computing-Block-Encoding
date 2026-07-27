#!/usr/bin/env python3
"""Build the unified ABEIS literate formalization website."""

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
    ROADMAP,
    STATUS_ORDER,
    WORKFLOW_STAGES,
)


NAVIGATION = [
    ("Overview", ""),
    ("Implementation Map", "implementation-map/"),
    ("Chapters", "learning/"),
    ("Library", "library/"),
    ("Roadmap", "roadmap/"),
    ("Workflow", "workflow/"),
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
    links = []
    for label, route in NAVIGATION:
        current_attr = ' aria-current="page"' if current == route else ""
        links.append(
            f'<a href="{page_url(prefix, route)}"{current_attr}>{html.escape(label)}</a>'
        )
    return f"""
<a class="skip-link" href="#main-content">Skip to content</a>
<header class="site-header">
  <div class="header-inner">
    <a class="brand" href="{page_url(prefix, '')}">
      <span class="brand-mark" aria-hidden="true">U/A</span>
      <span>ABEIS Formalization</span>
    </a>
    <nav class="top-nav" data-main-nav aria-label="Primary">
      {''.join(links)}
    </nav>
    <div class="header-tools">
      <div class="search-shell">
        <label class="visually-hidden" for="global-search">Search declarations and chapters</label>
        <input id="global-search" class="global-search" type="search"
               placeholder="Search Lean declarations" data-global-search>
        <div class="search-results" data-search-results hidden></div>
      </div>
      <div class="theme-switcher" aria-label="Reading style">
        <button type="button" data-theme-choice="blueprint" aria-pressed="true">Blueprint</button>
        <button type="button" data-theme-choice="modern" aria-pressed="false">Modern</button>
        <button type="button" data-theme-choice="bold" aria-pressed="false">Bold</button>
      </div>
      <button class="icon-button mobile-menu" type="button" data-menu-button
              aria-label="Open navigation" aria-expanded="false">&#9776;</button>
    </div>
  </div>
</header>"""


def verification_strip(
    prefix: str,
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    return f"""
<div class="verification-strip">
  <div class="verification-inner">
    <strong>Lean gate passed</strong>
    <span>{int(coverage['publicDeclarationCount']):,} public declarations</span>
    <span>{int(coverage['privateDeclarationExclusionCount']):,} private/internal declarations excluded</span>
    <span>commit <code>{html.escape(str(context['shortCommit']))}</code></span>
    <a href="{prefix}build-report.json">build evidence</a>
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
    description: str = "ABEIS state-preparation and block-encoding formalization",
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
    return f"""<!doctype html>
<html lang="en" data-theme="blueprint">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="{html.escape(description)}">
  <title>{html.escape(title)} | ABEIS Formalization</title>
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
    ABEIS formalization documentation. Generated from the current Lean inventory and commit.
    <a href="{page_url(prefix, 'attribution/')}">Attribution</a>.
  </footer>
  <script src="{prefix}static/site.js"></script>
  <script type="module">
    import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
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
        fontFamily: "Inter, system-ui, sans-serif"
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


def render_contracts() -> str:
    return """
<div class="contract-grid">
  <article class="contract">
    <h3>State preparation</h3>
    <div class="math-block">\\[U|0^n\\rangle=|\\psi\\rangle\\]</div>
    <p>The first column of a unitary is the normalized target state.</p>
  </article>
  <article class="contract">
    <h3>Block encoding</h3>
    <div class="math-block">\\[\\Pi U\\Pi^\\dagger=A/\\alpha\\]</div>
    <p>Ancilla-zero projection selects a scaled block of a larger unitary.</p>
  </article>
  <article class="contract">
    <h3>Acceptance</h3>
    <div class="math-block">\\[\\text{candidate}\\to\\text{proof}\\to\\text{check}\\]</div>
    <p>Resource quality is ranked only after the mathematical obligations are explicit.</p>
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
    chapter_links = "".join(
        f"""
<a class="chapter-link" href="chapters/{chapter['slug']}/index.html">
  <span class="chapter-number">Chapter {chapter['number']}</span>
  <h3>{html.escape(str(chapter['title']))}</h3>
  <p>{html.escape(str(chapter['summary']))}</p>
</a>"""
        for chapter in CHAPTERS
    )
    body = f"""
<section class="hero">
  <p class="eyebrow">Literate formalization of quantum construction contracts</p>
  <h1>ABEIS: state preparation before block encoding</h1>
  <p class="lede">Read the quantum objective in ordinary language, inspect its exact
  matrix contract, follow the proof obligations into Lean, and separate a locally
  compiled declaration from completion of the broader algorithmic route.</p>
  <div class="hero-actions">
    <a class="button" href="learning/index.html">Start the guided path</a>
    <a class="button secondary" href="implementation-map/index.html">Audit implementation status</a>
    <a class="button secondary" href="library/index.html">Search Lean declarations</a>
  </div>
</section>
<section class="content-section" id="contracts">
  <h2>Two application directions, one certificate discipline</h2>
  <p>State preparation is the concrete entry point. Block encoding generalizes the
  same unitary reasoning to a projected matrix block, with ancillas, register order,
  and normalization made explicit.</p>
  {render_contracts()}
  {diagram(prefix, "learning-path", "Recommended mathematical learning path")}
</section>
<section class="content-section" id="evidence">
  <h2>Evidence in this build</h2>
  <div class="metric-grid">
    <div class="metric"><strong>{int(coverage['publicDeclarationCount']):,}</strong><span>explicit public declarations</span></div>
    <div class="metric"><strong>{int(coverage['sourceDocstringCount']):,}</strong><span>source docstrings</span></div>
    <div class="metric"><strong>{experimental:,}</strong><span>experimental declarations</span></div>
    <div class="metric"><strong>{open_proofs:,}</strong><span>explicit incomplete proofs</span></div>
    <div class="metric"><strong>{len(CHAPTERS)}</strong><span>guided learning chapters</span></div>
    <div class="metric"><strong>{len(coverage['bySource'])}</strong><span>source modules with public declarations</span></div>
  </div>
  <div class="callout"><strong>Status rule.</strong> “Compiled” on this site is emitted
  only because the Lean and test gates certified commit
  <code>{html.escape(str(context['shortCommit']))}</code>. A structure or contract may
  compile while its broader construction route remains partial.</div>
</section>
<section class="content-section" id="pipeline">
  <h2>From mathematical target to accepted artifact</h2>
  <p>ABEIS separates automation policy, candidate exploration, formal verification,
  and executable checks. A Qiskit result can corroborate an export; it does not replace
  the Lean certificate.</p>
  {diagram(prefix, "certificate-pipeline", "Mathematical contract to Lean certificate")}
</section>
<section class="content-section" id="chapters">
  <h2>Recommended reading order</h2>
  <div class="chapter-grid">{chapter_links}</div>
</section>
<section class="content-section" id="navigation">
  <h2>One site, three evidence views</h2>
  <p>The guided chapters explain; the Library Explorer inventories every explicit
  declaration; the Verso Blueprint checks Lean references and remains available at
  its stable URL.</p>
  {diagram(prefix, "navigation", "Overview, Library, Blueprint, and source navigation")}
  <div class="link-row">
    <a class="button secondary" href="blueprint/html-multi/index.html">Open Verso Blueprint</a>
    <a class="button secondary" href="task-builder/index.html">Open task builder</a>
  </div>
</section>"""
    toc = [
        ("contracts", "Core contracts"),
        ("evidence", "Build evidence"),
        ("pipeline", "Certificate pipeline"),
        ("chapters", "Learning chapters"),
        ("navigation", "Evidence views"),
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
      <p class="eyebrow">Important result</p>
      <h3>{html.escape(str(result['title']))}</h3>
      <code>{html.escape(str(result['declaration']))}</code>
    </div>
    <div class="status-pair">
      <span title="Local declaration completion">{badge(str(result['local_status']))}</span>
      <span title="Broader construction route">{badge(str(result['route_status']))}</span>
    </div>
  </div>
  <div class="math-block">\\[{html.escape(str(result['math']))}\\]</div>
  <dl class="result-grid">
    <div><dt>Plain-English statement</dt><dd>{html.escape(str(result['plain']))}</dd></div>
    <div><dt>Intuition</dt><dd>{html.escape(str(result['intuition']))}</dd></div>
    <div><dt>Why it is needed</dt><dd>{html.escape(str(result['why']))}</dd></div>
    <div><dt>Dependencies</dt><dd>{'; '.join(dependencies)}</dd></div>
    <div><dt>Proof idea</dt><dd>{html.escape(str(result['proof_idea']))}</dd></div>
    <div><dt>Missing route steps</dt><dd>{html.escape(str(result['missing']))}</dd></div>
  </dl>
  <h4>Lean proof correspondence</h4>
  <table class="proof-steps">
    <thead><tr><th>Natural-language step</th><th>Lean object or step</th></tr></thead>
    <tbody>{steps}</tbody>
  </table>
  <details class="source-panel">
    <summary>Lean statement and source</summary>
    <pre><code>{html.escape(source_statement(str(declaration['sourcePreview'])))}</code></pre>
    <p>
      <a href="{module_url(prefix, declaration)}">local declaration anchor</a> |
      <a href="{blueprint_url(prefix, declaration)}">Verso Blueprint panel</a> |
      {source_links}
    </p>
  </details>
</article>"""


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
    toc = [("orientation", "Orientation"), ("dependency-view", "Dependency view")]
    for item in chapter["results"]:
        declaration = declarations[str(item["declaration"])]
        result_html.append(result_card(item, declaration, prefix))
        toc.append((declaration_anchor(str(item["declaration"])), str(item["title"])))
    modules = "".join(f"<li><code>{html.escape(module)}</code></li>" for module in chapter["modules"])
    body = f"""
<section class="hero" id="orientation">
  <p class="eyebrow">Guided chapter {chapter['number']} of {len(CHAPTERS)}</p>
  <h1>{html.escape(str(chapter['title']))}</h1>
  <p class="lede">{html.escape(str(chapter['summary']))}</p>
  <p><strong>Primary modules</strong></p>
  <ul>{modules}</ul>
</section>
<section class="content-section" id="dependency-view">
  <h2>Route view</h2>
  {diagram(prefix, str(chapter['diagram']), str(chapter['title']))}
</section>
<section class="content-section" id="important-results">
  <h2>Important results</h2>
  <p>Each entry separates the status of the Lean declaration from the status of the
  broader construction route.</p>
  {''.join(result_html)}
</section>"""
    return page_template(
        title=str(chapter["title"]),
        route=route,
        current="learning/",
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
    cards = "".join(
        f"""
<a class="chapter-link" href="../chapters/{chapter['slug']}/index.html">
  <span class="chapter-number">Chapter {chapter['number']}</span>
  <h3>{html.escape(str(chapter['title']))}</h3>
  <p>{html.escape(str(chapter['summary']))}</p>
</a>"""
        for chapter in CHAPTERS
    )
    body = f"""
<section class="hero">
  <p class="eyebrow">Guided learning chapters</p>
  <h1>Read from a prepared state to an accepted block encoding</h1>
  <p class="lede">The order is deliberate: first understand how a unitary prepares one
  target vector, then add ancillas and projection to encode a general operator.</p>
</section>
<section class="content-section">
  {diagram("../", "learning-path", "State preparation to block encoding")}
  <div class="chapter-grid">{cards}</div>
</section>"""
    return page_template(
        title="Guided learning",
        route="learning/",
        current="learning/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
    )


def render_implementation_map(
    declarations: dict[str, dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    prefix = "../"
    rows = []
    for item in IMPLEMENTATION_MAP:
        declaration = declarations[str(item["declaration"])]
        rows.append(
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
    body = f"""
<section class="hero">
  <p class="eyebrow">Generated links, curated route status</p>
  <h1>Implementation Map</h1>
  <p class="lede">Every row connects a mathematical goal to a contract, proof
  obligation, exact Lean declaration, module line, dependencies, current status,
  missing work, and its reader-facing evidence.</p>
</section>
<section class="content-section">
  <div class="table-wrap">
    <table class="data-table">
      <thead><tr>
        <th>Mathematical goal</th><th>Contract</th><th>Proof obligation</th>
        <th>Lean declaration</th><th>Module / line</th><th>Dependencies</th>
        <th>Status</th><th>Missing step</th><th>Reader links</th>
      </tr></thead>
      <tbody>{''.join(rows)}</tbody>
    </table>
  </div>
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
  <p class="eyebrow">ABEIS Workflow</p>
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
        title="ABEIS Workflow",
        route="workflow/",
        current="workflow/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
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
  <p class="lede">ABEIS documentation is generated from this repository's Lean
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
  <p>This site is tailored to ABEIS state preparation, block encoding, circuit
  semantics, resource evaluation, and automation records. It does not import
  unrelated application terminology or status data from reference documentation.</p>
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
  <h1>ABEIS Verso Blueprint</h1>
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
        ("Overview", "Core contracts, evidence, and recommended reading order", "index.html"),
        ("Implementation Map", "Mathematical goals connected to exact Lean declarations", "implementation-map/index.html"),
        ("Lean Library Explorer", "Search the complete public declaration inventory", "library/index.html"),
        ("Progress and Roadmap", "Compiled, partial, experimental, planned, and blocked routes", "roadmap/index.html"),
        ("ABEIS Workflow", "Candidate generation, resource scoring, proof, and validation", "workflow/index.html"),
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

    output: Path = args.output
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    shutil.copytree(WEBSITE_ROOT / "static", output / "static")
    shutil.copytree(WEBSITE_ROOT / "diagrams", output / "diagrams")

    write_page(output, "", render_home(inventory, coverage, gate, context))
    write_page(
        output,
        "implementation-map",
        render_implementation_map(declaration_map, coverage, gate, context),
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
