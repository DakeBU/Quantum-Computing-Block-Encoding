"""Freeze a corrected, explicitly provisional extension of the v2 release.

Inherited reviews are transferred only for identical authored SHA256 content.
This script does not pretend to be a new independent reviewer. The 12 changed
items remain candidates even after their reference propositions pass Lean.
"""
from copy import deepcopy
from pathlib import Path
import sys

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "src"))
sys.path.insert(0, str(B / "scripts"))
from qcb_core import assign_splits, content_hash, digest, model_input, prepare, read_json, score, validate, write_json
from qcb_integrity import WITHDRAWN, check_not_withdrawn, matches, snapshot_input_matches, text_sha
from qcb_snapshot import snapshot, coverage
from qcb import schema_check

HOLDOUTS = {"real-amplitude-preparation", "givens-decomposition", "thin-lq", "breadth-banded-inverse-register"}


def main():
    version = "release-v3"
    public = B / "data/public" / version
    manifest = B / "manifests" / version
    reports = B / "reports" / version
    baseline = read_json(B / "manifests/release-v2/snapshot.json")
    for relative, expected in baseline["input_hashes"].items():
        if not snapshot_input_matches(R, relative, expected):
            raise ValueError("v2 library differs: " + relative)
    old = read_json(B / "data/public/release-v2/items.json")
    errors = validate(old, baseline, R)
    if errors:
        raise ValueError("legacy admission artifacts changed: " + str(errors[:5]))
    references = read_json(reports / "lean-reference-checks.json")
    if references["status"] != "reference_checked" or not matches(B / "lean/ReferenceChecks.lean", references["reference_pack_sha256"]):
        raise ValueError("actual local Lean reference checks required first")
    for relative, expected in references["pipeline_hashes"].items():
        if not matches(R / relative, expected):
            raise ValueError("reference checker changed; replay it: " + relative)
    snap = snapshot(R)
    if (manifest / "snapshot.json").exists():
        prior = read_json(manifest / "snapshot.json")
        if prior["input_hashes"] != snap["input_hashes"]:
            raise ValueError("library changed; create a successor version")
        snap = prior  # a documentation-only commit must not rewrite source provenance
    raw = []
    batches = sorted((B / "data/authored").glob("*.json"))
    for path in batches:
        batch = read_json(path)
        raw.extend(batch["items"] if isinstance(batch, dict) else batch)
    superseded = {i["supersedes"] for i in raw if i.get("supersedes")}
    raw = [i for i in raw if i["key"] not in superseded]
    if len({i["key"] for i in raw}) != len(raw):
        raise ValueError("duplicate authoring key")
    check_not_withdrawn(raw)
    items = assign_splits(prepare(raw, snap), HOLDOUTS)
    candidates = deepcopy(items)
    inherited = {i["authored_hash"]: i for i in old if i["lifecycle"] == "released" and i["key"] not in WITHDRAWN}
    transfers = []
    for item in items:
        previous = inherited.get(item["authored_hash"])
        if previous:
            item["reviews"] = deepcopy(previous["reviews"])
            for review in item["reviews"]:
                if review.get("authored_sha256") != item["authored_hash"]:
                    raise ValueError("review lacks exact authored-content binding")
                review["content_hash"] = content_hash(item)
            item["lifecycle"] = "released"
            item["validation"] = deepcopy(previous["validation"])
            transfers.append({"old_id": previous["id"], "new_id": item["id"], "authored_sha256": item["authored_hash"],
                              "method": "exact-content review inheritance, NOT a new independent review"})
        if item.get("reference_checks"):
            item["verification_receipts"] = [{"execution_class": "trusted_local_reference", "isolated": False,
                "report": "benchmarks/quantumcomputingbench/reports/release-v3/lean-reference-checks.json",
                "report_hash": digest(references), "roots": ["QuantumComputingBench.ReferenceChecks." + r for r in item["reference_checks"]],
                "status": "reference_checked", "nl_alignment": "pending_independent_review"}]
    errors = schema_check(items) + validate(items, snap, R)
    if errors:
        raise ValueError("\n".join(errors))
    released = [i for i in items if i["lifecycle"] == "released"]
    provisional = [i for i in items if i.get("reference_checks")]
    check_not_withdrawn(released + provisional)
    for name, value in [("items", items), ("candidates", candidates), ("release", released), ("provisional", provisional)]:
        write_json(public / (name + ".json"), value, immutable=True)
    for name, values in [("closed_book", released), ("provisional", provisional)]:
        write_json(public / ("prompts-" + name + ".json"), [model_input(i) for i in values], immutable=True)
    write_json(public / "prompts-open_library.json", [model_input(i, "open_library") for i in released], immutable=True)
    write_json(manifest / "snapshot.json", snap, immutable=True)
    write_json(manifest / "review-inheritance.json", {"baseline_commit": "86b9e677566498da04faebcf4e5ed57f177c6bb1",
        "withdrawn": WITHDRAWN, "transfers": transfers, "new_independent_reviews": 0}, immutable=True)
    write_json(manifest / "splits.json", {"holdout_families": sorted(HOLDOUTS), "planned_track": "separate planned/OOD test_public stratum",
        "exposure_warning": "Retrospective public grouped diagnostic; v2 and its answers were public. Not secret, unseen, or contamination-free.",
        "shared_foundations": "Support lemmas can be shared across splits; family and target-solution unions are indivisible.",
        "assignments": [{"id": i["id"], "group": i["split_group"], "split": i["split"], "track": i["track"]} for i in items]}, immutable=True)
    write_json(manifest / "release.json", {"schema_version": "qcb.release.v1", "snapshot_id": snap["snapshot_id"],
        "items_hash": digest(released), "ids": [i["id"] for i in released],
        "splits": {s: [i["id"] for i in released if i["split"] == s] for s in ["train", "dev", "test_public"]},
        "provisional_items_hash": digest(provisional), "provisional_count": len(provisional),
        "private_gold_published": False, "test_is_public": True, "baseline": "unmeasured",
        "license": "See dataset card; external source text not redistributed."}, immutable=True)
    write_json(manifest / "generation.json", {"method": "curated-source-inspected authoring; not an automated full-graph authoring agent",
        "batches": [p.name for p in batches], "authoring_hash": digest(raw), "calls": 0, "cost_usd": 0,
        "independent_review_of_new_items": "pending", "new_reference_checked_candidates": len(provisional), "benchmark_complete": False}, immutable=True)
    pipeline_files = sorted([p for d in [B / "src", B / "scripts", B / "schemas", B / "configs"] for p in d.glob("*")
                             if p.is_file() and p.suffix in {".py", ".json"}])
    pipeline_files.append(B / "requirements.txt")
    write_json(manifest / "pipeline.json", {"hash_policy": "sha256-lf-text-v1",
        "input_hashes": {p.relative_to(R).as_posix(): text_sha(p) for p in pipeline_files},
        "purpose": "Bind validator/scorer/generator/schema/config separately from the mathematical-library snapshot"}, immutable=True)
    report = coverage(snap, items)
    write_json(reports / "coverage.json", report, immutable=True)
    write_json(reports / "validation.json", {"schema_valid": len(items), "structural_errors": [],
        "inherited_reviewed_release": len(released), "withdrawn_old_gold": sorted(WITHDRAWN),
        "provisional": len(provisional), "independent_review_pending": True, "whole_graph_complete": False}, immutable=True)
    exact = [i for i in provisional if i["answer_format"] == "exact"]
    pos = score(exact, [{"id": i["id"], "answer": i["reference_answer"]} for i in exact])
    neg = score(exact, [{"id": i["id"], "answer": "incorrect"} for i in exact])
    write_json(reports / "provisional-scoring-smoke.json", {"fixture_only": True, "model_performance_measured": False,
        "provisional_exact_count": len(exact), "all_positive_controls_one": all(r["correctness"] == 1 for r in pos["results"]),
        "all_negative_controls_zero": all(r["correctness"] == 0 for r in neg["results"]),
        "warning": "Scorer plumbing checks, not independent NL validation or a model baseline"}, immutable=True)
    # The reviewer receives full frozen candidates. No reviewer identity is invented.
    write_json(manifest / "review-queue.json", {"reviewer": None, "state": "awaiting genuinely independent review",
        "instructions": "Inspect actual declarations, full ambient source, NL semantics and local Lean report. Review the sparse/physical-resource boundaries independently. Do not accept just because a referenced Lean theorem compiles.",
        "items": [{"key": i["key"], "id": i["id"], "authored_sha256": i["authored_hash"], "content_hash": content_hash(i),
                   "source_refs": i["source_refs"], "reference_checks": i.get("reference_checks", [])} for i in provisional]}, immutable=True)
    print({"items": len(items), "reviewed_release": len(released), "reference_checked_provisional": len(provisional),
           "splits": report["released_axes"]["split"], "whole_graph_complete": False})


if __name__ == "__main__":
    main()
