# Backend-Expansion Correction Middle Packet

Task: `QBE-AUTO-002`
Run: `20260615-024629-QBE-AUTO-002-cycle01`
Role: middle coordinator synthesis
Mode: `faithfulPaper`
Created: `2026-06-15 02:55 JST`

## Source Status

The local TeX path named by the run prompt,
`outer_papers/quantum/GHL2025/main.tex`, is absent in this checkout.  This
packet therefore uses only public or checked-in source anchors: the maintained
GHL2025 proof notes, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`,
Definition `def:block-encoding`, Theorem `theorem: 1 term robin`, and the
cited-results rows in `research-wiki/cited-results/GHL2025.md`.

The source-prepared projection/product composite is compiled route memory:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

Those declarations may be reused as dependencies.  They are not active lower2
targets.

## Definitions

`BackendExpansionRaw` denotes the current raw backend-expansion field:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

`SignalEntryFold` denotes the full signal-zero branch fold:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The typed equivalence is compiled:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3 :
  BackendExpansionRaw <-> SignalEntryFold
```

The no-go guard is compiled:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3 :
  ¬ BackendExpansionRaw
```

## Source-Dependency Classification

The source proof fragment is the projection/backend branch-sum step that
connects the clean block entry in Definition `def:block-encoding` and Fig.
`fig:1 term ROBIN` to the boundary $\gamma_3$ product in Eq. `ROBIN
clarified`.  It is an internal GHL/QBE finite projection step.  It is not a
Shukla--Vedula state-preparation theorem, an LCU theorem, a QSVT theorem, or a
normalizer theorem.

The unchanged Lean proposition `BackendExpansionRaw` is not a valid lower2
theorem target.  Lean already proves its negation by an all-one selected-slot
finite counterexample.  The missing ingredient is therefore classified as
`contract-drift` for the raw statement, with verifier class
`finite_matrix_counterexample`.

| Missing ingredient | Classification | Evidence | Next route |
|---|---|---|---|
| proof of unchanged `BackendExpansionRaw` | `contract-drift` plus `finite_matrix_counterexample` | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | do not assign as lower2 target |
| corrected projection/backend branch-sum proposition | `internal-paper-step` if source notes support a corrected source-facing fold; otherwise `source-contract-gap` | Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding`, Theorem `theorem: 1 term robin` | lower1 names the corrected leaf or records the gap |
| external state-preparation, sparse oracle, LCU, block extraction | external/background contracts | cited-results rows remain `contract-only` or `obligation` | do not use to close this local leaf |

## Proof-Translation Map

| Source step | Lean status | Classification |
|---|---|---|
| Definition `def:block-encoding` selects the clean signal-system block entry. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` is typed. | existing Lean declaration |
| Fig. `fig:1 term ROBIN` fixes the active seven-gate component and the source-prepared projection route. | The three source-prepared projection/product bridge theorems above compile. | existing Lean declarations |
| Eq. `ROBIN clarified` isolates the boundary $\gamma_3$ slot-`2` product for the fixed `(0,0)` coefficient route. | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` reaches `projectedBranchProduct`; `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains open. | existing Lean declaration plus open root obligation |
| The projection/backend branch-sum step should connect the signal entry to the backend branch fold. | The existing raw target is equivalent to `SignalEntryFold` but refuted by `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`. | source-contract correction required |
| Any corrected branch-sum statement must preserve clean index `0`, focused sparse slot `2`, full branch basis index `32`, and the fixed product route `(3,0,0)`. | Lower3 has a prior all-one finite rejection for the unchanged target. | verifier precondition |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_projection_slot2_product` | source-prepared projection entry evaluates to slot-`2` projected branch product | source-prepared backend bridge; backend-fold-to-product bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | previous source-prepared composite packets | previous full gate | proved; stale as lower2 target |
| `backend_expansion_raw` | raw H-free backend expansion, equivalent to the full signal-zero entry fold | all-one selected-slot no-go guard | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | this packet; verifier JSON | none | refuted; do not prove unchanged |
| `backend_expansion_correction_source_audit` | decide whether source notes support a corrected source-facing branch-sum leaf or force a source-contract gap | GHL2025 anchors above; compiled no-go guard; lower3 finite rejection | lower1 | no new Lean declaration | this packet | `python3 tools/qbe.py check` | active lower1 leaf |
| `backend_expansion_correction_verifier` | record necessary-condition rejection for unchanged raw target and constraints for any corrected leaf | compiled no-go guard; selected-slot all-one diagnostic | lower3 | no theorem-facing Lean edit | verifier JSON | `python3 tools/qbe.py check` | active lower3 leaf |
| `backend_expansion_corrected_lean_leaf` | one corrected projection/backend statement, if lower1/lower3 name one | lower1 source audit; lower3 necessary-condition packet | lower2 after correction only | to be named later in `QuantumBlockEncoding/RobinMatrix.lean` | future lower packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | blocked until named |
| `product_to_coefficient_3_0_0` | fixed product-to-coefficient equality | compiled source projection/product route; corrected projection/backend route; normalizer algebra; boundary coefficient convention | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate | open; do not promote |

## Lower Packets

Lower1 natural-language proof architect:

- Write
  `proof-attempts/QBE-AUTO-002/backend-expansion-correction-lower1-dag-20260615-024629.md`.
- Use the source anchors listed above; do not cite the absent local TeX path in
  public artifacts.
- Decide whether the paper notes support a corrected source-facing branch-sum
  theorem, a finite projection lemma, or a `source-contract-gap`.
- Name exactly one corrected Lean leaf if supported.  The leaf must preserve
  clean index `0`, focused sparse slot `2`, full branch basis index `32`, and
  `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

Lower3 necessary-condition verifier:

- Write
  `verifier-feedback/QBE-AUTO-002/backend-expansion-correction-lower3-20260615-024629.json`.
- Record that unchanged `BackendExpansionRaw` is rejected by
  `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.
- If a corrected finite shape is proposed, check it against the clean index,
  slot, full branch basis index, and false theorem-facing flags above.

Lower2 Lean implementation worker:

- Make no Lean edit unless lower1 and lower3 have named one corrected leaf.
- If run before that correction exists, log
  `leaf=backend_expansion_correction`,
  `error_class=finite_matrix_counterexample`, and
  `next_route=wait for corrected source-facing projection/backend leaf`.
- After the corrected leaf exists, edit only
  `QuantumBlockEncoding/RobinMatrix.lean` and prove exactly that one leaf.

## Forbidden Routes

Do not prove `BackendExpansionRaw` unchanged.  Do not use the two diagnostic
`sorry` declarations as dependencies.  Do not revive the old H-free evaluated
fold as a theorem-facing route.  Do not promote product-to-coefficient,
normalizer, LCU/block composition, oracle correctness, unitarity, block
correctness, or final block-extraction flags.

## Typed Feedback

```text
leaf=backend_expansion_correction
source_correspondence_ok=false
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=false
block_entry_ok=false
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=finite_matrix_counterexample
next_route=lower1/lower3 must name a corrected projection/backend target or record a source-contract gap before lower2 edits Lean
```
