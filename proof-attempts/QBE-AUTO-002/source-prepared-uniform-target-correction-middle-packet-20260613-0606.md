# 2026-06-13 Middle Source-Prepared Uniform Target Correction

Task: `QBE-AUTO-002`  
Run: `20260613-054606-QBE-AUTO-002-cycle01`  
Mode: faithful paper reproduction

## Source Object

The translated paper object is the clean projection of the focused one-term
Robin boundary gamma3 branch.  The public anchors are GHL2025 Eq. `arbitrary
sparcity`, Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Definition `def:block-encoding`, and the Shukla--Vedula
uniform-state-preparation citation.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

Define `Uniform(H)` to be
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Define `SourcePreparedField(H, env)` to be
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.

Define `EvaluatedBackendFold(env)` to be
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

Define `PreparedEntry(H)` to be
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.

## Source-Contract Audit

| Source anchor | Lean-facing contract | Classification | Lower decision |
|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula citation | `Uniform(H)` | external cited contract; contract-only | keep explicit; do not formalize the cited primitive in this leaf |
| GHL2025 Eq. `ROBIN clarified` | selected gamma3 backend fold | GHL-owned branch transcript plus QBE-local finite matrix glue | compare the clean projection to `EvaluatedBackendFold(env)` |
| GHL2025 Fig. `fig:1 term ROBIN` | theorem-facing sandwich with both `H_W^(kappa)` sides | GHL-owned circuit transcript | do not treat the H-free seven-gate component as the whole theorem-facing circuit |
| GHL2025 Definition `def:block-encoding` | clean signal projection | QBE-local projection theorem | active finite feeder remains open |

## Lean Contract

The arbitrary-`H` statement

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

is retired as the default lower target.  It may be assigned only with a true
all-`H` finite composition proof or an all-`H` clean-column independence theorem.

The source-backed contract keeps the paper preparation hypothesis explicit and
uses the compiled route

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
  H env hUniform hFold
```

where

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
hFold :
  oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The corresponding equivalence already compiled as

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3
  H env hUniform
```

and must be reused rather than rediscovered.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Status |
|---|---|---|---|---|---|
| `source_uniform_contract` | all-slot clean-column sparse-register amplitudes | Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | contract-only |
| `source_contract_target_correction` | source-prepared field recovered from a finite projection feeder under `Uniform(H)` | source audit; compiled equivalences | middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | compiled route |
| `finite_projection_feeder` | active clean projection equals backend fold after `Coeff.evalWith` | Definition `def:block-encoding`; Eq. `ROBIN clarified`; backend branch fold definitions | lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or one strict feeder | active leaf; open |
| `arbitrary_H_source_prepared_field` | `SourcePreparedField(H, env)` for arbitrary `H` | needs true all-`H` composition or independence theorem | none by default | `SourcePreparedField(H, env)`; `PreparedEntry(H)` | retired as default |
| `direct_hfree_closure_route` | H-free fold used as theorem-facing closure without the source-prepared bridge | lower diagnostics | none | diagnostic `sorry` route near `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | rejected |

## Lower-Facing Packet

Lower2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.

The assigned theorem is a finite projection feeder for
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, or one
strictly smaller theorem that directly feeds it.  The feeder must be consumed
through
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
H env hUniform hFold`.

Lower2 must not add `Uniform(H)` to the existing arbitrary-`H`
`SourcePreparedField(H, env)` target.  If proving that arbitrary target needs
`Uniform(H)`, the feedback class is `source_translation_gap`.  If a route uses
the standalone H-free fold as theorem-facing closure without the
source-prepared bridge, the feedback class is `shape_or_register_gap`.

Lower3 should check source correspondence and clean-column sensitivity only:
the useful checks are whether the lower proof target is consumed by the
explicit `hUniform` bridge, whether no arbitrary-`H` theorem has been silently
strengthened, and whether no diagnostic `sorry` route is used.

The first-case-study one-term theorem remains open.  No oracle, `H_W`, `R_y`,
LCU, block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, normalizer, or external
primitive flag is promoted by this packet.

Gate result: `python3 tools/qbe.py check`, `lake build`, and
`lake build Tests` passed, with only the known diagnostic `sorry` warnings at
`QuantumBlockEncoding/RobinMatrix.lean:24330` and
`QuantumBlockEncoding/RobinMatrix.lean:24361`.
