#!/usr/bin/env python3

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from website.content import CHAPTERS
from website.scripts import enrich_teaching_site as enrich


class TeachingEnrichmentTests(unittest.TestCase):
    def test_every_guided_chapter_has_a_beginner_lesson(self) -> None:
        data = enrich.load_data()
        expected = {str(chapter["slug"]) for chapter in CHAPTERS}
        actual = set(data["chapters"])
        self.assertEqual(actual, expected)

    def test_exact_source_quotes_are_short_and_not_reused(self) -> None:
        data = enrich.load_data()
        used = list(enrich.QUOTE_SOURCE_FOR_SLUG.values())
        self.assertEqual(len(used), len(set(used)))
        for key in used:
            quote = data["sources"][key]["quote"]
            self.assertIsInstance(quote, str)
            self.assertLessEqual(len(quote.split()), 24, key)

    def test_start_here_teaches_measurement_and_entanglement_visually(self) -> None:
        data = enrich.load_data()
        intro = data["startHere"]
        self.assertIn("P(x)", intro["measurementFormula"])
        self.assertIn("Phi", intro["bellFormula"])
        self.assertEqual(len(intro["circuit"]["wires"]), 2)
        self.assertIn("H", intro["circuit"]["wires"][0]["gates"])
        self.assertIn("X target", intro["circuit"]["wires"][1]["gates"])

    def test_lesson_has_all_three_reading_layers(self) -> None:
        data = enrich.load_data()
        lesson = enrich.lesson_html(
            "block-encoding",
            data["chapters"]["block-encoding"],
            data["sources"],
        )
        for mode in ("concept", "math", "lean"):
            self.assertIn(f'data-reader-layer="{mode}"', lesson)
            self.assertIn(f'data-reader-mode-choice="{mode}"', lesson)
        self.assertIn("PREPARE", enrich.lesson_html(
            "classic-routes",
            data["chapters"]["classic-routes"],
            data["sources"],
        ))

    def test_enriches_generated_pages_without_removing_existing_content(self) -> None:
        data = enrich.load_data()
        minimal = """<!doctype html><html><head><link rel=\"stylesheet\" href=\"static/site.css\"></head><body><main id=\"main-content\"><section class=\"hero\">ORIGINAL</section></main></body></html>"""
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for slug in data["chapters"]:
                path = root / "chapters" / slug / "index.html"
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(minimal, encoding="utf-8")
            for route in ("state-preparation", "block-encoding", "learning"):
                path = root / route / "index.html"
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(minimal, encoding="utf-8")
            (root / "index.html").write_text(minimal, encoding="utf-8")

            enrich.enrich(root)

            chapter = (root / "chapters" / "block-encoding" / "index.html").read_text(encoding="utf-8")
            self.assertIn("ORIGINAL", chapter)
            self.assertIn('data-concept-first-lesson="block-encoding"', chapter)
            self.assertIn("../../static/learning.css", chapter)
            learning = (root / "learning" / "index.html").read_text(encoding="utf-8")
            self.assertIn('id="start-here"', learning)
            home = (root / "index.html").read_text(encoding="utf-8")
            self.assertIn("Start the beginner path", home)


if __name__ == "__main__":
    unittest.main()
