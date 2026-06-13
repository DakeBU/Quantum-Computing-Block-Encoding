# 2026-06-13 Middle Source-Prepared Contract Clarification

Task: `QBE-AUTO-002`  
Run: `20260613-052836-QBE-AUTO-002-cycle01`  
Mode: faithful paper reproduction

The configured local GHL2025 TeX archive was not available for this run.  This
packet therefore uses the checked-in source maps in
`conversion-windows/QBE-AUTO-002.md`, `proof-obligations/QBE-AUTO-002.md`,
`paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`, and
`research-wiki/cited-results/GHL2025.md`.  Public references remain the
GHL2025 anchors Eq. `arbitrary sparcity`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and Definition `def:block-encoding`.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

Define `Uniform(H)` to be
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Define `SourcePreparedField(H, env)` to be
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.

Define `UncastActivePrepared(H, env)` to be
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`.

Define `CachedPreparedEntry(H)` to be
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.

Define `BackendFold(env)` to be
`Coeff.evalWith env (blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3)`.

## Source-Contract Audit

| Source anchor | Lean-facing contract | Classification | Lower decision |
|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula sparse-preparation dependency | `Uniform(H)` | external cited contract, contract-only | use only for downstream prepared-to-backend recovery; do not formalize the cited primitive here |
| GHL2025 Eq. `ROBIN clarified`; Fig. `fig:1 term ROBIN` | active seven-gate signal-zero entry and the prepared singleton clean entry must remain tied to the source-prepared sandwich | GHL-internal transcript plus QBE-local finite matrix semantics | prove the source-prepared field or a strict feeder; do not reassign standalone H-free evaluated fold |
| GHL2025 Definition `def:block-encoding` | the clean projection entry is compared with the prepared/backend fold | QBE-local finite projection/composition theorem | active lower2 leaf remains open |
| Missing local TeX archive in this run | no fresh line-level TeX re-read was possible | source audit limitation | rely on checked-in source maps; if a new source ambiguity appears, route back to middle before Lean proof search |

## Proof-Translation Map

| Proof step | Current Lean status | Next action |
|---|---|---|
| Remove source-prepared wrappers from `SourcePreparedField(H, env)` | compiled: `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env` | reuse only |
| Prove the active signal-zero entry equals the source-prepared singleton clean entry | open: `SourcePreparedField(H, env)`, `UncastActivePrepared(H, env)`, or `CachedPreparedEntry(H)` | lower2 active leaf |
| Transport a cached entry proof into the theorem-facing source field | compiled: `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_entryTarget_n3 H env`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_entryTarget_n3 H env` | reuse if lower2 proves `CachedPreparedEntry(H)` |
| Compare the prepared singleton clean entry with the backend fold | compiled under `Uniform(H)`: `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | downstream only |
| Recover evaluated backend fold after the source-prepared field closes | compiled: `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | recovery root; not the current lower2 target |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | all-slot clean-column behavior for the paper sparse-preparation matrix | GHL2025 Eq. `arbitrary sparcity`; cited-results ledger | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `source_prepared_wrapper` | `SourcePreparedField(H, env)` is equivalent to `UncastActivePrepared(H, env)` | source-prepared target; active/prepared circuit-field target | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env` | conversion window | already gated | compiled |
| `cached_entry_route` | cached entry equality implies the source-prepared field | active/prepared entry target | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_entryTarget_n3 H env` | Section 21.25 lower1 addendum | already gated | compiled |
| `source_prepared_finite_composition_leaf` | active signal-zero entry equals the source-prepared singleton clean entry | source-prepared wrappers; finite `CircuitMatrixSemantics` matrix product | lower2 | `SourcePreparedField(H, env)`, `UncastActivePrepared(H, env)`, or `CachedPreparedEntry(H)` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf; open |
| `strict_source_shaped_feeder` | one local finite theorem directly feeding the active leaf without adding `Uniform(H)` to the arbitrary-`H` target | source transcript guard; active/prepared wrappers | lower2 alternate | new local theorem in `QuantumBlockEncoding/RobinMatrix.lean` | this packet | same gate | allowed only if it directly feeds the active field |
| `evaluated_backend_fold_recovery` | evaluated backend fold after the source-prepared field closes | active leaf; `Uniform(H)`; prepared backend bridge | later | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | proof blueprint | same gate after active leaf | recovery root; open |
| `direct_hfree_evaluated_fold_route` | standalone H-free active `[0,0]` entry compared with backend fold | evaluated-fold diagnostics | none | diagnostic route around `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` and `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | verifier feedback | none | rejected as default; `shape_or_register_gap` |

## Lower Packets

Lower 1 may append only a one-paragraph postscript if needed.  The postscript
should point to this packet and Section 21.25 of
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
It should not rebuild the proof map from scratch.

Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.  The target is
`SourcePreparedField(H, env)`, `UncastActivePrepared(H, env)`,
`CachedPreparedEntry(H)`, or one strictly smaller finite theorem that directly
feeds one of those statements.  The worker must not add `Uniform(H)` to the
current arbitrary-`H` target.  If every route needs `Uniform(H)`, the result is
`source_translation_gap` and the target returns to middle for a source-backed
restatement.

Lower 3 checks only source-shaped active/prepared composition, clean-column
independence, or finite matrix-support diagnostics.  Standalone H-free
selected-slot or backend-fold reassignment remains `shape_or_register_gap`.

Retired targets remain retired: obstruction handles, feeder equivalences,
compiled bridge rediscovery, raw `Coeff` constructor equalities, branch-sum
wrappers, backend slot vanish/support work, H-free active-selected diagnostics,
and diagnostic `sorry` routes.

The first-case-study one-term theorem remains open.  No oracle, `H_W`, `R_y`,
LCU, block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, normalizer, or external
primitive flag is promoted by this packet.
