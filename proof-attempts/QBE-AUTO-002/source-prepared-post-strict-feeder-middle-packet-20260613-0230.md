# QBE-AUTO-002 Middle Packet: Post-Strict-Feeder Source-Prepared Frontier

Run: `20260613-022313-QBE-AUTO-002-cycle01`

Role: middle formalization maintainer

This packet incorporates the latest upper handoff and the accepted lower2
route-wiring theorem
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_rawEntryPreparedSandwichField_n3`.
That theorem is now retired as a lower target.  It proves that, under the
existing clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
`PreparedEntry(H)` is equivalent to the raw prepared-sandwich field.  It does
not prove either side.

The first-case-study one-term theorem remains open.  No oracle, $H_W$,
$R_y$, LCU, block projection, normalized equality, product-to-coefficient,
circuit unitarity, block correctness, final extraction, normalizer, or
external primitive flag is promoted by this packet.

## Source-Contract Audit

| Source anchor | Paper fragment | Lean interface | Classification | Decision |
|---|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the sparse register uniformly on the paper slots. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external cited contract | Keep as `hUniform`; do not formalize Shukla--Vedula here. |
| GHL2025 Eq. `ROBIN clarified` | The gamma3 boundary branch uses the prepared sparse-register amplitudes on both sides. | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`; raw prepared-sandwich field | GHL-internal branch algebra plus QBE-local finite semantics | The active leaf must keep the prepared sandwich, not a standalone H-free slot comparison. |
| GHL2025 Fig. `fig:1 term ROBIN` | The theorem-facing circuit has both $H_W^{(\kappa)}$ sides around the active backend component. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | transcript guard plus route distinction | Reuse the guard; do not treat the seven-gate H-free list as the full theorem-facing circuit. |
| GHL2025 Definition `def:block-encoding` | The clean projection selects the source-prepared singleton entry that must match the encoded operator entry. | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | QBE-local finite composition theorem | Prove the source-prepared active-entry field or a strict feeder. |

## Lean-Facing Contract

For fixed `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
the current active leaf is one of the following source-shaped statements:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

The preferred next Lean target is now the raw prepared-sandwich field or one
strictly smaller theorem that feeds it directly.  The compiled theorem
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_rawEntryPreparedSandwichField_n3 H hUniform`
then recovers `PreparedEntry(H)`, and existing wrappers recover the
source-prepared active field.

Compiled route declarations to reuse:

| Declaration | Role |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_rawEntryPreparedSandwichField_n3 H hUniform` | Retired feeder: `PreparedEntry(H)` is equivalent to the raw prepared-sandwich field. |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_rawEntryPreparedSandwichField_n3 H env` | Routes a raw prepared-sandwich proof to the theorem-facing source-prepared field. |
| `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_rawEntryPreparedSandwichField_n3 H env` | Routes a raw prepared-sandwich proof to the uncast active/prepared target. |
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_rawEntryPreparedSandwichField_n3 H env hUniform` | Recovers the evaluated backend fold after the source-shaped raw field is proved. |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H` | Exposes the active seven-gate entry only inside the prepared-entry target. |

Retired lower targets for this cycle:

| Retired route | Reason |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_rawEntryPreparedSandwichField_n3` | Compiled at 02:22; route wiring only. |
| default H-free `semantic_eval_product_bridge` | It is diagnostic unless a source-prepared bridge prevents the slot/register drift. |
| `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3` | Compiled sparse-clean-to-fold bridge; route wiring only. |
| strict prepared-sparse feeders, slot vanish/support work, raw `Coeff` constructor equality, branch-sum wrappers | Compiled, diagnostic, or stale. |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | all paper sparse slots have the clean-column amplitude used by the prepared sandwich | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited primitive | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger and this packet | contract only | external obligation |
| `prepared_side_to_backend` | prepared clean-clean entry evaluates to the backend branch fold under `hUniform` | `source_uniform_contract`; prepared sandwich backend lemmas | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | conversion window | already gated | compiled conditional |
| `active_prepared_composition_leaf` | active signal-zero entry equals the source-prepared singleton clean entry | active wrapper/cast removal; prepared-entry target; raw prepared-sandwich feeder | lower 2 | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`; raw prepared-sandwich field | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active source-prepared leaf |
| `raw_entry_to_source_prepared_sandwich_bridge` | prove the finite raw equality between the signal-zero entry and the prepared $H_W^\dagger U H_W$ sandwich fold | source-prepared projection target; prepared sandwich matrix; clean-column contract for recovery | lower 2 | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | this packet | same gate | preferred active smaller leaf |
| `evaluated_backend_fold_leaf` | evaluated signal-zero entry equals the backend branch fold through the source-prepared route | raw prepared-sandwich field or active/prepared composition leaf; `hUniform` | later lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | proof blueprint | same gate | recovery leaf; open |
| `retired_hfree_product_route` | standalone H-free active `[0,0]` product/backend comparison | selected-slot diagnostics and raw seven-gate facts | none | `semantic_eval_product_bridge`; diagnostic `sorry` declarations | verifier feedback | none | stale for source closure |

## Lower-Agent Packets

Lower 1, natural-language proof architect:

- Append only a narrow postscript after Section 21.17.
- Name `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_rawEntryPreparedSandwichField_n3` as compiled and retired.
- Keep the active proof map on the raw prepared-sandwich field or a strict feeder into it.

Lower 2, Lean implementation worker:

- Edit only `QuantumBlockEncoding/RobinMatrix.lean`.
- Prove exactly the raw prepared-sandwich statement, `PreparedEntry(H)`, `UncastActivePrepared(H, env)`, the theorem-facing source-prepared field, or one smaller theorem that directly feeds one of them.
- Reuse the compiled wrappers above.  Do not add hypotheses except the existing `hUniform` route when the wrapper requires it.
- Do not change the paper circuit, oracle contracts, normalizer, gate labels, or theorem statement.
- Run `python3 tools/qbe.py check`, then `lake build`, then `lake build Tests`.

Lower 3, necessary-condition verifier:

- Reject a proposed smaller leaf if it compares the H-free active slot directly to the gamma3 selected backend slot without the prepared sandwich.
- Use `shape_or_register_gap` for that drift.
- Use `symbolic_bridge_gap` only when the target is source-shaped and the remaining problem is Lean finite matrix algebra.

## Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `source_prepared_active_entry_leaf` |
| `source_correspondence_ok` | `true_for_source_prepared_route_with_hUniform; false_for_default_hfree_slot0_to_gamma3_slot2_closure` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_current_middle_gate` |
| `finite_matrix_ok` | `partial_route_wiring_compiled_raw_field_open` |
| `block_entry_ok` | `false_raw_prepared_sandwich_field_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `true_for_strict_feeder_only_false_for_active_leaf` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove the raw prepared-sandwich field or a strict source-shaped feeder; do not reassign compiled feeder or standalone H-free semantic_eval_product_bridge` |
