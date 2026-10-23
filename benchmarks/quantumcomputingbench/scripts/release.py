#!/usr/bin/env python3
"""Audit the frozen preview; refuse obsolete native scoring/packaging after repairs."""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import sys
import zipfile

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "src"))
sys.path.insert(0, str(B / "scripts"))
from qcb import checked_release
from qcb_core import digest, model_input, read_json, score
from qcb_integrity import text_sha
from qcb_lean import APPROVED_AXIOMS
from qcb_nl_release_policy import check_current_gold
from nl_qa import load_checked
from check_references import ROOTS, PREFIX
from proof_inputs import proof_input_digest, lean_module_targets

TAG = "quantumcomputingbench-v0.1.0-preview.1"
NATIVE_VERSION = "nl-v12"
LEGACY_VERSION = "release-v3"
REFERENCE_REPORT = B / "reports/integration-20261022/lean-reference-checks.json"


def checked():
    snapshot, items, native = load_checked(NATIVE_VERSION)
    admission = read_json(B / "manifests/integration-20261022/admission.json")
    by_key = {i["key"]: i for i in native}
    for row in admission["quarantined"]:
        if row["key"] not in by_key or digest(by_key[row["key"]]) != row["item_digest"]:
            raise ValueError("integration quarantine binding changed: " + row["key"])
    excluded = {row["key"] for row in admission["quarantined"]}
    native = [i for i in native if i["key"] not in excluded]
    check_current_gold(native, frozen_preview_audit=True)
    legacy = checked_release(LEGACY_VERSION)
    if len({i["core_id"] for i in native}) != len(native):
        raise ValueError("duplicate native core ID")
    for item in native + legacy:
        if item["language"] != "en" or re.search(r"[\u3400-\u9fff]", item["question"] + item["reference_answer"]):
            raise ValueError("public QA must be English: " + item["key"])
    migration = read_json(B / "manifests/integration-20261022/path-migration.json")
    for row in migration["files"]:
        if (R / row["original_path"]).exists():
            raise ValueError("duplicate noncanonical upload remains: " + row["original_path"])
        if text_sha(R / row["canonical_path"]) != row["canonical_lf_sha256"]:
            raise ValueError("canonical upload content changed: " + row["canonical_path"])
    reference = read_json(REFERENCE_REPORT)
    if (reference["status"] != "reference_checked" or reference["isolated"] is not False
            or set(reference["checked_roots"]) != {PREFIX + name for name in ROOTS}
            or len(reference["generated_harnesses"]) != 3
            or reference["negative_control"]["reason"] != "sorry_axiom"
            or reference["wrong_type_control"]["status"] != "rejected"
            or reference["reference_pack_sha256"] != text_sha(B / "lean/ReferenceChecks.lean")
            or reference["proof_inputs_sha256"] != proof_input_digest(R)
            or reference["repository_gate"]["compiledModules"] != lean_module_targets(R)
            or reference["repository_gate"]["passed"] is not True):
        raise ValueError("fixed-reference evidence/context changed")
    for path, expected in reference["pipeline_hashes"].items():
        if text_sha(R / path) != expected:
            raise ValueError("fixed-reference checker changed: " + path)
    if (any(set(axioms) - APPROVED_AXIOMS for axioms in reference["checked_roots"].values())
            or any(set(h["axioms"]) - APPROVED_AXIOMS or h["isolated"] is not False
                   or h["status"] != "reference_checked" for h in reference["generated_harnesses"])):
        raise ValueError("fixed reference depends on unapproved axioms or changed execution scope")
    return snapshot, items, native, legacy


