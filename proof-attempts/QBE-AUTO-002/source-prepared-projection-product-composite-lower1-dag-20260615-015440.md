# 2026-06-15 Lower1 DAG: Source-Prepared Projection To Projected Product

Task: `QBE-AUTO-002`
Run: `20260615-015440-QBE-AUTO-002-cycle01`
Role: lower1 natural-language proof architect
Mode: `faithfulPaper`
Leaf: `source_projection_slot2_projected_product_composite`

## Source Fragment

The focused source fragment is the clean projection of the full GHL2025 Fig.
`fig:1 term ROBIN` construction for the boundary `gamma_3` branch.  The local
TeX archive path named in the focused prompt,
`outer_papers/quantum/GHL2025/main.tex`, is absent in this checkout.  This
note therefore uses the maintained source map
`research-wiki/paper-contributions/GHL2025/source-map.md`, the Fig. 4 visual
audit, and the compiled source transcript in
`QuantumBlockEncoding/GHL2025.lean`.

The translated paper fragment has three pieces:

1. GHL2025 Eq. `arbitrary sparcity`, main.tex lines 948-955 in the source map,
   supplies only the sparse-register clean-column contract:

   $$
   H_W^{(\kappa)} |0\rangle =
   \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle .
   $$

2. GHL2025 Fig. `fig:1 term ROBIN`, main.tex lines 1122-1164 in the source
   map, makes the theorem-facing object the prepared sandwich with both
   $H_W^{(\kappa)}$ sides.  Lean records this source transcript as
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit`.

3. GHL2025 Eq. `ROBIN clarified`, main.tex lines 1111-1119 in the source map,
   supplies the boundary `gamma_3` clean-branch coefficient.  For the focused
   finite instance, this is the slot `2` projected branch product attached to
   fixed product obligation `oneTermRobinGamma3ProductToCoefficientObligation
   3 0 0`.  GHL2025 Eq. `angles for Ry`, main.tex lines 1077-1085 in the
   source map, supplies the selected boundary-entry convention used as
   `hentry`.

No source step in this fragment proves the fixed product-to-coefficient
obligation, normalizer algebra, `R_y` unitarity, LCU composition, block
correctness, or final extraction.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

Define `SourcePreparedTarget(H, env)` as:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

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

Define `hentry` as the boundary selected-entry convention:

```lean
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

## Active Local Theorem

Both bridge leaves requested earlier in this run are now present in
`QuantumBlockEncoding/RobinMatrix.lean`:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
```

The next lower2 target should therefore be the composite:

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

Natural-language proof:

Start with `PreparedProjectionEntry(H, env)`.  The hypothesis `hUniform`
enters exactly once, through
`oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3 H env
hUniform`, to identify the evaluated prepared projection entry with
`BackendFold`.

Then apply
`oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3 env hentry`.
The hypothesis `hentry` enters exactly once in that compiled bridge, where the
selected symbolic boundary entry
`boundary_cos_half_0_2` is identified with
`GHL2025.boundaryRotationNormalizedCoefficient (oneTermParameters 3) 0 2`.

The complete proof is the two-link calculation:

```text
eval PreparedProjectionEntry(H, env)
  = eval BackendFold
  = eval ProjectedBranchProduct.
```

No matrix product should be unfolded.  The proof should not use the
backend-expansion parent, the H-free evaluated fold, the old selected-slot
feeder, or diagnostic `sorry` declarations.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | Clean-column sparse preparation for $H_W^{(\kappa)}$. | Eq. `arbitrary sparcity`; cited sparse-preparation primitive. | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | source map; cited-results memory | contract only | external contract; not proved here |
| `fig4_source_prepared_projection` | Select prepared clean projection of the full Fig. 4 sandwich. | Fig. `fig:1 term ROBIN`; Definition `def:block-encoding`; Fig. 4 audit. | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`; transcript theorem | conversion window | project gate | compiled |
| `source_prepared_product_packet` | Record source target, fixed product `3 0 0`, finite bridge, and false flags. | source-prepared target; product route; finite product bridge. | none | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`; transcript theorem | earlier lower packets | previous full gate | compiled; stale as lower2 work |
| `source_projection_to_backend_fold` | `PreparedProjectionEntry(H, env)` evaluates to `BackendFold` under `hUniform`. | target-level source-prepared backend bridge. | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | current run packets | project gate | compiled |
| `backend_fold_to_slot2_projected_product` | `BackendFold` evaluates to `ProjectedBranchProduct` under `hentry`. | backend fold collapse; selected-slot evaluator. | none | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | current run packets | project gate | compiled leaf; gate passed in this lower1 attempt |
| `source_projection_slot2_product` | `PreparedProjectionEntry(H, env)` evaluates to `ProjectedBranchProduct`. | previous two compiled bridge leaves. | lower2 | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this note | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active leaf |
| `product_to_coefficient_3_0_0` | Prove fixed product-to-coefficient equality. | projection/product bridge; boundary coefficient convention; normalizer algebra. | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligations ledger | same gate | open; not assigned |
| `backend_expansion_parent` | H-free backend-expansion parent. | refuted selected-slot obstruction. | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | obstruction packets | none | forbidden |

## Ordered Lean Lemmas For Lower2

1. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
2. Reuse
   `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
3. Add only
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.

The expected proof script is:

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

If Lean does not reduce the middle expression definitionally, lower2 should
first expose that
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
.backendBranchFold` is `BackendFold` by `rfl`/`dsimp`, not by introducing a new
route theorem.

## Failure Analysis And Route Guard

The composite target is mathematically well-scoped.  It is not a replacement
for the paper construction and it does not add assumptions beyond the two
already explicit bridge contracts.  It only composes two compiled evaluated
equalities.

The current route would become invalid if a proof uses any of these names as a
dependency:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

The next unresolved mathematical blocker after the composite is the fixed
product-to-coefficient theorem `oneTermRobinGamma3ProductToCoefficientObligation
3 0 0`, including coefficient equality and normalizer algebra.  That is a
later leaf, not part of this composite.

## Typed Feedback

```text
leaf=source_projection_slot2_projected_product_composite
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

Lower1 proof design complete.  No Lean edits were made.  The packet,
source-projection wrapper, and backend-fold-to-slot-2 projected-product leaf
are all compiled route memory.  The next Lean worker should add exactly the
composite theorem
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
in `QuantumBlockEncoding/RobinMatrix.lean`, using only the two compiled bridge
leaves above.

Gate result for this lower1 attempt:

```text
python3 tools/qbe.py check: pass
lake build: pass
lake build Tests: pass
warnings: existing diagnostic sorry warnings in QuantumBlockEncoding/RobinMatrix.lean
```
