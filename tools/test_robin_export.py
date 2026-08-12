#!/usr/bin/env python3
"""Exact-table and finite-unitary tests for the Robin exporter."""

from __future__ import annotations

import unittest

from tools.export_robin_evolution import (
    candidate_result, eight_perm, eight_weight, exact_decomposition, five_perm,
    five_weight, full_candidate,
)


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


if __name__ == "__main__":
    unittest.main()