def release_manifest(snapshot, items, native, legacy, commit):
    return {
        "schema_version": "qcb.distribution.v1", "tag": TAG,
        "repository": "DakeBU/QuantumComputinglib-QuantumComputingBench",
        "repository_commit": commit, "publication_date": "2026-10-22",
        "status": "public_preview_not_complete_whole_graph_benchmark",
        "snapshot_id": snapshot["snapshot_id"],
        "native": {
            "version": NATIVE_VERSION, "admitted_core_ids": len(native),
            "imported_admitted_core_ids": 217,
            "active_records": len(items), "non_gold_records": len(items) - len(native),
            "inherited_provisional_records": 21, "integration_quarantined_records": 4,
            "release_digest": digest(native),
            "splits": dict(Counter(i["split"] for i in native)),
            "evidence": dict(Counter(i["evidence_relation"] for i in native)),
            "primary_target_nodes": len({n for i in native for n in i["target_nodes"]}),
            "semantic_step_counts": dict(Counter(str(i["semantic_step_count"]) for i in native)),
            "review_provenance": "Imported exact-content-bound AI reviews; software checks are not a new independent mathematical review.",
            "new_local_formal_verification_of_native_answers": False,
        },
        "legacy": {"version": LEGACY_VERSION, "diagnostic_records": len(legacy),
                   "release_digest": digest(legacy), "role": "separate_public_diagnostics_not_pooled_training"},
        "global_distinct_core_count": None,
        "cross_cohort_semantic_dedup_complete": False,
        "shared_formal_core_integration": "pending_real_external_collaborator_acknowledgment",
        "distribution_decision": "Maintainer authorized repository consolidation and preview publication; no external acknowledgment is fabricated.",
        "test_answers_public": True, "blind_or_contamination_free": False,
        "isolated_untrusted_lean_evaluation": "ENV_BLOCKED",
        "real_model_baseline": "UNMEASURED",
        "local_fixed_reference_replay": {
            "report_sha256": text_sha(REFERENCE_REPORT), "roots": 16, "application_harnesses": 3,
            "sorry_and_wrong_type_controls_rejected": True, "isolated": False,
            "scope": "Fixed reference pack only, not all native answers or model predictions.",
        },
        "training_or_paid_model_calls_performed": False,
        "license": "MIT for original authored QA and code; external-source rights remain separate.",
    }


