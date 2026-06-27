#!/usr/bin/env python3
"""Necessary-condition verifier for the COLD MAIN-EXPORT-001 leaf.

This script does not prove any Lean theorem.  It checks whether post-Lean
export artifacts expose enough deterministic data to compare their basis action
with the certified COLD finite table.
"""

from __future__ import annotations

import ast
import importlib.util
import json
from pathlib import Path
from typing import Callable


TASK = "QBE-MAIN-CASE-HIER-COLD-001"
RUN = "20260627-122318-QBE-MAIN-CASE-HIER-COLD-001-cycle01"
LEAF = "MAIN-EXPORT-001"
EXPORT_ROOT = Path("executable-exports") / TASK

REFERENCE_ACTION = {
    0: 14,
    1: 15,
    2: 8,
    3: 9,
    4: 10,
    5: 11,
    6: 0,
    7: 1,
    8: 2,
    9: 3,
    10: 4,
    11: 5,
    12: 6,
    13: 7,
    14: 12,
    15: 13,
}
EXPECTED_SUPPORT = {(0, 6), (1, 7)}
EXPECTED_RESOURCE = "(5,5,1,0)"
FORBIDDEN_TOKENS = ("mainCasePro", "MAINCASE-PRO", "MAIN-PRO")


def clean_embed(system_index: int) -> int:
    return system_index


def clean_support(action: Callable[[int], int]) -> set[tuple[int, int]]:
    return {
        (row, col)
        for row in range(8)
        for col in range(8)
        if clean_embed(row) == action(clean_embed(col))
    }


def passive_preserved(action: Callable[[int], int]) -> bool:
    return all((action(index) % 2) == (index % 2) for index in range(16))


def is_permutation(action: Callable[[int], int]) -> bool:
    image = [action(index) for index in range(16)]
    return sorted(image) == list(range(16))


def action_from_table(table: object) -> Callable[[int], int] | None:
    if isinstance(table, list) and len(table) == 16:
        values = [int(value) for value in table]
        return lambda index: values[index]
    if isinstance(table, dict):
        values = {int(key): int(value) for key, value in table.items()}
        if set(values) == set(range(16)):
            return lambda index: values[index]
    return None


def static_python_action(path: Path) -> Callable[[int], int] | None:
    module = ast.parse(path.read_text())
    names = {
        "BASIS_ACTION",
        "BASIS_ACTION_TABLE",
        "MAIN_CASE_COLD_BASIS_ACTION",
    }
    for statement in module.body:
        if not isinstance(statement, ast.Assign):
            continue
        for target in statement.targets:
            if isinstance(target, ast.Name) and target.id in names:
                try:
                    action = action_from_table(ast.literal_eval(statement.value))
                except Exception:
                    action = None
                if action is not None:
                    return action
    return None


def imported_python_action(path: Path) -> Callable[[int], int] | None:
    spec = importlib.util.spec_from_file_location("main_case_cold_export", path)
    if spec is None or spec.loader is None:
        return None
    module = importlib.util.module_from_spec(spec)
    try:
        spec.loader.exec_module(module)
    except Exception:
        return None
    basis_action = getattr(module, "basis_action", None)
    if not callable(basis_action):
        return None
    try:
        values = [int(basis_action(index)) for index in range(16)]
    except Exception:
        return None
    return action_from_table(values)


def discover_python_action(qiskit_dir: Path) -> tuple[Callable[[int], int] | None, list[str]]:
    messages: list[str] = []
    if not qiskit_dir.is_dir():
        return None, ["missing qiskit/ directory"]
    py_files = sorted(path for path in qiskit_dir.glob("*.py") if path.name != "__init__.py")
    if not py_files:
        return None, ["missing qiskit/*.py export file"]
    for path in py_files:
        action = static_python_action(path)
        if action is not None:
            return action, [f"loaded static basis table from {path}"]
        action = imported_python_action(path)
        if action is not None:
            return action, [f"loaded basis_action from {path}"]
    messages.append("no qiskit export exposes BASIS_ACTION or basis_action(index)")
    return None, messages


