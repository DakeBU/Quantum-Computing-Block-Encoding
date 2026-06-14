# QBE-AUTO-002 lower1 product/active DAG: post prepared-projection wrapper

Owner: `lower1-natural-language-proof-architect`

Leaf: `post_prepared_projection_product_leaf`

Date: 2026-06-14

## Verdict

After the prepared projection wrapper, the logically earlier theorem-facing
leaf is the focused product-to-coefficient equality for

```lean
oneTermRobinGamma3ProductToCoefficientObligation
  3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

The active/prepared finite-composition equality is earlier only in the stale
route whose left side is still the H-free active seven-gate `[0,0]` entry.  In
the corrected source-facing route, the wrapper has already selected the
prepared clean projection

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
```

and compiled its backend equality under the explicit clean-column contract.
Therefore the next useful lower leaf is not another active/prepared wrapper; it
is the finite product/coefficient bridge attached to the fixed `(0,0)` boundary
product obligation.

## Source-facing dependency order

The corrected source route is:

```text
Eq. arbitrary sparcity
  -> prepared clean-clean projection of H_W^(kappa)^dagger * U_gamma3 * H_W^(kappa)
  -> backend branch fold
  -> focused slot-2 boundary product map
  -> product-to-coefficient equality for oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
```

The route is not:

```text
H-free active row0,row0 seven-gate entry
  -> row0,row0 feeder
  -> raw Coeff matrix equality
  -> product-to-coefficient
```

The prepared projection wrapper already has compiled witnesses:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3
oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
```

These expose the prepared clean-entry backend bridge beside the fixed product
map while keeping `productToCoefficientProved`, normalized block equality, LCU,
block projection, block correctness, and final extraction false.

## Candidate A: active/prepared finite-composition equality

This candidate has exact existing Lean shapes:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3
  (H : Matrix 8 8 Coeff) (env : String → Rat) : Prop
```

whose body is:

```lean
Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  Coeff.evalWith env
    ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
      oneTermRobinGamma3BoundarySparseCleanIndex_n3
      oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

The uncast equivalent is:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
  (H : Matrix 8 8 Coeff) (env : String → Rat) : Prop
```

with body:

```lean
Coeff.evalWith env
    ((evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders
        (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3) =
  Coeff.evalWith env
    ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
      oneTermRobinGamma3BoundarySparseCleanIndex_n3
      oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

The cached raw-entry form is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

and the record-field form is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env)
  .activePreparedCompositeEvalStatement
```

Classification: this is not the immediate source-facing leaf after the
prepared projection wrapper.  It compares a H-free active entry with the
prepared clean entry.  The current mismatch witness

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3
```

shows that the active side omits both `H_W^(kappa)` side gates.  Under
`hUniform`, this route feeds the retired evaluated backend fold and selected
slot-zero obstruction.  Keep it as diagnostic or as a repair target only if a
downstream statement still insists on the H-free active left side.

## Candidate B: product-to-coefficient equality for `(3,0,0)`

This is the immediate source-facing leaf after the prepared projection wrapper.
The semantic obligation is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation
  3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

The compiled boundary product interface is:

```lean
oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3
```

It fixes:

```text
system row = 0
system column = 0
sparse slot = 2
clean source = 32
branch entry = oneTermRobinGamma3BoundarySevenGateMatrix_n3[32,32]
ket-zero factors =
  [1, 1, boundary_cos_half_0_2, 1, f_3_0 * N_f_inv, 1, 1]
```

The strongest existing branch-entry evaluator is:

```lean
oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedCoefficientExpanded_n3
    (env : String → Rat)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2)) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        oneTermRobinGamma3BoundaryPrefixSource_n3
        oneTermRobinGamma3BoundaryPrefixSource_n3) =
      Coeff.evalWith env
        (Coeff.mul
          (Coeff.mul (GHL2025.robinFunctionValue 3 0)
            (Coeff.symbol "N_f_inv"))
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2))
```

The source-facing product equality should be stated at the projection target
layer, not at raw matrix-constructor level.  The lower2-ready theorem shape is:

```lean
theorem oneTermRobinGamma3BoundaryProductToCoefficientEquality_n3
    (env : String → Rat)
    (H : Matrix 8 8 Coeff)
    (hUniform :
      H
        ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnRowIndex,
          by native_decide⟩
        ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnColIndex,
          by native_decide⟩ =
        oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.expectedUniformColumnEntry)
    (hND : env "N_D_inv" * env "N_D" = 1)
    (hNF : env "N_f_inv" * env "N_f" = 1)
    (hkappa : env "kappa_inv" * env "kappa" = 1)
    (hkappaSqrt :
      env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
        env "kappa_inv")
    (hProjection :
      Coeff.evalWith env
          oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalBlockEntry =
        Coeff.evalWith env
          oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct) :
    Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalBlockEntry *
      Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.theoremNormalizer =
    Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.expectedTargetEntry
```

This theorem consumes the existing algebraic route:

```lean
oneTermRobinGamma3BoundaryProductUnderContractsEval_n3
```

and the missing finite projection/summation field:

```lean
hProjection :
  eval(signalBlockEntry) = eval(projectedBranchProduct)
```

The exact smaller finite leaf, if lower2 wants to split the proof, is therefore:

```lean
theorem oneTermRobinGamma3BoundaryProjectionSummation_slot2_to_signalBlock_n3
    (env : String → Rat) :
    Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalBlockEntry =
      Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

or a branch-selection version feeding it through:

```lean
oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3
```

This is still downstream of the prepared projection wrapper and upstream of
LCU/block/final extraction.

## Forbidden routes

Do not use the H-free row-`0`, row-`0` feeder as source closure:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

This is the active backend component only.  It omits the theorem-facing
`H_W^(kappa)` and `(H_W^(kappa))^dagger` side gates.

Do not use the raw `Coeff` matrix equality route:

```lean
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

These are diagnostic raw constructor equalities, not the source-facing
prepared projection/product route.  They must not be consumed to prove
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Proof-DAG delta

| Node | Interface | Status | Next action |
|---|---|---|---|
| `prepared_projection_wrapper` | prepared clean entry evaluates to backend fold under the clean-column contract | compiled | reuse only |
| `active_prepared_finite_composition` | H-free active `[0,0]` equals prepared clean entry | diagnostic/stale for corrected source route | do not assign unless the target still exposes active `[0,0]` |
| `product_boundary_interface_300` | slot-`2` boundary product data for `(0,0)` | compiled interface | reuse |
| `projection_summation_slot2` | signal block entry `[0,0]` equals projected slot-`2` branch product after evaluation | open finite leaf | prove or split |
| `product_to_coefficient_300` | projected product times theorem normalizer equals `A_k[0,0]` | immediate source-facing target after wrapper | prove after `projection_summation_slot2` |
| `hfree_row0_row0_feeder` | active seven-gate `[0,0]` feeder | forbidden as closure | diagnostic only |
| `raw_coeff_matrix_equality` | raw symbolic matrix equality | forbidden as closure | diagnostic only |

## Handoff

Lower2 should not spend the next pass on another active/prepared wrapper.  The
prepared projection wrapper is already in the fixed product map.  The next
source-facing mutation is the finite projection/product equality for
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, preferably split
first as the slot-`2` projection-summation theorem feeding
`oneTermRobinGamma3BoundaryProductUnderContractsEval_n3`.
