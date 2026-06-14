# 2026-06-13 Middle Packet: Backend-Fold Obstruction Retarget

Task: `QBE-AUTO-002`  
Run: `20260613-182230-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf family: `branch_correct_evaluated_backend_fold_obstruction`

## Verdict

Use the upper handoff in
`runs/20260613-182230-QBE-AUTO-002-cycle01/dialogue.md`.

The all-environment H-free evaluated backend fold is retired as an active proof
target for this cycle:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Lower2 already compiled the normal form

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
```

so the fold is equivalent to selected slot-`2` scalar vanishing:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution = 0
```

Lower3 also recorded a finite all-one environment where the selected slot-`2`
branch evaluates nonzero.  This is not a Lean tactic gap.  It is a
`finite_matrix_counterexample` for the current all-env row-`0`/slot-`2`
contract, with the older direct selected-slot feeder still classified as
`shape_or_register_gap`.

## Definitions

Define `ActiveEntry(env)` as

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define `BackendFold(env)` as

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

Define `SelectedSlot(env)` as

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

Define `Uniform(H)` as

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The compiled facts are:

- `ActiveEntry(env) = 0`, by
  `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`.
- `BackendFold(env) = SelectedSlot(env)`, by
  `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`.
- The root fold is equivalent to `SelectedSlot(env) = 0`, by
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`.

## Source-Contract Audit

| Source anchor | Paper object | Lean correspondence | Classification |
|---|---|---|---|
| GHL2025 Eq. `ROBIN clarified` | nonzero displayed boundary contribution for the selected gamma3 branch | selected slot `2` branch contribution, full index `32` | source branch; not zero by default |
| GHL2025 Fig. `fig:1 term ROBIN` and Fig. 4 audit | full prepared route with `H_W^(kappa)` around the backend component | source-prepared recovery lemmas under `Uniform(H)` | downstream route only |
| GHL2025 Eq. `arbitrary sparcity` | clean sparse-register superposition | `Uniform(H)` | external cited contract; downstream only |
| GHL2025 Definition `def:block-encoding` | clean signal entry | active H-free row `0` in the current Lean target | current row/register contract under audit |
| lower3 finite diagnostic | all-one selected slot contribution is nonzero | finite witness recorded in verifier feedback | `finite_matrix_counterexample` |

The current H-free fold should not be proved for all `env` unless a
source-backed selected-zero theorem is supplied.  The paper source currently
supports the opposite interpretation for the displayed boundary branch:
the selected contribution is a real branch contribution, not a vanishing term.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `active_column0_zero_eval` | `ActiveEntry(env) = 0` | evalGateMatrices column-`0` bridge; seven-gate tail kill | none | `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env` | lower2 column-0 diagnostic packets | project gate | proved diagnostic |
| `backend_fold_to_selected_eval` | `BackendFold(env) = SelectedSlot(env)` | nonselected backend slot vanish family | none | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | backend fold packets | project gate | proved |
| `fold_selected_zero_normal_form` | root H-free fold is equivalent to `SelectedSlot(env) = 0` | active zero; backend fold collapse | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3 env` | lower2 18:19 packet | project gate | proved normal form |
| `selected_slot_nonzero_counterexample` | provide one concrete `env` with `SelectedSlot(env) != 0` | selected slot product eval; projection amplitude factor; finite all-one environment | lower2 | proposed `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` | this packet; lower3 18:18 diagnostic | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | preferred active obstruction leaf |
| `fold_forces_selected_zero_guard` | name the implication from a fold proof to `SelectedSlot(env) = 0` | normal-form lemma | lower2 fallback | proposed `oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3` | lower1 18:18 route guard | same gate | fallback active obstruction leaf |
| `hfree_evaluated_backend_fold` | prove `ActiveEntry(env) = BackendFold(env)` for all `env` | would require selected slot vanishing | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | old 18:00 packet | none | retired; `finite_matrix_counterexample` |
| `source_prepared_retarget` | return to source-prepared proof search only after the obstruction is formalized and a corrected source/register target is assigned | obstruction leaf; source audit | middle/later | no new Lean target yet | future packet | no gate yet | blocked |

## Lower1 Packet

Write:

```text
proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-obstruction-lower1-<timestamp>.md
```

Scope:

- No Lean edits.
- Translate the proof contradiction in source terms: the active H-free row
  `0` evaluates to zero, while Eq. `ROBIN clarified` uses a selected
  boundary branch contribution at sparse slot `2`.
- Reuse the existing source anchors above and the Fig. 4 audit.  Do not add
  a new paper assumption.
- Name the exact lower2 leaf.  Prefer the nonzero counterexample; use the
  route-guard wrapper only if the nonzero witness is delayed by algebra.

## Lower2 Packet

Write scope:

```text
QuantumBlockEncoding/RobinMatrix.lean
```

Prove exactly one obstruction leaf.

Preferred target:

```lean
theorem oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3 :
    let env : String -> Rat :=
      fun name =>
        if name = "f_3_0" then 1
        else if name = "N_f_inv" then 1
        else if name = "boundary_cos_half_0_2" then 1
        else if name = "sqrt_kappa_inv" then 1
        else 0
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
      = 1 := by
  ...
```

The proof should reuse the selected branch product evaluation
`oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3` and
the transcript facts showing the projection factor is
`sqrt_kappa_inv * sqrt_kappa_inv`.  It must not add a coefficient assumption
or promote the boundary half-angle/product-to-coefficient obligations.

Fallback target:

```lean
theorem oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3
    (env : String -> Rat)
    (hFold : oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env) :
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution = 0 := by
  exact
    (oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
      env).1 hFold
```

Lower2 must not:

- prove the root fold as an unconditional theorem;
- revive `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`;
- add `hUniform` to the H-free fold;
- prove arbitrary-`H` active/prepared closure;
- use `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`,
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic`,
  or raw `Coeff` constructor equality as theorem closure;
- promote oracle, `H_W`, `R_y`, LCU, unitarity, block-projection, normalizer,
  product-to-coefficient, block-correctness, or final-extraction flags.

## Lower3 Packet

Write:

```text
verifier-feedback/QBE-AUTO-002/source-prepared-backend-fold-obstruction-lower3-<timestamp>.json
```

Required checks:

- Confirm the proposed nonzero witness uses only the selected slot-`2`
  contribution and not the active row-`0` entry.
- Confirm `finite_matrix_ok=false` for the old root fold and
  `block_entry_ok=false` for the old row-`0`/fold equality.
- Confirm `hUniform` remains downstream-only and is not inserted into the
  H-free obstruction theorem.
- Classify the old root fold as `finite_matrix_counterexample` and the direct
  row-`0` to selected slot-`2` feeder as `shape_or_register_gap`.

## Typed Feedback Template

```json
{
  "leaf": "branch_correct_evaluated_backend_fold_obstruction",
  "source_correspondence_ok": false,
  "lean_parse_ok": null,
  "lean_build_ok": null,
  "finite_matrix_ok": false,
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": null,
  "closed_theorem_ok": false,
  "retired_root": "oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env",
  "preferred_lower2_leaf": "oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3",
  "fallback_lower2_leaf": "oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3",
  "error_class": "finite_matrix_counterexample",
  "next_route": "formalize one obstruction leaf, then middle/reviewer should restate the source-prepared target before any new proof search"
}
```

## Gate

Any Lean edit must pass:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

This middle packet changes proof-control memory and lower-agent scope only.
