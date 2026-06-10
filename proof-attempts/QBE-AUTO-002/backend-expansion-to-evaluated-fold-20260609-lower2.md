# QBE-AUTO-002 Backend Expansion To Evaluated Fold Bridge

Date: 2026-06-09
Role: lower 2, Lean implementation worker
Mode: faithfulPaper

## Lean Leaf

Compiled declaration:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3
```

Statement shape:

```lean
theorem oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3
    (env : String -> Rat)
    (hexpansion :
      oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement) :
    oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The proof reuses
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`
to turn the stronger backend-expansion statement into the raw unitary-entry
fold, then applies
`oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_unitaryEntryFold_n3`.

## Status

This is a one-way route bridge only.  It does not prove
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`,
does not prove `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`
unconditionally, and does not revive the raw symbolic `Coeff` constructor route.

Remaining Lean goal:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

or the equivalent source-prepared raw field under the existing clean-column
contract:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

The preferred uncast `evalWith` entry leaf remains open unless one of these
stronger inputs is supplied.

## Gate

Focused Lean check passed:

```bash
lake env lean QuantumBlockEncoding/RobinMatrix.lean
```

Known pre-existing diagnostic `sorry` warnings remain in `RobinMatrix.lean`.
