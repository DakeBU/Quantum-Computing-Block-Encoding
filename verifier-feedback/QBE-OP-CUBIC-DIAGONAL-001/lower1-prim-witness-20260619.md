# Verifier Feedback: Lower 1 Primitive Witness Proof Design

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Updated: 2026-06-19 21:06 JST

| Field | Value |
|---|---|
| `leaf` | `DIAG-PRIM-WITNESS-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true`, no Lean edit in this pass |
| `lean_build_ok` | `true`, final gate passed after this Markdown update |
| `finite_matrix_ok` | `null`, not run in this proof-architecture pass |
| `block_entry_ok` | `true`, conditional bridge compiled under `primitiveAmplitudeOracleSemanticContract n` |
| `ancilla_cleanup_ok` | `null`, clean-block extraction remains part of the primitive contract |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null`, unitarity is named by an opaque predicate but not proved |
| `resource_score` | `(1, 1, 1, 1)` inside the primitive oracle-label tier |
| `gate_count` | `1` |
| `depth` | `1` |
| `auxiliary_qubits` | `1` |
| `oracle_calls` | `1` |
| `closed_theorem_ok` | `false` |
| `error_class` | `external_contract_gap` |
| `next_route` | `Either record an accepted primitive-tier witness for primitiveAmplitudeOracleSemanticContract n, or open an expanded arithmetic/rotation leaf with an explicit scalar convention.` |

This feedback records a natural-language proof architecture pass.  It does not
certify the primitive oracle candidate.  The Lean worker should receive
`DIAG-PRIM-WITNESS-001` only after the primitive oracle-label contract is
accepted as a proof source; otherwise the route should branch to an expanded
circuit construction.
