# Verifier Feedback: QBE-OP-CUBIC-STATEPREP-001 Initial Diagnostics

Leaf: target normalization and Scenario 2 trigger

## Result

The target vector

```text
v_j = (j / 2^n)^3
```

is not normalized in general.  Therefore the phrase "state preparation
operator" must be interpreted as the rank-one map `|v><0^n|` unless the user
explicitly asks for the normalized state `v / ||v||`.

## Error Class

`target_semantics_gap` avoided.  This is historical prose, not a controlled
typed `error_class` value.

## Typed Feedback Status

The initial normalization diagnostic remains historical context.  The current
typed dense-scaling diagnostic for `CUBIC-VER-001` is recorded in
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`.

| Field | Current value |
|---|---|
| `leaf` | `target-normalization-initial-diagnostic` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `false` |
| `unitarity_ok` | `null` |
| `resource_score` | `null` |
| `closed_theorem_ok` | `false` |
| `error_class` | `null` |
| `next_route` | `Use CUBIC-VER-001 as completed dense-scaling feedback; send Lean work to CUBIC-NORM-001.` |

## Necessary Conditions Before Lean Candidate Work

- Any candidate claiming to be a state-preparation unitary must either
  normalize `v` or work as a block encoding with a normalizer `alpha`.
- Dense statevector/unitary checks are allowed only for small instances and
  should be recorded as diagnostics.
- A scalable candidate should expose arithmetic approximation and rotation
  synthesis error budgets whose sum is at most `1e-10`, unless the run enters a
  user-approved relaxed-epsilon branch.

## Next Route

Switch quickly from exact amplitude synthesis to approximate arithmetic
synthesis if no exact candidate appears within the configured stall window.
