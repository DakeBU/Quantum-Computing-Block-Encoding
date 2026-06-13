# 2026-06-13 Lower1 Addendum: Source-Prepared Projection/Summation Route

Task: `QBE-AUTO-002`  
Run: `20260613-161435-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`

## Source Fragment

The translated source fragment is GHL2025 Eq. `arbitrary sparcity`,
Eq. `angles for Ry`, Theorem `theorem: 1 term robin`, Eq.
`ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

Definitions from the source fragment:

- Eq. `arbitrary sparcity` prepares the sparse register as
  $H_W^{(\kappa)}|0\rangle = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle$.
- Eq. `angles for Ry` defines boundary controlled rotations for sparse slots
  $s=0,\dots,\kappa-1$ and boundary indices outside the bulk interval.
- Eq. `ROBIN clarified` states that the displayed boundary part of
  $|\gamma_3\rangle$ carries a clean-ancilla contribution with coefficient
  $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$, while
  other branches are hidden in the trailing terms.
- Fig. `fig:1 term ROBIN` includes the sparse-register preparation and cleanup
  gates $H_W^{(\kappa)}$ and $(H_W^{(\kappa)})^\dagger$ around the backend
  component.
- Definition `def:block-encoding` selects the clean ancilla and signal
  projection as the theorem-facing predicate.

The source route is therefore a prepared sparse-register projection route, not
a direct equality between the H-free seven-gate active entry `[0,0]` and the
selected sparse slot `2` contribution.

## Definitions

Let `Uniform(H)` be
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Let `ActiveEval(env)` be

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `PreparedSparseCleanEntry(H, env)` be

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `SourcePreparedField(H, env)` be
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.

Let `BackendFold(env)` be

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

## Natural-Language Proof Design

Claim 1: The paper source prepares a sparse-slot superposition before the
backend and cleans it afterward.

Reason: Eq. `arbitrary sparcity` is exactly the all-slot clean-column contract
represented in Lean by `Uniform(H)`.  Fig. `fig:1 term ROBIN` contains both
`H_W^(kappa)` sides, while
`GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)` contains
only the seven active backend gates.  The Lean transcript guards are
`GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and
`GHL2025.oneTermRobinActiveBackendCircuit_gateList`.

Claim 2: Under `Uniform(H)`, the prepared sparse clean-clean entry evaluates to
the backend branch fold.

Reason: `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H` is the
finite sparse-register sandwich matrix whose clean-clean entry is
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`, by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.  The
uniform-column contract rewrites each prepared sandwich summand to the backend
summand by
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`,
and the fold-level statement is
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.
After evaluation, the compiled bridge is
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.

Claim 3: The active source-prepared field is the remaining finite composition
statement.

