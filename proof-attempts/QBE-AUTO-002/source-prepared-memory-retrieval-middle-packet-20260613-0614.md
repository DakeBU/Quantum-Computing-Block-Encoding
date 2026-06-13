# 2026-06-13 Middle Memory Retrieval Packet

Task: `QBE-AUTO-002`  
Run: `20260613-054606-QBE-AUTO-002-cycle01`  
Role: middle memory/retrieval curator

## Inputs Read

- Recent trial memory from `runs/trials.jsonl`, especially the 05:44 lower2/lower3 failures and the 06:10 middle source-contract correction.
- Verifier cards under `verifier-feedback/QBE-AUTO-002/`, especially `source-prepared-uniform-target-correction-middle-20260613-0606.json`.
- Proof-attempt packets through `source-prepared-uniform-target-correction-middle-packet-20260613-0606.md`.
- Refreshed `proof-blueprints/QBE-AUTO-002.md`, `proof-blueprints/QBE-AUTO-002-status.md`, `runs/20260613-054606-QBE-AUTO-002-cycle01/memory_digest.md`, `runs/20260613-054606-QBE-AUTO-002-cycle01/todo.md`, and `research-wiki/retrieval-index/QBE-AUTO-002.json`.

## Stale Lower Targets To Retire

1. `SourcePreparedField(H, env)` for arbitrary `H` as the default lower target. It is assignable only with a true all-`H` finite composition proof or an all-`H` clean-column independence theorem.
2. Compiled route wiring, including `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` and the prepared-sandwich/sparse-clean feeders.
3. Direct standalone H-free closure of `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` through the seven-gate diagnostic route.
4. Obstruction handles, backend slot vanish/support work, raw `Coeff` constructor equality, branch-sum wrappers, compiled bridge rediscovery, and diagnostic `sorry` routes.

## Rejected Routes To Remember

- Adding `Uniform(H)` as a lower-local hypothesis to the existing arbitrary-`H` source-prepared target is a `source_translation_gap`, not a proof route.
- Treating the H-free active seven-gate `[0,0]` product as the theorem-facing prepared sandwich is a `shape_or_register_gap`.
- Recursively formalizing Shukla--Vedula state preparation is backlog for this leaf; the current paper route uses `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` as an explicit contract.
- Any closure using `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` remains non-closure while those declarations are diagnostic `sorry` routes.

## Current Active Proof-DAG Leaf

Active leaf id: `finite_projection_feeder`.

Lean interface:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

or one strict finite theorem in `QuantumBlockEncoding/RobinMatrix.lean` that directly feeds this statement.

Required consumption route:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
  H env hUniform hFold
```

with:

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
hFold :
  oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Dependencies:

| Dependency | Status |
|---|---|
| `source_uniform_contract` | contract-only external row from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula |
| `source_contract_target_correction` | compiled route through `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3` |
| finite projection/backend fold theorem | active lower2 leaf; open |
| first-case-study one-term theorem | open; no semantic flag promoted |

## Missing Typed Feedback Or Memory Updates

- `memory-refresh` regenerated `memory_digest.md`, `todo.md`, and the retrieval index, but the generated active leaf queue still names the older arbitrary-`H` source-prepared field. This packet and `verifier-feedback/QBE-AUTO-002/source-prepared-memory-retrieval-middle-20260613-0614.json` are the narrow override.
- The current GHL feedback card still begins with older evaluated-fold and source-prepared text. A new top section records `leaf=finite_projection_feeder`, `error_class=source_translation_gap` for the target correction, and `shape_or_register_gap` if the H-free route is reassigned.
- Next lower feedback must include `leaf`, `source_correspondence_ok`, `lean_parse_ok`, `lean_build_ok`, `finite_matrix_ok`, `block_entry_ok`, `closed_theorem_ok`, `error_class`, and `next_route`. Use `null` for irrelevant fields.

## Next-Cycle Retrieval Packet

Read in this order:

1. `proof-attempts/QBE-AUTO-002/source-prepared-uniform-target-correction-middle-packet-20260613-0606.md`
2. `proof-attempts/QBE-AUTO-002/source-prepared-memory-retrieval-middle-packet-20260613-0614.md`
3. `verifier-feedback/QBE-AUTO-002/source-prepared-uniform-target-correction-middle-20260613-0606.json`
4. `verifier-feedback/QBE-AUTO-002/source-prepared-memory-retrieval-middle-20260613-0614.json`
5. `proof-obligations/QBE-AUTO-002.md` EOF section `2026-06-13 Middle Source-Contract Target Correction EOF`
6. `runs/20260613-054606-QBE-AUTO-002-cycle01/memory_digest.md`

Lower2 edits only `QuantumBlockEncoding/RobinMatrix.lean`. The next theorem is the finite projection feeder above, or one strict theorem feeding it. Lower3 checks source correspondence and clean-column sensitivity; it should reject standalone H-free closure as `shape_or_register_gap`.

