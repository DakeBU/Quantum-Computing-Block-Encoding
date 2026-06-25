# Proof Obligations: QBE-MAIN-CASE-HIER-COLD-001

## Fixed Target

The task-owned operator is

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The system basis is `(T,tau,S)` with one qubit per register.  Its flattening is
`4*T + 2*tau + S`, so the nonzero target entries are system row/column pairs
`(0,6)` and `(1,7)`.  The clean block is selected by one signal qubit at value
`0`.  The normalizer is `1`, and the exact error is `0`.

## Current Lean Surface

| Role | Lean declaration | Status |
|---|---|---|
| reusable clean-block card | `BlockEncodingClassics.partialPermutationCertificate` | compiled reusable dependency |
| reusable permutation matrix | `BlockEncodingClassics.permMatrix` | compiled reusable dependency |
| reusable clean-block extraction | `BlockEncodingClassics.cleanBlockBy` | compiled reusable dependency |
| reusable exact clean-block package | `BlockEncodingClassics.ExactCleanBlock` | compiled reusable dependency |
| task target file | `QuantumBlockEncoding/MainCase.lean` | exists, but currently contains only separate `mainCasePro*` declarations |
| task import from root | `QuantumBlockEncoding.lean` import for `MainCase` | present from separate worktree change |
| task target matrix | `mainCaseColdTarget` | planned |
| candidate finite image | `mainCaseColdPartialPermImage` | planned |
| clean-entry theorem | `mainCaseColdPartialPerm_clean_eq_target` | active Lean leaf |
| permutation/unitarity certificate | `mainCaseColdPartialPermImage_bijective` or stronger package | obligation |
| resource field certificates | `mainCaseColdPartialPermCost_*` | obligation |
| Qiskit/QASM3 export | export packet under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/` | blocked until Lean certificate |

`QuantumBlockEncoding/MainCase.lean` currently contains `mainCasePro*`
declarations for a separate Pro-isolated arm.  They do not satisfy this COLD
task.  The no-Pro arm needs independent `mainCaseCold*` declarations and
task-local proofs.

## Current Obligation State

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| add COLD task-local Lean target surface | `mainCaseCold*` declarations in `QuantumBlockEncoding/MainCase.lean` or child import | internal construction leaf | active |
| keep task file imported into the library | `import QuantumBlockEncoding.MainCase` in `QuantumBlockEncoding.lean` | build integration | present |
| define matrix/operator target `A` | `mainCaseColdTarget` | source translation | active |
| define clean projector/embedding | `mainCaseColdCleanEmbed` | shape/register | active |
| define candidate unitary matrix | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | candidate construction | active |
| prove clean-block equality | `mainCaseColdPartialPerm_clean_eq_target` | symbolic bridge | active |
| prove permutation/unitarity | `mainCaseColdPartialPermImage_bijective`; later unitary theorem if needed | unitarity layer | open |
| make normalizer explicit | `mainCaseColdExactNormalizer = 1` | source translation | active |
| make auxiliary qubit count explicit | `mainCaseColdPartialPermCost.auxiliaryQubits = 1` or layout theorem | resource layer | open |
| make resource tuple explicit | field theorems for `(gateCount, depth, auxiliaryQubits, oracleCalls)` | resource layer | open; gate/depth need circuit schema |
| compare against baseline | candidate-population row for `MAIN-PARTIAL-PERM-001` | exploratory memory | queued |
| run gate | `python3 tools/qbe.py check` | project gate | required after edits |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Translate target matrix, register order, clean signal, normalizer, and exact error into Lean. | task packet | lower 2 | `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | conversion window | `python3 tools/qbe.py check` | active prerequisite |
| `MAIN-CAND-IMAGE-001` | Define the task-local `Fin 16` partial-permutation completion. | `MAIN-SOURCE-001` | lower 2 | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | conversion window candidate table | `python3 tools/qbe.py check` | active prerequisite |
| `MAIN-FINITE-DIAG-001` | Check candidate table, clean block, normalizer, ancilla, and current resource fields. | candidate table | lower 3 | `verifier-feedback/.../main-case-partial-perm-cycle01.*` | verifier-feedback packet | diagnostic plus typed feedback | preliminary middle diagnostic passed |
| `MAIN-CLEAN-ENTRY-001` | Package the clean-entry equality through `partialPermutationCertificate`. | `MAIN-SOURCE-001`, `MAIN-CAND-IMAGE-001` | lower 2 | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | conversion window | `python3 tools/qbe.py check` | active Lean leaf |
| `MAIN-PERM-UNITARY-001` | Prove finite bijection/permutation and connect to unitarity obligation. | `MAIN-CAND-IMAGE-001`, `MAIN-FINITE-DIAG-001` | lower 2/refiner | `mainCaseColdPartialPermImage_bijective` | this ledger | `python3 tools/qbe.py check` | open |
| `MAIN-RESOURCE-001` | Certify the resource tuple. | candidate circuit schema | lower 2/refiner | `mainCaseColdPartialPermCost_*` | candidate population | `python3 tools/qbe.py check` | open |
| `MAIN-EXPORT-001` | Generate Qiskit and QASM3 exports from named Lean certificates. | block, unitarity, and resource certificates | later export worker | export manifest/check files | export ledger | export checks plus project gate | blocked |

