#!/usr/bin/env python3
"""Publish one hierarchical reader over the evidence-qualified shared QA cores."""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import html
import json
from pathlib import Path, PurePosixPath
import re
import shutil
import sys
from urllib.parse import quote, urlsplit

ROOT = Path(__file__).resolve().parents[2]
B = ROOT / "benchmarks/quantumcomputingbench"
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(B / "src"))
from qcb_core import digest, read_json, write_json
from qcb_curriculum import load_catalog, stable_readiness, reader_source_digest
from qcb_integrity import text_sha
from qcb_textbook_policy import public_reader_item

HUB = "quantumcomputingbench/"
REPO = "https://github.com/DakeBU/QuantumComputinglib-QuantumComputingBench"
SOURCE_COMMIT = "86b9e677566498da04faebcf4e5ed57f177c6bb1"
TRACKS = ("non-lean", "lean")


def esc(value):
    return html.escape(str(value), quote=True)


def prose(value):
    """Preserve reviewed wording/notation; never execute embedded HTML or Markdown."""
    return "".join('<p class="qcb-prose">' + esc(p) + '</p>'
                   for p in str(value).split("\n\n") if p.strip())


def title_of(topic):
    return topic.removeprefix("planned_").replace("_", " ").title()


def section(title, content, anchor):
    return f'<section class="qcb-section" id="{esc(anchor)}"><h2>{esc(title)}</h2>{content}</section>'


def disclosure(title, content, anchor):
    return f'<details class="qcb-disclosure" id="{esc(anchor)}"><summary>{esc(title)}</summary>{content}</details>'


def reader_sources():
    return reader_source_digest()


def formal_warmups():
    """Bind semantic review to exact fixed references, without admitting new cores."""
    review = read_json(B / "reports/textbook-v1/formal-view-review.json")
    for binding in review["file_bindings"]:
        if text_sha(ROOT / binding["path"]) != binding["sha256_lf"]:
            raise ValueError("formal view review is stale: " + binding["path"])
    raw = read_json(B / "data/authored/repairs-v3.json")
    records = raw if isinstance(raw, list) else raw["items"]
    by_key = {r["key"]: r for r in records}
    selected = []
    for row in review["reviews"]:
        item = by_key[row["key"]]
        if digest(item) != row["raw_record_digest"] or row["verdict"] != "accept":
            raise ValueError("formal warmup review does not match the exact record")
        selected.append((item, row))
    return selected


def graph_link(node, prefix, graph, live_ids):
    if node in live_ids:
        href = prefix + "lean-graph/index.html?focus=" + quote(node, safe="")
        return '<a data-qcb-graph href="' + esc(href) + '">' + esc(graph[node].get("label", node)) + '</a>'
    # A frozen planned/curated identity may not be a live declaration identity.
    return '<span>' + esc(graph[node].get("label", node)) + ' <small>(frozen curriculum anchor; see graph registry)</small></span>'


def source_list(item):
    rows = []
    for source in item.get("source_refs", []):
        path = source.get("path", "")
        relative = PurePosixPath(path)
        if path and not relative.is_absolute() and ".." not in relative.parts and "\\" not in path:
            href = REPO + "/blob/" + SOURCE_COMMIT + "/" + quote(path, safe="/")
            label = '<a href="' + esc(href) + '">' + esc(path) + '</a>'
        else:
            label = esc(path or "Source record")
        rows.append('<li>' + label + prose(source.get("anchor", "")) +
                    '<small>Source SHA-256: <code>' + esc(source.get("sha256", "not recorded")) +
                    '</code> · ' + esc(source.get("license", "license not recorded")) + '</small></li>')
    for source in item.get("primary_sources", []):
        url = source.get("url", "")
        label = source.get("title", source.get("id", "Primary source"))
        if urlsplit(url).scheme in {"http", "https"}:
            label = '<a href="' + esc(url) + '">' + esc(label) + '</a>'
        else:
            label = esc(label)
        rows.append('<li>' + label + prose(source.get("anchor", source.get("section", ""))) + '</li>')
    return '<ul class="qcb-sources">' + "".join(rows) + '</ul>'


