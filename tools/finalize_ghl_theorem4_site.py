#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROOT_DECL = "QuantumBlockEncoding.GHL2025.Hamiltonian.theorem4_source_lcu_route_closed"
PRINTED_REFUTATION = "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_ne_S1"
PRINTED_FILLER = "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_lowerRight"
S1_CORRECTED = "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PhaseBalancedClean_eq_S1"
S2_SOURCE = "QuantumBlockEncoding.GHL2025.Hamiltonian.eq30Clean_eq_S2"
H_FORMULA = "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I"


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected exactly one match, got {count}")
    return text.replace(old, new, 1)


def update_content() -> None:
    path = ROOT / "website" / "content.py"
    text = path.read_text(encoding="utf-8")
    start_marker = '''            result(\n                "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",'''
    end_marker = '''            result(\n                "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_ne_backendFold_n3",'''
    start = text.find(start_marker)
    end = text.find(end_marker, start)
    if start < 0 or end < 0:
        raise RuntimeError("Hamiltonian result-card boundaries missing")
    card = r'''            result(
                "QuantumBlockEncoding.GHL2025.Hamiltonian.theorem4_source_lcu_route_closed",
                "GHL Theorem 4: source-audited LCU composition to the Hamiltonian",
                "The paper's Theorem 4 route is now machine-checked from A and A-dagger through the LCU clean blocks for S1 and S2, then to H, together with the registered normalization, signal-width, and resource expressions.",
                r"A=\sum_kA_k,\quad A^\dagger=\sum_kA_k^\dagger,\quad H=S_1\otimes x_\xi+S_2\otimes I_\xi.",
                "ASPBE does not silently copy the displayed phases: a literal full-clean-matrix reading of the printed first LCU line leaves a nonzero lower-right filler because exp(i*pi)=exp(-i*pi)=-1. Lean proves that obstruction, then proves a phase-balanced correction gives exactly S1; the printed S2 line closes as written.",
                "This is the distinction the public status needs: the Hamiltonian composition is not open, but the source-phase audit and the remaining arbitrary-width primitive compiler must stay visible.",
                [
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
                    "QuantumBlockEncoding.Robin.ComplexLCU.prepareAmplitudeSelectUnprepare_unitary",
                    "QuantumBlockEncoding.Robin.ComplexLCU.prepareAmplitudeSelectUnprepare_cleanEntry",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_ne_S1",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PhaseBalancedClean_eq_S1",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.eq30Clean_eq_S2",
                ],
                "Assemble A and A-dagger from one-term inputs; audit the controlled-phase filler in the first S1 LCU; use the phase-balanced correction to obtain S1; verify the S2 LCU; then compose the two Hermitian pieces with x_xi and I_xi and attach the paper-facing normalization/resource record.",
                [
                    ("Assemble A and A-dagger.", "adjoint_sumTerms / Adagger_eq_sum_term_adjoints"),
                    ("Refute the literal printed filler cancellation.", "eq29PrintedClean_ne_S1"),
                    ("Close the corrected S1 clean block.", "eq29PhaseBalancedClean_eq_S1"),
                    ("Close S2 from the printed second LCU line.", "eq30Clean_eq_S2"),
                    ("Close H plus source metadata.", "theorem4_source_lcu_route_closed"),
                ],
                "Compiled",
                "Compiled",
                "The source-audited Theorem-4 composition is closed. Uniform arbitrary-width primitive compilation of all Theorem-3 source oracles and their concrete gate/resource realization remains a separate compiler frontier.",
                route_closures=[
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_lowerRight",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_ne_S1",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PhaseBalancedClean_eq_S1",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.eq30Clean_eq_S2",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.oneDimHamiltonianClaim_normalization_closed",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.oneDimHamiltonianClaim_layout_closed",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.oneDimHamiltonianResource_pureAncilla_closed",
                    "QuantumBlockEncoding.GHL2025.Hamiltonian.theorem4_source_lcu_route_closed",
                ],
            ),
'''
    text = text[:start] + card + text[end:]

    old_decl = '''        "declaration": "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",'''
    new_decl = f'''        "declaration": "{ROOT_DECL}",'''
    if old_decl in text:
        text = text.replace(old_decl, new_decl, 1)
    elif new_decl not in text:
        raise RuntimeError("Hamiltonian implementation-map declaration missing")

    old_dep = '        "dependencies": "adjoint_sumTerms; S1_isHermitian; S2_isHermitian; Adagger_eq_sum_term_adjoints",'
    new_dep = '        "dependencies": "adjoint_sumTerms; verified ComplexLCU kernel; eq29PrintedClean_ne_S1; eq29PhaseBalancedClean_eq_S1; eq30Clean_eq_S2",'
    if old_dep in text:
        text = text.replace(old_dep, new_dep, 1)

    old_missing = '        "missing": "None for Theorem-4 source composition; arbitrary-width primitive one-term resource compilation is a separate frontier",'
    new_missing = '        "missing": "None for the source-audited Theorem-4 composition; arbitrary-width primitive one-term gate/resource compilation is a separate frontier",'
    if old_missing in text:
        text = text.replace(old_missing, new_missing, 1)

    old_section = r'''            ("From one-term operators to the Hamiltonian", r"A=\sum_kA_k,\quad A^\dagger=\sum_kA_k^\dagger,\quad H=S_1\otimes x_\xi+S_2\otimes I_\xi.", "The paper itself carries this composition through Theorem 4. ASPBE now compiles the same source-level A/A-dagger, S1/S2, and H chain in GHLHamiltonian.lean."),'''
    new_section = r'''            ("From one-term operators to the Hamiltonian", r"A=\sum_kA_k,\quad A^\dagger=\sum_kA_k^\dagger,\quad H=S_1\otimes x_\xi+S_2\otimes I_\xi.", "The paper itself carries this composition through Theorem 4. ASPBE compiles the same A/A-dagger, S1/S2, and H chain and also checks the LCU filler phases rather than treating the displayed matrix equality as self-evident."),
            ("A source audit matters", r"e^{i\pi}=e^{-i\pi}=-1.", "Under a literal full-clean-matrix reading, the printed first S1 LCU phase pair leaves a lower-right -N_A identity filler. Lean records that obstruction and separately proves the phase-balanced correction that yields the intended S1 matrix; S2 closes with the printed zero phases."),'''
    if old_section in text:
        text = text.replace(old_section, new_section, 1)

    path.write_text(text, encoding="utf-8")


