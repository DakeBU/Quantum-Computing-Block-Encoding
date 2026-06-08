# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-07 21:06:16`
- Mode: `faithfulPaper`
- Stage: Stage 2 DAG proof discharge, with faithful transcript checks still active
- Latest cycle: `20260607-155230-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- - lower 1 is the natural-language proof architect. It should translate the GHL source proof and the current Lean DAG into a dependency-ordered proof plan, naming existing declarations and the smallest new intermediate lemma.
- - lower 2 is the Lean implementation worker. It should implement that smallest theorem/lemma, run `python3 tools/qbe.py check`, and record useful failed routes under `proof-attempts/`.
- 1. Reduce the active/prepared statement to the uncast form using the compiled equivalence.
- 2. Compare the raw active seven-gate selected entry with the prepared sandwich clean entry under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
- 3. Reuse the prepared clean-entry backend bridge already compiled in `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
- 4. If direct HWKappa use is blocked, use the column-0 support lemmas as a fallback, but do not restart the frozen H-free raw fold as the main route.
- - Do not prove `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as a standalone H-free theorem this batch; it is diagnostic/backlog unless routed through the prepared projection target.
- - Do not recursively formalize Shukla--Vedula, LCU, or block-composition.
- - Do not add assumptions, replace the paper circuit, or promote semantic flags.
- - Do not spend the cycle on project-paper polish or broad library refactors.

## Open Obligation Signals

- # Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend
- This ledger tracks the unproved semantic claims introduced by the circuit
- the remaining five gate unitarity claims remain explicit proof obligations.
- | Gate | Lean declaration | Paper source | Status |
- | O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | Lemma 3, Eq. (20), arXiv:2506.20478 | active controlled-rotation skeleton; coefficient-normalizer relation and unitarity unproved |
- | Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478 | active symbolic controlled rotation matrix; angle-normalizer contract and unitarity unproved |
- | O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | Lemma 1, arXiv:2506.20478 | active global sparse-slot paper-image matrix skeleton; `bandedSparseAccessPaperGlobalSlotSource` now records the faithful clean source predicate as padded clean input plus sparse index $s<\kappa$; finite-image, entry-safety, finite-range cleanup wrapper, global-source image injectivity, post-SWAP unique preimage, and record-level inverse bridge proved under explicit hypotheses; `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` proves the corrected active image separates the old $n=3$ boundary columns, while `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` is retained as a rejected row-dependent-model regression; forward correctness, semantic cleanup, obligation-record flag promotion, and unitarity unproved |
- | O_f | `GHL2025.oneTermRobinGate_O_f` | Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, and Fig. 1-term Robin, arXiv:2506.20478 | active paper-image matrix skeleton with clean $m_f$ branch wired; orthogonal completion, amplitude relation, normalizer bound, and unitarity unproved |
- | (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | Fig. 1-term Robin caption, arXiv:2506.20478 | active transpose-style paper-image matrix; conditional entry and register-cleanup witness available for the global-source candidate, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` identifies that candidate among active global-source preimages; semantic cleanup and unitarity unproved |
- The source audit points to a different faithful target:
- Therefore the active obligation is not to invent an unused-branch image for a
- row-dependent source domain.  The Lean `O_D^BS` address layer now uses a global
- | `odbs_global_source_domain` | implemented `bandedSparseAccessPaperGlobalSlotSource` as clean padded input plus sparse index $s<\kappa$; old columns `0` and `48` are both active global sources | do not use `bandedSparseAccessPaperValidCleanSource` to delete zero-amplitude boundary slots |
- | `odbs_rejected_model_memory` | added `bandedSparseAccessRowDependentPaperAddress` and `bandedSparseAccessRowDependentPaperImage`; kept the old collision witness as rejected-model memory | do not present the old witness as a paper-level source gap |
- | Obligation | Declaration | Status |
- | Obligation | Declaration | Status |
- | Block projection extracts correct submatrix | `oneTermRobinBlockExtractionTarget.blockProjection` | unproved |
- | Extracted block = targetMatrix / normalizer | `oneTermRobinBlockExtractionTarget.blockCorrect` | unproved |
- | Obligation | Declaration | Status |
- | Block correctness for Robin | `blockCorrect` field | unproved |

## Trial Counts By Role

- `lower`: 811
- `middle`: 676
- `reviewer`: 600
- `upper`: 1112

## Trial Counts By Status

