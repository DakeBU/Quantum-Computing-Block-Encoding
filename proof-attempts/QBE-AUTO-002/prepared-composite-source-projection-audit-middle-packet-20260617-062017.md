# Middle Packet: Prepared-Composite Source Projection Audit

Task: `QBE-AUTO-002`  
Run: `20260617-060327-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `prepared_composite_source_projection_audit`  
Timestamp: `2026-06-17 06:20:17 JST`

## Source Anchors

The active paper target remains GHL2025 Theorem `theorem: 1 term robin`,
arXiv:2506.20478, treated in this run as the main Theorem 3 benchmark.  The
local source map anchors are:

| Source anchor | Object translated |
|---|---|
| Theorem `theorem: 1 term robin`, `main.tex:1098-1109` | one-term Robin block-encoding with normalizer `N_D*N_f*kappa` and `2n` pure ancillas |
| Eq. `arbitrary sparcity`, `main.tex:948-955` | sparse-register preparation $H_W^{(\kappa)}$ |
| Eq. `ROBIN clarified`, `main.tex:1111-1119` | boundary `gamma_3` coefficient branch |
| Fig. `fig:1 term ROBIN`, `main.tex:1122-1164` | theorem-facing circuit with both $H_W^{(\kappa)}$ side gates |
| Definition `def:block-encoding`, `main.tex:2027-2035` | clean signal-block projection |

The paper-facing object is the clean projection route for the `gamma_3`
boundary branch, not a replacement circuit and not the post-baseline
improvement search.

## Lean Translation

Definitions for this packet:

- `PreparedCompositeSemantics(H)` is
  `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`.
- `ActivePreparedEval(H, env)` is
  `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`.
- `UncastActivePreparedEval(H, env)` is
  `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`.
- `SourcePreparedActiveEval(H, env)` is
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.
- `FixedProductObligation` is
  `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

Lower1 and lower3 have now classified the direct active/prepared equality as a
finite counterexample route.  A uniform clean-column matrix `H` and the all-one
selected-branch environment make `ActivePreparedEval(H, env)` imply that the
selected slot contribution evaluates to `0`, while
`oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`
evaluates the same contribution to `1`.

The following declarations are route memory, not closure:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3
```

## Source-Dependency Audit

| Missing ingredient | Classification | Lower route |
|---|---|---|
| Proving `ActivePreparedEval(H, env)`, `UncastActivePreparedEval(H, env)`, or `SourcePreparedActiveEval(H, env)` as a theorem | `finite_matrix_counterexample` | reject; do not assign lower2 |
| Recording that the prepared-composite object is still the source-prepared Fig. `fig:1 term ROBIN` route object | internal GHL step plus QBE-local semantic glue | allow only a false-flag audit wrapper |
| `H_W^(kappa)` clean sparse-register column | existing external cited contract | use only through `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| Full Fig. `fig:1 term ROBIN` versus active seven-gate backend | source translation guard | keep the transcript split; do not identify them |
| Product-to-coefficient and final block-encoding flags | downstream obligations | keep false |

No new cited-results row is needed.  The next packet uses the existing
`ShuklaVedula2024.HWkappaUniformSuperposition` row only as a contract for the
clean-column behavior of $H_W^{(\kappa)}$; that row must not be marked
formalized.

## Ownership

| Layer | Contents |
|---|---|
| GHL-owned | The theorem, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, normalizer `N_D*N_f*kappa`, register layout, gate order, and resource claim |
| External contract | sparse-register preparation from Eq. `arbitrary sparcity`; existing oracle and LCU rows remain contract-only/backlog |
| QBE-local semantic glue | `CircuitMatrixSemantics`, prepared-composite singleton semantics, source-prepared projection records, false theorem flags, no-go guards, and verifier-feedback fields |

## Updated Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_prepared_prepared_composite_field` | active/prepared equality after `Coeff.evalWith` | prepared composite semantics; source projection target | none | `ActivePreparedEval(H, env)`; `UncastActivePreparedEval(H, env)`; `SourcePreparedActiveEval(H, env)` | lower1/lower3 artifacts | scratch Lean plus previous gate | rejected; `finite_matrix_counterexample` |
| `prepared_composite_source_projection_audit` | audit wrapper exposing the source-prepared object and rejected equality without theorem promotion | prepared composite declarations, no-go guards, lower3 witness | lower2 only if a Lean audit increment is requested | planned `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active audit-only leaf |
| `source_contract_repair` | source-facing repair of the projection contract so the full Fig. 4 clean block is not replaced by the H-free active backend entry | source anchors, Fig. 4 audit, finite witness | middle/lower1 | no Lean target fixed yet | conversion window | no Lean edit | active source-contract repair |
| `fixed_product_to_coefficient_3_0_0` | focused product/coefficient obligation | repaired projection contract and coefficient algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | not run | blocked |

## Lower2 Contract

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Lower2 may implement exactly one declaration if requested:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3
```

The declaration must be a non-promoting audit wrapper.  It may package existing
records, strings, false flags, and no-go declarations.  It must not prove or
assume:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

It must also keep product-to-coefficient, normalized block, LCU, block
projection, block correctness, final extraction, oracle correctness, unitarity,
resource score, post-baseline candidate population, and OPTCTRL flags false.

If lower2 cannot make an audit wrapper without implying one of the rejected
equalities, lower2 should make no Lean edit and log
`error_class=finite_matrix_counterexample` with this packet as the artifact.

## Lower3 Contract

Lower3 should verify only necessary conditions for the audit wrapper:

| Field | Expected value |
|---|---|
| `leaf` | `prepared_composite_source_projection_audit` |
| `source_correspondence_ok` | `true` for audit-only use of the source-prepared object; `false` for theorem promotion of the active/prepared equality |
| `finite_matrix_ok` | `false` for the direct active/prepared equality; `null` for the audit wrapper |
| `block_entry_ok` | `false` for root closure |
| `normalizer_ok` | `conditional`; no normalizer flag promoted |
| `closed_theorem_ok` | `false` unless a later repaired contract is Lean-closed |
| `error_class` | `finite_matrix_counterexample` for direct equality; `source_translation_gap` for missing repaired projection contract |
| `next_route` | source-contract repair or lower2 audit wrapper only |

Reviewer should reject any route that revives the direct H-free evaluated fold,
generic backend projection/expansion, active/prepared equality, product
closure, normalized block, LCU, oracle, unitary, resource claim,
post-baseline improvement search, or OPTCTRL fallback before the GHL baseline
is closed.
