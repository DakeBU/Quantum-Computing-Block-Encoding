# Middle Packet: Source-Contract Repair After Prepared-Composite Rejection

Task: `QBE-AUTO-002`  
Run: `20260617-060327-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `source_contract_repair`  
Timestamp: `2026-06-17 06:35:35 JST`

## Source Anchors

The active paper target remains GHL2025 Theorem `theorem: 1 term robin`,
arXiv:2506.20478, treated in this run as the main Theorem 3 block-encoding
benchmark.  The source anchors for this repair packet are:

| Source anchor | Object translated |
|---|---|
| Eq. `arbitrary sparcity`, `main.tex:948-955` | source-prepared sparse register $H_W^{(\kappa)}$ |
| Eq. `angles for Ry`, `main.tex:1077-1085` | boundary controlled $R_y$ convention obligation |
| Theorem `theorem: 1 term robin`, `main.tex:1098-1109` | one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ and `2n` pure ancillas |
| Eq. `ROBIN clarified`, `main.tex:1111-1119` | boundary `gamma_3` coefficient branch and the hidden bulk `+ ...` branch |
| Fig. `fig:1 term ROBIN`, `main.tex:1122-1164` | theorem-facing circuit with the prepared $H_W^{(\kappa)}$ sandwich |
| Definition `def:block-encoding`, `main.tex:2027-2035` | clean signal-block projection target |

## Repair Objective

The repaired source contract must stop identifying the H-free seven-gate active
backend entry with the prepared singleton clean entry.  The theorem-facing clean
block must instead be routed through the full Fig. `fig:1 term ROBIN`
prepared-sandwich semantics and only then connected to the fixed
`gamma_3` coefficient obligation.

This packet does not change the GHL circuit, normalizer, register layout, gate
order, oracle contracts, or resource claim.  It only narrows the Lean-facing
contract so later lower work does not revive a refuted equality.

## Existing Lean Objects To Reuse

Definitions and route memory:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3 H env
oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
```

Rejected theorem targets:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

## Proof Translation Map

| Paper proof step | Lean-facing route | Classification |
|---|---|---|
| Prepare the sparse register using $H_W^{(\kappa)}$ before the Robin backend | use `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` and the existing clean-column contract `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external contract plus QBE-local semantics |
| Apply the Fig. `fig:1 term ROBIN` gate sequence, including both $H_W^{(\kappa)}$ side gates | keep the prepared-composite semantics separate from the seven-gate backend | internal paper step needing a corrected projection interface |
| Read the clean block as in Definition `def:block-encoding` | target the clean entry/projection of the prepared composite, not the H-free active backend entry | source-contract repair |
| Specialize to the boundary `gamma_3` coefficient branch in Eq. `ROBIN clarified` | require branch-correct finite checks for `0 <= j < K_1` or `K_2 < j < 2^n` and sparse slot `s` | active lower3 diagnostic |
| Connect the coefficient branch to `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | only after the repaired projection contract is typed and finite-checked | downstream blocked theorem |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_contract_repair` | corrected theorem-facing projection contract for the full prepared-sandwich clean block | source anchors, Fig. 4 audit, lower3 finite counterexample, prepared-composite semantics | lower1 then lower3; lower2 only after target is fixed | not fixed yet; lower1 must propose the exact Lean record or field name | this packet; `conversion-windows/QBE-AUTO-002.md` | no Lean edit yet | active primary leaf |
| `prepared_composite_source_projection_audit` | audit wrapper over source-prepared route memory and false theorem flags | no-go guards, selected-slot counterexample, prepared-composite objects | lower2 only if an audit increment is requested | planned `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3` | `proof-attempts/QBE-AUTO-002/prepared-composite-source-projection-audit-middle-packet-20260617-062017.md` | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | secondary audit-only leaf |
| `fixed_product_to_coefficient_3_0_0` | fixed coefficient equality for entry `(0,0)` | repaired projection contract plus coefficient algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | not run | blocked |

## Lower-Agent Split

Lower 1 must write the natural-language proof DAG for `source_contract_repair`.
It should name a proposed Lean record or field that represents the prepared
composite clean projection without proving the active/prepared equality.

Lower 2 must not edit Lean for `source_contract_repair` until lower1 names the
exact repaired target and lower3 verifies the finite branch/register condition.
If lower2 is scheduled before that, the only allowed Lean edit is the
non-promoting audit wrapper:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3
```

Lower 3 must test the necessary conditions for the repaired contract:

| Field | Required interpretation |
|---|---|
| `leaf` | `source_contract_repair` |
| `source_correspondence_ok` | `true` only if the target uses the full Fig. `fig:1 term ROBIN` prepared sandwich |
| `finite_matrix_ok` | `false` for the retired direct active/prepared equality; pending for any repaired target |
| `block_entry_ok` | `false` until a repaired clean projection is Lean-closed |
| `normalizer_ok` | no promotion; only the source normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ may appear |
| `error_class` | `source_translation_gap` until the repaired Lean statement is fixed |
| `next_route` | lower1 source-contract DAG, lower3 branch/register check, then one lower2 leaf |

Reviewer should reject any lower attempt that proves or assumes the retired
active/prepared equality, the H-free evaluated fold, generic backend
projection/expansion, product closure, normalized block, LCU, oracle, unitary,
resource, post-baseline candidate, or OPTCTRL target before the GHL baseline
closes.
