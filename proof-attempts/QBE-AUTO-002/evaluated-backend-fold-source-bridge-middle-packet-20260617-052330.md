# Middle Packet: Evaluated Backend-Fold Source Bridge

Task: `QBE-AUTO-002`  
Run: `20260617-051350-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `evaluated_backend_fold_source_bridge`

## Source Contract

The active paper target remains GHL2025 Theorem `theorem: 1 term robin`, the
one-term Robin block-encoding theorem treated in this run as the main Theorem 3
benchmark.  The fixed finite branch is the boundary `gamma_3` contribution for
system entry `(0,0)`, sparse slot `2`, source branch basis `[32,32]`, signal
block `[0,0]`, and normalizer `N_D*N_f*kappa`.

The source anchors are Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`, Eq.
`angles for Ry`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.  The `H_W^(kappa)` clean-column behavior remains the
existing contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.  No new
cited result is needed for this packet.

## Definitions

- `FixedProductObligation` is
  `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.
- `FeederAudit(H, env)` is the compiled wrapper
  `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3 H env`.
- `EvaluatedFoldTarget(H, env)` is
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3 H env`.
- `EvaluatedFoldStatement(env)` is
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
- `SourcePreparedActiveEval(H, env)` is
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.
- `RawPreparedSandwichField(H)` is
  `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`.

The previous lower work compiled `FeederAudit(H, env)` as non-promoting route
memory.  The remaining bridge is the finite projection/evaluation step: the
active signal-zero entry must evaluate as the seven-slot backend branch fold,
or equivalently as the source-prepared active/prepared singleton entry under
the explicit clean-column contract.

## Source-Dependency Audit

| Missing ingredient | Classification | Next route |
|---|---|---|
| Source-prepared slot-`2` product and explicit normalizer feed `FixedProductObligation` | internal paper step plus QBE-local coefficient interface | compiled by `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`; stale as lower work |
| Active signal-zero entry evaluates to the backend branch fold | internal paper step plus QBE-local finite projection/evaluation theorem | active leaf through `EvaluatedFoldTarget(H, env)` |
| `SourcePreparedActiveEval(H, env)` and `EvaluatedFoldStatement(env)` have the same remaining content under `hUniform` | QBE-local proof-DAG alignment | compiled by `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_activeEval_iff_statement_n3` |
| Raw prepared-sandwich field feeds the active/prepared route | QBE-local proof-route memory | `RawPreparedSandwichField(H)` is allowed as an equivalent smaller finite field, but it is not proved |
| Unchanged generic backend projection or backend expansion | invalid route / finite counterexample | keep `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` and `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`; do not prove or assume either generic statement |
| `H_W^(kappa)` clean column | external cited contract | use only through `hUniform`; do not mark the primitive formalized |
| Final product-to-coefficient theorem | theorem-facing coefficient and normalized-block closure | blocked until the evaluated finite projection bridge closes |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_corrected_product_feeder` | source-shaped feeder from prepared slot-`2` product and explicit normalizer into `FixedProductObligation` | `hUniform`, `hentry`, `hND`, `hNF`, `hkappa`, `hkappaSqrt`, fixed pre-audit, no-go guards | none | `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3` | lower1/lower2/lower3 source-corrected product feeder artifacts | previous full gate | compiled; retired |
| `evaluated_backend_fold_target` | record the evaluated active signal entry, backend branch fold, active/prepared equivalence, and false proof flags | source-prepared target and active/prepared circuit field records | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3`; transcript and exposure lemmas | this packet | current gate if edited | compiled obstruction record |
| `prepared_clean_entry_product_map` | prepared singleton clean entry evaluates to the backend branch fold and feeds the fixed product map | `hUniform`; prepared singleton backend evaluator | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedCleanEntryFeedsProductMap_n3`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3` | this packet | previous gate | compiled route memory |
| `evaluated_backend_fold_source_bridge` | prove or narrow `EvaluatedFoldStatement(env)` without reviving the generic backend projection/expansion surface | evaluated target, source-prepared active/eval equivalence, raw prepared-sandwich route, finite expansion diagnostics | lower1 and lower3 first; lower2 only for one confirmed local leaf | preferred target `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; allowed equivalent `RawPreparedSandwichField(H)`; if only route packaging is possible, planned wrapper `oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active source-constrained leaf |
| `fixed_product_to_coefficient_3_0_0` | close `FixedProductObligation` | evaluated finite projection bridge plus final coefficient and normalized-block bridge | later | existing obligation | proof-obligation ledger | not run | blocked |
| `post_baseline_candidate_population` | candidates for the same operator scored by `(depth, gateCount, auxiliaryQubits, oracleCalls)` | GHL baseline theorem closed first | later middle | none | task directive | not run | deferred |
| `fallback_optctrl_operator` | `E_k := |0><k|_time \otimes |0><1|_type \otimes I_n` | baseline closure and improvement stagnation | later middle | planned OPTCTRL task | `tasks/QBE-OP-OPTCTRL-001.md` | not run | deferred |