def artifact_texts(paths: list[Path]) -> str:
    chunks: list[str] = []
    for path in paths:
        try:
            chunks.append(path.read_text())
        except UnicodeDecodeError:
            chunks.append(path.read_bytes().decode("utf-8", errors="ignore"))
    return "\n".join(chunks)


def main() -> int:
    qiskit_dir = EXPORT_ROOT / "qiskit"
    qasm_dir = EXPORT_ROOT / "qasm3"
    qasm_files = sorted(qasm_dir.glob("*.qasm")) + sorted(qasm_dir.glob("*.qasm3"))
    manifest_files = sorted(path for path in EXPORT_ROOT.glob("*manifest*") if path.is_file())

    action, action_messages = discover_python_action(qiskit_dir)

    if action is None:
        finite_matrix_ok = False
        block_entry_ok = False
        ancilla_cleanup_ok = False
        unitarity_ok = False
        observed_support: list[list[int]] | None = None
        action_matches_reference = False
    else:
        action_matches_reference = all(action(index) == REFERENCE_ACTION[index] for index in range(16))
        observed = clean_support(action)
        observed_support = sorted([list(pair) for pair in observed])
        finite_matrix_ok = action_matches_reference
        block_entry_ok = observed == EXPECTED_SUPPORT
        ancilla_cleanup_ok = passive_preserved(action)
        unitarity_ok = is_permutation(action)

    manifest_text = artifact_texts(manifest_files)
    normalizer_ok = bool(manifest_files) and "normalizer" in manifest_text and "1" in manifest_text
    resource_ok = bool(manifest_files) and (
        EXPECTED_RESOURCE in manifest_text
        or all(token in manifest_text for token in ("gateCount", "depth", "auxiliaryQubits", "oracleCalls"))
    )
    qasm3_ok = bool(qasm_files) and all("OPENQASM 3" in path.read_text() for path in qasm_files)

    generated_paths = sorted(qiskit_dir.glob("*")) + qasm_files + manifest_files
    generated_text = artifact_texts([path for path in generated_paths if path.is_file()])
    forbidden_reference_ok = not any(token in generated_text for token in FORBIDDEN_TOKENS)

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

    reference_support = clean_support(lambda index: REFERENCE_ACTION[index])
    reference_finite_matrix_ok = (
        reference_support == EXPECTED_SUPPORT
        and passive_preserved(lambda index: REFERENCE_ACTION[index])
        and is_permutation(lambda index: REFERENCE_ACTION[index])
    )

    if not required_artifacts_present:
        error_class = "source_translation_gap"
        next_route = "Generate qiskit/qasm3/manifest artifacts for mainCaseColdPartialPermVerified, then rerun this verifier."
    elif not finite_matrix_ok or not block_entry_ok:
        error_class = "finite_matrix_counterexample"
        next_route = "Repair the exported basis action to match mainCaseColdPartialPermImage before review."
    elif not normalizer_ok or not resource_ok or not qasm3_ok:
        error_class = "shape_or_register_gap"
        next_route = "Repair export metadata/register syntax while preserving the certified COLD circuit."
    else:
        error_class = None
        next_route = "Review export artifacts and gate."

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
        "expected_clean_support": sorted([list(pair) for pair in EXPECTED_SUPPORT]),
        "closed_theorem_ok": False,
        "error_class": error_class,
        "next_route": next_route,
        "artifact_presence": {
            "qiskit_dir": qiskit_dir.is_dir(),
            "qiskit_python_action": action is not None,
            "qasm3_files": [str(path) for path in qasm_files],
            "manifest_files": [str(path) for path in manifest_files],
        },
        "messages": action_messages,
    }
    print(json.dumps(feedback, indent=2, sort_keys=True))
    return 0 if error_class is None else 1


if __name__ == "__main__":
    raise SystemExit(main())
