# 2026-06-13 Lower1 Route Guard: Branch-Correct Backend Fold

Task: `QBE-AUTO-002`  
Run: `20260613-180059-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`

## Source Fragment

The source-paper fragment is GHL2025 Theorem `theorem: 1 term robin`,
Eq. `arbitrary sparcity`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`,
and Definition `def:block-encoding`.

Equation `arbitrary sparcity` defines the clean sparse-register preparation:

$$
H_W^{(\kappa)} |0\rangle^{\lceil \log_2 \kappa \rceil}
  = \frac{1}{\sqrt{\kappa}} \sum_{s=0}^{\kappa-1}
    |s\rangle^{\lceil \log_2 \kappa \rceil}.
$$

Equation `ROBIN clarified` gives the displayed boundary part of
$|\gamma_3\rangle$:

$$
|\gamma_3\rangle =
\frac{1}{\mathcal{N}_D \mathcal{N}_f \kappa}
\sum_{\substack{s=0,\dots,\kappa-1 \\
0 \leq j < K_1 \cup K_2 < j < 2^n}}
f(x_i) (D)^{(s)}_i \sigma^{(s)}
|0\rangle^{m_f+1} |s\rangle
|0\rangle^{n-\lceil \log_2\kappa\rceil} |j\rangle^n |0\rangle
  + \cdots .
$$

Fig. `fig:1 term ROBIN` supplies the theorem-facing circuit around this
state transition: `U_indic`, the transposed sparse-amplitude oracle or
boundary `R_y`, the banded sparse-access oracle, `O_f`, `SWAP`, and
`(O_D^{BS})^dagger`, with the sparse preparation supplied by the
`H_W^(kappa)` clean-column contract.  Definition `def:block-encoding`
selects the clean signal projection entry after this unitary.

The active Lean route for this run is the H-free evaluated backend fold:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

with uncast form:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

## Definitions

For fixed `env : String -> Rat`, define `ActiveEntry(env)` to be:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define `BackendFold(env)` to be:

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

Define `SelectedSlot(env)` to be:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

Define `Uniform(H)` to be:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The current H-free statement is `ActiveEntry(env) = BackendFold(env)`.
The downstream source-prepared bridge consumes that statement only through
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
H env hUniform hFold`.

## Natural-Language Proof

The source and Lean route split into three facts.

First, Definition `def:block-encoding` selects the clean signal entry.
Lean exposes this entry as
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`
and removes the active circuit cast with
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`.

Second, the current backend branch fold is already proved to collapse, after
`Coeff.evalWith`, to the selected sparse slot.  The named Lean theorem is
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`.
Thus the right side of the active fold is `SelectedSlot(env)`.

Third, the current active H-free `[0,0]` seven-gate entry evaluates to zero.
The named Lean theorem is
`oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`.  Its proof uses the
two-path column-0 normal form and the two zero `O_f` entries
`O_f[12,96]` and `O_f[12,97]`.

Therefore any proof of the current H-free evaluated backend fold would imply:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution = 0
```

The proof is a three-line calculation: rewrite `BackendFold(env)` to
`SelectedSlot(env)`, rewrite the assumed evaluated fold to `ActiveEntry(env)`,
and rewrite `ActiveEntry(env)` to zero.

