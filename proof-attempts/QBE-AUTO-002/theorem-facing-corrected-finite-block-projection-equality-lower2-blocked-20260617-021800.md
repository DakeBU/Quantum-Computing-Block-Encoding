# Lower2 Blocked Attempt: Corrected Finite Block/Projection Equality

Task: `QBE-AUTO-002`  
Run: `20260617-015528-QBE-AUTO-002-cycle01`  
Role: lower Lean implementation worker  
Mode: `paperBenchmark`  
Timestamp: `2026-06-17 02:18 JST`

## Leaf

`theorem_facing_corrected_finite_block_projection_equality`

Middle exposed the allowed Lean-facing target as:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

with equivalent presentations:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

## Decision

No Lean edit was made.  The active middle packet
`theorem-facing-corrected-finite-block-projection-equality-middle-packet-20260617-0205.md`
marks this frontier as audit-gated:

- `source_correspondence_ok` is still pending lower1 source-contract audit.
- lower3 necessary-condition feedback for this corrected frontier is not yet present.
- lower2 is instructed to wait for those checks before proving the active/prepared field.

The compiled theorem
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`
is route memory only and is already present in `QuantumBlockEncoding/RobinMatrix.lean`.
Re-proving or extending from it would not close the corrected finite
block/projection equality.

## Gate

`python3 tools/qbe.py check` passed.  It ran the lake build gate and reported
only the two known diagnostic `sorry` warnings in `QuantumBlockEncoding/RobinMatrix.lean`.

## Feedback

| Field | Value |
|---|---|
| `leaf` | `theorem_facing_corrected_finite_block_projection_equality` |
| `source_correspondence_ok` | `pending_lower1_source_contract_audit` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `pending_lower3_necessary_condition_check` |
| `block_entry_ok` | `not_closed` |
| `normalizer_ok` | `compiled_route_memory_only` |
| `closed_theorem_ok` | `false` |
| `error_class` | `source_translation_gap` |
| `next_route` | `lower1 must classify the source-backed active/prepared equality, lower3 must check the active/prepared shape and no-go guard, then middle should either release this exact leaf to lower2 or name a non-promoting corrected prepared finite block/projection contract.` |

## Handoff

Do not assign lower2 directly to
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, the H-free backend
expansion route, or the finite block-composition root.  The next Lean work is
only valid after the missing source and necessary-condition packets either
approve the active/prepared equality or replace it with a middle-named
non-promoting corrected contract.
