# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-14 16:31:08`
- Mode: `faithfulPaper`
- Stage: Stage 2 DAG proof discharge, with faithful transcript checks still active
- Latest cycle: `20260614-004100-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- prepared_projection_restatement_leaf: restate theorem-facing Fig. 4 clean projection as `PreparedCleanEntry(H, env) = BackendFold(env)` under `Uniform(H)`; status: active next leaf; Lean: `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`; ...

## Open Obligation Signals

- selected-slot nonzero obstruction: Lean `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`; class QBE-local finite evaluator witness for the selected gamma3 branch; status proved; stale as lower work
- H-free evaluated backend fold: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; class compiled normal form plus nonzero selected-slot witness; status retired as active target; `finite_matrix_counterexample`
- direct H-free selected-slot feeder: Lean proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env`; class active row `0` versus selected sparse slot `2` / full index `32`; status retired; `shape_or_register_gap`
- source-prepared active-field contract: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` and equivalents; class GHL Fig. `fig:1 term ROBIN` / Definition `def:block-encoding` source-correspondence audit; status active middle/lower1/lower3 contract leaf; not theorem closure
- active field forces selected-zero guard: Lean proposed `oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3 H env hUniform hActive`; class QBE-local diagnostic consequence of source-prepared-to-fold wiring plus selected-zero normal form; status active lower2 guard leaf
- corrected source-prepared target: Lean restated theorem-facing clean projection after the guard/source audit; class source-contract audit plus finite branch/register diagnostics; status blocked until guard or reviewer restatement
- all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula; status contract-only; downstream-only

## Trial Counts By Role

- `lower`: 1142
- `middle`: 826
- `reviewer`: 699
- `upper`: 1379

## Trial Counts By Status

- `accepted`: 1489
- `blocked`: 37
- `compiled`: 506
- `failed`: 42
- `queued`: 1971
- `rejected`: 1

## Local Paper Sources

- `GHL2025` found: `outer_papers/quantum/GHL2025/main.tex`

## Recent Lean Declarations

- `def oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21652`
- `def oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21785`
- `theorem oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21890`
- `structure OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:21910`
- `def oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21956`
- `structure OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` at `QuantumBlockEncoding/RobinMatrix.lean:22184`
- `def oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:22227`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:22837`
- `theorem oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23077`
- `theorem oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23128`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:23948`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23980`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24872`
- `theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24902`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` at `QuantumBlockEncoding/RobinMatrix.lean:24915`
- `theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24933`
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
- `proof-attempts/QBE-AUTO-002/chat1h-lower1-source-dag-20260614-162018.md`
- `proof-attempts/QBE-AUTO-002/chat1h-middle-synthesis-20260614-162018.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-target-repair-plan-20260614-pro.md`
- `proof-blueprints/QBE-AUTO-002-status.json`
- `proof-blueprints/QBE-AUTO-002-status.md`
- `proof-blueprints/QBE-AUTO-002.md`
- `tasks/QBE-AUTO-002.md`
- `tools/qbe.py`
- `verifier-feedback/QBE-AUTO-002/chat1h-lower3-prepared-projection-20260614-162018.json`

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
