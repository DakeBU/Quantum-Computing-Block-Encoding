# 2026-06-13 Middle Packet: Prepared Projection Restatement

Task: `QBE-AUTO-002`  
Run: `20260613-172255-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf family: `source_prepared_projection_restatement`

## Verdict

Use the latest upper handoff in
`runs/20260613-172255-QBE-AUTO-002-cycle01/dialogue.md`.  The ChatGPT Pro
strict H-free feeder is stale for this run.  The retired target is:

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

It compares active full-basis index `0` with selected sparse slot `2` at full
index `32`, so it remains classified as `shape_or_register_gap`.

The current source-faithful route is the prepared projection entry of the full
Fig. `fig:1 term ROBIN` source circuit.  The prepared-side backend bridge is
already compiled under the explicit clean-column contract:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
  H env hUniform
```

## Source Anchors

Use public paper anchors and bundled proof notes, not local absolute paths:

| Anchor | Use in this packet |
|---|---|
| GHL2025 Eq. `arbitrary sparcity` | source for the `H_W^(kappa)` clean-column contract |
| GHL2025 Eq. `ROBIN clarified` | boundary gamma3 sparse summand and backend branch fold |
| GHL2025 Fig. `fig:1 term ROBIN` | full prepared route with both `H_W` sides |
| GHL2025 Definition `def:block-encoding` | clean projection entry selected by the theorem |
| `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` | audit separating the full source circuit from the H-free seven-gate backend component |

## Definitions

Let `PreparedProjectionEntry(H, env)` be:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
```

Let `ActiveSignalEntry(env)` be:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry
```

Let `ActivePreparedEntry(H)` be:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Let `Uniform(H)` be:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

## Proof Translation

1. Eq. `arbitrary sparcity` supplies `Uniform(H)`.  This remains an explicit
   contract and is not formalized in this packet.
2. Fig. `fig:1 term ROBIN` supplies the full prepared route.  Lean names the
   selected clean projection as
   `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.
3. The prepared projection entry reaches the backend fold by
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
   H env hUniform`.
4. The missing local field is the active/prepared entry comparison, packaged as
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H`.  Do not replace
   it with the retired H-free selected-slot feeder.
5. A lower2 route leaf may prove that an active/prepared projection-entry
   equality feeds the evaluated backend fold.  This route keeps `Uniform(H)`
   explicit and promotes no semantic flags.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Status |
|---|---|---|---|---|---|
| `strict_hfree_feeder_retirement` | reject `ActiveEval(env) = selectedSlotContribution(env)` | active index `0`; selected slot `2` / full index `32` | middle | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | retired; `shape_or_register_gap` |
| `prepared_projection_entry_backend_bridge` | evaluate prepared projection entry to backend fold under `Uniform(H)` | prepared sparse clean entry; prepared sandwich fold | closed | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiled conditional bridge |
| `active_prepared_entry_field` | prove active signal entry equals prepared clean entry | prepared matrix interface; source projection target | lower2 after calibration | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | open local field |
| `prepared_projection_restatement_leaf` | consume an active/prepared projection-entry equality and recover `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | prepared bridge; `Uniform(H)` | lower2 | proposed theorem below | active lower2 route leaf |
| `source_prepared_active_field_unwrapped` | expose old source-prepared active field as an H-free active entry compared with prepared sparse clean entry | active/prepared wrappers | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` | obstruction map only |

## Lower1 Packet

Write:

```text
proof-attempts/QBE-AUTO-002/source-prepared-projection-restatement-lower1-<timestamp>.md
```

Scope:

- No Lean edits.
- Map the source anchors above to `preparedProjectionEntry`,
  `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3`, and the compiled
  prepared-entry backend bridge.
- State why `activeToPreparedSingletonEvalStatement` is an obstruction map
  unless it is restated through `preparedProjectionEntry`.
- Identify whether lower2 should prove the route leaf below or first add a
  smaller equivalence between `ActiveSignalEntry(env) = PreparedProjectionEntry(H, env)`
  and `ActivePreparedEntry(H)`.

Acceptance:

- The strict H-free feeder stays retired.
- `Uniform(H)` stays explicit.
- No new register, matrix, normalizer, or theorem definition is duplicated.

## Lower2 Packet

Write scope:

```text
QuantumBlockEncoding/RobinMatrix.lean
```

Prove exactly one source-shaped route/restatement leaf.  Preferred target:

```lean
theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3
    (H : Matrix 8 8 Coeff) (env : String -> Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hEntry :
      let target :=
        oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
      Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      Coeff.evalWith env target.preparedProjectionEntry) :
    oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env := by
  ...
```

Expected proof shape:

1. Unfold the source-prepared target enough to read `hEntry` as
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`.
2. Apply
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
   H env hUniform`.

If this exact theorem is already present when lower2 starts, classify the leaf
as `stale_leaf` and do not add another alias.

Lower2 must not:

- prove or revive `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`;
- use `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
  `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as theorem
  closure;
- add assumptions to the paper theorem;
- promote oracle, `H_W`, `R_y`, LCU, unitarity, block-projection, normalizer,
  or final-extraction flags.

## Lower3 Packet

Write:

```text
verifier-feedback/QBE-AUTO-002/source-prepared-projection-restatement-lower3-<timestamp>.json
```

Required checks:

- `preparedProjectionEntry` is the clean entry of the full prepared source
  target.
- The prepared route contains both `H_W^(kappa)` side gates as a source
  contract, while the active seven-gate backend list remains H-free.
- Active full-basis index `0` and selected sparse slot `2` / full index `32`
  are still different finite paths.
- The next lower2 theorem is a route/restatement leaf, not a proof that the
  H-free active row equals the selected sparse contribution.

## Typed Feedback Template

```json
{
  "leaf": "source_prepared_projection_restatement",
  "source_correspondence_ok": true,
  "prepared_projection_entry_selected": true,
  "strict_hfree_feeder_retired": true,
  "lean_parse_ok": null,
  "lean_build_ok": null,
  "finite_matrix_ok": "pending_lower3",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": null,
  "closed_theorem_ok": false,
  "closed_theorem_scope": "route/restatement only; one-term Robin theorem remains open",
  "error_class": "source_translation_gap",
  "next_route": "lower2 proves one active/prepared projection-entry route leaf with Uniform(H) explicit; lower3 rejects any revived H-free selected-slot feeder as shape_or_register_gap"
}
```

## Gate

Any Lean edit must pass:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

This packet itself changes only proof-control memory and lower-agent scope.
