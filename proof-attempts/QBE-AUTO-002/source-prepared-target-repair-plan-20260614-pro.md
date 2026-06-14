# Source-Prepared Target Repair Plan After ChatGPT Pro Review

Task: `QBE-AUTO-002`  
Date: `2026-06-14`  
Mode: `faithfulPaper`

## Verdict

The ChatGPT Pro response is directionally correct: the retired H-free feeder and
the all-environment H-free evaluated backend fold must not be revived.  The
next faithful route must keep both sides of the Fig. `fig:1 term ROBIN`
preparation, namely `H_W^(kappa)` and `(H_W^(kappa))^dagger`, in the theorem
object.

There is one important local correction.  In the current Lean file, the names

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

still compare the old active H-free signal-zero entry against the prepared
clean entry.  Under the explicit clean-column contract

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

the existing compiled bridge sends this comparison back to the retired H-free
backend fold.  Therefore these names are useful as diagnostic wrappers, but
they should not be assigned as the main theorem-closing target until middle has
checked or restated the source-facing left-hand side.

The source-facing target should instead be the clean projection of the prepared
composite circuit itself:

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
=
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

This prepared clean-entry bridge already has compiled support through

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
```

The next run should promote this as the theorem-facing prepared projection
route, while keeping downstream product, LCU, block-correctness, and final
extraction flags false.

## Next 6h Focus

1. Upper must update the proof-DAG root from "prove active H-free entry equals
   prepared clean entry" to "use prepared clean projection as the Fig. 4
   theorem-facing block entry".
2. Middle must write the source correspondence packet explaining that Fig. 4's
   block-entry object is the prepared composite clean projection, not the
   H-free seven-gate `[0,0]` entry by itself.
3. Lower3 must run a necessary-condition check that the prepared clean-entry
   route has no finite counterexample under the all-one selected branch and
   `hUniform`, and that the H-free active route remains retired.
4. Lower2 should first prove the cheap diagnostic guard only if it is still
   useful:

```lean
oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3
```

   This guard is not theorem closure.  If it closes quickly, lower2 should then
   add one theorem-facing prepared-projection route theorem reusing the compiled
   prepared clean-entry bridge.  If it does not close quickly, stop and let
   middle restate the target rather than spending the whole run on the guard.
5. Reviewer must reject any route that uses either diagnostic `sorry`, raw
   `Coeff` constructor equality, the retired H-free fold, or the direct row-`0`
   to selected-slot feeder.

## Agent Scheduling Fix

The previous batch spent too much time on upper/middle/reviewer repetition and
did not run a lower proof after the latest source-prepared retarget.  The next
6h run should use this order:

1. one upper director pass, not the full upper panel unless stale leaves are
   detected;
2. middle source-correspondence and memory refresh;
3. lower1 and lower3 in parallel;
4. lower2 only after lower1/lower3 confirm the exact source-prepared leaf;
5. one reviewer pass after lower2 edits or after lower2 explicitly reports a
   blocker;
6. final Chinese summary and ChatGPT Pro prompt once per 6h batch.

