# Verifier Feedback: CUBIC-VER-CAND-001 Hadamard-Counting Path Check

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf checked: `CUBIC-VER-CAND-001:HCOUNT-PATH`, against the candidate route
`CUBIC-HCOUNT-001`.

Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_hcount_path_check.py`

## Necessary Condition

The active Hadamard-counting route proposes the clean-block entry

$$
B_n[j,c] =
\begin{cases}
j^3 / (2^n)^4, & c = 0,\\
0, & c \ne 0.
\end{cases}
$$

With `alpha = conservativeNormalizer n = 2^n`, this must scale to the fixed
rank-one target

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

This finite path/support check is necessary before a Lean worker tries the
Hadamard-sandwich semantic theorem: a mismatch would mean the current path
count, normalizer, or rank-one support convention is proving the wrong target.

## Command

```bash
python3 verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_hcount_path_check.py
```

## Diagnostic Rows

| n | N | path_capacity_ok | missing_first_column_entries | nonfirst_column_leaks | block_entry_ok | block_norm_sq<=1 | first_mismatch |
|---:|---:|---|---:|---:|---|---|---|
| 1 | 2 | true | 0 | 0 | true | true | `none` |
| 2 | 4 | true | 0 | 0 | true | true | `none` |
| 3 | 8 | true | 0 | 0 | true | true | `none` |
| 4 | 16 | true | 0 | 0 | true | true | `none` |

The diagnostic found no finite contradiction for `n = 1..4`.  It checks only
the exact rational path-count formula and support shape.  It does not provide a
unitary matrix, reversible comparator semantics, ancilla cleanup proof, or Lean
block-encoding certificate.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-VER-CAND-001:HCOUNT-PATH` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` for the exact path-count formula, not for a compiled circuit semantic matrix |
| `ancilla_cleanup_ok` | `designed_not_executed` |
| `normalizer_ok` | `true` for `alpha = conservativeNormalizer n` in the checked entries |
| `unitarity_ok` | `null` |
| `resource_score` | `null`; `CUBIC-HCOUNT-IFACE-001` has not compiled a resource tuple yet |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Compile CUBIC-HCOUNT-IFACE-001 layout/circuit/resource declarations, then attach Hadamard-sandwich and reversible-comparator semantics before theorem promotion.` |

## Rejection Rule

Do not promote this candidate from the finite executable population to the
certified population from this diagnostic.  The finite path formula is
consistent with the target, but the current blocker remains the symbolic bridge
from oracle-label/path-count prose to a compiled unitary clean-block theorem.
