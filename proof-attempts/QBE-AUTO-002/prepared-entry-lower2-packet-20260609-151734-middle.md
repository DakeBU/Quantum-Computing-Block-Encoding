# QBE-AUTO-002 Lower 2 Packet: Prepared-Entry LHS Or Finite Composition

Date: 2026-06-09
Role: middle formalization maintainer
Mode: faithfulPaper
Lean edit status: no Lean edits by middle

## 1. Source Contract

Use the lower-1 proof map
`proof-attempts/QBE-AUTO-002/prepared-signal-entry-source-dag-20260609-lower1.md`.
It translates GHL2025 `main.tex:948-955`, `main.tex:1098-1164`,
`main.tex:1111-1119`, `main.tex:1122-1164`, and `main.tex:2027-2035` to the
prepared-entry route.

Definitions before the target:

| Name | Meaning |
|---|---|
| `hUniform` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the external clean-column contract for `H_W^(kappa)` |
| `Target(H, env)` | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| `PreparedEntry(H, env)` | `(Target(H, env)).preparedProjectionEntry`, the clean-clean entry of `H_W^(kappa)^dagger * U_gamma3 * H_W^(kappa)` |
| `BackendFold` | `(Target(H, env)).backendBranchFold`, equivalently `blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` |
| `Active00` | the active seven-gate `evalGateMatrices[0,0]` entry exposed by the current active/evaluated fields |

## 2. Accepted Dependencies

| Dependency | Status |
|---|---|
| `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | compiled transcript with both `H_W` sides, `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger` visible |
| `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | compiled guard that the active backend remains seven gates only |
| `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | compiled branch map for slot `2` at full basis `[32,32]` |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiled conditional evaluator from `PreparedEntry(H, env)` to `BackendFold` |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3` | compiled mismatch guard: the current active field exposes H-free `Active00` |
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3` | compiled mismatch guard for the evaluated backend-fold target |

## 3. Exact Lower 2 Task

Write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Implement exactly one of these leaves:

| Leaf | Required shape | Acceptance |
|---|---|---|
| `prepared_signal_entry_lhs_repair` | a small theorem or record whose left-hand side is `PreparedEntry(H, env)` and whose proof uses `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiles with `python3 tools/qbe.py check` |
| `finite_active_to_prepared_composition` | prove or strictly reduce `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | compiles with `python3 tools/qbe.py check` |

Do not prove a theorem whose substance is only `Active00` slot `0` equals the
slot `2` prepared branch.  If the target still exposes active seven-gate
`[0,0]` on the left, the finite active-to-prepared field must remain an
explicit obligation unless it is actually proved.

## 4. Forbidden Promotions

Do not promote `O_D^BS`, `O_{D^T}^S`, `O_f`, `H_W`, `R_y`, LCU,
block-projection, block-correctness, circuit unitarity, normalized equality, or
final extraction.  Do not revive `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`
or `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as the
main theorem route; those are diagnostic/backlog.

## 5. Handoff

Lower 1 has already completed the natural-language source DAG.  Lower 2 should
reference that packet and compile one leaf above.  Any failure should be
recorded as either a typed target-shape mismatch or a missing finite
composition lemma, not as an external cited-result gap.
