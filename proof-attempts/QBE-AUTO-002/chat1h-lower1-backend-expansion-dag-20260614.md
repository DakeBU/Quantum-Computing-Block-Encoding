# Lower1 backend-expansion DAG for `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`

Date: 2026-06-14.

Scope: architecture note only.  No Lean edit is requested.  The target is the
single backend/projection leaf

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

## Source Shape

The source object is the GHL2025 one-term Robin boundary `gamma3` clean branch:
Eq. `ROBIN clarified`, Fig. `1-term ROBIN`, and Definition
`def:block-encoding`.  For the finite witness `n = 3`, system entry `(0,0)` is
represented by sparse slot `2`, full clean branch index `32`, and the
signal-zero block/unitary entry at row and column `0`.

The source coefficient convention is:

```text
seven-gate branch entry [32,32]
  = f_3_0 * N_f_inv * boundary_cos_half_0_2

projection amplitude factor
  = sqrt_kappa_inv * sqrt_kappa_inv

projected selected contribution
  = seven-gate branch entry [32,32] * sqrt_kappa_inv * sqrt_kappa_inv
```

The theorem normalizer route later rewrites this into the usual
`N_D * N_f * kappa` normalization for the product-to-coefficient obligation.
That later normalization is not part of this backend-expansion leaf.

## Reduction DAG

The target has already been reduced to one branch-sum theorem:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3 :
  oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement ↔
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
      oneTermRobinGamma3BoundaryBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Equivalently, using the compiled signal-entry bridge:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3 :
  oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement ↔
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

So the proof should close this equality:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

and then apply `.2` of
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

## Branch Sum

The concrete branch family is already defined:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_n3 (s : Fin 7) =
  oneTermRobinGamma3BoundarySevenGateMatrix_n3
    (oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s)
    (oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s)
  * oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor
```

Compiled branch-sum support:

- `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` gives the
  all-slot formula with amplitude product
  `sqrt_kappa_inv * sqrt_kappa_inv`.
- `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` expands the
  fold into the seven diagonal full-index summands.
- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
  proves that after evaluation the fold collapses to the selected slot-`2`
  contribution because slots `0`, `1`, `3`, `4`, `5`, and `6` evaluate to zero.

That last fact is an evaluated simplifier, not the raw backend expansion theorem.

## Selected Slot

The selected branch is compiled:

```lean
oneTermRobinGamma3BoundaryBranchContributionFocusedSlot : Fin 7 := 2
```

and the selected summand theorem is compiled:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3 :
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
      oneTermRobinGamma3BoundaryBranchContributionFocusedSlot =
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

The selected contribution is

```lean
Coeff.mul
  (oneTermRobinGamma3BoundarySevenGateMatrix_n3
    oneTermRobinGamma3BoundaryPrefixSource_n3
    oneTermRobinGamma3BoundaryPrefixSource_n3)
  oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor
```

with `oneTermRobinGamma3BoundaryPrefixSource_n3 = 32`.

## Unique Path

The slot-`2` branch path is already evaluated.  The compiled path is:

```text
32 -> 32 -> 32 -> 32 -> 0 -> 0 -> 0 -> 32
```

Relevant compiled facts:

- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3_transcript`
  records slot `2`, full index `32`, and the factor list.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryPrefixSupport_n3` proves the
  four-gate prefix from column `32` has evaluated support only in rows `0` and
  `1`.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateSupport_n3`
  kills every intermediate row except row `0` for the final row-`32`, column-`32`
  product.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateUniquePath_n3`
  applies `Matrix.evalWith_mul_unique_path`.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`
  proves the selected branch entry evaluates to
  `(env "f_3_0" * env "N_f_inv") * env "boundary_cos_half_0_2"`.

This proves the selected branch entry.  It does not yet prove that the
signal-zero block/unitary entry is the sum over all sparse slots.

## Coefficient Conventions

Compiled coefficient facts:

- `oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3` connects
  `[32,32] * projectionAmplitudeFactor` to the route's `projectedBranchProduct`,
  conditional on the corrected boundary-rotation entry.
- `oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3` proves the symbolic
  product `sqrt_kappa_inv * sqrt_kappa_inv = kappa_inv` under an explicit
  environment hypothesis.
- `oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3` packages
  that same symbolic product in the projection-amplitude semantics packet.
- `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` gives the downstream
  coefficient route under explicit `N_D`, `N_f`, `kappa`, and `sqrt_kappa`
  hypotheses.

These are coefficient algebra and contract-routing lemmas.  They should be used
after the backend expansion or as side conditions for the product route, not as
a replacement for the branch-sum theorem.

## Already Compiled

Use these facts as existing nodes, not new lower targets:

- `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivProjection_n3`
- `oneTermRobinGamma3BoundaryBackendProjectionStatement_equivBranchSum_n3`
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`
- `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`
- `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`
- `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`
- `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`
- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`
- `oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3`
- `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`

Do not use the retired H-free all-env evaluated fold as theorem closure.  The
compiled diagnostic
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`
together with `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`
shows why that route is not source-correct as an unconditional proof path.

## Exact Missing Lemma

The exact missing lemma is the finite projection/backend branch-sum theorem:

```lean
theorem oneTermRobinGamma3BoundarySignalUnitaryEntry_eq_backendBranchSum_n3 :
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
    blockExtractionBranchContributionSum
      oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  -- missing: prove the signal-zero block/unitary entry expands as the
  -- seven-slot sparse branch fold.
```

Once this lemma exists, the requested target closes by:

```lean
exact
  (oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3).2
    oneTermRobinGamma3BoundarySignalUnitaryEntry_eq_backendBranchSum_n3
```

If the proof is routed through the prepared sparse-register sandwich instead,
the equivalent missing field is:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H)
  .rawEntryPreparedSandwichStatement
```

under

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

via `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`.
That is a valid reduction, but it is conditional on the explicit `H_W^(kappa)`
clean-column contract.  The H-free core target remains the signal-unitary
entry equals the seven-slot backend branch fold.
