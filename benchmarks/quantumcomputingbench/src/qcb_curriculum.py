"""A shared graph-grounded core catalog over immutable admitted QA records."""
from __future__ import annotations

from collections import Counter
import json
from pathlib import Path
import sys
from uuid import UUID

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "scripts"))
from qcb_core import digest, read_json
from qcb_integrity import text_sha
from qcb_textbook_policy import apply_current_reader_policy, CONTRACT_FIELDS, check_source_bindings
import release as preview


def core_contract(item):
    return {key: item[key] for key in CONTRACT_FIELDS}


def reader_source_digest():
    paths = ("website/scripts/quantumcomputingbench.py", "website/static/quantumcomputingbench.css",
             "website/static/quantumcomputingbench.js", "website/scripts/test_quantumcomputingbench_browser.py",
             "benchmarks/quantumcomputingbench/src/qcb_curriculum.py",
             "benchmarks/quantumcomputingbench/src/qcb_textbook_policy.py",
             "benchmarks/quantumcomputingbench/src/qcb_formal_views.py",
             "benchmarks/quantumcomputingbench/tracks/lean/views/native-v1.json",
             "benchmarks/quantumcomputingbench/shared/current-policy.json",
             "benchmarks/quantumcomputingbench/shared/curriculum.json")
    return digest({path: text_sha(R / path) for path in paths})


def load_catalog():
    snapshot, all_items, native, legacy = preview.checked()
    native, reader_decisions = apply_current_reader_policy(native)
    config = read_json(B / "shared/curriculum.json")
    topics = {topic: part for part in config["parts"] for topic in part["topics"]}
    if sum(len(p["topics"]) for p in config["parts"]) != len(topics):
        raise ValueError("a topic has multiple primary textbook homes")
    graph = {node["id"]: node for node in snapshot["nodes"]}
    records = []
    for item in native:
        if item["topic"] not in topics:
            raise ValueError("unmapped mathematical topic: " + item["topic"])
        ids = item["target_nodes"] + item["supporting_nodes"]
        if any(node not in graph for node in ids):
            raise ValueError("exercise has an unknown graph identity")
        records.append({
            "core_id": item["core_id"], "contract_hash": digest(core_contract(item)),
            "item_digest": digest(item), "item_id": item["id"], "key": item["key"],
            "author_identity": item["author"]["identity"],
            "title": item["native_nl"]["core_summary"], "topic": item["topic"],
            "part": topics[item["topic"]]["id"], "family": item["family"], "split": item["split"],
            "snapshot_id": snapshot["snapshot_id"], "target_nodes": item["target_nodes"],
            "supporting_nodes": item["supporting_nodes"], "evidence_relation": item["evidence_relation"],
            "semantic_steps": item["semantic_step_count"],
            "source_record": "data/public/nl-v12/release.json",
            "source_key": item.get("textbook_successor", {}).get("predecessor_key", item["key"]),
            "answer_source_record": item.get("textbook_successor", {}).get("repair_record", "data/public/nl-v12/release.json"),
            "textbook_successor": item.get("textbook_successor"),
            "views": {"non-lean": {"status": "admitted_under_current_overlay", "item_id": item["id"]}},
            "editorial_second_pass": "pending_content_bound_review",
        })
    records.sort(key=lambda row: row["core_id"])
    if len({r["core_id"] for r in records}) != len(records):
        raise ValueError("duplicate canonical core ID")
    admission = read_json(B / "manifests/integration-20261022/admission.json")
    catalog = {
        "schema_version": "qcb.shared_core_registry.v1", "version": config["version"],
        "publication_status": config["publication_status"], "snapshot_id": snapshot["snapshot_id"],
        "graph_source_commit": snapshot["commit"],
        "reader_decisions": reader_decisions,
        "parts": config["parts"], "cores": records,
        "core_count_policy": "One admitted core per mathematical target; views never increase this count.",
        "known_cross_cohort_aliases": admission["observed_cross_cohort_aliases"],
        "legacy_diagnostic_count": len(legacy), "legacy_pooling_allowed": False,
        "global_semantic_dedup_complete": False,
        "graph_evidence": "imports/ownership plus typed curated/planned relations, not a theorem-proof dependency oracle",
        "isolated_prediction_evaluation": "ENV_BLOCKED",
    }
    from qcb_formal_views import admission as formal_admission
    formal, formal_status = formal_admission(records)
    catalog["native_formal_view_admission"] = formal_status
    for core in records:
        if core["core_id"] in formal:
            core["views"]["lean"] = formal[core["core_id"]]
    accepted, disputed = content_review_status(catalog)
    for core in records:
        core["editorial_second_pass"] = ("disputed" if core["core_id"] in disputed else
            "content_bound_review_accepted" if core["core_id"] in accepted else "pending_content_bound_review")
    catalog["catalog_hash"] = digest(catalog)
    return catalog, {i["core_id"]: i for i in native}, graph


