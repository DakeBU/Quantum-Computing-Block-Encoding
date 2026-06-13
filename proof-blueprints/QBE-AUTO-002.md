# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-13 16:47:14`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
## Current Run Directive: 2026-06-13 Middle Coordinator Synthesis For Run 20260613-163714

This directive implements the latest upper handoff in
`runs/20260613-163714-QBE-AUTO-002-cycle01/dialogue.md`.  If a focused prompt
replays the older ChatGPT Pro strict-feeder override, treat it as stale.  The
strict H-free feeder

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

remains retired as `shape_or_register_gap`: it compares the active H-free
full-basis entry `[0,0]` with the selected sparse slot `2` contribution at full
index `32`.

The active source-faithful route is still the prepared sparse-register
projection route under explicit

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The next lower2 Lean leaf is the guard-only evaluated column-`0` bridge:

```lean
theorem oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

This bridge may use matrix associativity or entry-level product congruence, but
must not use the sorry-guarded raw theorem
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as closure.
It is a diagnostic guard only.  If it compiles, combine it with
`oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3` to record the
active H-free column-`0` behavior, then middle must retarget before any worker
tries to prove a direct source-shaped feeder from the H-free active entry.

Current packet:

```text
proof-attempts/QBE-AUTO-002/source-prepared-col0-diagnostic-middle-packet-20260613-163714.md
```

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted.  The
first-case-study one-term theorem remains open.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| source_prepared_projection_summation_correction: translate Eq. `ROBIN clarified` through prepared sparse-register projection, not the H-free row-0 shortcut; status: active lower1/lower3 leaf; Lean: no new Lean required before lower2 | candidate |
| active_eval_gate_matrices_column0_bridge: prove `ActiveEval(env) = ExplicitSevenGate00(env)` at `evalWith` entry level without using the sorry-guarded raw matrix equality; status: active lower2 leaf; guard only; Lean: proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env` | candidate |
| source_prepared_sparse_clean_feeder: prove `SourcePreparedField(H, env)` or the equivalent uncast prepared sparse-clean equality under explicit source contract; status: active lower2 leaf after calibration; Lean: `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` feeds the target | candidate |

## Open Obligation Signals

