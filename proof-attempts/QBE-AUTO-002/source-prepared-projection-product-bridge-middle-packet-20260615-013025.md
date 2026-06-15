# Source-Prepared Projection/Product Bridge Middle Packet

Task: `QBE-AUTO-002`  
Run: `20260615-013025-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Created: `2026-06-15 01:40 JST`

## Directive

The source-prepared product/projection packet is compiled and stale as a lower2
target:

```lean
OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript
```

The active leaf is now the source-prepared projection-to-projected-product
evaluated bridge.  It starts from the clean projection of the full Fig.
`fig:1 term ROBIN` prepared sandwich

```text
(H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa)
```

and routes it to the slot-`2` projected branch product.  Do not revive the
H-free evaluated-fold closure, the selected-slot strict feeder, or the refuted
backend-expansion parent.

## Definitions

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

`SourcePreparedTarget(H, env)` means:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

`PreparedProjectionEntry(H, env)` means:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
  .preparedProjectionEntry
```

`BackendFold` means:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

`ProjectedBranchProduct` means:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

The boundary coefficient-entry hypothesis for the selected branch is:

```lean
hentry :
  env "boundary_cos_half_0_2" =
    Coeff.evalWith env
      (GHL2025.boundaryRotationNormalizedCoefficient
        (oneTermParameters 3) 0 2)
```

## Source Anchors

| Anchor | Role in this packet | Lean representation |
|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | supplies the clean-column sparse-preparation contract | `hUniform` |
| GHL2025 Fig. `fig:1 term ROBIN` | theorem-facing full prepared sandwich with both `H_W` sides | `SourcePreparedTarget(H, env)` |
| GHL2025 Definition `def:block-encoding` | clean signal/system projection | `PreparedProjectionEntry(H, env)` |
| GHL2025 Eq. `ROBIN clarified` | boundary gamma3 slot-`2` product | `ProjectedBranchProduct` and fixed product `3 0 0` |
| GHL2025 Eq. `angles for Ry` | boundary coefficient entry used by the selected-slot evaluator | `hentry` |
| Fig. 4 visual audit | separates full prepared route from H-free backend component | `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` |

## Existing Lean Material To Reuse

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | clean-column contract for all sparse slots of $H_W^{(\kappa)}$ | GHL2025 Eq. `arbitrary sparcity`; cited sparse-preparation primitive | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results and conversion window | contract only | external contract; not proved here |
| `source_prepared_product_packet` | route packet tying source target, fixed product `3 0 0`, finite bridge, and false flags | source-prepared target; finite product bridge; product route | none | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` | previous packet and lower3 feedback | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | compiled; stale as lower2 target |
| `source_projection_to_backend_fold` | evaluated prepared projection entry equals the backend fold under `hUniform` | compiled source-prepared bridge | lower2 | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | this packet | same gate | active leaf if absent |
| `backend_fold_to_slot2_projected_product` | backend fold evaluates to the slot-`2` projected branch product under `hentry` | backend fold collapse; selected-slot product evaluator | lower2 after wrapper | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | this packet | same gate | next mathematical leaf |
| `source_projection_slot2_product` | compose source projection with slot-`2` projected product | previous two bridge leaves | lower2 after both leaves | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this packet | same gate | open composite |
| `product_to_coefficient_3_0_0` | prove fixed product-to-coefficient equality | projection/product bridge; normalizer algebra; boundary coefficient convention | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligations ledger | same gate | open; not assigned |
| `backend_expansion_parent` | stale backend-expansion statement | refuted by selected-slot nonzero guard | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | obstruction memory | none | forbidden |

## Lower 1 Packet

Role: natural-language proof architect.

Write scope:

```text
proof-attempts/QBE-AUTO-002/source-prepared-projection-product-bridge-lower1-dag-20260615-013025.md
```

Task:

1. Define `SourcePreparedTarget`, `PreparedProjectionEntry`, `BackendFold`,
   `ProjectedBranchProduct`, `hUniform`, and `hentry` before stating claims.
2. Translate the source anchors above into a proof-DAG table.
3. Explain why the compiled product/projection packet is stale as a lower2
   target but remains route memory.
4. Identify the first lower2 target:
   `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
5. Identify the next mathematical target:
   `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`, then
   the composite
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
6. State that `hUniform` enters only at the source-prepared projection wrapper
   and `hentry` enters only at the selected-slot-to-projected-product step.

Acceptance:
no Lean edits, no new assumptions, no theorem-flag promotion.

## Lower 2 Packet

Role: Lean implementation worker.

Write scope:

```text
QuantumBlockEncoding/RobinMatrix.lean
```

First target if absent:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).preparedProjectionEntry =
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).backendBranchFold := by
  exact
    oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
      H env hUniform
```

If that theorem is already present, prove exactly this next leaf:

```lean
theorem oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
    (env : String → Rat)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2)) :
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct := by
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

Do not use:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

Acceptance:

- `python3 tools/qbe.py check`;
- `lake build`;
- `lake build Tests`;
- no new `sorry`, `admit`, axiom, raw `Coeff` constructor theorem closure, or
  semantic flag promotion;
- no proof of product-to-coefficient, LCU, block correctness, unitarity,
  normalizer, oracle correctness, or final extraction.

## Lower 3 Packet

Role: necessary-condition verifier.

Write scope:

```text
verifier-feedback/QBE-AUTO-002/source-prepared-projection-product-bridge-lower3-20260615-013025.json
```

Checks:

1. The route starts from `PreparedProjectionEntry(H, env)`, not the H-free
   active row-`0` entry.
2. The source-prepared clean index remains
   `oneTermRobinGamma3BoundarySparseCleanIndex_n3 = 0`.
3. The focused branch remains sparse slot `2`, full branch basis index `32`,
   and fixed product obligation `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.
4. `hUniform` is used only to identify the prepared projection with the backend
   fold; `hentry` is used only for the selected-slot product evaluator.
5. No dependency on the refuted backend-expansion parent or the two diagnostic
   `sorry` declarations.
6. No product, LCU, block, normalizer, unitarity, oracle, or final flag is
   promoted.

Typed feedback baseline:

```text
leaf=source_prepared_projection_to_projected_branch_product
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=null
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3, then oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
```

Use `stale_leaf` if a lower attempt repeats the compiled product/projection
packet.  Use `invalid_route` if an attempt adds assumptions, changes the paper
construction, or uses the backend-expansion parent.
