# Lower2 Attempt: Source-Prepared Projection Restatement

Task: `QBE-AUTO-002`  
Run: `20260613-172255-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf: `source_prepared_projection_restatement`

## Closed Lean Leaf

Closed:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3
```

This theorem consumes:

- `hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`
- an evaluated active/prepared equality stated through
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`

and returns:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The proof unwraps `preparedProjectionEntry` to the existing
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`, then
reuses
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

## Scope Discipline

- Did not revive `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`.
- Did not use the sorry-guarded raw diagnostic declarations as closure.
- Did not add assumptions, change gates, change oracle contracts, or promote
  oracle, `H_W`, `R_y`, LCU, unitarity, block-projection, normalizer, or final
  theorem flags.
- The active/prepared entry field remains open.

## Gate

Passed:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

Both gates reported only the pre-existing diagnostic `sorry` warnings in
`QuantumBlockEncoding/RobinMatrix.lean`.

## Handoff

Next lower2 route: prove exactly one active/prepared finite-composition field,
preferably a small leaf feeding
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` or
the prepared-entry equality exposed by
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.
Keep `Uniform(H)` explicit in recovery and keep the retired H-free row-`0` to
slot-`2` feeder classified as `shape_or_register_gap`.
