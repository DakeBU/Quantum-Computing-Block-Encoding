# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-15 06:21:02`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
## Current Run Directive: 2026-06-15 Theorem-Facing Projection-Interface Normalizer Bridge Prepared

This directive supersedes the post-audit projection-interface packet after
lower2 compiled it as non-promoting route memory:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript
```

Lower3 postcompile feedback records that the interface is now stale as lower
work: the source-prepared projection target is attached to the finite block
contract, `oneTermRobinFiniteBlockCompositionContract 3` still uses
`oneTermRobinCircuitSemantics 3`, the theorem-facing Fig. 4 transcript remains
distinct from the active seven-gate backend, and every theorem-facing semantic
flag remains false.

The root obligation remains open and is still forbidden as a direct lower2
target:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
```

The new active leaf is a theorem-facing projection-interface normalizer
bridge.  Middle prepared:

```text
proof-attempts/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-middle-packet-20260615-0558.md
verifier-feedback/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-middle-20260615-0558.json
```

The planned lower2 declaration is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3
```

This theorem should expose the already compiled source-prepared slot-`2`
normalizer evaluator through the fields of
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`.
It may assume only the existing explicit contracts:

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
hentry :
  env "boundary_cos_half_0_2" =
    Coeff.evalWith env
      (GHL2025.boundaryRotationNormalizedCoefficient
        (oneTermParameters 3) 0 2)
hND : env "N_D_inv" * env "N_D" = 1
hNF : env "N_f_inv" * env "N_f" = 1
hkappa : env "kappa_inv" * env "kappa" = 1
hkappaSqrt :
  env "sqrt_kappa_inv" * env "sqrt_kappa_inv" = env "kappa_inv"
```

The expected bridge equality is the interface-field version of the compiled
route:

```lean
Coeff.evalWith env interface.sourcePreparedProjectionEntry *
    Coeff.evalWith env interface.normalizedProjectionBridge.theoremNormalizer =
  Coeff.evalWith env interface.normalizedProjectionBridge.expectedTargetEntry
```

The bridge must also restate that `correctedFiniteBlockProjectionEquality`,
the fixed product obligation, normalized-block equality, LCU correctness,
block projection, block correctness, final extraction, oracle correctness,
unitarity, and resource claims remain false.  It must not replace the paper
circuit, mutate `oneTermRobinFiniteBlockCompositionContract 3`, add new
assumptions, use the diagnostic `sorry` routes, or prove the root obligation.

Lower-agent split:

1. lower1 validates the source map and keeps the focused branch fixed to
   system entry `(0,0)`, sparse slot `2`, source-prepared projection, branch
   basis `[32,32]`, signal block `[0,0]`, and normalizer `N_D*N_f*kappa`.
2. lower3 verifies the compiled interface, normalizer bridge inputs, transcript
   split, active-backend contract wiring, and all false theorem flags before
   lower2 edits Lean.
3. lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean` and only for
   the one bridge theorem above.  If it already exists, lower2 should make no
   Lean edit and log `error_class=stale_leaf`.

Forbidden lower2 targets remain:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

