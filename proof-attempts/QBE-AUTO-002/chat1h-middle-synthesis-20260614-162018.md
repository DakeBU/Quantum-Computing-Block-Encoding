# Chat1h Middle Synthesis: Prepared Projection Route

Task: `QBE-AUTO-002`  
Run: `runs/20260614-162018-QBE-AUTO-002-chat1h`  
Time: `2026-06-14 16:25 JST`

## Middle Verdict

The dynamic queue is now correctly focused on
`prepared_projection_restatement_leaf`.  After inspecting
`QuantumBlockEncoding/RobinMatrix.lean`, the prepared-projection route is not an
empty plan: several theorem-facing wrappers are already compiled.

Important compiled declarations:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_preparedProjectionBackendEval_n3
oneTermRobinGamma3BoundaryFocusedProductObligation_preparedProjectionBackendEval_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedProjectionBackendEval_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3
oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3
```

These declarations already expose the prepared clean-entry/backend equality
under the explicit external contract

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

and keep downstream product, LCU, block-projection, block-correctness, and final
extraction flags false.

## What Is Still Not Closed

The following is still not proved and should not be silently assumed:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

This statement compares the H-free active signal-zero entry to the prepared
clean entry.  Under `hUniform`, existing bridges route it back to the retired
H-free evaluated backend fold.  Therefore it is diagnostic unless the source
target is restated.

The two remaining `sorry` declarations are still diagnostic raw/H-free bridges:

```lean
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

They should not be used as theorem closure.

## Lower2 Recommendation

The best one-hour lower2 target is the cheap guard:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hActive :
      oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env) :
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution = 0
```

Expected proof:

```lean
  have hFold :=
    oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
      H env hUniform hActive
  exact
    (oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
      env).1 hFold
```

This guard would make the source-translation problem explicit: if the old
active/prepared field is assumed under uniform preparation, the selected gamma3
slot is forced to vanish, contradicting the compiled all-one nonzero witness.