def core_body(core, item, catalog, graph, live_ids, prefix):
    part = next(p for p in catalog["parts"] if p["id"] == core["part"])
    parent = prefix + HUB + "non-lean/" + part["id"] + "/" + core["topic"] + "/index.html"
    body = '<article class="qcb-reader"><p class="qcb-breadcrumb"><a href="' + esc(parent) + '">' + esc(part["title"]) + ' / ' + esc(title_of(core["topic"])) + '</a></p>'
    body += '<p class="eyebrow">' + esc(title_of(core["topic"])) + '</p><h1>Exercise ' + esc(core["core_id"].removeprefix("qcb-core-").upper()) + '</h1>'
    body += '<p class="qcb-meta">' + esc(item["difficulty"]["level"]) + ' · ' + esc(item["task_kind"]) + ' · ' + esc(core["split"]) + '</p>'
    review_status = 'Additive answer successor with distinct content-bound review; historical rejected answer retained only for audit.' if core.get("textbook_successor") else 'Inherited content-bound reviews; consult the current textbook review ledger for second-pass status.'
    body += '<p class="qcb-boundary">' + esc(core["evidence_relation"].replace("_", " ")) + '. ' + review_status + ' No new Lean verification is claimed for this NL view.</p>'
    premises = '<ul>' + "".join('<li>' + esc(s) + '</li>' for s in item["assumptions"] + item["conventions"]) + '</ul>'
    body += section("Assumptions and conventions", premises, "assumptions")
    body += section("Question", prose(item["question"]), "question")
    roadmap = '<ol>' + "".join('<li>' + esc(s["claim"]) + '</li>' for s in item["semantic_steps"]) + '</ol>'
    body += disclosure("Hint: mathematical route", prose(core["title"]) + roadmap, "hint")
    body += disclosure("Reference solution", prose(item["reference_answer"]), "solution")
    rubric = '<ol>' + "".join('<li>' + esc(r["criterion"]) + ' <small>(' + esc(r["weight"]) + ' weight)</small></li>' for r in item["rubric"]) + '</ol>'
    body += disclosure("Assessment rubric", rubric, "rubric")
    body += section("Graph-grounded prerequisites", '<p>These are support/source anchors, not an automatically extracted theorem-dependency proof.</p><ul>' + "".join('<li>' + graph_link(n, prefix, graph, live_ids) + '</li>' for n in dict.fromkeys(core["target_nodes"] + core["supporting_nodes"])) + '</ul><p><a href="' + prefix + 'data/quantumcomputingbench/cores.json">Download the shared core registry</a></p>', "graph")
    body += disclosure("Lean view and evidence boundary", '<p>No aligned Lean view has been admitted for this native core in this textbook checkpoint. This is not a claim that the underlying mathematics lacks a formal proof. Contributions must preserve this exact target contract and split.</p><p><a href="' + prefix + HUB + 'lean/index.html">Read the Lean track and existing diagnostic warmups</a></p>', "lean")
    body += disclosure("Sources and provenance", source_list(item) + '<p>Contract: <code>' + esc(core["contract_hash"]) + '</code></p><p>Item digest: <code>' + esc(core["item_digest"]) + '</code></p><p>Graph snapshot: <code>' + esc(core["snapshot_id"]) + '</code></p><p>Authored support steps: ' + str(core["semantic_steps"]) + '. This is not measured graph distance or model difficulty.</p>', "sources")
    if core.get("textbook_successor"):
        body += disclosure("Answer revision lineage", prose(json.dumps(core["textbook_successor"], indent=2)), "revision")
    return body + '</article>'


