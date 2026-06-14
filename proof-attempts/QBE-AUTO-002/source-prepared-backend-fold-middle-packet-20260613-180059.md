# 2026-06-13 Middle Packet: Branch-Correct Source-Prepared Backend Fold

Task: `QBE-AUTO-002`  
Run: `20260613-180059-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf family: `branch_correct_source_prepared_backend_fold`

## Verdict

Use the upper handoff in
`runs/20260613-180059-QBE-AUTO-002-cycle01/dialogue.md`.

The ChatGPT Pro finite-path packet remains trial memory, but the direct
H-free selected-slot feeder

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

is retired for this run as `shape_or_register_gap`.  The active entry is full
index `0`, while the selected branch contribution is sparse slot `2` at full
index `32`.

The latest lower2 feeder

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_uncastPreparedSparseCleanEntry_n3
```

is compiled route wiring.  It consumes the exact unwrapped sparse-clean
evaluated equality and produces
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`, but
it does not prove that equality.  Do not reassign it as a fresh lower2 target.

The active local theorem is now the branch-correct evaluated backend fold:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

with the uncast form exposed by

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env
```

This removes arbitrary `H` from the statement that lower2 should prove.  The
source-prepared route remains available after the fold closes through

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
  H env hUniform hFold
```

where `hUniform` is still the explicit clean-column contract.

## Source Anchors

| Anchor | Lean-facing contract |
|---|---|
| GHL2025 Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; external clean-column contract only |
| GHL2025 Eq. `ROBIN clarified` | full seven-slot backend branch fold, not a standalone active row-`0` to slot-`2` equality |
| GHL2025 Fig. `fig:1 term ROBIN` | full prepared route with both `H_W^(kappa)` side gates around the seven-gate backend |
| GHL2025 Definition `def:block-encoding` | clean signal entry selected as `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |
| `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` | separates the source-prepared circuit from the H-free backend component |

## Definitions

Let `ActiveEntry(env)` be

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `BackendFold(env)` be

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

Let `PreparedSingleton(H, env)` be

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `Uniform(H)` be

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The next nontrivial Lean target is the equality
`ActiveEntry(env) = BackendFold(env)`, or equivalently
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

## Proof Translation

1. Eq. `arbitrary sparcity` supplies only `Uniform(H)`.  It does not prove the
   active H-free fold and must not be added to the H-free target.
2. Fig. `fig:1 term ROBIN` supplies the source-prepared comparison route.  Lean
   has compiled the prepared singleton and prepared sparse matrix wrappers.
3. Eq. `ROBIN clarified` is represented by the full backend branch fold.  Lower
   work should compare the active entry with the full fold, not directly with
   one selected sparse slot.
4. Definition `def:block-encoding` selects the clean signal entry.  Lean
   exposes this entry through `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3`.
5. After the evaluated backend fold is proved, the source-prepared active field
   follows under the explicit clean-column contract.  The compiled route is
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `strict_hfree_selected_slot_feeder` | direct active row `0` equals selected sparse slot `2` contribution | deployment packet; lower1/lower3 finite path diagnostics | none | proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env` | finite-path feedback packets | none | retired; `shape_or_register_gap` |
| `compiled_sparse_clean_feeder` | unwrapped sparse-clean equality implies the source-prepared composite eval statement | source-prepared target wrappers | none | `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_uncastPreparedSparseCleanEntry_n3 H env hSparseClean` | lower2 17:58 packet | full gate already passed | compiled feeder; stale as lower target |
| `source_prepared_to_fold_wiring` | source-prepared active field is equivalent to the evaluated backend fold under `Uniform(H)` | prepared singleton backend bridge | none | `oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3 H env hUniform`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | this packet | project gate | compiled route wiring; not theorem closure |
| `evaluated_backend_fold_leaf` | prove the active clean entry evaluates to the full backend branch fold | active entry cast removal; branch-sum fold; finite support/path calculation | lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; uncast form from `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf; open |
| `backend_expansion_raw_field` | stronger raw `Coeff` equality between signal entry and backend fold | finite backend expansion; no raw diagnostic sorry closure | later/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | Lean route wiring near backend expansion target | same gate | open stronger route; use only if lower2 chooses raw-to-eval bridge deliberately |
| `downstream_source_prepared_recovery` | recover the source-prepared active field once evaluated fold is proved | `evaluated_backend_fold_leaf`; `Uniform(H)` | later | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | this packet | same gate | compiled; blocked on evaluated fold proof |

## Lower1 Packet

Write:

```text
proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-lower1-<timestamp>.md
```

Scope:

- No Lean edits.
- Map Eq. `ROBIN clarified` to the full backend branch fold, not to a direct
  slot-`2` shortcut.
- Explain how the active clean entry from Definition `def:block-encoding`
  reaches the uncast active entry in
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`.
- Identify whether the next lower2 proof should attack the evaluated fold
  directly or first prove one strict path-collapse feeder into the same fold.
- Record that `Uniform(H)` enters only when recovering the source-prepared
  field after the evaluated fold is supplied.

## Lower2 Packet

Write scope:

```text
QuantumBlockEncoding/RobinMatrix.lean
```

Prove exactly one nontrivial branch-correct leaf.  Preferred target:

```lean
theorem oneTermRobinGamma3BoundaryUncastActiveEntryEval_eq_backendFold_n3
    (env : String → Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) := by
  ...
```

The theorem may instead close
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` directly if
it uses the existing uncast equivalence.

Lower2 may prove one smaller path-collapse, support, or branch-sum feeder only
when the statement feeds the displayed equality without changing the paper
circuit or adding hypotheses.  Lower2 must not:

- revive `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`;
- reprove compiled route-wiring leaves from the 17:42, 17:58, or 18:00 memory;
- close the theorem with the sorry-guarded raw diagnostic declarations;
- add `hUniform` to the H-free evaluated backend fold;
- prove arbitrary-`H` active/prepared equality without a source-backed finite
  composition bridge;
- promote oracle, `H_W`, `R_y`, LCU, unitarity, block-projection, normalizer,
  product-to-coefficient, block-correctness, or final-extraction flags.

## Lower3 Packet

Write:

```text
verifier-feedback/QBE-AUTO-002/source-prepared-backend-fold-lower3-<timestamp>.json
```

Required checks:

- The evaluated fold uses the full backend branch sum, not only
  `selectedSlotContribution`.
- The active side remains the H-free signal-zero `[0,0]` entry selected by the
  finite block projection.
- The source-prepared recovery route uses `Uniform(H)` only after the evaluated
  backend fold is supplied.
- Any proof route that collapses to arbitrary entries of an unconstrained `H`
  without a concrete source-prepared bridge is `source_translation_gap`.
- Any direct active row-`0` to selected slot-`2` reassignment is
  `shape_or_register_gap`.

## Typed Feedback Template

```json
{
  "leaf": "branch_correct_evaluated_backend_fold",
  "source_correspondence_ok": true,
  "lean_parse_ok": null,
  "lean_build_ok": null,
  "finite_matrix_ok": "pending_lower3",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": null,
  "closed_theorem_ok": false,
  "retired_hfree_feeder": "shape_or_register_gap",
  "compiled_route_wiring": true,
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove ActiveEntry(env) = BackendFold(env) at evalWith level, then consume source-prepared recovery under explicit hUniform"
}
```

## Gate

Any Lean edit must pass:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

This middle packet changes proof-control memory and lower-agent scope only.
