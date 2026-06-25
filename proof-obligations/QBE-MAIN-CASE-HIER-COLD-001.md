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
| task target file | `QuantumBlockEncoding/MainCase.lean` | contains separate `mainCasePro*` declarations and independent COLD declarations |
| task import from root | `QuantumBlockEncoding.lean` import for `MainCase` | present from separate worktree change |
| task target matrix | `mainCaseColdTarget` | compiled |
| candidate finite image | `mainCaseColdPartialPermImage` | compiled |
| clean-entry theorem | `mainCaseColdPartialPerm_clean_eq_target` | proved |
| permutation/unitarity certificate | `mainCaseColdPartialPermImage_bijective`; stronger matrix-unitary package if required | finite bijection proved |
| operator target metadata | `mainCaseColdQueryTarget` | compiled |
| block-projection predicate | `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection` | proved |
| source layout and resource schema | `mainCaseColdSourceLayout`, `mainCaseColdSourceLayout_auxiliaryQubits`, `mainCaseColdCircuit`, `mainCaseColdSchedule`, `mainCaseColdCircuitImage_eq_partialPermImage` | layout and COLD-local logical schema compiled |
| COLD candidate package | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified` | active next leaf after resource closure |
| resource field certificates | `mainCaseColdPartialPermCost_*` | proved as `(5, 5, 1, 0)` at high-level logical tier |
| Qiskit/QASM3 export | export packet under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/` | blocked until Lean certificate |

`QuantumBlockEncoding/MainCase.lean` contains `mainCasePro*` declarations for a
separate Pro-isolated arm and independent `mainCaseCold*` declarations for this
task.  The COLD clean-block equality is task-local; the Pro declarations remain
out of scope for COLD certificates.

