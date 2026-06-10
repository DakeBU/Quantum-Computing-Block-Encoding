# QBE-AUTO-002 Finite Active-To-Prepared Composition Packet

Date: 2026-06-09
Role: middle formalization maintainer
Mode: faithfulPaper
Run: `20260609-154329-QBE-AUTO-002-cycle01`

## Source-Contract Audit

The local TeX source was re-read around `main.tex:948-955`,
`main.tex:1098-1164`, and `main.tex:2027-2035` before assigning the next
proof work.  Public artifacts should cite these anchors, not the machine-local
source path.

| Source anchor | Paper step | Lean contract or declaration | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955` | `H_W^(kappa)` prepares the sparse register with all-slot amplitude `1 / sqrt(kappa)`. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only; Shukla--Vedula is not recursively formalized in this packet |
| `main.tex:1098-1109` | The one-term Robin theorem claims the normalized block-encoding of `A_k`. | source-prepared projection route plus final `CircuitBlockEncodingClaim` | GHL-internal theorem target | not closed |
| `main.tex:1111-1119` | The displayed boundary `gamma_3` clean coefficient is the sparse-slot sum contribution, with the focused finite branch at slot `2`. | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal branch plus QBE-local index bridge | compiled branch map |
| `main.tex:1122-1164` | Fig. `1 term ROBIN` uses both `H_W` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, post-SWAP `(O_D^BS)^dagger`, and cleanup. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local permutation bridge | compiled transcript guard; not a full semantic theorem |
| `main.tex:2027-2035` | Block-encoding extracts the clean signal block after pure-ancilla cleanup. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | QBE-local semantic bridge | selected prepared entry compiled; active-to-prepared composition remains open |

## Definitions Before Claims

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, let
`PreparedEntry(H, env)` be
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.
This is the clean entry of the prepared singleton semantics for
`H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)`.

Let `Active00(env)` be the uncast active seven-gate entry
`evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders
(oneTermParameters 3))[0,0]` after `Coeff.evalWith env`.

The compiled theorem
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3`
has retired the target-shape leaf: it exposes `PreparedEntry(H, env)` as the
left side of the backend evaluator under `hUniform`.

The remaining active leaf is finite active-to-prepared composition:
`Active00(env)` must equal the prepared singleton clean entry, or an equivalent
strictly smaller statement must feed
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing transcript exposes `H_W`, `U_indic^dagger`, pre-SWAP `O_DT^BS`, post-SWAP `(O_D^BS)^dagger`, and cleanup | Fig. `1 term ROBIN`; indicator self-inverse bridge | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | proved transcript guard |
| `prepared_entry_backend_eval` | `PreparedEntry(H, env)` evaluates to the backend fold under the `H_W` clean-column contract | Eq. `arbitrary sparcity`; source-prepared target | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | lower-1 packet; status notes | `python3 tools/qbe.py check` | proved conditional |
| `prepared_signal_entry_lhs_repair` | evaluated backend target exposes `PreparedEntry(H, env)` as the LHS | prepared-entry backend eval | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3` | `proof-attempts/QBE-AUTO-002/prepared-entry-lhs-repair-20260609-lower2.md` | `python3 tools/qbe.py check` | compiled; retired |
| `finite_active_to_prepared_composition` | prove `Active00(env)` equals the prepared singleton clean entry, or the equivalent active/prepared field | active backend guard; prepared target; mismatch witness | lower 2/refiner | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`; `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | this packet; proof obligations | `python3 tools/qbe.py check` | active Lean leaf |
| `slot2_branch_map` | displayed slot `2` is the selected backend summand at full basis `[32,32]` | Eq. `ROBIN clarified`; branch index map | lower 1 | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | `proof-attempts/QBE-AUTO-002/prepared-signal-entry-source-dag-20260609-lower1.md` | `python3 tools/qbe.py check` | proved branch map |
| `active_h_free_mismatch_guard` | current active field remains the H-free seven-gate `[0,0]` entry and omits both `H_W` sides | active/prepared reduction; sparse-preparation absence guard | lower 2 | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3` | `proof-attempts/QBE-AUTO-002/active-seven-gate-prepared-mismatch-20260609-lower2.md` | `python3 tools/qbe.py check` | proved mismatch witness |
| `column0_slot0_diagnostic` | active seven-gate `[0,0]` expands through slot `0` diagnostics | two-path support lemmas | none | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | diagnostic/backlog | none | retired |
| `raw_coeff_fold_route` | raw constructor equality for H-free symbolic products | old backend fold route | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale |

## Lower-Agent Split

| Lower profile | Packet |
|---|---|
| lower 1 proof architect | Write a natural-language proof packet for `finite_active_to_prepared_composition`.  Reuse `prepared-signal-entry-source-dag-20260609-lower1.md`; do not re-open broad source search.  The packet should explain why the active seven-gate `[0,0]` entry can be compared with the prepared singleton clean entry, or classify the missing equality as QBE-local finite `CircuitMatrixSemantics` composition. |
| lower 2 Lean worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Implement exactly one active leaf: first target `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; accepted smaller targets are `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`, `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`, or a theorem directly feeding `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.  Run `python3 tools/qbe.py check`. |

No oracle, `H_W`, `R_y`, LCU, block-projection, block-correctness, unitarity,
normalized-equality, product-to-coefficient, or final-extraction flag may be
promoted by this packet.  The source dependency classification is QBE-local
finite matrix semantics, not a new Shukla--Vedula, Gilyen/LCU, sparse-oracle,
function-oracle, or classical theorem dependency.
