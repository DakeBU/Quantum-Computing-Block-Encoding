# Theorem-Facing Corrected Finite Block/Projection Equality Packet

Task: `QBE-AUTO-002`  
Run: `20260617-015528-QBE-AUTO-002-cycle01`  
Role: middle coordinator synthesis  
Mode: `paperBenchmark`  
Prepared: `2026-06-17 02:05 JST`

## Source Object

The source object is GHL2025 Theorem `theorem: 1 term robin`, the one-term
Robin block-encoding theorem treated as Theorem 3 for this run.  The active
source fragments are Eq. `eq: arbitrary sparcity`, Eq. `eq:angles for Ry`,
Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

The focused branch remains system entry `(0,0)`, sparse slot `2`, signal block
`[0,0]`, branch basis `[32,32]`, source-prepared projection, and normalizer
$N_D N_f \kappa$.

## Definitions

`ProjectionInterface(H, env)` is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
```

`SourcePreparedProjectionTarget(H, env)` is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

`ActivePreparedEntry(H)` is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

`ActivePreparedEval(H, env)` is:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

`FixedProductObligation` is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
```

The theorem-facing projection-interface normalizer bridge is compiled route
memory:

```lean
oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3
```

## Proof Translation Map

| Paper step | Lean object | Classification |
|---|---|---|
| Definition `def:block-encoding` selects the signal-zero clean block entry. | `SourcePreparedProjectionTarget(H, env).activeToPreparedSingletonEvalStatement` and `ActivePreparedEval(H, env)` | internal paper step; source-contract audit required before proof search |
| Fig. `fig:1 term ROBIN` supplies the full source-prepared sandwich, not only the active seven-gate core. | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env`; `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | source-transcript guard |
| Eq. `eq: arbitrary sparcity` supplies the sparse clean-column contract. | `hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external contract; cited row only |
| Eq. `eq: ROBIN clarified` and Eq. `eq:angles for Ry` supply the focused boundary coefficient and normalizer route. | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | compiled QBE-local normalizer bridge |
| The unchanged H-free backend expansion would identify the active raw entry directly with the backend fold. | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | refuted no-go guard; forbidden target |
| Theorem `theorem: 1 term robin` claims the final block-encoding. | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | blocked; not a lower2 target |

No new cited-result row is needed for this packet.  The only external
ingredient remains the `H_W^(kappa)` clean-column contract, and it must stay an
explicit hypothesis or obligation.

## Current DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `projection_interface_normalizer_bridge` | source slot-`2` product times theorem normalizer exposed through theorem-facing fields | projection interface, source slot-`2` normalizer bridge | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | previous normalizer packet | previous gate | compiled route memory |
| `active_prepared_circuit_field_target` | active seven-gate entry versus prepared singleton clean entry, with false flags | prepared matrix interface, active entry target, transcript split | none | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env` | source-prepared packets | previous gate | compiled route memory |
| `corrected_finite_block_projection_equality` | source-backed finite block/projection equality feeding `FixedProductObligation` | source proof map, no-go guard, lower3 necessary-condition audit | lower1/lower3 before lower2 | audit-gated `SourcePreparedProjectionTarget(H, env).activeToPreparedSingletonEvalStatement` or corrected prepared finite block contract | this packet | `python3 tools/qbe.py check` after any Lean edit | active frontier |
| `fixed_product_to_coefficient` | focused coefficient/normalizer equality for `(0,0)` | corrected block/projection equality plus final coefficient bridge | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate plus proof-map sync | blocked |

## Lower-Agent Split

| Lower role | Packet | Write scope | Acceptance |
|---|---|---|---|
| lower1 proof architect | Re-read the source anchors and map the proof of Definition `def:block-encoding` for the one-term theorem.  Decide whether the source step justifies `ActivePreparedEval(H, env)` as a finite composition theorem, or whether the theorem-facing finite block contract must be corrected to use a prepared block/projection contract. | Markdown proof-attempt and proof-obligation notes only | a proof-DAG table with `leaf=corrected_finite_block_projection_equality` and `source_correspondence_ok=true`, or a precise `source_translation_gap` |
| lower3 verifier | Check the necessary conditions before lower2 proof search: the active seven-gate circuit is distinct from the prepared singleton, `H_W^(kappa)` side gates are absent from the active gate list, unchanged backend expansion is refuted, and all theorem-facing flags remain false. | `verifier-feedback/QBE-AUTO-002/` only unless a tiny diagnostic is explicitly needed | typed feedback with `finite_matrix_ok=false` for the unchanged H-free backend route or `finite_matrix_ok=pending` for a corrected prepared contract |
| lower2 Lean worker | After lower1/lower3 agree that a source-backed target is valid, edit only one leaf in `QuantumBlockEncoding/RobinMatrix.lean`: either prove the existing active/prepared field target below, or compile a non-promoting corrected prepared finite block/projection contract named by middle. | `QuantumBlockEncoding/RobinMatrix.lean` only | `python3 tools/qbe.py check`; no theorem flags promoted |

## Audit-Gated Lean Target

Lower2 must not attack the root theorem.  If the source and verifier checks
confirm that the active/prepared field is the correct paper-backed finite
composition theorem, the allowed target is exactly one of the following
equivalent presentations:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement

oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env

oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env

(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The preferred wrapper for theorem-facing work is:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

The preferred smaller mathematical statement is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

If lower3 confirms the no-go route blocks this target as currently stated,
lower2 should not improvise a proof.  The next Lean work should instead be a
non-promoting corrected prepared finite block/projection contract that reuses:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
```

## Rejections

Lower2 must not target:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

This packet must not replace the Fig. 4 circuit, mutate the active backend
contract, add assumptions, or promote normalized-block equality, LCU
correctness, block projection, block correctness, final extraction, oracle
correctness, unitarity, resource claims, or product-to-coefficient closure.

## Deferred Ledgers

The post-baseline improvement population remains deferred until the GHL
baseline closes.  The fallback `QBE-OP-OPTCTRL-001` operator contract remains
deferred while the one-term Robin baseline root is open.
