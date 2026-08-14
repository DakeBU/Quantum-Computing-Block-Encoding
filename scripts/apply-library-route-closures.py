#!/usr/bin/env python3
"""Apply the proof-backed teaching-route closure metadata once, then regenerate catalogs."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path
from textwrap import dedent


ROOT = Path(__file__).resolve().parents[1]


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{label}: expected one match, found {count}")
    return text.replace(old, new, 1)


def replace_result_block(text: str, declaration: str, replacement: str) -> str:
    marker = f'            result(\n                "{declaration}",'
    start = text.find(marker)
    if start < 0:
        raise SystemExit(f"result block not found: {declaration}")
    closing = "\n            ),"
    end = text.find(closing, start)
    if end < 0:
        raise SystemExit(f"result block closing not found: {declaration}")
    end += len(closing)
    return text[:start] + dedent(replacement).strip("\n") + text[end:]


def patch_content() -> None:
    path = ROOT / "website" / "content.py"
    text = path.read_text(encoding="utf-8")

    text = replace_once(
        text,
        '''            "QuantumBlockEncoding/BlockEncodingClassics.lean",\n            "QuantumBlockEncoding/BandedSparseAccess.lean",''',
        '''            "QuantumBlockEncoding/BlockEncodingClassics.lean",\n            "QuantumBlockEncoding/BandedSparseAccess.lean",\n            "QuantumBlockEncoding/BandedSparseAccessPrimitive.lean",''',
        "classic-route module list",
    )
    text = replace_once(
        text,
        '''            "QuantumBlockEncoding/Automation.lean",\n            "QuantumBlockEncoding/PromiseGateOptimization.lean",''',
        '''            "QuantumBlockEncoding/Automation.lean",\n            "QuantumBlockEncoding/PromiseGateOptimization.lean",\n            "QuantumBlockEncoding/CubicAmplitudePrimitive.lean",''',
        "resource/export module list",
    )
    text = replace_once(
        text,
        '''            "QuantumBlockEncoding/Automation.lean",\n            "QuantumBlockEncoding/Literature.lean",\n            "QuantumBlockEncoding/OpenProblems.lean",''',
        '''            "QuantumBlockEncoding/Automation.lean",\n            "QuantumBlockEncoding/AutomationTrace.lean",\n            "QuantumBlockEncoding/Literature.lean",\n            "QuantumBlockEncoding/OpenProblems.lean",\n            "QuantumBlockEncoding/OpenProblemsAudit.lean",''',
        "automation module list",
    )

    text = replace_result_block(
        text,
        "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_clean_slot",
        r'''
            result(
                "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_clean_slot",
                "Banded sparse address access",
                "The arbitrary-size loader-plus-SUM semantics is unitary, and a clean three-bit instance is refined to the exact primitive basis.",
                r"|0^{n-l}\rangle|s\rangle|i\rangle\mapsto|r_{s0}+i\bmod 2^n\rangle|i\rangle.",
                "The source-dependent loader chooses the first-row offset; the reusable SUM operation shifts it to row i.",
                "The generic semantics matches the cited construction, while the finite primitive witness proves that the compiler boundary is executable and oracle-free.",
                [
                    "QuantumBlockEncoding.BandedSparseAccess.modularSumEquiv",
                    "QuantumBlockEncoding.BandedSparseAccess.accessMatrix_unitary",
                    "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_eval",
                ],
                "Compose the generic finite equivalences, then instantiate an XOR-three loader, compile its modular adder to X/RY/RZ/CX, and prove clean action, unitarity, and zero unresolved oracle calls.",
                [
                    ("Load the first-row band offset.", "liftLoaderEquiv / primitiveOffset3"),
                    ("Add the preserved row modulo 2^n.", "modularSumEquiv / modularAdd3ReversibleProgram"),
                    ("Prove the clean selected address.", "accessEquiv_clean_slot / primitiveAccess3_cleanAction"),
                    ("Refine the finite witness to primitive matrices.", "primitiveAccess3Program_eval"),
                ],
                "Compiled",
                "Compiled",
                "None within the declared semantic-plus-finite-compiler route. The paper's arbitrary-size one-qubit/CNOT upper bound remains a separate general compiler theorem.",
                route_closures=[
                    "QuantumBlockEncoding.BandedSparseAccess.accessMatrix_unitary",
                    "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3_cleanAction",
                    "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_eval",
                    "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_unitary",
                    "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_oracleCalls_eq_zero",
                ],
            ),''',
    )

    text = replace_result_block(
        text,
        "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_costTuple_eq",
        r'''
            result(
                "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveVerifiedBlockEncoding",
                "Finite cubic amplitude oracle",
                "A four-way uniformly controlled RY circuit exactly block-encodes the two-qubit cubic diagonal operator.",
                r"\Pi_0U_{\mathrm{cubic},2}\Pi_0^\dagger=\operatorname{diag}(0,(1/4)^3,(2/4)^3,(3/4)^3).",
                "Each system basis string selects the exact angle 2 arccos((j/4)^3); the clean RY entry is therefore the desired diagonal amplitude.",
                "The earlier opaque one-call tuple remains a diagnostic, but the accepted teaching route now has gate-expanded semantics, exact clean projection, and a verified block-encoding wrapper.",
                [
                    "QuantumBlockEncoding.compileUniformlyControlledRy_eval_controlledRyBlockMatrix",
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveProgram_cleanEntry",
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveFlatUnitary_unitary",
                ],
                "Compile the four exact amplitudes through the uniformly controlled RY theorem, prove the clean entries, reindex the little-endian basis, and package the resulting unitary as a verified block encoding.",
                [
                    ("Select one exact cubic amplitude.", "cubicN2Angle"),
                    ("Compile the multiplexed rotations.", "cubicN2PrimitiveCircuit_eval"),
                    ("Prove the clean diagonal entry.", "cubicN2PrimitiveProgram_cleanEntry"),
                    ("Promote the flat unitary and block.", "cubicN2PrimitiveVerifiedBlockEncoding"),
                ],
                "Compiled",
                "Compiled",
                "None within the fixed n=2 primitive route. Scalable arithmetic and general QSVT phase synthesis remain separately scoped research routes.",
                route_closures=[
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveProgram_cleanEntry",
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveFlatUnitary_unitary",
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveFlatUnitary_cleanBlock",
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveVerifiedBlockEncoding",
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2Primitive_oracleCalls_eq_zero",
                ],
            ),''',
    )

    text = replace_result_block(
        text,
        "QuantumBlockEncoding.threeLayerAgentContracts",
        r'''
            result(
                "QuantumBlockEncoding.threeLayerAgentContracts",
                "Three-layer agent contracts",
                "The harness records distinct responsibilities and a typed, executable handoff state machine for planning, refinement, proof work, and review.",
                r"\text{upper}\rightarrow\text{middle}\rightarrow\text{lower}\rightarrow\text{reviewer}\rightarrow\text{accepted}.",
                "Every handoff must be logged and carry an artifact; acceptance additionally requires both the Lean gate and reviewer approval.",
                "Hard tasks need explicit ownership and machine-checkable promotion conditions instead of repeated untracked prompts.",
                [
                    "QuantumBlockEncoding.AutomationStage",
                    "QuantumBlockEncoding.AutomationTask",
                    "QuantumBlockEncoding.ThreeLayerTrace",
                ],
                "Encode role contracts as data, define an executable transition guard, and prove that the canonical trace reaches acceptance while a failed Lean gate cannot do so.",
                [
                    ("Declare stage and task types.", "AutomationStage / AutomationTask"),
                    ("Instantiate layer contracts.", "threeLayerAgentContracts"),
                    ("Check every typed handoff.", "threeLayerCanonicalTrace_allValid"),
                    ("Require Lean and reviewer approval.", "threeLayerAccepted_requiresLeanGate"),
                ],
                "Compiled",
                "Compiled",
                "None within the typed handoff and acceptance route. Running external models remains engineering evidence rather than a Lean theorem.",
                route_closures=[
                    "QuantumBlockEncoding.threeLayerCanonicalTrace_allValid",
                    "QuantumBlockEncoding.threeLayerCanonicalTrace_reachesAccepted",
                    "QuantumBlockEncoding.threeLayerAccepted_requiresLeanGate",
                    "QuantumBlockEncoding.threeLayerAccepted_requiresReviewerApproval",
                    "QuantumBlockEncoding.threeLayerFailedGateTrace_notAccepted",
                ],
            ),''',
    )

    text = replace_result_block(
        text,
        "QuantumBlockEncoding.openProblems",
        r'''
            result(
                "QuantumBlockEncoding.openProblems",
                "Open problems are first-class data",
                "Unfinished mathematical or engineering routes are listed explicitly with stable identifiers, status, evidence requirements, and source references.",
                r"\mathcal O=[o_1,\ldots,o_7],\qquad \operatorname{Nodup}(\operatorname{id}(\mathcal O)).",
                "A planned result cannot be mistaken for a theorem merely because it appears near compiled code.",
                "The registry route is itself audited even though the mathematical problems it contains intentionally remain open.",
                [
                    "QuantumBlockEncoding.OpenProblem",
                    "QuantumBlockEncoding.openProblemIds",
                ],
                "Publish the typed records, prove that their identifiers are unique, and check that every entry has a nonempty statement, acceptance test, and reference list.",
                [
                    ("Describe each obligation.", "OpenProblem"),
                    ("Publish the current list.", "openProblems"),
                    ("Check stable unique identifiers.", "openProblemIds_nodup"),
                    ("Check actionable evidence fields.", "openProblems_all_actionable"),
                ],
                "Compiled",
                "Compiled",
                "The registry route is closed; its seven mathematical problems remain intentionally open and are not presented as solved theorems.",
                route_closures=[
                    "QuantumBlockEncoding.openProblems_count",
                    "QuantumBlockEncoding.openProblemIds_nodup",
                    "QuantumBlockEncoding.openProblems_all_actionable",
                    "QuantumBlockEncoding.openProblemRegistry_compiled",
                ],
            ),''',
    )

    old_entries = [
        (r'''    {
        "goal": "Prepare a finite target state",
        "contract": r"U|0^n\rangle=|\psi\rangle",
        "obligation": "Unitary candidate and first-column equality",
        "declaration": "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget",
        "dependencies": "StatePreparationTarget; StatePreparationCandidate",
        "status": "Partial route",
        "missing": "Instantiate and certify each concrete target family",
        "chapter": "state-preparation",
    },''', r'''    {
        "goal": "Prepare a finite target state",
        "contract": r"U|0^n\rangle=|\psi\rangle",
        "obligation": "Normalization, unitarity, and first-column equality supplied to the promotion constructor",
        "declaration": "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget",
        "dependencies": "StatePreparationCandidate.certify; textbook Pauli-X and Hadamard witnesses",
        "status": "Compiled",
        "missing": "None for the reusable promotion route; each new target family supplies its own proof terms",
        "chapter": "state-preparation",
    },'''),
        (r'''    {
        "goal": "Extract a block from a circuit",
        "contract": r"\Pi U\Pi^\dagger=A/\alpha",
        "obligation": "Ancilla-zero projection equality",
        "declaration": "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget",
        "dependencies": "CircuitMatrixSemantics; signalSystemBlockProjection",
        "status": "Partial route",
        "missing": "Concrete circuit unitarity and entry proof",
        "chapter": "circuit-semantics",
    },''', r'''    {
        "goal": "Extract a block from a circuit",
        "contract": r"\Pi U\Pi^\dagger=A/\alpha",
        "obligation": "Typed circuit semantics, selected projection equality, and finite identity witness",
        "declaration": "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget",
        "dependencies": "CertifiedCircuitBlockExtraction; teachingIdentityBlockExtraction",
        "status": "Compiled",
        "missing": "None for the reusable extraction route; each concrete circuit supplies its unitary and entry proof",
        "chapter": "circuit-semantics",
    },'''),
        (r'''    {
        "goal": "Package an exact block encoding",
        "contract": r"\Pi U\Pi^\dagger=A/\alpha",
        "obligation": "Candidate validity and exact block identity",
        "declaration": "QuantumBlockEncoding.VerifiedOperatorBlockEncoding",
        "dependencies": "QueryOperatorTarget; OperatorBlockEncodingCandidate",
        "status": "Partial route",
        "missing": "Concrete candidate fields vary by route",
        "chapter": "block-encoding",
    },''', r'''    {
        "goal": "Package an exact block encoding",
        "contract": r"\Pi U\Pi^\dagger=A/\alpha",
        "obligation": "Candidate unitarity and exact block identity supplied to the promotion constructor",
        "declaration": "QuantumBlockEncoding.VerifiedOperatorBlockEncoding",
        "dependencies": "OperatorBlockEncodingCandidate.certify; certified finite cases",
        "status": "Compiled",
        "missing": "None for the reusable promotion route; concrete candidate fields remain route-specific inputs",
        "chapter": "block-encoding",
    },'''),
        (r'''    {
        "goal": "Feed a diagonal encoding to QSVT",
        "contract": r"U_D\leadsto p^{(\mathrm{SV})}(D/\alpha)",
        "obligation": "Concrete QSVT sequence and polynomial error",
        "declaration": "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract",
        "dependencies": "Source block encoding; polynomial conditions",
        "status": "Partial route",
        "missing": "Consumer implementation and approximation proof",
        "chapter": "classic-routes",
    },''', r'''    {
        "goal": "Feed a certified clean block to a typed polynomial consumer",
        "contract": r"U_D\leadsto p^{(\mathrm{SV})}(D/\alpha)",
        "obligation": "Source certificate, side conditions, and a finite degree-one identity realization",
        "declaration": "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract",
        "dependencies": "QSVTConsumerContract.identity; teachingIdentityQSVTConsumer",
        "status": "Compiled",
        "missing": "None for the typed identity consumer; general phase synthesis and approximation checking remain roadmap items",
        "chapter": "classic-routes",
    },'''),
    ]
    for index, (old, new) in enumerate(old_entries, start=1):
        text = replace_once(text, old, new, f"implementation-map entry {index}")

    new_map_rows = r'''    {
        "goal": "Compile a finite banded sparse-access witness",
        "contract": r"|s\rangle|i\rangle|0\rangle\mapsto|s\oplus3+i\bmod8\rangle|i\rangle|0\rangle",
        "obligation": "Primitive refinement, clean workspace, unitarity, and zero oracle calls",
        "declaration": "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_eval",
        "dependencies": "modularAdd3ReversibleProgram; compileReversibleProgram_eval",
        "status": "Compiled",
        "missing": "Arbitrary-width source gate upper bounds remain a separate compiler theorem",
        "chapter": "classic-routes",
    },
    {
        "goal": "Compile a finite cubic diagonal amplitude oracle",
        "contract": r"\Pi_0U\Pi_0^\dagger=\operatorname{diag}((j/4)^3)",
        "obligation": "Exact multiplexed RY semantics, clean projection, and verified BE packaging",
        "declaration": "QuantumBlockEncoding.CubicDiagonalOracle.cubicN2PrimitiveVerifiedBlockEncoding",
        "dependencies": "UniformlyControlledRy; PrimitiveBasisLE; exact RY bridge",
        "status": "Compiled",
        "missing": "Scalable arithmetic and general QSVT phase synthesis are separate routes",
        "chapter": "resources-and-exports",
    },
    {
        "goal": "Verify three-layer harness promotion",
        "contract": r"\text{upper}\to\text{middle}\to\text{lower}\to\text{reviewer}\to\text{accepted}",
        "obligation": "Logged artifacts, valid role order, Lean gate, and reviewer approval",
        "declaration": "QuantumBlockEncoding.threeLayerCanonicalTrace_reachesAccepted",
        "dependencies": "ThreeLayerHandoff.validFlag; ThreeLayerTrace.finalPhase",
        "status": "Compiled",
        "missing": "External model execution remains engineering evidence",
        "chapter": "automation-and-roadmap",
    },
    {
        "goal": "Audit the open-problem registry",
        "contract": r"|\mathcal O|=7\land\operatorname{Nodup}(\operatorname{id}(\mathcal O))",
        "obligation": "Unique identifiers and nonempty actionable fields",
        "declaration": "QuantumBlockEncoding.openProblemRegistry_compiled",
        "dependencies": "openProblemIds_nodup; openProblems_all_actionable",
        "status": "Compiled",
        "missing": "The registered mathematical problems intentionally remain open",
        "chapter": "automation-and-roadmap",
    },
'''
    insertion_marker = '''    {\n        "goal": "Close the historical Robin raw-fold branch",'''
    text = replace_once(
        text,
        insertion_marker,
        new_map_rows + insertion_marker,
        "implementation-map closure rows",
    )

    old_roadmap = r'''ROADMAP = [
    ("State-preparation contracts and first-column consumer", "Compiled"),
    ("Textbook Pauli X and Hadamard certificates", "Compiled"),
    ("Circuit syntax to matrix semantics", "Compiled"),
    ("Reusable exact block-encoding routes", "Compiled"),
    ("BE Case 1 transfer-operator certificate", "Compiled"),
    ("BE Case 2 exact Householder certificate", "Compiled"),
    ("Primitive amplitude-oracle cost record", "Partial route"),
    ("Concrete QSVT polynomial realization", "Planned"),
    ("Paper-wide Robin backend reproduction", "Experimental"),
    ("Historical Robin H-free raw-fold rejection", "Compiled"),
]'''
    new_roadmap = r'''ROADMAP = [
    ("State-preparation contracts and first-column consumer", "Compiled"),
    ("Textbook Pauli X and Hadamard certificates", "Compiled"),
    ("Circuit syntax to matrix semantics", "Compiled"),
    ("Reusable exact block-encoding routes", "Compiled"),
    ("Finite three-bit primitive banded sparse access", "Compiled"),
    ("BE Case 1 transfer-operator certificate", "Compiled"),
    ("BE Case 2 exact Householder certificate", "Compiled"),
    ("Finite two-qubit cubic primitive amplitude oracle", "Compiled"),
    ("Degree-one QSVT identity consumer realization", "Compiled"),
    ("Three-layer controller trace and registry audit", "Compiled"),
    ("Fixed-N8 Robin T3 reproduction and evolved winner", "Compiled"),
    ("Arbitrary-width banded-access source resource compiler", "Planned"),
    ("General QSVT phase synthesis and approximation checker", "Planned"),
    ("Arbitrary-n GHL and full Hamiltonian reproduction", "Experimental"),
    ("Historical Robin H-free raw-fold rejection", "Compiled"),
]'''
    text = replace_once(text, old_roadmap, new_roadmap, "roadmap split")

    path.write_text(text, encoding="utf-8", newline="\n")


def patch_catalog_generator() -> None:
    path = ROOT / "scripts" / "generate-blueprint-catalog.py"
    text = path.read_text(encoding="utf-8")
    text = replace_once(
        text,
        '{"BandedSparseAccess.lean", "BlockEncodingClassics.lean"}',
        '{"BandedSparseAccess.lean", "BandedSparseAccessPrimitive.lean", "BlockEncodingClassics.lean"}',
        "classic catalog files",
    )
    text = replace_once(
        text,
        '("Cubic", "catalog-cubic", {"CubicStatePreparation.lean"})',
        '("Cubic", "catalog-cubic", {"CubicStatePreparation.lean", "CubicAmplitudePrimitive.lean"})',
        "cubic catalog files",
    )
    text = replace_once(
        text,
        '{"Automation.lean", "Literature.lean", "OpenProblems.lean"}',
        '{"Automation.lean", "AutomationTrace.lean", "Literature.lean", "OpenProblems.lean", "OpenProblemsAudit.lean"}',
        "automation catalog files",
    )
    path.write_text(text, encoding="utf-8", newline="\n")


def patch_site_tests() -> None:
    path = ROOT / "website" / "scripts" / "test_site_contracts.py"
    text = path.read_text(encoding="utf-8")
    text = replace_once(
        text,
        "from website.content import CHAPTERS",
        "from website.content import CHAPTERS, ROADMAP",
        "site test imports",
    )
    text = replace_once(
        text,
        '''CORE_COMPLETE_TRACKS = {\n    "Shared foundations",\n    "State preparation",\n    "Block encoding",\n}''',
        '''TEACHING_TRACKS = {str(chapter["track"]) for chapter in CHAPTERS}''',
        "teaching track set",
    )
    text = text.replace("CORE_COMPLETE_TRACKS", "TEACHING_TRACKS")
    old_assertions = '''                self.assertIn(result["route_status"], build_site.STATUS_ORDER)\n                if result["route_status"] == "Compiled":\n                    self.assertTrue(result["route_closures"], result["declaration"])\n                else:\n                    self.assertTrue(result["missing"], result["declaration"])'''
    new_assertions = '''                self.assertEqual(result["route_status"], "Compiled", result["declaration"])\n                self.assertTrue(result["route_closures"], result["declaration"])'''
    text = replace_once(text, old_assertions, new_assertions, "route status assertions")
    old_render_assertions = '''            self.assertIn("Route closure", rendered, chapter["slug"])\n            for result in chapter["results"]:\n                if result["route_status"] != "Compiled":\n                    self.assertIn(\n                        build_site.html.escape(str(result["missing"])),\n                        rendered,\n                        result["declaration"],\n                    )'''
    new_render_assertions = '''            self.assertIn("Route closure", rendered, chapter["slug"])\n            for result in chapter["results"]:\n                self.assertEqual(result["route_status"], "Compiled", result["declaration"])\n                for root in result["route_closures"]:\n                    self.assertIn(build_site.html.escape(str(root)), rendered)'''
    text = replace_once(
        text,
        old_render_assertions,
        new_render_assertions,
        "rendered route assertions",
    )
    insertion = '''\n    def test_roadmap_separates_closed_witnesses_from_open_generality(self) -> None:\n        status = dict(ROADMAP)\n        self.assertEqual(status["Finite three-bit primitive banded sparse access"], "Compiled")\n        self.assertEqual(status["Finite two-qubit cubic primitive amplitude oracle"], "Compiled")\n        self.assertEqual(status["Degree-one QSVT identity consumer realization"], "Compiled")\n        self.assertEqual(status["Fixed-N8 Robin T3 reproduction and evolved winner"], "Compiled")\n        self.assertEqual(status["Arbitrary-width banded-access source resource compiler"], "Planned")\n        self.assertEqual(status["General QSVT phase synthesis and approximation checker"], "Planned")\n        self.assertEqual(status["Arbitrary-n GHL and full Hamiltonian reproduction"], "Experimental")\n\n'''
    marker = "    def test_robin_tex_is_canonical(self) -> None:\n"
    text = replace_once(text, marker, insertion + marker, "roadmap regression test")
    path.write_text(text, encoding="utf-8", newline="\n")


def run(command: list[str]) -> None:
    print("+", " ".join(command), flush=True)
    subprocess.run(command, cwd=ROOT, check=True)


def main() -> int:
    patch_content()
    patch_catalog_generator()
    patch_site_tests()
    run([sys.executable, "scripts/generate-blueprint-catalog.py"])
    run([sys.executable, "scripts/generate-blueprint-catalog.py", "--check"])
    run([sys.executable, "-m", "unittest", "website.scripts.test_site_contracts"])
    run(["git", "diff", "--check"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
