# Evaluated Backend-Fold Source Bridge Lower1 DAG

Task: `QBE-AUTO-002`  
Run: `20260617-051350-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `paperBenchmark`  
Leaf checked: `evaluated_backend_fold_source_bridge`  
Verdict: do not release the direct all-env evaluated fold, raw prepared-sandwich field, generic projection, or backend-expansion statement to lower2 as a closure theorem.

## 1. Source Fragment

The source theorem remains GHL2025 Theorem `theorem: 1 term robin`, treated by
this run as the main Theorem 3 benchmark.  The relevant local TeX anchors are:

| Source anchor | Local role |
|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}$ prepares $\kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$; QBE may use only the existing clean-column contract. |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | source block-encoding tuple $(N_DN_f\kappa, \lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ with $2n$ pure ancillas. |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | boundary $\gamma_3$ branch with coefficient denominator $N_DN_f\kappa$ and sparse slots $s=0,\dots,\kappa-1$. |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing circuit includes the sparse-preparation layer around the central Robin backend. |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the clean signal block is selected after the unitary action. |

For the focused branch, Eq. `ROBIN clarified` contributes the boundary slice
$$
\ket{\gamma_3}_{\mathrm{bdry}}
  = {1 \over N_D N_f \kappa}
    \sum_{s,\;j\ \mathrm{boundary}}
      f(x_i)D_i^{(s)}\sigma^{(s)}
      \ket{0}^{m_f+1}\ket{s}\ket{0}^{n-\lceil\log_2\kappa\rceil}
      \ket{j}\ket{0}
    + \cdots .
$$
The ellipsis is part of the paper branch split.  For this lower leaf, only the
boundary branch with system entry $(0,0)$ and sparse slot $2$ is in scope.

## 2. Definitions Before Claims

`Uniform(H)` means
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
This is the external clean-column contract from Eq. `arbitrary sparcity`.

`ActiveEntryEval(env)` is
`Coeff.evalWith env oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`.
Equivalently, it is the evaluated clean `[0,0]` entry of the active seven-gate
backend.

`BackendFoldEval(env)` is
`Coeff.evalWith env (blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3)`.

`PreparedCleanEval(H, env)` is the evaluated clean-clean entry of
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`.

`PreparedEntry(H, env)` is
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.

`SelectedSlotEval(env)` is
`Coeff.evalWith env oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`.

`EvaluatedFold(env)` is
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, namely
`ActiveEntryEval(env) = BackendFoldEval(env)`.

`RawPreparedSandwichField(H)` is
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`.

## 3. Natural-Language Proof and Route Check

The source-prepared part of the route is correct and already compiled.  Under
`Uniform(H)`, the prepared clean entry evaluates to the backend fold:
`PreparedCleanEval(H, env) = BackendFoldEval(env)`.  This is the content of
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` and
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
It is a theorem-facing prepared projection fact, not a proof that the H-free
active seven-gate entry is already the full Fig. `fig:1 term ROBIN` projection.

If a future lower worker supplies an active-to-prepared composition theorem
`ActiveEntryEval(env) = PreparedCleanEval(H, env)`, then `EvaluatedFold(env)`
follows by transitivity.  Lean already has this route as
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
and the target equivalence
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_activeEval_iff_statement_n3`.
This implication is route wiring only; it does not prove the missing
active-to-prepared composition theorem.

The direct target `EvaluatedFold(env)` is not a valid all-env lower theorem.
Lean proves
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`,
so `EvaluatedFold(env)` is equivalent to `SelectedSlotEval(env) = 0`.
The no-go proof for
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` uses the concrete
environment with `f_3_0 = 1`, `N_f_inv = 1`, `boundary_cos_half_0_2 = 1`,
`sqrt_kappa_inv = 1`, and all other symbols zero; in that environment
`oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` gives
`SelectedSlotEval(env) = 1`.  Thus a theorem proving `EvaluatedFold(env)` for
arbitrary `env` would force `1 = 0`.

The raw prepared-sandwich field is not an escape hatch.  Under `Uniform(H)`,
`oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`
identifies `RawPreparedSandwichField(H)` with the already refuted backend
expansion surface.  A lower worker should not prove that raw field as source
closure unless middle first restates a physically constrained theorem-facing
prepared circuit contract that avoids the all-env H-free equality.

Therefore the current source-backed proof contribution is negative: the direct
H-free evaluated fold, raw prepared-sandwich field, generic projection, and
backend expansion are rejected as closure targets.  The next useful Lean leaf
is a non-promoting audit wrapper, not a proof of `EvaluatedFold(env)`.

## 4. Proof-DAG Table

| Node id | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `ghl_one_term_robin_root` | Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding` | open baseline root | upper/middle | keep source theorem fixed; no post-baseline search |
| `uniform_sparse_prepare_contract` | Eq. `arbitrary sparcity`, cited Shukla--Vedula row | contract-only | none | reuse only as explicit `hUniform` |
| `source_corrected_product_feeder` | prepared slot-`2` product, normalizer hypotheses, fixed product obligation, no-go guards | compiled; retired | none | reuse `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3` only as route memory |
| `prepared_clean_backend_eval` | `Uniform(H)`, prepared composite semantics | compiled conditional | none | reuse prepared clean-entry backend evaluator |
| `active_to_prepared_composition` | active seven-gate entry, prepared clean entry, Fig. `fig:1 term ROBIN` transcript | open but not currently proved | later lower2 | only attempt after middle gives a source-correct finite statement |
| `hfree_evaluated_backend_fold_direct` | active H-free entry, backend fold | finite counterexample for all-env closure | none | do not assign as theorem closure |
| `raw_prepared_sandwich_field` | raw field, `Uniform(H)`, backend-expansion equivalence | inherits rejected backend-expansion route under `hUniform` | none | do not use as direct closure |
| `generic_projection_or_backend_expansion` | projection/backend equivalence and all-one diagnostic | refuted | none | keep `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` and `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` as guards |
| `evaluated_backend_fold_source_bridge_audit` | compiled feeder, evaluated target transcript, selected-slot-zero equivalence, no-go guards | next safe active leaf | lower2 if Lean edit is requested | compile only a non-promoting audit wrapper with all theorem flags false |
| `fixed_product_to_coefficient_3_0_0` | prepared finite projection route, normalizer algebra, final coefficient bridge | blocked | later | do not assign directly |

