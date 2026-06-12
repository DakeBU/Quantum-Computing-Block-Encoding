# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-11 23:32:00`
- Mode: `faithfulPaper`
- Stage: Stage 2 DAG proof discharge, with faithful transcript checks still active
- Latest cycle: `20260611-232725-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- active_prepared_composition_leaf: active seven-gate `[0,0]` evaluated entry equals the prepared sparse clean-clean entry; status: active equivalent leaf; not proved; Lean: exact unwrapped equality in `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`
- source_prepared_entry_leaf: theorem-facing source-prepared active field follows after the active equivalent leaf; status: open dependent target; Lean: `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`
- unitary_fold_leaf: `FullUnitaryFold`: raw signal-zero unitary entry equals backend branch fold; status: open dependent root; Lean: `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`
- backend_expansion_leaf: backend-expansion statement for the branch-contribution target; status: open equivalent endpoint; Lean: `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
- evaluated_backend_fold_leaf: evaluated signal-zero entry equals `blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; status: active equivalent leaf; not proved; Lean: `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`
- post_feeder_sparse_clean_to_fold_bridge: sparse-clean equality is equivalent to the evaluated backend fold under `hUniform`; status: compiled bridge; retired; Lean: `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`

## Open Obligation Signals

- post-feeder sparse-clean to fold bridge: Lean `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`; class QBE-local evalWith bridge under external clean-column contract; status compiled bridge; retired as lower target
- active/prepared sparse-clean equality: Lean displayed `Coeff.evalWith` equality above; class QBE-local finite matrix semantics; status active Lean leaf; not proved
- evaluated backend fold: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; class QBE-local finite projection/backend theorem; status active equivalent leaf; not proved
- source-prepared projection active field: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`; class QBE-local theorem-facing projection bridge; status open dependent target
- full signal-zero unitary fold: Lean `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; class QBE-local finite projection/backend theorem; status open dependent root
- theorem-facing Fig. 4 transcript: Lean `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; class GHL-internal transcript plus QBE-local indicator bridge; status compiled guard; no full semantic proof
- external sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract; status contract-only; no Shukla--Vedula formalization in this packet
- diagnostic raw constructor route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class diagnostic/backlog; status still `sorry`-guarded; do not assign as source closure

## Trial Counts By Role

- `lower`: 971
- `middle`: 759
- `reviewer`: 668
- `upper`: 1295

## Trial Counts By Status

- `accepted`: 1350
- `blocked`: 9
- `compiled`: 472
- `failed`: 37
- `queued`: 1825

## Local Paper Sources

- `GHL2025` found: `outer_papers/quantum/GHL2025/main.tex`

## Recent Lean Declarations

- `def oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21115`
- `def oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21132`
- `def oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21227`
- `def oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21360`
- `theorem oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21465`
- `structure OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:21485`
- `def oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21531`
- `structure OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` at `QuantumBlockEncoding/RobinMatrix.lean:21759`
- `def oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21802`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:22332`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:23297`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23329`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24156`
- `theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24186`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` at `QuantumBlockEncoding/RobinMatrix.lean:24199`
- `theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24217`
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

- `MANIFEST.md`
- `QuantumBlockEncoding/RobinMatrix.lean`
- `conversion-windows/QBE-AUTO-002.md`
- `paper-notes/GHL2025/latex/sections/00_status.tex`
- `paper-notes/GHL2025/markdown/00_status.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-191349-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-193425-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-195209-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-201223-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-203233-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-211850-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-214323-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-220058-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-222311-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-224727-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-230354-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260611-232725-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/latest.md`
- `paper-notes/project-paper/cycle-updates/20260611-191349-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-191349-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-193425-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-193425-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-195209-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-195209-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-201223-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-201223-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-203233-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-203233-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-211850-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-211850-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-214323-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-214323-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-220058-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-220058-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-222311-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-222311-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-224727-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-224727-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260611-230354-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260611-230354-QBE-AUTO-002-cycle01.tex`

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
