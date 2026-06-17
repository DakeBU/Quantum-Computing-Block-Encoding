# Lower1 DAG: Source-Prepared Prepared-Composite Field

Task: `QBE-AUTO-002`  
Run: `20260617-054403-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `paperBenchmark`  
Leaf: `source_prepared_prepared_composite_field`  
Timestamp: `2026-06-17 05:57:06 JST`

## 1. Source Fragment

The local archive path named by the run,
`outer_papers/quantum/GHL2025/main.tex`, is absent in this checkout.  I used
the maintained source map
`research-wiki/paper-contributions/GHL2025/source-map.md` and the Fig. 4
visual audit as the local source controls.

The source theorem remains GHL2025 Theorem `theorem: 1 term robin`
(`main.tex:1098-1109` in the source map), treated by this run as the main
block-encoding theorem.  It claims the paper construction is a block encoding
with $2n$ pure ancillas and tuple

$$
(N_D N_f \kappa,
\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4, 0).
$$

The active fragment is the boundary `gamma_3` branch from Eq.
`ROBIN clarified` (`main.tex:1111-1119`).  In the focused finite instance
`n = 3`, system entry `(0,0)`, sparse slot `2`, and signal block `[0,0]`,
the clean branch has coefficient shape

$$
{f(x_i)D_i^{(s)}\sigma^{(s)} \over N_D N_f \kappa}.
$$

Eq. `arbitrary sparcity` (`main.tex:948-955`) supplies the sparse-register
preparation contract only through
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
Fig. `fig:1 term ROBIN` (`main.tex:1122-1164`) fixes the theorem-facing gate
order with both $H_W^{(\kappa)}$ side gates and cleanup.  Definition
`def:block-encoding` (`main.tex:2027-2035`) fixes the clean block projection.

## 2. Definitions

Let `Uniform(H)` mean
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Let `ActiveEval(env)` be the evaluated active seven-gate row-zero entry:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `PreparedCompositeClean(H, env)` be the clean entry of the singleton
prepared-composite semantics:

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `PreparedSparseClean(H, env)` be the same clean entry after reducing the
singleton semantics to the prepared sparse matrix:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `SourcePreparedField(H, env)` be

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
  .activeToPreparedSingletonEvalStatement
```

Let `BackendFold(env)` be
`Coeff.evalWith env (blockExtractionBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3)`.

Let `SelectedSlot(env)` be
`Coeff.evalWith env
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`.

## 3. Natural-Language Proof Of The Local Route

The theorem-facing source route uses the prepared sandwich
$H_W^{(\kappa)\dagger} U_{\gamma_3} H_W^{(\kappa)}$.  Lean records this object
as `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`.  Its
clean entry evaluates to the prepared sparse matrix clean entry by
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.

Under `Uniform(H)`, the prepared clean entry evaluates to the backend fold.
The reusable declarations are
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` and
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
This is the valid prepared-side proof block from the source equation to the
backend branch sum.

The active seven-gate backend is not the full Fig. `fig:1 term ROBIN` circuit.
Lean records the transcript split with
`GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
`GHL2025.oneTermRobinActiveBackendCircuit_gateList`, and
`oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.

The current source-prepared active field is therefore only an obstruction
interface.  Existing equivalences reduce it to the unwrapped equality

$$
\text{ActiveEval(env)} = \text{PreparedSparseClean(H, env)}.
$$

The relevant Lean declarations are
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3`,
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSandwich_n3`, and
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`.

This proves the proof-design claim: the next Lean worker should not try to
close `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`
as an arbitrary theorem.  The source-backed local theorem is a non-promoting
audit wrapper that exposes the prepared-composite clean entry, the unwrapped
active/prepared equality still missing, and the false downstream flags.

