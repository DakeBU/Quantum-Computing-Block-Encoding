# QBE-AUTO-002 Middle Packet: Post-Obstruction Prepared Clean-Entry Frontier

Run: `20260613-031339-QBE-AUTO-002-cycle01`

Mode: faithful paper reproduction.

This packet supersedes only the lower-agent assignment in
`proof-attempts/QBE-AUTO-002/source-prepared-prepared-clean-entry-middle-packet-20260613-0257.md`.
It does not change the paper circuit, oracle contracts, normalizer, or theorem
hypotheses.

## Definitions

`PreparedCleanEntry(H)` is the proposition

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

`PreparedInterface(H)` is

```lean
oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H
```

and its field

```lean
(oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H).activeEntryToPreparedEntryStatement
```

is the same active-to-prepared clean-entry proposition.

## Source-Dependency Audit

The blocked lower2 attempt was audited against GHL2025 Theorem
`theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`,
Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`.  The nearby
bibliography cites Shukla and Vedula, "An efficient quantum algorithm for
preparation of uniform quantum superposition states", Quantum Information
Processing 23, Article 38 (2024), for the uniform sparse-register preparation
in Eq. `arbitrary sparcity`.

| Source step | Lean-facing object | Classification | Decision |
|---|---|---|---|
| Eq. `arbitrary sparcity` prepares the sparse register uniformly. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-result, contract-only | Reuse the existing cited-results row; do not formalize Shukla-Vedula in this packet. |
| Eq. `ROBIN clarified` names the gamma3 prepared sparse-register contribution. | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H clean clean` and `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H` | internal paper step plus QBE-local finite semantics | The prepared side is represented; no new external result is needed. |
| Fig. `fig:1 term ROBIN` keeps both `H_W^(kappa)` sides around the active backend component. | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` and the source-prepared projection targets | transcript guard plus route distinction | The H-free seven-gate list remains an inner component, not theorem closure. |
| Definition `def:block-encoding` selects the clean signal-system projection. | `PreparedCleanEntry(H)` and `PreparedInterface(H).activeEntryToPreparedEntryStatement` | QBE-local finite composition theorem | This is the active Lean gap. |

The missing ingredient is therefore an internal QBE-local finite
`CircuitMatrixSemantics` composition theorem, not a new external cited theorem
and not a source-contract gap.

## Compiled Inputs

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H` | compiled interface for the prepared sparse-register matrix and singleton prepared semantics |
| `oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3 H` | compiled obstruction handle; proves the interface field is exactly `PreparedCleanEntry(H)` and records `activePreparedEntryEqualityProved = false` |
| `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H` | compiled clean-entry unfolding to the prepared sandwich fold |
| `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3 H env` | compiled singleton prepared-semantics clean-entry evaluation |
| `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3 H` | compiled source-shaped feeder; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3 H` | compiled cached-entry equivalence; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3 H env` | compiled recovery theorem from the clean-entry equality; not a proof of the equality |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | all sparse slots have the clean-column amplitude used by the prepared sandwich | Eq. `arbitrary sparcity`; Shukla-Vedula cited primitive | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `prepared_interface_obstruction` | compiled handle identifying the exact remaining prepared clean-entry proposition and false proof flag | prepared sparse matrix interface | none | `oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3 H` | this packet; proof-obligation ledger | already gated by previous lower2/reviewer run | proved obstruction handle |
| `prepared_clean_entry_leaf` | active signal-zero entry equals the prepared sparse-matrix clean-clean entry | prepared interface obstruction; source-prepared route guards | lower 2 | `PreparedCleanEntry(H)` or `(oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H).activeEntryToPreparedEntryStatement` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf; open |
| `cached_prepared_entry_leaf` | cached `PreparedCircuitEntryTarget` equality equivalent to the clean-entry equality | `prepared_clean_entry_leaf`; compiled equivalence | lower 2 alternate | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | same gate | active equivalent leaf; open |
| `source_prepared_active_entry_leaf` | theorem-facing source-prepared active field follows after `PreparedCleanEntry(H)` | `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3 H env`; source projection wrappers | later lower 2 | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | conversion window | same gate | dependent target |
| `retired_hfree_product_route` | standalone H-free active `[0,0]` product/backend comparison | selected-slot diagnostics and raw seven-gate facts | none | `semantic_eval_product_bridge`; diagnostic `sorry` declarations | verifier feedback | none | stale for source closure |

## Lower-Agent Split

Lower 1, natural-language proof architect:

- Append at most a narrow postscript to
  `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
- Name `oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3 H` as the current compiled obstruction handle.
- State that the remaining proof is the QBE-local finite composition theorem
  equating the active signal-zero entry with the prepared
  `H_W^(kappa)^dagger * U * H_W^(kappa)` clean entry.

Lower 2, Lean implementation worker:

- Edit only `QuantumBlockEncoding/RobinMatrix.lean`.
- Prove exactly `PreparedCleanEntry(H)`, the interface field
  `(oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H).activeEntryToPreparedEntryStatement`,
  the cached entry equality
  `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`,
  or one strictly smaller source-shaped theorem that directly supplies one of
  those statements.
- Do not use the `sorry`-guarded H-free raw fold as theorem closure.
- Do not change oracle contracts, theorem hypotheses, normalizers, gate labels,
  register layout, or the paper circuit.

Lower 3, necessary-condition verifier:

- Check whether a proposed smaller theorem still compares the active
  signal-zero entry with the prepared sandwich clean entry.
- Classify source-shaped finite matrix algebra failures as `symbolic_bridge_gap`.
- Classify renewed standalone H-free active/backend slot routes as
  `shape_or_register_gap`.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.  The first-case-study one-term theorem remains open.
