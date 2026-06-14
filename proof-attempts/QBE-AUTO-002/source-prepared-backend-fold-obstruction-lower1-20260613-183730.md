# 2026-06-13 Lower1 Obstruction DAG: Backend Fold Retarget

Task: `QBE-AUTO-002`  
Run: `20260613-182230-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`  
Leaf family: `branch_correct_evaluated_backend_fold_obstruction`

## Source Fragment

The source-paper fragment is GHL2025 Eq. `arbitrary sparcity`, Eq.
`ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

Equation `arbitrary sparcity` supplies the sparse-register preparation
contract:

$$
H_W^{(\kappa)} |0\rangle
  = \frac{1}{\sqrt{\kappa}} \sum_{s=0}^{\kappa - 1} |s\rangle .
$$

Equation `ROBIN clarified` displays the Robin boundary part of
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

Fig. `fig:1 term ROBIN` is the theorem-facing prepared circuit: the
seven-gate backend component sits between the sparse-preparation side gates,
and the block-encoding definition selects a clean signal projection entry.
The displayed boundary branch is a real selected branch contribution.  The
source fragment does not state a selected-branch vanish condition.

## Definitions

For fixed `env : String -> Rat`, define `ActiveEntry(env)` as:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define `BackendFold(env)` as:

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

Define `SelectedSlot(env)` as:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

Define `Uniform(H)` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The retired root fold is the proposition `ActiveEntry(env) = BackendFold(env)`
packaged by `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

## Natural-Language Proof

The current H-free root fold is not a remaining tactic problem.  It reduces to
a scalar vanish condition for the selected branch.

First, the active side is the H-free row-`0` entry.  Lean names the uncast
active comparison with
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`.
The compiled row-`0` tail-kill theorem
`oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env` proves
`ActiveEntry(env) = 0`.

Second, the backend side is the seven-slot branch fold.  The compiled backend
fold theorem
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env`
proves `BackendFold(env) = SelectedSlot(env)`.

Therefore any proof of the retired root fold gives `SelectedSlot(env) = 0`.
This calculation is already compiled as
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3 env`.

The preferred obstruction leaf is the converse finite witness: take the
all-one selected-slot environment

```lean
let env : String -> Rat :=
  fun name =>
    if name = "f_3_0" then 1
    else if name = "N_f_inv" then 1
    else if name = "boundary_cos_half_0_2" then 1
    else if name = "sqrt_kappa_inv" then 1
    else 0
```

The selected contribution is the selected seven-gate branch entry multiplied
by the two sparse-register projection amplitudes.  The branch entry evaluates
by `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3` to
`(env "f_3_0" * env "N_f_inv") * env "boundary_cos_half_0_2"`, and the
projection amplitude factor is
`Coeff.mul (Coeff.symbol "sqrt_kappa_inv") (Coeff.symbol "sqrt_kappa_inv")`.
Under the displayed environment, both factors evaluate to `1`, so
`SelectedSlot(env) = 1`.

This proves that the all-environment H-free fold cannot be assigned as a Lean
closure theorem in the current row/register shape.  `Uniform(H)` remains
downstream-only: it is needed for source-prepared recovery, not for a
standalone H-free selected-slot vanish claim.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_boundary_branch` | Eq. `ROBIN clarified` supplies the selected boundary contribution, not a vanish assumption | source equation; Fig. `fig:1 term ROBIN` | none | source transcript only | this packet | none | source checked |
| `active_column0_zero_eval` | `ActiveEntry(env) = 0` | row-`0` finite tail kill | none | `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env` | lower3 diagnostic | project gate | proved |
| `backend_fold_to_selected_eval` | `BackendFold(env) = SelectedSlot(env)` | backend slot vanish feeders | none | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | backend fold packets | project gate | proved |
| `fold_selected_zero_normal_form` | root H-free fold iff `SelectedSlot(env) = 0` | `active_column0_zero_eval`; `backend_fold_to_selected_eval`; uncast fold bridge | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3 env` | lower2 18:19 packet | project gate | proved |
| `selected_slot_nonzero_counterexample` | concrete all-one `env` with `SelectedSlot(env) = 1` | selected seven-gate product eval; projection amplitude factor; coefficient evaluation | lower2 | proposed `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` | middle obstruction packet; this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active leaf |
| `fold_forces_selected_zero_guard` | any root fold proof implies `SelectedSlot(env) = 0` | normal-form lemma | lower2 fallback | proposed `oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3` | lower1 route guard; this packet | same gate | fallback leaf |
| `hfree_evaluated_backend_fold` | prove `ActiveEntry(env) = BackendFold(env)` for all `env` | would require selected-slot vanish | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | old 18:00 packet | none | retired; `finite_matrix_counterexample` |
| `source_prepared_retarget` | resume source-prepared proof search after the obstruction is formalized and target is restated | obstruction leaf; source audit; explicit `Uniform(H)` | middle/later | no new Lean theorem yet | future packet | none | blocked |

The next active Lean leaf is
`oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`.  The
fallback is the route-guard implication if the nonzero witness needs more
coefficient algebra than expected.

## Intermediate Lean Lemmas

Lower2 should reuse these declarations in dependency order:

1. `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`:
   evaluates the selected seven-gate entry at full index `32`.
2. `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`:
   records the all-slot contribution shape as seven-gate branch entry times
   `sqrt_kappa_inv * sqrt_kappa_inv`.
3. `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3`:
   exposes `selectedSlotContribution` as the typed slot-`2` contribution.
4. `oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript`, or direct
   definitional simplification of `oneTermRobinGamma3BoundaryBranchEntrySelection_n3`:
   identifies the projection amplitude factor with
   `Coeff.mul (Coeff.symbol "sqrt_kappa_inv")
     (Coeff.symbol "sqrt_kappa_inv")`.
5. `Coeff.evalWith_mul` and ordinary `Rat` simplification:
   evaluate the all-one selected-slot environment to `1`.
6. Fallback only:
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`
   closes
   `oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3`.

