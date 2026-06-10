# QBE-AUTO-002 Lower2 Attempt: Expanded Slot-0 Fold Guard

Created: 2026-06-09 17:19 JST

## Closed Lean Leaf

`QuantumBlockEncoding/RobinMatrix.lean` now contains:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3
```

The theorem rewrites the evaluated backend-fold target to the uncast active
`evalGateMatrices` entry against the expanded backend fold.  The expanded fold
has the slot-`0` summand visible as

```lean
Coeff.mul
  (oneTermRobinGamma3BoundarySevenGateMatrix_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
  oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor
```

and leaves backend slots `1` through `6` explicit.

Dependencies used:

| Dependency | Role |
|---|---|
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | removes the block-extraction cast from the evaluated target |
| `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` | exposes the weighted slot-`0` backend summand and slots `1`-`6` |
| `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | records that the active gate list is H-free |

## Remaining Goal

This does not prove
`oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`.
The remaining support theorem must either match or eliminate the expanded
backend slots `1` through `6` and account for the projection amplitude factor.

The proof route must not collapse to
`oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` as source closure:
that diagnostic expands the active `[0,0]` seven-gate entry through slot `0`,
whereas Eq. `ROBIN clarified` uses the displayed gamma3 slot `2`.

## Gate

Focused Lean check passed:

```bash
lake env lean QuantumBlockEncoding/RobinMatrix.lean
python3 tools/qbe.py check
lake build && lake build Tests
```

Known diagnostic sorries remain in `RobinMatrix.lean`; no new `sorry` was
introduced.