def exercise_cards(cores, prefix, items):
    content = '<div class="qcb-grid">'
    for c in cores:
        href = prefix + HUB + "cores/" + c["core_id"] + "/index.html"
        question = items[c["core_id"]]["question"]
        preview = question if len(question) <= 220 else question[:220] + "…"
        content += '<article class="qcb-card" data-qcb-card data-qcb-search="' + esc(c["core_id"] + ' ' + c["topic"] + ' ' + c["evidence_relation"] + ' ' + question) + '"><p class="qcb-meta">' + esc(c["split"]) + ' · ' + esc(items[c["core_id"]]["task_kind"]) + '</p><h3><a href="' + esc(href) + '">Exercise ' + esc(c["core_id"].removeprefix("qcb-core-").upper()) + '</a></h3>' + prose(preview) + '<p>' + esc(c["evidence_relation"].replace("_", " ")) + '</p></article>'
    return content + '</div>'


def filters():
    return '<div class="qcb-filter" data-qcb-controls hidden><label for="qcb-query">Find an exercise (questions and topics, not solutions)</label><input id="qcb-query" data-qcb-query type="search" autocomplete="off"><p data-qcb-count role="status" aria-live="polite"></p></div>'


def publish(root):
    from website.scripts import build_site as site
    from website.scripts.research_atlas import patch_navigation
    root = root.resolve()
    catalog, items, graph = load_catalog()
    report = read_json(root / "build-report.json")
    context = site.git_context()
    if not report["leanGate"].get("passed") or report["leanGate"].get("commit") != context["commit"]:
        raise ValueError("textbook publication requires the current passed repository Lean gate")
    graph_path = root / "data/lean-graph.json"
    graph_hash = hashlib.sha256(graph_path.read_bytes()).hexdigest()
    live_ids = {n["id"] for n in read_json(graph_path)["nodes"]}
    data_dir = root / "data/quantumcomputingbench"
    write_json(data_dir / "cores.json", catalog)
    write_json(data_dir / "reader-items.json", {"schema_version": "qcb.current_reader_export.v1", "stable": False,
        "catalog_hash": catalog["catalog_hash"], "use": "Open reader views; not a stable training/scoring release.", "items": [public_reader_item(i) for i in items.values()]})
    for name in ("quantumcomputingbench.css", "quantumcomputingbench.js"):
        shutil.copyfile(ROOT / "website/static" / name, root / "static" / name)
    entries, routes = [], []

    def write(route, title, body, description):
        site.write_page(root, route, site.page_template(
            title=title, route=route, current=route, body=body,
            coverage=report["coverage"], gate=report["leanGate"], context=context,
            description=description, extra_styles=("static/quantumcomputingbench.css",),
            extra_scripts=("static/quantumcomputingbench.js",)))
        routes.append(route + "index.html")
        entries.append({"type": "page", "kind": "quantumcomputingbench", "title": title,
                        "summary": description, "url": route + "index.html"})

    def intro(title, subtitle):
        return '<div class="qcb-reader"><p class="eyebrow">QuantumComputingBench · graph-grounded exercise book</p><h1>' + esc(title) + '</h1>' + prose(subtitle)

    body = intro("Learn the mathematics. Inspect the evidence.", "A substantial open exercise book for quantum-computing knowledge, derivations and proof skills. Two reader paths share one mathematical core registry, the same graph identities and the same split contracts.")
    body += '<p class="qcb-boundary">Textbook edition in progress, not a stable benchmark claim. ' + str(len(catalog["cores"])) + ' retained native core IDs; global semantic deduplication and fresh editorial review are incomplete. Public answers are open training/diagnostic material, not a hidden evaluation set.</p>'
    body += '<div class="qcb-grid"><article class="qcb-card"><p class="eyebrow">Read without Lean</p><h2><a href="non-lean/index.html">Mathematical questions and solutions</a></h2><p>Definitions, reasoning, constructions, counterexamples and carefully stated assumptions. No Lean installation needed.</p></article><article class="qcb-card"><p class="eyebrow">Inspect the formal interface</p><h2><a href="lean/index.html">Lean companion and proof tasks</a></h2><p>Exact targets, fixed-reference checks and explicit semantic boundaries. Native formal views are a contribution frontier; three separate API warmups are available.</p></article></div>'
    body += section("Five parts, one source of truth", "".join('<article class="qcb-part"><p class="eyebrow">Part ' + str(i + 1) + '</p><h3><a href="non-lean/' + p["id"] + '/index.html">' + esc(p["title"]) + '</a></h3>' + prose(p["summary"]) + '<p>' + str(sum(c["part"] == p["id"] for c in catalog["cores"])) + ' native core IDs · ' + str(len(p["topics"])) + ' topics</p></article>' for i, p in enumerate(catalog["parts"])), "parts")
    body += section("Read, solve, then inspect", '<ol><li>Choose a part and topic. Check dimensions, normalization, phase and resource conventions first.</li><li>Attempt the question before opening the hint or solution.</li><li>Follow exact graph/source anchors. Source-backed and planned material are visibly different evidence classes.</li><li>Use the Lean path to contribute a matching formal view, not another copy of the same question.</li></ol><p><a href="contribute/index.html">Contributor tracks and compatibility contract</a> · <a href="evidence/index.html">Release boundaries and current acceptance gates</a></p>', "reading")
    write(HUB, "QuantumComputingBench exercise book", body + '</div>', "Five-part graph-grounded quantum-computing exercise book with non-Lean and Lean companion paths.")
    for track in TRACKS:
        prefix = "../../"
        is_lean = track == "lean"
        body = intro("Lean companion" if is_lean else "Mathematical exercise book", "The same five-part curriculum, with no duplicate mathematical core counting. " + ("A source-supported NL answer is not automatically a verified formal view. Native formal views are not yet admitted." if is_lean else "Read and solve substantial quantum-computing problems without learning Lean syntax."))
        if is_lean:
            body += '<p class="qcb-boundary">0 admitted native Lean views in this checkpoint. The three corrected-v3 reference warmups below are separate legacy diagnostics, not additions to the native count. Trusted local checking does not establish isolated model-output evaluation.</p><p><a href="warmups/index.html">Open the three semantic-audited API warmups</a></p>'
        body += '<div class="qcb-grid">' + "".join('<article class="qcb-card"><h2><a href="' + p["id"] + '/index.html">' + esc(p["title"]) + '</a></h2>' + prose(p["summary"]) + '</article>' for p in catalog["parts"]) + '</div>'
        write(HUB + track + "/", "Lean companion" if is_lean else "Non-Lean exercise book", body + '</div>', "Shared curriculum and exact evidence boundaries for the " + track + " track.")
        for part in catalog["parts"]:
            body = intro(part["title"], part["summary"])
            body += '<p><a href="../index.html">Back to the ' + track + ' reader path</a></p><ol class="qcb-topic-list">' + "".join('<li><a href="' + topic + '/index.html">' + esc(title_of(topic)) + '</a> <small>(' + str(sum(c["topic"] == topic for c in catalog["cores"])) + ' shared cores' + (', formal views pending' if is_lean else '') + ')</small></li>' for topic in part["topics"]) + '</ol>'
            write(HUB + track + "/" + part["id"] + "/", part["title"] + " · " + track, body + '</div>', part["summary"])
            for topic in part["topics"]:
                rows = [c for c in catalog["cores"] if c["topic"] == topic]
                body = intro(title_of(topic), part["summary"])
                body += '<p><a href="../index.html">Back to ' + esc(part["title"]) + '</a></p>'
                if is_lean:
                    body += '<p class="qcb-boundary">Formal-view contribution frontier: these links open shared NL targets, not admitted Lean exercises. Preserve the exact core contract and split when adding a formal companion.</p>'
                body += filters() + exercise_cards(rows, "../../../../", items)
                write(HUB + track + "/" + part["id"] + "/" + topic + "/", title_of(topic) + " · " + track, body + '</div>', "Graph-grounded " + title_of(topic) + " questions; shared targets for both reader paths.")
    for core in catalog["cores"]:
        title = title_of(core["topic"]) + " · Exercise " + core["core_id"].removeprefix("qcb-core-").upper()
        write(HUB + "cores/" + core["core_id"] + "/", title, core_body(core, items[core["core_id"]], catalog, graph, live_ids, "../../../"), items[core["core_id"]]["question"])
    body = intro("Three reference warmups", "Small API applications, not deep proof synthesis. A distinct semantic review checked exact definitions, angle conventions and assumptions; inherited fixed-reference elaboration is separate from this review. The review is not a strictly source-blind decoder certificate.")
    for i, (item, review) in enumerate(formal_warmups(), 1):
        formal = item["formal"]
        content = prose(item["question"]) + '<pre><code>' + esc(json.dumps({k: formal[k] for k in ("imports", "target")}, ensure_ascii=False, indent=2)) + '</code></pre>'
        content += disclosure("Reference proof and semantic reconstruction", '<pre><code>' + esc(formal["reference_proof"]) + '</code></pre>' + prose(review["independent_reconstruction"]["meaning"]) + prose(review["independent_reconstruction"]["proof"]), "warmup-proof-" + str(i))
        content += '<p>Historical same-core alias: ' + esc(", ".join(review["suggested_core_aliases"])) + '. Not added to the native core count.</p>'
        body += section(item["key"], content, "warmup-" + str(i))
    write(HUB + "lean/warmups/", "Lean reference warmups", body + '</div>', "Three exact-target, semantic-audited diagnostic warmups with inherited trusted reference checks.")
    body = intro("Contribute without conflicting datasets", "Two contribution folders, one merge-time semantic contract. Existing mathematical targets keep their core identity, family and split across natural-language, Lean and mixed views.")
    for track in TRACKS:
        body += section(track.title() + " contributor goal", '<p><a href="' + REPO + '/blob/main/benchmarks/quantumcomputingbench/tracks/' + track + '/AGENT_GOAL.md">Open the copyable English agent goal</a></p>', track)
    body += prose((B / "shared/CONTRACT.md").read_text(encoding="utf-8"))
    write(HUB + "contribute/", "Contribution contract", body + '</div>', "Shared core IDs, UUID proposals, exact contracts, compatible views and split-safe collaboration.")
    body = intro("Evidence and release readiness", "An inspectable textbook is not automatically a fully validated benchmark. These are the current acceptance boundaries, not claimed completions.")
    body += '<pre><code>' + esc(json.dumps(stable_readiness(catalog), indent=2)) + '</code></pre>'
    body += '<p>Four mathematically quarantined records and inherited provisional material are excluded from the normal reader. Historical releases and all source/review records are retained in the repository. Existing AI reviews are fallible, content-bound provenance, not newly invented expert approval. No model baseline or isolated arbitrary-Lean prediction evaluation is claimed.</p><p>The frozen benchmark graph is not the current whole-library inventory. Exact live node links are offered only when identities exist; planned/source-only anchors remain graph metadata. An import edge is not theorem entailment and a curated AND hyperedge is not a completed proof.</p>'
    body += section("Additive answer decisions", '<pre><code>' + esc(json.dumps(catalog["reader_decisions"], indent=2)) + '</code></pre><p>The frozen preview contains the historical predecessor answer. Do not treat its bytes as current gold after a withdrawal. A corrected reader view needs its own content-bound review and does not create a new mathematical core.</p><p><a href="../../data/quantumcomputingbench/reader-items.json">Download current open reader views (not a stable training release)</a></p>', "answer-decisions")
    write(HUB + "evidence/", "Evidence and release readiness", body + '</div>', "Current second-pass review, split/dedup, formal-view, isolation and publication boundaries.")
    home = root / "index.html"
    text = home.read_text(encoding="utf-8")
    text = re.sub(r'<!-- qcb-textbook:start -->.*?<!-- qcb-textbook:end -->', '', text, flags=re.S)
    panel = '<!-- qcb-textbook:start --><section class="qcb-home" id="quantumcomputingbench"><p class="eyebrow">QuantumComputingBench · open exercise book</p><h2><a href="quantumcomputingbench/index.html">A graph-grounded quantum-computing exercise book</a></h2><p>Five parts. ' + str(len(catalog["cores"])) + ' retained native core IDs. Read substantial mathematics without Lean, then inspect the formal companion and exact evidence boundaries.</p><p><a href="quantumcomputingbench/non-lean/index.html">Read the mathematical exercises</a> · <a href="quantumcomputingbench/lean/index.html">Explore the Lean companion</a></p><p><small>Textbook edition in progress; semantic review and formal-view expansion remain explicit gates.</small></p></section><!-- qcb-textbook:end -->'
    text = text.replace('<main id="main-content">', '<main id="main-content">' + panel, 1)
    if 'static/quantumcomputingbench.css' not in text:
        text = text.replace('</head>', '<link rel="stylesheet" href="./static/quantumcomputingbench.css"></head>', 1)
    home.write_text(text, encoding="utf-8")
    patch_navigation(root)
    search_path = root / "search-index.json"
    search = read_json(search_path)
    search["entries"] = [e for e in search["entries"] if e.get("kind") != "quantumcomputingbench"] + entries
    search["entryCount"] = len(search["entries"])
    search["pageEntryCount"] = sum(e.get("type") == "page" for e in search["entries"])
    write_json(search_path, search)
    manifest = {"schema_version": 1, "catalog_hash": catalog["catalog_hash"],
                "reader_source_digest": reader_sources(), "routes": routes,
                "native_core_ids": len(catalog["cores"]), "admitted_native_lean_views": 0,
                "legacy_reference_warmups": 3, "stable": False,
                "leanGraphSha256": graph_hash, "source_commit": context["commit"]}
    write_json(data_dir / "reader.json", manifest)
    for filename in ("site-metadata.json", "build-report.json"):
        value = read_json(root / filename)
        value["searchEntryCount"] = search["entryCount"]
        value["quantumComputingBench"] = manifest
        write_json(root / filename, value)
    if hashlib.sha256(graph_path.read_bytes()).hexdigest() != graph_hash:
        raise ValueError("textbook publisher mutated the authoritative Lean graph")
    return {"pages": len(routes), "native_core_ids": len(catalog["cores"]), "stable": False}