Suggested preferred theorem:

```lean
theorem oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3 :
    let env : String -> Rat :=
      fun name =>
        if name = "f_3_0" then 1
        else if name = "N_f_inv" then 1
        else if name = "boundary_cos_half_0_2" then 1
        else if name = "sqrt_kappa_inv" then 1
        else 0
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
      = 1 := by
  ...
```

Suggested fallback theorem:

```lean
theorem oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3
    (env : String -> Rat)
    (hFold : oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env) :
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution = 0 := by
  exact
    (oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
      env).1 hFold
```

## Failure Analysis

The current target
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` is
mathematically wrong as an all-environment H-free theorem for the current Lean
row/register interpretation.  The compiled normal form says the target is
equivalent to `SelectedSlot(env) = 0`, while the source equation treats the
selected boundary branch as a contribution and the all-one selected-slot
environment evaluates it to `1`.

The direct strict feeder
`oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env` remains a
`shape_or_register_gap`: it compares active full index `0` with selected
sparse slot `2` at full index `32`.  A proof route that adds `hUniform` to the
H-free fold would also be invalid, because Eq. `arbitrary sparcity` supplies
the prepared sparse-register clean-column contract only for downstream
source-prepared recovery.

No oracle, `H_W`, `R_y`, LCU, unitarity, block projection, normalizer,
product-to-coefficient, block correctness, or final-extraction flag is
promoted by this packet.

## Handoff

Lower1 obstruction map complete.  Lower2 should prove exactly one formal
obstruction leaf, preferably
`oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`; use
`oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3`
only as a fallback if the concrete witness is delayed.  After one obstruction
leaf compiles, middle/reviewer should restate the source-prepared target before
new proof search.

This packet edits Markdown proof-control memory only.

Gate note: `python3 tools/qbe.py check` was started after this Markdown/JSON
edit.  It ran for about six hours inside `lake build`, with Lean compiling
`QuantumBlockEncoding/RobinMatrix.lean` continuously and without returning an
exit code.  The non-completing gate process was terminated and should be
classified as `blocked_gate_noncompletion`, not as a Lean theorem failure from
this Markdown-only lower1 packet.  Because the `qbe.py check` build never
returned, the separate `lake build && lake build Tests` gate was not run.

Concurrent status update: after this lower1 packet was written, a concurrent
lower2 artifact reported that the preferred witness
`oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`
compiled and passed the project gate.  Future lower work should not reassign
that witness or the retired H-free fold; middle/reviewer should retarget the
source-prepared row/register theorem.
