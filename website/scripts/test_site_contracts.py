#!/usr/bin/env python3
"""Focused regression tests for the unified Robin and task-builder surfaces."""

from __future__ import annotations

import importlib.util
import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("build_site", ROOT / "website/scripts/build_site.py")
assert SPEC and SPEC.loader
build_site = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(build_site)


class SiteContractTests(unittest.TestCase):
    def test_robin_tex_is_canonical(self) -> None:
        data = json.loads((ROOT / "website/robin-paper-map.json").read_text(encoding="utf-8"))
        for row in data["rows"]:
            self.assertNotRegex(row["latex"], r"\\\\(?=[A-Za-z])")
            rendered = build_site.render_math_tex(row["latex"])
            self.assertNotIn("\ufffd", rendered)

    def test_math_renderer_rejects_corruption(self) -> None:
        with self.assertRaises(ValueError):
            build_site.render_math_tex(r"\\theta")
        with self.assertRaises(ValueError):
            build_site.render_math_tex("\ufffd")

    def test_executable_robin_modules_have_no_self_swap(self) -> None:
        sources = "\n".join(
            path.read_text(encoding="utf-8")
            for path in (ROOT / "QuantumBlockEncoding/Robin").glob("*.lean")
        )
        self.assertNotRegex(sources, r"Gate\.swap\s+([0-9]+)\s+\1")
        adapter = (ROOT / "QuantumBlockEncoding/RobinEvolution.lean").read_text(encoding="utf-8")
        self.assertNotIn("Gate.swap 0 0", adapter)

    def test_task_builder_is_generated_in_shared_shell(self) -> None:
        source = (ROOT / "website/scripts/build_site.py").read_text(encoding="utf-8")
        self.assertIn("def render_task_builder", source)
        self.assertNotIn("def copy_task_builder", source)
        for marker in ("aspbe-harness-flow.svg", "abeis-library-map.svg", "redactApiKey"):
            self.assertNotIn(marker, source)

    def test_example_cases_are_unique_and_nav_is_common(self) -> None:
        data = json.loads((ROOT / "website/example-cases.json").read_text(encoding="utf-8"))
        self.assertEqual(data["schemaVersion"], 2)
        slugs = [case["slug"] for case in data["cases"]]
        self.assertEqual(len(slugs), len(set(slugs)))
        self.assertIn("Example Cases", build_site.site_header("./", ""))

    def test_every_case_has_formula_lean_evolution_and_executable_output(self) -> None:
        data = json.loads((ROOT / "website/example-cases.json").read_text(encoding="utf-8"))
        for case in data["cases"]:
            self.assertTrue(case["formula"], case["slug"])
            self.assertTrue(case["problem"], case["slug"])
            self.assertTrue(case["leanAnchors"], case["slug"])
            self.assertTrue(case["circuit"]["stages"], case["slug"])
            self.assertTrue(case["evolution"]["stages"], case["slug"])
            self.assertTrue((ROOT / case["qiskit"]["path"]).is_file(), case["slug"])
            for stage in case["evolution"]["stages"]:
                self.assertIn(stage["leanAnchor"], case["leanAnchors"])
                if stage["status"].startswith("Strictly better"):
                    self.assertIn("betterThan", stage["leanAnchor"])

    def test_backend_check_and_export_controls_are_independent(self) -> None:
        source = (ROOT / "website/scripts/build_site.py").read_text(encoding="utf-8")
        script = (ROOT / "website/static/task-builder.js").read_text(encoding="utf-8")
        self.assertIn('name="intermediateBackend"', source)
        self.assertIn('id="exportQiskitPython"', source)
        self.assertIn("executablePolicy", script)
        self.assertNotIn('exports: {qiskit:', script)

    def test_example_pages_use_backend_neutral_evidence_section(self) -> None:
        source = (ROOT / "website/scripts/build_site.py").read_text(encoding="utf-8")
        self.assertIn("Executable verification and exports", source)
        self.assertIn("OpenQASM 3 round-trip", source)
        self.assertNotIn('(\"qiskit-export\", \"Qiskit export\")', source)

    def test_numerical_replay_is_not_the_case_certification_gate(self) -> None:
        source = (ROOT / "website/scripts/build_site.py").read_text(encoding="utf-8")
        self.assertNotIn("lacks passing replay evidence", source)
        self.assertNotIn("public-case replay report is missing or did not pass", source)
        self.assertIn("not a Lean certification gate", source)

    def test_no_credential_export_branch(self) -> None:
        script = (ROOT / "website/static/task-builder.js").read_text(encoding="utf-8")
        self.assertNotIn("redactApiKey", script)
        self.assertNotRegex(script, re.compile(r"packet.*key\.value", re.I))


if __name__ == "__main__":
    unittest.main()
