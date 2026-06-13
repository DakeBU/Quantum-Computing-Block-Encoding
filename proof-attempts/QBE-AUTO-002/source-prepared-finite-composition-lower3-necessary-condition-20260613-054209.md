# QBE-AUTO-002 Lower Necessary-Condition Check

Run: `20260613-052836-QBE-AUTO-002-cycle01`

Leaf: `source_prepared_finite_composition_leaf`.

Active statement:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

This diagnostic is necessary because the active lower worker must prove the
source-prepared finite composition field, not the stale H-free backend fold.
The check verifies that the source-prepared field reduces to the unwrapped
active seven-gate entry compared with the prepared sparse clean-clean entry,
and that the active seven-gate circuit remains distinct from the prepared
singleton circuit.

## Executable Diagnostic

I ran a stdin Lean diagnostic importing `QuantumBlockEncoding.RobinMatrix`.
The diagnostic checked:

- `SourcePreparedField(H, env)` is definitionally
  `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`.
- the active/prepared circuit-field record exposes the same statement.
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`
  exposes the unwrapped active seven-gate `[0,0]` entry against the prepared
  sparse clean-clean entry.
- `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3`
  records distinct active/prepared circuits and keeps theorem-facing proof
  flags false.
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`
  confirms that the active gate list does not contain `H_W^(kappa)` or
  `(H_W^(kappa))^dagger`.
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
  is only the downstream recovery route after the active/prepared field and
  explicit clean-column contract are available.

The diagnostic parsed and elaborated successfully.

## Result

No contradiction was found against the current source-prepared target shape.
The block-entry equality is still not closed: the finite matrix theorem
relating the active signal-zero entry to the prepared singleton clean entry is
still missing.

Reject the standalone H-free evaluated backend-fold route for the next lower
worker: it compares the active seven-gate entry directly with the backend fold
and bypasses the theorem-facing prepared sandwich.  That route remains a
`shape_or_register_gap` as a default lower target.

If the arbitrary-`H` active/prepared equality can only be proved after adding
`Uniform(H)`, lower should stop and return `source_translation_gap` to middle
rather than adding the hypothesis to the current theorem.

## Gate

The required gate passed:

```text
python3 tools/qbe.py check
lake build
lake build Tests
```

All three reported only the known diagnostic sorries in
`QuantumBlockEncoding/RobinMatrix.lean` at the raw H-free fold diagnostics.

