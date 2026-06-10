# QBE-AUTO-002 Lower2 Attempt: Active/Prepared Eval Equivalence

Created: 2026-06-09 17:43 JST
Role: lower 2, Lean implementation worker
Mode: faithfulPaper

## Closed Lean Leaf

`QuantumBlockEncoding/RobinMatrix.lean` now contains:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
```

The theorem states that, under the existing all-slot
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`
contract, the exact active/prepared composite eval statement

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

is equivalent to the named evaluated backend-fold statement

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

It is proof-DAG wiring only.  It does not prove either side, does not prove the
raw prepared-sandwich field, and does not promote any oracle, `H_W`, `R_y`,
LCU, block-projection, product-to-coefficient, unitarity, block-correctness, or
final-extraction flag.

## Dependencies Used

| Dependency | Role |
|---|---|
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3 H env hUniform` | source-prepared target to evaluated backend-fold equivalence |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | definitional bridge exposing the direct `activePreparedCompositeEvalStatement` field |

## Remaining Goal

The remaining source-faithful finite composition theorem is still one of:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

The new equivalence only makes explicit that proving the named evaluated fold
is the same remaining target as the source-prepared active eval field under the
accepted `H_W^(kappa)` clean-column contract.

## Gate

Focused Lean check passed:

```bash
lake env lean QuantumBlockEncoding/RobinMatrix.lean
```

Only the pre-existing diagnostic sorries were reported.
