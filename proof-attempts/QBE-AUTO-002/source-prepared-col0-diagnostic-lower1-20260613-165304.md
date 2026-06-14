# 2026-06-13 Lower1 Addendum: Active Column-0 Diagnostic Bridge

Task: `QBE-AUTO-002`  
Run: `20260613-163714-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`

## Source Fragment

The translated source fragment is GHL2025 Eq. `arbitrary sparcity`, Eq.
`angles for Ry`, Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and Definition `def:block-encoding`.

Definitions from the source fragment:

- Eq. `arbitrary sparcity` prepares the sparse register by
  $$H_W^{(\kappa)} |0\rangle = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle.$$
- Eq. `angles for Ry` defines the Robin boundary controlled-rotation angle
  $$\theta_j^s = \arccos(D_j^{(s)}/\mathcal{N}_D)$$
  for sparse slots $s$ and boundary indices $j < K_1$ or $K_2 < j < 2^n$.
- Eq. `ROBIN clarified` displays the boundary part of $|\gamma_3\rangle$ with
  clean-ancilla coefficient
  $$f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa),$$
  while non-displayed branches are in the trailing terms.
- Fig. `fig:1 term ROBIN` contains the full prepared circuit with
  $H_W^{(\kappa)}$ and $(H_W^{(\kappa)})^\dagger$ around the backend gates.
- Definition `def:block-encoding` is the clean projection predicate.

The active local theorem below is not the source theorem.  It is a guard for
the H-free backend component extracted from Fig. `fig:1 term ROBIN`.

## Definitions

Let `row0` be `oneTermRobinGamma3BoundaryPrefixRow0_n3`.  Lean proves
`row0.val = 0` through native finite evaluation and uses this row for the
active H-free entry.

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

Let the seven active backend gate matrices be

| Symbol | Existing Lean matrix |
|---|---|
| `G1` | `(GHL2025.oneTermRobinGate_U_indic (oneTermParameters 3)).matrix` |
| `G2` | `(GHL2025.oneTermRobinGate_O_DT_S (oneTermParameters 3)).matrix` |
| `G3` | `(GHL2025.oneTermRobinGate_Ry_boundary (oneTermParameters 3)).matrix` |
| `G4` | `(GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters 3)).matrix` |
| `G5` | `(GHL2025.oneTermRobinGate_O_f (oneTermParameters 3)).matrix` |
| `G6` | `(GHL2025.oneTermRobinGate_SWAP (oneTermParameters 3)).matrix` |
| `G7` | `(GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters 3)).matrix` |

The existing explicit product is split as

```lean
oneTermRobinGamma3BoundaryPrefixMatrix_n3 = G4 * (G3 * (G2 * G1))
oneTermRobinGamma3BoundarySuffixMatrix_n3 = G7 * (G6 * G5)
oneTermRobinGamma3BoundarySevenGateMatrix_n3 =
  oneTermRobinGamma3BoundarySuffixMatrix_n3 *
    oneTermRobinGamma3BoundaryPrefixMatrix_n3
```

The `evalGateMatrices` fold over `GHL2025.oneTermRobinGateMatrixPlaceholders
(oneTermParameters 3)` uses the same gate order by
`GHL2025.oneTermRobinGateMatrixPlaceholders_gateList`.

## Active Local Theorem

The active local theorem is:

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

Natural-language proof:

1. Unfold `evalGateMatrices` on the seven-element placeholder list.  The fold
   starts from the identity matrix and produces
   `G7 * (G6 * (G5 * (G4 * (G3 * (G2 * (G1 * I))))))`.
2. Remove the terminal identity at the evaluated entry level, using
   `Matrix.evalWith_mul_identity_right_apply` if a direct simplification leaves
   symbolic identity summands.
