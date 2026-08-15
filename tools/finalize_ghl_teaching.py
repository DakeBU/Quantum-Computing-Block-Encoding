#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected exactly one match, found {count}")
    return text.replace(old, new, 1)


def update_literature() -> None:
    path = ROOT / "QuantumBlockEncoding" / "Literature.lean"
    text = path.read_text(encoding="utf-8")
    start = text.index('      key := "guseynov-huang-liu-2026-robin"')
    end = text.index("\n    },", start)
    block = text[start:end]
    block = block.replace(
        "status := ImplementationStatus.skeleton",
        "status := ImplementationStatus.formalized",
    )
    block = block.replace(
        'targetFile := "QuantumBlockEncoding/GHL2025.lean"',
        'targetFile := "QuantumBlockEncoding/GHLHamiltonian.lean"',
    )
    old_note = 'note := "Main target: explicit oracle-free block encodings for Robin boundaries."'
    new_note = (
        'note := "Fixed-N8 one-term source circuits are primitive-certified; '
        'Theorem 4 A/A-dagger to S1,S2 to H composition is formalized generically. '
        'Arbitrary-width primitive resource compilation remains a separate frontier."'
    )
    if old_note not in block:
        raise RuntimeError("GHL literature note anchor missing")
    block = block.replace(old_note, new_note)
    text = text[:start] + block + text[end:]
    path.write_text(text, encoding="utf-8")


def update_content() -> None:
    path = ROOT / "website" / "content.py"
    text = path.read_text(encoding="utf-8")
    text = text.replace(
        r'\llbracket[g_1,\ldots,g_m]\rrbracket=G_m\cdots G_1.',
        r'\mathrm{Eval}([g_1,\ldots,g_m])=G_m\cdots G_1.',
    )
    if r"\llbracket" in text:
        raise RuntimeError("unsupported \\llbracket remains in website/content.py")

    modules_anchor = '''            "QuantumBlockEncoding/GHL2025.lean",\n            "QuantumBlockEncoding/Examples/RobinHeat.lean",'''
    modules_repl = '''            "QuantumBlockEncoding/GHL2025.lean",\n            "QuantumBlockEncoding/GHLHamiltonian.lean",\n            "QuantumBlockEncoding/Examples/RobinHeat.lean",'''
    text = replace_once(text, modules_anchor, modules_repl, "certified-cases module list")

    robin_marker = '''            result(\n                "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_ne_backendFold_n3",'''
    h_card = r'''            result(
                "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",
                "GHL Theorem 4: one-term operators compose into the Hamiltonian",
                "Lean now closes the paper's source-level chain from the one-term matrices and their adjoints to A, A-dagger, the Hermitian pieces S1 and S2, and the final one-dimensional Hamiltonian H.",
                r"A=\sum_kA_k,\quad A^\dagger=\sum_kA_k^\dagger,\quad S=S_1+iS_2,\quad H=S_1\otimes x_\xi+S_2\otimes I_\xi.",
                "The block-encoding work is modular: Theorem 3 supplies one-term ingredients, while Theorem 4 combines them by the paper's LCU and Schrodingerisation algebra rather than inventing a new target.",
                "This prevents the website from incorrectly treating the A-to-H composition as an open extrapolation when it is an explicit part of the source paper.",
                [
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.homogenizedS_eq_S1_add_iS2",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_isHermitian",
                ],
                "Form A by summing the one-term matrices, commute adjoint with the finite sum, homogenize the inhomogeneous system, split it into the two canonical Hermitian pieces, and tensor those pieces with x_xi and the identity.",
                [
                    ("Assemble A.", "sumTerms"),
                    ("Assemble A-dagger.", "Adagger_eq_sum_term_adjoints"),
                    ("Split S into Hermitian pieces.", "S_decomposition"),
                    ("Construct and certify H.", "H_eq_S1_tensor_xXi_add_S2_tensor_I"),
                ],
                "Compiled",
                "Compiled",
                "Theorem 4 composition is closed. Arbitrary-width primitive compilers for all source one-term oracles remain a separately scoped implementation frontier.",
                route_closures=[
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.S1_isHermitian",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.S2_isHermitian",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_isHermitian",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",
                ],
            ),
'''
    text = replace_once(text, robin_marker, h_card + robin_marker, "Hamiltonian result card")

    text = text.replace(
        "The rejected branch is closed. The broader Robin paper reproduction remains experimental because several cited oracle contracts are not local gate-level certificates.",
        "The rejected branch is closed. Fixed-N8 source circuits and the GHL Theorem-4 A-to-H composition are compiled; arbitrary-width primitive compilers for the general source oracles remain separately scoped.",
    )

    old_teaching = r'''            ("What remains experimental", r"\text{paper theorem}=\text{local semantics}+\text{cited oracle contracts}.", "The research module now has zero proof holes, but several external oracle constructions are still typed assumptions rather than local gate-level certificates."),'''
    new_teaching = r'''            ("From one-term operators to the Hamiltonian", r"A=\sum_kA_k,\quad A^\dagger=\sum_kA_k^\dagger,\quad H=S_1\otimes x_\xi+S_2\otimes I_\xi.", "The paper itself carries this composition through Theorem 4. ASPBE now compiles the same source-level A/A-dagger, S1/S2, and H chain in GHLHamiltonian.lean."),
            ("The remaining compiler frontier", r"\text{source theorem}\to\text{arbitrary-width primitive gate list}.", "What remains open is not the Hamiltonian formula: it is a uniform primitive compiler proving all general-width one-term oracle resource bounds at the source paper's gate tier."),'''
    text = replace_once(text, old_teaching, new_teaching, "certified-cases teaching frontier")

    map_marker = '''    {\n        "goal": "Close the historical Robin raw-fold branch",'''
    map_row = r'''    {
        "goal": "Compose the GHL one-dimensional Hamiltonian",
        "contract": r"A=\sum_kA_k,\ A^\dagger=\sum_kA_k^\dagger,\ H=S_1\otimes x_\xi+S_2\otimes I_\xi",
        "obligation": "Finite sum/adjoint bridge, Hermitian S1/S2 split, and final Hamiltonian composition",
        "declaration": "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",
        "dependencies": "adjoint_sumTerms; S1_isHermitian; S2_isHermitian; Adagger_eq_sum_term_adjoints",
        "status": "Compiled",
        "missing": "None for Theorem-4 source composition; arbitrary-width primitive one-term resource compilation is a separate frontier",
        "chapter": "certified-cases",
    },
'''
    text = replace_once(text, map_marker, map_row + map_marker, "Hamiltonian implementation-map row")

    old_roadmap = '    ("Arbitrary-n GHL and full Hamiltonian reproduction", "Experimental"),'
    new_roadmap = '''    ("GHL Theorem 4 A-to-H Hamiltonian composition", "Compiled"),\n    ("Arbitrary-width GHL one-term primitive resource compiler", "Planned"),'''
    text = replace_once(text, old_roadmap, new_roadmap, "GHL roadmap split")
    path.write_text(text, encoding="utf-8")


