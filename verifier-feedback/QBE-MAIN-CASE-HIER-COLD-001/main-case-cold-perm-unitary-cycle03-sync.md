# Verifier Feedback Sync: MAIN-PERM-UNITARY-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Leaf: `MAIN-PERM-UNITARY-001`

## Result

The finite-bijection subleaf is now compiled.  Lean contains
`mainCaseColdPartialPermPreimage`,
`mainCaseColdPartialPermImage_preimage`,
`mainCaseColdPartialPermImage_surjective`,
`mainCaseColdPartialPermImage_injective`, and
`mainCaseColdPartialPermImage_bijective`.

The previous cycle-2 diagnostic remains useful as a necessary-condition check,
but its `closed_theorem_ok=false` state is stale.  This sync packet records the
accepted finite-permutation theorem status and routes the next cycle to
`MAIN-BLOCK-PROJECTION-001`.

## Typed Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-PERM-UNITARY-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `finite_permutation_tier_true` |
| `resource_score` | `{ "gate_count": null, "depth": null, "auxiliary_qubits": 1, "oracle_calls": 0 }` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `null` |
| `depth` | `null` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` |
| `error_class` | `null` |
| `next_route` | `MAIN-BLOCK-PROJECTION-001`: define the COLD `QueryOperatorTarget` and block-projection predicate; keep resource/candidate packaging and the matrix-unitary bridge conditional. |

## Retired Targets

Retire lower packets that only prove `mainCaseColdPartialPermImage_bijective`.
Do not reopen `MAIN-CLEAN-ENTRY-001` or finite-bijection proof search unless
the COLD target or image table changes.
