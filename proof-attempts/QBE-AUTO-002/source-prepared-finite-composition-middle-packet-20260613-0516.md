# QBE-AUTO-002 Middle Packet: Source-Prepared Finite Composition Coordinator Synthesis

Run: `20260613-050943-QBE-AUTO-002-cycle01`

Mode: `faithfulPaper`

## Decision

The active leaf remains `source_prepared_finite_composition_leaf`.  The next
Lean worker should not attack the standalone H-free evaluated backend fold.
Lower2 and lower3 already classified that route as a register-shape failure
for the theorem-facing source-prepared circuit.

The current root remains the first case-study one-term Robin theorem.  It is
still open.

## Definitions

`Uniform(H)` abbreviates:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

`SourcePreparedField(H, env)` abbreviates:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

The accepted equivalent Lean targets are:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement
```

## Source-Dependency Classification

The fresh local TeX reread requested by the source-dependency protocol was not
available in this checkout.  This packet therefore relies on the bundled
source map, the cited-results ledger, and the current proof-note anchors.  The
public source references remain GHL2025 Eq. `arbitrary sparcity`, Eq.
`ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem `theorem: 1 term robin`,
and Definition `def:block-encoding`.

| Source anchor | Lean interface | Classification | Lower decision |
|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula state-preparation primitive | `Uniform(H)` | external cited contract | keep explicit; do not formalize here |
| GHL2025 Fig. `fig:1 term ROBIN` | source-prepared target with both sparse-preparation sides visible | transcript and register-shape guard | do not replace by the H-free seven-gate component |
| GHL2025 Eq. `ROBIN clarified` | prepared gamma3/backend branch | prepared side compiled under `Uniform(H)` | reuse after the active/prepared field closes |
| GHL2025 Definition `def:block-encoding` | clean signal projection entry | QBE-local finite composition theorem | active lower work |

The missing ingredient is internal finite matrix semantics: the active
signal-zero entry must equal the source-prepared singleton clean entry, or a
strict smaller theorem must feed that statement.  If this equality only becomes
true after adding `Uniform(H)` to the arbitrary-`H` statement, the next result
is not a lower tactic problem.  It is a `source_translation_gap` requiring a
middle restatement or a named independence theorem.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | clean-column all-slot behavior for the paper sparse-preparation matrix | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation; not a lower target |
| `source_prepared_projection_wrapper` | source-prepared projection target equals the uncast active/prepared field | source-prepared target; active/prepared circuit-field target | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env` | Section 21.24 and this packet | already gated | compiled; reuse only |
| `cached_entry_to_source_field` | cached prepared-entry equality implies the evaluated active/prepared field | prepared entry target; wrapper bridges | none | `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_entryTarget_n3 H env`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_entryTarget_n3 H env` | Section 21.24 | already gated | compiled; reuse if proving cached entry |
| `prepared_backend_under_uniform` | prepared singleton clean entry evaluates to the backend fold under `Uniform(H)` | source uniform contract; prepared sparse clean-entry bridge | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | conversion window | already gated | compiled conditional; downstream only |
| `source_prepared_finite_composition_leaf` | active signal-zero entry equals the source-prepared singleton clean entry | wrappers above; finite `CircuitMatrixSemantics` semantics | lower 2 | `SourcePreparedField(H, env)` or one accepted equivalent target | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active source-prepared leaf; open |
| `strict_source_shaped_feeder` | one finite theorem directly feeding the source-prepared field | source transcript guard; active/prepared wrappers | lower 2 alternate | new local theorem in `QuantumBlockEncoding/RobinMatrix.lean` | this packet | same gate | allowed smaller leaf |
| `evaluated_backend_fold_recovery` | evaluated backend fold after the active/prepared field closes | `source_prepared_finite_composition_leaf`; `Uniform(H)`; prepared backend bridge | later | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | proof blueprint | same gate after active field | recovery root; open; not default |
| `direct_hfree_evaluated_fold_route` | standalone active seven-gate `[0,0]` entry equals backend fold | lower2/lower3 diagnostics | none | diagnostic route through `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | verifier-feedback JSON packets | none | rejected as default; `shape_or_register_gap` |

## Lower Packets

Lower 1 is already satisfied by Section 21.24.  A new lower1 write is not
needed unless the next cycle wants a narrow postscript naming this coordinator
packet.

Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.  It should prove
exactly one of:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

or one strict finite `CircuitMatrixSemantics` or `Coeff.evalWith` theorem that
directly feeds one of those statements.  The worker must not change the paper
circuit, the normalizer, gate labels, oracle contracts, theorem hypotheses, or
the `H_W` clean-column contract.

Lower 3 should run only source-shaped active/prepared diagnostics.  It should
record `symbolic_bridge_gap` for source-shaped finite algebra blockers,
`source_translation_gap` if arbitrary-`H` closure needs a middle restatement or
independence theorem, and `shape_or_register_gap` for standalone H-free route
reassignment.

## Retired Targets

Do not assign feeder equivalence rediscovery, obstruction handles, backend
slot vanish/support work, raw `Coeff` constructor equality, branch-sum
wrappers, H-free selected-slot diagnostics, or the diagnostic `sorry` route.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.

Gate result for this middle packet: `python3 tools/qbe.py check`, `lake build`,
and `lake build Tests` passed with only the known diagnostic `sorry` warnings
at `QuantumBlockEncoding/RobinMatrix.lean:24282` and
`QuantumBlockEncoding/RobinMatrix.lean:24313`.
