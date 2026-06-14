# 2026-06-13 Middle Packet: Source-Prepared Finite Composition

Task: `QBE-AUTO-002`  
Run: `20260613-174250-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf family: `source_prepared_finite_composition`

## Verdict

Use the latest upper handoff in
`runs/20260613-174250-QBE-AUTO-002-cycle01/dialogue.md`.

The ChatGPT Pro finite-path deployment packet was not ignored.  Lower1 and
lower3 mapped it to the current Lean objects and lower3 rejected the direct
strict feeder

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

as `shape_or_register_gap`: the left side is the active full-basis row `0`
two-path tail-kill diagnostic, while the selected contribution is sparse slot
`2` at full index `32`.

The already compiled restatement

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3
```

is also retired as a lower target.  It proves only route wiring: an
active/prepared projection-entry equality plus the explicit `Uniform(H)`
contract would imply the evaluated backend fold.

## Source Anchors

Use public anchors and bundled proof notes, not local absolute paths.  The
local TeX path advertised in some prompts is not present in this checkout.

| Anchor | Lean-facing contract |
|---|---|
| GHL2025 Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; contract-only |
| GHL2025 Eq. `ROBIN clarified` | selected gamma3 branch and backend fold memory |
| GHL2025 Fig. `fig:1 term ROBIN` | full prepared route with both `H_W^(kappa)` sides |
| GHL2025 Definition `def:block-encoding` | clean signal projection entry |
| `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` | separates the full source-prepared circuit from the H-free seven-gate backend component |

## Definitions

Let `ActivePreparedField(H, env)` be

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

Let `EntryTarget(H)` be

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Let `UncastActivePrepared(H, env)` be

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

Let `Uniform(H)` be

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

## Proof Translation

1. Eq. `arbitrary sparcity` supplies `Uniform(H)` only for downstream prepared
   backend recovery.  It is not a proof of the active/prepared finite
   composition field.
2. Fig. `fig:1 term ROBIN` supplies the full prepared
   `H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)` clean-entry route.
3. Definition `def:block-encoding` selects the clean signal entry on the active
   side.  Lean names that comparison by `ActivePreparedField(H, env)`.
4. The current active proof leaf is the finite composition theorem equating
   the active signal-zero entry with the prepared singleton clean entry.
5. The compiled bridges
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3`,
   and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
   should be reused.  Do not duplicate the target under a new matrix or
   register definition.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | clean-column behavior of `H_W^(kappa)` over the seven sparse slots | Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | contract-only; keep explicit |
| `strict_hfree_feeder` | active row `0` equals selected slot `2` contribution | finite path map from lower1/lower3 | none | proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env` | deployment packet and lower3 JSON | none | retired; `shape_or_register_gap` |
| `projection_restatement_leaf` | active/prepared projection entry equality plus `Uniform(H)` implies evaluated backend fold | prepared backend bridge | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3 H env hUniform hEntry` | lower2 restatement packet | already gated | compiled; stale as lower target |
| `active_prepared_finite_composition_leaf` | active signal-zero entry equals the source-prepared singleton clean entry | prepared circuit semantics; active/prepared wrappers; Fig. 4 transcript split | lower2 | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active source-prepared leaf; open |
| `uncast_sparse_clean_entry_feeder` | expose the active/prepared field as an evaluated uncast active entry compared with the prepared sparse clean entry | current wrapper bridges | lower2 only if proving one small feeder | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` | this packet | same gate | compiled equivalence; do not rediscover |
| `evaluated_backend_fold_recovery` | recover the evaluated backend fold once the active/prepared field is supplied | `active_prepared_finite_composition_leaf`; `Uniform(H)`; prepared backend bridge | later | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | proof blueprint | same gate | blocked on active leaf |

## Lower1 Packet

Write:

```text
proof-attempts/QBE-AUTO-002/source-prepared-finite-composition-lower1-<timestamp>.md
```

Scope:

- No Lean edits.
- Map the source anchors above to `ActivePreparedField(H, env)`,
  `EntryTarget(H)`, and `UncastActivePrepared(H, env)`.
- Explain why the H-free row-`0` selected-slot feeder is retired but why the
  full source-prepared route remains source-faithful.
- Name one lower2 target from the active leaf row.  Prefer the uncast evaluated
  statement if no stronger finite composition theorem is ready.

## Lower2 Packet

Write scope:

```text
QuantumBlockEncoding/RobinMatrix.lean
```

Prove exactly one source-prepared finite-composition leaf or one strict feeder
into it.  Preferred target family:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

or the cached field:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Allowed smaller feeder:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

provided the proof uses the existing equivalences and does not add `Uniform(H)`
to the active/prepared field itself.

Lower2 must not:

- revive `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`;
- reprove the already compiled projection-restatement leaf;
- use the sorry-guarded raw diagnostic declarations as theorem closure;
- add assumptions, change gate order, change oracle contracts, or introduce a
  replacement circuit;
- promote oracle, `H_W`, `R_y`, LCU, unitarity, block-projection, normalizer,
  product-to-coefficient, or final-extraction flags.

## Lower3 Packet

Write:

```text
verifier-feedback/QBE-AUTO-002/source-prepared-finite-composition-lower3-<timestamp>.json
```

Required checks:

- The active leaf is source-shaped: full Fig. `fig:1 term ROBIN` preparation
  is represented by the prepared singleton clean-entry side.
- `Uniform(H)` is used only for downstream recovery to the backend fold.
- The active seven-gate backend list remains H-free and diagnostic by itself.
- Any reassignment of active row `0` directly to selected sparse slot `2` is
  rejected as `shape_or_register_gap`.

## Typed Feedback Template

```json
{
  "leaf": "source_prepared_finite_composition_leaf",
  "source_correspondence_ok": true,
  "lean_parse_ok": null,
  "lean_build_ok": null,
  "finite_matrix_ok": "pending_lower3",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": null,
  "closed_theorem_ok": false,
  "retired_hfree_feeder": "shape_or_register_gap",
  "retired_restatement_leaf": "compiled_stale_leaf",
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove one source-prepared active/prepared finite-composition leaf; do not revive the H-free row-0 to slot-2 feeder"
}
```

## Gate

Any Lean edit must pass:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

This middle packet changes only proof-control memory and lower-agent scope.
