# QBE-AUTO-002 Middle Packet: Prepared Clean-Entry Frontier

Run: `20260613-024914-QBE-AUTO-002-cycle01`

Role: middle formalization maintainer

This packet incorporates the latest upper handoff and the lower3 amendment in
`verifier-feedback/QBE-AUTO-002/source-prepared-necessary-condition-lower3-20260613-0243.json`.
The current theorem-facing route remains source-prepared: both
`H_W^(kappa)` sides are represented through the existing
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`
contract.  The standalone H-free `semantic_eval_product_bridge` remains
diagnostic memory only.

The first-case-study one-term theorem remains open.  No oracle, `H_W`, `R_y`,
LCU, block projection, normalized equality, product-to-coefficient, circuit
unitarity, block correctness, final extraction, normalizer, or external
primitive flag is promoted by this packet.

## Source-Contract Audit

| Source anchor | Paper fragment | Lean interface | Classification | Decision |
|---|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | The sparse-register preparation has uniform clean-column amplitudes. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external cited contract | Keep as `hUniform`; do not formalize Shukla-Vedula in this packet. |
| GHL2025 Fig. `fig:1 term ROBIN` | The theorem-facing route has a prepared sandwich with `H_W^(kappa)` and its adjoint around the active component. | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`; source-prepared projection target | transcript and route guard | The active seven-gate list is an inner component, not the whole theorem-facing circuit. |
| GHL2025 Eq. `ROBIN clarified` | The gamma3 boundary branch is read after the prepared sparse-register amplitudes are paired. | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H clean clean` | GHL-internal branch algebra plus QBE-local finite semantics | The active lower target is the prepared clean-entry equality, not another backend-slot wrapper. |
| GHL2025 Definition `def:block-encoding` | The clean projection compares the active signal-zero entry with the source-prepared clean entry. | prepared clean-entry equality and `PreparedCircuitEntryTarget` | QBE-local finite composition theorem | Lower2 should prove the equality or a strict source-shaped feeder into it. |

## Lean-Facing Contract

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.  Define
`PreparedCleanEntry(H)` as

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

Define `PreparedEntry(H)` as

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The next Lean target is exactly `PreparedCleanEntry(H)`,
`PreparedEntry(H)`, or one strictly smaller source-shaped theorem that directly
feeds one of those statements.  The active theorem-facing field is recovered by

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3 H env
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_entryTarget_n3 H env
```

when the corresponding Coeff-level equality is supplied.

Compiled route declarations to reuse:

