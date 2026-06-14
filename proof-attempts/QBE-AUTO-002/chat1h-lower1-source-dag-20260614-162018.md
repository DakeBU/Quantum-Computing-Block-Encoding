# QBE-AUTO-002 lower1 source DAG: prepared projection restatement

Owner: `lower1-natural-language-proof-architect`

Leaf: `prepared_projection_restatement_leaf`

## Verdict

The theorem-facing Fig. 4 clean projection should be restated as:

```text
PreparedCleanEntry(H, env) = BackendFold(env)
```

under the explicit clean-column contract:

```text
Uniform(H)
```

In Lean names, this is already the compiled bridge:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
```

and the source-target field wrapper:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
```

This is the correct next source-faithful leaf because Fig. 4/Definition
`def:block-encoding` selects the clean entry after both sparse-register side
preparations.  It is not the raw H-free seven-gate `[0,0]` entry by itself.

## Local abbreviations

```text
Uniform(H)
  := oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H

PreparedCleanEntry(H, env)
  := Coeff.evalWith env
       ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
         oneTermRobinGamma3BoundarySparseCleanIndex_n3
         oneTermRobinGamma3BoundarySparseCleanIndex_n3)

BackendFold(env)
  := Coeff.evalWith env
       (blockExtractionBranchContributionSum
         oneTermRobinGamma3BoundaryBackendBranchContribution_n3)

ActivePreparedOld(H, env)
  := oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

The source-target record version of `PreparedCleanEntry` is:

```lean
let target := oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
Coeff.evalWith env target.preparedProjectionEntry
```

and its backend side is:

```lean
Coeff.evalWith env target.backendBranchFold
```

## Source-faithful DAG

| Node | Claim | Lean reuse | Status |
|---|---|---|---|
| `D0_uniform_contract` | Eq. `arbitrary sparcity` supplies only the clean-column sparse preparation contract for `H_W^(kappa)`. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | contract-only hypothesis |
| `D1_clean_index` | Fig. 4 clean projection selects the sparse clean-clean entry after the prepared sandwich. | `oneTermRobinGamma3BoundarySparseCleanIndex_n3`; `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | compiled |
| `D2_prepared_clean_entry` | The theorem-facing LHS is the prepared composite clean entry, not the H-free active `[0,0]` entry. | `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | compiled |
| `D3_singleton_to_backend` | Under `Uniform(H)`, the prepared clean entry evaluates to the backend branch fold. | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | compiled bridge |
| `D4_record_field_route` | The same equality is exposed through the source-prepared target fields `preparedProjectionEntry` and `backendBranchFold`. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | compiled |
| `D5_product_map_consumption` | The prepared clean-entry backend bridge can be carried to the focused product-map layer without proving product, LCU, block, or final extraction. | `oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3`; `oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3` | route wiring only |
| `D6_diagnostics_retired` | The H-free fold and old active/prepared comparison remain diagnostics because they route to selected-slot vanishing under `Uniform(H)`. | declarations listed below | do not use as theorem closure |

Dependency order:

```text
D0_uniform_contract
  -> D3_singleton_to_backend

D1_clean_index
  -> D2_prepared_clean_entry
  -> D3_singleton_to_backend
  -> D4_record_field_route
  -> D5_product_map_consumption

D6_diagnostics_retired is a side guard only, not a parent of the theorem-facing leaf.
```

## Why this is the Fig. 4 theorem-facing projection

Fig. 4's clean block entry is the selected entry of the prepared composite
object:

```text
H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)
```

The `H_W^(kappa)` gates are not decoration.  They are the sparse-register
preparation and cleanup that make the clean-column projection equal the paper's
backend branch fold after the `Uniform(H)` contract is applied.  Therefore the
left side must be the prepared composite clean entry.

The H-free seven-gate active entry is only the internal boundary component
before the sparse-register side preparations are selected.  Treating that
entry as the theorem-facing clean projection silently drops both `H_W^(kappa)`
sides and changes the source object.

## Why the old H-free routes are diagnostic only

The old H-free fold:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

is retired as an all-environment theorem target.  Existing compiled normal form
identifies it with selected-slot vanishing:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
```

but the finite witness:

```lean
oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3
```

shows the selected gamma3 contribution is nonzero in the all-one environment.
So the H-free fold is useful as obstruction memory only.

Likewise `ActivePreparedOld(H, env)` is diagnostic.  In the current Lean file
it still compares the old active signal-zero entry with the prepared clean
entry:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Under `Uniform(H)`, compiled bridge declarations route this old comparison back
to the retired evaluated backend fold:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3
```

That route is valid as a guard showing the old target would force selected-slot
zero behavior.  It is not valid as closure of the Fig. 4 theorem-facing clean
projection.

## Exact Lean declarations to reuse

Primary prepared-projection leaf:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
oneTermRobinGamma3BoundarySparseCleanIndex_n3
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3
```

Source-prepared target field wrappers:

```lean
OneTermRobinGamma3BoundarySourcePreparedProjectionTarget
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3
```

Focused product-map route witnesses:

```lean
oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_preparedProjectionBackendEval_n3
oneTermRobinGamma3BoundaryFocusedProductObligation_preparedCompositeCleanEntryBackendEval_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3
oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
```

Diagnostic-only declarations:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3
```

## Lower2-ready theorem shape

No new mathematical proof is needed for this leaf; lower2 can expose the
already compiled bridge under a restatement name if middle wants a new named
leaf:

```lean
theorem oneTermRobinGamma3BoundaryPreparedProjectionRestatement_leaf_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
        ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
          oneTermRobinGamma3BoundarySparseCleanIndex_n3
          oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
      Coeff.evalWith env
        (blockExtractionBranchContributionSum
          oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :=
  oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
    H env hUniform
```

Record-field variant:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_restatement_leaf_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    let target :=
      oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
    Coeff.evalWith env target.preparedProjectionEntry =
      Coeff.evalWith env target.backendBranchFold :=
  oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
    H env hUniform
```

Recommended lower2 action: reuse one of the existing declarations directly
unless a fresh theorem name is required for queue bookkeeping.  Do not assign
the retired H-free fold or `ActivePreparedOld` as the main proof target.
