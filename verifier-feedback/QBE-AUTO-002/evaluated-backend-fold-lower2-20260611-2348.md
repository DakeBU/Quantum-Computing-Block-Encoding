# Verifier Feedback: Evaluated Backend Fold Lower2 Blocker

Task: `QBE-AUTO-002`

Run: `20260611-234445-QBE-AUTO-002-cycle01`

Artifact:
`proof-attempts/QBE-AUTO-002/evaluated-backend-fold-lower2-blocked-20260611-2348.md`

## Classification

The fixed target is
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
Lower2 tested the raw matrix diagnostic
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` by trying
to close it with definitional equality after expansion. Lean hit
`maxRecDepth`, and the patch was reverted.

The failure class is `symbolic_bridge_gap`. The source audit keeps the
evaluated backend fold as a QBE-local finite product/projection theorem. The
external $H_W^{(\kappa)}$ result remains contract-only through
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

| Field | Value |
|---|---|
| `leaf` | `evaluated_backend_fold_leaf` |
| `source_correspondence_ok` | `true_for_evaluated_fold_under_source_audit; sparse_clean_route_requires_hUniform` |
| `lean_parse_ok` | `true_after_lower2_revert` |
| `lean_build_ok` | `true_previous_gate` |
| `finite_matrix_ok` | `partial_backend_fold_collapses_to_slot_2; active_eval_product_bridge_absent` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove an evalWith-level active product/backend fold bridge using Matrix.evalWith_mul_apply or path-isolation helpers; keep hUniform explicit if using the source-prepared sparse-clean route` |

Do not use this feedback to promote oracle, $H_W$, $R_y$, LCU,
block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, normalizer, or
external primitive flags. The first-case-study one-term theorem remains open.
