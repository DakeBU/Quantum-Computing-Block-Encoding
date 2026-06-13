# QBE-AUTO-002 Middle Packet: Active/Prepared Composition Interface

Run: `20260613-033618-QBE-AUTO-002-cycle01`

Mode: faithful paper reproduction.

## Source Audit

Definitions first. The current source-prepared equality is the comparison
between the active signal-zero entry and the clean-clean entry of the prepared
sparse-register sandwich matrix:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

The existing generic interface for the same equality is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The existing field record exposing the same missing theorem is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement
```

and its interface form is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).interfaceStatement
```

The relevant source anchors are GHL2025 Eq. `arbitrary sparcity`, Theorem
`theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and
Definition `def:block-encoding`. Eq. `arbitrary sparcity` cites Shukla and
Vedula only for the uniform sparse-register preparation. That cited result is
already recorded as `ShuklaVedula2024.HWkappaUniformSuperposition` in
`research-wiki/cited-results/GHL2025.md` with status `contract-only`.

| Source anchor | Lean interface | Dependency class | Decision |
|---|---|---|---|
| Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external cited contract | Keep as `hUniform`; do not formalize Shukla-Vedula here. |
| Eq. `ROBIN clarified` | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H clean clean` | GHL-internal branch algebra plus QBE-local finite semantics | Prepared side is already represented; no new external result is needed. |
| Fig. `fig:1 term ROBIN` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | transcript guard plus route distinction | Keep both $H_W^{(\kappa)}$ sides in the theorem-facing route. |
| Definition `def:block-encoding` | active signal-zero clean projection compared with the source-prepared clean entry | QBE-local finite composition theorem | This is the active Lean gap. |

## Latest Lower Feedback

Lower2's `prepared-clean-entry-lower2-blocked-20260613-033219.md` made no Lean
edit. It found only compiled wrappers or retired feeders around the same
proposition. A direct `rfl` probe against the prepared clean-entry equality hit
`maxRecDepth`; a zero-`H` counterprobe did not finish and produced no
counterexample certificate. The result is useful failure memory, not theorem
closure.

Primary classification: `symbolic_bridge_gap`.

Secondary classification if reassigned through the standalone H-free slot
route: `shape_or_register_gap`.

## Compiled Support

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3 H` | compiled obstruction handle; retired as lower target |
| `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H` | compiled field record exposing the exact active/prepared composition gap |
| `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3_transcript H` | compiled transcript showing `activePreparedEntryEqualityProved = false` |
| `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_interfaceStatement_n3 H` | compiled equivalence between the field record and prepared-interface statement |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3 H` | compiled route wiring; retired as lower target |
| `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3 H` | compiled source-shaped feeder; retired as lower target |
| `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3 H env` | compiled recovery from the equality; not closure |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | sparse-register preparation has the clean-column amplitude used by the prepared sandwich | GHL2025 Eq. `arbitrary sparcity`; Shukla-Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `prepared_interface_obstruction` | identifies the prepared clean-entry equality and records its proof flag as false | prepared sparse matrix interface | none | `oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3 H` | this packet and conversion window | previous gate | compiled obstruction handle; stale as lower target |
| `active_prepared_composition_interface_leaf` | prove the finite composition theorem equating the active seven-gate signal-zero entry with the prepared $H_W^\dagger U H_W$ clean entry | prepared interface obstruction; Fig. 4 transcript guard; `PreparedCircuitEntryTarget` | lower 2 | `(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement`; equivalently `.interfaceStatement` or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf; open |
| `source_prepared_entry_leaf` | theorem-facing source-prepared active field follows after the active/prepared equality | active composition interface leaf; source projection wrappers | lower 2 after active leaf | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | conversion window | same gate | open dependent target |
| `evaluated_backend_fold_leaf` | evaluated signal-zero entry equals the backend branch fold through the source-prepared route | source-prepared active field; `hUniform`; prepared backend bridge | later lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | proof blueprint | same gate | recovery leaf; open |
| `retired_hfree_product_route` | standalone H-free active `[0,0]` product/backend comparison | diagnostic `sorry` declarations | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | verifier feedback | none | stale for source closure |

## Lower-Agent Packets

Lower 1 natural-language proof architect:

- Reuse the prior Section 21.19 proof-DAG addendum.
- If writing anything, append only a narrow postscript naming
  `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H` as the
  active interface leaf.
- Do not rewrite broad branch-sum, backend-slot, or H-free selected-slot notes.

Lower 2 Lean implementation worker:

- Edit only `QuantumBlockEncoding/RobinMatrix.lean`.
- Prove exactly the active composition interface leaf:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement
```

- Equivalent acceptable targets are:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).interfaceStatement
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

- A smaller theorem is acceptable only if it directly proves this finite
  active/prepared composition field. It must not be another obstruction
  record, equivalence wrapper, raw `Coeff` constructor equality, backend-slot
  vanish/support lemma, or H-free selected-slot diagnostic.
- Do not change oracle contracts, theorem hypotheses, normalizers, gate labels,
  the paper circuit, or the `H_W` clean-column contract.

Lower 3 necessary-condition verifier:

- Check only source-shaped active/prepared composition routes.
- Useful feedback: source correspondence, Lean parser/build status, finite
  matrix-entry support for the active/prepared equality if available, and
  whether the route is still comparing the H-free active slot to a gamma3
  selected backend slot.
- Record `symbolic_bridge_gap` for a source-shaped finite-algebra blocker and
  `shape_or_register_gap` for standalone H-free reassignment.

## Retired Routes

Do not reassign the compiled obstruction handle, raw-to-clean feeder, cached
prepared-entry feeder, strict prepared-sparse feeders, sparse-clean-to-fold
bridges, finite active/prepared reduction guards, backend slot vanish/support
work, branch-sum wrappers, raw `Coeff` constructor equalities, or diagnostic
H-free `sorry` routes.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet. The first-case-study one-term theorem remains open.
