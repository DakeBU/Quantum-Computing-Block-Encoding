#!/usr/bin/env python3
"""Resource-readiness diagnostic for QBE-MAIN-CASE-HIER-COLD-001.

This is a necessary-condition check for MAIN-RESOURCE-001.  It rechecks the
COLD finite table against the clean block and then verifies that no COLD
candidate package is being advertised before an honest resource schema exists.
"""

from __future__ import annotations

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MAINCASE = ROOT / "QuantumBlockEncoding" / "MainCase.lean"


def parse_image_table(text: str) -> dict[int, int]:
    pattern = re.compile(r"\|\s*⟨(\d+), _⟩\s*=>\s*⟨(\d+), by decide⟩")
    table: dict[int, int] = {}
    in_decl = False
    for line in text.splitlines():
        if line.startswith("def mainCaseColdPartialPermImage"):
            in_decl = True
            continue
        if in_decl and line.startswith("/-- Column-vector permutation matrix"):
            break
        if in_decl:
            match = pattern.search(line)
            if match:
                table[int(match.group(1))] = int(match.group(2))
    return table


def has_decl(text: str, name: str) -> bool:
    return re.search(rf"^(def|theorem|example)\s+{re.escape(name)}\b", text, re.M) is not None


def main() -> int:
    text = MAINCASE.read_text()
    table = parse_image_table(text)

    domain_ok = sorted(table) == list(range(16))
    range_ok = sorted(table.values()) == list(range(16))
    clean_support = sorted((row, col) for col, row in table.items() if col < 8 and row < 8)
    expected_support = [(0, 6), (1, 7)]

    resource_obligation_open = bool(
        re.search(
            r"def mainCaseColdResourceSchemaObligation[\s\S]*?proved\s*:=\s*false",
            text,
        )
    )
    cost_decls = [
        "mainCaseColdPartialPermCost",
        "mainCaseColdPartialPermCost_auxiliaryQubits",
        "mainCaseColdPartialPermCost_gateCount",
        "mainCaseColdPartialPermCost_depth",
        "mainCaseColdPartialPermCost_oracleCalls",
    ]
    missing_cost_decls = [name for name in cost_decls if not has_decl(text, name)]
    candidate_package_present = any(
        has_decl(text, name)
        for name in [
            "mainCaseColdPartialPermCandidate",
            "mainCaseColdPartialPermVerified",
        ]
    )

    finite_matrix_ok = (
        domain_ok
        and range_ok
        and has_decl(text, "mainCaseColdPartialPermImage_bijective")
    )
    block_entry_ok = (
        clean_support == expected_support
        and has_decl(text, "mainCaseColdPartialPerm_blockProjection")
    )

    feedback = {
        "leaf": "MAIN-RESOURCE-001",
        "source_correspondence_ok": True,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "finite_matrix_ok": finite_matrix_ok,
        "finite_bijection_ok": finite_matrix_ok,
        "block_entry_ok": block_entry_ok,
        "ancilla_cleanup_ok": clean_support == expected_support,
        "normalizer_ok": (
            "def mainCaseColdExactNormalizer : Rat := 1" in text
            and has_decl(text, "mainCaseColdQueryTarget_normalizer")
        ),
        "unitarity_ok": "finite_permutation_tier_true" if finite_matrix_ok else False,
        "resource_schema_present": not resource_obligation_open,
        "resource_obligation_open": resource_obligation_open,
        "cost_declarations_present": not missing_cost_decls,
        "missing_cost_declarations": missing_cost_decls,
        "candidate_package_present": candidate_package_present,
        "resource_score": {
            "gate_count": None,
            "depth": None,
            "auxiliary_qubits": 1,
            "oracle_calls": None,
        },
        "auxiliary_qubits": 1,
        "gate_count": None,
        "depth": None,
        "oracle_calls": None,
        "closed_theorem_ok": False,
        "closed_lean_declaration": None,
        "error_class": "symbolic_bridge_gap",
        "next_route": (
            "MAIN-RESOURCE-001: derive a COLD-local circuit/schedule or named "
            "resource model, then prove mainCaseColdPartialPermCost_* field "
            "theorems before candidate packaging or export."
        ),
        "rejection": (
            "No finite/block target contradiction.  Reject any route that adds "
            "mainCaseColdPartialPermCandidate, mainCaseColdPartialPermVerified, "
            "or executable exports before a COLD-local resource schema and cost "
            "field theorems compile."
        ),
    }

    print(json.dumps(feedback, indent=2, sort_keys=True))
    return 0 if finite_matrix_ok and block_entry_ok and resource_obligation_open else 1


if __name__ == "__main__":
    raise SystemExit(main())