def update_robin_map() -> None:
    path = ROOT / "website" / "robin-paper-map.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    audit = (
        "Source audit for Eq. (30): with Eq. (29)'s L1(phi), L2(phi) definitions, the printed first-line phases pi and -pi both contribute exp(i phi)=-1 on the filler block. A literal full-clean-matrix sum therefore leaves -N_A I rather than the displayed zero lower-right block. Lean proves this obstruction and separately proves a phase-balanced correction; the S2 line closes as printed."
    )
    if audit not in data["sourceInterpretation"]:
        data["sourceInterpretation"].append(audit)

    row = next(row for row in data["rows"] if row["id"] == "hamiltonian-composition")
    row["plain"] = (
        "Use verified LCU clean-block algebra to combine A and A-dagger into S1 and S2, then assemble the one-dimensional Hamiltonian; keep the printed phase audit explicit."
    )
    row["paperAnchor"] = "Eq. (29), Eq. (30), Theorem 4"
    row["declarations"] = [
        "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",
        PRINTED_FILLER,
        PRINTED_REFUTATION,
        S1_CORRECTED,
        S2_SOURCE,
        "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",
        H_FORMULA,
        "QuantumBlockEncoding.GHL2025.Hamiltonian.oneDimHamiltonianClaim_normalization_closed",
        "QuantumBlockEncoding.GHL2025.Hamiltonian.oneDimHamiltonianClaim_layout_closed",
        "QuantumBlockEncoding.GHL2025.Hamiltonian.oneDimHamiltonianResource_pureAncilla_closed",
        ROOT_DECL,
    ]
    row["reading"] = (
        "Theorem 4 is not left open. Lean closes the source-audited LCU route through A/A-dagger, S1/S2, H, and the paper-facing normalization/layout/resource records. The literal printed S1 phase pair is separately refuted as a full clean matrix and replaced by an explicit phase-balanced correction. Uniform primitive compilation of all arbitrary-width Theorem-3 oracles remains a separate implementation frontier."
    )
    row["localStatus"] = "Compiled"
    row["routeStatus"] = "Compiled"

    if not any(r["id"] == "hamiltonian-phase-audit" for r in data["rows"]):
        data["rows"].insert(-1, {
            "id": "hamiltonian-phase-audit",
            "paperAnchor": "Eq. (29) and first line of Eq. (30)",
            "plain": "Check whether the printed phases really cancel the filler block before accepting the S1 LCU equality.",
            "latex": "e^{i\\pi}=e^{-i\\pi}=-1\\;\\Longrightarrow\\;\\text{printed filler}=-\\mathcal N_A I\\neq0,\\qquad\\text{phase-balanced filler}=0.",
            "declarations": [PRINTED_FILLER, PRINTED_REFUTATION, S1_CORRECTED],
            "localStatus": "Compiled",
            "routeStatus": "Compiled",
            "reading": "This row is a source audit, not a new open problem. ASPBE proves the literal printed full-clean-matrix phase pair does not produce S1 when N_A is nonzero, and proves a phase-balanced correction produces exactly S1."
        })

    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def update_example_case() -> None:
    path = ROOT / "website" / "example-cases.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    robin = next(case for case in data["cases"] if case["slug"] == "robin-ghl-one-term")
    for root in (PRINTED_FILLER, PRINTED_REFUTATION, S1_CORRECTED, S2_SOURCE, ROOT_DECL):
        if root not in robin["leanAnchors"]:
            robin["leanAnchors"].append(root)
    audit_row = ["Printed Eq. (30) first-line phase pair: full-clean-matrix audit", "Refuted as printed", PRINTED_REFUTATION]
    close_row = ["Source-audited Theorem-4 LCU composition to H", "Complete", ROOT_DECL]
    for item in (audit_row, close_row):
        if item not in robin["verificationStatus"]:
            robin["verificationStatus"].append(item)
    audit = (
        "The Hamiltonian route is source-audited rather than silently normalized: the literal printed first S1 LCU phase pair leaves a -N_A identity filler, while a phase-balanced correction gives the intended S1. The second S2 LCU line and the final H composition close in Lean."
    )
    if audit not in robin["sourceInterpretation"]:
        robin["sourceInterpretation"].append(audit)
    robin["limitations"] = (
        "The fixed circuit comparison remains N=8, homogeneous f=1, alpha=56/3, standard-RY-corrected, and compiler-specific. The source-audited Theorem-4 LCU composition through H is compiled; the printed first S1 phase pair is explicitly flagged and corrected. Uniform arbitrary-width primitive compilation of every Theorem-3 source oracle and global circuit optimality are not claimed."
    )
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def update_literature() -> None:
    path = ROOT / "QuantumBlockEncoding" / "Literature.lean"
    text = path.read_text(encoding="utf-8")
    old = 'note := "Fixed-N8 one-term source circuits are primitive-certified; Theorem 4 A/A-dagger to S1,S2 to H composition is formalized generically. Arbitrary-width primitive resource compilation remains a separate frontier."'
    new = 'note := "Fixed-N8 one-term source circuits are primitive-certified; Theorem 4 A/A-dagger to S1,S2 to H source LCU composition is formalized with an explicit Eq. (30) phase audit and phase-balanced S1 correction. Arbitrary-width primitive resource compilation remains a separate frontier."'
    if old in text:
        text = text.replace(old, new, 1)
    elif new not in text:
        raise RuntimeError("GHL literature note anchor missing")
    path.write_text(text, encoding="utf-8")