def validate_proposals(catalog, proposals):
    """Detect merge-time conflicts; advisory reservations are not distributed locks."""
    known = {c["core_id"]: c for c in catalog["cores"]}
    owners, views, candidates = {}, set(), set()
    for row in proposals:
        if row.get("track") not in {"non-lean", "lean"}:
            raise ValueError("invalid contribution track")
        try:
            valid_uuid = str(UUID(row.get("proposal_id", ""))) == row.get("proposal_id")
        except (ValueError, TypeError, AttributeError):
            valid_uuid = False
        if not valid_uuid:
            raise ValueError("proposal ID must be a UUID")
        if not row.get("author") or not row.get("source_nodes"):
            raise ValueError("author and graph-grounded source identities are required")
        core = row.get("core_id")
        if core in known:
            original = known[core]
            for key in ("contract_hash", "family", "split", "snapshot_id"):
                if row.get(key) != original[key]:
                    raise ValueError("existing core contract/family/split changed: " + core)
            slot = (core, row["track"], row.get("view_kind", "default"))
            if slot in views:
                raise ValueError("duplicate view proposal requires reconciliation")
            views.add(slot)
        else:
            if core != "candidate:" + row["proposal_id"]:
                raise ValueError("new candidates use candidate:<proposal UUID> until semantic admission")
            if row.get("admission") != "candidate_not_counted" or not row.get("dedup_review_required"):
                raise ValueError("unknown mathematical core is not automatically admitted")
            if core in candidates:
                raise ValueError("candidate core collision requires semantic reconciliation")
            candidates.add(core)
        if row["proposal_id"] in owners:
            raise ValueError("duplicate proposal ID")
        owners[row["proposal_id"]] = row["author"]
    return {"proposals": len(proposals), "new_cores_admitted": 0, "distributed_lock_claimed": False}


def content_review_status(catalog):
    """One content-bound editorial status for both registry rows and metrics."""
    accepted = {c["core_id"] for c in catalog["cores"] if c.get("textbook_successor")}
    disputed = set()
    by_id = {c["core_id"]: c for c in catalog["cores"]}
    for path in sorted((B / "reports/textbook-v1/reader-reviews").glob("*.json")):
        packet = read_json(path)
        if not packet.get("reviewer") or packet.get("method") != "independent-mathematical-reader-review":
            raise ValueError("invalid reader review provenance")
        for row in packet["items"]:
            historical = any(d["core_id"] == row["core_id"] and d["predecessor_item_digest"] == row.get("item_digest")
                             for d in catalog.get("reader_decisions", []))
            if historical and row.get("verdict") in {"reject", "uncertain"}:
                continue  # exact predecessor finding remains history, never successor approval
            if row["core_id"] not in by_id or row.get("item_digest") != by_id[row["core_id"]]["item_digest"]:
                raise ValueError("reader review does not bind current mathematical content")
            if packet["reviewer"] == by_id[row["core_id"]]["author_identity"]:
                raise ValueError("authors cannot self-certify an independent review")
            if not row.get("reasoning") or not row.get("source_checks"):
                raise ValueError("review verdicts require substantive reasoning and source checks")
            check_source_bindings(row["source_checks"])
            if row.get("verdict") == "accept" and row.get("semantic_core_verdict") == "distinct_or_explicit_alias":
                accepted.add(row["core_id"])
            else:
                disputed.add(row["core_id"])
    accepted -= disputed
    return accepted, disputed


def stable_readiness(catalog):
    """Stable requires real second-pass records, not changing a version label."""
    accepted, disputed = content_review_status(catalog)
    missing = sorted({c["core_id"] for c in catalog["cores"]} - accepted)
    browser_path = R / "_out/qcb-browser/browser-report.json"
    if not browser_path.is_file():
        browser_path = B / "reports/textbook-v1/browser-report.json"
    browser = read_json(browser_path) if browser_path.is_file() else {}
    browser_ok = (browser.get("catalog_hash") == catalog["catalog_hash"]
                  and browser.get("reader_source_digest") == reader_source_digest()
                  and browser.get("failures") == []
                  and browser.get("all_core_mobile_checks") == len(catalog["cores"])) and all(
        browser.get("checks", {}).get(key) is True for key in (
            "mobile_no_overflow", "desktop_no_overflow", "themes", "solution_disclosure",
            "graph_links", "search_excludes_answers"))
    if any("lean" in c["views"] for c in catalog["cores"]):
        browser_ok = browser_ok and browser.get("checks", {}).get("native_formal_panels") is True
    gates = {"content_bound_second_pass": not missing and bool(catalog["cores"]),
             "rendered_browser_checks": browser_ok,
             "cross_cohort_semantic_reconciliation": catalog["global_semantic_dedup_complete"],
             "shared_view_admission": catalog.get("native_formal_view_admission", {}).get("status") == "admitted"}
    return {"stable": all(gates.values()), "required_core_reviews": len(catalog["cores"]),
            "content_bound_second_pass_reviews": len(accepted), "pending_core_ids": missing,
            "gates": gates, "disputed_core_ids": sorted(disputed),
            "version_rename_is_not_an_acceptance_gate": True,
            "other_required_gates": ["rendered reader/browser publication checks", "shared-view semantic and split reconciliation", "current source/reference verification"]}


def summary(catalog):
    return {"version": catalog["version"], "admitted_core_ids": len(catalog["cores"]),
            "non_lean_views": sum("non-lean" in c["views"] for c in catalog["cores"]),
            "lean_views": sum("lean" in c["views"] for c in catalog["cores"]),
            "by_part": dict(Counter(c["part"] for c in catalog["cores"])),
            "by_split": dict(Counter(c["split"] for c in catalog["cores"])),
            "catalog_hash": catalog["catalog_hash"], "stable_readiness": stable_readiness(catalog)}
