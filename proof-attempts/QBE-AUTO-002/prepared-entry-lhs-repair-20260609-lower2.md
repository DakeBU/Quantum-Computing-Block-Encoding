# QBE-AUTO-002 Prepared-Entry LHS Repair

Date: 2026-06-09
Role: lower 2, Lean implementation worker
Mode: faithfulPaper
Write scope: `QuantumBlockEncoding/RobinMatrix.lean`

## Leaf Closed

Compiled theorem:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3
```

This is the `prepared_signal_entry_lhs_repair` leaf from
`proof-attempts/QBE-AUTO-002/prepared-entry-lower2-packet-20260609-151734-middle.md`.
It exposes
`(oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3 H env).sourcePreparedProjectionTarget.preparedProjectionEntry`
as the left-hand side of the evaluated backend bridge and consumes:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
  H env hUniform
```

The theorem also keeps `evaluatedBackendFoldProved`,
`productToCoefficientProved`, and `finalExtractionProved` false.

## Classification

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `prepared_signal_entry_lhs_repair` | source-prepared target exposes `preparedProjectionEntry` as the left-hand side of the backend evaluator | lower-1 prepared-entry DAG, source-prepared target, all-slot `H_W` clean-column contract | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3` | this note | `python3 tools/qbe.py check` | compiled; gate passed |
| `finite_active_to_prepared_composition` | active signal-zero entry equals the prepared singleton clean entry or prepared sandwich fold | active backend guard, prepared target, finite matrix semantics | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` or `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | proof-obligations ledger | `python3 tools/qbe.py check` | open |

## Remaining Goal

This leaf does not prove the active/evaluated backend fold.  The exact remaining
Lean goal is still the QBE-local finite composition field:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

or equivalently the active-to-prepared singleton entry equality.  The active
seven-gate `[0,0]` diagnostics and the raw `Coeff` constructor equality remain
diagnostic/backlog only.
