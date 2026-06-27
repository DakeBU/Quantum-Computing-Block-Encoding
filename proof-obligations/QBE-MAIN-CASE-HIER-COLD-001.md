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
| COLD candidate package | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, `mainCaseColdPartialPermCandidate_cost` | proved |
| resource field certificates | `mainCaseColdPartialPermCost_*` | proved as `(5, 5, 1, 0)` at high-level logical tier |
| Qiskit/QASM3 export | `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`; corrected map uses `S=0,tau=1,T=2,signal=3`; generated Qiskit, QASM3, manifest, and deterministic checker pass | completed post-Lean export leaf |

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
| package COLD candidate and verified certificate | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, `mainCaseColdPartialPermCandidate_cost` | candidate packaging | proved |
| compare against baseline | candidate-population row for `MAIN-PARTIAL-PERM-001` | exploratory memory | updated with compiled verified package and resource tuple |
| run gate | `python3 tools/qbe.py check` | project gate | passed after candidate-package and test updates |

## Cycle 20260627 Candidate-Package Closure

The leaf `MAIN-CANDIDATE-PACKAGE-001` is now closed.  It was a packaging leaf,
not a new construction route.  The compiled record fields are:

| Record field or proof | Required COLD declaration |
|---|---|
| `auxiliaryQubits` | `1` |
| `target` | `mainCaseColdQueryTarget` |
| `unitary` | `mainCaseColdPartialPermMatrix` |
| `layout` | `mainCaseColdSourceLayout` |
| `circuit` | `mainCaseColdCircuit` |
| `schedule` | `mainCaseColdSchedule` |
| `resource` | `mainCaseColdHighLevelResource` |
| `layoutMatches` | `mainCaseColdSourceLayout_auxiliaryQubits` |
| `isUnitary` | `mainCaseColdPartialPermImageIsPermutation` |
| `blockContainsTarget` | `mainCaseColdBlockProjection mainCaseColdPartialPermMatrix` |
| `unitaryProof` | `mainCaseColdPartialPermImage_bijective` |
| `blockProof` | `mainCaseColdPartialPerm_blockProjection` |

Acceptance evidence is `mainCaseColdPartialPermCandidate`,
`mainCaseColdPartialPermVerified`, and
`mainCaseColdPartialPermCandidate_cost`.  The cost reads
`(gateCount, depth, auxiliaryQubits, oracleCalls) = (5, 5, 1, 0)` at the
high-level logical tier.  Qiskit/QASM3 export has proceeded from the named Lean certificate.  The generated Qiskit, QASM3, manifest, and deterministic checker pass against the COLD finite image and resource tuple.

## Cycle 2 Export-Map Repair

The active post-Lean source-correspondence object is the executable translation
of the compiled COLD circuit, not a new Lean theorem.  The source anchor remains
the task packet target

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The Lean certificate fixes the full basis index as
`8*signal + 4*T + 2*tau + S`.  Therefore the executable integer bit weights are
`S=0`, `tau=1`, `T=2`, and `signal=3`.  The earlier export-plan wording
`T=0`, `tau=1`, `S=2`, `signal=3` was contract drift.  It is now retired, and
lower export work must consume the corrected map:

| Source register | Lean bit weight | Qiskit qubit |
|---|---:|---|
| `S` | `0` | `q[0]` |
| `tau` | `1` | `q[1]` |
| `T` | `2` | `q[2]` |
| `signal` | `3` | `q[3]` |

No external cited-result row is needed.  This repair is QBE-local semantic glue
between the compiled Lean certificate and post-Lean executable artifacts.

If a later refactor breaks the package, classify the failure narrowly:

| Symptom | Primary class | Next route |
|---|---|---|
| candidate record field type mismatch | `shape_or_register_gap` | adapt only the record-field bridge; do not alter target or circuit |
| proof script cannot inhabit `candidate.isUnitary` or `candidate.blockContainsTarget` after unfolding | `lean_tactic_gap` | isolate the exact unfolded proposition and prove that bridge |
| attempted proof requires a stronger matrix-orthogonality predicate than the record asks for | `symbolic_bridge_gap` | add a separate bridge obligation, not a target mutation |
| lower work imports Pro-arm names or previous Qiskit exports as evidence | `invalid_route` | reject the attempt and restart from COLD declarations |

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
| `MAIN-CANDIDATE-PACKAGE-001` | Package the COLD candidate and verified certificate without changing the target or hiding resource assumptions. | `MAIN-BLOCK-PROJECTION-001`, `MAIN-RESOURCE-001` | middle/lower 2 | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, `mainCaseColdPartialPermCandidate_cost` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-EXPORT-MAP-001` | Record export register map from the named Lean certificate. | `mainCaseColdPartialPermVerified`, `mainCaseColdPartialPermCandidate_cost` | middle | `export-plan.md`; source-contract packet; verifier-feedback repair packet | conversion window | `python3 tools/qbe.py check` | repaired and retired; consumed by `MAIN-EXPORT-IMPLEMENT-001` |
| `MAIN-EXPORT-IMPLEMENT-001` | Generate Qiskit and QASM3 exports from named Lean certificates. | `MAIN-EXPORT-MAP-001` | export worker | `export-manifest.json`, `qiskit/export.py`, `qasm3/main_case_cold_partial_perm.qasm3`, `main_case_cold_export_check.py` | executable export packet | export checks plus project gate | completed; deterministic checks pass |
| `MAIN-EXPORT-VERIFY-001` | Rerun deterministic export verification against the COLD Lean table. | `MAIN-EXPORT-IMPLEMENT-001` | verifier | `main-case-cold-export-implement-cycle02.md` | verifier-feedback packet | export checks plus project gate | completed; basis action, clean support, passive `S`, alpha, epsilon, resource tuple, QASM3, and forbidden-reference checks pass |

## Closed and Deferred Notes

There is no active proof leaf for the COLD exact main-case certificate or its executable export.  The table below records what should be reused or reopened only under an explicit semantic-tier change.

| Item | Current evidence | Reopen condition |
|---|---|---|
| finite verifier script | durable script and feedback packet check bijection, clean support, passive `S`, normalizer, ancilla, and oracle calls | rerun only if the target or finite table changes |
| COLD block-projection predicate | closed by `mainCaseColdQueryTarget`, `mainCaseColdBlockProjection`, and `mainCaseColdPartialPerm_blockProjection` | reopen only if the target or matrix table changes |
| matrix-unitary bridge | finite image is proved bijective; stronger rational-orthogonal matrix theorem is optional | attach only if reviewer raises the semantic tier beyond the current finite-permutation certificate |
| resource tuple | `mainCaseColdCircuitImage_eq_partialPermImage` and `mainCaseColdPartialPermCost_*` prove `(5,5,1,0)` | reopen only if the circuit transcript or metric definition changes |
| candidate package | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, and `mainCaseColdPartialPermCandidate_cost` compile | reuse as the exact certificate and zero-error incumbent |
| executable export | Qiskit, QASM3, manifest, and deterministic checker pass from `mainCaseColdPartialPermVerified` with `q[0]=S,q[1]=tau,q[2]=T,q[3]=signal` | rerun if export language, wire map, or certificate changes |

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
| current mismatch | none at the clean-block, finite-permutation, block-projection, resource-tuple, candidate-package, or executable-export layers; export-map drift was repaired to `S=0,tau=1,T=2,signal=3` | no lower proof leaf is active unless the target, semantic tier, metric, or export language changes |

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