Next active leaf for a Lean worker:
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3`, if middle
still wants a Lean increment.  Its interface should package the compiled route
memory and the no-go facts while keeping `EvaluatedFold(env)`,
`FixedProductObligation`, normalized-block equality, LCU, block projection,
block correctness, final extraction, oracle correctness, unitarity, and
resource flags false.

## 5. Intermediate Lean Lemmas To Reuse

1. `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`: the active
   seven-gate backend omits both `H_W^(kappa)` and its dagger.
2. `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`:
   explicit external clean-column contract; do not prove it here.
3. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`:
   unfolds the prepared composite clean entry.
4. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`:
   under `hUniform`, the prepared clean entry evaluates to the backend fold.
5. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`:
   theorem-facing prepared projection entry evaluates to the backend fold.
6. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedCleanEntryFeedsProductMap_n3`:
   product-map route memory for the prepared clean entry.
7. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`:
   uncasts the H-free evaluated fold to the active `evalGateMatrices` entry.
8. `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`:
   collapses the evaluated backend fold to the selected slot contribution.
9. `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`:
   the active H-free clean entry evaluates to zero on the relevant column.
10. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`:
    direct evaluated fold is equivalent to `SelectedSlotEval(env) = 0`.
11. `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`:
    the all-one diagnostic environment gives selected slot value `1`.
12. `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`:
    refutes the unchanged backend-expansion statement.
13. `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`:
    refutes the unchanged generic projection-summation statement.
14. `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`:
    shows the raw prepared-sandwich field is not a safe direct closure target
    under `hUniform`.
15. `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`:
    compiled non-promoting feeder into the fixed product route.

## 6. Failure Analysis

The current target is mathematically wrong if lower2 is asked to prove
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` for arbitrary
`env`, or to prove `RawPreparedSandwichField(H)` under the same all-env
H-free closure interpretation.  The failure is not that the source theorem is
false.  The failure is that the direct Lean target has lost the paper's
register-level prepared projection: it compares the active seven-gate H-free
entry against a backend fold that carries the nonzero source-prepared branch.

Primary `error_class`: `finite_matrix_counterexample`.

Next route: keep the source-prepared product and normalizer feeder as compiled
route memory, then either compile a non-promoting audit wrapper for
`evaluated_backend_fold_source_bridge` or have middle restate the finite
block/projection contract so the theorem-facing block uses the prepared
composite semantics instead of the H-free active backend entry.  Do not add an
environment hypothesis, do not mutate Fig. `fig:1 term ROBIN`, and do not
start candidate improvement or OPTCTRL work before the GHL baseline closes.

## 7. Handoff

lower1 handoff: source audit and Lean route check for
`evaluated_backend_fold_source_bridge` completed.  The exact source anchors are
GHL2025 `main.tex:948-955`, `1098-1109`, `1111-1119`, `1122-1164`, and
`2027-2035`.  The direct all-env `EvaluatedFoldStatement(env)` is rejected:
Lean reduces it to selected-slot vanishing, while the all-one environment makes
the selected slot equal `1`.  `RawPreparedSandwichField(H)` is also unsafe as a
closure target because it is equivalent to the refuted backend expansion under
`hUniform`.  No Lean edit made.  Recommended next lower2 action, if any, is a
non-promoting audit wrapper that records the mismatch and keeps all theorem
flags false.