3. Reassociate the evaluated product entry to
   `(G7 * (G6 * G5)) * (G4 * (G3 * (G2 * G1)))`.  This is the entry-level
   version of `Matrix.mul_assoc`; the proof may use a local congruence over
   `Coeff.evalWith env (M row0 row0)`, but it must not invoke the sorry-guarded
   theorem `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.
4. Fold the left factor to `oneTermRobinGamma3BoundarySuffixMatrix_n3` and the
   right factor to `oneTermRobinGamma3BoundaryPrefixMatrix_n3` by their
   definitions.
5. Fold the final product to
   `oneTermRobinGamma3BoundarySevenGateMatrix_n3` by definition.

This proof is purely a finite matrix-semantics bridge for the H-free backend
product.  It does not use `Uniform(H)`, does not prove the prepared sparse
projection theorem, and does not identify the active row-`0` entry with the
selected sparse slot `2` contribution.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | sparse clean-column amplitude for all paper slots | Eq. `arbitrary sparcity`; Shukla--Vedula contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | conversion window | contract only | external contract; keep explicit |
| `fig4_backend_split` | separate full Fig. 4 from H-free backend list | Fig. `fig:1 term ROBIN`; visual audit | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` | project gate | compiled transcript guard |
| `strict_hfree_feeder_retirement` | reject direct `ActiveEval(env) = selectedSlotContribution` | lower1/lower3 support audit; index split | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | proof obligations | project gate | retired; `shape_or_register_gap` |
| `active_col0_tail_kill_normal_form` | explicit seven-gate `[0,0]` entry evaluates to zero through the two `O_f` tail entries | two-path support and finite zero entries | closed lower2 | `oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3`; `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | tail-kill packet | gates passed in prior run | proved |
| `active_eval_gate_matrices_column0_bridge` | prove `ActiveEval(env) = ExplicitSevenGate00(env)` at `evalWith` entry level | placeholder gate order; product associativity; identity-right evaluation | lower2 | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env` | this file | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active leaf |
| `active_eval_zero_diagnostic` | derive `ActiveEval(env) = 0` | `active_eval_gate_matrices_column0_bridge`; `active_col0_tail_kill_normal_form` | lower2 or middle | no new theorem required, optional wrapper | proof obligations | same gate if Lean is edited | blocked on bridge |
| `source_prepared_sparse_clean_feeder` | prove `SourcePreparedField(H, env)` or an equivalent prepared sparse-clean entry comparison | source route; branch-correct active-side target after guard | middle then lower2 | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` feeds it | source-prepared packet | same gate | blocked until guard is interpreted |
| `evaluated_backend_fold_recovery` | recover `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` under explicit `Uniform(H)` | source-prepared field; compiled bridge | later lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | conversion window | same gate | blocked on source-shaped field |

The next active leaf for the Lean worker is
`active_eval_gate_matrices_column0_bridge`.

## Intermediate Lean Lemmas

Reuse existing declarations in this order:

1. Gate-list and gate-matrix transcript guards:
   `GHL2025.oneTermRobinGateMatrixPlaceholders`,
   `GHL2025.oneTermRobinGateMatrixPlaceholders_gateList`, and
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
2. Product definitions:
   `evalGateMatrices`,
   `oneTermRobinGamma3BoundaryPrefixMatrix_n3`,
   `oneTermRobinGamma3BoundarySuffixMatrix_n3`, and
   `oneTermRobinGamma3BoundarySevenGateMatrix_n3`.
3. Entry-level matrix tools:
   `Matrix.evalWith_mul_identity_right_apply`,
   `Matrix.evalWith_mul_apply`, and ordinary product associativity or
   entry-level congruence for `Coeff.evalWith env (M row0 row0)`.
4. Active tail-kill facts, only after the bridge is proved:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`, and
   `oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3`.
5. Strict-feeder rejection facts, for diagnostics only:
   `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` and
   `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`.
6. Source-prepared recovery facts, only after middle retargets:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`.

If the direct bridge proof starts unfolding the entire raw `Coeff` equality,
the Lean worker should stop and introduce a smaller entry-only helper for
identity-right removal or for one associativity step.  The helper must still
target the evaluated entry, not the global raw matrix equality.

## Failure Analysis

The strict H-free selected-slot feeder remains mathematically misrouted.  Its
left side is the active full-basis row-`0`, column-`0` entry.  Its right side is
the selected sparse slot `2` contribution at full basis index `32`, including
the two sparse-register projection amplitudes.  Lean records this split in
`oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`.

The current active bridge is mathematically well-shaped only as a diagnostic
guard.  If lower2 proves the bridge, then
`oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3` immediately
shows `ActiveEval(env) = 0`.  Combining that with a revived strict feeder would
force the selected slot contribution to evaluate to zero, exactly the
obstruction recorded by
`oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`.

Therefore the bridge should be consumed only to classify the active H-free
entry.  The theorem-facing route must remain the source-prepared route:

```text
Eq. arbitrary sparcity
  -> Uniform(H)
  -> Fig. fig:1 term ROBIN prepared circuit
  -> prepared singleton clean entry
  -> backend branch fold under Uniform(H)
  -> Definition def:block-encoding clean projection
```

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `active_eval_gate_matrices_column0_bridge` |
| `source_correspondence_ok` | `true_for_diagnostic_backend_component_only` |
| `lean_parse_ok` | `not_applicable_no_Lean_edit` |
| `lean_build_ok` | `not_applicable_no_Lean_edit_before_gate` |
| `finite_matrix_ok` | `active_column0_tail_kill_compiled_bridge_open` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `not_promoted` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | prove the evaluated column-`0` bridge, then middle retargets before any source-shaped feeder is attempted |

## Handoff

Lower1 proof architecture is complete for the current diagnostic leaf.  The
ready Lean target is exactly
`oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
env`.  The proof should unfold the seven-gate `evalGateMatrices` fold and
associate it to the existing `suffix * prefix` product at `evalWith` entry
level.  Do not use the sorry-guarded raw theorem, do not revive the strict
selected-slot feeder, and do not add `hUniform` to the H-free bridge.
