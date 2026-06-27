# Lower Architect Packet: QBE-MAIN-CASE-HIER-COLD-001 Cycle 2 MAIN-EXPORT-IMPLEMENT-001

## Source Fragment

No local paper-source archive is present for this task.  The source fragment
being translated is therefore the task-owned operator contract, already
synchronized in `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md`:

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The block-encoding contract is the exact clean-signal equality

$$
(<0| \otimes I) U (|0> \otimes I) = E_1.
$$

The benchmark instance fixes one qubit each for `T`, `tau`, and passive `S`,
one clean signal qubit at value `0`, normalizer `1`, and exact error `0`.
The system index is `4*T + 2*tau + S`, and the full signal-system index is
`8*signal + 4*T + 2*tau + S`.

The source-paper proof fragment for this cycle is not a new paper proof.  It is
the post-Lean executable translation of the already compiled COLD certificate
`mainCaseColdPartialPermVerified` and cost theorem
`mainCaseColdPartialPermCandidate_cost`.

## Definitions

Use the bit variables `b`, `T`, `tau`, and `S`, where `b` is the signal bit.
The executable integer bit weights must be:

| Register | Bit weight | Qiskit integer-basis wire |
|---|---:|---|
| `S` | `0` | `q[0]` |
| `tau` | `1` | `q[1]` |
| `T` | `2` | `q[2]` |
| `signal` | `3` | `q[3]` |

Define the exported logical transcript by the five gates

```text
X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal
```

with passive `S` untouched.  For a Qiskit qubit list ordered as
`[S, tau, T, signal]`, the operations are:

```text
x(q[2]);
ccx(q[1], q[2], q[3]);
x(q[1]);
cx(q[3], q[2]);
cx(q[1], q[3]);
```

For a deterministic export checker, define:

```text
S      = index & 1
tau    = (index >> 1) & 1
T      = (index >> 2) & 1
signal = (index >> 3) & 1
```

and return `8*signal_out + 4*T_out + 2*tau_out + S`.

## Local Proof

All bit arithmetic in this section is over bits, so addition is modulo two.
The first gate changes the time bit to `1 + T`.  The Toffoli then changes the
signal bit to

$$
b_2 = b + \tau(1 + T).
$$

The third gate changes the type bit to `1 + tau`.  The fourth gate uses the
current signal as a control and changes the time bit to

$$
T_4 = 1 + T + b_2 = 1 + T + b + \tau + T\tau.
$$

The last gate uses the updated type bit as a control and changes the signal bit
to

$$
b_5 = b_2 + (1 + \tau) = 1 + b + T\tau.
$$

Thus the active output map is

$$
(b,T,\tau) \mapsto
(1 + b + T\tau,\; 1 + T + b + \tau + T\tau,\; 1 + \tau).
$$

Lifting this map by the identity on `S` gives the full basis action:

| Input index | Output index |
|---:|---:|
| `0` | `14` |
| `1` | `15` |
| `2` | `8` |
| `3` | `9` |
| `4` | `10` |
| `5` | `11` |
| `6` | `0` |
| `7` | `1` |
| `8` | `2` |
| `9` | `3` |
| `10` | `4` |
| `11` | `5` |
| `12` | `6` |
| `13` | `7` |
| `14` | `12` |
| `15` | `13` |

This is exactly the Lean table `mainCaseColdPartialPermImage`, and Lean already
proves the bridge by

```lean
theorem mainCaseColdCircuitImage_eq_partialPermImage :
    forall x : Fin 16,
      mainCaseColdCircuitImage x = mainCaseColdPartialPermImage x
```

For the clean block, set `b = 0`.  The output signal is clean exactly when
`1 + T*tau = 0`, which happens only for `T = 1` and `tau = 1`.  In that case
the system output is `(T,tau,S) = (0,0,S)`.  Therefore the clean-block support
is exactly `(0,6)` and `(1,7)` in system indices.  This is the target matrix
`mainCaseColdTarget`, already proved by `mainCaseColdPartialPerm_blockProjection`
and packaged in `mainCaseColdPartialPermVerified`.

The export worker should therefore generate executable artifacts from the
five-gate transcript and expose a deterministic basis-action function or table
equal to the full action above.  The export verifier should compare the
generated action against `mainCaseColdPartialPermImage`; it should not attempt
a new Lean theorem.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration or artifact | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Fixed operator, register order, clean signal, normalizer, and exact error. | task packet | previous lower | `mainCaseColdTarget`, `mainCaseColdQueryTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CAND-IMAGE-001` | COLD finite permutation table on `Fin 16`. | `MAIN-SOURCE-001` | previous lower | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CLEAN-ENTRY-001` | Clean block equals `E_1`. | `MAIN-CAND-IMAGE-001` | previous lower | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPerm_clean_eq_target` | conversion window | project gate | proved and retired |
| `MAIN-PERM-UNITARY-001` | Finite image is a bijection at the finite-permutation semantic tier. | `MAIN-CAND-IMAGE-001` | previous lower | `mainCaseColdPartialPermImage_bijective` | verifier feedback | project gate | proved and retired |
| `MAIN-BLOCK-PROJECTION-001` | Project-local block projection predicate holds. | `MAIN-CLEAN-ENTRY-001`, `MAIN-PERM-UNITARY-001` | previous lower | `mainCaseColdPartialPerm_blockProjection` | conversion window | project gate | proved and retired |
| `MAIN-RESOURCE-001` | Circuit transcript implements the table and has cost `(5,5,1,0)`. | `MAIN-BLOCK-PROJECTION-001` | previous lower | `mainCaseColdCircuit`, `mainCaseColdSchedule`, `mainCaseColdCircuitImage_eq_partialPermImage`, `mainCaseColdPartialPermCost_*` | candidate population | project gate | proved and retired |
| `MAIN-CANDIDATE-PACKAGE-001` | Package the COLD verified certificate. | `MAIN-BLOCK-PROJECTION-001`, `MAIN-RESOURCE-001` | previous lower | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, `mainCaseColdPartialPermCandidate_cost` | proof obligations | project gate | proved and retired |
| `MAIN-EXPORT-MAP-001` | Record export register map from the named Lean certificate. | `MAIN-CANDIDATE-PACKAGE-001` | middle | `export-plan.md`, source-contract packet, map feedback JSON | proof obligations and export plan | project gate | repaired and retired |
| `MAIN-EXPORT-IMPLEMENT-001` | Generate Qiskit, QASM3, and manifest artifacts for the certified transcript. | `MAIN-EXPORT-MAP-001`, `mainCaseColdCircuitImage_eq_partialPermImage` | next export worker | `qiskit/`, `qasm3/`, manifest | this packet and export plan | export checker plus project gate | active leaf |
| `MAIN-EXPORT-VERIFY-001` | Check generated basis action, clean support, passive `S`, normalizer, exact error, resource tuple, and forbidden references. | `MAIN-EXPORT-IMPLEMENT-001` | next verifier | verifier feedback packet | this packet | export checker plus project gate | pending |

