"""Deterministic adapter over the supported site exporter and planned records.

The library remains mathematical truth. This adapter never upgrades historical
publication debt, lexical references or import proximity to proof entailment.
"""
from __future__ import annotations
import ast
from collections import Counter, defaultdict
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys


def _hash(data):
    return hashlib.sha256(data).hexdigest()


def _digest(value):
    return _hash(json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(",", ":")).encode())


def _read(root, path):
    return json.loads((root / path).read_text(encoding="utf-8"))


def _module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def snapshot(root):
    root = Path(root).resolve()
    inputs = ["web/library/declarations.json", "docs/blueprint-coverage.json",
              "website/lean-graph-contract.json", "website/scripts/lean_graph.py",
              "website/scripts/build_site.py", "website/curriculum-parts.json",
              "website/content.py", "docs/quantum-domain-roadmap.md",
              "website/research/atlas.json", "website/research/state-preparation-wiki.json",
              "website/research/sources.json", "website/research/publications.json",
              "lean-toolchain", "lake-manifest.json", "LICENSE", "NOTICE.md"]
    inputs += [p.relative_to(root).as_posix() for p in (root / "QuantumBlockEncoding").rglob("*.lean")]
    inputs += [p.relative_to(root).as_posix() for p in (root / "website/research").glob("*.json")]
    inputs += [p.relative_to(root).as_posix() for p in (root / "docs").glob("*audit*.md")]
    inputs += [p.relative_to(root).as_posix() for p in (root / "paper-notes").rglob("*audit*.md")]
    hashes = {p: _hash((root / p).read_bytes()) for p in sorted(set(inputs)) if (root / p).is_file()}
    missing = [p for p in inputs[:14] if not (root / p).is_file()]
    if missing:
        raise ValueError(f"missing required snapshot inputs: {missing}")
    content = _module(root / "website/content.py", "qcb_frozen_content")
    exporter = _module(root / "website/scripts/lean_graph.py", "qcb_frozen_exporter")
    declarations = _read(root, "web/library/declarations.json")["declarations"]
    graph = exporter.build_lean_graph_payload(root, declarations, content.CHAPTERS, [])
    nodes, edges, hyperedges = {}, list(graph["edges"]), []
    def add(identity, kind, topic, status, source, **extra):
        record = {"id": identity, "kind": kind, "topic": topic, "status": status, "source": source, **extra}
        if identity in nodes and nodes[identity] != record:
            # One source ID shared by multiple views, not a second theorem.
            nodes[identity].setdefault("additional_views", []).append(record)
        else:
            nodes[identity] = record
    for n in graph["nodes"]:
        # Exporter historically overwrites track:<id> with raw track id;
        # preserve its exact emitted identity, fixing only edges to that identity.
        kind = n["type"]
        status = "legacy_source_semantic_debt" if kind in {"module", "declaration"} else "navigation"
        add(n["id"], kind, n.get("track", n.get("id", "shared-foundations")), status,
            n.get("source", "website/scripts/lean_graph.py"),
            label=n.get("label", n.get("fullName", n["id"])),
            declaration_kind=n.get("kind"), line=n.get("line"),
            inventory_status=n.get("status"), compiled_this_run=False,
            source_review="not inferred from compilation", open_obligation=n.get("openProof", False))
    track_ids = {n["id"] for n in graph["nodes"] if n["type"] == "track"}
    for e in edges:
        if e["source"].startswith("track:") and e["source"][6:] in track_ids:
            e["exporter_source"] = e["source"]
            e["source"] = e["source"][6:]
            e["adapter_note"] = "Exporter track node id spread overrides prefixed ID; preserve emitted node identity."
    for p in _read(root, "website/curriculum-parts.json")["parts"]:
        add(p["id"], "curriculum_part", p["id"], "planned_or_partial", "website/curriculum-parts.json", label=p["title"], source_status=p["status"])
        for c in p["chapters"]:
            add(c["id"], "curriculum_chapter", p["id"], "planned_or_partial", "website/curriculum-parts.json", label=c["title"], source_status=c["status"])
            edges.append({"id": f"curriculum:{p['id']}:{c['id']}", "source": p["id"], "target": c["id"], "type": "curriculum-navigation"})
    for chapter in content.CHAPTERS:
        identity = chapter["slug"]
        add(identity, "teaching_chapter", chapter.get("track", "shared-foundations"), "curated_exposition", "website/content.py", label=chapter["title"])
        for module in chapter.get("modules", []):
            mid = "module:" + exporter._module_name(module)
            edges.append({"id": f"chapter:{identity}:{mid}", "source": identity, "target": mid, "type": "curated-chapter-module"})
    atlas = _read(root, "website/research/atlas.json")
    for collection, kind in [("domains", "concept"), ("families", "mathematical_family"), ("contributions", "contribution")]:
        for r in atlas[collection]:
            add(r["id"], kind, r.get("domains", [r["id"]])[0] if r.get("domains") else r["id"],
                "curated_proposal_review_pending", "website/research/atlas.json", label=r.get("label", r["id"]),
                lean_refs=r.get("lean_refs", []), source_ids=r.get("source_ids", []), boundary=r.get("boundary", r.get("novelty_boundary", "")))
            card = r.get("technical_card")
            if card:
                add(card["id"], "technical_card", r["id"], "obligation", "website/research/atlas.json", label=card["statement"], lean_refs=card.get("lean_decl", []))
    for h in atlas["hyperedges"]:
        add(h["id"], "conditional_transport", "cross_topic", "proposal_not_lean_implication", "website/research/atlas.json", label=h["label"])
        hyperedges.append(h)  # Complete AND tails, heads, review and failure map.
    for route in _read(root, "website/research/state-preparation-wiki.json")["routes"]:
        add(route["id"], "research_route", "state-preparation", "open_obligation", "website/research/state-preparation-wiki.json", label=route["title"], source_ids=route.get("source_ids", []))
        for step in route.get("steps", []):
            identity = route["id"] + "/" + step["id"]
            add(identity, "research_obligation", "state-preparation", "open_obligation", "website/research/state-preparation-wiki.json", label=step["target"], parent=route["id"])
            edges.append({"id": "research-step:" + identity, "source": route["id"], "target": identity, "type": "research-route-obligation"})
    for r in _read(root, "website/research/sources.json")["sources"]:
        add(r["id"], "source_record", "source_evidence", "external_reference_not_local_proof", "website/research/sources.json", label=r["title"], source_status=r["status"], anchor=r.get("anchor"), url=r.get("url"))
    for r in _read(root, "docs/blueprint-coverage.json")["excluded"]:
        identity = "private-source:" + r["name"]
        add(identity, "private_helper", "implementation_details", "private", r["source"], line=r["line"], exclusion_reason=r["reason"])
    publication = _read(root, "website/research/publications.json")
    for i, r in enumerate(publication["records"]):
        identity = r.get("id", "publication-record:" + _digest(r)[:20])
        add(identity, "publication_record", "source_evidence", "publication_record_not_benchmark_review", "website/research/publications.json", record=r)
    # Expose conceptual references omitted from top-level registries, without
    # changing their source identity or fabricating declarations.
    referenced = {x for h in hyperedges for x in h.get("tails", []) + h.get("heads", [])}
    for identity in sorted(referenced - nodes.keys()):
        add(identity, "referenced_concept", "cross_topic", "unresolved_reference", "website/research/atlas.json")
    unresolved_edges = [e["id"] for e in edges if e["source"] not in nodes or e["target"] not in nodes]
    if unresolved_edges:
        raise ValueError(f"graph has unresolved edge endpoints: {unresolved_edges[:5]}")
    try:
        commit = subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"], stderr=subprocess.DEVNULL, text=True).strip()
        timestamp = subprocess.check_output(["git", "-C", str(root), "show", "-s", "--format=%cI", "HEAD"], text=True).strip()
    except (OSError, subprocess.CalledProcessError):
        commit, timestamp = None, None
    return {"schema_version": "qcb.snapshot.v1", "snapshot_id": "qcb-snapshot-" + _digest(hashes)[:24],
            "commit": commit, "source_timestamp": timestamp,
            "timestamp_policy": "Git source time when available; archive time unknown, not invented",
            "canonical_remote": "https://github.com/DakeBU/QuantumComputinglib-QuantumComputingBench.git",
            "input_hashes": hashes, "toolchain": (root / "lean-toolchain").read_text().strip(),
            "dependency_manifest_sha256": hashes["lake-manifest.json"],
            "graph_schema_version": graph["schemaVersion"],
            "graph_contract_schema_version": _read(root, "website/lean-graph-contract.json")["schemaVersion"],
            "extraction_method": "website/scripts/lean_graph.py:build_lean_graph_payload(root,declarations,content.CHAPTERS,[]) + source-record adapters",
            "overlay_limitations": "Example-case overlays omitted; all declarations/modules retained. Authored blueprint/private exclusions retained. No theorem dependency export.",
            "evidence_boundaries": graph["evidenceClass"], "compiled_this_run": False,
            "nodes": sorted(nodes.values(), key=lambda n: n["id"]),
            "edges": sorted(edges, key=lambda e: e["id"]), "hyperedges": sorted(hyperedges, key=lambda e: e["id"]),
            "stats": {"nodes": len(nodes), "kinds": dict(sorted(Counter(n["kind"] for n in nodes.values()).items())), "exporter": graph["stats"]}}


