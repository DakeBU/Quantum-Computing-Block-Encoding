# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-10 01:35:20`
- Mode: `faithfulPaper`
- Stage: Stage 2 DAG proof discharge, with faithful transcript checks still active
- Latest cycle: `20260610-013140-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- Latest handoff indicates at least one assigned lower target was already compiled; upper/middle should retire stale directives before more proof search.
- 1. Keep the conversion window and proof-obligation ledger synchronized with the branch-sum proof-DAG. Retire stale lower targets explicitly.
- 2. Generate the Chinese human audit page at:
- 3. Update the project article bridge after the batch. The generated status must be mirrored into:
- 4. The public ABEIS report must be readable by the original paper authors and by non-agent-system readers. Use citations, theorem/equation/figure names, and prose descriptions. Do not write local source line anchors such as `main.tex:1098-1164` in the publi...
- - Reject any cycle that changes the target theorem, adds assumptions, changes the normalizer, or treats a cited oracle primitive as proved without a named Lean theorem and source/citation row.
- - Reject any cycle that works on raw symbolic `Coeff` matrix equality as the main route instead of the `Coeff.evalWith`/branch-sum semantic route.
- - Reject any claim that the first-case-study one-term block-encoding theorem is complete while the theorem-facing root or any corresponding `sorry` remains.
- - Confirm that `python3 tools/qbe.py check`, `lake build`, and `lake build Tests` pass after Lean edits.
- - Confirm that the Chinese summary path above and the ABEIS generated appendix are updated. The Chinese summary may cite local TeX line ranges; the public article must not.

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

- `lower`: 860
- `middle`: 703
- `reviewer`: 618
- `upper`: 1163

## Trial Counts By Status

- `accepted`: 1243
- `blocked`: 9
- `compiled`: 416
- `failed`: 8
- `queued`: 1668

## Local Paper Sources

- `GHL2025` found: `outer_papers/quantum/GHL2025/main.tex`

## Recent Lean Declarations

- `def oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18897`
- `def oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:18914`
- `def oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19009`
- `def oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19142`
- `theorem oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19221`
- `structure OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:19241`
- `def oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19287`
- `structure OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` at `QuantumBlockEncoding/RobinMatrix.lean:19515`
- `def oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19558`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:19980`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:20798`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:20830`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21657`
- `theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21687`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` at `QuantumBlockEncoding/RobinMatrix.lean:21700`
- `theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21718`
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

- `.agents/skills/qbe-project-paper-update/`
- `MANIFEST.md`
- `QuantumBlockEncoding/GHL2025.lean`
- `QuantumBlockEncoding/RobinMatrix.lean`
- `conversion-windows/QBE-AUTO-002.md`
- `docs/agent_orchestration.md`
- `paper-notes/GHL2025/latex/sections/00_status.tex`
- `paper-notes/GHL2025/markdown/00_status.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-134517-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-141421-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-143630-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-145602-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-151734-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-154329-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-161309-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-163249-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-170218-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-172319-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-175111-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-181857-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260609-183946-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/latest.md`
- `paper-notes/project-paper/README.md`
- `paper-notes/project-paper/cycle-updates/`
- `proof-attempts/QBE-AUTO-002/active-eval-support-partition-proof-dag-20260609-1718-lower1.md`
- `proof-attempts/QBE-AUTO-002/active-prepared-eval-iff-evaluated-fold-20260609-lower2.md`
- `proof-attempts/QBE-AUTO-002/active-seven-gate-prepared-mismatch-20260609-lower2.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-of-active-prepared-entry-20260609-lower2.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-raw-sandwich-middle-packet-20260609-180111.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-to-evaluated-fold-20260609-lower2.md`
- `proof-attempts/QBE-AUTO-002/eval-entry-expanded-slot0-fold-20260609-lower2.md`
- `proof-attempts/QBE-AUTO-002/eval-gate-matrices-entry-middle-packet-20260609-164304.md`
- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-middle-packet-20260609-161309.md`
- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-route-dag-20260609-lower1.md`
- `proof-attempts/QBE-AUTO-002/fig4-source-proof-dag-20260609-lower1.md`
- `proof-attempts/QBE-AUTO-002/finite-active-prepared-composition-dag-20260609-lower1.md`
- `proof-attempts/QBE-AUTO-002/finite-active-prepared-composition-middle-packet-20260609-154329.md`
- `proof-attempts/QBE-AUTO-002/prepared-entry-lhs-repair-20260609-lower2.md`
- `proof-attempts/QBE-AUTO-002/prepared-entry-lower2-packet-20260609-151734-middle.md`
- `proof-attempts/QBE-AUTO-002/prepared-projection-entry-dag-20260609-151734-lower1.md`

## Controls

- ASTIS-style compact context/status artifacts for long runs
- LeanMarathon-style durable proof blueprint and dynamic leaf queue
- LBG-style trial memory and reviewer feedback compression
- EoH-style candidate/proof-attempt populations only where QBE mode permits them

## Next-Cycle Rule

- Upper must choose one dynamic leaf or one refiner illness area before lower work.
- Middle must map the selected paper proof fragment to Lean declarations or explicit obligations.
- With two lower agents, lower 1 writes the natural-language DAG proof packet and lower 2 proves one ready Lean leaf.
- Lower must edit only the assigned local target and run `python3 tools/qbe.py check` after Lean edits.
- Reviewer accepts progress only when the Lean gate and the Markdown/LaTeX correspondence are synchronized.
