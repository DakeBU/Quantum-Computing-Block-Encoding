# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-13 16:47:14`
- Mode: `faithfulPaper`
- Stage: Stage 2 DAG proof discharge, with faithful transcript checks still active
- Latest cycle: `20260613-163714-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- source_prepared_projection_summation_correction: translate Eq. `ROBIN clarified` through prepared sparse-register projection, not the H-free row-0 shortcut; status: active lower1/lower3 leaf; Lean: no new Lean required before lower2
- active_eval_gate_matrices_column0_bridge: prove `ActiveEval(env) = ExplicitSevenGate00(env)` at `evalWith` entry level without using the sorry-guarded raw matrix equality; status: active lower2 leaf; guard only; Lean: proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env`
- source_prepared_sparse_clean_feeder: prove `SourcePreparedField(H, env)` or the equivalent uncast prepared sparse-clean equality under explicit source contract; status: active lower2 leaf after calibration; Lean: `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` feeds the target

## Open Obligation Signals

- strict H-free row-0 to slot-2 feeder: Lean `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env`; class compares different finite paths: active `[0,0]` and selected slot `2`/full index `32`; status retired; `shape_or_register_gap`
- active column-0 tail-kill normal form: Lean `oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3`; class QBE-local explicit seven-gate path support; status proved by lower2; no semantic flag promoted
- active evalGateMatrices column-0 bridge: Lean proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env`; class QBE-local fold/product associativity at `evalWith` entry level; status active lower2 leaf; guard only; open
- source-prepared sparse-clean feeder: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`, or the equivalent uncast prepared sparse-clean comparison from `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env`; class source-shaped active/prepared finite composition theorem under explicit `Uniform(H)` in recovery; status blocked until the active-side guard is interpreted
- evaluated fold recovery: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive`; class compiled route from source-prepared field to evaluated backend fold under `Uniform(H)`; status blocked on source-shaped field
- all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula 2024; status contract-only; keep explicit

## Trial Counts By Role

- `lower`: 1092
- `middle`: 801
- `reviewer`: 690
- `upper`: 1354

## Trial Counts By Status

- `accepted`: 1444
- `blocked`: 34
- `compiled`: 492
- `failed`: 40
- `queued`: 1927

## Local Paper Sources

- `GHL2025` found: `outer_papers/quantum/GHL2025/main.tex`

## Recent Lean Declarations

- `def oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21298`
- `def oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21393`
- `def oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21526`
- `theorem oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21631`
- `structure OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:21651`
- `def oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21697`
- `structure OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` at `QuantumBlockEncoding/RobinMatrix.lean:21925`
- `def oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21968`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:22546`
- `theorem oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` at `QuantumBlockEncoding/RobinMatrix.lean:22727`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:23547`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23579`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24406`
- `theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24436`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` at `QuantumBlockEncoding/RobinMatrix.lean:24449`
- `theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24467`
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
- `README.md`
- `conversion-windows/QBE-AUTO-002.md`
- `docs/pro_prompt_policy.md`
- `paper-notes/project-paper/cycle-updates/20260613-155325-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-155325-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260613-161435-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-161435-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260613-163714-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-163714-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`
- `proof-attempts/QBE-AUTO-002/finite-path-feeder-lower1-dag-20260613-160936.md`
- `proof-attempts/QBE-AUTO-002/finite-path-feeder-lower2-index-split-20260613-155325.md`
- `proof-attempts/QBE-AUTO-002/finite-path-feeder-lower2-tailkill-normalform-20260613-161435.md`
- `proof-attempts/QBE-AUTO-002/finite-path-feeder-lower3-necessary-condition-20260613-160804.md`
- `proof-attempts/QBE-AUTO-002/finite-path-feeder-middle-packet-20260613-1600.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-col0-diagnostic-middle-packet-20260613-163714.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-projection-summation-correction-middle-packet-20260613-1621.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-projection-summation-lower1-20260613-163053.md`
- `proof-blueprints/QBE-AUTO-002-status.json`
- `proof-blueprints/QBE-AUTO-002-status.md`
- `proof-blueprints/QBE-AUTO-002.md`
- `proof-obligations/QBE-AUTO-002.md`
- `research-wiki/retrieval-index/QBE-AUTO-002.json`
- `tasks/QBE-AUTO-002.md`
- `tools/qbe.py`
- `verifier-feedback/QBE-AUTO-002/finite-path-feeder-lower1-20260613-160936.json`
- `verifier-feedback/QBE-AUTO-002/finite-path-feeder-lower2-20260613-155325.json`
- `verifier-feedback/QBE-AUTO-002/finite-path-feeder-lower2-tailkill-20260613-161435.json`
- `verifier-feedback/QBE-AUTO-002/finite-path-feeder-lower3-20260613-160804.json`
- `verifier-feedback/QBE-AUTO-002/finite-path-feeder-middle-20260613-1600.json`
- `verifier-feedback/QBE-AUTO-002/source-prepared-col0-diagnostic-middle-20260613-163714.json`
- `verifier-feedback/QBE-AUTO-002/source-prepared-projection-summation-correction-middle-20260613-1621.json`
- `verifier-feedback/QBE-AUTO-002/source-prepared-projection-summation-lower3-20260613-163030.json`

## Controls

- ASTIS-style compact context/status artifacts for long runs
- LeanMarathon-style durable proof blueprint and dynamic leaf queue
- LBG-style trial memory and reviewer feedback compression
- EoH-style candidate/proof-attempt populations only where QBE mode permits them

## Next-Cycle Rule

- Upper must choose one dynamic leaf or one refiner illness area before lower work.
- Middle must map the selected paper proof fragment to Lean declarations or explicit obligations.
- Lower 1 writes the natural-language DAG proof packet; lower 2 proves one ready Lean leaf; lower 3, if present, runs finite/path/support diagnostics and records typed verifier feedback.
- Lower must edit only the assigned local target and run `python3 tools/qbe.py check` after Lean edits.
- Reviewer accepts progress only when the Lean gate and the Markdown/LaTeX correspondence are synchronized.
