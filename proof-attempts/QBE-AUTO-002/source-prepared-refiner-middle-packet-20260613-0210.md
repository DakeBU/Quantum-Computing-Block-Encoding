# QBE-AUTO-002 Middle Packet: Source-Prepared Active-Entry Refiner

Run: `20260613-020116-QBE-AUTO-002-cycle01`

Role: middle formalization maintainer

This packet supersedes the default H-free `semantic_eval_product_bridge` lower
assignment for the current run.  The latest upper dialogue reclassified that
route as an illness area: the active seven-gate `[0,0]` product is an inner
component, while the paper theorem route compares the source-prepared clean
entry with the backend fold through the two $H_W^{(\kappa)}$ sides.

No Lean declaration is edited by this packet.  No oracle, $H_W^{(\kappa)}$,
$R_y$, LCU, block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, normalizer, or external
primitive flag is promoted.  The first-case-study one-term theorem remains
open.

## Source-Contract Audit

| Source anchor | Paper fragment | Lean interface | Classification | Decision |
|---|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}$ prepares the sparse register with amplitude $\kappa^{-1/2}$ in every paper slot. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | Keep as `hUniform`; do not formalize Shukla--Vedula in this cycle. |
| GHL2025 Eq. `ROBIN clarified` | The gamma3 boundary branch carries the product of the ket-side and bra-side sparse-preparation amplitudes. | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`; `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | GHL-internal branch algebra plus QBE-local semantics | Reuse the compiled prepared-side backend bridge. |
| GHL2025 Fig. `fig:1 term ROBIN` | The theorem-facing circuit contains both $H_W^{(\kappa)}$ sides and the explicit `U_indic^dagger` role around the active backend component. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | transcript guard plus local route distinction | Do not treat the H-free seven-gate list as the whole theorem-facing circuit. |
| GHL2025 Definition `def:block-encoding` | The clean signal-system projection selects the source-prepared entry that must match the encoded operator entry. | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | QBE-local finite projection/composition theorem | Make this the source-correct route target or prove one smaller feeder. |

The blocked ingredient is QBE-local finite matrix semantics.  It is not a new
external cited theorem.  The previous H-free product/backend-fold attempt is
useful only as diagnostic memory unless a proof routes it back through the
source-prepared entry and the existing `hUniform` contract.

## Lean-Facing Contract

Definitions used below:

```lean
HUniform(H) :=
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H

SourcePreparedActive(H, env) :=
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement

UncastActivePrepared(H, env) :=
  oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env

PreparedEntry(H) :=
  (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The next lower work should prove exactly one source-prepared active-entry
statement, or one strictly smaller theorem that feeds it directly.  Acceptable
forms are:

```lean
SourcePreparedActive(H, env)
UncastActivePrepared(H, env)
PreparedEntry(H)
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

If the worker states a new theorem wrapper, the existing
`hUniform : HUniform(H)` contract may appear as a hypothesis because it is the
paper-backed sparse-preparation contract already present in the Lean route.
The worker must not add any other hypothesis, normalizer change, oracle
contract, gate label, or replacement circuit.

Compiled route declarations to reuse:

