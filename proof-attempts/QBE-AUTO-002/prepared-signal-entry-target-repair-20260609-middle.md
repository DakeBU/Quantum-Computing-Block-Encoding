# QBE-AUTO-002 Prepared Signal-Entry Target Repair Packet

Date: 2026-06-09
Role: middle formalization maintainer
Mode: faithfulPaper
Lean edit status: no Lean edits

## 1. Source-Dependency Audit

The blocked proof step is the active/source-prepared equality after the latest
typed mismatch witness:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3
```

The paper anchors rechecked for this packet are:

| Source anchor | Paper fragment | Lean-facing role |
|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0} = \kappa^{-1/2}\sum_s \ket{s}$ | external clean-column contract for the two sparse-register sides |
| `main.tex:1098-1109`, Theorem `1 term robin` | one-term Robin block-encoding claim and resource statement | root theorem target; still not closed |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | boundary $\gamma_3$ coefficient, summed over sparse slots | branch-correct coefficient target; focused slot is `2`, full basis index `[32,32]` |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | full theorem-facing circuit order, including $H_W^{(\kappa)}$, `U_indic^dagger`, and cleanup | transcript target; active seven-gate backend is only a subobject |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean signal projection after pure-ancilla cleanup | source-prepared projection target |

Classification: the missing ingredient is a `QBE-local finite
projection/composition field`, not a new external cited theorem.  The
Shukla--Vedula dependency supplies only the clean-column state-preparation
contract.  The current Lean active field still exposes the active seven-gate
entry `[0,0]`; Fig. `1 term ROBIN` obtains the all-slot prepared entry only
after the two $H_W^{(\kappa)}$ sides are included.

## 2. Accepted Context

The following compiled facts are accepted context for the next lower packet:

| Declaration | Role | Status |
|---|---|---|
| `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | corrected theorem-facing transcript with both $H_W^{(\kappa)}$ sides and `U_indic^dagger` visible | proved transcript guard |
| `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | guard that the active backend is still the seven-gate product | proved transcript guard |
| `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | records the explicit dagger slot and self-inverse matrix bridge | proved transcript bridge |
| `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | focused source slot `2` maps to full basis index `[32,32]` | proved index bridge |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | the selected prepared entry evaluates to the backend fold under `hUniform` | compiled conditional bridge |
| `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | active seven-gate `[0,0]` expands through slot-`0` half-angle symbols | proved diagnostic only |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3` | selected active field reduces to seven-gate `[0,0]`, while the active gate list omits both $H_W^{(\kappa)}$ sides | proved mismatch witness |

## 3. Current Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guards` | Source-facing Fig. `1 term ROBIN` labels are present, including $H_W^{(\kappa)}$, `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, post-SWAP $(O_D^{BS})^\dagger$, and cleanup | source Fig. caption; indicator self-inverse bridge | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | conversion window | `python3 tools/qbe.py check` | proved |
| `slot2_branch_source_path` | Displayed boundary $\gamma_3$ slot `2` maps to full basis entry `[32,32]` | Eq. `ROBIN clarified`; backend branch index map | lower 1 | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | lower proof-DAG packet | `python3 tools/qbe.py check` | proved |
| `prepared_entry_backend_fold` | The theorem-facing prepared clean entry evaluates to the backend branch fold under `hUniform` | Eq. `arbitrary sparcity`; prepared composite semantics | lower 2 | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | conversion window and status notes | `python3 tools/qbe.py check` | compiled conditional |
| `active_eval_exposes_uncast_seven_gate` | Current selected active field is still seven-gate `[0,0]` compared with the prepared sandwich, and the active gate list omits both $H_W^{(\kappa)}$ sides | active/prepared reduction; sparse-preparation absence guard | lower 2 | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3` | `proof-attempts/QBE-AUTO-002/active-seven-gate-prepared-mismatch-20260609-lower2.md` | `python3 tools/qbe.py check` | proved mismatch witness |
| `prepared_signal_entry_lhs_repair` | Expose a theorem-facing statement whose left-hand side is the prepared clean entry `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`, or a named replacement target using the same matrix entry | transcript guards; prepared entry backend fold; block-encoding projection anchor | lower 2 | new target-shape/entry-selection theorem or record in `QuantumBlockEncoding/RobinMatrix.lean` | this packet | `python3 tools/qbe.py check` | active Lean leaf |
| `finite_active_to_prepared_composition` | If the seven-gate active entry remains the left-hand side, prove the separate finite composition theorem justifying replacement by the prepared entry | prepared signal-entry target; `PreparedCircuitEntryTarget`; active backend guard | lower 2 or later refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` or `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | proof-obligation ledger | `python3 tools/qbe.py check` | open; do not assume |
| `seven_gate_col0_slot0_diagnostic` | Active seven-gate `[0,0]` uses slot-`0` diagnostics | prefix/suffix eval lemmas | none | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | diagnostic note | none | retired from active proof search |
| `raw_coeff_fold_route` | Raw constructor equality for symbolic `Coeff` expressions | old H-free route | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog only | none | stale |

## 4. Lower-Agent Split

Lower 1 proof architect:

- Write the natural-language proof packet from `main.tex:948-955`,
  `main.tex:1098-1164`, and `main.tex:2027-2035` to the repaired
  theorem-facing prepared signal-entry target.
- The packet must name slot `2`, full basis index `[32,32]`,
  `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`, and the
  prepared-entry field
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.
- Classify every edge as `GHL-internal`, `external-cited-contract`, or
  `QBE-local semantic bridge`.
- Do not use the column-`0` diagnostics to justify the displayed slot-`2`
  coefficient.

Lower 2 Lean worker:

- Write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.
- Implement exactly one target-shape/entry-selection leaf.  Preferred shape:
  a theorem or record showing that the next theorem-facing statement consumes
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`
  and the compiled bridge
  `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
- If the worker keeps the active seven-gate `[0,0]` entry as the left-hand
  side, the worker must prove the separate finite composition theorem or leave
  it as a typed obligation.  It must not prove slot `0` equals the all-slot
  prepared sandwich by reusing slot-`0` diagnostics.
- Do not edit oracle contracts, do not promote `O_D^{BS}`, `O_{D^T}^S`,
  `O_f`, $H_W$, $R_y$, LCU, block-projection, block-correctness, unitarity, or
  final-extraction flags, and do not revive the raw `Coeff` constructor route.

Acceptance gate for either lower edit:

```bash
python3 tools/qbe.py check
```