Reason: `SourcePreparedField(H, env)` is equivalent to the unwrapped equality
`ActiveEval(env) = PreparedSparseCleanEntry(H, env)` by
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`.
This statement is the source-shaped active leaf.  It keeps the prepared
sparse-register object on the right-hand side rather than replacing it by the
slot-`2` contribution too early.

Claim 4: Once the source-shaped field is proved under `Uniform(H)`, the
evaluated backend fold follows.

Reason: `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
turns `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`
and `Uniform(H)` into
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.  The
theorem-facing source-prepared field is recovered by
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`.

Claim 5: The retired strict H-free feeder must not be assigned as a theorem
target.

Reason: `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` records
that the active side is full-basis row `0`, while the selected contribution is
sparse slot `2` at full basis index `32`.  The previous lower1/lower3 support
audit also records that the active column-`0` path is a two-path branch killed
by the tail, whereas the selected slot-`2` branch is the prepared sparse-slot
contribution.  This is a `shape_or_register_gap`, not a missing raw `Coeff`
constructor equality.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | all seven sparse slots have clean-column amplitude `sqrt_kappa_inv` | Eq. `arbitrary sparcity`; Shukla--Vedula cited contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger and conversion window | contract only | external contract; keep explicit |
| `fig4_vs_backend_split` | distinguish full Fig. 4 from the H-free seven-gate backend | Fig. `fig:1 term ROBIN`; Fig. 4 audit | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | Fig. 4 audit | project gate | compiled transcript guard |
| `prepared_sparse_clean_entry` | clean-clean entry of the prepared sparse sandwich | prepared sparse matrix definition | none | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3` | conversion window | project gate | compiled |
| `prepared_fold_to_backend` | prepared sandwich fold equals backend branch fold under `Uniform(H)` | all-slot contract; branch contribution definitions | none | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`; `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | source-prepared packet | project gate | compiled conditional bridge |
| `source_prepared_uncast_leaf` | `SourcePreparedField(H, env)` is equivalent to `ActiveEval(env) = PreparedSparseCleanEntry(H, env)` | source-prepared target; uncast prepared-sandwich bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3` | current packet | project gate | compiled equivalence |
| `active_col0_diagnostic_bridge` | evaluated `evalGateMatrices` `[0,0]` entry equals explicit seven-gate `[0,0]` entry | active backend gate list; matrix associativity; no raw theorem closure | lower2 | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env` | this file | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active diagnostic leaf |
| `source_prepared_sparse_clean_feeder` | prove the source-shaped evaluated equality under the explicit paper contract, or record its failure against the active-side diagnostic | active-side diagnostic; prepared sparse clean entry; `Uniform(H)` | lower2 after diagnostic | proposed `oneTermRobinGamma3BoundarySourcePreparedSparseCleanFeeder_n3 H env hUniform` | source-prepared packet | same | blocked on active-side viability check |
| `evaluated_backend_fold_recovery` | recover `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` from the source-shaped field | source-prepared sparse clean feeder; `Uniform(H)` | lower2 after feeder | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3` | conversion window | same | blocked on feeder |
| `strict_hfree_feeder_retirement` | reject `ActiveEval(env) = selectedSlotContribution` as a lower2 target | index split; lower1/lower3 finite support audit | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | proof obligations | project gate | retired; `shape_or_register_gap` |

Next active leaf for a Lean worker:

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

This leaf is diagnostic only.  It should not be used as theorem closure.  Its
purpose is to decide whether the source-shaped feeder is viable in the current
active-side semantics before lower2 spends tokens on a broad prepared equality.

## Intermediate Lean Lemma Order

Reuse existing declarations in this order:

1. Transcript guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`, and
   `GHL2025.oneTermRobinGateMatrixPlaceholders_gateList`.
2. Uniform sparse-register contract:
   `oneTermRobinGamma3BoundarySparseCleanIndex_n3`,
   `oneTermRobinGamma3BoundarySparseSlotIndex_n3`, and
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`.
3. Prepared sandwich objects:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3`, and
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3`.
4. Prepared-to-backend compiled bridges:
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   and `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
5. Source-prepared target equivalences:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`,
   and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`.
6. Active-side diagnostics:
   `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`, and
   `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`.

If the diagnostic bridge compiles and confirms the active side is the explicit
seven-gate `[0,0]` entry, then lower2 should not attack the source-shaped
feeder blindly.  Middle should first decide whether the active signal entry
must be restated as a prepared projection entry or whether a missing finite
projection theorem justifies the current active-side semantics.

## Failure Analysis

The current strict H-free feeder is mathematically misrouted.  Its left-hand
side is the active full-basis `[0,0]` entry of the seven-gate backend list; its
right-hand side is the selected prepared sparse slot `2` contribution at full
index `32`.  Existing Lean declarations already record this index split and
the previous lower support audit records different branch behavior for the two
paths.

The corrected source route is not a new construction.  It is the paper's
prepared sparse-register route:

```text
Eq. arbitrary sparcity
  -> prepared sparse register
  -> Fig. fig:1 term ROBIN backend
  -> prepared sparse clean entry
  -> backend branch fold under Uniform(H)
  -> Definition def:block-encoding clean projection
```

The remaining risk is that the current Lean active entry still exposes the
H-free seven-gate `[0,0]` entry.  If the proposed diagnostic bridge proves that
this active entry is exactly the explicit column-`0` entry already known to
evaluate to zero, then a direct source-shaped feeder for arbitrary `env` and
uniform `H` will likely need retargeting rather than more tactic search.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `source_prepared_projection_summation_correction` |
| `source_correspondence_ok` | `true_for_prepared_sparse_projection_route` |
| `lean_parse_ok` | `not_applicable_no_Lean_edit` |
| `lean_build_ok` | `not_applicable_no_Lean_edit_before_gate` |
| `finite_matrix_ok` | `blocked_until_active_col0_diagnostic_bridge` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `not_promoted` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `prove the evaluated active column-0 diagnostic bridge, then either assign a branch-correct source-prepared sparse-clean feeder or retarget the active signal entry if the diagnostic confirms the row-0/slot-2 mismatch` |

