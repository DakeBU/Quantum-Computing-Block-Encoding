# Verifier Feedback: CUBIC-VER-001 Dense Scaling Diagnostic

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-VER-001`
Generated from: `reports/cubic-stateprep/latest.md`,
`reports/cubic-stateprep/latest.csv`, and
`reports/cubic-stateprep/latest.json`

## Scope

This packet records necessary-condition diagnostics for dense
statevector/unitary verification against the symbolic ABEIS route.  It does
not certify a block encoding and does not promote any candidate.

The checked instances are `n = 4, 8, 12, 16, 20`, with `n = 1, 2` retained as
compiled exact norm smoke tests matching `cubicNormSq_n1` and
`cubicNormSq_n2`.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-VER-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `false` |
| `unitarity_ok` | `null` |
| `resource_score` | `dense vector entries: 16, 256, 4096, 65536, 1048576; dense one-aux unitary memory: 16 KiB, 4 MiB, 1 GiB, 256 GiB, 64 TiB` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Do not spend lower Lean time on dense verifier scaling; send lower 2 to CUBIC-NORM-001 and use these finite rows only as smoke-test diagnostics for later candidate instances.` |

## Diagnostic Rows

| n | Dense vector entries | Dense one-aux unitary memory | Role |
|---:|---:|---:|---|
| 4 | 16 | 16 KiB | small smoke test |
| 8 | 256 | 4 MiB | small smoke test |
| 12 | 4096 | 1 GiB | upper edge of practical dense unitary materialization |
| 16 | 65536 | 256 GiB | dense unitary verifier is not a routine inner-loop check |
| 20 | 1048576 | 64 TiB | dense unitary verifier is a scaling witness only |

## Interpretation

Dense executable verification remains useful for small instances and for
catching target-semantics mistakes.  It is not a scalable certificate for the
family theorem because the dense vector has `2^n` entries and dense unitary
materialization grows quadratically in the full Hilbert-space dimension.

The next Lean-relevant route is the symbolic norm/normalizer bridge
`CUBIC-NORM-001`; these diagnostics only justify keeping dense methods as a
finite smoke-test baseline.