def update_source_notes() -> None:
    path = ROOT / "paper-notes" / "GHL2025" / "source-excerpts.tex"
    text = path.read_text(encoding="utf-8")
    marker = "% ASPBE-THEOREM4-PHASE-AUDIT"
    if marker not in text:
        text += r'''

% ASPBE-THEOREM4-PHASE-AUDIT
% Eq. (29) defines both L_1(phi) and L_2(phi) with the filler I exp(i phi).
% The first line of Eq. (30) then uses phases pi and -pi.  Since both phases
% equal -1, a literal full-clean-matrix addition leaves the lower-right filler
% -N_A I rather than the displayed zero block.  ASPBE records this as the
% theorem eq29PrintedClean_ne_S1 (for nonzero N_A), and separately certifies a
% phase-balanced correction with filler phases +1 and -1 via
% eq29PhaseBalancedClean_eq_S1.  The S_2 line closes with the printed zero
% phases, and theorem4_source_lcu_route_closed packages the corrected S_1,
% printed S_2, final H formula, and paper-facing metadata.
'''
    path.write_text(text, encoding="utf-8")


def update_tests() -> None:
    path = ROOT / "website" / "scripts" / "test_site_contracts.py"
    text = path.read_text(encoding="utf-8")
    old_required = '''        required = {\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",\n        }'''
    new_required = '''        required = {\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.adjoint_sumTerms",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_ne_S1",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PhaseBalancedClean_eq_S1",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.eq30Clean_eq_S2",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.Adagger_eq_sum_term_adjoints",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.OneDimCompositionCertificate.H_eq_S1_tensor_xXi_add_S2_tensor_I",\n            "QuantumBlockEncoding.GHL2025.Hamiltonian.theorem4_source_lcu_route_closed",\n        }'''
    if old_required in text:
        text = text.replace(old_required, new_required, 1)
    elif ROOT_DECL not in text:
        raise RuntimeError("Hamiltonian required-root test anchor missing")

    old_tail = '''        self.assertIn("ImplementationStatus.formalized", ghl)\n        self.assertIn("QuantumBlockEncoding/GHLHamiltonian.lean", ghl)\n'''
    new_tail = '''        self.assertIn("ImplementationStatus.formalized", ghl)\n        self.assertIn("QuantumBlockEncoding/GHLHamiltonian.lean", ghl)\n        self.assertIn("phase audit", ghl)\n        audit = next(row for row in data["rows"] if row["id"] == "hamiltonian-phase-audit")\n        self.assertEqual(audit["routeStatus"], "Compiled")\n        self.assertIn("eq29PrintedClean_ne_S1", " ".join(audit["declarations"]))\n        self.assertIn("phase-balanced", audit["reading"])\n'''
    if old_tail in text:
        text = text.replace(old_tail, new_tail, 1)
    path.write_text(text, encoding="utf-8")


