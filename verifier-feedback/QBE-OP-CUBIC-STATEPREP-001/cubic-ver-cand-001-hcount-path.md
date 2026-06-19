# Verifier Feedback: CUBIC-VER-CAND-001 Hadamard-Counting Path Check

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf checked: `CUBIC-VER-CAND-001:HCOUNT-PATH`, against the candidate route
`CUBIC-HCOUNT-001`.

Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_hcount_path_check.py`

## Middle Update

Updated on `2026-06-19 16:33:44 JST`: `CUBIC-HCOUNT-IFACE-001` now compiles
the Hadamard-counting layout, transcript, normalizer, resource tuple,
clean-block contract bridge, and normalizer bridge.  The finite path/support
check below is still useful, but the next route is no longer "compile the
interface."  The next verifier packet should test finite semantic clean-block,
unitarity, and ancilla-cleanup conditions for `n = 1` or `n = 2`, while the
Lean worker proves `CUBIC-HCOUNT-RATIO-001`.

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
| `resource_score` | `stale pre-repair tuple was (7, 7, 21, 7); repaired separate-reject interface now has oracle-label tier n=2 tuple (8, 8, 21, 8)` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `CUBIC-HCOUNT-RATIO-001 and the repaired finite n=1/n=2 Hadamard-counting semantic diagnostics are complete; schedule one symbolic bridge leaf such as CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001 before theorem promotion.` |

## Rejection Rule

Do not promote this candidate from the finite executable population to the
certified population from this diagnostic.  The finite path formula is
consistent with the target, but the current blocker remains the symbolic bridge
from oracle-label/path-count prose to a compiled unitary clean-block theorem.
