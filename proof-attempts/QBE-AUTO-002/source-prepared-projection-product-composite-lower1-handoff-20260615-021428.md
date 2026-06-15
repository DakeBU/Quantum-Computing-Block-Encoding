# 2026-06-15 Lower1 Handoff: Source-Prepared Projection To Slot-2 Product

Task: `QBE-AUTO-002`  
Run: `20260615-021428-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `faithfulPaper`  
Leaf: `source_projection_slot2_product`

## Source Fragment

The active paper fragment is the clean projection of the full GHL2025 Fig.
`fig:1 term ROBIN` prepared sandwich for the boundary `gamma_3` branch.  The
local TeX archive path `outer_papers/quantum/GHL2025/main.tex` is absent in
this checkout, so this handoff uses the maintained source map, Fig. 4 visual
audit, cited-results ledger, and current conversion window.

The translated anchors are:

| Source anchor | Paper fragment | Lean interface |
|---|---|---|
| Eq. `arbitrary sparcity` | sparse-register preparation $H_W^{(\kappa)} |0\rangle = \kappa^{-1/2}\sum_s |s\rangle$ | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| Fig. `fig:1 term ROBIN` | theorem-facing prepared sandwich with both $H_W^{(\kappa)}$ sides | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| Definition `def:block-encoding` | read the clean signal/system projection entry | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry` |
| Eq. `ROBIN clarified` | focused boundary branch contributes the slot-`2` projected product for fixed product `3 0 0` | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct` |
| Eq. `angles for Ry` | selected boundary entry convention for `boundary_cos_half_0_2` | `hentry` hypothesis |

This fragment does not prove the fixed product-to-coefficient equality,
normalizer algebra, gate unitarity, LCU/block composition, oracle correctness,
or final block extraction.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

Define `PreparedProjectionEntry(H, env)` as:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
  .preparedProjectionEntry
```

Define `BackendFold` as:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define `ProjectedBranchProduct` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

Define `Uniform(H)` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `hentry` as:

```lean
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

## Active Local Theorem

The focused prompt names
`oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`, but the
current run dialogue and Lean source show that this leaf is already compiled.
The active lower2 theorem is therefore the composite:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
    (H : Matrix 8 8 Coeff) (env : String -> Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2)) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).preparedProjectionEntry =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

Natural-language proof: start from the evaluated source-prepared clean
projection entry.  Use `hUniform` only through
`oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3 H env
hUniform` to identify it with the evaluated backend fold.  Then use `hentry`
only through `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
env hentry` to identify the evaluated backend fold with the projected branch
product.  No matrix product expansion is needed.

The proof calculation is:

```lean
  calc
    Coeff.evalWith env
        (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
          H env).preparedProjectionEntry =
      Coeff.evalWith env
        (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
          H env).backendBranchFold :=
        oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
          H env hUniform
    _ =
      Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct :=
        oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
          env hentry
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | clean-column sparse preparation for $H_W^{(\kappa)}$ | Eq. `arbitrary sparcity`; cited sparse-preparation primitive | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger; conversion window | contract only | external contract; not proved here |
| `fig4_source_prepared_projection` | select the prepared clean projection of the full Fig. 4 sandwich | Fig. `fig:1 term ROBIN`; Definition `def:block-encoding`; Fig. 4 audit | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | conversion window | project gate | compiled target |
| `source_projection_to_backend_fold` | `PreparedProjectionEntry(H, env)` evaluates to `BackendFold` under `hUniform` | target-level prepared-backend bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | current proof map | previous full gate | compiled; stale as lower2 work |
| `backend_fold_to_slot2_projected_product` | `BackendFold` evaluates to `ProjectedBranchProduct` under `hentry` | backend fold collapse; selected-slot evaluator | none | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | bridge packet | previous full gate | compiled; stale as lower2 work |
| `source_projection_slot2_product` | `PreparedProjectionEntry(H, env)` evaluates to `ProjectedBranchProduct` | previous two bridge leaves | lower2 | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this handoff; middle composite packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `product_to_coefficient_3_0_0` | fixed product-to-coefficient equality | projection/product bridge; coefficient convention; normalizer algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligations ledger | same gate | open; not assigned |
| `backend_expansion_parent` | H-free backend-expansion parent | refuted selected-slot obstruction | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | obstruction memory | none | forbidden |

## Ordered Lean Lemmas

1. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
2. Reuse `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
3. Add only `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.

If the middle expression does not line up definitionally, lower2 should expose
the `backendBranchFold` field by `dsimp`/`rfl`; it should not introduce a new
scientific route theorem.

## Failure Analysis And Route Guard

The backend-fold-to-slot-`2` theorem is mathematically correct but stale for
this run because it is already compiled in `QuantumBlockEncoding/RobinMatrix.lean`.
Continuing to attack it would be a `stale_leaf` attempt.

The composite theorem is well-scoped.  It adds no assumptions and only composes
two compiled evaluated equalities.  It is invalid to use any of:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

## Typed Feedback

```text
leaf=source_projection_slot2_product
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=prove oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3 by composing the two compiled bridge leaves
```

## Handoff

No Lean edits were made.  Lower2 should edit only
`QuantumBlockEncoding/RobinMatrix.lean` and add exactly
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
using the two-line `calc` above.  The backend fold bridge named in the older
focused prompt is compiled route memory, not the active leaf.
