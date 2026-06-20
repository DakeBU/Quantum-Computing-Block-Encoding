# Verifier Feedback: Middle Primitive Contract Interface

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Updated: 2026-06-19 20:59 JST

| Field | Value |
|---|---|
| `leaf` | `DIAG-PRIM-WITNESS-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true`, `lake build` passed after the Lean edit |
| `finite_matrix_ok` | `null`, not rerun in this middle pass |
| `block_entry_ok` | `true`, via `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target` under the primitive contract |
| `ancilla_cleanup_ok` | `null`, clean-block extraction remains part of the primitive contract |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null`, unitarity is named by `primitiveAmplitudeOracleIsUnitary` but not proved |
| `closed_theorem_ok` | `false`, no unconditional primitive oracle certificate is proved |
| `error_class` | `external_contract_gap` |
| `next_route` | `Provide or explicitly accept h : primitiveAmplitudeOracleSemanticContract n; otherwise switch to the expanded arithmetic route.` |

This feedback records a partial middle success.  The Lean surface now has a
fixed primitive contract interface and a conditional certificate transformer
`primitiveAmplitudeOracleVerified n h`.  It does not add an unconditional proof
of the primitive oracle semantics.
