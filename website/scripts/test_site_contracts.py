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

from website.content import CHAPTERS, IMPLEMENTATION_MAP, ROADMAP
from website.case_assets import STAGE_CIRCUITS


TEACHING_TRACKS = {str(chapter["track"]) for chapter in CHAPTERS}


class SiteContractTests(unittest.TestCase):
    def test_core_tracks_have_compiled_declarations_and_honest_routes(self) -> None:
        for chapter in CHAPTERS:
            if chapter["track"] not in TEACHING_TRACKS:
                continue
            for result in chapter["results"]:
                self.assertEqual(result["local_status"], "Compiled", result["declaration"])
                self.assertEqual(result["route_status"], "Compiled", result["declaration"])
                self.assertTrue(result["route_closures"], result["declaration"])

    def test_rendered_core_chapters_explain_incomplete_routes(self) -> None:
        declarations = {}
        for chapter in CHAPTERS:
            for result in chapter["results"]:
                for name in [result["declaration"], *result["route_closures"]]:
                    declarations.setdefault(name, {
                        "fullName": name,
                        "source": "QuantumBlockEncoding/TeachingRouteClosures.lean",
                        "sourcePreview": f"theorem {name.rsplit('.', 1)[-1]} : True := by trivial",
                        "sourceUrl": None,
                        "blueprintUrl": "blueprint/html-multi/index.html",
                    })
        for chapter in CHAPTERS:
            if chapter["track"] not in TEACHING_TRACKS:
                continue
            rendered = build_site.render_chapter(
                chapter,
                declarations,
                {"publicDeclarationCount": len(declarations)},
                {"passed": True},
                {"shortCommit": "test"},
            )
            self.assertIn("Route closure", rendered, chapter["slug"])
            for result in chapter["results"]:
                self.assertEqual(result["route_status"], "Compiled", result["declaration"])
                for root in result["route_closures"]:
                    self.assertIn(build_site.html.escape(str(root)), rendered)


    def test_roadmap_separates_closed_witnesses_from_open_generality(self) -> None:
        status = dict(ROADMAP)
        self.assertEqual(status["Finite three-bit primitive banded sparse access"], "Compiled")
        self.assertEqual(status["Finite two-qubit cubic primitive amplitude oracle"], "Compiled")
        self.assertEqual(status["Degree-one QSVT identity consumer realization"], "Compiled")
        self.assertEqual(status["Fixed-N8 Robin T3 reproduction and evolved winner"], "Compiled")
        self.assertEqual(status["Arbitrary-width banded-access source resource compiler"], "Planned")
        self.assertEqual(status["General QSVT phase synthesis and approximation checker"], "Planned")
        self.assertEqual(status["GHL Theorem 4 A-to-H Hamiltonian composition"], "Compiled")
        self.assertEqual(status["Arbitrary-width GHL one-term primitive resource compiler"], "Planned")
        self.assertNotIn("Arbitrary-n GHL and full Hamiltonian reproduction", status)

    def test_robin_tex_is_canonical(self) -> None:
        data = json.loads((ROOT / "website/robin-paper-map.json").read_text(encoding="utf-8"))
        for row in data["rows"]:
            self.assertNotRegex(row["latex"], r"\\\\(?=[A-Za-z])")
            rendered = build_site.render_math_tex(row["latex"])
            self.assertNotIn("\ufffd", rendered)

    def test_robin_statuses_keep_local_and_route_completion_separate(self) -> None:
        data = json.loads((ROOT / "website/robin-paper-map.json").read_text(encoding="utf-8"))
        for row in data["rows"]:
            self.assertIn(row["localStatus"], build_site.STATUS_ORDER)
            self.assertIn(row["routeStatus"], build_site.STATUS_ORDER)
            self.assertNotIn(";", row["localStatus"])
            self.assertNotIn(";", row["routeStatus"])

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
        previous = build_site.EXAMPLE_CASE_NAV
        try:
            build_site.EXAMPLE_CASE_NAV = [
                (case["shortTitle"], case["slug"]) for case in data["cases"]
            ]
            navigation = build_site.site_header("./", "")
        finally:
            build_site.EXAMPLE_CASE_NAV = previous
        self.assertIn("Example Cases", navigation)
        self.assertIn("<span>01</span>", navigation)
        self.assertIn("<span>07</span>", navigation)
        self.assertIn("State prep: Pauli X", navigation)
        self.assertNotIn("Preparing the basis state |1&gt;", navigation)

    def test_footer_names_repository_and_all_organizers(self) -> None:
        source = (ROOT / "website/scripts/build_site.py").read_text(encoding="utf-8")
        self.assertIn("DakeBU/Quantum-Computing-Block-Encoding", source)
        for name in (
            "Dake Bu", "Xiajie Huang", "Nana Liu", "Atsushi Nitanda",
            "Hau-san Wong", "Qingfu Zhang",
        ):
            self.assertIn(name, source)

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
                self.assertTrue(STAGE_CIRCUITS[case["slug"]][stage["name"]])
                if stage["status"].startswith("Strictly better"):
                    self.assertIn("betterThan", stage["leanAnchor"])

    def test_case_pages_offer_copyable_latex_lean_and_quantikz(self) -> None:
        source = (ROOT / "website/scripts/build_site.py").read_text(encoding="utf-8")
        workbench = (ROOT / "website/static/case-workbench.js").read_text(encoding="utf-8")
        self.assertIn("Construction and circuit LaTeX", source)
        self.assertIn("English proof LaTeX", source)
        self.assertIn("Lean declaration retrieval block", source)
        self.assertIn("render_quantikz_svg", source)
        self.assertIn("data-case-workbench", source)
        self.assertIn("renderFormula", workbench)
        self.assertIn("renderProof", workbench)
        self.assertIn("renderCircuit", workbench)
        for circuits in STAGE_CIRCUITS.values():
            for circuit in circuits.values():
                self.assertIn("\\begin{quantikz}", circuit)

    def test_robin_primitive_counts_use_one_frozen_tier(self) -> None:
        data = json.loads((ROOT / "website/example-cases.json").read_text(encoding="utf-8"))
        robin = next(case for case in data["cases"] if case["slug"] == "robin-ghl-one-term")
        stages = {stage["name"]: stage for stage in robin["evolution"]["stages"]}
        for name in (
            "Fixed-N8 Figure-4 realization",
            "Paper-seven normal form",
            "XOR four-slot primitive",
        ):
            stage = stages[name]
            split = stage["gateBreakdown"]
            self.assertEqual(split["singleQubit"] + split["cx"], stage["score"][0])
            self.assertIn("primitive", stage["instructionTier"].lower())
        self.assertIn("every ordering", robin["evolution"]["scoreAudit"])

    def test_gate_list_contract_uses_supported_mathjax_tex(self) -> None:
        row = next(item for item in IMPLEMENTATION_MAP if item["goal"] == "Evaluate a gate list")
        self.assertEqual(row["contract"], r"\mathrm{Eval}(C)=G_m\cdots G_1")
        self.assertNotIn(r"\llbracket", row["contract"])
        rendered = build_site.render_math_tex(row["contract"])
        self.assertIn(r"\mathrm{Eval}", rendered)

    def test_robin_example_states_exact_eq9_specialization(self) -> None:
        data = json.loads((ROOT / "website/example-cases.json").read_text(encoding="utf-8"))
        robin = next(case for case in data["cases"] if case["slug"] == "robin-ghl-one-term")
        formula = robin["formula"]
        relation_root = (
            "QuantumBlockEncoding.RobinEvolution."
            "warmRobinTarget_eq_paperEq9_dimensionless_A1_B1_zero"
        )
        self.assertIn(r"A_{\mathrm{GHL}}^{(9)}", formula)
        self.assertIn(r"\Delta x^{-2}", formula)
        self.assertIn(r"\widetilde A_0", formula)
        self.assertIn("A1=B1=0", robin["problem"])
        self.assertIn("56/(3 Delta x^2)", robin["contract"])
        self.assertIn(relation_root, robin["leanAnchors"])
        self.assertTrue(any(row[2] == relation_root for row in robin["verificationStatus"]))
        rendered = build_site.render_math_tex(formula)
        self.assertNotIn("\\llbracket", rendered)

    def test_workspace_supports_both_translation_directions(self) -> None:
        page = (ROOT / "website/scripts/build_site.py").read_text(encoding="utf-8")
        server = (ROOT / "website/scripts/ide_server.py").read_text(encoding="utf-8")
        worker = (ROOT / "website/scripts/codex_translator.py").read_text(encoding="utf-8")
        for marker in ("latex-to-lean", "lean-to-latex"):
            self.assertIn(marker, page)
            self.assertIn(marker, server)
            self.assertIn(marker, worker)

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

    def test_ghl_hamiltonian_composition_is_compiled(self) -> None:
        data = json.loads((ROOT / "website/robin-paper-map.json").read_text(encoding="utf-8"))
        row = next(row for row in data["rows"] if row["id"] == "hamiltonian-composition")
        self.assertEqual(row["localStatus"], "Compiled")
        self.assertEqual(row["routeStatus"], "Compiled")
        required = {
            "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
            "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",
            "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",
        }
        self.assertTrue(required.issubset(set(row["declarations"])))
        roadmap = dict(ROADMAP)
        self.assertEqual(roadmap["GHL Theorem 4 A-to-H Hamiltonian composition"], "Compiled")
        self.assertEqual(roadmap["Arbitrary-width GHL one-term primitive resource compiler"], "Planned")
        self.assertNotIn("Arbitrary-n GHL and full Hamiltonian reproduction", roadmap)
        content = (ROOT / "website/content.py").read_text(encoding="utf-8")
        self.assertNotIn(r"\llbracket", content)
        literature = (ROOT / "QuantumBlockEncoding/Literature.lean").read_text(encoding="utf-8")
        ghl_start = literature.index('key := "guseynov-huang-liu-2026-robin"')
        ghl_end = literature.index("\n    },", ghl_start)
        ghl = literature[ghl_start:ghl_end]
        self.assertIn("ImplementationStatus.formalized", ghl)
        self.assertIn("QuantumBlockEncoding/GHLHamiltonian.lean", ghl)

    def test_no_credential_export_branch(self) -> None:
        script = (ROOT / "website/static/task-builder.js").read_text(encoding="utf-8")
        self.assertNotIn("redactApiKey", script)
        self.assertNotRegex(script, re.compile(r"packet.*key\.value", re.I))


if __name__ == "__main__":
    unittest.main()
