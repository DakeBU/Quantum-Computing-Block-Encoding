# Middle Packet: Prepared-Sandwich Semantics Gap Frontier

Task: `QBE-AUTO-002`
Run: `20260611-220058-QBE-AUTO-002-cycle01`
Mode: faithful paper reproduction

## Source-Facing Contract

The active source fragment remains Guseynov--Huang--Liu 2025, Theorem
`1 term robin`, Eq. `ROBIN clarified`, Fig. `1 term ROBIN`, the
$H_W^{(\kappa)}$ sparse-register preparation contract, and the block-encoding
projection definition. The theorem-facing transcript guard still keeps
`U_indic^dagger` and both $H_W^{(\kappa)}$ sides visible.

This packet does not promote ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y`, LCU,
block-projection, normalizer, block-correctness, final-extraction, oracle, or
external primitive status.

## Current Lean Evidence

The following compiled declarations are support only:

```lean
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3
oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3
```

The diagnostic theorem classifies the H-free active selected-slot route as a
shape/register gap when it is forced through the diagnostic seven-gate zero
path. The next lower target is therefore the prepared-sandwich semantics gap,
not another backend slot vanish theorem and not a rediscovery of the
active-selected bridge.

## Active Leaf

Definition first: `PreparedSandwichEval` is

```lean
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
```

Lower 2 should prove this statement, prove the raw prepared-sandwich field

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

or prove one strict prepared matrix-entry feeder named by
`(oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H).missingPreparedMatrixField`.

The external clean-column contract stays explicit:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Do not replace it with a theorem claim about Shukla--Vedula state preparation.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Gate | Status |
|---|---|---|---|---|---|---|
| `prepared_sandwich_gap_leaf` | source-prepared $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ entry supplies the prepared projection route | gap transcript; absence guard for active H-free list; `HUniform`; Fig. `1 term ROBIN` prepared boundary gates | lower 2 | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env` or a strict missing-field feeder | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active |
| `raw_prepared_sandwich_leaf` | signal-zero entry equals the prepared sandwich fold | raw-entry field transcript; prepared sandwich backend target; `HUniform` for downstream fold recovery | lower 2 if easier | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | same gate | allowed equivalent feeder |
| `prepared_sandwich_to_fold_bridge` | package prepared-sandwich eval as evaluated backend fold | `PreparedSandwichEval`; prepared backend fold; `HUniform` | none | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3 H env hUniform` | already gated | proved; retired |
| `active_selected_diagnostic_obstruction` | diagnostic H-free selected-slot route reaches zero | diagnostic seven-gate equality hypothesis; column-`0` vanish theorem | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3 env hDiagnostic hActiveSelected` | already gated | diagnostic; retired |
| `active_selected_slot_eval_comparison_leaf` | H-free active `[0,0]` entry equals selected slot `2` | direct source-faithful path not found; diagnostic route is invalid for closure | none by default | target `ActiveSelectedSlotEvalComparison` | same gate | stale by default |
| `source_prepared_entry_leaf` | source-prepared entry equality | prepared-sandwich field plus wrapper/cast bridges | later lower 2 | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | same gate | open dependent |
| `unitary_fold_leaf` | full signal-zero unitary entry equals backend branch fold | source-prepared entry; `HUniform`; prepared backend-fold normal form | later lower 2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | same gate | open dependent root |

## Lower 1 Packet

Append only a narrow postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The postscript should:

1. retire `ActiveSelectedSlotEvalComparison` as the default lower target after
   the diagnostic obstruction;
2. translate the prepared-sandwich source fragment into Lean declarations;
3. state the dependency order from `PreparedSandwichEval` to `SourcePreparedEntry`
   and `FullUnitaryFold`;
4. keep external sparse preparation as a contract-only obligation.

## Lower 2 Packet

Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Implement exactly one of:

1. `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`;
2. `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`;
3. one strict prepared matrix-entry lemma feeding one of the two statements
   above.

Do not change oracle contracts, theorem hypotheses, normalizers, gate labels,
the paper circuit, or the `H_W` clean-column contract.

## Verifier Feedback To Log

If lower 2 proves the prepared-sandwich leaf, use:

```text
leaf=prepared_sandwich_semantics_gap
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=not_promoted
normalizer_ok=true
closed_theorem_ok=true
error_class=none
next_route=recover SourcePreparedEntry and FullUnitaryFold through the compiled prepared-sandwich bridges
```

If lower 2 only proves a smaller feeder or records a useful failure, log:

```text
leaf=prepared_sandwich_semantics_gap
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=<true-or-false>
finite_matrix_ok=<true-partial-or-false>
block_entry_ok=partial
ancilla_cleanup_ok=not_promoted
normalizer_ok=true
closed_theorem_ok=false
error_class=<lean_tactic_gap|symbolic_bridge_gap|shape_or_register_gap>
next_route=<one narrow prepared-matrix feeder>
```
