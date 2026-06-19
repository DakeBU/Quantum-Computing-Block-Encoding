# Verifier Feedback: CUBIC-CAND-001 arithmetic interface

Task: `QBE-OP-CUBIC-STATEPREP-001`

Timestamp: `2026-06-19 14:52:18 JST`

## Attempt

Lower worker 5 seeded an independent arithmetic-transduction route for the
fixed target

```text
O_n = |v_n><0^n|,  v_n[j] = (j / 2^n)^3.
```

Lean now records the route as a candidate interface:

- `CubicStatePreparation.arithmeticCubicDefaultPrecision`
- `CubicStatePreparation.arithmeticCubicLayout`
- `CubicStatePreparation.arithmeticCubicCircuit`
- `CubicStatePreparation.arithmeticCubicResource`
- `CubicStatePreparation.arithmeticCubicNormalizer`
- `CubicStatePreparation.arithmeticCubicResourceTuple`
- `CubicStatePreparation.arithmeticCubicClaim`

The route uses one signal qubit, `3*n + precision + 2` pure arithmetic
ancillas, `alpha = conservativeNormalizer n`, and seven unexpanded oracle-label
calls:

```text
cubic-load-j-over-2^n
cubic-square-fixed-point
cubic-multiply-by-x
cubic-amplitude-transduction-Ry
(cubic-multiply-by-x)^dagger
(cubic-square-fixed-point)^dagger
(cubic-load-j-over-2^n)^dagger
```

For the default precision and `n = 2`, the compiled unexpanded-oracle score is
`(gateCount, depth, auxiliaryQubits, oracleCalls) = (7, 7, 49, 7)`.

## Typed Fields

| Field | Value |
|---|---|
| `leaf` | `CUBIC-CAND-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true`; `python3 tools/qbe.py check` passed and ran `lake build` plus `lake build Tests` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `false` |
| `normalizer_ok` | `false` |
| `unitarity_ok` | `false` |
| `resource_score` | unexpanded-oracle tier; `(7, 7, 1 + (3*n + precision + 2), 7)` |
| `auxiliary_qubits` | `1 + (3*n + precision + 2)` |
| `gate_count` | `7` |
| `depth` | `7` |
| `oracle_calls` | `7` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | Instantiate one finite `n=1` or `n=2` semantic matrix for the seven oracle labels, then test unitarity, clean-block equality for `O_n / alpha`, and clean workspace return before attempting a symbolic family proof. |

## Interpretation

This is a population/interface improvement only.  It does not promote the route
to the certified population and does not weaken the target to normalized state
preparation.  The next useful verifier action is `CUBIC-VER-CAND-001`, not
another dense-baseline rerun.
