# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-06 01:40:47`
- Mode: `faithfulPaper`
- Stage: Stage 2 DAG proof discharge, with faithful transcript checks still active
- Latest cycle: `20260605-051845-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- Latest handoff indicates at least one assigned lower target was already compiled; upper/middle should retire stale directives before more proof search.
- 1. `H_W^(kappa)` prepares the sparse register as in Eq. `arbitrary sparcity`.
- 2. The Fig. `1 term ROBIN` seven-gate product acts on the prepared sparse register and produces the `gamma_3` coefficient in Eq. `ROBIN clarified`.
- 3. The block-encoding projection from Definition `def:block-encoding` selects the prepared clean output, not the H-free seven-gate active entry by itself.
- - Make the theorem-facing focused block/projection route use the prepared singleton clean entry `(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix oneTermRobinGamma3BoundarySparseCleanIndex_n3 oneTermRobinGamma3BoundarySparseCleanInd...
- - Use the already compiled bridge `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` under the explicit contract `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` to prove the source-correct evaluated backend fold.
- - If possible, route the focused `gamma_3` product-to-coefficient statement through this prepared projection target. If not possible, add only the smallest missing route lemma and keep all theorem-facing flags false.
- - GHL2025 own contribution: the Robin boundary seven-gate construction, `gamma_1`/`gamma_2`/`gamma_3` coefficient bookkeeping, normalizer `N_D * N_f * kappa`, ancilla ledger, and resource count.
- - External contract: Shukla--Vedula uniform superposition gives only the clean-column amplitude shape and `O(log kappa)` cost for `H_W^(kappa)`. Do not recursively formalize it in this batch.
- - External/standard contract: LCU and block-composition are downstream contracts. Do not use them to prove the local prepared projection entry.

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

- `lower`: 799
- `middle`: 665
- `reviewer`: 593
- `upper`: 1095

## Trial Counts By Status

- `accepted`: 1173
- `blocked`: 8
- `compiled`: 395
- `failed`: 5
- `queued`: 1571

## Local Paper Sources

- `GHL2025` found: `outer_papers/GHL2025/main.tex`

## Recent Lean Declarations

- `def oneTermRobinGamma3BoundaryActiveCleanIndex_n3` at `QuantumBlockEncoding/RobinMatrix.lean:17262`
- `def oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:17489`
- `structure OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:17570`
- `def oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:17607`
- `def oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:17939`
- `def oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:17956`
- `def oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18051`
- `def oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18184`
- `theorem oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18263`
- `structure OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:18283`
- `def oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18329`
- `structure OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` at `QuantumBlockEncoding/RobinMatrix.lean:18534`
- `def oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18577`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18963`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:19713`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19745`
- `def gateMatricesMatchCircuit` at `QuantumBlockEncoding/CircuitSemantics.lean:41`
- `structure CircuitMatrixSemantics` at `QuantumBlockEncoding/CircuitSemantics.lean:305`
- `structure PreparedCircuitEntryTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:337`
- `structure BlockExtractionTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:403`
- `structure BlockExtractionBranchContributionTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:436`
- `structure CircuitBlockEncodingClaim` at `QuantumBlockEncoding/CircuitSemantics.lean:562`
- `structure FiniteBlockCompositionContract` at `QuantumBlockEncoding/CircuitSemantics.lean:577`
- `def signalSystemBlockRowIndex` at `QuantumBlockEncoding/CircuitSemantics.lean:597`
- `def signalSystemBlockColIndex` at `QuantumBlockEncoding/CircuitSemantics.lean:601`
- `theorem signalSystemBlockRowIndex_lt` at `QuantumBlockEncoding/CircuitSemantics.lean:613`
- `theorem signalSystemBlockColIndex_lt` at `QuantumBlockEncoding/CircuitSemantics.lean:628`
- `def signalSystemBlockProjection` at `QuantumBlockEncoding/CircuitSemantics.lean:654`
- `def totalCircuitQubits` at `QuantumBlockEncoding/CircuitSemantics.lean:679`
- `def CircuitMatrixSemantics.blockExtractionTarget` at `QuantumBlockEncoding/CircuitSemantics.lean:687`

## Current Dirty Files

- `.agents/skills/qbe-conversion-window/SKILL.md`
- `.agents/skills/qbe-formalize-paper/SKILL.md`
- `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md`
- `.agents/skills/qbe-proof-blueprint/`
- `.agents/skills/qbe-proof-diagnostics/`
- `.agents/skills/qbe-source-dependency-audit/SKILL.md`
- `MANIFEST.md`
- `NOTICE.md`
- `QuantumBlockEncoding/CircuitSemantics.lean`
- `QuantumBlockEncoding/GHL2025.lean`
- `QuantumBlockEncoding/RobinMatrix.lean`
- `README.md`
- `Tests/Basic.lean`
- `conversion-windows/QBE-AUTO-002.md`
- `docs/agent_orchestration.md`
- `docs/attribution.md`
- `docs/automation_deployment.md`
- `docs/leanmarathon_reference_notes.md`
- `docs/mathcode_reference_notes.md`
- `docs/sleep_run_guide.md`
- `paper-notes/GHL2025/latex/sections/00_status.tex`
- `paper-notes/GHL2025/markdown/00_status.md`
- `paper-notes/GHL2025_RobinOneTerm.tex`
- `proof-attempts/QBE-AUTO-002/gamma3-product-to-coefficient.md`
- `proof-blueprints/`
- `proof-obligations/QBE-AUTO-002.md`
- `research-wiki/cited-results/GHL2025.md`
- `tasks/QBE-AUTO-002.md`
- `tools/qbe.py`

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
