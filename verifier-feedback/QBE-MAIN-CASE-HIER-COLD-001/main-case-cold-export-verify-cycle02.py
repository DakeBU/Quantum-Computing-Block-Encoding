#!/usr/bin/env python3
"""Cycle-2 necessary-condition verifier for COLD executable exports.

This is a post-Lean diagnostic.  It reuses the durable cycle-1 checker helpers
and records the current proof-DAG leaf and run id.  Passing this script would
not prove a Lean theorem; failing it blocks export review because there is no
executable artifact to compare with the compiled COLD finite table.
"""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path


TASK = "QBE-MAIN-CASE-HIER-COLD-001"
RUN = "20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02"
LEAF = "MAIN-EXPORT-VERIFY-001"
EXPORT_ROOT = Path("executable-exports") / TASK
EXPECTED_RESOURCE = "(5,5,1,0)"
REQUIRED_WIRE_MAP = {"S": 0, "tau": 1, "T": 2, "signal": 3}
FULL_INDEX = "8*signal + 4*T + 2*tau + S"


def load_cycle01_module():
    path = Path(__file__).with_name("main-case-cold-export-cycle01.py")
    spec = importlib.util.spec_from_file_location("main_case_cold_export_cycle01", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load verifier helper {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    helper = load_cycle01_module()
    qiskit_dir = EXPORT_ROOT / "qiskit"
    qasm_dir = EXPORT_ROOT / "qasm3"
    qasm_files = sorted(qasm_dir.glob("*.qasm")) + sorted(qasm_dir.glob("*.qasm3"))
    manifest_files = sorted(path for path in EXPORT_ROOT.glob("*manifest*") if path.is_file())

    action, action_messages = helper.discover_python_action(qiskit_dir)
    messages = list(action_messages)
    if not qasm_dir.is_dir():
        messages.append("missing qasm3/ directory")
    elif not qasm_files:
        messages.append("missing qasm3/*.qasm or qasm3/*.qasm3 export file")
    if not manifest_files:
        messages.append("missing export manifest")
    messages.append("required Lean bit positions are S=0,tau=1,T=2,signal=3")

    if action is None:
        finite_matrix_ok = False
        block_entry_ok = False
        ancilla_cleanup_ok = False
        unitarity_ok = False
        observed_support = None
        action_matches_reference = False
    else:
        action_matches_reference = all(
            action(index) == helper.REFERENCE_ACTION[index] for index in range(16)
        )
        observed = helper.clean_support(action)
        observed_support = sorted([list(pair) for pair in observed])
        finite_matrix_ok = action_matches_reference
        block_entry_ok = observed == helper.EXPECTED_SUPPORT
        ancilla_cleanup_ok = helper.passive_preserved(action)
        unitarity_ok = helper.is_permutation(action)

    manifest_text = helper.artifact_texts(manifest_files)
    normalizer_ok = bool(manifest_files) and "normalizer" in manifest_text and "1" in manifest_text
    resource_ok = bool(manifest_files) and (
        EXPECTED_RESOURCE in manifest_text
        or all(token in manifest_text for token in ("gateCount", "depth", "auxiliaryQubits", "oracleCalls"))
    )
    qasm3_ok = bool(qasm_files) and all("OPENQASM 3" in path.read_text() for path in qasm_files)

    generated_paths = sorted(qiskit_dir.glob("*")) + qasm_files + manifest_files
    generated_text = helper.artifact_texts([path for path in generated_paths if path.is_file()])
    forbidden_reference_ok = not any(token in generated_text for token in helper.FORBIDDEN_TOKENS)

    required_artifacts_present = bool(qiskit_dir.is_dir() and qasm_dir.is_dir() and manifest_files)
    source_correspondence_ok = (
        required_artifacts_present
        and finite_matrix_ok
        and block_entry_ok
        and normalizer_ok
        and resource_ok
        and qasm3_ok
        and forbidden_reference_ok
    )

    reference_support = helper.clean_support(lambda index: helper.REFERENCE_ACTION[index])
    reference_finite_matrix_ok = (
        reference_support == helper.EXPECTED_SUPPORT
        and helper.passive_preserved(lambda index: helper.REFERENCE_ACTION[index])
        and helper.is_permutation(lambda index: helper.REFERENCE_ACTION[index])
    )

    if not required_artifacts_present:
        error_class = "source_translation_gap"
        next_route = (
            "Generate qiskit/qasm3/manifest artifacts for "
            "mainCaseColdPartialPermVerified using q[0]=S,q[1]=tau,q[2]=T,q[3]=signal, "
            "then rerun this verifier."
        )
    elif not finite_matrix_ok or not block_entry_ok:
        error_class = "finite_matrix_counterexample"
        next_route = "Repair the exported basis action to match mainCaseColdPartialPermImage before review."
    elif not normalizer_ok or not resource_ok or not qasm3_ok:
        error_class = "shape_or_register_gap"
        next_route = "Repair export metadata/register syntax while preserving the certified COLD circuit."
    elif not forbidden_reference_ok:
        error_class = "invalid_route"
        next_route = "Remove Pro-arm or previous-export evidence and regenerate from COLD declarations only."
    else:
        error_class = None
        next_route = "Review export artifacts and run the project gate."

    feedback = {
        "task": TASK,
        "run": RUN,
        "leaf": LEAF,
        "source_correspondence_ok": source_correspondence_ok,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "finite_matrix_ok": finite_matrix_ok,
        "block_entry_ok": block_entry_ok,
        "ancilla_cleanup_ok": ancilla_cleanup_ok,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": unitarity_ok,
        "resource_score": EXPECTED_RESOURCE,
        "resource_ok": resource_ok,
        "qasm3_ok": qasm3_ok,
        "forbidden_reference_ok": forbidden_reference_ok,
        "reference_finite_matrix_ok": reference_finite_matrix_ok,
        "observed_clean_support": observed_support,
        "expected_clean_support": sorted([list(pair) for pair in helper.EXPECTED_SUPPORT]),
        "closed_theorem_ok": False,
        "error_class": error_class,
        "next_route": next_route,
        "required_wire_map": REQUIRED_WIRE_MAP,
        "full_index": FULL_INDEX,
        "artifact_presence": {
            "qiskit_dir": qiskit_dir.is_dir(),
            "qiskit_python_action": action is not None,
            "qasm3_dir": qasm_dir.is_dir(),
            "qasm3_files": [str(path) for path in qasm_files],
            "manifest_files": [str(path) for path in manifest_files],
        },
        "messages": messages,
    }
    print(json.dumps(feedback, indent=2, sort_keys=True))
    return 0 if error_class is None else 1


if __name__ == "__main__":
    raise SystemExit(main())
