# Backend-Expansion Route-Retarget Lower Proof Architect Postscript

Task: `QBE-AUTO-002`
Run: `20260615-030358-QBE-AUTO-002-cycle01`
Role: `lower1-natural-language-proof-architect`
Mode: `faithfulPaper`
Created: `2026-06-15 03:20 JST`

## Source Status

The private TeX source `outer_papers/quantum/GHL2025/main.tex` is absent in
this checkout.  This postscript therefore uses the checked-in source map and
public anchors already named by middle: GHL2025 Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Definition `def:block-encoding`, Theorem
`theorem: 1 term robin`, the maintained GHL2025 proof notes, and
`research-wiki/cited-results/GHL2025.md`.

## Source Fragment

The translated fragment is the boundary gamma3 branch of Eq. `ROBIN clarified`
for the focused finite instance `n = 3`, system entry `(0,0)`, and sparse slot
`2`, read through the clean block-entry projection in Definition
`def:block-encoding` and the prepared sparse-register route in Fig.
`fig:1 term ROBIN`.

The source-facing branch/product step is the prepared clean projection, not the
raw H-free seven-gate signal entry.  In Lean, that source-facing equality is
already compiled as:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

Middle has also compiled the route-retarget guard:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3
```

## Definitions

`SourceSlot2Product(H, env)` is the evaluated equality

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
    H env).preparedProjectionEntry =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

`FixedProductObligation` is

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`BackendExpansionRaw` is

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

## Natural-Language Proof Of The Local Guard

Assume `hUniform`, the existing all-slot clean-column contract for
`H_W^(kappa)`, and assume `hentry`, the boundary-entry convention for
`boundary_cos_half_0_2`.

The theorem
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
applies directly to `H`, `env`, `hUniform`, and `hentry`.  It gives
`SourceSlot2Product(H, env)`.

The route-retarget guard then unfolds only bookkeeping records:
`oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` and
`oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`.  After those
records are unfolded, the fixed product obligation is definitionally
`FixedProductObligation`, and every downstream flag in the packet and bridge is
definitionally `false`.  The proof is therefore a composition of the compiled
slot-`2` source-prepared equality with record-field reflexivity.  It does not
prove `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `backend_expansion_raw_no_go` | raw H-free backend expansion, equivalent to `SignalEntryFold` | all-one selected-slot counterexample | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | lower1/lower3 correction packets | no-go theorem compiled | refuted; forbidden |
| `source_projection_to_backend_fold` | source-prepared projection equals backend fold under `hUniform` | prepared clean-entry evaluator; clean-column contract | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | source-prepared route packets | previous full gate | compiled route memory |
| `backend_fold_to_slot2_product` | backend fold equals slot-`2` projected product under `hentry` | selected-slot fold collapse; boundary entry convention | none | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | source-prepared route packets | previous full gate | compiled route memory |
| `source_projection_slot2_product` | `SourceSlot2Product(H, env)` under `hUniform` and `hentry` | previous two bridge nodes | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | source-prepared composite packets | previous full gate | compiled route memory |
| `source_slot2_product_fixed_map_guard` | attach `SourceSlot2Product(H, env)` to `FixedProductObligation` while all downstream flags remain false | `source_projection_slot2_product`; finite product bridge records | none for lower2 now | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | middle retarget packet and this postscript | current gate | compiled; stale as a lower2 target |
| `product_to_coefficient_3_0_0` | prove the focused coefficient equality and normalizer algebra | retarget guard; boundary coefficient convention; product-under-contracts route | future upper/middle packet | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | future gate | open; next theorem-facing packet |

Next active Lean leaf for this directive: none.  The only assignable lower2
target in the current directive is already present.  Future work should prepare
a new coefficient/normalizer packet for `product_to_coefficient_3_0_0`.

## Intermediate Lean Lemmas

1. Reuse
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`
   for the prepared clean-entry to backend-fold evaluation under `hUniform`.

2. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` to
   expose that equality through the source-prepared projection target.

3. Reuse
   `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
   and
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`
   for the backend-fold collapse to the selected slot.

4. Reuse
   `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` for the
   boundary-entry bridge to the projected branch product.

5. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
   as the compiled source-facing branch/product equality.

6. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`,
   `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`, and
   `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3` only as record
   interfaces with false downstream flags.

7. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3`
   as completed route memory.  Do not reassign it as a proof-search target.

8. Treat
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`
   and `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` as no-go
   memory for `BackendExpansionRaw`, not as dependencies for theorem closure.

## Failure Analysis

The unchanged `BackendExpansionRaw` target is mathematically invalid for this
frontier.  If it held, the compiled route would force the selected slot
contribution to evaluate to `0`, but the all-one selected-branch witness
evaluates the same contribution to `1`.  Lean records this contradiction in
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.

The current route-retarget guard is mathematically acceptable but no longer
active implementation work: it is already compiled.  Lower2 should therefore
make no Lean edit on this directive and classify the guard as `stale_leaf` if
assigned after this postscript.  The next theorem-facing work is not another
branch-sum/backend-expansion statement; it is a new product-to-coefficient and
normalizer packet for the fixed `(3,0,0)` obligation.

## Typed Feedback

```text
leaf=source_slot2_product_fixed_map_guard
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=false
closed_theorem_ok=true
product_to_coefficient_ok=false
error_class=stale_leaf
next_route=prepare a coefficient/normalizer packet for oneTermRobinGamma3ProductToCoefficientObligation 3 0 0; do not revive backendExpansionStatement
```

## Handoff

Lower proof-architect postscript complete.  The route-retarget guard
`oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3`
is compiled and should be retired as a lower target.  The raw backend expansion
remains refuted/source-contract-gap.  The next useful packet is a
coefficient/normalizer proof design for
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.
