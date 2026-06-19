# Verifier Feedback: CUBIC-HCOUNT-REJECT-REPAIR-001

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf checked: `CUBIC-HCOUNT-REJECT-REPAIR-001`, against the
Hadamard-counting route `CUBIC-HCOUNT-001` and compiled interface
`CUBIC-HCOUNT-IFACE-001`.

Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_hcount_semantic_check.py`

## Necessary Condition

The Hadamard-counting route is intended to prove the clean-block statement

$$
B_n[j,c] =
\begin{cases}
j^3 / (2^n)^4, & c = 0,\\
0, & c \ne 0.
\end{cases}
$$

This is necessary for the fixed rank-one target

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3,
$$

with `alpha = conservativeNormalizer n = 2^n`.

The previous Lean transcript included `hcount-zero-input-flag` and
`(hcount-zero-input-flag)^dagger` with no separate rejection witness.  Under the
literal finite semantics, that daggered route computes `nz := [S != 0]`, skips
the path work for nonzero input columns, then uncomputes `nz`.  Nonzero input
columns therefore return to clean ancillas and leak identity entries.

The repaired interface inserts `hcount-nonzero-column-reject` after the
nonzero-input flag computation.  The final `nz` cleanup remains, but nonzero
input columns leave the signal reject qubit set, so the clean projection
rejects them.

## Command

```bash
python3 verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_hcount_semantic_check.py
```

## Diagnostic Rows

| n | N | reversible_layers_ok | path_hadamard_orthogonal_ok | rejected_daggered_nonfirst_column_leaks | rejected_daggered_block_entry_ok | repaired_block_entry_ok | sticky_reference_block_entry_ok | repaired_first_mismatch |
|---:|---:|---|---|---:|---|---|---|---|
| 1 | 2 | true | true | 1 | false | true | true | `none` |
| 2 | 4 | true | true | 3 | false | true | true | `none` |

The old daggered route remains rejected.  The separate-reject repair passes the
same finite clean-block support check as the sticky-reference convention while
keeping the pure `nz` flag clean.

## Rejection

Reject any proof route that attempts `CUBIC-HCOUNT-BLOCK-001` using the old
seven-call daggered `nz` convention without an additional nonzero-column reject
mechanism.  That route has the concrete mismatch `(row=1, col=1, target=0,
current=1)` for both `n = 1` and `n = 2`.

Do not reject the ratio leaf `CUBIC-HCOUNT-RATIO-001`; that arithmetic identity
remains independent.  Do not promote the repaired candidate from this finite
diagnostic alone: a symbolic clean-block theorem is still required.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-HCOUNT-REJECT-REPAIR-001` |
| `source_correspondence_ok` | `true`; the user target is unchanged |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` after `python3 tools/qbe.py check` |
| `finite_matrix_ok` | `true` for the repaired finite `n = 1, 2` check |
| `block_entry_ok` | `true` for the repaired finite clean block |
| `ancilla_cleanup_ok` | `true`; pure `nz` is cleaned and nonzero columns are rejected by the signal qubit |
| `normalizer_ok` | `true` for `alpha = conservativeNormalizer n`; not a certificate of the route |
| `unitarity_ok` | `true` for the finite reversible layers plus path-Hadamard orthogonality checked here |
| `resource_score` | `oracle-label tier; repaired n=2 tuple is (8, 8, 21, 8)` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Promote the separate-reject convention into symbolic Hadamard-counting semantics before attempting CUBIC-HCOUNT-BLOCK-001.` |

## Non-Promotion Rule

This diagnostic improves the finite executable population only.  The
Hadamard-counting route may not enter the certified population until Lean
proves the repaired clean-block theorem and the route is build-tested.