```text
strict H-free row-0 to slot-2 feeder: Lean `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env`; class compares different finite paths: active `[0,0]` and selected slot `2`/full index `32`; status retired; `shape_or_register_gap`
active column-0 tail-kill normal form: Lean `oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3`; class QBE-local explicit seven-gate path support; status proved by lower2; no semantic flag promoted
active evalGateMatrices column-0 bridge: Lean proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env`; class QBE-local fold/product associativity at `evalWith` entry level; status active lower2 leaf; guard only; open
source-prepared sparse-clean feeder: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`, or the equivalent uncast prepared sparse-clean comparison from `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env`; class source-shaped active/prepared finite composition theorem under explicit `Uniform(H)` in recovery; status blocked until the active-side guard is interpreted
evaluated fold recovery: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive`; class compiled route from source-prepared field to evaluated backend fold under `Uniform(H)`; status blocked on source-shaped field
all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula 2024; status contract-only; keep explicit
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18978` |
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19102` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19124` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19179` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19323` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19327` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19337` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19352` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19366` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19453` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19494` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:19625` |
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19659` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19860` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19876` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:19895` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19929` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20028` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20110` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20125` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20130` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20145` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:20227` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20267` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20421` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20426` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20653` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20828` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20865` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21281` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21298` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21393` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21526` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21631` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21651` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21697` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21925` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21968` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22546` |
| theorem | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22727` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:23547` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23579` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24406` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24436` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:24449` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24467` |
| def | `gateMatricesMatchCircuit` | `QuantumBlockEncoding/CircuitSemantics.lean:41` |
| structure | `CircuitMatrixSemantics` | `QuantumBlockEncoding/CircuitSemantics.lean:404` |
| structure | `PreparedCircuitEntryTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:436` |
| structure | `BlockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:502` |
| structure | `BlockExtractionBranchContributionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:535` |
| structure | `CircuitBlockEncodingClaim` | `QuantumBlockEncoding/CircuitSemantics.lean:661` |
| structure | `FiniteBlockCompositionContract` | `QuantumBlockEncoding/CircuitSemantics.lean:676` |
| def | `signalSystemBlockRowIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:696` |
| def | `signalSystemBlockColIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:700` |
| theorem | `signalSystemBlockRowIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:712` |
| theorem | `signalSystemBlockColIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:727` |
| def | `signalSystemBlockProjection` | `QuantumBlockEncoding/CircuitSemantics.lean:753` |
| def | `totalCircuitQubits` | `QuantumBlockEncoding/CircuitSemantics.lean:778` |
| def | `CircuitMatrixSemantics.blockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:786` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-AUTO-002.md` | task/proof map |
| `conversion-windows/QBE-AUTO-002.md` | Lean/Markdown/LaTeX conversion |
| `proof-obligations/QBE-AUTO-002.md` | open obligations |
| `paper-notes/GHL2025_RobinOneTerm.tex` | human-readable proof export |
| `paper-notes/GHL2025/markdown/00_status.md` | human-readable proof export |
| `paper-notes/GHL2025/latex/sections/00_status.tex` | human-readable proof export |
| `research-wiki/cited-results/GHL2025.md` | external theorem memory |

## Latest Dialogue Signal

````text
emma if middle states it; lower3 checks branch-correct finite support. No raw Coeff equality, no hUniform added to strict feeder, no semantic flag promotion.

## 2026-06-13 16:27:44 - middle

Middle sync complete: retired the strict H-free finite-path feeder as shape_or_register_gap after lower1/lower3; source-prepared projection/summation correction is now the active leaf, with Uniform(H) explicit and lower packet proof-attempts/QBE-AUTO-002/source-prepared-projection-summation-correction-middle-packet-20260613-1621.md. Blueprint/status, obligations, conversion window, run memory/todo, retrieval index, article update, and verifier feedback refreshed. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests, with known diagnostic sorries only.

## 2026-06-13 16:32:01 - lower

Lower3 necessary-condition verifier wrote verifier-feedback/QBE-AUTO-002/source-prepared-projection-summation-lower3-20260613-163030.json. Source-prepared projection/summation correction is shape-valid under explicit hUniform; retired H-free ActiveEval=selectedSlotContribution remains rejected as shape_or_register_gap because row0 and selected slot2/full index32 are different finite paths. No Lean declarations edited. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests, with known diagnostic sorries at RobinMatrix.lean:24366 and 24397.

## 2026-06-13 16:33:47 - lower

Lower1 addendum written: proof-attempts/QBE-AUTO-002/source-prepared-projection-summation-lower1-20260613-163053.md maps the corrected source-prepared route Eq. arbitrary sparcity -> Fig. fig:1 term ROBIN -> prepared sparse clean entry -> backend fold under explicit Uniform(H). It keeps oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 retired as shape_or_register_gap because it compares active row 0 with sparse slot 2/full index 32. Recommended next lower2 leaf is only the evaluated active column-0 diagnostic bridge oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env; do not use it as theorem closure. Gate passed via python3 tools/qbe.py check, which ran lake build and lake build Tests with only known diagnostic sorries.

## 2026-06-13 16:36:28 - lower

Lower2 handoff: closed oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3 in QuantumBlockEncoding/RobinMatrix.lean. Gate passed: python3 tools/qbe.py check and lake build && lake build Tests, with only the known diagnostic sorry warnings now at RobinMatrix.lean:24436 and 24467. Remaining Lean bridge: prove Coeff.evalWith env ((evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3))) oneTermRobinGamma3BoundaryPrefixRow0_n3 oneTermRobinGamma3BoundaryPrefixRow0_n3) = Coeff.evalWith env (oneTermRobinGamma3BoundarySevenGateMatrix_n3 oneTermRobinGamma3BoundaryPrefixRow0_n3 oneTermRobinGamma3BoundaryPrefixRow0_n3) without using the diagnostic raw Coeff equality theorem; strict selected-slot feeder remains blocked by active row-0 versus selected slot-2 shape gap.
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts progress only through `python3 tools/qbe.py check` and
  synchronized Markdown/LaTeX correspondence.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
