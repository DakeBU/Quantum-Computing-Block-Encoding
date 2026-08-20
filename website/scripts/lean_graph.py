#!/usr/bin/env python3
"""Build the interactive module/declaration graph used by QuantumComputinglib.

The first public graph is deliberately honest about its evidence class:

* module-to-module edges are parsed Lean `import` edges;
* module-to-declaration edges are containment edges from the generated public
  declaration inventory;
* chapter, example-case, and paper labels are curated overlays.

It is not yet a theorem-level dependency graph.  That stronger graph requires
Lean environment dependencies and proof-term analysis, and is named explicitly
as a later compression layer on the reader-facing page.
"""

from __future__ import annotations

import html
import json
import re
from collections import defaultdict
from pathlib import Path
from typing import Iterable


TRACKS: tuple[dict[str, str], ...] = (
    {
        "id": "shared-foundations",
        "label": "Shared foundations",
        "short": "Foundations",
        "description": (
            "Finite matrices, resources, circuit syntax, semantics, register order, "
            "and reusable linear-algebra bridges."
        ),
        "methodology": (
            "Choose a stable finite semantic model, make indexing conventions "
            "explicit, and factor representation lemmas before proving cases."
        ),
    },
    {
        "id": "state-preparation",
        "label": "State Preparation",
        "short": "State prep",
        "description": (
            "Targets, normalization, exact and approximate preparation, primitive "
            "rotations, UCRY trees, structured loaders, and sparse routes."
        ),
        "methodology": (
            "Constrain one column of a unitary: search the unitary orbit of the "
            "all-zero ket while preserving normalization and implementation evidence."
        ),
    },
    {
        "id": "block-encoding",
        "label": "Block Encoding and papers",
        "short": "Block encoding",
        "description": (
            "Clean-block projections, dilations, LCU constructions, Robin operators, "
            "paper reconstructions, and same-target circuit improvements."
        ),
        "methodology": (
            "Constrain a projected subblock of a larger unitary. Ancillas and failure "
            "branches are degrees of freedom in a unitary dilation, not informal debris."
        ),
    },
    {
        "id": "system-evidence",
        "label": "Harness, evidence, and publication",
        "short": "Evidence",
        "description": (
            "Candidate contracts, verification policy, executable mirrors, resource "
            "scores, literature maps, publication gates, and automation records."
        ),
        "methodology": (
            "First freeze the semantic fibre of correct candidates; only then compare "
            "gate count, depth, ancillas, and oracle calls lexicographically."
        ),
    },
)

TRACK_BY_LABEL = {
    "Shared foundations": "shared-foundations",
    "State preparation": "state-preparation",
    "Block encoding": "block-encoding",
    "System and evidence": "system-evidence",
}


