# Verifier Feedback: CUBIC-VER-CAND-001 Rank-One Support

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf checked: `CUBIC-VER-CAND-001`, against the active shape subleaf
`CUBIC-CAND-SHAPE-001`.

Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_rank_one_support_check.py`

## Necessary Condition

The current compiled arithmetic candidate records a seven-label middle
transcript:

```text
load j/2^n -> square -> multiply by x -> amplitude transduction -> uncompute
```

If this middle transcript is treated as the whole clean block, its natural
finite matrix support is diagonal: the clean amplitude for input column `c`
remains on output row `c`.  The task target is instead the rank-one
first-column block

$$
O_n / \alpha_n = |v_n\rangle\langle 0^n| / \alpha_n,
\qquad v_n[j] = (j/2^n)^3.
$$

Therefore a necessary condition for the current route is support correctness:
all nonzero input columns must vanish in the clean block, and input column
`0` must generate every output row.  This condition must be checked before a
Lean worker attempts a symbolic clean-block theorem.

## Command

```bash
python3 verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_rank_one_support_check.py
```

## Diagnostic Rows

| n | N | missing_first_column_entries | nonfirst_column_leaks | block_entry_ok | first_mismatch |
|---:|---:|---:|---:|---|---|
| 1 | 2 | 1 | 1 | false | `(row=1, col=0, target=1/16, unwrapped_middle=0)` |
| 2 | 4 | 3 | 3 | false | `(row=1, col=0, target=1/256, unwrapped_middle=0)` |
| 3 | 8 | 7 | 7 | false | `(row=1, col=0, target=1/4096, unwrapped_middle=0)` |
| 4 | 16 | 15 | 15 | false | `(row=1, col=0, target=1/65536, unwrapped_middle=0)` |

The first mismatch is already visible at `n = 1`: the target clean block has
a nonzero first-column entry at `(row=1, col=0)`, while the unwrapped
arithmetic middle block has zero there.  The same unwrapped block also has
nonzero diagonal entries in nonzero columns, contradicting the required
vanish condition.

## Rejection

Reject any proof route that promotes the current seven-label arithmetic
middle transcript directly to a block encoding of `O_n`.  It has diagonal
support under the natural finite interpretation and does not satisfy the
rank-one first-column support condition.

This does not reject the arithmetic-transduction route after repair.  The
next route is to add explicit rank-one wrapper declarations: a zero-input
filter for all `c != 0`, a row-generation branch for `c = 0`, and an updated
resource tuple that includes those wrapper costs.

## Gate

`python3 tools/qbe.py check` passed after adding this diagnostic artifact:

```text
lake build
lake build Tests
```

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-VER-CAND-001` |
| `source_correspondence_ok` | `false` for the current transcript as a full rank-one block; the task target itself is unchanged |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `false` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true` for using `alpha = conservativeNormalizer n`; not a certification of optimality |
| `unitarity_ok` | `null` |
| `resource_score` | current tuple omits required zero-test and row-generation wrapper costs |
| `closed_theorem_ok` | `false` |
| `error_class` | `finite_matrix_counterexample` |
| `next_route` | `Repair CUBIC-CAND-SHAPE-001 by adding zero-input filtering and row-generation wrapper declarations, then rerun this support/block-entry verifier on n = 1 or n = 2 before symbolic theorem work.` |
