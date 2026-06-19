# Verifier Feedback: CUBIC-HCOUNT-COUNT-001 Threshold Count

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf checked: `CUBIC-HCOUNT-COUNT-001`.

Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_hcount_count_001_threshold_check.py`

## Necessary Condition

The active Lean leaf is the pure Hadamard-counting threshold count:

```text
((List.finRange (gridSize (3 * n))).filter
    (fun t => t.val < j.val ^ 3)).length = j.val ^ 3
```

This is necessary for the candidate clean first-column entry.  With
`alpha = conservativeNormalizer n = gridSize n`, denominator `gridSize (4*n)`,
and threshold count `j.val^3`, the scaled entry becomes
`j.val^3 / (gridSize n)^3`, matching `cubicAmplitude n j`.

If this diagnostic failed, the current path-count leaf would be proving the
wrong target or using the wrong register shape.  Passing the diagnostic alone
does not prove the symbolic Lean theorem, the repaired circuit semantics,
ancilla cleanup, or unitarity.

## Command

```bash
python3 verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_hcount_count_001_threshold_check.py
```

## Diagnostic Rows

| n | N | capacity_ok | grid3_cube_ok | grid4_fourth_ok | count_mismatches | first_count_mismatch | block_entry_ok | first_block_mismatch |
|---:|---:|---|---|---|---:|---|---|---|
| 1 | 2 | true | true | true | 0 | `none` | true | `none` |
| 2 | 4 | true | true | true | 0 | `none` | true | `none` |
| 3 | 8 | true | true | true | 0 | `none` | true | `none` |
| 4 | 16 | true | true | true | 0 | `none` | true | `none` |
| 5 | 32 | true | true | true | 0 | `none` | true | `none` |

## Post-Gate Lean Status

The current workspace also build-tests the count leaf declarations:

- `gridSize_three_mul_eq_cube`
- `gridSize_four_mul_eq_fourth`
- `hadamardCountingCubic_threshold_le_pathCapacity`
- `hadamardCountingCubic_thresholdPathCount`

The current Lean-facing diff includes a local `Tests/Basic.lean` syntax repair
around the new examples for the last two declarations.  This refiner pass reran
the project gate, and it passed.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-HCOUNT-COUNT-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` for the exact finite path-count/block-entry model, not for a compiled circuit matrix |
| `block_entry_ok` | `true` for `alpha * (j^3 / gridSize (4*n)) = cubicAmplitude n j` on checked rows |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true` for `alpha = conservativeNormalizer n` |
| `unitarity_ok` | `null` |
| `closed_theorem_ok` | `true` for the count leaf declarations named above; `false` for any clean-block/unitarity certificate |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | Schedule `CUBIC-HCOUNT-UNITARY-001` or the Hadamard-sandwich semantic bridge before `CUBIC-HCOUNT-BLOCK-001`. |

## Rejection Rule

Do not promote the Hadamard-counting candidate from this diagnostic or from the
count leaf alone.  The finite threshold count is consistent with the target for
the checked instances, and the count declarations now build, but the active
blocker remains unitary/reversibility plus Hadamard-sandwich clean-block
semantics.
