#!/usr/bin/env python3
"""Exact-table and finite-unitary tests for the Robin exporter."""

from __future__ import annotations

import unittest
from pathlib import Path

from tools.export_robin_evolution import (
    candidate_result, eight_perm, eight_weight, exact_decomposition, five_perm,
    five_weight, full_candidate,
)

ROOT = Path(__file__).resolve().parents[1]


class RobinExportTests(unittest.TestCase):
    def test_exact_tables(self) -> None:
        exact_decomposition(5, five_perm, five_weight)
        exact_decomposition(8, eight_perm, eight_weight)

    def test_finite_composed_clean_blocks(self) -> None:
        for slots, perm, weight, denominator in (
            (5, five_perm, five_weight, 224 / 5),
            (8, eight_perm, eight_weight, 28),
        ):
            unitary, clean = full_candidate(slots, perm, weight, denominator)
            self.assertEqual(unitary.shape, (128, 128))
            self.assertEqual(clean.shape, (8, 8))

    def test_qiskit_operator_agreement(self) -> None:
        result = candidate_result("five", 5, five_perm, five_weight, 224 / 5, "test.root")
        self.assertLess(result["qiskitOperatorError"], 1e-12)
        self.assertEqual(result["executableSemanticTier"], "legacyDenseDiagnostic")
        self.assertFalse(result["primitive"])
        self.assertFalse(result["t3"])

    def test_dense_diagnostic_is_not_presented_as_t3(self) -> None:
        source = (ROOT / "tools" / "export_robin_evolution.py").read_text(encoding="utf-8")
        self.assertIn("legacy-dense-diagnostic", source)
        self.assertIn('"certifiedExecutable": False', source)


if __name__ == "__main__":
    unittest.main()
