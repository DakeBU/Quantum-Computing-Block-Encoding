# Source-Prepared Product/Projection Plan After ChatGPT Pro Review

Task: `QBE-AUTO-002`
Date: `2026-06-15`
Mode: `faithfulPaper`

## Verdict

The ChatGPT Pro response is correct enough to become the next 6h directive.
The active proof root must no longer be the H-free backend fold, the direct
row-`0` to selected slot feeder, or the active/prepared comparison that routes
back to the retired H-free fold under `hUniform`.

The next Lean target should first be a bookkeeping/proof-DAG packet:

```lean
OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation
```

with an `n = 3` instance that records the theorem-facing source-prepared route.
Only after this packet compiles should lower agents attack the first small
mathematical leaf: the source-prepared clean projection to focused slot-`2`
projected branch product.

## Compiled Material To Reuse

The prepared clean projection/backend bridge is already available:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3
```

The fixed product obligation remains:

```lean
oneTermRobinGamma3ProductToCoefficientObligation
  3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

The branch data to preserve are:

```text
system row = 0
system column = 0
sparse slot = 2
clean source full index = 32
branch entry = oneTermRobinGamma3BoundarySevenGateMatrix_n3[32,32]
ket-zero factors = [1, 1, boundary_cos_half_0_2, 1, f_3_0 * N_f_inv, 1, 1]
```

## Required New Packet

Suggested structure fields:

```lean
structure OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation where
  sourceTarget : OneTermRobinGamma3BoundarySourcePreparedProjectionTarget
  productRoute : OneTermRobinGamma3BoundaryProductUnderContractsRoute
  productBridge : OneTermRobinGamma3BoundaryFiniteProjectionProductBridge
  preparedBackendEvalStatement : Prop
  fixedProductObligation : SemanticObligation
  forbiddenBackendExpansionParent : Bool
  preparedBackendEvalCompiled : Bool
  productRouteConsumed : Bool
  normalizedBlockEqualityProved : Bool
  productToCoefficientProved : Bool
  lcuCorrectProved : Bool
  blockProjectionProved : Bool
  blockCorrectProved : Bool
  finalExtractionProved : Bool
  exactRemainingObstruction : String
```

The concrete packet should set:

```lean
sourceTarget :=
  oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env

fixedProductObligation :=
  oneTermRobinGamma3ProductToCoefficientObligation
    3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩

preparedBackendEvalStatement :=
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
    .preparedSingletonToBackendEvalStatement

forbiddenBackendExpansionParent := true
preparedBackendEvalCompiled := true
productRouteConsumed := false
normalizedBlockEqualityProved := false
productToCoefficientProved := false
lcuCorrectProved := false
blockProjectionProved := false
blockCorrectProved := false
finalExtractionProved := false
exactRemainingObstruction :=
  "Need source-prepared slot-2 projection/product bridge, then normalizer algebra."
```

The transcript theorem should prove by `rfl`/`dsimp` that these fields are
exactly the intended objects.  It must not unfold the large matrix products.

## First Mathematical Leaf After The Packet

Preferred next theorem shape:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
    =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

This leaf may be decomposed into:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
```

The first should be a direct wrapper over the compiled source-prepared bridge.
The second is the real finite projection/product bridge and must not use the
retired `backendExpansionStatement`.

## Later Leaves

Only after the source-prepared projection/product leaf compiles, attack:

```lean
oneTermRobinGamma3BoundaryProjectedBranchProduct_eval_correctedCoefficient_n3
oneTermRobinGamma3BoundarySlot2Product_normalizedCoefficientEval_n3
oneTermRobinGamma3ProductToCoefficientObligation_3_0_0_of_sourcePrepared_n3
```

The normalizer assumptions belong to these local algebra leaves, not to the
bookkeeping packet:

```lean
env "N_D_inv" * env "N_D" = 1
env "N_f_inv" * env "N_f" = 1
env "kappa_inv" * env "kappa" = 1
env "sqrt_kappa_inv" * env "sqrt_kappa_inv" = env "kappa_inv"
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

## Forbidden Routes

Do not use or revive:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

Also do not use the following active/prepared diagnostic names as the main
route:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

They are useful diagnostics, but under `hUniform` they can route back to the
retired selected-slot-zero obstruction.

## Reviewer Checks

After lower2 edits Lean, lower3/reviewer must verify:

1. The new packet's `sourceTarget` is
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.
2. The fixed product obligation is exactly
   `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.
3. `forbiddenBackendExpansionParent = true`.
4. All downstream flags remain false.
5. No new theorem depends on the refuted backend expansion or the two
   diagnostic `sorry` declarations.
6. `hUniform` is used only where the source-prepared bridge requires it.
7. The $R_y$ boundary coefficient remains explicit through the existing
   `hentry` convention; no silent angle-convention change is introduced.
