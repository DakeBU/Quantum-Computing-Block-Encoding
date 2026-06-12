# QBE-AUTO-002 Middle Packet: Post-Lower2 Evaluated Fold Semantic Bridge

Run: `20260611-234445-QBE-AUTO-002-cycle01`

## Source Audit

The blocked Lean statement is

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

This statement is the evaluated signal-zero entry compared with the backend
branch fold. The public source anchors are GHL2025 Eq. `arbitrary sparcity`,
Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and Definition `def:block-encoding`.

The audit classifies the missing ingredient as `internal-paper-step` plus a
QBE-local semantic bridge. The paper supplies the sparse-register preparation
only through the cited $H_W^{(\kappa)}$ uniform-superposition result, already
recorded as `ShuklaVedula2024.HWkappaUniformSuperposition`. That cited result
does not prove the active seven-gate product equality. The current Lean
blocker is the evaluated finite matrix-product/projection calculation.

| Source step | Lean interface | Classification | Decision |
|---|---|---|---|
| Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external cited contract | keep as explicit `hUniform`; do not formalize Shukla--Vedula in this packet |
| Eq. `ROBIN clarified` | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; selected slot `2` backend fold | GHL-internal branch algebra plus QBE-local semantics | compiled backend vanish/slot feeders are retired |
| Fig. `fig:1 term ROBIN` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; active backend seven-gate list | GHL-internal transcript | compiled transcript guard; do not change gate order or labels |
| Definition `def:block-encoding` | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection semantics | next lower work must prove an evaluated product/projection bridge |

## Proof Translation

Define the active evaluated entry as the `Coeff.evalWith` value of

```lean
((evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define the backend evaluated fold as the `Coeff.evalWith` value of

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled theorem
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`
shows that equality between these two evaluated expressions is equivalent to
the named evaluated backend fold.

Lower2's failed raw-matrix attempt shows that the next proof should not try to
close
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` by `rfl` or
raw constructor equality. That route hits `maxRecDepth` because the two sides
are differently nested symbolic `Coeff` matrix products. The already compiled
matrix-evaluation helpers in `QuantumBlockEncoding/CircuitSemantics.lean` are
the intended bridge level:

```lean
Matrix.evalWith_mul_apply
Matrix.evalWith_mul_unique_path
Matrix.evalWith_mul_two_path
Matrix.evalWith_mul_eq_zero_of_all_paths_zero
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `evaluated_backend_fold_leaf` | prove the evaluated signal-zero entry equals the backend branch fold | active-entry cast removal; backend fold-to-slot feeder; evaluated matrix-product support lemmas | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or the right side of `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | this packet; Section 21.16 lower1 postscript | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `active_prepared_composition_leaf` | prove the active evaluated entry equals the prepared sparse clean-clean entry only under the source-prepared route | `hUniform`; post-feeder bridge; prepared clean-entry backend theorem | lower 2 only if selected | exact left side of `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | conversion window and lower1 Section 21.16 | same gate | equivalent leaf; not an arbitrary-`H` theorem |
| `semantic_eval_product_bridge` | connect the active seven-gate `evalGateMatrices` entry to the backend fold at `Coeff.evalWith` level | `Matrix.evalWith_mul_*`; existing support facts; selected slot `2` backend contribution | lower 2 | new smaller lemma in `QuantumBlockEncoding/RobinMatrix.lean` feeding the evaluated fold | this packet | same gate | preferred smaller leaf |
| `post_feeder_sparse_clean_to_fold_bridge` | sparse-clean equality iff evaluated fold under `hUniform` | strict prepared-sparse feeder; prepared backend bridge | none | `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | lower2 compiled route | already gated | compiled; retired |
| `raw_coeff_matrix_equality` | raw equality between `evalGateMatrices` and `oneTermRobinGamma3BoundarySevenGateMatrix_n3` | associativity of symbolic `Coeff` matrix constructors | none | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | lower2 blocked note | none | diagnostic `sorry`; do not assign |
| `source_prepared_entry_leaf` | theorem-facing source-prepared active field after the evaluated fold | evaluated fold; source-prepared wrappers; `hUniform` | later lower 2 | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | proof-obligation ledger | same gate | open dependent |

## Lower Packets

Lower 1 should not broaden Section 21.16. A permissible note is one paragraph
stating that lower2's raw equality attempt is a `symbolic_bridge_gap`, and that
the next proof uses evaluated product lemmas from `CircuitSemantics.lean`.

Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`. The fixed target
is one of:

1. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`;
2. the right side of
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`;
3. a strictly smaller evaluated matrix-product bridge using
   `Matrix.evalWith_mul_apply`, `Matrix.evalWith_mul_unique_path`,
   `Matrix.evalWith_mul_two_path`, or
   `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`.

Lower 2 must not target the raw `Coeff` constructor equality, the compiled
sparse-clean-to-fold bridge, backend slot vanish/support work, branch-sum
wrappers, H-free selected-slot diagnostics, or any theorem variant that changes
the circuit, normalizer, `H_W` contract, oracle contract, or hypotheses.

## Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `evaluated_backend_fold_leaf` |
| `source_correspondence_ok` | `true_for_evaluated_fold_under_source_audit; sparse_clean_route_requires_hUniform` |
| `lean_parse_ok` | `true_after_lower2_revert` |
| `lean_build_ok` | `true_previous_gate` |
| `finite_matrix_ok` | `partial_backend_fold_collapses_to_slot_2; active_eval_product_bridge_absent` |
| `block_entry_ok` | `false_evaluated_backend_fold_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove an evalWith-level active product/backend fold bridge; keep hUniform explicit if using the source-prepared sparse-clean route` |

No oracle, $H_W$, $R_y$, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet. The first-case-study one-term theorem remains open.
