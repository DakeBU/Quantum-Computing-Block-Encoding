# Source-Prepared Projection/Product Bridge Middle Packet

Task: `QBE-AUTO-002`  
Run: `20260615-015440-QBE-AUTO-002-cycle01`  
Role: middle coordinator synthesis  
Mode: `faithfulPaper`  
Created: `2026-06-15 02:05 JST`

## Source Status

The local TeX path named by the focused prompt,
`outer_papers/quantum/GHL2025/main.tex`, is not present in this checkout.
This packet therefore relies on the maintained source map
`research-wiki/paper-contributions/GHL2025/source-map.md`, the Fig. 4 visual
audit, the cited-results row for GHL2025, and the compiled Lean transcript
records.  Public-facing anchors remain GHL2025 Eq. `arbitrary sparcity`,
Eq. `ROBIN clarified`, Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`, and
Definition `def:block-encoding`.

## Definitions

Fix `env : String -> Rat`.

`BackendFold` denotes:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

`SelectedSlot` denotes:

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

`ProjectedBranchProduct` denotes:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

`hentry` is the selected boundary-entry convention:

```lean
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

The already compiled source-prepared wrapper uses a separate hypothesis
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
That hypothesis belongs only to
`oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.

## Current Lean Frontier

The packet and first wrapper are compiled and stale as lower2 targets:

```lean
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
```

The active lower2 target is:

```lean
theorem oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
    (env : String -> Rat)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2)) :
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

The proof is the two-step evaluated bridge:

```lean
calc
  Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution :=
      oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
        env
  _ =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct :=
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3
        env hentry
```

## Source-to-Lean Map

| Source anchor | Paper step used here | Lean representation | Status |
|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ clean-column sparse preparation. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external contract; already consumed by the compiled wrapper |
| GHL2025 Fig. `fig:1 term ROBIN` | full source-prepared sandwich with both $H_W$ sides | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | compiled source-prepared target |
| GHL2025 Definition `def:block-encoding` | clean projection entry | `.preparedProjectionEntry` of the source-prepared target | compiled wrapper to backend fold |
| GHL2025 Eq. `ROBIN clarified` | focused boundary gamma3 slot-`2` branch | `SelectedSlot`; `ProjectedBranchProduct`; fixed product `3 0 0` | active evaluated bridge; coefficient theorem still open |
| GHL2025 Eq. `angles for Ry` | selected boundary rotation entry | `hentry` | explicit hypothesis for selected-slot evaluator |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | clean-column sparse preparation for $H_W^{(\kappa)}$ | Eq. `arbitrary sparcity`; cited sparse-preparation primitive | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results and conversion window | contract only | external contract; not proved here |
| `source_prepared_product_packet` | route packet tying source target, fixed product `3 0 0`, finite bridge, and false flags | source-prepared target; finite product bridge; product route | none | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` | earlier middle/lower packets | previous full gate | compiled; stale |
| `source_projection_to_backend_fold` | prepared projection entry evaluates to backend fold under `hUniform` | compiled target-level source-prepared backend bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | lower2 handoff and this packet | previous full gate | compiled; stale as lower2 work |
| `backend_fold_to_slot2_projected_product` | backend fold evaluates to slot-`2` projected product under `hentry` | backend fold collapse; selected-slot evaluator | lower2 | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `source_projection_slot2_product` | compose source-prepared projection with slot-`2` projected product | previous two bridge leaves | lower2 after active leaf | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this packet | same gate | open composite |
| `product_to_coefficient_3_0_0` | prove fixed product-to-coefficient equality | projection/product bridge; boundary coefficient convention; normalizer algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | same gate | open; not assigned |

## Lower Packets

Lower1 already wrote the natural-language DAG at
`proof-attempts/QBE-AUTO-002/source-prepared-projection-product-bridge-lower1-dag-20260615-013025.md`.

Lower3 already checked the necessary finite shape at
`verifier-feedback/QBE-AUTO-002/source-prepared-projection-product-bridge-lower3-20260615-013025.json`.
It confirmed clean index `0`, focused sparse slot `2`, full branch basis index
`32`, fixed product `3 0 0`, no backend-expansion dependency, no diagnostic
`sorry` dependency, and no theorem-flag promotion.

Lower2 should now edit only `QuantumBlockEncoding/RobinMatrix.lean` and prove
exactly `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
Do not introduce new assumptions, new route definitions, new `sorry`, raw
`Coeff` constructor equality, or a proof of product-to-coefficient, LCU,
block correctness, unitarity, normalizer, oracle correctness, or final
extraction.

## Typed Feedback

```text
leaf=backend_fold_to_slot2_projected_product
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=prove oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3, then compose oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```