def _slug(text: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")


def _module_name(source: str) -> str:
    return ".".join(Path(source).with_suffix("").parts)


def _module_slug(source: str) -> str:
    trimmed = source.removeprefix("QuantumBlockEncoding/").removesuffix(".lean")
    return _slug(trimmed)


def _declaration_anchor(full_name: str) -> str:
    return f"decl-{_slug(full_name)}"


def _lean_sources(root: Path) -> list[Path]:
    paths: list[Path] = []
    root_module = root / "QuantumBlockEncoding.lean"
    if root_module.is_file():
        paths.append(root_module)
    library = root / "QuantumBlockEncoding"
    if library.is_dir():
        paths.extend(sorted(library.rglob("*.lean")))
    return paths


def _module_title(text: str, fallback: str) -> str:
    match = re.search(r"^#\s+(.+?)\s*$", text, flags=re.M)
    return match.group(1).strip() if match else fallback


def _parse_modules(root: Path) -> dict[str, dict[str, object]]:
    modules: dict[str, dict[str, object]] = {}
    import_pattern = re.compile(r"^\s*import\s+([A-Za-z0-9_.]+)\s*$", re.M)
    for path in _lean_sources(root):
        source = path.relative_to(root).as_posix()
        name = _module_name(source)
        text = path.read_text(encoding="utf-8")
        modules[name] = {
            "name": name,
            "source": source,
            "title": _module_title(text, name.rsplit(".", 1)[-1]),
            "imports": [
                item for item in import_pattern.findall(text)
                if item.startswith("QuantumBlockEncoding")
            ],
        }
    known = set(modules)
    for module in modules.values():
        module["imports"] = sorted({
            item for item in module["imports"] if item in known and item != module["name"]
        })
    return modules


def _track_for_source(
    source: str,
    chapter_tracks: dict[str, list[str]],
) -> str:
    for label in chapter_tracks.get(source, []):
        track = TRACK_BY_LABEL.get(label)
        if track:
            return track
    lower = source.lower()
    if any(token in lower for token in (
        "statepreparation", "uniformlycontrolledry", "textbookstatepreparation",
        "primitivebasisle",
    )):
        return "state-preparation"
    if any(token in lower for token in (
        "blockencoding", "robin", "ghl", "lcu", "cubicdiagonal",
        "optimalcontrol", "bandedsparse", "householder",
    )):
        return "block-encoding"
    if any(token in lower for token in (
        "candidate", "policy", "evidence", "publication", "literature",
        "validation", "executable", "adapter", "workflow", "harness",
    )):
        return "system-evidence"
    return "shared-foundations"


def _paper_overlays(root: Path) -> list[dict[str, object]]:
    path = root / "website" / "papers.json"
    if not path.is_file():
        return []
    data = json.loads(path.read_text(encoding="utf-8"))
    return [dict(item) for item in data.get("featured", []) + data.get("queue", [])]


def _unique_records(records: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    seen: set[tuple[str, str]] = set()
    answer: list[dict[str, str]] = []
    for record in records:
        key = (record.get("label", ""), record.get("url", ""))
        if key in seen:
            continue
        seen.add(key)
        answer.append(record)
    return sorted(answer, key=lambda item: item.get("label", "").lower())


def build_lean_graph_payload(
    root: Path,
    declarations: list[dict[str, object]],
    chapters: list[dict[str, object]],
    example_cases: list[dict[str, object]],
) -> dict[str, object]:
    modules = _parse_modules(root)
    declaration_by_name = {
        str(item.get("fullName", "")): item for item in declarations
        if item.get("fullName")
    }
    declarations_by_source: dict[str, list[dict[str, object]]] = defaultdict(list)
    for declaration in declarations:
        source = str(declaration.get("source", ""))
        if source:
            declarations_by_source[source].append(declaration)

    chapter_records: dict[str, list[dict[str, str]]] = defaultdict(list)
    chapter_tracks: dict[str, list[str]] = defaultdict(list)
    for chapter in chapters:
        label = f"{int(chapter['number']):02d} · {chapter['title']}"
        url = f"../chapters/{chapter['slug']}/index.html"
        for source in chapter.get("modules", []):
            source = str(source)
            chapter_records[source].append({"label": label, "url": url})
            chapter_tracks[source].append(str(chapter.get("track", "")))

    case_records: dict[str, list[dict[str, str]]] = defaultdict(list)
    for case in example_cases:
        record = {
            "label": str(case.get("title", case.get("slug", "Example case"))),
            "url": f"../example-cases/{case.get('slug', '')}/index.html",
        }
        for root_name in case.get("leanAnchors", []):
            declaration = declaration_by_name.get(str(root_name))
            if declaration:
                case_records[str(declaration.get("source", ""))].append(record)

    paper_records: dict[str, list[dict[str, str]]] = defaultdict(list)
    for paper in _paper_overlays(root):
        route = str(paper.get("route", ""))
        record = {
            "label": str(paper.get("title", paper.get("key", paper.get("slug", "Paper")))),
            "url": f"../{route}index.html" if route else str(paper.get("url", "")),
        }
        for root_name in paper.get("leanRoots", []):
            declaration = declaration_by_name.get(str(root_name))
            if declaration:
                paper_records[str(declaration.get("source", ""))].append(record)

    imported_by: dict[str, list[str]] = defaultdict(list)
    for module in modules.values():
        for dependency in module["imports"]:
            imported_by[str(dependency)].append(str(module["name"]))

    nodes: list[dict[str, object]] = []
    edges: list[dict[str, str]] = []
    for track in TRACKS:
        nodes.append({"id": f"track:{track['id']}", "type": "track", **track})

    module_sources = {str(module["source"]) for module in modules.values()}
    # A generated declaration can occasionally come from a public source file that
    # was not found by the filesystem pass. Keep such a module visible rather than
    # silently dropping certified leaves.
    for source in sorted(set(declarations_by_source) - module_sources):
        name = _module_name(source)
        modules[name] = {
            "name": name,
            "source": source,
            "title": name.rsplit(".", 1)[-1],
            "imports": [],
        }

    module_track: dict[str, str] = {}
    for name, module in sorted(modules.items()):
        source = str(module["source"])
        track = _track_for_source(source, chapter_tracks)
        module_track[name] = track
        module_declarations = sorted(
            declarations_by_source.get(source, []),
            key=lambda item: (int(item.get("line", 0)), str(item.get("fullName", ""))),
        )
        chapters_here = _unique_records(chapter_records.get(source, []))
        cases_here = _unique_records(case_records.get(source, []))
        papers_here = _unique_records(paper_records.get(source, []))
        description = (
            "; ".join(item["label"] for item in chapters_here)
            or str(module["title"])
        )
        module_id = f"module:{name}"
        nodes.append({
            "id": module_id,
            "type": "module",
            "label": str(module["title"]),
            "fullName": name,
            "source": source,
            "track": track,
            "description": description,
            "declarationCount": len(module_declarations),
            "imports": list(module["imports"]),
            "importedBy": sorted(imported_by.get(name, [])),
            "chapters": chapters_here,
            "cases": cases_here,
            "papers": papers_here,
            "url": f"../library/modules/{_module_slug(source)}/index.html",
        })
        edges.append({
            "id": f"contains:{track}:{name}",
            "source": f"track:{track}",
            "target": module_id,
            "type": "track-contains-module",
        })
        for declaration in module_declarations:
            full_name = str(declaration.get("fullName", ""))
            declaration_id = f"declaration:{full_name}"
            status = str(
                declaration.get("routeStatus")
                or declaration.get("localStatus")
                or declaration.get("status")
                or "Compiled"
            )
            nodes.append({
                "id": declaration_id,
                "type": "declaration",
                "label": full_name.rsplit(".", 1)[-1],
                "fullName": full_name,
                "module": name,
                "source": source,
                "line": int(declaration.get("line", 0)),
                "kind": str(declaration.get("kind", "declaration")),
                "catalog": str(declaration.get("catalog", "")),
                "status": status,
                "experimental": bool(declaration.get("experimental", False)),
                "openProof": bool(declaration.get("openProof", False)),
                "plain": str(declaration.get("plainEnglish", "")),
                "url": (
                    f"../library/modules/{_module_slug(source)}/index.html#"
                    f"{_declaration_anchor(full_name)}"
                ),
            })
            edges.append({
                "id": f"declares:{name}:{full_name}",
                "source": module_id,
                "target": declaration_id,
                "type": "module-declares-leaf",
            })

    known_modules = set(modules)
    for name, module in sorted(modules.items()):
        for dependency in module["imports"]:
            dependency = str(dependency)
            if dependency not in known_modules:
                continue
            edges.append({
                "id": f"imports:{dependency}:{name}",
                # Dependencies point toward the modules that reuse them.
                "source": f"module:{dependency}",
                "target": f"module:{name}",
                "type": "module-supports-importer",
            })

    track_counts = {
        track["id"]: sum(
            1 for node in nodes
            if node.get("type") == "module" and node.get("track") == track["id"]
        )
        for track in TRACKS
    }
    return {
        "schemaVersion": 1,
        "evidenceClass": {
            "moduleEdges": "Parsed internal Lean import edges",
            "leafEdges": "Generated public declaration containment edges",
            "overlays": "Curated chapter, example-case, and paper associations",
            "notYetClaimed": (
                "Theorem-level proof-term dependency, equivalence quotienting, and "
                "proof-graph compression are not claimed by this first graph."
            ),
        },
        "tracks": list(TRACKS),
        "nodes": nodes,
        "edges": edges,
        "stats": {
            "trackCount": len(TRACKS),
            "moduleCount": sum(node.get("type") == "module" for node in nodes),
            "declarationCount": sum(node.get("type") == "declaration" for node in nodes),
            "importEdgeCount": sum(edge["type"] == "module-supports-importer" for edge in edges),
            "trackModuleCounts": track_counts,
        },
    }


def render_lean_graph_body(payload: dict[str, object]) -> str:
    stats = dict(payload["stats"])
    track_cards = "".join(
        f"""<article class="lean-graph-method-card">
  <p class="eyebrow">{html.escape(str(track['short']))}</p>
  <h3>{html.escape(str(track['label']))}</h3>
  <p>{html.escape(str(track['description']))}</p>
  <p><strong>Methodological reading.</strong> {html.escape(str(track['methodology']))}</p>
</article>"""
        for track in payload["tracks"]
    )
    return f"""
<section class="hero lean-graph-hero" id="graph-purpose">
  <p class="eyebrow">Formal topology · clickable library branches</p>
  <h1>Underlying Lean Graph of Libraries</h1>
  <p class="lede">This graph exposes the structure underneath the textbook. It
  shows which Lean modules support later modules, which public declarations live
  on each branch, and where chapters, paper reconstructions, example cases, and
  lexicographic circuit improvements attach to the library.</p>
  <div class="metric-row">
    <span><strong>{int(stats['moduleCount']):,}</strong> Lean modules</span>
    <span><strong>{int(stats['declarationCount']):,}</strong> public declaration leaves</span>
    <span><strong>{int(stats['importEdgeCount']):,}</strong> internal import relations</span>
  </div>
</section>
<section class="content-section" id="graph-methodology">
  <div class="section-heading">
    <p class="eyebrow">How to read the topology</p>
    <h2>Technical constructions become positions in a shared formal graph</h2>
    <p>A state-preparation method and a block-encoding method may look like
    unrelated gate tricks. The graph instead asks which semantic constraint they
    solve, which representation lemmas they share, and which new edge or reusable
    branch the proof contributes.</p>
  </div>
  <div class="lean-graph-method-grid">{track_cards}</div>
</section>
<section class="content-section lean-graph-app" id="interactive-graph"
         data-lean-graph data-url="../data/lean-graph.json">
  <div class="section-heading">
    <p class="eyebrow">Interactive explorer</p>
    <h2>Open a module, then inspect its declaration leaves</h2>
    <p>Drag the canvas to pan, use the wheel or controls to zoom, click a module
    to open its branch, and click a declaration leaf to see its statement role and
    source link. Search can isolate one technique, theorem family, paper, or case.</p>
  </div>
  <div class="lean-graph-toolbar" role="group" aria-label="Lean graph controls">
    <label>Search<input type="search" data-graph-search
      placeholder="UCRY, Robin, clean block, betterThan…"></label>
    <label>Track<select data-graph-track><option value="">All tracks</option></select></label>
    <button type="button" data-graph-zoom-in aria-label="Zoom in">+</button>
    <button type="button" data-graph-zoom-out aria-label="Zoom out">−</button>
    <button type="button" data-graph-reset>Reset view</button>
    <button type="button" data-graph-collapse>Collapse leaves</button>
  </div>
  <p class="lean-graph-status" data-graph-status aria-live="polite">Loading the checked library graph…</p>
  <div class="lean-graph-layout">
    <div class="lean-graph-stage" data-graph-stage>
      <svg data-graph-svg role="img"
           aria-label="Interactive QuantumComputinglib Lean module graph">
        <defs>
          <marker id="lean-graph-arrow" viewBox="0 0 10 10" refX="9" refY="5"
                  markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M 0 0 L 10 5 L 0 10 z"></path>
          </marker>
        </defs>
        <g data-graph-viewport></g>
      </svg>
    </div>
    <aside class="lean-graph-inspector" data-graph-inspector>
      <p class="eyebrow">Selected branch</p>
      <h3>Choose a module</h3>
      <p>The inspector will show imported foundations, downstream users,
      textbook chapters, attached papers/cases, and every public Lean leaf.</p>
    </aside>
  </div>
</section>
<section class="content-section" id="graph-compression">
  <div class="section-heading">
    <p class="eyebrow">Next topology layer</p>
    <h2>From an import graph to a compressed proof graph</h2>
  </div>
  <div class="lean-graph-future-grid">
    <article><h3>Compress repeated subproofs</h3><p>Detect isomorphic proof
    subgraphs, promote their common invariant to one reusable lemma, and measure
    how much later formalization becomes shorter and more stable.</p></article>
    <article><h3>Quotient equivalent routes</h3><p>Separate genuine mathematical
    choices from syntactic proof variation. Equivalent branches can be grouped
    while preserving source fidelity and exact Lean provenance.</p></article>
    <article><h3>Read the matrix geometry</h3><p>State preparation fixes a unitary
    column; block encoding fixes a projected subblock of a dilation. Ancilla,
    clean-workspace, sparsity, and oracle requirements define different feasible
    fibres over those constraints.</p></article>
    <article><h3>Interpret evolution correctly</h3><p>Lexicographic improvement is
    search inside a correctness fibre: target equality first, then gate count,
    depth, auxiliary qubits, and oracle calls. A new topology is valuable when it
    creates reusable understanding, not merely a smaller isolated circuit.</p></article>
  </div>
  <div class="callout warning"><strong>Current evidence boundary.</strong> Import
  edges and public declaration containment are generated from this checkout.
  The theorem-level dependency DAG and its compression quotient remain an
  explicit roadmap item, so this page does not overstate what has already been
  extracted from Lean proof terms.</div>
</section>"""
