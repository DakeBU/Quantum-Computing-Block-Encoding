# QBE-AUTO-002 Middle Packet: Semantic Eval Product Bridge

Run: `20260613-014104-QBE-AUTO-002-cycle01`

## Source Audit

The fixed Lean target remains:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Equivalently, lower work may prove the right side of:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env
```

This is the evaluated equality between the active seven-gate `[0,0]`
`evalGateMatrices` entry and the backend branch fold.

The source anchors are GHL2025 Eq. `arbitrary sparcity`, Theorem
`theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and
Definition `def:block-encoding`.  The TeX source supplies the circuit, the
boundary $\gamma_3$ branch, the sparse-register preparation contract, and the
block-projection convention.  It does not supply a new external theorem for
the active `[0,0]` finite product calculation.

| Source step | Lean interface | Classification | Decision |
|---|---|---|---|
| Eq. `arbitrary sparcity` prepares the sparse register by $H_W^{(\kappa)}$ | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external cited contract | keep `hUniform` explicit; do not formalize Shukla--Vedula in this packet |
| Theorem `theorem: 1 term robin` states the one-term Robin block-encoding | theorem-facing one-term route | GHL-internal theorem target plus contracts | root remains open |
| Eq. `ROBIN clarified` identifies the displayed boundary $\gamma_3$ coefficient | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; selected slot `2` fold feeders | GHL-internal branch algebra plus QBE-local matrix semantics | backend slot work is compiled support, not the next target |
| Fig. `fig:1 term ROBIN` fixes the active backend gates and prepared sides | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; active seven-gate list | GHL-internal transcript | do not change labels, order, normalizer, or circuit |
| Definition `def:block-encoding` selects the clean signal-system entry | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection semantics | prove an evaluated product/projection bridge |

## Proof Translation

Define the active evaluated entry:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define the backend evaluated fold:

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

The compiled bridge
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`
turns equality of these two evaluated expressions into the named evaluated
backend fold.  The smaller preferred leaf is therefore a local theorem that
proves this evaluated equality without using the sorry-dependent diagnostic
theorems
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

The intended proof level is `Coeff.evalWith`, using existing matrix-evaluation
support where appropriate:

```lean
Matrix.evalWith_mul_apply
Matrix.evalWith_mul_unique_path
Matrix.evalWith_mul_two_path
Matrix.evalWith_mul_eq_zero_of_all_paths_zero
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `semantic_eval_product_bridge` | prove the active seven-gate `[0,0]` evaluated entry equals the backend fold | active-entry cast removal; backend fold-to-slot feeder; `Matrix.evalWith_mul_*` helpers; existing finite support facts | lower 2 | new local theorem in `QuantumBlockEncoding/RobinMatrix.lean` feeding the right side of `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | preferred active smaller leaf |
| `evaluated_backend_fold_leaf` | prove the named evaluated signal-zero backend fold statement | `semantic_eval_product_bridge` or exact active/prepared sparse-clean equality | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | proof blueprint; conversion window | same gate | active leaf; not proved |
| `active_prepared_composition_leaf` | prove the exact sparse-clean active/prepared equality only through the source-prepared route | post-feeder bridge; `hUniform`; prepared clean-entry backend theorem | lower 2 only if selected | left side of `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | lower1 Section 21.16 | same gate | equivalent route; not an arbitrary-`H` theorem |
| `post_feeder_sparse_clean_to_fold_bridge` | identify sparse-clean equality with evaluated fold under `hUniform` | strict prepared-sparse feeder; prepared backend bridge | none | `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | lower2 compiled route | already gated | compiled; retired |
| `raw_coeff_matrix_equality` | raw constructor equality for the seven-gate product | symbolic matrix associativity | none | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | lower2 blocked note | none | diagnostic `sorry`; do not assign |
| `source_prepared_entry_leaf` | recover theorem-facing source-prepared active field after the evaluated fold | evaluated fold; source-prepared wrappers; `hUniform` | later lower 2 | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | proof-obligation ledger | same gate | open dependent target |

## Lower-Agent Packets

Lower 1 may append only a narrow postscript to Section 21.16 of
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The postscript should name this packet, keep the compiled sparse-clean-to-fold
bridge retired, and point lower2 to `semantic_eval_product_bridge`.  It should
not reopen slot vanish/support work or the raw constructor route.

Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.  The accepted
outputs are:

1. a proof of `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`;
2. a proof of the uncast active-entry equality exposed by
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`;
3. one strictly smaller evaluated product/projection lemma that directly feeds
   one of the two statements above.

Lower 2 must not use the diagnostic proof
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic`
as theorem closure, because it depends on the sorry-guarded raw fold.  Lower 2
must not change oracle contracts, theorem hypotheses, normalizers, gate labels,
the paper circuit, or the $H_W^{(\kappa)}$ clean-column contract.

Lower 3 receives a necessary-condition verifier packet.  The useful checks are
finite `n = 3` checks for the active `[0,0]` evaluated entry, the backend fold
after collapse to selected slot `2`, and any concrete-environment
counterexample to the uncast active-entry equality.  If a finite check
contradicts the target, lower3 should classify the route as
`finite_matrix_counterexample` or `shape_or_register_gap`; if checks pass but
Lean still lacks the bridge, lower3 should record `symbolic_bridge_gap`.
Lower3 may write durable feedback under `verifier-feedback/QBE-AUTO-002/`.

## Verifier Feedback Seed

| Field | Value |
|---|---|
| `leaf` | `semantic_eval_product_bridge` |
| `source_correspondence_ok` | `true_for_evaluated_fold; sparse_clean_route_requires_hUniform` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_current_middle_gate` |
| `finite_matrix_ok` | `partial_backend_fold_collapses_to_slot_2; active_eval_product_bridge_absent` |
| `block_entry_ok` | `false_evaluated_backend_fold_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove an evalWith-level active product/backend fold bridge feeding oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` |

No oracle, $H_W$, $R_y$, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.  The first-case-study one-term theorem remains open.