Concurrent lower3 feedback has now checked this condition and found a finite
counterexample for the active/prepared equality under a uniform clean-column
matrix and the all-one selected-branch environment.  The useful route is
therefore narrower: preserve the prepared-composite object as source route
memory, but do not assign the active/prepared equality itself to lower2.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `ghl_one_term_robin_root` | source theorem with normalizer $N_D N_f \kappa$, Fig. 4 circuit, clean block projection, and $2n$ pure ancillas | fixed product, prepared projection, oracle contracts, resource flags | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` plus finite block fields | conversion window; source map | full gate | open |
| `source_fragment_gamma3_boundary` | boundary `gamma_3` clean coefficient for entry `(0,0)` and sparse slot `2` | Eq. `ROBIN clarified`; boundary branch condition | none | source labels only | this file | no build | source fixed |
| `uniform_sparse_prepare_contract` | all paper sparse slots have the clean-column sparse-preparation amplitude | Eq. `arbitrary sparcity`; cited preparation row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results and technical lemma ledgers | previous gate for consumers only | contract-only |
| `fig4_transcript_split` | full Fig. 4 transcript differs from active seven-gate backend | Fig. `fig:1 term ROBIN`; Fig. 4 visual audit | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | Fig. 4 audit | previous gate | compiled guard |
| `prepared_composite_semantics` | singleton semantics for $H_W^\dagger U_{\gamma_3} H_W$ clean entry | prepared sparse matrix | none | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`; `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3` | this file | previous gate | compiled route memory |
| `prepared_clean_to_backend_fold` | prepared singleton clean entry evaluates to backend branch fold under `Uniform(H)` | prepared composite clean entry; uniform clean-column contract | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | prepared projection notes | previous gate | compiled conditional |
| `source_prepared_field_unwrapped` | `SourcePreparedField(H, env)` is equivalent to `ActiveEval(env) = PreparedSparseClean(H, env)` | active/prepared field target; prepared-sandwich wrapper; clean-entry reduction | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`; `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3` | this file | previous gate | compiled obstruction map |
| `retired_hfree_evaluated_fold` | all-env H-free active entry equals backend fold | active column-zero vanish; backend fold to selected slot | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; no-go guards | lower3 05:37 diagnostic | no Lean edit | rejected; finite counterexample |
| `prepared_composite_source_projection_audit` | non-promoting wrapper exposing the prepared-composite source route, lower3 finite obstruction, retired H-free fold, and false flags | compiled nodes above; lower3 finite diagnostic | lower2 only if middle wants obstruction route memory | planned `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3` or smaller obstruction wrapper | this file and middle/lower3 packets | `python3 tools/qbe.py check` if edited | safe audit-only leaf |
| `active_prepared_composition_equality` | prove `ActiveEval(env) = PreparedSparseClean(H, env)` as the active/prepared field | prepared audit wrapper plus lower3 finite check | none | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | lower3 diagnostic | scratch Lean diagnostic plus full gate | rejected; finite counterexample |
| `fixed_product_to_coefficient_3_0_0` | close the focused product-to-coefficient obligation | active/prepared composition equality, source-prepared product route, normalizer bridge | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate | blocked |

Next active leaf for the Lean worker: no closure theorem is ready.  If middle
wants a Lean increment before retargeting, lower2 may compile only
`oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3`, or a
strictly smaller obstruction wrapper with the same dependencies.  It should
package the compiled equivalences, lower3 finite counterexample route, and
false flags, not prove
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`.

## 5. Ordered Lean Lemma Plan

1. Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`.
2. Reuse `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
3. Reuse `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
4. Reuse `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`.
5. Reuse `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
6. Reuse `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.
7. Reuse `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
8. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
9. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3`.
10. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSandwich_n3`.
11. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`.
12. Reuse `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3`.
13. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`.
14. Reuse `oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3` as a guard only.
15. Reuse lower3's scratch witness route: uniform clean-column matrix plus
    all-one selected-branch environment.
16. Reuse `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` and the two no-go guards to reject the retired H-free fold and the active/prepared equality target.
17. Reuse `oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3` only as compiled route memory.

For the planned audit wrapper, lower2 should prove tuple fields by `have`
bindings to the declarations above followed by `dsimp` over the packet records.
The wrapper must keep `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`,
normalized-block equality, LCU, block projection, block correctness, final
extraction, oracle correctness, unitarity, resource claims, post-baseline
search, and OPTCTRL flags false.

## 6. Failure Analysis

The current source-prepared prepared-composite route is mathematically useful
as an audit interface.  It is not a valid direct all-env/all-`H` closure
theorem.  The compiled obstruction map reduces the current field to the active
seven-gate entry compared with the prepared sparse clean entry, while the active
gate list still omits both $H_W^{(\kappa)}$ side gates.

With `Uniform(H)`, a proof of the active/prepared field routes through
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
and then through
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`.
That path forces selected-slot vanishing.  The already compiled
`oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` shows why
the retired H-free fold is a finite counterexample route, not a theorem target.

Lower3 has now supplied the finite witness: a uniform clean-column matrix
`H` and the all-one selected-branch environment make the active/prepared
composite statement imply `SelectedSlot(env) = 0`, while
`oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` gives
`SelectedSlot(env) = 1`.

Primary `error_class`: `finite_matrix_counterexample`.

Secondary diagnosis: `source_translation_gap`, because the theorem-facing
source route still needs a repaired projection contract that does not equate
the H-free active row-zero entry with the prepared singleton clean entry.

Next route: middle should repair the source contract or explicitly assign only
a non-promoting obstruction/audit wrapper.  Lower2 must not prove the
active/prepared composite equality, the H-free evaluated backend fold, or the
generic backend expansion/projection surfaces.

## 7. Handoff

Lower1 handoff: source-prepared prepared-composite proof design completed.
The exact source anchors are GHL2025 `main.tex:948-955`, `1098-1109`,
`1111-1119`, `1122-1164`, and `2027-2035` as recorded in the project source
map; the original `outer_papers` TeX path is absent in this checkout.  The next
Lean leaf, if any, should be only a non-promoting obstruction audit such as
`oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3`, reusing
the prepared-composite clean-entry bridge, active/prepared unwrapping lemmas,
lower3 finite counterexample route, the active seven-gate mismatch guard, and
the no-go guards.  Do not prove
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` as a
root closure theorem, and do not revive the direct H-free evaluated fold.