- `accepted`: 1191
- `blocked`: 8
- `compiled`: 400
- `failed`: 5
- `queued`: 1595

## Local Paper Sources

- `GHL2025` found: `outer_papers/quantum/GHL2025/main.tex`

## Recent Lean Declarations

- `def oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18527`
- `def oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18544`
- `def oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18639`
- `def oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18772`
- `theorem oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18851`
- `structure OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:18871`
- `def oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18917`
- `structure OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` at `QuantumBlockEncoding/RobinMatrix.lean:19122`
- `def oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19165`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19551`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:20301`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:20333`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` at `QuantumBlockEncoding/RobinMatrix.lean:20988`
- `theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21018`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` at `QuantumBlockEncoding/RobinMatrix.lean:21031`
- `theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21049`
- `def gateMatricesMatchCircuit` at `QuantumBlockEncoding/CircuitSemantics.lean:41`
- `structure CircuitMatrixSemantics` at `QuantumBlockEncoding/CircuitSemantics.lean:404`
- `structure PreparedCircuitEntryTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:436`
- `structure BlockExtractionTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:502`
- `structure BlockExtractionBranchContributionTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:535`
- `structure CircuitBlockEncodingClaim` at `QuantumBlockEncoding/CircuitSemantics.lean:661`
- `structure FiniteBlockCompositionContract` at `QuantumBlockEncoding/CircuitSemantics.lean:676`
- `def signalSystemBlockRowIndex` at `QuantumBlockEncoding/CircuitSemantics.lean:696`
- `def signalSystemBlockColIndex` at `QuantumBlockEncoding/CircuitSemantics.lean:700`
- `theorem signalSystemBlockRowIndex_lt` at `QuantumBlockEncoding/CircuitSemantics.lean:712`
- `theorem signalSystemBlockColIndex_lt` at `QuantumBlockEncoding/CircuitSemantics.lean:727`
- `def signalSystemBlockProjection` at `QuantumBlockEncoding/CircuitSemantics.lean:753`
- `def totalCircuitQubits` at `QuantumBlockEncoding/CircuitSemantics.lean:778`
- `def CircuitMatrixSemantics.blockExtractionTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:786`

## Current Dirty Files

- `.agents/skills/qbe-cited-results/SKILL.md`
- `.agents/skills/qbe-source-dependency-audit/SKILL.md`
- `MANIFEST.md`
- `QuantumBlockEncoding/CircuitSemantics.lean`
- `QuantumBlockEncoding/RobinMatrix.lean`
- `README.md`
- `conversion-windows/QBE-AUTO-002.md`
- `docs/astis_reference_notes.md`
- `docs/leanmarathon_reference_notes.md`
- `docs/mathcode_reference_notes.md`
- `proof-attempts/QBE-AUTO-002/active-prepared-architect-plan-cycle01-update.md`
- `proof-attempts/QBE-AUTO-002/active-prepared-architect-plan-cycle01.md`
- `proof-attempts/QBE-AUTO-002/column0-two-path-analysis.md`
- `proof-attempts/QBE-AUTO-002/cycle01-two-path-infra.md`
- `proof-attempts/QBE-AUTO-002/matrix-associativity-bridge.md`
- `proof-attempts/QBE-AUTO-002/suffix-row0-plan.md`
- `proof-blueprints/QBE-AUTO-002-status.json`
- `proof-blueprints/QBE-AUTO-002-status.md`
- `proof-blueprints/QBE-AUTO-002.md`
- `proof-obligations/QBE-AUTO-002.md`
- `tasks/QBE-AUTO-002.md`
- `tools/qbe.py`
- `tools/qbe_claude_faithful.sh`
- `tools/qbe_run_theorem_closure.sh`

## Controls

- ASTIS-style compact context/status artifacts for long runs
- LeanMarathon-style durable proof blueprint and dynamic leaf queue
- LBG-style trial memory and reviewer feedback compression
- EoH-style candidate/proof-attempt populations only where QBE mode permits them

## Next-Cycle Rule

- Upper must choose one dynamic leaf or one refiner illness area before lower work.
- Middle must map the selected paper proof fragment to Lean declarations or explicit obligations.
- Lower must edit only the assigned local target and run `python3 tools/qbe.py check` after Lean edits.
- Reviewer accepts progress only when the Lean gate and the Markdown/LaTeX correspondence are synchronized.
