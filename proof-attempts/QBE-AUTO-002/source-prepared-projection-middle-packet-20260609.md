# QBE-AUTO-002 Middle Packet: Source-Prepared Projection Field

Date: 2026-06-09

Mode: faithful paper reproduction for GHL2025 one-term Robin.

## Source Anchors

| Anchor | Role |
|---|---|
| `main.tex:948-955` | $H_W^{(\kappa)}$ sparse-register preparation contract |
| `main.tex:1098-1109` | Theorem `1 term robin` block-encoding claim |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`, especially the displayed $\gamma_3$ slot branch |
| `main.tex:1122-1164` | Fig. `1 term ROBIN` theorem-facing gate order |
| `main.tex:2027-2035` | clean-block projection definition |

## Selected Lean Field

The selected theorem-facing prepared signal-entry field is
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.

Its prepared entry is the clean entry of
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`, i.e. the
local $H_W^{(\kappa)\dagger} U_{\gamma_3} H_W^{(\kappa)}$ sandwich.  The
conditional backend bridge is
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`,
where `hUniform` is the contract-only
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

The smaller missing Lean field is
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`.
It states that the active signal-zero entry equals the prepared sandwich fold.
It is open.

## Frontier

| Node | Interface | Dependencies | Status |
|---|---|---|---|
| `slot2_source_path_to_prepared_signal_entry` | Map the displayed slot `2` branch, full basis `[32,32]`, to the selected source-prepared field | Eq. `ROBIN clarified`, `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`, `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | lower-1 proof-map leaf |
| `raw_entry_to_source_prepared_sandwich_bridge` | Prove or strictly reduce the active signal-zero entry equals the prepared sandwich fold | selected source-prepared field, prepared backend fold, $H_W$ clean-column contract | lower-2 Lean leaf |
| `seven_gate_col0_slot0_expansion` | Active seven-gate `[0,0]` expands through slot `0` factors | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | proved diagnostic; retired |
| `raw_coeff_fold_route` | Raw symbolic constructor equality | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | stale diagnostic/backlog |

## Lower Assignments

Lower 1: write a proof-translation packet from source slot `2` and full basis
`[32,32]` to `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.
Classify each edge as `GHL-internal`, `external-cited-contract`, or
`QBE-local semantic bridge`.

Lower 2: edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Implement one
ready Lean leaf feeding
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`,
or introduce a typed mismatch/obligation if the current active `[0,0]` LHS is
only the seven-gate slot-`0` diagnostic and not theorem-facing prepared
semantics.

Gate for any Lean edit: `python3 tools/qbe.py check`.

Forbidden promotions: do not mark ODBS, ODTS, `O_f`, $H_W$, $R_y$, LCU, block
projection, block correctness, circuit unitarity, normalized equality, product
to coefficient, or final extraction as proved.
