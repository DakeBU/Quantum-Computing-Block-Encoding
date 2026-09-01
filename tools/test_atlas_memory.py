from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from tools import atlas_memory


class AtlasMemoryTests(unittest.TestCase):
    def test_declaration_blocks_keep_namespace_and_status(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "Atlas" / "Book" / "code" / "Demo.lean"
            source.parent.mkdir(parents=True)
            source.write_text(
                """namespace Demo

theorem clean_result (n : Nat) : n = n := by
  rfl

private lemma unfinished : True := by
  sorry

end Demo
""",
                encoding="utf-8",
            )
            records = list(atlas_memory.declaration_blocks(source))
            self.assertEqual(len(records), 2)
            self.assertEqual(
                atlas_memory.full_name(records[0][2].group("name"), records[0][4]),
                "Demo.clean_result",
            )
            self.assertIn("sorry", "\n".join(records[1][3]))

    def test_comment_prose_that_starts_with_lemma_is_not_indexed(self) -> None:
        lines = ["/-- Explanation", "lemma not_a_declaration", "-/", "lemma real : True := by trivial"]
        active = atlas_memory.active_code_lines(lines)
        self.assertEqual(active, [True, False, False, True])

    def test_report_records_preserve_scores(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            book = root / "Atlas" / "Book"
            book.mkdir(parents=True)
            (book / "report.json").write_text(
                json.dumps(
                    {
                        "statements": {
                            "details": [
                                {
                                    "lean_declaration": "Demo.clean_result",
                                    "passed": True,
                                    "scores": {
                                        "compilation": 1,
                                        "faithfulness": 5,
                                        "proof_integrity": 5,
                                        "code_quality": 4,
                                    },
                                }
                            ]
                        }
                    }
                ),
                encoding="utf-8",
            )
            variants = atlas_memory.report_records(root)[("Book", "Demo.clean_result")]
            record = atlas_memory.merge_report_variants(variants)
            self.assertIsNotNone(record)
            self.assertTrue(record["passed"])
            self.assertEqual(record["scores"]["proof_integrity"], 5)

    def test_duplicate_reports_are_merged_conservatively(self) -> None:
        variants = [
            {"passed": True, "scores": {"faithfulness": 5}, "axioms": "Classical.choice"},
            {
                "passed": False,
                "scores": {"faithfulness": 2},
                "axioms": "Classical.choice, sorryAx",
            },
        ]
        merged = atlas_memory.merge_report_variants(variants)
        self.assertIsNotNone(merged)
        self.assertFalse(merged["passed"])
        self.assertEqual(merged["scores"]["faithfulness"], 2)
        self.assertIn("sorryAx", merged["axioms"])

    def test_quality_status_does_not_equate_compilation_with_clean_proof(self) -> None:
        self.assertEqual(
            atlas_memory.quality_status(None, False),
            "upstream-compiled-not-evaluated",
        )
        self.assertEqual(
            atlas_memory.quality_status(
                {"passed": True, "axioms": "Classical.choice, sorryAx"}, False
            ),
            "upstream-evaluated-rejected",
        )
        self.assertEqual(
            atlas_memory.quality_status(
                {"passed": True, "axioms": "Classical.choice"}, False
            ),
            "upstream-evaluated-clean",
        )


if __name__ == "__main__":
    unittest.main()