def encoded(value):
    return (json.dumps(value, sort_keys=True, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


def payloads(snapshot, items, native, legacy, commit):
    files = {"manifest.json": encoded(release_manifest(snapshot, items, native, legacy, commit))}
    for split in ("train", "dev", "test_public"):
        selected = [i for i in native if i["split"] == split]
        files[f"data/native/{split}.json"] = encoded(selected)
        files[f"prompts/native/{split}.json"] = encoded([model_input(i) for i in selected])
    files["data/diagnostics/legacy-v3.json"] = encoded(legacy)
    admitted = {i["id"] for i in native}
    files["audit/native-non-gold.json"] = encoded([i for i in items if i["id"] not in admitted])
    for relative in (
        "manifests/nl-v12/release.json", "manifests/nl-v12/core-registry.json",
        "manifests/nl-v12/review-queue.json", "manifests/integration-20261022/compatibility.json",
        "manifests/integration-20261022/path-migration.json",
        "manifests/integration-20261022/admission.json",
        "docs/integration-release-2026-10-22.md", "docs/native-nl-dataset-card.md",
        "reports/nl-v12/summary.json",
        "reports/integration-20261022/lean-reference-checks.json",
    ):
        files["provenance/" + relative] = (B / relative).read_bytes().replace(b"\r\n", b"\n")
    files["README.md"] = (
        "# QuantumComputingBench public preview\n\n"
        "Native mathematical QA is under data/native; prompts exclude answers. "
        "Test answers are public. Do not describe these tests as blind or contamination-free.\n\n"
        "Legacy diagnostics are a separate cohort: do not concatenate them into native training "
        "or add their record count to the native distinct-core count. "
        "The audit directory is not training gold.\n\n"
        "This is a data distribution, not a standalone source checkout. For source-bound "
        "validation/scoring, clone the repository with full Git history, check out " + TAG +
        ", install benchmarks/quantumcomputingbench/requirements.txt, and run "
        "python benchmarks/quantumcomputingbench/scripts/release.py validate. "
        "Historical validator bytes and review artifacts remain inspectable in Git.\n\n"
        "NL source review is not a Lean certificate. Untrusted Lean evaluation remains "
        "ENV_BLOCKED, and model baseline performance is unmeasured. "
        "See manifest.json and provenance for exact scope and rights.\n"
    ).encode("utf-8")
    files["CHECKSUMS.sha256"] = "".join(
        f"{hashlib.sha256(data).hexdigest()}  {name}\n" for name, data in sorted(files.items())
    ).encode("ascii")
    return files


def zip_bytes(files):
    output = io.BytesIO()
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name, data in sorted(files.items()):
            info = zipfile.ZipInfo(name, date_time=(2026, 10, 22, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            archive.writestr(info, data)
    return output.getvalue()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["validate", "build", "score"])
    parser.add_argument("--output-dir", default=str(R / "_out/qcb-release"))
    parser.add_argument("--cohort", choices=["native", "legacy"], default="native")
    parser.add_argument("--predictions")
    parser.add_argument("--ratings")
    parser.add_argument("--output")
    args = parser.parse_args()
    try:
        snapshot, items, native, legacy = checked()
        commit = subprocess.check_output(["git", "-C", str(R), "rev-parse", "HEAD"], text=True).strip()
        manifest = release_manifest(snapshot, items, native, legacy, commit)
        from qcb_textbook_policy import apply_current_reader_policy, frozen_native_is_current
        current_reader, reader_decisions = apply_current_reader_policy(native)
        manifest["textbook_current_reader"] = {"native_core_ids": len(current_reader),
            "answer_decisions": reader_decisions,
            "frozen_preview_is_current_gold": frozen_native_is_current(native),
            "policy": "Published preview bytes remain historical; changed reader answers require a separately versioned future data release."}
        if (args.command == "build" or args.command == "score" and args.cohort == "native") and not frozen_native_is_current(native):
            raise ValueError("historical preview contains a withdrawn predecessor answer; do not repackage or score it as current gold. Inspect shared/current-policy.json and the reviewed textbook successor; a new data release is pending")
        if args.command == "score":
            if not args.predictions:
                raise ValueError("--predictions is required")
            result = score(native if args.cohort == "native" else legacy,
                           read_json(args.predictions), read_json(args.ratings) if args.ratings else None)
            if args.output:
                target = Path(args.output).resolve()
                if target.is_relative_to(R):
                    raise ValueError("private evaluator logs must remain outside the public repository")
                target.write_bytes(encoded(result))
            print(json.dumps(result["by_track"], indent=2))
        elif args.command == "build":
            if subprocess.check_output(["git", "-C", str(R), "status", "--porcelain"], text=True).strip():
                raise ValueError("commit the reviewed source tree before packaging")
            output = Path(args.output_dir).resolve()
            if output.is_relative_to(R) and not output.is_relative_to(R / "_out"):
                raise ValueError("build artifacts inside the repository must be under _out")
            output.mkdir(parents=True, exist_ok=True)
            archive = zip_bytes(payloads(snapshot, items, native, legacy, commit))
            name = TAG + ".zip"
            target = output / name
            if target.exists() and target.read_bytes() != archive:
                raise ValueError("refusing to overwrite a different release asset")
            target.write_bytes(archive)
            (output / "SHA256SUMS").write_text(hashlib.sha256(archive).hexdigest() + "  " + name + "\n", encoding="ascii")
            (output / "manifest.json").write_bytes(encoded(manifest))
            print(json.dumps({"asset": str(target), "sha256": hashlib.sha256(archive).hexdigest(), "bytes": len(archive)}))
        else:
            print(json.dumps(manifest, indent=2))
        return 0
    except (ValueError, KeyError, OSError, subprocess.SubprocessError) as error:
        print("ERROR: " + str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