## Open Obligations

| Obligation | Why it is needed | Next route |
|---|---|---|
| COLD task-local Lean surface is missing | `QuantumBlockEncoding/MainCase.lean` exists and is imported, but it currently contains only separate `mainCasePro*` declarations | lower 2 adds independent `mainCaseCold*` declarations without using `mainCasePro*` as certificates |
| clean-entry theorem is not proved | exact block-entry equality is the root semantic claim for this cycle | lower 2 proves `MAIN-CLEAN-ENTRY-001` using `BlockEncodingClassics.partialPermutationCertificate` |
| finite verifier script not yet durable | a middle sanity check passed, but lower 3 may still mirror it into a durable diagnostic script if the run wants executable verifier memory | lower 3 writes or confirms the exact 16-state diagnostic under `verifier-feedback/` |
| unitarity layer is not certified | a permutation-matrix block equality alone is not a full block-encoding certificate at the advertised tier | prove bijection/permutation and then connect to the project unitary predicate or record the missing bridge |
| resource tuple is incomplete | `a=1` and `oracleCalls=0` are clear, but gate count and depth require a named circuit schema or honest high-level score | keep gate/depth as obligations until the circuit/resource declarations compile |
| executable export is blocked | export policy is Lean-first | start Qiskit/QASM3 only after named Lean block, unitarity, and resource certificates exist |

## Source-Dependency Audit

No local paper-source archive is available for this task.  This is not a
blocker for the current exploratory operator-construction leaf because the
task packet itself supplies the operator, register layout, normalizer, clean
projector, and exactness requirement.

| Potential dependency | Classification | Required action before lower work |
|---|---|---|
| source proof paragraph | no paper proof present | use task-owned operator contract |
| cited theorem or subroutine | none active | no cited-results row needed |
| classical fact | finite image table over `Fin 16` | prove locally by `native_decide` or finite case split |
| semantic bridge | exact clean block from permutation entries | reuse `BlockEncodingClassics.partialPermutationCertificate` |
| current mismatch | COLD declarations absent while Pro declarations exist | repair COLD Lean surface before unitarity/resource/export work |

## Verifier Feedback Fields For Lower Attempts

Lower attempts should report:

`leaf`, `source_correspondence_ok`, `lean_parse_ok`, `lean_build_ok`,
`finite_matrix_ok`, `block_entry_ok`, `ancilla_cleanup_ok`, `normalizer_ok`,
`unitarity_ok`, `resource_score`, `auxiliary_qubits`, `gate_count`, `depth`,
`oracle_calls`, `closed_theorem_ok`, `error_class`, and `next_route`.

Expected useful error classes are `shape_or_register_gap`,
`finite_matrix_counterexample`, `symbolic_bridge_gap`, `lean_tactic_gap`,
`stale_leaf`, and `invalid_route`.  No external cited result is active for this
packet.

## Stale And Rejected Route Memory

- Retire any lower packet that uses prior main-case candidate names, previous
  Pro answers, or prior Qiskit exports as construction parents.
- Reject any candidate that changes `mainCaseColdTarget`, the clean signal value,
  the normalizer, the passive identity factor, or the exact target.
- Reject simulator-only acceptance.  Finite diagnostics may guide search, but
  Lean theorem closure remains the acceptance gate.