This is not a proof of the evaluated backend fold.  It is a necessary-condition
guard showing that the fold cannot be assigned as an all-environment theorem
unless the selected branch contribution is also proved to vanish for all
environments.  Existing lower3 feedback for the finite-path feeder records a
simple environment where the selected contribution evaluates to `1`, so the
unqualified H-free fold should be treated as a route mismatch until that
counterexample is refuted or the target is restated.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | clean-column sparse-register preparation | Eq. `arbitrary sparcity`; Shukla--Vedula cited contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results GHL2025 row | contract only | downstream-only |
| `fig1_robin_source_route` | theorem-facing route includes source preparation and cleanup around the backend component | Fig. `fig:1 term ROBIN`; Fig. 4 audit | none | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` as active-list guard | Fig. 4 audit | prior gate | source checked |
| `strict_hfree_selected_slot_feeder` | direct `ActiveEntry(env) = SelectedSlot(env)` | active full index `0`; selected sparse slot `2` / full index `32` | none | proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3` | finite-path feedback | none | retired; `shape_or_register_gap` |
| `backend_fold_to_selected_eval` | `BackendFold(env) = SelectedSlot(env)` | backend slot vanish lemmas | none | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | backend fold packets | project gate | proved |
| `active_column0_zero_eval` | `ActiveEntry(env) = 0` | two-path active column-0 tail kill | none | `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env` | finite-path feedback | project gate | proved diagnostic |
| `evaluated_fold_forces_selected_zero` | if `ActiveEntry(env) = BackendFold(env)`, then `SelectedSlot(env) = 0` | `backend_fold_to_selected_eval`; `active_column0_zero_eval`; uncast fold equivalence | lower2 | proposed `oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3 env hFold` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` if Lean-edited | next safe active leaf |
| `evaluated_backend_fold_leaf` | prove `ActiveEntry(env) = BackendFold(env)` | selected contribution must be zero or target must be restated | none until retargeted | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | 18:00 middle packet | none | blocked; current route risks `finite_matrix_counterexample` |
| `source_prepared_recovery_from_fold` | recover source-prepared target under `Uniform(H)` after a valid fold proof | `evaluated_backend_fold_leaf`; `source_uniform_contract` | later | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | middle packet | prior gate | compiled; blocked |

## Intermediate Lean Lemmas

Reuse these declarations in dependency order:

1. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`.
2. `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`.
3. `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3`.
4. `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`.
5. `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`.
6. Proposed route-guard lemma:

```lean
theorem oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3
    (env : String -> Rat)
    (hFold : oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env) :
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution = 0 := by
  have hUncast :=
    (oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3
      env).1 hFold
  calc
    Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution =
        Coeff.evalWith env
          (blockExtractionBranchContributionSum
            oneTermRobinGamma3BoundaryBackendBranchContribution_n3) := by
          exact
            (oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
              env).symm
    _ = Coeff.evalWith env
          ((evalGateMatrices
            (GHL2025.oneTermRobinGateMatrixPlaceholders
              (oneTermParameters 3)))
            oneTermRobinGamma3BoundaryPrefixRow0_n3
            oneTermRobinGamma3BoundaryPrefixRow0_n3) := hUncast.symm
    _ = 0 := oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env
```

The Lean worker should not use:

- `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`.
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic`.
- `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

Those are diagnostic or sorry-guarded raw routes and are not theorem closure.

## Failure Analysis

The current H-free evaluated fold has the same necessary-condition problem as
the retired selected-slot feeder.  Since `BackendFold(env)` evaluates to
`SelectedSlot(env)` and `ActiveEntry(env)` evaluates to zero, an all-env proof
of the fold would force `SelectedSlot(env) = 0` for every environment.

That condition is not supplied by Eq. `ROBIN clarified`; the displayed
boundary branch is the selected gamma3 contribution, not a zero branch.
It is also not supplied by Eq. `arbitrary sparcity`; that equation supplies
only the uniform sparse-register preparation contract for the prepared route.
Existing lower3 feedback records a concrete all-one environment where the
selected contribution evaluates to `1`.  Until that finite counterexample is
formally refuted or the active/source index contract is changed, lower2 should
not attempt to close `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`
as an unconditional H-free theorem.

The correct next route is one of the following:

1. Prove the route-guard lemma above, then ask middle to retire or restate the
   H-free evaluated fold.
2. Formalize the selected-slot nonzero counterexample as a finite verifier
   lemma, which would make the current target a formal contradiction under the
   chosen environment.
3. Retarget lower2 to the source-prepared conditional bridge, keeping
   `Uniform(H)` explicit and avoiding arbitrary-`H` closure.

No oracle, `H_W`, `R_y`, LCU, unitarity, block projection, normalizer,
product-to-coefficient, block correctness, final extraction, or final theorem
flag is promoted by this packet.

## Handoff

Lower1 route guard complete.  The active H-free evaluated backend fold should
not be assigned as a closure theorem until the selected contribution is proved
identically zero or the target is restated.  The next safe lower2 leaf is
`oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3`,
which is a diagnostic necessary-condition theorem feeding a middle retarget.

This packet edits Markdown proof-control memory only.  Run the project gate:

```bash
python3 tools/qbe.py check
```
