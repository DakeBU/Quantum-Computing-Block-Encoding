# Verifier Feedback: CUBIC-HCOUNT-RATIO-001

Task: `QBE-OP-CUBIC-STATEPREP-001`
Mode: `exploratoryConstruction`
Leaf: `CUBIC-HCOUNT-RATIO-001`

## Fields

| Field | Value |
|---|---|
| `leaf` | `CUBIC-HCOUNT-RATIO-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null` |
| `closed_theorem_ok` | `true` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `CUBIC-VER-CAND-001:HCOUNT-SEMANTIC is complete for the repaired separate-reject interface; schedule one symbolic bridge leaf such as CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001 before CUBIC-HCOUNT-BLOCK-001.` |

## Result

The algebra leaf is closed in Lean by
`CubicStatePreparation.cubicAmplitude_div_conservativeNormalizer_eq`, with
the local helper `CubicStatePreparation.rat_div_cube_div_eq`.  This proves the
exact scaled-entry identity
`cubicAmplitude n j / conservativeNormalizer n =
(j.val : Rat)^3 / (gridSize n : Rat)^4`.

This does not certify the Hadamard-counting candidate as a block encoding.
The remaining blocker is the semantic bridge from the oracle-label transcript
to finite or symbolic clean-block, clean-ancilla, and unitarity/reversibility
properties.

Gate: `python3 tools/qbe.py check` passed, running `lake build` and
`lake build Tests`.
