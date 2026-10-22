#!/usr/bin/env python3
"""Freeze blinded review inputs or replay only the inspected native fixed references."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "src"))
sys.path.insert(0, str(R / "website/scripts"))
from qcb_core import digest, read_json, write_json
from qcb_curriculum import load_catalog
from qcb_formal_views import candidates, decoder_packet, EVIDENCE
from qcb_integrity import text_sha
from qcb_lean import build_harness, evaluate_report
from proof_inputs import proof_input_digest, lean_module_targets


def run_references(batch, build):
    identity = proof_input_digest(R)
    if identity != proof_input_digest(build):
        raise ValueError("reference cache has different production proof inputs")
    gate = read_json(build / "_out/lean-gate.json")
    modules = lean_module_targets(R)
    if not gate.get("passed") or gate.get("proofInputsSha256") != identity or gate.get("compiledModules") != modules:
        raise ValueError("run the complete Lean gate in the matching cached checkout first")
    sources = [Path(__file__), B / "src/qcb_formal_views.py", B / "src/qcb_lean.py"]
    pipelines = {p.relative_to(R).as_posix(): text_sha(p) for p in sources}
    records = []
    def execute(path):
        return subprocess.run(["lake", "env", "lean", str(path)], cwd=build, capture_output=True,
                              text=True, encoding="utf-8", timeout=300)
    with tempfile.TemporaryDirectory(prefix="qcb-native-fixed-reference-") as temp:
        path = Path(temp) / "Reference.lean"
        for view in batch["views"]:
            item = {"id": view["view_id"], "formal_context": view["formal_context"]}
            source, name = build_harness(item, view["reference_proof"], "nativeReference")
            path.write_text(source, encoding="utf-8", newline="\n")
            result = execute(path)
            outcome = evaluate_report(result.returncode, result.stdout, result.stderr, "nativeReference")
            if outcome["status"] != "certified":
                raise ValueError("native reference did not elaborate: " + view["view_id"] + "\n" + result.stdout[-6000:] + result.stderr[-2000:])
            records.append({"view_id": view["view_id"], "formal_context_digest": digest(view["formal_context"]),
                            "root_name": name, "source_sha256": hashlib.sha256(source.encode()).hexdigest(),
                            "axioms": outcome["axioms"], "sorry": outcome["sorry"], "status": "reference_checked"})
        proof = batch["views"][-1]["reference_proof"]
        if source.count(proof) != 1:
            raise ValueError("negative control cannot identify the exact proof slot")
        path.write_text(source.replace(proof, "by sorry", 1), encoding="utf-8", newline="\n")
        result = execute(path)
        negative = evaluate_report(result.returncode, result.stdout, result.stderr, "nativeReference")
        if negative.get("reason") != "sorry_axiom":
            raise ValueError("actual sorryAx negative control was not rejected")
        path.write_text(source.replace(proof, batch["views"][0]["reference_proof"], 1), encoding="utf-8", newline="\n")
        result = execute(path)
        wrong = evaluate_report(result.returncode, result.stdout, result.stderr, "nativeReference")
        if result.returncode == 0 or wrong.get("reason") != "unproven":
            raise ValueError("actual wrong-type negative control was not rejected")
    if proof_input_digest(R) != identity or proof_input_digest(build) != identity:
        raise ValueError("production proof inputs changed during native replay")
    if any(text_sha(R / path) != sha for path, sha in pipelines.items()):
        raise ValueError("native replay pipeline changed during execution")
    return {"schema_version": "qcb.native_reference_checks.v1", "batch_digest": digest(batch),
            "execution_class": "trusted_local_reference", "isolated": False, "views": records,
            "proof_inputs_sha256": identity, "compiled_modules": modules, "pipeline_hashes": pipelines,
            "repository_gate": {k: v for k, v in gate.items() if k != "completedAtUtc"},
            "sorry_control_rejected": True, "wrong_type_control_rejected": True,
            "negative_control": negative, "wrong_type_control": wrong,
            "limitations": ["Only inspected fixed proofs were run; no model output executed.",
                            "Local reference validity is not isolated prediction certification or NL fidelity.",
                            "These are library applications; no deep proof-synthesis baseline is measured."]}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("command", choices=("decoder-input", "comparison-input", "check-references"))
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--build-root", type=Path, default=R)
    p.add_argument("--trusted-local-reference", action="store_true")
    args = p.parse_args()
    catalog, items, _ = load_catalog()
    batch = candidates(catalog["cores"])
    if args.command == "decoder-input":
        payload = decoder_packet(batch)
    elif args.command == "comparison-input":
        decoder = read_json(EVIDENCE / "decoder.json")
        if decoder.get("packet_digest") != digest(decoder_packet(batch)):
            raise ValueError("decoder did not reconstruct this exact blinded input")
        payload = {"schema_version": "qcb.anti_anchored_comparison_packet.v1", "batch_digest": digest(batch),
                   "decoder_digest": digest(decoder), "author": batch["author"], "decoder": decoder["decoder"], "views": []}
        decoded = {r["anonymous_id"]: r for r in decoder["views"]}
        for view in batch["views"]:
            item = items[view["core_id"]]
            payload["views"].append({"anonymous_id": view["anonymous_id"], "core_id": view["core_id"],
                "question_contract_hash": view["contract_hash"], "formal_context": view["formal_context"],
                "reconstruction": decoded[view["anonymous_id"]],
                "source_question": {k: item[k] for k in ("question", "assumptions", "conventions", "reference_answer", "rubric", "source_refs")}})
    else:
        if not args.trusted_local_reference:
            raise ValueError("fixed reference execution requires explicit --trusted-local-reference")
        payload = run_references(batch, args.build_root.resolve())
    write_json(args.output, payload, immutable=True)
    print(json.dumps({"output": str(args.output), "digest": digest(payload), "kind": args.command}, indent=2))


if __name__ == "__main__":
    main()
