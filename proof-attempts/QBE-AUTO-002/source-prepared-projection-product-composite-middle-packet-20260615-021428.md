# Source-Prepared Projection/Product Composite Middle Packet

Task: `QBE-AUTO-002`
Run: `20260615-021428-QBE-AUTO-002-cycle01`
Role: middle coordinator synthesis
Mode: `faithfulPaper`
Created: `2026-06-15 02:18 JST`

## Source Status

This packet follows the upper handoff in
`runs/20260615-021428-QBE-AUTO-002-cycle01/dialogue.md`.  The local TeX path
advertised by older focused prompts is absent in this checkout, so the public
source anchors remain GHL2025 Eq. `arbitrary sparcity`, Eq. `ROBIN clarified`,
Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`, as recorded in the maintained source map and proof
exports.

The source-prepared product/projection packet and both bridge leaves are
compiled route memory:

```lean
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
```

They are stale as lower2 targets.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

`SourceProjection` denotes:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
    H env).preparedProjectionEntry
```

`BackendFold` denotes:

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

`ProjectedBranchProduct` denotes:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

`hUniform` is:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

`hentry` is:

```lean
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

## Active Lean Leaf

Lower2 should edit only `QuantumBlockEncoding/RobinMatrix.lean` and prove
exactly:

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

The proof route is:

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

The hypothesis `hUniform` enters only in the source-prepared bridge.  The
hypothesis `hentry` enters only in the selected-slot projected-product bridge.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | clean-column sparse preparation for $H_W^{(\kappa)}$ | Eq. `arbitrary sparcity`; cited sparse-preparation primitive | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results and conversion window | contract only | external contract; not proved here |
| `source_prepared_product_packet` | route packet tying source target, fixed product `3 0 0`, finite bridge, and false flags | source-prepared target; finite product bridge; product route | none | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` | earlier middle/lower packets | previous full gate | compiled; stale |
| `source_projection_to_backend_fold` | prepared projection entry evaluates to backend fold under `hUniform` | compiled source-prepared backend bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | bridge packet | previous full gate | compiled; stale |
| `backend_fold_to_slot2_projected_product` | backend fold evaluates to slot-`2` projected product under `hentry` | backend fold collapse; selected-slot evaluator | none | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | bridge packet | previous full gate | compiled; stale |
| `source_projection_slot2_product` | source-prepared projection evaluates to slot-`2` projected product | previous two bridge leaves | lower2 | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `product_to_coefficient_3_0_0` | fixed product-to-coefficient equality | projection/product bridge; boundary coefficient convention; normalizer algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | same gate | open; not assigned |

## Forbidden Routes

Do not use:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

Do not promote product-to-coefficient, normalizer, LCU/block, oracle,
unitarity, block-correctness, or final-extraction flags.

## Lower Packets

Lower1: the existing natural-language DAG remains sufficient.  Update it only
if lower2 finds a statement mismatch.

Lower2: prove exactly the active Lean leaf above in
`QuantumBlockEncoding/RobinMatrix.lean`.

Lower3: recheck finite shape only if lower2 changes the statement shape.  The
expected shape is clean index `0`, focused sparse slot `2`, full branch basis
index `32`, fixed product `3 0 0`, no backend-expansion dependency, no
diagnostic `sorry` dependency, and no theorem-flag promotion.

## Typed Feedback

```text
leaf=source_projection_slot2_product
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=prove oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3 by composing the two compiled bridge leaves
```
