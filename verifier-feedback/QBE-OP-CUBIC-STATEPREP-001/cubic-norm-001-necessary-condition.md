# Verifier Feedback: CUBIC-NORM-001 Necessary-Condition Diagnostic

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-NORM-001`
Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_norm_001_diagnostic.py`

## Scope

This packet checks the active norm leaf before another Lean worker attempts a
large proof.  The source target is the rank-one operator
`O_n = |v_n><0^n|`, with `v_n[j] = (j / 2^n)^3`.  Therefore the norm bridge
must compute

$$
||v_n||^2 = \sum_{j=0}^{2^n-1} (j / 2^n)^6.
$$

This is a necessary condition for `CUBIC-NORM-001`: if the finite sixth-power
sum or rank-one support shape disagreed with the planned closed form, a Lean
proof of `cubicNormSq_closedForm` would be proving the wrong target.

## Command

```bash
python3 verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_norm_001_diagnostic.py
```

## Diagnostic Rows

| n | N | norm_sq approx | formula_ok | rank_one_support_ok | unnormalized | conservative_alpha_ok | one_aux_dense_unitary_memory |
|---:|---:|---:|---|---|---|---|---:|
| 1 | 2 | 0.015625 | true | true | true | true | 256 B |
| 2 | 4 | 0.19384765625 | true | true | true | true | 1 KiB |
| 4 | 16 | 1.81692361832 | true | true | true | true | 16 KiB |
| 8 | 256 | 36.0733816865 | true | true | true | true | 4 MiB |
| 12 | 4096 | 584.642979213 | true | true | true | true | 1 GiB |
| 16 | 65536 | 9361.78572192 | true | true | true | true | 256 GiB |
| 20 | 1048576 | 149796.071429 | true | true | true | true | 64 TiB |

The diagnostic uses an exact integer sum for `sum_j j^6` and compares it with
the planned closed form

$$
\frac{(N-1)(2N-1)(3N^4 - 6N^3 + 3N + 1)}{42N^5}.
$$

The rank-one support check is exhaustive for the smallest matrix sizes and
sampled for the large scaling rows.  It is a target-shape guard, not a family
proof.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-NORM-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `false` |
| `unitarity_ok` | `null` |
| `resource_score` | `dense verifier rows only; no candidate resource tuple` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Prove CUBIC-NORM-001 in Lean using the sixth-power sum bridge, or prove the conservative normalizer bound directly from entrywise nonnegativity. Do not run block-entry diagnostics until a concrete candidate U_n, alpha, projector, and ancilla layout exist.` |

## Rejection

No finite counterexample was found against the current rank-one target.  Reject
any route that treats `v_n` as a normalized unitary output state, because the
checked norms are not equal to `1`.  Also reject a block-entry proof attempt in
this cycle: no candidate unitary, block projector, clean-ancilla convention, or
approximation budget has been stated yet.
