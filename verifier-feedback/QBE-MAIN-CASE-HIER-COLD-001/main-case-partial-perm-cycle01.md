# Verifier Feedback Target: MAIN-FINITE-DIAG-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`
Leaf: `MAIN-FINITE-DIAG-001`

## Scope

This packet defines the necessary-condition diagnostic lower 3 should run for
candidate `MAIN-PARTIAL-PERM-001`.  It is a pre-Lean finite check, not an
acceptance certificate.

The fixed target is

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The basis convention is `system = 4*T + 2*tau + S` and
`total = 8*signal + system`.

## Candidate Table

```text
0 -> 14, 1 -> 15, 2 -> 8, 3 -> 9,
4 -> 10, 5 -> 11, 6 -> 0, 7 -> 1,
8 -> 2, 9 -> 3, 10 -> 4, 11 -> 5,
12 -> 6, 13 -> 7, 14 -> 12, 15 -> 13
```

## Required Checks

| Check | Expected value |
|---|---|
| image is a permutation of `0..15` | `true` |
| passive `S` is preserved | `true` |
| clean-block support | only `(0,6)` and `(1,7)` |
| clean-block values on support | `1` |
| clean-block values off support | `0` |
| normalizer | `1` |
| auxiliary qubits | `1` |
| oracle calls | `0` |
| gate count | `null` until a circuit schema exists |
| depth | `null` until a circuit schema exists |

## Middle Preliminary Check

Middle ran an exact table sanity check in cycle 1.  The table is a permutation
of `0..15`, preserves passive `S`, and has clean-block support exactly
`[(0,6),(1,7)]`.  This is diagnostic evidence only; `closed_theorem_ok` remains
`false` until Lean names the corresponding theorem.

## Typed Feedback Template

| Field | Value |
|---|---|
| `leaf` | `MAIN-FINITE-DIAG-001` |
| `source_correspondence_ok` | `true` if the target and basis convention match the task packet |
| `lean_parse_ok` | `null` unless Lean was edited |
| `lean_build_ok` | `null` unless Lean was edited |
| `finite_matrix_ok` | result of exact table check |
| `block_entry_ok` | result of clean-block support/value check |
| `ancilla_cleanup_ok` | `true` for this one-signal clean branch check |
| `normalizer_ok` | `true` if `alpha = 1` is used |
| `unitarity_ok` | `true` if the table is a permutation |
| `resource_score` | `{ "gate_count": null, "depth": null, "auxiliary_qubits": 1, "oracle_calls": 0 }` |
| `closed_theorem_ok` | `false` |
| `error_class` | `none`, `finite_matrix_counterexample`, `shape_or_register_gap`, or `stale_leaf` |
| `next_route` | one narrow next action |

## Rejection Rule

If the finite table does not preserve `S`, does not form a permutation, or has
any clean-block support outside `(0,6)` and `(1,7)`, reject the candidate table
and send lower 2 a table-repair packet.  Do not weaken the target operator.
