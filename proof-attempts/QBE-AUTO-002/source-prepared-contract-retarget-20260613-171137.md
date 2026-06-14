# 2026-06-13 Middle Packet: Source-Prepared Contract Retarget

Task: `QBE-AUTO-002`  
Run: `20260613-170242-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf family: `source_prepared_projection_summation_correction`

## Verdict

The H-free strict selected-slot feeder remains retired.  Lower2 has already
compiled the diagnostic bridge

```lean
oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
```

and the explicit seven-gate side already has

```lean
oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3
```

Therefore the active H-free `[0,0]` route is a zero diagnostic path.  It must
not be used as the source-prepared gamma3 selected contribution.

## Source Anchors

Use these public anchors, not local absolute paths:

| Anchor | Use in this packet |
|---|---|
| GHL2025 Eq. `arbitrary sparcity` | source for the `H_W^(kappa)` clean-column contract |
| GHL2025 Eq. `angles for Ry` | source for boundary `R_y` branch convention; do not promote it here |
| GHL2025 Theorem `theorem: 1 term robin` | root theorem remains open |
| GHL2025 Eq. `ROBIN clarified` | boundary gamma3 coefficient and selected sparse summand |
| GHL2025 Fig. `fig:1 term ROBIN` | full prepared circuit with both `H_W` sides |
| GHL2025 Definition `def:block-encoding` | clean projection target |
| `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` | audit separating full Fig. 4 from the H-free seven-gate backend component |

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

Let `PreparedSparseClean(H, env)` be

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `SourcePreparedField(H, env)` be

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

Let `Uniform(H)` be

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The key equivalence for lower2 is

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
  H env
```

which exposes the theorem-facing field as `ActiveEval(env) = PreparedSparseClean(H, env)`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Status |
|---|---|---|---|---|---|
| `strict_hfree_feeder_retirement` | reject `ActiveEval(env) = selectedSlotContribution(env)` | active index `0`; selected slot `2` / full index `32` | middle | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | retired; `shape_or_register_gap` |
| `active_eval_gate_matrices_column0_bridge` | evaluated H-free `[0,0]` bridge | active column-`0` support | lower2 closed | `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env` | proved diagnostic-only |
| `active_eval_zero_diagnostic` | derive `ActiveEval(env) = 0` | compiled bridge; `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env` | lower2 | proposed `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env` | optional active guard |
| `source_prepared_contract_retarget` | map full Fig. 4 prepared route to the prepared singleton clean entry | source anchors; visual audit; `Uniform(H)` contract | lower1/lower3 | no new Lean required | active calibration |
| `source_prepared_sparse_clean_feeder` | prove `SourcePreparedField(H, env)` through the prepared sparse-clean equality | retargeted proof map; branch-correct finite support | lower2 | equivalence named above | active theorem-facing leaf after calibration |
| `evaluated_backend_fold_recovery` | recover evaluated backend fold under explicit `Uniform(H)` | source-prepared field; prepared backend bridge | later lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | blocked |

## Lower1 Packet

Write:

```text
proof-attempts/QBE-AUTO-002/source-prepared-contract-retarget-lower1-<timestamp>.md
```

Scope:

- No Lean edits.
- Map each source anchor above to the Lean names in this packet.
- State explicitly that the seven-gate backend is not the full Fig. 4 circuit.
- Name the prepared singleton clean entry as the theorem-facing object.
- Identify one exact lower2 theorem, either the optional zero guard or the
  uncast prepared sparse-clean equality exposed by the equivalence above.

Acceptance:

- The old H-free active field is diagnostic-only.
- `Uniform(H)` stays an explicit contract.
- No new matrix/register definitions are duplicated.

## Lower2 Packet

Write scope:

```text
QuantumBlockEncoding/RobinMatrix.lean
```

Preferred small guard theorem:

```lean
theorem oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) = 0 := by
  rw [oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env]
  exact oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env
```

The theorem-facing alternative is one exact prepared-entry leaf:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Lower2 must prove only one of these in a single attempt.  Do not add
`hUniform` to the retired H-free feeder.  Do not use
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as closure.
Do not change gate order, oracle contracts, normalizers, or theorem
assumptions.

## Lower3 Packet

Write:

```text
verifier-feedback/QBE-AUTO-002/source-prepared-contract-retarget-lower3-<timestamp>.json
```

Required checks:

- active full-basis index is `0`;
- selected source sparse slot is `2` and selected full index is `32`;
- current `R_y` and `O_f` behavior for column `0` is two-path with tail-kill,
  not a unique selected sparse slot path;
- the full Fig. 4 source route contains both `H_W^(kappa)` sides;
- the H-free seven-gate backend list omits both `H_W` sides;
- a revived `ActiveEval(env) = selectedSlotContribution(env)` is rejected as
  `shape_or_register_gap`;
- a reassignment of the already compiled column-`0` bridge is classified as
  `stale_leaf`.

## Typed Feedback Template

```json
{
  "leaf": "source_prepared_contract_retarget",
  "source_correspondence_ok": true,
  "lean_parse_ok": null,
  "lean_build_ok": null,
  "finite_matrix_ok": "pending_lower3_or_guard",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": null,
  "closed_theorem_ok": false,
  "closed_theorem_scope": "no theorem closure; source-prepared retarget only",
  "error_class": "shape_or_register_gap",
  "next_route": "prove the optional ActiveEval column-0 zero guard or one branch-correct source-prepared sparse-clean feeder; do not revive the H-free selected-slot feeder"
}
```

## Gate

Any Lean edit must pass:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

This packet itself changes only proof-control memory and lower-agent scope.