No oracle, `H_W`, boundary `R_y`, LCU/block composition, oracle correctness,
unitarity, normalized block equality, block correctness, final extraction,
resource, normalizer-free, or product-to-coefficient flag is promoted by this
middle packet.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| 1. lower1 validates the source map and keeps the focused branch fixed to system entry `(0,0)`, sparse slot `2`, source-prepared projection, branch basis `[32,32]`, signal block `[0,0]`, and normalizer `N_D*N_f*kappa`. | candidate |
| 2. lower3 verifies the compiled interface, normalizer bridge inputs, transcript split, active-backend contract wiring, and all false theorem flags before lower2 edits Lean. | candidate |
| 3. lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean` and only for the one bridge theorem above. If it already exists, lower2 should make no Lean edit and log `error_class=stale_leaf`. | candidate |

## Open Obligation Signals

```text
theorem-facing finite block/projection interface: Lean `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`; class QBE-local non-promoting interface packet; status compiled; stale as lower work
source-prepared slot-`2` normalizer route: Lean `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`; class QBE-local semantic bridge under explicit source contracts; status compiled route memory
theorem-facing projection-interface normalizer bridge: Lean planned `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`; class internal paper-step interface glue plus local coefficient normalizer bridge; status active lower2 leaf after lower1/lower3 checks
fixed product-to-coefficient theorem for `(0,0)`: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus corrected theorem-facing finite block/projection route; status open; blocked
finite block-composition closure: Lean `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`, `.blockProjection`, `.lcuComposition`, `.finalExtraction`; class contract-only LCU/block composition background plus local finite projection theorem; status false; forbidden as this leaf
diagnostic raw equality route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class existing diagnostic `sorry` route; status forbidden as dependency
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19918` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20119` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20135` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:20154` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20188` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20287` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20369` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20384` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20389` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20404` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:20486` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20526` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20680` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20685` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20912` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21087` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21124` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21540` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21557` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21652` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21785` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21890` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21910` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21956` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:22207` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22250` |
| theorem | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22491` |
| theorem | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22514` |
| theorem | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22549` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22956` |
| theorem | `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23196` |
| theorem | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23247` |
| theorem | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23637` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:24108` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24140` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation` | `QuantumBlockEncoding/RobinMatrix.lean:24913` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24937` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge` | `QuantumBlockEncoding/RobinMatrix.lean:25201` |
| def | `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25251` |
| structure | `OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit` | `QuantumBlockEncoding/RobinMatrix.lean:25408` |
| def | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25466` |
| def | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25708` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26091` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26121` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:26134` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26152` |
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
Obligation 3 0 0. lower1 source DAG, lower3 guard diagnostics, lower2 one named Lean leaf only after the packet. Reject root attack, backendExpansion/raw diagnostic sorry routes, seven-gate-as-Fig4 substitution, and semantic-flag promotion. Gate passed with only known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:03:25 - middle

middle source-correspondence sync complete: retired theorem-facing finite block/projection interface as compiled stale route memory; prepared theorem-facing projection-interface normalizer bridge packet and verifier feedback; next lower2 target is oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3 only; root product-to-coefficient and semantic flag promotion remain forbidden; gate passed via python3 tools/qbe.py check with only known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:09:39 - middle

middle memory/retrieval curator complete: retired compiled contract-audit and projection-interface leaves as stale lower targets; recorded rejected root/backendExpansion/diagnostic-sorry/semantic-flag routes; active leaf remains theorem_facing_projection_interface_normalizer_bridge with planned Lean target oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3; wrote 22_middle_memory_retrieval-output.md and middle-memory verifier JSON; refreshed blueprint status cards; gate passed via python3 tools/qbe.py check with only known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:12:47 - middle

middle report/export maintainer complete: wrote runs/20260615-053748-QBE-AUTO-002-cycle01/23_middle_report_export-output.md. Final audit should refresh HUMAN_STATUS.md, REPORTS.zh.md, any zh_summary/article_update packets, GHL Markdown/LaTeX status exports, project-paper latest update, and ABEIS generated_cycle_status from the current run. Raw logs, verifier JSON, proof-attempt packets, machine retrieval JSON, trials files, and generated cycle updates are not primary human entry points. Human blocker: compiled ProjectionInterface is route memory; active blocker is oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3 before final coefficient/product bridge. Forbidden claims unchanged: no GHL theorem closure or oracle/H_W/R_y/LCU/block/final/unitary/resource/product promotion. Gate passed: python3 tools/qbe.py check with only known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:18:03 - middle

middle coordinator synthesis complete: read source-correspondence, memory/retrieval, and report/export outputs; wrote 24_middle_coordinator_synthesis-output.md and theorem-facing projection-interface normalizer coordinator feedback JSON; active leaf remains theorem_facing_projection_interface_normalizer_bridge with planned lower2 target oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3; no Lean or article update edit; gate passed via python3 tools/qbe.py check with only the two known RobinMatrix diagnostic sorry warnings.
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
