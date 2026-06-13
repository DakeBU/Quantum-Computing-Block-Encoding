# 2026-06-13 Final Middle Packet: Finite Projection Feeder

Task: `QBE-AUTO-002`  
Run: `20260613-054606-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`

## Source Anchors

The source-facing anchors remain GHL2025 Eq. `arbitrary sparcity`, Theorem
`theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Definition `def:block-encoding`, and the
Shukla--Vedula cited sparse-register preparation result.  This packet does
not change the paper circuit, normalizer, oracle contracts, or register
layout.

## Definitions

- `Uniform(H)` is
  `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
- `EvaluatedBackendFold(env)` is
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
- `SourcePreparedField(H, env)` is
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.

## Active Leaf

The active lower2 leaf is `finite_projection_feeder`.

Lower2 should prove exactly:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

or one strictly smaller finite `CircuitMatrixSemantics` or `Coeff.evalWith`
theorem in `QuantumBlockEncoding/RobinMatrix.lean` that directly feeds that
statement.  The result is consumed only through:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
  H env hUniform hFold
```

where:

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
hFold :
  oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | all-slot sparse-register clean column | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external contract; not a lower target |
| `source_contract_target_correction` | recover `SourcePreparedField(H, env)` only with `Uniform(H)` explicit and a finite feeder | source audit; compiled route bridges | middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | this packet and `conversion-windows/QBE-AUTO-002.md` | documentation gate plus project gate | correction accepted |
| `finite_projection_feeder` | prove `EvaluatedBackendFold(env)` or a strict finite theorem feeding it | backend branch fold definitions; clean projection; no diagnostic `sorry` route | lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active lower leaf; open |
| `arbitrary_H_source_prepared_field` | prove `SourcePreparedField(H, env)` for arbitrary `H` | needs a true all-`H` finite composition or clean-column independence theorem | none by default | `SourcePreparedField(H, env)` | older packets | none | retired as default |
| `direct_hfree_evaluated_fold_route` | treat the H-free seven-gate fold as theorem-facing source-prepared closure | lower2/lower3 diagnostics | none | diagnostic declarations around `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | verifier feedback | none | rejected as default; `shape_or_register_gap` |

## Lower-Agent Split

Lower1 may append a narrow natural-language proof postscript naming this packet
and the source anchors above.  It should not change Lean code.

Lower2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.  It must not add
`Uniform(H)` to the existing arbitrary-`H` `SourcePreparedField(H, env)` target,
must not change oracle contracts or gate order, and must not use diagnostic
`sorry` declarations as theorem closure.

Lower3 should run necessary-condition checks for the finite projection feeder:
source correspondence, clean-column sensitivity, and exact finite entry/path
shape.  Feedback should use `leaf=finite_projection_feeder`.  Use
`source_translation_gap` if a route tries to rescue arbitrary-`H`
`SourcePreparedField(H, env)` by adding `Uniform(H)`, and
`shape_or_register_gap` if the standalone H-free route is reassigned as
theorem-facing closure.

The first-case-study one-term theorem remains open.  No oracle, `H_W`, `R_y`,
LCU, block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, normalizer, or external
primitive flag is promoted.