def update_robin_map() -> None:
    path = ROOT / "website" / "robin-paper-map.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    data["paper"]["title"] = "Quantum Framework for Simulating Linear PDEs with Robin Boundary Conditions"
    interp = "Theorem 4 is part of the source paper: the one-term A_k and A_k-dagger ingredients are combined into A and A-dagger, then S1 and S2, and finally H = S1 tensor x_xi + S2 tensor I_xi. GHLHamiltonian.lean now formalizes that composition; only uniform primitive compilation of the general-width source oracles remains separate."
    if interp not in data["sourceInterpretation"]:
        data["sourceInterpretation"].append(interp)
    ids = {row["id"] for row in data["rows"]}
    if "hamiltonian-composition" not in ids:
        data["rows"].append({
            "id": "hamiltonian-composition",
            "paperAnchor": "Eq. (18), Eqs. (29)-(30), Theorem 4",
            "plain": "Combine the one-term matrices and their adjoints into A and A-dagger, form the two Hermitian Schrodingerisation pieces, and assemble the one-dimensional Hamiltonian.",
            "latex": "A=\\sum_kA_k,\\qquad A^\\dagger=\\sum_kA_k^\\dagger,\\qquad S=S_1+iS_2,\\qquad H=S_1\\otimes x_\\xi+S_2\\otimes I_\\xi.",
            "declarations": [
                "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
                "QuantumBlockEncoding.GHL2025.Hamiltonian.homogenizedS_eq_S1_add_iS2",
                "QuantumBlockEncoding.GHL2025.Hamiltonian.S1_isHermitian",
                "QuantumBlockEncoding.GHL2025.Hamiltonian.S2_isHermitian",
                "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",
                "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_isHermitian",
                "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I"
            ],
            "localStatus": "Compiled",
            "routeStatus": "Compiled",
            "reading": "This is the source-level Theorem-4 composition, not an extrapolation beyond the paper. The finite-sum adjoint identity, Hermitian S1/S2 decomposition, and final H formula compile as proof-carrying Lean data. The remaining generality frontier is uniform primitive compilation of all arbitrary-width one-term source oracles and their resource upper bounds."
        })
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def update_example_case() -> None:
    path = ROOT / "website" / "example-cases.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    robin = next(case for case in data["cases"] if case["slug"] == "robin-ghl-one-term")
    roots = [
        "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
        "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",
        "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_isHermitian",
        "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",
    ]
    for root in roots:
        if root not in robin["leanAnchors"]:
            robin["leanAnchors"].append(root)
    status = ["GHL Theorem-4 A to A-dagger to S1,S2 to H composition", "Complete", roots[-1]]
    if status not in robin["verificationStatus"]:
        robin["verificationStatus"].append(status)
    interp = "The source paper continues beyond the one-term block encoding: Theorem 4 combines A_k/A_k-dagger into A/A-dagger, builds S1 and S2, and forms H. ASPBE now compiles this composition in GHLHamiltonian.lean."
    if interp not in robin["sourceInterpretation"]:
        robin["sourceInterpretation"].append(interp)
    robin["limitations"] = (
        "The fixed circuit comparison remains N=8, homogeneous f=1, alpha=56/3, standard-RY-corrected, and compiler-specific. The paper's Theorem-4 A/A-dagger to S1,S2 to H composition is compiled generically; uniform arbitrary-width primitive compilation of every source oracle and global circuit optimality are not claimed."
    )
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def update_textbook_intro() -> None:
    path = ROOT / "website" / "textbook-lessons.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    intro = data["startHere"]
    intro["measurementFormula"] = "P(x)=|\\langle x|\\psi\\rangle|^2"
    intro["bellFormula"] = "|\\Phi^+\\rangle=(|00\\rangle+|11\\rangle)/\\sqrt2"
    intro["circuit"] = {
        "caption": "A first two-qubit circuit: H creates a superposition and CNOT turns it into an entangled Bell pair.",
        "wires": [
            {"label": "q0", "input": "|0>", "gates": ["H", "control"], "output": "Bell pair"},
            {"label": "q1", "input": "|0>", "gates": ["", "X target"], "output": "Bell pair"}
        ]
    }
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def update_enricher() -> None:
    path = ROOT / "website" / "scripts" / "enrich_teaching_site.py"
    text = path.read_text(encoding="utf-8")
    old = '''  {math_block(str(intro['formula']))}\n  {steps_html(list(intro['steps']))}'''
    new = '''  {math_block(str(intro['formula']))}\n  {math_block(str(intro['measurementFormula']))}\n  {circuit_html(dict(intro['circuit']))}\n  {math_block(str(intro['bellFormula']))}\n  {steps_html(list(intro['steps']))}'''
    text = replace_once(text, old, new, "start-here measurement/circuit insertion")
    path.write_text(text, encoding="utf-8")