def _bucket(n):
    return str(n) if n <= 2 else "3-4" if n <= 4 else "5-8" if n <= 8 else "9+"


def coverage(snap, items):
    released = [i for i in items if i.get("lifecycle") == "released"]
    cover, candidates = defaultdict(list), defaultdict(list)
    for item in items:
        table = cover if item.get("lifecycle") == "released" else candidates
        for node in set(item["target_nodes"] + item["supporting_nodes"]):
            table[node].append(item["id"])
    ledger = []
    for node in snap["nodes"]:
        identity = node["id"]
        if cover[identity]:
            state, reason = "covered_by_released_qa", "Released separately reviewed QA maps to this node; not automatic Lean/source certification."
        elif candidates[identity]:
            state, reason = "candidate_pending_review", "Authored candidate exists; unresolved review/formal/source gate, not released coverage."
        elif node["kind"] in {"track", "source_record", "publication_record", "private_helper", "contribution"}:
            state, reason = "deliberately_excluded", node.get("exclusion_reason", "Navigation/evidence/private implementation record; not a standalone mathematical QA target.")
        else:
            state, reason = "blocked_by_missing_evidence", "No retained source-inspected and separately reviewed QA for this node yet; mathematical authoring/review required."
        ledger.append({"id": identity, "kind": node["kind"], "topic": node["topic"], "status": node["status"],
                       "disposition": state, "reason": reason, "released_items": sorted(cover[identity]),
                       "candidate_items": sorted(candidates[identity])})
    counts = Counter(n["disposition"] for n in ledger)
    by_topic = {}
    for topic in sorted({n["topic"] for n in ledger}):
        rows = [n for n in ledger if n["topic"] == topic]
        by_topic[topic] = {"nodes": len(rows), "dispositions": dict(sorted(Counter(n["disposition"] for n in rows).items()))}
    axes = {}
    for field in ["track", "topic", "evidence_status", "split_group", "split"]:
        axes[field] = dict(sorted(Counter(i[field] for i in released).items()))
    axes["difficulty"] = dict(sorted(Counter(i["difficulty"]["level"] for i in released).items()))
    axes["support_bucket"] = dict(sorted(Counter(_bucket(i["support_count"]) for i in released).items()))
    axes["reviewed_semantic_step_bucket"] = dict(sorted(Counter(_bucket(i["semantic_step_count"]) for i in released).items()))
    axes["validation_class"] = dict(sorted(Counter(i["validation"]["formal"] for i in released).items()))
    return {"schema_version": "qcb.coverage.v1", "snapshot_id": snap["snapshot_id"],
            "universe_nodes": len(ledger), "released_items": len(released), "candidate_items": len(items)-len(released),
            "dispositions": dict(sorted(counts.items())), "complete_node_accounting": len(ledger) == len(snap["nodes"]),
            "benchmark_complete": False, "by_topic": by_topic, "released_axes": axes,
            "edge_types": dict(sorted(Counter(e["type"] for e in snap["edges"]).items())),
            "conditional_hyperedges": len(snap["hyperedges"]), "theorem_depth": "unknown; semantic steps and structural distance are distinct",
            "lean_certified_items": 0, "baseline": "unmeasured", "ledger": ledger}
