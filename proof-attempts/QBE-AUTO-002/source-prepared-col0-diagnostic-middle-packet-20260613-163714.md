# 2026-06-13 Middle Packet: Source-Prepared Guard And Column-0 Diagnostic

Task: `QBE-AUTO-002`
Run: `20260613-163714-QBE-AUTO-002-cycle01`
Mode: `faithfulPaper`

## Coordinator Decision

Use the latest upper handoff and the on-disk current task directive, not the
older ChatGPT Pro strict-feeder override if it appears in a replayed focused
prompt.  The strict H-free feeder

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

is retired as a lower2 theorem target.  It compares the active H-free
full-basis entry `[0,0]` with the selected sparse slot `2` contribution at
full index `32`.  Existing lower1/lower3 feedback classifies this as
`shape_or_register_gap`.

The source-faithful route remains the prepared sparse-register projection
route:

```text
Eq. arbitrary sparcity
  -> Uniform(H)
  -> Fig. fig:1 term ROBIN prepared circuit
  -> prepared singleton clean entry
  -> backend branch fold under Uniform(H)
  -> Definition def:block-encoding clean projection
```

The next Lean worker should not attack the whole source-prepared feeder
blindly.  The ready one-lemma guard is the evaluated column-`0` bridge from the
active `evalGateMatrices` fold to the explicit seven-gate matrix entry.

## Reused Evidence

| Artifact | Role |
|---|---|
| `proof-attempts/QBE-AUTO-002/source-prepared-projection-summation-lower1-20260613-163053.md` | source proof map and DAG addendum |
| `verifier-feedback/QBE-AUTO-002/source-prepared-projection-summation-lower3-20260613-163030.json` | branch/register necessary-condition check |
| `proof-attempts/QBE-AUTO-002/finite-path-feeder-lower2-tailkill-normalform-20260613-161435.md` | compiled active column-`0` tail-kill normal form |
| `verifier-feedback/QBE-AUTO-002/finite-path-feeder-lower2-tailkill-20260613-161435.json` | typed feedback for the closed tail-kill leaf |

## Definitions

Let `ActiveEval(env)` be

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `ExplicitSevenGate00(env)` be

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySevenGateMatrix_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `Uniform(H)` be

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Let `SourcePreparedField(H, env)` be

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `strict_hfree_feeder_retirement` | reject `ActiveEval(env) = selectedSlotContribution` as a theorem target | lower1/lower3 support audit; active/selected index split | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | conversion window and proof obligations | project gate | retired; `shape_or_register_gap` |
| `active_col0_tail_kill_normal_form` | explicit seven-gate `[0,0]` entry evaluates to zero by two `R_y` branches killed through `O_f` | explicit seven-gate path support | closed lower2 | `oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3` | lower2 tail-kill packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | proved |
| `active_eval_gate_matrices_column0_bridge` | prove `ActiveEval(env) = ExplicitSevenGate00(env)` without using sorry-guarded raw matrix equality | gate fold/product associativity; active backend gate list | lower2 | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env` | this packet | same gate | active guard leaf |
| `source_prepared_sparse_clean_feeder` | prove `SourcePreparedField(H, env)` or an equivalent uncast prepared sparse-clean comparison under the explicit source contract | source proof map; branch-correct active-side statement after the guard | middle then lower2 | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` feeds it | source-prepared lower1 addendum | same gate | blocked until the guard confirms the active-side shape |
| `evaluated_backend_fold_recovery` | recover `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` through the source-prepared route | source-prepared field; `Uniform(H)`; compiled bridge | later lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | conversion window | same gate | blocked on source-shaped field |

## Lower-Agent Split

### lower1: Natural-Language Proof Architect

Do not rewrite the full proof map unless a lower2 bridge failure exposes a new
source issue.  Reuse
`source-prepared-projection-summation-lower1-20260613-163053.md`.

If asked for a short addendum, write only a column-`0` bridge dependency map:

| Role | Lean declaration |
|---|---|
| active fold entry | `evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)) row0 row0` |
| explicit product entry | `oneTermRobinGamma3BoundarySevenGateMatrix_n3 row0 row0` |
| row index | `oneTermRobinGamma3BoundaryPrefixRow0_n3` |
| existing tail-kill normal form | `oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3` |
| stale raw matrix equality | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` |

Lower1 must keep the stale raw matrix equality out of theorem closure.

### lower2: Lean Implementation Worker

Edit only `QuantumBlockEncoding/RobinMatrix.lean`.

Prove exactly this guard theorem, or a strictly smaller helper that feeds it
directly:

```lean
theorem oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Allowed proof route:

- unfold only the fold/product definitions needed for the seven active backend
  gates;
- use matrix associativity or entry-level congruence for that product;
- avoid full raw symbolic equality as theorem closure;
- do not use the sorry-guarded theorem
  `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`;
- do not prove `ActiveEval(env) = selectedSlotContribution`;
- do not add `hUniform` to the retired strict feeder.

After the Lean edit, run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

### lower3: Necessary-Condition Verifier

After lower2's guard attempt, write typed feedback under
`verifier-feedback/QBE-AUTO-002/` with:

```json
{
  "leaf": "active_eval_gate_matrices_column0_bridge",
  "source_correspondence_ok": true,
  "strict_hfree_feeder_retired": true,
  "finite_matrix_ok": "checked|blocked|failed",
  "block_entry_ok": false,
  "closed_theorem_ok": false,
  "error_class": "shape_or_register_gap",
  "next_route": "..."
}
```

If the guard compiles and combines with
`oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3`, record that the
active H-free `[0,0]` side is diagnostic zero.  That result should trigger a
middle retarget before any source-shaped feeder is attacked as a direct
equality from the H-free entry.

## Reject Routes

Reject any lower attempt that:

- revives `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env`;
- treats the H-free seven-gate backend as the full Fig. 4 prepared circuit;
- uses the sorry-guarded raw matrix equality as theorem closure;
- changes the gate order, oracle contracts, normalizer, or assumptions;
- promotes oracle, `H_W`, `R_y`, LCU, unitarity, block-projection,
  product-to-coefficient, final-extraction, or final theorem flags.

The first-case-study one-term theorem remains open.