def update_tests() -> None:
    path = ROOT / "website" / "scripts" / "test_site_contracts.py"
    text = path.read_text(encoding="utf-8")
    marker = '''    def test_no_credential_export_branch(self) -> None:\n'''
    method = r'''    def test_ghl_hamiltonian_composition_is_compiled(self) -> None:
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

'''
    text = replace_once(text, marker, method + marker, "Hamiltonian site-contract test")
    path.write_text(text, encoding="utf-8")

    tpath = ROOT / "website" / "scripts" / "test_teaching_enrichment.py"
    t = tpath.read_text(encoding="utf-8")
    marker2 = '''    def test_lesson_has_all_three_reading_layers(self) -> None:\n'''
    method2 = '''    def test_start_here_teaches_measurement_and_entanglement_visually(self) -> None:\n        data = enrich.load_data()\n        intro = data["startHere"]\n        self.assertIn("P(x)", intro["measurementFormula"])\n        self.assertIn("Phi", intro["bellFormula"])\n        self.assertEqual(len(intro["circuit"]["wires"]), 2)\n        self.assertIn("H", intro["circuit"]["wires"][0]["gates"])\n        self.assertIn("X target", intro["circuit"]["wires"][1]["gates"])\n\n'''
    t = replace_once(t, marker2, method2 + marker2, "start-here teaching test")
    tpath.write_text(t, encoding="utf-8")


def update_source_notes() -> None:
    path = ROOT / "paper-notes" / "GHL2025" / "source-excerpts.tex"
    text = path.read_text(encoding="utf-8")
    if "% ASPBE-THEOREM4-COMPOSITION" not in text:
        text += r'''

% ASPBE-THEOREM4-COMPOSITION
% Source audit note for Eq. (18), Eqs. (29)-(30), and Theorem 4.
% The paper combines the one-term A_k and A_k^\dagger encodings into A and
% A^\dagger, defines the Hermitian pieces S_1 and S_2 of the homogenized
% system, and then forms
%   H = S_1 \otimes x_\xi + S_2 \otimes I_\xi.
% The corresponding Lean source-level composition roots live in
% QuantumBlockEncoding/GHLHamiltonian.lean.
'''
    path.write_text(text, encoding="utf-8")


def main() -> None:
    update_literature()
    update_content()
    update_robin_map()
    update_example_case()
    update_textbook_intro()
    update_enricher()
    update_tests()
    update_source_notes()


if __name__ == "__main__":
    main()