def check_site(root):
    manifest = read_json(root / "data/quantumcomputingbench/reader.json")
    catalog, items, _ = load_catalog()
    if manifest["catalog_hash"] != catalog["catalog_hash"] or manifest["reader_source_digest"] != reader_sources():
        raise ValueError("textbook projection is stale")
    if manifest["leanGraphSha256"] != hashlib.sha256((root / "data/lean-graph.json").read_bytes()).hexdigest():
        raise ValueError("textbook graph binding differs")
    for route in manifest["routes"]:
        page = (root / route).read_text(encoding="utf-8")
        if '<html lang="en"' not in page or 'class="qcb-reader"' not in page:
            raise ValueError("missing shared English reader shell: " + route)
    entries = [e for e in read_json(root / "search-index.json")["entries"] if e.get("kind") == "quantumcomputingbench"]
    expected = {HUB + "cores/" + c["core_id"] + "/index.html": items[c["core_id"]]["question"] for c in catalog["cores"]}
    actual = {e["url"]: e["summary"] for e in entries if e["url"] in expected}
    if actual != expected or len(entries) != len(manifest["routes"]):
        raise ValueError("question-only search or route coverage changed")
    return {"pages": len(manifest["routes"]), "question_only_search": True, "graph_unchanged": True}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("publish", "check-site"))
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    print(json.dumps(publish(args.root) if args.command == "publish" else check_site(args.root), indent=2))
