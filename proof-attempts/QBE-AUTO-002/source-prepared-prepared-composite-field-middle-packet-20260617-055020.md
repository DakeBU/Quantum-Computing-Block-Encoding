# Middle Packet: Source-Prepared Prepared-Composite Field Retarget

Task: `QBE-AUTO-002`  
Run: `20260617-054403-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `source_prepared_prepared_composite_field`

## Source Contract

The active paper target remains GHL2025 Theorem `theorem: 1 term robin`, the
one-term Robin block-encoding theorem treated by this run as the main
Theorem 3 benchmark.  The fixed branch remains the boundary `gamma_3`
contribution for system entry `(0,0)`, sparse slot `2`, source branch basis
`[32,32]`, signal block `[0,0]`, and normalizer
`N_D*N_f*kappa`.

The direct H-free target
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` is retired as
an active lower target.  Lower3 gave a finite all-one selected-slot witness
contradicting that statement.  This does not reject the source-prepared route;
it rejects using the seven-gate backend component as if it were the full Fig.
`fig:1 term ROBIN` prepared circuit.

The next source-faithful target is the prepared-composite field around
`PreparedCompositeSemantics(H)`:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

The source anchors are Theorem `theorem: 1 term robin`, Eq.
`ROBIN clarified`, Eq. `arbitrary sparcity`, Fig. `fig:1 term ROBIN`,
and Definition `def:block-encoding`.  The local Fig. 4 audit is also binding:
the full theorem-facing circuit contains both `H_W^(kappa)` side gates, while
the active seven-gate backend is only a component.

## Source-Dependency Audit

The local TeX source around Theorem `theorem: 1 term robin` gives the theorem
statement, the `gamma_1`, `gamma_2`, and `gamma_3` slices, and the Fig.
`fig:1 term ROBIN` circuit caption.  It does not give a separate gate-level
matrix proof paragraph.  The missing QBE ingredient is therefore classified as
an internal paper step needing a Lean finite-matrix interface, not as a new
external cited theorem.

| Missing ingredient | Classification | Next route |
|---|---|---|
| Active signal-zero entry must be compared with the clean entry of `H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)` | internal paper step needing a Lean finite matrix interface | active leaf `source_prepared_prepared_composite_field` |
| Direct H-free evaluated fold for all environments | finite matrix counterexample / invalid route | keep retired; do not assign lower2 to prove it |
| Full Fig. `fig:1 term ROBIN` transcript versus seven-gate backend component | source translation guard | reuse Fig. 4 audit and `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3` |
| Prepared singleton clean-entry semantics | existing Lean declaration | reuse `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` and clean-entry evaluation lemmas |
| `H_W^(kappa)` clean column | external cited contract | use only through `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; do not mark the primitive formalized |
| Product-to-coefficient, normalized block, LCU, block projection, block correctness, final extraction, oracle correctness, unitarity, resources | downstream theorem obligations | keep all flags false |

No new cited-results row is required for this packet.  Existing rows
`GHL2025.Theorem1.BlockEncoding`, `GHL2025.Lemma1.ODBS`,
`GHL2025.Lemma3.ODTS`, `GHL2025.Lemma4.Of`, `GHL2025.RyBoundary`, and
`LCU.StandardBlockEncoding` remain contract-only or obligation rows as
recorded.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_corrected_product_feeder` | source-shaped feeder from prepared slot-`2` product and explicit normalizer into `FixedProductObligation` | fixed pre-audit; `hUniform`; `hentry`; normalizer identities; no-go guards | none | `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3` | source-corrected feeder artifacts | previous full gate | compiled; retired |
| `evaluated_backend_fold_source_bridge_audit` | non-promoting wrapper over the evaluated fold route and no-go guards | source feeder; evaluated target exposure; prepared clean-entry route | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3` | lower2 05:41 feedback | previous full gate | compiled route memory; retired as lower target |
| `direct_hfree_evaluated_fold` | prove `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` directly | H-free seven-gate backend component | none | same statement; no proof | lower3 05:37 diagnostic | no Lean edit | rejected; `finite_matrix_counterexample` |
| `prepared_composite_source_field` | active signal-zero entry equals the prepared singleton clean entry after `Coeff.evalWith` | Fig. 4 source-prepared route; prepared composite semantics; active/prepared field obstruction | lower1/lower3 first; lower2 only after checks | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3`; planned audit `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `raw_prepared_sandwich_equivalent` | uncast active entry equals prepared sandwich fold after `Coeff.evalWith` | prepared-composite source field | lower2 alternate after lower3 check | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env` | this packet | same gate | open equivalent leaf |
| `fixed_product_to_coefficient_3_0_0` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | source-prepared field plus final coefficient and normalized-block bridge | later | existing obligation | proof-obligation ledger | not run | blocked |
| `post_baseline_candidate_population` | candidates for the same operator scored by `(depth, gateCount, auxiliaryQubits, oracleCalls)` | GHL baseline theorem closed first | later middle | none | task directive | not run | deferred |
| `fallback_optctrl_operator` | `E_k := |0><k|_time \otimes |0><1|_type \otimes I_n` | baseline closure and improvement stagnation | later middle | planned OPTCTRL task | task directive | not run | deferred |