## Current Obligation State

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| add COLD task-local Lean target surface | `mainCaseCold*` declarations in `QuantumBlockEncoding/MainCase.lean` | internal construction leaf | proved |
| keep task file imported into the library | `import QuantumBlockEncoding.MainCase` in `QuantumBlockEncoding.lean` | build integration | present |
| define matrix/operator target `A` | `mainCaseColdTarget` | source translation | proved |
| define clean projector/embedding | `mainCaseColdCleanEmbed` | shape/register | proved |
| define candidate unitary matrix | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | candidate construction | proved |
| prove clean-block equality | `mainCaseColdPartialPerm_clean_eq_target` | symbolic bridge | proved |
| prove permutation/unitarity | `mainCaseColdPartialPermImage_bijective`; later unitary theorem if needed | unitarity layer | finite bijection proved; retired from active queue |
| state operator-first target metadata | `mainCaseColdQueryTarget` | source translation | proved |
| state project-local block projection and prove candidate matrix satisfies it | `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection` | semantic bridge | proved |
| make normalizer explicit | `mainCaseColdExactNormalizer = 1` | source translation | compiled |
| make auxiliary qubit count explicit | `mainCaseColdSourceLayout_auxiliaryQubits`, `mainCaseColdPartialPermCost_auxiliaryQubits` | resource layer | proved |
| make resource tuple explicit | field theorems for `(gateCount, depth, auxiliaryQubits, oracleCalls)` | resource layer | proved as `(5,5,1,0)` after COLD-local circuit schema |
| package COLD candidate and verified certificate | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified` | candidate packaging | active next leaf; resource tuple now ready |
| compare against baseline | candidate-population row for `MAIN-PARTIAL-PERM-001` | exploratory memory | updated with compiled resource tuple; full candidate ranking still awaits verified package |
| run gate | `python3 tools/qbe.py check` | project gate | required after edits |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Translate target matrix, register order, clean signal, normalizer, and exact error into Lean. | task packet | lower 2 | `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CAND-IMAGE-001` | Define the task-local `Fin 16` partial-permutation completion. | `MAIN-SOURCE-001` | lower 2 | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | conversion window candidate table | `python3 tools/qbe.py check` | proved |
| `MAIN-FINITE-DIAG-001` | Check candidate table, clean block, normalizer, ancilla, and current resource fields. | candidate table | lower 3 | `verifier-feedback/.../main-case-cold-perm-unitary-cycle02.*` | verifier-feedback packet | diagnostic plus typed feedback | durable diagnostic passed |
| `MAIN-CLEAN-ENTRY-001` | Package the clean-entry equality through `partialPermutationCertificate`. | `MAIN-SOURCE-001`, `MAIN-CAND-IMAGE-001` | lower 2 | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-PERM-UNITARY-001` | Prove finite bijection/permutation for the finite-permutation semantic tier. | `MAIN-CAND-IMAGE-001`, `MAIN-FINITE-DIAG-001` | lower 2 | `mainCaseColdPartialPermImage_bijective` | verifier feedback | `python3 tools/qbe.py check` | proved and retired from active queue |
| `MAIN-BLOCK-PROJECTION-001` | Define COLD `QueryOperatorTarget` and `signalSystemBlockProjection` predicate, then prove the COLD permutation matrix satisfies that predicate. | `MAIN-CLEAN-ENTRY-001`, `MAIN-PERM-UNITARY-001` | lower 2 | `mainCaseColdQueryTarget`, `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection` | conversion window and cycle-3 source contract | `python3 tools/qbe.py check` | proved |
| `MAIN-RESOURCE-001` | Certify an honest resource tuple. | `MAIN-BLOCK-PROJECTION-001`, candidate circuit/schema choice | lower 2 | `mainCaseColdCircuit`, `mainCaseColdCircuitImage_eq_partialPermImage`, `mainCaseColdPartialPermCost_*` | candidate population | `python3 tools/qbe.py check` | proved at high-level logical resource tier |
| `MAIN-CANDIDATE-PACKAGE-001` | Package the COLD candidate and verified certificate without changing the target or hiding resource assumptions. | `MAIN-BLOCK-PROJECTION-001`, `MAIN-RESOURCE-001` | lower 2/refiner | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified` | conversion window | `python3 tools/qbe.py check` | active leaf |
| `MAIN-EXPORT-001` | Generate Qiskit and QASM3 exports from named Lean certificates. | block, unitarity, and resource certificates | later export worker | export manifest/check files | export ledger | export checks plus project gate | blocked |

## Open Obligations

| Obligation | Why it is needed | Next route |
|---|---|---|
| finite verifier script | the durable script and feedback packet now parse the COLD image table and check bijection, clean support, passive `S`, normalizer, ancilla, and oracle calls | keep as memory; rerun only if the target or table changes |
| COLD block-projection predicate | the project-local candidate interface expects a `signalSystemBlockProjection` predicate | closed by `mainCaseColdQueryTarget`, `mainCaseColdBlockProjection`, and `mainCaseColdPartialPerm_blockProjection`; reopen only if the target or matrix table changes |
| matrix-unitary bridge is not a current active leaf | the finite image is proved bijective; a reusable rational-orthogonal matrix predicate can be attached later if reviewer raises the semantic tier | keep as deferred bridge, not a lower target for cycle 3 |
| resource tuple is compiled | `mainCaseColdCircuitImage_eq_partialPermImage` ties the COLD logical transcript to the finite table, and `mainCaseColdPartialPermCost_*` proves `(5,5,1,0)` | next worker should consume these declarations rather than reopening resource search |
| candidate package is incomplete | there is no COLD `OperatorBlockEncodingCandidate` or `VerifiedOperatorBlockEncoding` yet | package using `mainCaseColdPartialPermMatrix`, finite-permutation proof, block projection proof, and compiled resource declarations |
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
| current mismatch | none at the clean-block, finite-permutation, block-projection, or resource-tuple layers; candidate package and export layers remain open | schedule `MAIN-CANDIDATE-PACKAGE-001` before export work |

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
- Retire `MAIN-CLEAN-ENTRY-001` and finite-bijection-only
  `MAIN-PERM-UNITARY-001` packets.  Reopening either is stale unless the COLD
  target or image table changes.
