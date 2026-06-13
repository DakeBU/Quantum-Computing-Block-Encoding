# QBE-AUTO-002 Middle Packet: Source-Prepared Finite Composition Frontier

Run: `20260613-045026-QBE-AUTO-002-cycle01`

Mode: `faithfulPaper`

## Decision

Lower2 and lower3 rejected the direct H-free evaluated backend-fold route as
the default next target.  That route exposes the active seven-gate `[0,0]`
entry, while the theorem-facing backend path runs through the prepared
singleton clean entry and the selected backend slot.  The active lower target
is therefore the source-prepared finite composition field.

## Definitions

`Uniform(H)` abbreviates:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

`SourcePreparedField(H, env)` abbreviates:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

Accepted equivalent targets are:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement
```

## Source Correspondence

| Source anchor | Lean interface | Status |
|---|---|---|
| GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula 2024 | `Uniform(H)` | external contract only |
| GHL2025 Eq. `ROBIN clarified` | prepared gamma3/backend branch definitions | prepared side compiled under `Uniform(H)` |
| GHL2025 Fig. `fig:1 term ROBIN` | source-prepared projection and active/prepared circuit-field targets | transcript compiled; composition field open |
| GHL2025 Definition `def:block-encoding` | clean signal projection entry | active lower field |

The missing ingredient is internal QBE finite matrix composition, not a new
external cited theorem.  The cited sparse-preparation result stays contract
only.

## Dependency Route

| Step | Lean declaration | Status |
|---|---|---|
| Prepared singleton clean entry reaches backend fold under `Uniform(H)` | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | compiled conditional |
| Source-prepared active field removes source projection wrapper | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env` | compiled bridge |
| Cached prepared-entry equality feeds active field | `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_entryTarget_n3 H env hEntry` | compiled bridge |
| Active field recovers evaluated backend fold under `Uniform(H)` | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | compiled conditional |
| Direct H-free evaluated fold as default target | lower2/lower3 feedback artifacts | rejected as `shape_or_register_gap` |

## Lower Packets

Lower 1 may append only a narrow proof-DAG postscript.  It should name
`source_prepared_finite_composition_leaf`, record the route from
`SourcePreparedField(H, env)` through `Uniform(H)` to
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, and retire
the direct H-free evaluated-fold route as the default target.

Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.  It should prove
`SourcePreparedField(H, env)`, one accepted equivalent target above, or one
strict finite `CircuitMatrixSemantics` or `Coeff.evalWith` lemma that directly
feeds one of those targets.  It must not add `hUniform` to an existing
arbitrary-`H` theorem statement, change the paper circuit, change gate labels,
alter normalizers, or reopen obstruction handles and feeder equivalences.

Lower 3 should check only source-shaped active/prepared
composition/projection routes.  Use `symbolic_bridge_gap` for a source-shaped
finite algebra blocker, `source_translation_gap` when an arbitrary-`H` target
needs a middle restatement or an independence theorem, and
`shape_or_register_gap` for standalone H-free selected-slot reassignment.

## Retired Targets

Do not assign obstruction handles, feeder equivalences, compiled bridge
rediscovery, backend slot vanish/support work, raw `Coeff` constructor
equalities, branch-sum wrappers, H-free active-selected diagnostics, or the
diagnostic `sorry` route
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` /
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

## Acceptance Check

Any Lean edit must pass:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

The first-case-study one-term theorem remains open.  No oracle, `H_W`, `R_y`,
LCU, block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, normalizer, or
external primitive flag is promoted by this packet.