## Lower 1 Packet

Write a natural-language proof map for
`source_prepared_prepared_composite_field`.  The map must:

1. Start from Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, and
   Fig. `fig:1 term ROBIN`.
2. State that the full theorem-facing route includes both `H_W^(kappa)` side
   gates, while `GHL2025.oneTermRobinCircuit` is only the active seven-gate
   backend component.
3. Map the source-prepared clean branch to
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` and its
   clean entry.
4. Use the existing Lean equivalences:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSandwich_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`.
5. Mark `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` as a
   rejected direct target, not as the lower2 theorem.
6. End with exactly one Lean-facing missing field: an evaluated equality
   between the active `[0,0]` entry and the prepared-composite clean entry.

Lower1 should write a proof-attempt Markdown artifact and typed feedback JSON.
No Lean edit is allowed.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Lower2 may edit only after lower1 and lower3 confirm the source-prepared
prepared-composite field.  The preferred non-promoting wrapper name is:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3
```

The wrapper should package existing declarations, especially:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
```

The wrapper must keep these unproved or false:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

It must not prove or assume the generic backend expansion/projection surfaces,
must not add hypotheses beyond the paper contracts, and must not promote
normalized-block equality, LCU, block projection, block correctness, final
extraction, oracle correctness, unitarity, resources, post-baseline search, or
OPTCTRL.

If lower3 finds that the prepared-composite equality is also contradicted by a
finite matrix witness, lower2 must make no Lean edit and log
`error_class=finite_matrix_counterexample`.  If the source-prepared target
cannot be matched to Fig. `fig:1 term ROBIN`, lower2 must make no Lean edit
and log `error_class=source_translation_gap`.

## Lower 3 Packet

Run a necessary-condition diagnostic before lower2 edits Lean.

| Field | Expected value |
|---|---|
| `leaf` | `source_prepared_prepared_composite_field` |
| `source_correspondence_ok` | `true` only if the statement uses Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding`, and the Fig. 4 audit distinction |
| `finite_matrix_ok` | check the active `[0,0]` entry against the prepared-composite clean entry or prepared sparse clean entry, not the direct H-free backend fold |
| `block_entry_ok` | `source-prepared prepared-composite field only`; no root block-encoding closure |
| `ancilla_cleanup_ok` | `null` unless a clean-ancilla theorem is explicitly checked |
| `normalizer_ok` | `conditional`; source-prepared branch may use `hUniform` and the existing explicit normalizer hypotheses, but the active field itself should not promote normalizer flags |
| `closed_theorem_ok` | `false` unless lower2 proves the exact prepared-composite finite entry theorem without diagnostic `sorry` |
| `error_class` | `symbolic_bridge_gap`, or `finite_matrix_counterexample` if the prepared-composite equality fails |
| `next_route` | lower2 compiles one non-promoting audit wrapper, or makes no edit with typed failure |

Reject any route that revives the direct H-free evaluated fold, generic
projection/backend expansion, changes `A`, changes `alpha`, hides an oracle
contract, mutates Fig. 4 gate order, promotes semantic flags, starts
post-baseline candidate search, or switches to OPTCTRL.

## Middle Handoff

Middle handoff: leaf=`source_prepared_prepared_composite_field`.  The direct
H-free evaluated fold target is retired after finite counterexample feedback.
The next source-faithful work is a prepared-composite finite block/projection
contract around `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
H`, packaged first as a non-promoting audit wrapper.  The GHL baseline theorem
is still open; improvement search and OPTCTRL remain deferred.
