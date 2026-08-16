#!/usr/bin/env python3

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from website.scripts import polish_casebook


class CasebookPolishTests(unittest.TestCase):
    def test_wrap_section_makes_lean_panel_optional(self) -> None:
        source = (
            '<main><section class="content-section" id="lean-certificate">'
            '<h2>Named Lean certificates</h2><p>ROOT</p></section></main>'
        )
        rendered = polish_casebook.wrap_section(
            source,
            "lean-certificate",
            "Show the complete Lean certificate list",
            "Optional proof details.",
        )
        self.assertIn('data-collapsed-section="lean-certificate"', rendered)
        self.assertIn('<details', rendered)
        self.assertIn('ROOT', rendered)

    def test_polishes_cases_and_robin_paper_map(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            case = root / "example-cases" / "demo" / "index.html"
            case.parent.mkdir(parents=True, exist_ok=True)
            case.write_text(
                '<main><section id="verification-status">STATUS</section>'
                '<section id="lean-certificate">LEAN</section></main>',
                encoding="utf-8",
            )
            paper = root / "case-studies" / "robin" / "index.html"
            paper.parent.mkdir(parents=True, exist_ok=True)
            paper.write_text(
                '<main><section id="how-to-read">STATUS POLICY</section>'
                '<section class="paper-map" id="correspondence">MAP</section></main>',
                encoding="utf-8",
            )
            polish_casebook.polish(root)
            case_text = case.read_text(encoding="utf-8")
            paper_text = paper.read_text(encoding="utf-8")
            self.assertIn('data-collapsed-section="verification-status"', case_text)
            self.assertIn('data-collapsed-section="lean-certificate"', case_text)
            self.assertIn('data-collapsed-section="how-to-read"', paper_text)
            self.assertIn('data-collapsed-section="correspondence"', paper_text)


if __name__ == "__main__":
    unittest.main()
