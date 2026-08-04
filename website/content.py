"""Curated ABEIS teaching content.

Declaration names in this file are validated against the generated inventory by
``website/scripts/build_site.py``.  The prose may explain a broader route, but it
must never upgrade that route beyond the status carried here.
"""

from __future__ import annotations


STATUS_ORDER = (
    "Compiled",
    "Partial route",
    "Stated, proof incomplete",
    "Experimental",
    "Planned",
    "Blocked",
)


def result(
    declaration: str,
    title: str,
    plain: str,
    math: str,
    intuition: str,
    why: str,
    dependencies: list[str],
    proof_idea: str,
    correspondence: list[tuple[str, str]],
    local_status: str,
    route_status: str,
    missing: str = "None for this local declaration.",
) -> dict[str, object]:
    return {
        "declaration": declaration,
        "title": title,
        "plain": plain,
        "math": math,
        "intuition": intuition,
        "why": why,
        "dependencies": dependencies,
        "proof_idea": proof_idea,
        "correspondence": correspondence,
        "local_status": local_status,
        "route_status": route_status,
        "missing": missing,
    }


CHAPTERS = [
    {
        "slug": "linear-algebra",
        "number": 1,
        "track": "Shared foundations",
        "title": "Vectors, matrices, and basis states",
        "summary": (
            "Fix the finite matrix model, pointwise equality, dimensions, and "
            "resource records used by every later certificate."
        ),
        "modules": [
            "QuantumBlockEncoding/Core.lean",
            "QuantumBlockEncoding/Resources.lean",
        ],
        "diagram": "module-dependencies",
        "results": [
            result(
                "QuantumBlockEncoding.Matrix.PointwiseEq",
                "Pointwise matrix equality",
                "Two finite matrices are equal when every indexed entry agrees.",
                r"A = B \;\Longleftrightarrow\; \forall i\,j,\; A_{ij}=B_{ij}.",
                "Matrix goals become explicit finite entry goals that Lean can rewrite.",
                "Block extraction and candidate validation are ultimately entrywise claims.",
                ["QuantumBlockEncoding.Matrix"],
                "Expose row and column indices, prove the scalar equality, then recover matrix equality.",
                [
                    ("Choose arbitrary indices.", "intro i j"),
                    ("Reduce the matrix claim to the selected entry.", "apply Matrix.ext"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.Resource",
                "Executable resource records",
                "A candidate carries named resource counts instead of an informal cost label.",
                r"r=(q_{\mathrm{anc}},q_{\mathrm{tot}},d,n_{1q},n_{2q}).",
                "The proof object and the engineering cost can be compared without conflating them.",
                "Candidate search needs deterministic, auditable scoring fields.",
                ["QuantumBlockEncoding.gridSize"],
                "Represent each resource coordinate as data and derive decidable comparison support.",
                [
                    ("Store each cost coordinate.", "structure Resource"),
                    ("Expose values to scoring and export code.", "deriving Repr"),
                ],
                "Compiled",
                "Partial route",
                "Hardware-specific transpilation costs remain outside this generic record.",
            ),
        ],
    },
    {
        "slug": "state-preparation",
        "number": 3,
        "track": "State preparation",
        "title": "The state-preparation problem",
        "summary": (
            "Ask one concrete question: which unitary sends the all-zero basis "
            "state to the normalized state we want?"
        ),
        "modules": [
            "QuantumBlockEncoding/StatePreparation.lean",
            "QuantumBlockEncoding/ConcreteSemantics.lean",
        ],
        "diagram": "state-preparation-flow",
        "results": [
            result(
                "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget",
                "The state-preparation contract",
                "The candidate unitary prepares the target from the zero basis state.",
                r"U\lvert 0^n\rangle=\lvert\psi\rangle.",
                "The target amplitudes are the first column of the unitary matrix.",
                "It gives state preparation its own acceptance test, independent of any later use in block encoding.",
                [
                    "QuantumBlockEncoding.StatePreparationTarget",
                    "QuantumBlockEncoding.StatePreparationCandidate",
                ],
                "Unfold the candidate action on the zero basis vector and compare every amplitude.",
                [
                    ("Select the all-zero input column.", "candidate.unitary row (zeroBasisIndex qubits)"),
                    ("Match it with the requested amplitude.", "= candidate.target.amplitudes row"),
                ],
                "Compiled",
                "Partial route",
                "Only concrete candidates whose unitary and amplitude obligations are supplied complete the broader route.",
            ),
        ],
    },
    {
        "slug": "state-preparation-certificates",
        "number": 4,
        "track": "State preparation",
        "title": "Reading and reusing a preparation certificate",
        "summary": (
            "Connect the ket equation to a matrix column, package the proof, "
            "and reuse exact preparation where an approximate interface is expected."
        ),
        "modules": [
            "QuantumBlockEncoding/StatePreparation.lean",
            "QuantumBlockEncoding/ConcreteSemantics.lean",
        ],
        "diagram": "state-preparation-flow",
        "results": [
            result(
                "QuantumBlockEncoding.ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet",
                "The ket equation is a first-column statement",
                "Matrix action on the all-zero ket selects exactly the first column of the unitary.",
                r"\operatorname{column}_0(U)=\psi\iff U\lvert0^n\rangle=\lvert\psi\rangle.",
                "There are two common ways to say the same fact: physicists write a ket equation, while the finite Lean model compares indexed amplitudes.",
                "This bridge keeps proofs and circuit explanations in the same convention.",
                [
                    "QuantumBlockEncoding.FirstColumnMatches",
                    "QuantumBlockEncoding.ConcreteSemantics.applyVec_zeroKet",
                ],
                "Acting on a basis vector selects one matrix column; function extensionality then turns vector equality into entrywise equality.",
                [
                    ("Apply the matrix to the zero basis ket.", "applyVec_zeroKet"),
                    ("Compare every output amplitude.", "funext / congrFun"),
                ],
                "Compiled",
                "Partial route",
                "A concrete candidate must still provide normalization and unitarity proofs.",
            ),
            result(
                "QuantumBlockEncoding.VerifiedStatePreparation.firstColumn",
                "A verified preparer exposes its amplitudes",
                "Once the certificate is built, downstream proofs can read its first-column identity directly.",
                r"U_{i,0}=\psi_i.",
                "The certificate hides the packaging work but does not weaken the statement.",
                "Prepared amplitudes are often the input to later LCU or oracle constructions.",
                ["QuantumBlockEncoding.VerifiedStatePreparation"],
                "Project the stored preparation proof from the verified record.",
                [
                    ("Read the certified state-action field.", "verified.preparationProof"),
                    ("Expose it through the public theorem.", "verified.firstColumn"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.VerifiedStatePreparation.asZeroErrorApprox",
                "Exact preparation can enter an approximate interface",
                "An exact certificate is also an approximate certificate with error zero.",
                r"\varepsilon=0.",
                "The tolerance ladder can reuse exact work instead of changing certificate formats.",
                "Exact and approximate searches need one stable consumer boundary.",
                ["QuantumBlockEncoding.VerifiedStatePreparation"],
                "Reuse normalization, unitarity, and preparation proofs while setting the approximation field to the exact predicate.",
                [
                    ("Keep the same candidate and proofs.", "verified.candidate / normalizationProof / unitaryProof"),
                    ("Set the error to zero.", "epsilon := 0"),
                ],
                "Compiled",
                "Compiled",
            ),
        ],
    },
    {
        "slug": "circuit-semantics",
        "number": 2,
        "track": "Shared foundations",
        "title": "Gates, unitaries, and circuit meaning",
        "summary": (
            "Separate gate syntax from matrix evaluation and make register order "
            "an explicit part of the semantic boundary."
        ),
        "modules": [
            "QuantumBlockEncoding/Circuit.lean",
            "QuantumBlockEncoding/CircuitSemantics.lean",
            "QuantumBlockEncoding/ConcreteSemantics.lean",
        ],
        "diagram": "certificate-pipeline",
        "results": [
            result(
                "QuantumBlockEncoding.evalGateMatrices",
                "Circuit matrix evaluation",
                "A list of gate matrices is folded into one matrix in the library's declared application order.",
                r"\llbracket[g_1,\ldots,g_m]\rrbracket=G_m\cdots G_1.",
                "The list is executable syntax; its fold is the matrix used by proofs.",
                "Without one order convention, circuit diagrams and matrix products can silently disagree.",
                ["QuantumBlockEncoding.GateMatrix", "QuantumBlockEncoding.Matrix"],
                "Recursively multiply the next gate matrix on the side fixed by the semantics.",
                [
                    ("Empty circuit is identity.", "evalGateMatrices []"),
                    ("Compose the next gate.", "evalGateMatrices (g :: gs)"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct",
                "Flat and product-register clean blocks agree",
                "The two ABEIS block-projection views are pointwise equal under the shared register order.",
                r"\Pi_s U\Pi_s^\dagger=\operatorname{cleanBlockProduct}(s,U).",
                "A circuit-semantics proof can be consumed by classic block-encoding arithmetic without index reconstruction.",
                "Register-shape mismatches were a repeated historical failure class.",
                [
                    "QuantumBlockEncoding.signalSystemBlockProjection",
                    "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct",
                ],
                "Both definitions use the same signal-major flattened index, so the pointwise proof is definitional.",
                [
                    ("Fix system row and column.", "intro row col"),
                    ("Unfold the shared index.", "rfl"),
                ],
                "Compiled",
                "Partial route",
                "This representation bridge does not prove candidate unitarity or target equality.",
            ),
            result(
                "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget",
                "Circuit-to-block extraction target",
                "Circuit semantics selects the signal-system block that must match the scaled target operator.",
                r"(\langle0^a\rvert\otimes I)\,U\,(|0^a\rangle\otimes I)=A/\alpha.",
                "Ancillas are fixed to zero on both sides; the remaining indices are the signal system.",
                "It connects an executable gate list to the mathematical block-encoding contract.",
                [
                    "QuantumBlockEncoding.CircuitMatrixSemantics",
                    "QuantumBlockEncoding.signalSystemBlockProjection",
                ],
                "Evaluate the gate list, project the ancilla-zero rows and columns, then compare the signal entries.",
                [
                    ("Evaluate syntax.", "CircuitMatrixSemantics.ofGateMatrices"),
                    ("Extract the selected block.", "signalSystemBlockProjection"),
                ],
                "Compiled",
                "Partial route",
                "A concrete circuit still has to discharge unitarity and the selected-block equality.",
            ),
        ],
    },
    {
        "slug": "block-encoding",
        "number": 5,
        "track": "Block encoding",
        "title": "The block-encoding contract",
        "summary": (
            "State the block contract with normalization, explicit register "
            "layout, and a verifier-facing certificate record."
        ),
        "modules": ["QuantumBlockEncoding/BlockEncoding.lean"],
        "diagram": "block-encoding-flow",
        "results": [
            result(
                "QuantumBlockEncoding.OperatorBlockEncodingCandidate.cost",
                "Candidate cost is derived from its layout",
                "The block-encoding candidate exposes a deterministic cost tuple from its declared registers and circuit resources.",
                r"c(U)=(a,q,d,n_{1q},n_{2q},\ldots).",
                "A candidate is not accepted only because its matrix works; alternatives remain rankable.",
                "The search layer needs a stable objective before proof attempts consume more budget.",
                [
                    "QuantumBlockEncoding.OperatorBlockEncodingCandidate",
                    "QuantumBlockEncoding.RegisterLayout",
                    "QuantumBlockEncoding.BlockEncodingCost",
                ],
                "Read the layout and circuit fields and assemble the canonical cost record.",
                [
                    ("Read ancillary and signal sizes.", "candidate.layout"),
                    ("Build the score tuple.", "candidate.cost"),
                ],
                "Compiled",
                "Partial route",
                "Backend-specific routing and noise costs are separate executable exports.",
            ),
            result(
                "QuantumBlockEncoding.VerifiedOperatorBlockEncoding.asZeroErrorApprox",
                "Exact certificates are zero-error approximate certificates",
                "Every exact verified block encoding can be reused where an approximation with epsilon zero is expected.",
                r"\left\|A-\alpha\Pi U\Pi^\dagger\right\|=0.",
                "Exactness is the strongest point on the tolerance ladder.",
                "The harness can begin exact and relax epsilon without changing the consumer interface.",
                [
                    "QuantumBlockEncoding.VerifiedOperatorBlockEncoding",
                    "QuantumBlockEncoding.QueryOperatorTarget",
                ],
                "Rewrite with the exact block identity; the residual is the zero matrix.",
                [
                    ("Use the stored exact equality.", "verified.correct"),
                    ("Package error zero.", "verified.asZeroErrorApprox"),
                ],
                "Compiled",
                "Compiled",
            ),
        ],
    },
    {
        "slug": "classic-routes",
        "number": 6,
        "track": "Block encoding",
        "title": "Construction routes and composition rules",
        "summary": (
            "Reuse permutation, one-sparse, LCU, product, dilation, and QSVT "
            "interfaces instead of rediscovering each route per benchmark."
        ),
        "modules": ["QuantumBlockEncoding/BlockEncodingClassics.lean"],
        "diagram": "module-dependencies",
        "results": [
            result(
                "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate",
                "Partial-permutation certificate",
                "A finite partial permutation satisfying the declared support conditions yields an exact clean block.",
                r"A_{ij}\in\{0,1\},\quad \text{at most one supported entry per routed index}.",
                "The circuit route becomes finite index routing rather than dense matrix algebra.",
                "BE Case 1 can reuse this route and avoid an unconstrained circuit search.",
                ["QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock"],
                "Construct the routed unitary and prove the clean ancilla block entry by entry.",
                [
                    ("Establish the finite routing conditions.", "partialPermutationCertificate"),
                    ("Read the clean block theorem.", "ExactCleanBlock.clean_eq_target"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate",
                "Product closure for exact clean blocks",
                "Compatible exact clean-block certificates compose into a certificate for the matrix product.",
                r"\operatorname{block}(U_B U_A)=BA.",
                "Certified components can be recombined as a proof-producing population operation.",
                "It is the formal counterpart of crossing over reusable constructions.",
                [
                    "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock",
                    "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise",
                ],
                "Expand the projected product, use both component block identities, and reassociate finite sums.",
                [
                    ("Substitute component clean blocks.", "ExactCleanBlock.clean_eq_target"),
                    ("Identify the matrix product.", "matrix_mul_congr_pointwise"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract",
                "QSVT consumer boundary",
                "The library records what a later QSVT stage may assume from a supplied block encoding.",
                r"U_A\leadsto p^{(\mathrm{SV})}(A/\alpha).",
                "QSVT is kept as an explicit consumer contract rather than treated as a proved end-to-end implementation.",
                "The hinted hard route can stop rediscovering the interface between a diagonal oracle and QSVT.",
                ["QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract"],
                "Package the exact preconditions and expected transformed-operator relation as a typed boundary.",
                [
                    ("Provide a source block encoding.", "QSVTConsumerContract.source"),
                    ("State the consumer obligation.", "QSVTConsumerContract"),
                ],
                "Compiled",
                "Partial route",
                "A concrete QSVT sequence and its polynomial approximation proof remain route-specific.",
            ),
        ],
    },
    {
        "slug": "certified-cases",
        "number": 7,
        "track": "Block encoding",
        "title": "Certified block-encoding cases",
        "summary": (
            "Distinguish completed local certificates from paper-facing contract "
            "models and historical experiments."
        ),
        "modules": [
            "QuantumBlockEncoding/ColdStartTransferE1.lean",
            "QuantumBlockEncoding/OptimalControl.lean",
            "QuantumBlockEncoding/CubicStatePreparation.lean",
            "QuantumBlockEncoding/GHL2025.lean",
            "QuantumBlockEncoding/Examples/RobinHeat.lean",
            "QuantumBlockEncoding/RobinMatrix.lean",
        ],
        "diagram": "roadmap",
        "results": [
            result(
                "QuantumBlockEncoding.coldE1Candidate_blockProjection",
                "BE Case 1 block projection",
                "The selected transfer-operator candidate has the required projected block.",
                r"\Pi U_{\mathrm{E1}}\Pi^\dagger=A_{\mathrm{E1}}/\alpha.",
                "The benchmark closes from a concrete candidate to the exact block identity.",
                "It is a compact reproducible example of the complete ABEIS acceptance path.",
                [
                    "QuantumBlockEncoding.coldE1CandidateImage_permutation_certificate",
                    "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate",
                ],
                "Reuse the partial-permutation image certificate and simplify the selected entries.",
                [
                    ("Certify routed basis images.", "coldE1CandidateImage_permutation_certificate"),
                    ("Project the clean block.", "coldE1Candidate_blockProjection"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete",
                "BE Case 2 exact Householder completion",
                "The cubic diagonal benchmark has a completed exact block-encoding contract through the rational Householder route.",
                r"\Pi U_{\mathrm{cubic}}\Pi^\dagger=D_{\mathrm{cubic}}/\alpha.",
                "The hard benchmark converges by selecting a library-supported algebraic route, not by expanding a large gate fold.",
                "It records a completed alternative to the still-partial amplitude-oracle/QSVT route.",
                [
                    "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_complete",
                    "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_backendSupport",
                ],
                "Complete the input Householder certificate, instantiate rational backend support, and package the cubic target identity.",
                [
                    ("Complete the linear input block.", "linearDiagonalHouseholderInputBEContract_complete"),
                    ("Supply rational backend support.", "cubicDiagonalRationalCompletion_backendSupport"),
                    ("Assemble the final certificate.", "cubicDiagonalHouseholderExactBEContract_complete"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3",
                "Historical Robin raw-fold obstruction",
                "The historical module states a finite seven-gate coefficient equality but leaves its proof open.",
                r"U_{00}=\sum_{s=0}^{6} B_s.",
                "The statement compares structurally different deep coefficient expressions and is a diagnostic route.",
                "It must remain visible so readers do not confuse paper-model coverage with a completed backend fold.",
                ["QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3"],
                "A successful route would bridge evaluated gate-list semantics to the explicit product before proving the finite projection sum.",
                [
                    ("Normalize the seven-gate product.", "evalGateMatrices"),
                    ("Prove the projection sum.", "oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3"),
                ],
                "Stated, proof incomplete",
                "Blocked",
                "The raw finite projection theorem is open; the default library uses a source-correct prepared route instead.",
            ),
        ],
    },
    {
        "slug": "resources-and-exports",
        "number": 8,
        "track": "System and evidence",
        "title": "Candidate comparison and executable exports",
        "summary": (
            "Keep formal validity lexicographically ahead of resource quality, "
            "then expose accepted candidates to executable tooling."
        ),
        "modules": [
            "QuantumBlockEncoding/Resources.lean",
            "QuantumBlockEncoding/BlockEncoding.lean",
            "QuantumBlockEncoding/Automation.lean",
        ],
        "diagram": "candidate-lifecycle",
        "results": [
            result(
                "QuantumBlockEncoding.BlockEncodingCost.betterThan",
                "Lexicographic candidate comparison",
                "Two candidate costs are compared by a fixed, explicit priority order.",
                r"c_1\prec_{\mathrm{lex}}c_2.",
                "A smaller later metric never compensates for failing an earlier acceptance priority.",
                "Population maintenance and promotion must be reproducible across runs.",
                ["QuantumBlockEncoding.BlockEncodingCost"],
                "Compare the first differing coordinate in the declared score tuple.",
                [
                    ("Build both score records.", "BlockEncodingCost"),
                    ("Apply the fixed ordering.", "BlockEncodingCost.betterThan"),
                ],
                "Compiled",
                "Compiled",
            ),
            result(
                "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_costTuple_eq",
                "A candidate has an auditable cost tuple",
                "The primitive amplitude-oracle proposal's resource tuple is computed exactly.",
                r"c(U_{\mathrm{amp}})=(1,1,1,1).",
                "The cost result is real, while the candidate's semantic oracle assumption remains conditional.",
                "It demonstrates why local declaration completion and broader route completion need separate badges.",
                ["QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate"],
                "Unfold the candidate and its resource record; normalize each tuple coordinate.",
                [
                    ("Unfold candidate resources.", "primitiveAmplitudeOracleCandidate"),
                    ("Reduce the tuple.", "primitiveAmplitudeOracleCandidate_costTuple_eq"),
                ],
                "Compiled",
                "Partial route",
                "The expanded amplitude-oracle semantic contract is not discharged by this cost theorem.",
            ),
        ],
    },
    {
        "slug": "automation-and-roadmap",
        "number": 9,
        "track": "System and evidence",
        "title": "Search control, evidence, and open work",
        "summary": (
            "Show how typed stages, agent layers, candidate populations, proof "
            "gates, and explicit open problems coordinate without overstating evidence."
        ),
        "modules": [
            "QuantumBlockEncoding/Automation.lean",
            "QuantumBlockEncoding/Literature.lean",
            "QuantumBlockEncoding/OpenProblems.lean",
        ],
        "diagram": "candidate-lifecycle",
        "results": [
            result(
                "QuantumBlockEncoding.threeLayerAgentContracts",
                "Three-layer agent contracts",
                "The harness records distinct responsibilities for planning, population maintenance, and focused proof work.",
                r"\text{planner}\rightarrow\text{maintainer}\rightarrow\text{worker}.",
                "Escalation changes exploration or decomposition only after structured feedback.",
                "Hard tasks need explicit ownership and bounded experiments instead of repeated untracked prompts.",
                ["QuantumBlockEncoding.AutomationStage", "QuantumBlockEncoding.AutomationTask"],
                "Encode each layer's inputs, outputs, and promotion conditions as inspectable data.",
                [
                    ("Declare stage and task types.", "AutomationStage / AutomationTask"),
                    ("Instantiate layer contracts.", "threeLayerAgentContracts"),
                ],
                "Compiled",
                "Partial route",
                "The declarations specify controller policy; external Codex execution remains an engineering system.",
            ),
            result(
                "QuantumBlockEncoding.openProblems",
                "Open problems are first-class data",
                "Unfinished mathematical or engineering routes are listed explicitly with status and evidence requirements.",
                r"\mathcal O=[o_1,\ldots,o_k].",
                "A planned result cannot be mistaken for a theorem merely because it appears near compiled code.",
                "The roadmap and harness both need a common, auditable backlog.",
                ["QuantumBlockEncoding.OpenProblem"],
                "Construct a finite list of typed open-problem records.",
                [
                    ("Describe each obligation.", "OpenProblem"),
                    ("Publish the current list.", "openProblems"),
                ],
                "Compiled",
                "Planned",
                "Each listed problem carries its own missing proof or implementation steps.",
            ),
        ],
    },
]

CHAPTERS.sort(key=lambda chapter: int(chapter["number"]))


IMPLEMENTATION_MAP = [
    {
        "goal": "Prepare a finite target state",
        "contract": r"U|0^n\rangle=|\psi\rangle",
        "obligation": "Unitary candidate and first-column equality",
        "declaration": "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget",
        "dependencies": "StatePreparationTarget; StatePreparationCandidate",
        "status": "Partial route",
        "missing": "Instantiate and certify each concrete target family",
        "chapter": "state-preparation",
    },
    {
        "goal": "Consume a verified prepared state",
        "contract": r"U_{i0}=\psi_i",
        "obligation": "First-column projection",
        "declaration": "QuantumBlockEncoding.VerifiedStatePreparation.firstColumn",
        "dependencies": "VerifiedStatePreparation",
        "status": "Compiled",
        "missing": "None locally",
        "chapter": "state-preparation-certificates",
    },
    {
        "goal": "Read first-column evidence as state action",
        "contract": r"\operatorname{column}_0(U)=\psi\iff U|0^n\rangle=|\psi\rangle",
        "obligation": "Finite basis-ket matrix-action bridge",
        "declaration": "QuantumBlockEncoding.ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet",
        "dependencies": "FirstColumnMatches; applyVec_zeroKet",
        "status": "Compiled",
        "missing": "Candidate normalization and unitarity remain separate",
        "chapter": "state-preparation-certificates",
    },
    {
        "goal": "Evaluate a gate list",
        "contract": r"\llbracket C\rrbracket=G_m\cdots G_1",
        "obligation": "Fixed fold and register order",
        "declaration": "QuantumBlockEncoding.evalGateMatrices",
        "dependencies": "GateMatrix; Matrix",
        "status": "Compiled",
        "missing": "None locally",
        "chapter": "circuit-semantics",
    },
    {
        "goal": "Extract a block from a circuit",
        "contract": r"\Pi U\Pi^\dagger=A/\alpha",
        "obligation": "Ancilla-zero projection equality",
        "declaration": "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget",
        "dependencies": "CircuitMatrixSemantics; signalSystemBlockProjection",
        "status": "Partial route",
        "missing": "Concrete circuit unitarity and entry proof",
        "chapter": "circuit-semantics",
    },
    {
        "goal": "Move between flat and product-register block views",
        "contract": r"\Pi_s U\Pi_s^\dagger=\operatorname{cleanBlockProduct}(s,U)",
        "obligation": "Shared register-order projection equality",
        "declaration": "QuantumBlockEncoding.ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct",
        "dependencies": "signalSystemBlockProjection; cleanBlockProduct",
        "status": "Compiled",
        "missing": "Candidate-level block and unitarity proofs remain separate",
        "chapter": "circuit-semantics",
    },
    {
        "goal": "Package an exact block encoding",
        "contract": r"\Pi U\Pi^\dagger=A/\alpha",
        "obligation": "Candidate validity and exact block identity",
        "declaration": "QuantumBlockEncoding.VerifiedOperatorBlockEncoding",
        "dependencies": "QueryOperatorTarget; OperatorBlockEncodingCandidate",
        "status": "Partial route",
        "missing": "Concrete candidate fields vary by route",
        "chapter": "block-encoding",
    },
    {
        "goal": "Reuse an exact certificate approximately",
        "contract": r"\|A-\alpha\Pi U\Pi^\dagger\|=0",
        "obligation": "Zero-error conversion",
        "declaration": "QuantumBlockEncoding.VerifiedOperatorBlockEncoding.asZeroErrorApprox",
        "dependencies": "VerifiedOperatorBlockEncoding",
        "status": "Compiled",
        "missing": "Positive-error analyses are route-specific",
        "chapter": "block-encoding",
    },
    {
        "goal": "Certify a partial permutation",
        "contract": r"\operatorname{block}(U)=A",
        "obligation": "Finite routed-entry proof",
        "declaration": "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate",
        "dependencies": "ExactCleanBlock",
        "status": "Compiled",
        "missing": "None locally",
        "chapter": "classic-routes",
    },
    {
        "goal": "Compose exact block encodings",
        "contract": r"\operatorname{block}(U_BU_A)=BA",
        "obligation": "Projected product equality",
        "declaration": "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate",
        "dependencies": "ExactCleanBlock; matrix_mul_congr_pointwise",
        "status": "Compiled",
        "missing": "Register compatibility for each application",
        "chapter": "classic-routes",
    },
    {
        "goal": "Close BE Case 1",
        "contract": r"\Pi U_{\mathrm{E1}}\Pi^\dagger=A_{\mathrm{E1}}/\alpha",
        "obligation": "Transfer-operator projection",
        "declaration": "QuantumBlockEncoding.coldE1Candidate_blockProjection",
        "dependencies": "coldE1CandidateImage_permutation_certificate",
        "status": "Compiled",
        "missing": "None locally",
        "chapter": "certified-cases",
    },
    {
        "goal": "Close BE Case 2",
        "contract": r"\Pi U_{\mathrm{cubic}}\Pi^\dagger=D/\alpha",
        "obligation": "Exact rational Householder completion",
        "declaration": "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete",
        "dependencies": "Householder input; rational backend support",
        "status": "Compiled",
        "missing": "None for the selected exact route",
        "chapter": "certified-cases",
    },
    {
        "goal": "Feed a diagonal encoding to QSVT",
        "contract": r"U_D\leadsto p^{(\mathrm{SV})}(D/\alpha)",
        "obligation": "Concrete QSVT sequence and polynomial error",
        "declaration": "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract",
        "dependencies": "Source block encoding; polynomial conditions",
        "status": "Partial route",
        "missing": "Consumer implementation and approximation proof",
        "chapter": "classic-routes",
    },
    {
        "goal": "Repair historical Robin raw fold",
        "contract": r"U_{00}=\sum_s B_s",
        "obligation": "Seven-gate semantic bridge and finite projection sum",
        "declaration": "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3",
        "dependencies": "Historical RobinMatrix module",
        "status": "Blocked",
        "missing": "Two explicit proof holes remain outside the default import",
        "chapter": "certified-cases",
    },
]


ROADMAP = [
    ("State-preparation contracts and first-column consumer", "Compiled"),
    ("Circuit syntax to matrix semantics", "Compiled"),
    ("Reusable exact block-encoding routes", "Compiled"),
    ("BE Case 1 transfer-operator certificate", "Compiled"),
    ("BE Case 2 exact Householder certificate", "Compiled"),
    ("Primitive amplitude-oracle cost record", "Partial route"),
    ("Concrete QSVT polynomial realization", "Planned"),
    ("Paper-wide Robin backend reproduction", "Experimental"),
    ("Historical seven-gate raw-fold diagnostics", "Blocked"),
]


WORKFLOW_STAGES = [
    (
        "1. Formal target",
        "Translate the mathematical request into a state-preparation or block-projection contract.",
    ),
    (
        "2. Memory retrieval",
        "Retrieve compatible completed declarations, route cards, and known obstructions.",
    ),
    (
        "3. Candidate population",
        "Generate distinct constructions and retain provenance, assumptions, and resource tuples.",
    ),
    (
        "4. Resource ranking",
        "Apply the declared lexicographic score without promoting an invalid candidate.",
    ),
    (
        "5. Lean obligations",
        "Split unitarity, dimensions, register order, projection, normalization, and approximation goals.",
    ),
    (
        "6. Adaptive exploration",
        "The upper layer may add agents, recombine routes, or relax epsilon only from recorded feedback.",
    ),
    (
        "7. Acceptance gate",
        "Require the Lean build, tests, no-new-proof-hole policy, and source-linked documentation.",
    ),
    (
        "8. Executable validation",
        "Run applicable circuit or matrix exports, including Qiskit checks, after the formal certificate gate.",
    ),
]
