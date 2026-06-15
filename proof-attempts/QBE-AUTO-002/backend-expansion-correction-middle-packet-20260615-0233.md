# Backend-Expansion Correction Middle Packet

Task: `QBE-AUTO-002`
Run: `20260615-022953-QBE-AUTO-002-cycle01`
Role: middle coordinator synthesis
Mode: `faithfulPaper`
Created: `2026-06-15 02:33 JST`

## Source Status

This packet follows the upper handoff in
`runs/20260615-022953-QBE-AUTO-002-cycle01/dialogue.md`.  The local TeX source
path named by the run prompt, `outer_papers/quantum/GHL2025/main.tex`, is absent
in this checkout.  Public source anchors for this packet are therefore the
maintained GHL2025 proof notes, the Fig. `fig:1 term ROBIN` visual audit, the
cited-results rows, Eq. `ROBIN clarified`, Definition `def:block-encoding`,
and Theorem `theorem: 1 term robin`.

The source-prepared projection/product composite is compiled:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

It is now route memory feeding the fixed product-to-coefficient obligation, not
active lower work.

## Definitions

`BackendExpansionRaw` denotes:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

`SignalEntryFold` denotes:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled equivalence is:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3 :
  BackendExpansionRaw <-> SignalEntryFold
```

The compiled no-go guard is:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3 :
  ¬ BackendExpansionRaw
```

## Source-Dependency Classification

The paper-level object is the projection/backend branch-sum step connecting the
Fig. `fig:1 term ROBIN` clean signal projection to the Eq. `ROBIN clarified`
boundary $\gamma_3$ branch.  This is an internal GHL/QBE-local finite
projection step, not a Shukla--Vedula state-preparation theorem and not an LCU
or QSVT theorem.

The current Lean proposition `BackendExpansionRaw` cannot be assigned as an
unchanged lower2 proof target.  Lean already proves its negation.  The
classification is:

| Missing ingredient | Classification | Evidence | Next route |
|---|---|---|---|
| unchanged `BackendExpansionRaw` proof | `contract-drift` with verifier `finite_matrix_counterexample` | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | do not assign as theorem target |
| corrected projection/backend statement | `internal-paper-step` plus QBE-local finite projection lemma | GHL2025 Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding` | lower1 source-DAG correction, lower3 finite check, then one corrected Lean leaf |
| sparse preparation, oracle cleanup, LCU/block extraction | `external-cited-result` or contract-only background | cited-results rows remain `obligation` or `contract-only` | do not use as closure for this leaf |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_projection_slot2_product` | source-prepared projection evaluates to slot-`2` projected branch product | source wrapper; backend-fold bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | composite packet | previous full gate | compiled; stale |
| `product_to_coefficient_3_0_0` | fixed product-to-coefficient equality | projection/product bridge; normalizer algebra; boundary coefficient convention | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate | open |
| `backend_expansion_raw` | raw H-free backend expansion / full signal entry fold | all-one counterexample guard | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | this packet | none | refuted; do not prove unchanged |
| `backend_expansion_correction` | corrected source-facing projection/backend branch-sum proposition | lower1 source audit; lower3 finite condition | lower1/lower3 first | to be named after correction | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active correction frontier |

## Lower Packets

Lower1 natural-language proof architect:

- Write `proof-attempts/QBE-AUTO-002/backend-expansion-correction-lower1-dag-20260615-022953.md`.
- Map Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition
  `def:block-encoding`, and Theorem `theorem: 1 term robin` to the current Lean
  declarations above.
- State whether the corrected Lean leaf is a source-facing branch-sum theorem,
  a finite projection lemma, or a source-contract gap.
- Do not restart broad oracle, LCU, normalizer, or product-to-coefficient work.

Lower3 necessary-condition verifier:

- Write
  `verifier-feedback/QBE-AUTO-002/backend-expansion-correction-lower3-20260615-022953.json`.
- Record that the unchanged raw target fails the necessary condition because
  `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` is compiled.
- If lower3 proposes a corrected finite shape, it must preserve clean index
  `0`, focused sparse slot `2`, full branch basis index `32`, fixed product
  obligation `3 0 0`, and false theorem-facing flags.

Lower2 Lean implementation worker:

- Do not prove `BackendExpansionRaw` unchanged.
- If lower2 runs before lower1 and lower3 complete the correction, make no Lean
  edit and log `leaf=backend_expansion_correction`,
  `error_class=finite_matrix_counterexample`, and
  `next_route=wait for corrected source-facing projection/backend leaf`.
- After the corrected leaf is named, edit only
  `QuantumBlockEncoding/RobinMatrix.lean` and prove exactly that one leaf.

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
next_route=lower1/lower3 must refine the projection/backend target before lower2 Lean proof search
```