The next active leaf is `MAIN-EXPORT-IMPLEMENT-001`.  There is no active Lean
proof leaf in this cycle.  A Lean-focused lower worker should avoid editing
`QuantumBlockEncoding/MainCase.lean` unless the deterministic export verifier
finds a mismatch in the compiled COLD declarations.

## Ordered Lean Dependencies To Reuse

1. `mainCaseColdSystemIndex` and `mainCaseColdTarget` for the target support
   pairs `(0,6)` and `(1,7)`.
2. `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, and
   `mainCaseColdCleanSignal` for manifest metadata.
3. `mainCaseColdPartialPermImage` as the reference full basis action.
4. `mainCaseColdCircuit`, `mainCaseColdSchedule`, and
   `mainCaseColdCircuitImage_eq_partialPermImage` as the transcript-to-table
   bridge.
5. `mainCaseColdPartialPermImage_bijective` for the finite-permutation
   semantic tier.
6. `mainCaseColdPartialPerm_blockProjection` for the clean-block predicate.
7. `mainCaseColdPartialPermCost_*` and
   `mainCaseColdPartialPermCandidate_cost` for the resource tuple `(5,5,1,0)`.
8. `mainCaseColdPartialPermVerified` as the Lean certificate named by every
   generated manifest and export report.

No new generic matrix, finite-sum, or algebra lemma is proposed here, so no
Mathlib search was needed for this Markdown-only packet.

## Failure Analysis

The mathematical target is not wrong.  It is already Lean-closed at the current
finite-permutation semantic tier by `mainCaseColdPartialPermVerified`.  The
current failure is post-Lean artifact absence: the export root still contains
only `export-plan.md`, so no generated Qiskit, QASM3, or manifest artifact can
be compared against the Lean table.

Useful narrow failures for the next worker are:

| Symptom | Error class | Next route |
|---|---|---|
| no `qiskit/`, `qasm3/`, or manifest files exist | `source_translation_gap` | generate the artifacts from the certified five-gate transcript |
| generated action disagrees with `mainCaseColdPartialPermImage` | `shape_or_register_gap` or `finite_matrix_counterexample` | repair wire order or basis-action code; do not mutate Lean target |
| clean support is not exactly `(0,6)` and `(1,7)` | `finite_matrix_counterexample` | reject the export implementation and regenerate from `mainCaseColdCircuit` |
| manifest changes alpha, exact error, clean projector, or resource tuple | `source_translation_gap` | repair manifest metadata from COLD declarations |
| generated artifact cites `mainCasePro*` or previous exports as evidence | `invalid_route` | remove that evidence path and cite only `mainCaseCold*` declarations |

LCU, sparse access, QSVT, dilation, approximate search, and target mutation are
not repair routes for this leaf.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAIN-EXPORT-IMPLEMENT-001` |
| `source_correspondence_ok` | `true` for the repaired map; `false` for implementation completeness until artifacts exist |
| `lean_parse_ok` | `true`; no Lean edits in this packet |
| `lean_build_ok` | `true` after the gate for this packet |
| `finite_matrix_ok` | `null`; no generated basis-action artifact exists yet |
| `block_entry_ok` | `true` for compiled COLD certificate; pending for generated artifacts |
| `ancilla_cleanup_ok` | `true` at metadata level; pending for generated action |
| `normalizer_ok` | `true`, alpha is `1` |
| `unitarity_ok` | `true` at finite-permutation tier by `mainCaseColdPartialPermImage_bijective` |
| `resource_score` | `(5,5,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `5` |
| `depth` | `5` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `false`; this is a post-Lean export leaf, not a new Lean theorem |
| `error_class` | `source_translation_gap` until generated artifacts exist |
| `next_route` | Generate Qiskit, QASM3, and manifest artifacts under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`, then run the export verifier and project gates. |

## Handoff

`MAIN-EXPORT-MAP-001` is repaired and should stay retired.  The next worker
should implement `MAIN-EXPORT-IMPLEMENT-001` by generating Qiskit, QASM3, and a
manifest from `mainCaseColdPartialPermVerified`,
`mainCaseColdCircuitImage_eq_partialPermImage`, and
`mainCaseColdPartialPermCandidate_cost`.  The deterministic basis action must
use `q[0]=S`, `q[1]=tau`, `q[2]=T`, and `q[3]=signal` and must match the full
table listed in this packet on all 16 inputs.
