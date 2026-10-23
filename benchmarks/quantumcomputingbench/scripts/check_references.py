"""Run ONLY the repository's inspected, fixed reference pack on local Lean.

Never pass model output here. This is trusted-local-reference evidence, NOT
isolated evaluation certification and NOT an independent NL/source review.
An alternate cached checkout is accepted only with identical proof inputs and
a fresh complete repository gate. No Lean dependencies are installed/fetched.
"""
from __future__ import annotations
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
from proof_inputs import proof_input_digest
from qcb_core import digest, read_json, write_json
from qcb_integrity import text_sha
from qcb_lean import APPROVED_AXIOMS, build_harness, evaluate_report, validate_proof_grammar

ROOTS = {"ryZero", "flipInvolution", "planeDet", "resourceWitness", "disjointDemandNotMax",
         "zeroSplit", "sparseNonnegative", "sparseHasZero", "sparsePositiveMass",
         "sparseNotStrictlyPositive", "sparsePrepared", "oracleAbstractGate", "addressWidth", "addressBoundary",
         "halfAngle", "oracleResourceTuple"}
PREFIX = "QuantumComputingBench.ReferenceChecks."


def parse_reference_output(output):
    found = {}
    for line in output.splitlines():
        if not line.startswith("QCB_REFERENCE_AXIOMS|"):
            continue
        _, root, axioms = line.split("|")
        if root in found:
            raise ValueError("duplicate reference audit root")
        names = sorted(filter(None, axioms.split(",")))
        if set(names) - APPROVED_AXIOMS:
            raise ValueError("unapproved transitive axiom on " + root)
        found[root] = names
    if set(found) != {PREFIX + r for r in ROOTS}:
        raise ValueError("missing/unexpected reference theorem audit")
    return found


def execute(build, path, require_success=True):
    result = subprocess.run(["lake", "env", "lean", str(path)], cwd=build,
                            capture_output=True, text=True, encoding="utf-8", timeout=300)
    if require_success and result.returncode:
        raise ValueError("Lean reference replay failed:\n" + result.stdout[-16000:] + result.stderr[-4000:])
    return result


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--build-root", type=Path, default=R)
    p.add_argument("--trusted-local-reference", action="store_true", required=True)
    p.add_argument("--output", type=Path, required=True)
    args = p.parse_args()
    build = args.build_root.resolve()
    identity = proof_input_digest(R)
    if identity != proof_input_digest(build):
        raise ValueError("cached build has different production proof inputs")
    gate = read_json(build / "_out/lean-gate.json")
    if not gate.get("passed") or gate.get("proofInputsSha256") != identity:
        raise ValueError("run website/scripts/run_lean_gate.py on the matching build first")
    pack = B / "lean/ReferenceChecks.lean"
    before = text_sha(pack)
    pipeline_paths = [Path(__file__), B / "src/qcb_lean.py"]
    pipeline_hashes = {p.relative_to(R).as_posix(): text_sha(p) for p in pipeline_paths}
    output = execute(build, pack).stdout
    roots = parse_reference_output(output)
    # Real generated-harness integration, against trusted constant references.
    # The negative sorry test is generated only in a temporary engineering file.
    harnesses = []
    proof_items = [i for i in read_json(B / "data/authored/repairs-v3.json") if i.get("formal")]
    with tempfile.TemporaryDirectory(prefix="qcb-trusted-reference-") as directory:
        path = Path(directory) / "Harness.lean"
        for item in proof_items:
            proof = item["formal"]["reference_proof"]
            validate_proof_grammar(proof)
            frozen = {"id": item["key"], "formal_context": {k: item["formal"][k] for k in ("imports", "target")}}
            source, _ = build_harness(frozen, proof, "referenceIntegration")
            path.write_text(source, encoding="utf-8", newline="\n")
            result = execute(build, path)
            outcome = evaluate_report(result.returncode, result.stdout, result.stderr, "referenceIntegration")
            if outcome["status"] != "certified":
                raise ValueError("trusted generated harness did not pass: " + json.dumps(outcome))
            harnesses.append({"key": item["key"], "formal_context": frozen["formal_context"],
                "proof_sha256": hashlib.sha256(proof.encode()).hexdigest(),
                "source_sha256": hashlib.sha256(source.encode()).hexdigest(), "axioms": outcome["axioms"],
                "status": "reference_checked", "isolated": False})
        # Exercise collectAxioms/evaluation, not just a string-filter unit test.
        bad = source.replace(proof_items[-1]["formal"]["reference_proof"], "by sorry")
        path.write_text(bad, encoding="utf-8", newline="\n")
        result = execute(build, path)
        negative = evaluate_report(result.returncode, result.stdout, result.stderr, "referenceIntegration")
        if negative.get("reason") != "sorry_axiom":
            raise ValueError("negative control failed to reject sorryAx")
        wrong = source.replace(proof_items[-1]["formal"]["reference_proof"],
                               proof_items[0]["formal"]["reference_proof"])
        path.write_text(wrong, encoding="utf-8", newline="\n")
        result = execute(build, path, require_success=False)
        wrong_type = evaluate_report(result.returncode, result.stdout, result.stderr, "referenceIntegration")
        if result.returncode == 0 or wrong_type["reason"] != "unproven":
            raise ValueError("wrong-type proof was not rejected")
    if text_sha(pack) != before or proof_input_digest(R) != identity or proof_input_digest(build) != identity:
        raise ValueError("proof inputs changed during replay")
    if any(text_sha(R / p) != sha for p, sha in pipeline_hashes.items()):
        raise ValueError("reference checker changed during replay")
    gate_public = {k: v for k,v in gate.items() if k != "completedAtUtc"}
    report = {"schema_version": "qcb.reference_check.v1", "status": "reference_checked",
        "execution_class": "trusted_local_reference", "isolated": False,
        "independent_nl_review": False, "proof_inputs_sha256": identity,
        "reference_pack_sha256": before, "checked_roots": roots,
        "generated_harnesses": harnesses, "negative_control": negative, "wrong_type_control": wrong_type,
        "repository_gate": gate_public,
        "pipeline_hashes": pipeline_hashes,
        "limitations": ["No untrusted model output executed", "Local reference evidence does not enable container certification",
                        "Lean validity does not independently prove natural-language alignment or external-source fidelity"]}
    write_json(args.output, report, immutable=True)
    print(json.dumps({"status": report["status"], "roots": len(roots), "harnesses": len(harnesses),
                      "isolated": False, "negative_sorry_rejected": True}))


if __name__ == "__main__":
    main()
