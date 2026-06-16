# QBE Blueprint Status

- Task: `QBE-AUTO-002`
- Title: Concrete Circuit Matrix Semantics Backend
- Generated: `2026-06-17 01:35:01`
- Mode: `paperBenchmark`
- Stage: Stage 2 DAG proof discharge, with source-transcript checks still active
- Latest cycle: `20260615-053748-QBE-AUTO-002-cycle01`
- Blueprint: `Auto-Quantum-Computing-Bloack-Encoding-In-Sleep/proof-blueprints/QBE-AUTO-002.md`

## Dynamic Leaf Queue

- 1. **Close the GHL paper benchmark baseline first.** Locate the paper theorem corresponding to the Guseynov--Huang--Liu block-encoding theorem (the run should treat this as Theorem 3 / the main BE construction theorem, using the local source map if numberin...
- 2. **After the baseline is Lean-closed, start improvement search for the same operator.** Create or update a candidate population for the same target operator and compare candidates by the current QBE score order: `(depth, gateCount, auxiliaryQubits, oracle...
- 3. **If the GHL baseline is closed and improvement search stagnates for many generations, switch to the fallback operator-construction task** `QBE-OP-OPTCTRL-001`, titled `Operator of optimal control paper`. Its target is the operator shown in the user's im...

## Open Obligation Signals

- theorem-facing finite block/projection interface: Lean `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`; class QBE-local non-promoting interface packet; status compiled; stale as lower work
- source-prepared slot-`2` normalizer route: Lean `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`; class QBE-local semantic bridge under explicit source contracts; status compiled route memory
- theorem-facing projection-interface normalizer bridge: Lean planned `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`; class internal paper-step interface glue plus local coefficient normalizer bridge; status active lower2 leaf after lower1/lower3 checks
- fixed product-to-coefficient theorem for `(0,0)`: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus corrected theorem-facing finite block/projection route; status open; blocked
- finite block-composition closure: Lean `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`, `.blockProjection`, `.lcuComposition`, `.finalExtraction`; class contract-only LCU/block composition background plus local finite projection theorem; status false; forbidden as this leaf
- diagnostic raw equality route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class existing diagnostic `sorry` route; status forbidden as dependency

## Trial Counts By Role

- `lower`: 1259
- `middle`: 870
- `reviewer`: 715
- `upper`: 1428

## Trial Counts By Status

- `accepted`: 1600
- `blocked`: 39
- `compiled`: 526
- `failed`: 42
- `queued`: 2062
- `rejected`: 3

## Local Paper Sources

- `GHL2025` found: `outer_papers/quantum/GHL2025/main.tex`

## Recent Lean Declarations

- `theorem oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23196`
- `theorem oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23247`
- `theorem oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` at `QuantumBlockEncoding/RobinMatrix.lean:23637`
- `structure OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` at `QuantumBlockEncoding/RobinMatrix.lean:24108`
- `def oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24140`
- `structure OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation` at `QuantumBlockEncoding/RobinMatrix.lean:24913`
- `def oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` at `QuantumBlockEncoding/RobinMatrix.lean:24937`
- `structure OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge` at `QuantumBlockEncoding/RobinMatrix.lean:25201`
- `def oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` at `QuantumBlockEncoding/RobinMatrix.lean:25251`
- `structure OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit` at `QuantumBlockEncoding/RobinMatrix.lean:25408`
- `def oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` at `QuantumBlockEncoding/RobinMatrix.lean:25466`
- `def oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` at `QuantumBlockEncoding/RobinMatrix.lean:25708`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` at `QuantumBlockEncoding/RobinMatrix.lean:26091`
- `theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` at `QuantumBlockEncoding/RobinMatrix.lean:26121`
- `theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` at `QuantumBlockEncoding/RobinMatrix.lean:26134`
- `theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` at `QuantumBlockEncoding/RobinMatrix.lean:26152`
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
- `QBE.md`
- `QuantumBlockEncoding/BlockEncoding.lean`
- `README.md`
- `Tests/Basic.lean`
- `docs/agent_orchestration.md`
- `docs/sleep_run_guide.md`
- `proof-blueprints/QBE-AUTO-002-status.json`
- `proof-blueprints/QBE-AUTO-002-status.md`
- `proof-blueprints/QBE-AUTO-002.md`
- `tasks/QBE-AUTO-002.md`
- `tasks/QBE-OP-OPTCTRL-001.md`
- `tasks/README.md`
- `tools/qbe.py`
- `tools/qbe_codex_agent.sh`
- `tools/qbe_run_theorem_closure.sh`

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
