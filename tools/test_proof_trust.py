#!/usr/bin/env python3

from __future__ import annotations

import unittest
from pathlib import Path

try:
    from check_proof_trust import is_approved
    from proof_trust import scan_lean_source
except ModuleNotFoundError:
    from tools.check_proof_trust import is_approved
    from tools.proof_trust import scan_lean_source


class ProofTrustScannerTests(unittest.TestCase):
    def test_ignores_nested_comments_docstrings_and_strings(self) -> None:
        source = '''
/- outer sorry
   /- nested admit -/
-/
/-- "axiom" in documentation. -/
def safe : String := "sorry admit axiom"
'''
        self.assertEqual(scan_lean_source(Path("Safe.lean"), source), [])

    def test_reports_hole_with_owning_declaration(self) -> None:
        findings = scan_lean_source(
            Path("Example.lean"),
            "theorem unfinished : True := by\n  sorry\n",
        )
        self.assertEqual(len(findings), 1)
        self.assertEqual(findings[0].token, "sorry")
        self.assertEqual(findings[0].declaration, "unfinished")
        self.assertEqual(findings[0].line, 2)

    def test_source_axiom_is_never_approved(self) -> None:
        finding = scan_lean_source(
            Path("QuantumBlockEncoding/RobinMatrix.lean"),
            "axiom oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3 : True\n",
        )[0]
        self.assertFalse(is_approved(finding))

    def test_historical_robin_sorry_is_no_longer_approved(self) -> None:
        finding = scan_lean_source(
            Path("QuantumBlockEncoding/RobinMatrix.lean"),
            "theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3 : True := by\n"
            "  sorry\n",
        )[0]
        self.assertFalse(is_approved(finding))


if __name__ == "__main__":
    unittest.main()
