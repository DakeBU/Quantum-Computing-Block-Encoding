#!/usr/bin/env python3
"""Deterministic export checker for QBE-MAIN-CASE-HIER-COLD-001."""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path
from typing import Any


TASK = "QBE-MAIN-CASE-HIER-COLD-001"
LEAF = "MAIN-EXPORT-VERIFY-001"
ROOT = Path(__file__).resolve().parent
QISKIT_EXPORT = ROOT / "qiskit" / "export.py"
QASM3_EXPORT = ROOT / "qasm3" / "main_case_cold_partial_perm.qasm3"
MANIFEST = ROOT / "export-manifest.json"
EXPECTED_ACTION = [14, 15, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 12, 13]
EXPECTED_SUPPORT = {(0, 6), (1, 7)}
EXPECTED_RESOURCE = {
    "gateCount": 5,
    "depth": 5,
    "auxiliaryQubits": 1,
    "oracleCalls": 0,
}


def load_export_module() -> Any:
    spec = importlib.util.spec_from_file_location("main_case_cold_export", QISKIT_EXPORT)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"could not load {QISKIT_EXPORT}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def clean_support(action: list[int]) -> set[tuple[int, int]]:
    return {
        (row, col)
        for row in range(8)
        for col in range(8)
        if row == action[col]
    }


def build_feedback() -> dict[str, Any]:
    module = load_export_module()
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    qasm_text = QASM3_EXPORT.read_text(encoding="utf-8")
    action = [int(module.basis_action(index)) for index in range(16)]
    local_check = module.check_export()

    finite_matrix_ok = action == EXPECTED_ACTION
    block_entry_ok = clean_support(action) == EXPECTED_SUPPORT
    ancilla_cleanup_ok = all((action[index] % 2) == (index % 2) for index in range(16))
    unitarity_ok = sorted(action) == list(range(16))
    normalizer_ok = manifest.get("normalizer") == 1 and manifest.get("epsilon") == 0
    resource_ok = manifest.get("resource_score") == EXPECTED_RESOURCE
    qasm3_ok = "OPENQASM 3" in qasm_text and all(gate in qasm_text for gate in ["x q[2];", "ccx q[1], q[2], q[3];", "cx q[1], q[3];"])
    source_correspondence_ok = all([
        finite_matrix_ok,
        block_entry_ok,
        ancilla_cleanup_ok,
        unitarity_ok,
        normalizer_ok,
        resource_ok,
        qasm3_ok,
        bool(local_check.passed),
    ])

    return {
        "task": TASK,
        "leaf": LEAF,
        "source_correspondence_ok": source_correspondence_ok,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "finite_matrix_ok": finite_matrix_ok,
        "block_entry_ok": block_entry_ok,
        "ancilla_cleanup_ok": ancilla_cleanup_ok,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": unitarity_ok,
        "resource_score": "(5,5,1,0)",
        "resource_ok": resource_ok,
        "qasm3_ok": qasm3_ok,
        "auxiliary_qubits": 1,
        "gate_count": 5,
        "depth": 5,
        "oracle_calls": 0,
        "closed_theorem_ok": False,
        "lean_certificate": "mainCaseColdPartialPermVerified",
        "lean_cost_theorem": "mainCaseColdPartialPermCandidate_cost",
        "basis_action": action,
        "observed_clean_support": [list(pair) for pair in sorted(clean_support(action))],
        "error_class": None if source_correspondence_ok else "source_translation_gap",
        "next_route": (
            "Reviewer should audit the post-Lean executable artifacts against the named Lean certificate."
            if source_correspondence_ok
            else "Repair the generated export artifacts before review."
        ),
    }


def main() -> int:
    feedback = build_feedback()
    print(json.dumps(feedback, indent=2, sort_keys=True))
    return 0 if feedback["error_class"] is None else 1


if __name__ == "__main__":
    raise SystemExit(main())