| Declaration | Role |
|---|---|
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env` | Removes the theorem-facing projection wrapper. |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` | Exposes the exact active/prepared sparse-clean equality. |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H` | Exposes the raw active entry compared with the prepared cached entry. |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform` | Evaluates only the prepared side under the clean-column contract. |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_rawEntryPreparedSandwichField_n3 H env` | Routes a future raw prepared-sandwich proof to the source-prepared field. |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | Recovery bridge from the evaluated fold after it is proved. |

Retired as lower targets for this cycle:

| Retired route | Reason |
|---|---|
| `semantic_eval_product_bridge` as the default H-free product/backend lower leaf | Latest lower diagnostics expose active slot `0` against source gamma3 slot `2`; using the raw seven-gate diagnostic would force the selected slot to evaluate to zero. |
| `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3` | Compiled bridge; route wiring only. |
| `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3` | Compiled strict feeder; route wiring only. |
| backend slot vanish/support and selected-slot fold collapse | Compiled or diagnostic; not the active obstruction. |
| raw `Coeff` constructor equalities and branch-sum wrappers | Known diagnostic/backlog route; not source closure. |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. `1 term ROBIN` transcript includes both $H_W^{(\kappa)}$ sides and explicit dagger roles | source figure; indicator bridge | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window and cited-results ledger | already gated | compiled guard |
| `source_uniform_contract` | all seven sparse slots have clean-column amplitude `sqrt_kappa_inv` | Shukla--Vedula cited by GHL2025 Eq. `arbitrary sparcity` | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `prepared_side_to_backend` | prepared clean-clean entry evaluates to the backend branch fold under `hUniform` | `source_uniform_contract`; prepared sandwich bridge | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | conversion window | already gated | compiled conditional |
| `source_prepared_active_entry_leaf` | active signal-zero entry equals the source-prepared singleton clean entry | active wrapper/cast removal; prepared-side backend bridge; source Fig. `1 term ROBIN` route | lower 2 | `SourcePreparedActive(H, env)`, `UncastActivePrepared(H, env)`, `PreparedEntry(H)`, or raw prepared-sandwich feeder | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `lower3_branch_register_guard` | necessary-condition check that a proposed smaller leaf does not compare the wrong sparse slot/register branch | Fig. `1 term ROBIN`; Eq. `ROBIN clarified`; compiled slot diagnostics | lower 3 | feedback packet only | verifier-feedback | no Lean gate unless edited | active diagnostic |
| `evaluated_backend_fold_leaf` | evaluated signal-zero entry equals the backend branch fold | source-prepared active entry via `hUniform`, or future source-backed active product theorem | later lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | proof blueprint | same gate | recovery leaf; not the default next target |
| `retired_hfree_product_route` | H-free active `[0,0]` product/backend-fold bridge through raw seven-gate diagnostics | stale or shape-mismatched diagnostics | none | `semantic_eval_product_bridge`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | verifier feedback | none | stale for this cycle |

## Lower-Agent Packets

Lower 1, natural-language proof architect:

- Append a narrow postscript after the latest Section 21 entry in
  `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
- State the four source anchors above and map them to
  `SourcePreparedActive(H, env)`, `UncastActivePrepared(H, env)`,
  `PreparedEntry(H)`, and the raw prepared-sandwich feeder.
- Retire the default H-free `semantic_eval_product_bridge` assignment as a
  source-closure target for this run.  Keep it only as diagnostic or recovery
  memory.

Lower 2, Lean implementation worker:

- Edit only `QuantumBlockEncoding/RobinMatrix.lean`.
- Prove one active source-prepared leaf: `SourcePreparedActive(H, env)`,
  `UncastActivePrepared(H, env)`, `PreparedEntry(H)`, the raw
  prepared-sandwich statement, or one strictly smaller theorem feeding one of
  these.
- Reuse the compiled wrappers listed above.  Do not reprove bridge feeders.
- Do not change source contracts, theorem hypotheses except the existing
  `hUniform` wrapper when needed, normalizers, gate labels, paper circuit, or
  oracle declarations.
- Run `python3 tools/qbe.py check`, then `lake build`, then `lake build Tests`.

Lower 3, necessary-condition verifier:

- Check whether the proposed smaller leaf is branch-correct for the source
  gamma3 boundary branch and preserves the $H_W^{(\kappa)}$ prepared sides.
- Record typed feedback under `verifier-feedback/QBE-AUTO-002/` and with
  `trial-log --feedback-field ...`.
- Use `shape_or_register_gap` if the route again compares active slot `0` to
  source gamma3 slot `2` without a source-prepared bridge.
- Use `symbolic_bridge_gap` only when the statement is source-shaped but the
  remaining obstacle is a Lean/evaluated matrix-product bridge.

## Verifier Feedback For This Middle Packet

| Field | Value |
|---|---|
| `leaf` | `source_prepared_active_entry_leaf` |
| `source_correspondence_ok` | `true_for_source_prepared_route_with_hUniform; false_for_default_hfree_slot0_to_gamma3_slot2_closure` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_current_middle_gate` |
| `finite_matrix_ok` | `partial_lower3_found_backend_fold_to_slot2_and_rejected_raw_seven_gate_zero_route` |
| `block_entry_ok` | `false_source_prepared_active_entry_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `prove a source-prepared active-entry theorem or raw prepared-sandwich feeder under the existing hUniform route; do not assign the H-free semantic_eval_product_bridge as the default lower target` |

Gate result: `python3 tools/qbe.py check`, `lake build`, and
`lake build Tests` passed after this middle packet, with only the known
diagnostic `sorry` warnings at `QuantumBlockEncoding/RobinMatrix.lean:24186`
and `QuantumBlockEncoding/RobinMatrix.lean:24217`.
