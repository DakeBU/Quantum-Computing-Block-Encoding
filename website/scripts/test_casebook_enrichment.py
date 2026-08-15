#!/usr/bin/env python3

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from website.scripts import enrich_casebook as casebook


ROOT = Path(__file__).resolve().parents[2]


class CasebookEnrichmentTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.teaching = casebook.load_json(ROOT / "website/case-teaching.json")
        cls.cases = casebook.load_json(ROOT / "website/example-cases.json")
        cls.declarations = casebook.declaration_map()

    def test_every_example_case_has_one_teaching_record(self) -> None:
        expected = {case["slug"] for case in self.cases["cases"]}
        actual = set(self.teaching["cases"])
        self.assertEqual(actual, expected)

    def test_every_case_teaches_context_circuit_theorem_proof_and_optional_lean(self) -> None:
        for slug, teaching in self.teaching["cases"].items():
            self.assertTrue(teaching["readerGoal"], slug)
            self.assertTrue(teaching["whyThisCase"], slug)
            self.assertTrue(teaching["algorithmContext"], slug)
            self.assertTrue(teaching["circuitReading"], slug)
            self.assertTrue(teaching["theorems"], slug)
            for theorem in teaching["theorems"]:
                self.assertTrue(theorem["statementFormula"], slug)
                self.assertTrue(theorem["statementProse"], slug)
                self.assertGreaterEqual(len(theorem["proofSteps"]), 3, slug)
                self.assertTrue(theorem["leanRoots"], slug)
                for root in theorem["leanRoots"]:
                    self.assertIn(root, self.declarations, f"{slug}: {root}")
            for root in teaching.get("improvement", {}).get("leanRoots", []):
                self.assertIn(root, self.declarations, f"{slug}: {root}")

    def test_robin_explains_query_oracle_theorems_and_winner(self) -> None:
        robin = self.teaching["cases"]["robin-ghl-one-term"]
        source = robin["source"]
        self.assertIn("O_H", source["queryFormula"])
        self.assertIn("oracle", source["queryExplanation"].lower())
        self.assertEqual(len(robin["theorems"]), 2)
        labels = " ".join(theorem["label"] for theorem in robin["theorems"])
        self.assertIn("Theorem 3", labels)
        self.assertIn("Theorem 4", labels)
        theorem4 = robin["theorems"][1]
        self.assertIn("H=S_1", theorem4["statementFormula"])
        self.assertIn("theorem4_source_lcu_route_closed", theorem4["leanRoots"][-1])
        improvement = robin["improvement"]
        self.assertIn("106,96,3,0", improvement["statementFormula"])
        self.assertIn("881,674,6,0", improvement["statementFormula"])
        self.assertIn(
            "QuantumBlockEncoding.Robin.warmRobinFourSlotT3Cost_betterThan_figure4",
            improvement["leanRoots"],
        )
        self.assertIn("pipeline", robin)
        self.assertGreaterEqual(len(robin["pipeline"]), 6)

    def test_source_quotes_are_short(self) -> None:
        for slug, teaching in self.teaching["cases"].items():
            quote = teaching.get("source", {}).get("shortQuote")
            if quote:
                self.assertLessEqual(len(quote.split()), 24, slug)

    def _minimal_page(self, *, case: bool = False, source_audit: bool = False) -> str:
        hero = (
            '<header class="hero case-hero"><h1>CASE</h1></header>'
            if case else '<section class="hero"><h1>PAGE</h1></section>'
        )
        audit = (
            '<section class="content-section" id="source-interpretation">'
            '<div class="section-heading"><h2>Source interpretation decisions</h2></div>'
            '<ol><li>technical choice</li></ol></section>'
            if source_audit else ""
        )
        return (
            '<!doctype html><html><head><link rel="stylesheet" href="site.css"></head>'
            f'<body><main id="main-content">{hero}'
            '<section class="content-section case-problem" id="mathematical-target">TARGET</section>'
            f'{audit}</main></body></html>'
        )

    def test_generated_casebook_places_teaching_before_dashboard_and_collapses_audit(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for slug in self.teaching["cases"]:
                path = root / "example-cases" / slug / "index.html"
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(
                    self._minimal_page(case=True, source_audit=(slug == "robin-ghl-one-term")),
                    encoding="utf-8",
                )
            index = root / "example-cases" / "index.html"
            index.write_text(self._minimal_page(), encoding="utf-8")
            for route in ("learning", "state-preparation", "block-encoding"):
                path = root / route / "index.html"
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(self._minimal_page(), encoding="utf-8")
            robin_map = root / "case-studies" / "robin" / "index.html"
            robin_map.parent.mkdir(parents=True, exist_ok=True)
            robin_map.write_text(self._minimal_page(source_audit=True), encoding="utf-8")

            casebook.enrich(root)

            robin = (root / "example-cases" / "robin-ghl-one-term" / "index.html").read_text(encoding="utf-8")
            self.assertIn('id="case-tutorial"', robin)
            self.assertLess(robin.index('id="case-tutorial"'), robin.index('id="mathematical-target"'))
            self.assertIn("GHL Theorem 3", robin)
            self.assertIn("GHL Theorem 4", robin)
            self.assertIn("What ASPBE improves", robin)
            self.assertIn("Advanced source-fidelity notes", robin)
            self.assertNotIn("<h2>Source interpretation decisions</h2>", robin)
            self.assertIn("<details class=\"casebook-lean\">", robin)

            learning = (root / "learning" / "index.html").read_text(encoding="utf-8")
            self.assertIn('id="quantum-access-models"', learning)
            self.assertIn("State preparation", learning)
            self.assertIn("Digital query oracle", learning)
            self.assertIn("Block encoding", learning)
            self.assertIn("How to read a quantum circuit", learning)

            paper = (root / "case-studies" / "robin" / "index.html").read_text(encoding="utf-8")
            self.assertIn('id="paper-beginner-guide"', paper)
            self.assertIn("Why does this paper build block encodings at all?", paper)
            self.assertNotIn("<h2>Source interpretation decisions</h2>", paper)


if __name__ == "__main__":
    unittest.main()
