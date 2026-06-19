# CUBIC-ALPHA-001 Refiner Repair

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-ALPHA-001`
Mode: exploratory construction
Author role: lower Lean refiner/reducer
Updated: `2026-06-19 14:56:38 JST`
Status: direct conservative-normalizer repair compiled and gate-checked.

## Failed Theorem And Rejected Route

Exact failed theorem route:

```lean
theorem cubicNormSq_closedForm (n : Nat) :
    cubicNormSq n =
      let N : Rat := (gridSize n : Rat)
      ((N - 1) * (2 * N - 1) *
        (3 * N ^ 4 - 6 * N ^ 3 + 3 * N + 1)) /
        (42 * N ^ 5)
```

Verifier/error message:

```text
leaf=CUBIC-NORM-001
normalizer_ok=false
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=prove CUBIC-NORM-001 using a sixth-power-sum bridge, or prove the conservative normalizer bound directly from entrywise nonnegativity
```

Rejected route for this refiner pass: do not replay the broad
`cubicNormSq_closedForm` proof without a formal
`classical-sixth-power-sum` helper in the current no-mathlib Lean surface.
That route is still a valid diagnostic target, but it is not the smallest
repair for the candidate normalizer blocker.

## Repair Patch

The repair closes the direct alpha leaf without changing the operator target:

```lean
theorem cubicNormSq_le_conservativeNormalizer_sq (n : Nat) :
    cubicNormSq n <= conservativeNormalizer n ^ 2
```

The proof factors through reusable helper lemmas in
`QuantumBlockEncoding/CubicStatePreparation.lean`:

- `gridSize_rat_pos` and `gridSize_rat_ne_zero` for rational denominator side
  conditions;
- `gridPoint_nonneg`, `gridPoint_lt_one`, and `gridPoint_le_one`;
- `rat_pow_le_one_of_nonneg_le_one`;
- `cubicAmplitude_sq_le_one`;
- `foldl_add_le_add_length`;
- `cubicNormSq_le_gridSize`;
- `gridSize_rat_le_sq`.

The core argument is:

1. For every `j : Fin (gridSize n)`, `0 <= gridPoint n j <= 1`.
2. Therefore `cubicAmplitude n j ^ 2 <= 1`.
3. The defining fold for `cubicNormSq n` has `gridSize n` summands, so
   `cubicNormSq n <= gridSize n`.
4. Since `1 <= gridSize n`, `gridSize n <= (gridSize n)^2`.
5. Hence `cubicNormSq n <= conservativeNormalizer n ^ 2`.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-ALPHA-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null` |
| `resource_score` | `null` |
| `closed_theorem_ok` | `true` for `CUBIC-ALPHA-001`; `false` for the exact closed-form diagnostic `CUBIC-NORM-001` |
| `error_class` | `symbolic_bridge_gap` for rejected closed-form route; repaired via direct-bound leaf |
| `next_route` | Keep the direct conservative-normalizer bridge.  Retry `CUBIC-NORM-001` only after adding a formal sixth-power-sum helper, or route candidate work through the compiled conservative alpha. |

Decision: keep this refiner repair.  `python3 tools/qbe.py check` and
`lake build && lake build Tests` passed after the Lean edit.  The rejected
broad closed-form route should be retried only as a separate exact diagnostic
leaf.
