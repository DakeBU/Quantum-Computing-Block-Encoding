# QBE-AUTO-002 Active Seven-Gate Prepared Mismatch Leaf

Date: 2026-06-09
Role: lower 2, Lean implementation worker
Mode: faithfulPaper

## Lean Leaf

Compiled declaration:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3
oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3
```

The theorem records that
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`
is equivalent to the evaluated active seven-gate entry
`evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3))[0,0]`
equals `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`.
It also reuses `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` to
show that the active gate list contains neither `H_W^(kappa)` nor
`(H_W^(kappa))^dagger`.

The second theorem records the same target-shape fact at
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3`: its
`evaluatedBackendFoldStatement` unfolds to the active seven-gate `[0,0]`
comparison against `backendBranchFold`, with both `H_W` side gates still absent
from the active gate list.

## Result

This is a typed mismatch witness, not a proof of the raw-entry prepared
sandwich field.  The current active left-hand side is still the seven-gate
slot-`0` active backend entry, while the right-hand side is the prepared
all-slot sparse-register sandwich.  Proving these equal by column-`0` slot-`0`
diagnostics would not reproduce the source route for the displayed slot-`2`
gamma3 branch.  The evaluated backend-fold target is therefore also guarded as
an H-free active-entry target, not a theorem-facing prepared-entry target.

The added column-`0` guard packages
`oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` with syntactic
separation from the slot-`2` Ry symbols:
`boundary_cos_half_0_0 != boundary_cos_half_0_2` and
`boundary_sin_half_0_0 != boundary_sin_half_0_2` as `Coeff.symbol`
constructors.  This records the failed route precisely: column `0` selects
slot `0`, so it cannot be used as the displayed gamma3 slot-`2` prepared
branch bridge.

## Remaining Goal

The remaining branch-correct Lean target is a finite composition theorem that
selects a theorem-facing prepared signal entry or otherwise proves the active
signal-zero entry equals the prepared singleton clean entry without deleting
the two $H_W^{(\kappa)}$ sides:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

The raw `Coeff` constructor equality route remains diagnostic/backlog.

## Gate

Focused gate and project gate passed:

```bash
lake env lean QuantumBlockEncoding/RobinMatrix.lean
python3 tools/qbe.py check
```

Only the pre-existing diagnostic sorries were reported.