## Lower 1 Packet

Write a natural-language proof map for `evaluated_backend_fold_source_bridge`.
The map must proceed in this order:

1. Start from the compiled feeder
   `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3` and mark it
   stale as lower work.
2. Use Eq. `arbitrary sparcity` only through
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
3. Use the compiled equivalence
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_activeEval_iff_statement_n3`
   to identify `SourcePreparedActiveEval(H, env)` with
   `EvaluatedFoldStatement(env)` under `hUniform`.
4. Use
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3`
   and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`
   to state the exact finite evaluated equality lower2 would have to prove.
5. Explain why the old generic backend projection and backend expansion remain
   invalid closure routes, citing the two no-go guards.
6. If the finite evaluated equality looks too large, name the equivalent
   source-prepared raw field `RawPreparedSandwichField(H)` as the next smaller
   proof target.  Do not assign the root product theorem.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Lower2 may edit only one source-constrained local leaf after lower1/lower3
confirm the exact finite target.  Preferred order:

1. Attempt a small lemma directly feeding
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` from a
   finite evaluated equality already certified by lower3.
2. If the direct finite theorem is too large, compile exactly one non-promoting
   audit wrapper named
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3` that
   packages:
   `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3_transcript`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedCleanEntryFeedsProductMap_n3`,
   and the two no-go guards.

The wrapper must keep `EvaluatedFoldStatement(env)`, `FixedProductObligation`,
normalized-block equality, LCU, block projection, block correctness, final
extraction, oracle correctness, unitarity, and resource claims false.

Lower2 must not prove or assume:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

If lower3 finds a finite matrix counterexample for the proposed evaluated
target, lower2 must make no Lean edit and log `error_class=finite_matrix_counterexample`.
If lower1 cannot source-map the finite target, lower2 must make no Lean edit and
log `error_class=source_translation_gap`.

## Lower 3 Packet

Run a necessary-condition diagnostic before lower2 edits Lean:

| Field | Expected value |
|---|---|
| `leaf` | `evaluated_backend_fold_source_bridge` |
| `source_correspondence_ok` | `true` only if the statement cites Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding` |
| `finite_matrix_ok` | check the evaluated active `[0,0]` equality exposed by `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`; reject the generic backend projection surface |
| `block_entry_ok` | `evaluated active signal entry / prepared singleton bridge only`; no root block-encoding closure |
| `normalizer_ok` | `true` only under explicit `hND`, `hNF`, `hkappa`, and `hkappaSqrt` when the feeder/normalizer is used |
| `closed_theorem_ok` | `false` unless lower2 proves the exact evaluated finite projection theorem without diagnostic `sorry` |
| `error_class` | `symbolic_bridge_gap`; use `finite_matrix_counterexample` if the evaluated equality fails |
| `next_route` | lower2 compiles one confirmed non-promoting bridge or no-edits with typed failure |

Reject any route that revives generic projection/backend expansion, changes
`A`, changes `alpha`, hides an oracle contract, mutates Fig. 4 gate order,
promotes semantic flags, starts post-baseline candidate search, or switches to
OPTCTRL.

## Middle Handoff

Middle handoff: leaf=`evaluated_backend_fold_source_bridge`.  The compiled
source-corrected feeder is accepted and retired.  The next proof target is the
source-constrained evaluated finite projection/backend fold, with
`RawPreparedSandwichField(H)` as the allowed smaller equivalent field.  The GHL
baseline theorem is still open; post-baseline improvement and OPTCTRL remain
deferred.