| Declaration | Role |
|---|---|
| `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3 H` | The raw prepared-sandwich field is equivalent to `PreparedCleanEntry(H)`; route wiring only. |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3 H` | `PreparedEntry(H)` is equivalent to `PreparedCleanEntry(H)`; route wiring only. |
| `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3 H env` | A proof of `PreparedCleanEntry(H)` closes the evaluated active/prepared singleton field. |
| `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_entryTarget_n3 H env` | A proof of `PreparedEntry(H)` closes the evaluated active/prepared singleton field. |
| `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | Prepared side reaches the backend fold under the external clean-column contract. |
| `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | Guard: the active seven-gate list omits `H_W^(kappa)` and its dagger. |

Retired lower targets for this cycle:

| Retired route | Reason |
|---|---|
| `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3` | Compiled source-shaped feeder; do not rediscover it. |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_rawEntryPreparedSandwichField_n3` | Older compiled feeder under `hUniform`; route wiring only. |
| strict prepared-sparse feeders and sparse-clean-to-fold bridges | Already compiled; they do not prove the prepared clean-entry equality. |
| standalone H-free `semantic_eval_product_bridge` | Rejected as theorem-facing closure because it omits the prepared sides unless recovered through a source-prepared bridge. |
| backend slot vanish/support work, branch-sum wrappers, raw `Coeff` constructor equalities | Diagnostic or stale for this source-prepared frontier. |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | all paper sparse slots have the clean-column amplitude used by the prepared sandwich | GHL2025 Eq. `arbitrary sparcity`; Shukla-Vedula cited primitive | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `prepared_clean_entry_leaf` | active signal-zero entry equals the prepared sparse-matrix clean-clean entry | prepared sparse matrix; active signal-zero entry source; source-prepared route guards | lower 2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H oneTermRobinGamma3BoundarySparseCleanIndex_n3 oneTermRobinGamma3BoundarySparseCleanIndex_n3` | this packet and lower3 feedback | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `cached_prepared_entry_leaf` | cached `PreparedCircuitEntryTarget` entry equality | `prepared_clean_entry_leaf`; generic active/prepared target | lower 2 alternate | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | same gate | active equivalent leaf |
| `source_prepared_active_entry_leaf` | theorem-facing active/prepared singleton evaluation field | `prepared_clean_entry_leaf` or `cached_prepared_entry_leaf`; source projection wrappers | lower 2 after active leaf | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | conversion window | same gate | open dependent target |
| `evaluated_backend_fold_leaf` | evaluated signal-zero entry equals the backend branch fold through the source-prepared route | source-prepared active entry; `hUniform`; prepared backend bridge | later lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | proof blueprint | same gate | recovery leaf; open |
| `retired_hfree_product_route` | standalone H-free active `[0,0]` product/backend comparison | selected-slot diagnostics and raw seven-gate facts | none | `semantic_eval_product_bridge`; diagnostic `sorry` declarations | verifier feedback | none | stale for source closure |

## Lower-Agent Packets

Lower 1, natural-language proof architect:

- Append only a narrow postscript after Section 21.18 of
  `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
- Name `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3`
  as compiled and retired.
- State that the active proof map is now `PreparedCleanEntry(H)` or
  `PreparedEntry(H)`, with the raw prepared-sandwich statement used only via
  the compiled equivalence.

Lower 2, Lean implementation worker:

- Edit only `QuantumBlockEncoding/RobinMatrix.lean`.
- Prove exactly `PreparedCleanEntry(H)`, `PreparedEntry(H)`, or one strictly
  smaller source-shaped theorem that directly feeds one of them.
- Reuse the compiled route declarations above.  Do not add hypotheses, change
  the paper circuit, change oracle contracts, alter the normalizer, rename
  gate labels, or prove the standalone H-free product route as theorem closure.
- Run `python3 tools/qbe.py check`, then `lake build`, then `lake build Tests`.

Lower 3, necessary-condition verifier:

- Check that a proposed smaller leaf preserves the source-prepared
  `H_W^(kappa)^dagger * U * H_W^(kappa)` sandwich or routes through an
  already compiled source-shaped feeder.
- Record `symbolic_bridge_gap` when a source-shaped prepared clean-entry proof
  is blocked by finite matrix algebra.
- Record `shape_or_register_gap` if a lower route compares the H-free active
  slot directly to the gamma3 selected backend slot without the prepared
  sandwich.

## Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `prepared_clean_entry_leaf` |
| `active_smaller_leaf` | `prepared_clean_entry_equality_after_source_shaped_feeder` |
| `source_correspondence_ok` | `true_for_source_prepared_route_with_hUniform; false_for_standalone_hfree_slot0_to_gamma3_slot2_closure` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_current_middle_gate` |
| `finite_matrix_ok` | `partial_existing_shape_diagnostics_compile; prepared clean-entry equality remains open` |
| `block_entry_ok` | `false_prepared_clean_entry_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `secondary_error_class_if_hfree_route_reassigned` | `shape_or_register_gap` |
| `next_route` | `prove the prepared clean-entry equality or cached active/prepared entry equality; do not reassign compiled source-shaped feeders or standalone H-free semantic_eval_product_bridge` |

Gate result: `python3 tools/qbe.py check`, `lake build`, and
`lake build Tests` passed after this middle sync, with only the known
diagnostic `sorry` warnings at `QuantumBlockEncoding/RobinMatrix.lean:24227`
and `QuantumBlockEncoding/RobinMatrix.lean:24258`.
