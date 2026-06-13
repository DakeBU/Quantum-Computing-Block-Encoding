# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-13 15:53:25`
- Mode: `faithfulPaper`
- Stage: Stage 2 DAG proof discharge, with faithful transcript checks still active
- Latest cycle: `20260613-054606-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- finite_projection_feeder: prove the active clean projection equals the backend fold at evaluated level; status: active lower leaf; open; Lean: `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or one strict finite theorem feeding it
- source_contract_target_correction: source-prepared field is recovered only with `Uniform(H)` explicit and a finite projection feeder; status: active correction; compiled bridge reused; Lean: `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_i...

## Open Obligation Signals

- finite projection feeder: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, or one strict finite `CircuitMatrixSemantics`/`Coeff.evalWith` theorem feeding it; class QBE-local finite projection/backend fold theorem tied to GHL2025 Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`; status active lower2 target; open
- source-prepared recovery under `Uniform(H)`: Lean `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold`; class compiled route consuming the finite feeder under the explicit external clean-column contract; status compiled conditional; not closure without `hFold`
- arbitrary-`H` source-prepared field: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`; `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; class needs a true all-`H` finite composition theorem or clean-column independence theorem; status retired as default lower target
- all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula 2024; status contract-only; allowed only as explicit `hUniform`; not formalized here
- direct H-free evaluated-fold route: Lean diagnostic `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class diagnostic route with register-shape drift risk; status rejected as default lower target; do not assign

## Trial Counts By Role

- `lower`: 1074
- `middle`: 797
- `reviewer`: 688
- `upper`: 1345

## Trial Counts By Status

- `accepted`: 1433
- `blocked`: 30
- `compiled`: 489
- `failed`: 39
- `queued`: 1913

## Local Paper Sources

- `GHL2025` found: `outer_papers/quantum/GHL2025/main.tex`

## Recent Lean Declarations

- `def oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21211`
- `def oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21228`
- `def oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21323`
- `def oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21456`
- `theorem oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21561`
- `structure OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:21581`
- `def oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21627`
- `structure OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` at `QuantumBlockEncoding/RobinMatrix.lean:21855`
- `def oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:21898`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` at `QuantumBlockEncoding/RobinMatrix.lean:22476`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:23441`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23473`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24300`
- `theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24330`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` at `QuantumBlockEncoding/RobinMatrix.lean:24343`
- `theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24361`
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
- `QuantumBlockEncoding/Automation.lean`
- `README.md`
- `docs/agent_blueprint_formalization.md`
- `docs/pro_prompt_policy.md`
- `docs/prompts/`
- `proof-attempts/QBE-AUTO-002/chatgpt-pro-finite-path-feeder-deployment-20260613.md`
- `proof-blueprints/QBE-AUTO-002-status.json`
- `proof-blueprints/QBE-AUTO-002-status.md`
- `proof-blueprints/QBE-AUTO-002.md`
- `proof-obligations/QBE-AUTO-002.md`
- `research-wiki/retrieval-index/QBE-AUTO-002.json`
- `tasks/QBE-AUTO-002.md`
- `tools/qbe.py`
- `tools/qbe_run_theorem_closure.sh`
- `verifier-feedback/QBE-AUTO-002-current-ghl-feedback.md`
- `verifier-feedback/QBE-AUTO-002/chatgpt-pro-finite-path-feeder-deployment-20260613.json`

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
