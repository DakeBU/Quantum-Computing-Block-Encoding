#!/usr/bin/env python3
"""Finite diagnostic for MAIN-PERM-UNITARY-001.

This is a necessary-condition check for the COLD partial-permutation route.  It
parses the task-local Lean image table and checks that it is a 16-state
permutation whose clean signal block still has exactly the source support for
E_1.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


TASK = "QBE-MAIN-CASE-HIER-COLD-001"
LEAF = "MAIN-PERM-UNITARY-001"
SYSTEM_DIM = 8
TOTAL_DIM = 16
CLEAN_SIGNAL = 0
NORMALIZER = 1
AUXILIARY_QUBITS = 1


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def system_index(time: int, typ: int, state: int) -> int:
    return 4 * time + 2 * typ + state


def decode_total(index: int) -> dict[str, int]:
    signal, system = divmod(index, SYSTEM_DIM)
    time, rem = divmod(system, 4)
    typ, state = divmod(rem, 2)
    return {"signal": signal, "T": time, "tau": typ, "S": state}


def clean_embed(system: int) -> int:
    return CLEAN_SIGNAL * SYSTEM_DIM + system


def parse_cold_image(maincase: Path) -> list[int]:
    text = maincase.read_text(encoding="utf-8")
    start = text.find("def mainCaseColdPartialPermImage")
    if start < 0:
        raise RuntimeError("missing mainCaseColdPartialPermImage")
    end = text.find("/-- Column-vector permutation matrix", start)
    if end < 0:
        raise RuntimeError("missing end marker after mainCaseColdPartialPermImage")

    table: dict[int, int] = {}
    for line in text[start:end].splitlines():
        if "=>" not in line or "by decide" not in line:
            continue
        numbers = [int(item) for item in re.findall(r"\d+", line)]
        if len(numbers) >= 2:
            src, dst = numbers[0], numbers[1]
            if src in table:
                raise RuntimeError(f"duplicate image clause for {src}")
            table[src] = dst

    missing = [idx for idx in range(TOTAL_DIM) if idx not in table]
    if missing:
        raise RuntimeError(f"missing image clauses for {missing}")
    return [table[idx] for idx in range(TOTAL_DIM)]


def inverse_table(image: list[int]) -> list[int] | None:
    if sorted(image) != list(range(TOTAL_DIM)):
        return None
    inverse = [0] * TOTAL_DIM
    for src, dst in enumerate(image):
        inverse[dst] = src
    return inverse


def main() -> int:
    maincase = repo_root() / "QuantumBlockEncoding" / "MainCase.lean"
    image = parse_cold_image(maincase)
    inverse = inverse_table(image)

    target_support = {
        (system_index(0, 0, 0), system_index(1, 1, 0)),
        (system_index(0, 0, 1), system_index(1, 1, 1)),
    }
    clean_support = {
        (row, col)
        for row in range(SYSTEM_DIM)
        for col in range(SYSTEM_DIM)
        if clean_embed(row) == image[clean_embed(col)]
    }

    finite_bijection_ok = inverse is not None
    passive_register_preserved = all(
        decode_total(src)["S"] == decode_total(dst)["S"]
        for src, dst in enumerate(image)
    )
    block_entry_ok = clean_support == target_support
    normalizer_ok = NORMALIZER == 1
    ancilla_cleanup_ok = all(
        decode_total(image[clean_embed(col)])["signal"] == CLEAN_SIGNAL
        for _, col in target_support
    )
    finite_matrix_ok = finite_bijection_ok and passive_register_preserved
    diagnostic_ok = (
        finite_matrix_ok
        and block_entry_ok
        and normalizer_ok
        and ancilla_cleanup_ok
        and AUXILIARY_QUBITS == 1
    )

    payload = {
        "task": TASK,
        "leaf": LEAF,
        "source": "QuantumBlockEncoding/MainCase.lean:mainCaseColdPartialPermImage",
        "image": image,
        "inverse": inverse,
        "expected_clean_support": sorted(target_support),
        "actual_clean_support": sorted(clean_support),
        "finite_bijection_ok": finite_bijection_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "passive_register_preserved": passive_register_preserved,
        "block_entry_ok": block_entry_ok,
        "ancilla_cleanup_ok": ancilla_cleanup_ok,
        "normalizer_ok": normalizer_ok,
        "auxiliary_qubits": AUXILIARY_QUBITS,
        "oracle_calls": 0,
        "reject_current_target": not diagnostic_ok,
        "error_class": (
            "symbolic_bridge_gap"
            if diagnostic_ok
            else "finite_matrix_counterexample"
        ),
        "next_route": (
            "Prove mainCaseColdPartialPermImage_bijective from the parsed Fin 16 "
            "table, then bridge that finite permutation certificate to the "
            "project unitary/verified-candidate layer."
        ),
    }
    print(json.dumps(payload, indent=2, sort_keys=True))
    return 0 if diagnostic_ok else 1


if __name__ == "__main__":
    sys.exit(main())