def update_readme() -> None:
    path = ROOT / "README.md"
    text = path.read_text(encoding="utf-8")
    old = '''  Theorem-4 composition from `A_k` and `A_k†` through `A`, `A†`, `S₁`, `S₂`,\n  and the one-dimensional Hamiltonian `H`; the remaining GHL frontier is the\n  uniform arbitrary-width primitive compiler/resource theorem for the source\n  one-term oracles, not the Hamiltonian composition itself.\n'''
    new = '''  Theorem-4 composition from `A_k` and `A_k†` through `A`, `A†`, `S₁`, `S₂`,\n  and the one-dimensional Hamiltonian `H`. The source audit also proves that the\n  literal printed first `S₁` LCU phase pair leaves a nonzero filler block and\n  records the phase-balanced correction; the remaining GHL frontier is the\n  uniform arbitrary-width primitive compiler/resource theorem for the source\n  one-term oracles, not the Hamiltonian composition itself.\n'''
    if old in text:
        text = text.replace(old, new, 1)
    current = '''- the GHL Theorem-4 source-level composition from one-term `A_k` / `A_k†`\n  ingredients to `A`, `A†`, `S₁`, `S₂`, and\n  `H = S₁ ⊗ x_ξ + S₂ ⊗ I_ξ`;'''
    replacement = '''- the GHL Theorem-4 source-audited LCU composition from one-term `A_k` / `A_k†`\n  ingredients to `A`, `A†`, `S₁`, `S₂`, and\n  `H = S₁ ⊗ x_ξ + S₂ ⊗ I_ξ`, including a Lean-refuted literal phase pair and\n  a Lean-certified phase-balanced `S₁` correction;'''
    if current in text:
        text = text.replace(current, replacement, 1)
    path.write_text(text, encoding="utf-8")


def main() -> None:
    update_content()
    update_robin_map()
    update_example_case()
    update_literature()
    update_source_notes()
    update_tests()
    update_readme()


if __name__ == "__main__":
    main()
