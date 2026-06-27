# Lower Architect Packet: QBE-MAIN-CASE-HIER-COLD-001 Cycle 1 MAIN-EXPORT-001

## Source Fragment

No local paper-source archive is present in this checkout.  The source fragment
for this packet is therefore the task-owned operator equation recorded in
`tasks/QBE-MAIN-CASE-HIER-COLD-001.md` and synchronized in
`conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md`:

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The benchmark instance fixes one qubit each for `T`, `tau`, and passive `S`,
one clean signal qubit at value `0`, normalizer `1`, and exact error `0`.  The
system index is

$$
\operatorname{sys}(T,\tau,S) = 4T + 2\tau + S,
$$

and the full signal-system index is

$$
\operatorname{full}(b,T,\tau,S) = 8b + 4T + 2\tau + S.
$$

The current compiled Lean certificate is `mainCaseColdPartialPermVerified`.
The package leaf `MAIN-CANDIDATE-PACKAGE-001` is stale for new lower work:
`mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, and
`mainCaseColdPartialPermCandidate_cost` already compile.  The active frontier
is the post-Lean export leaf `MAIN-EXPORT-001`.

## Definitions Before Claims

Use named registers `T`, `tau`, `S`, and `signal` in prose and export manifests.
For finite-basis checking, use the Lean full-index convention
`8*signal + 4*T + 2*tau + S`.  Equivalently, the bit weights are
`S = 0`, `tau = 1`, `T = 2`, and `signal = 3`.  This distinction matters
because Qiskit display order and integer basis order are not the Lean
certificate.

Define the exported logical transcript by the five named gates

```text
X_T;
CCX_tau,T->signal;
X_tau;
CX_signal->T;
CX_tau->signal
```

with passive `S` untouched.  In Lean's `Gate` wire numbers this is the compiled
circuit

```lean
[ Gate.oneQubit "X" 2
, Gate.multiControlled [(1, true), (2, true)] (Gate.oneQubit "X" 3)
, Gate.oneQubit "X" 1
, Gate.cnot 3 2
, Gate.cnot 1 3
]
```

named `mainCaseColdCircuit`.

For a bit input `(b,T,tau,S)`, define the active exported map `F` by applying
the five gates left to right and leaving `S` fixed.  Over bits with addition
modulo two, the active output is

$$
F(b,T,\tau) =
\left(
1 + b + T\tau,\,
1 + T + b + \tau + T\tau,\,
1 + \tau
\right).
$$

This formula is not a replacement construction.  It is the hand-checkable
basis-action description of the already compiled COLD transcript.

## Local Proof

First apply `X_T`, so the time bit becomes `1 + T`.  The Toffoli has controls
`tau` and the updated time bit, so the signal bit becomes

$$
b_2 = b + \tau(1 + T).
$$

The gate `X_tau` changes the type bit to `1 + \tau`.  The CNOT from signal to
time changes the time bit to

$$
T_4 = 1 + T + b_2 = 1 + T + b + \tau + T\tau.
$$

The final CNOT from `tau` to signal uses the updated type bit and gives

$$
b_5 = b_2 + (1 + \tau) = 1 + b + T\tau.
$$

Thus the active output is the formula for `F` above.  Evaluating it on the
eight active inputs gives the reduced table already compiled as
`mainCaseColdCircuitReducedImage`, and Lean proves

```lean
theorem mainCaseColdCircuitImage_eq_partialPermImage :
    forall x : Fin 16,
      mainCaseColdCircuitImage x = mainCaseColdPartialPermImage x
```

after lifting by the identity on `S`.

For clean-block verification, set `b = 0`.  The exported output has clean
signal exactly when

$$
1 + T\tau = 0,
$$

which over bits means `T = 1` and `tau = 1`.  In that case the system output is
`(T,tau,S) = (0,0,S)`.  Hence the only nonzero clean-block entries are

$$
(\operatorname{sys}(0,0,0),\operatorname{sys}(1,1,0)) = (0,6)
$$

and

$$
(\operatorname{sys}(0,0,1),\operatorname{sys}(1,1,1)) = (1,7).
$$

This is exactly `mainCaseColdTarget`, already proved by
`mainCaseColdPartialPerm_blockProjection` and packaged in
`mainCaseColdPartialPermVerified`.

Therefore an export verifier should not attempt a new theorem.  It should
check that the generated Qiskit and QASM3 basis action equals
`mainCaseColdPartialPermImage` on all 16 inputs, then check the clean support,
passive `S`, normalizer, exact error, and resource tuple against the compiled
COLD declarations.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration or artifact | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Fixed operator, register order, clean signal, normalizer, and exact error. | task packet | previous lower | `mainCaseColdTarget`, `mainCaseColdQueryTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CAND-IMAGE-001` | COLD finite permutation table on `Fin 16`. | `MAIN-SOURCE-001` | previous lower | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CLEAN-ENTRY-001` | Clean block equals `E_1`. | `MAIN-CAND-IMAGE-001` | previous lower | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPerm_clean_eq_target` | conversion window | `python3 tools/qbe.py check` | proved and retired |
| `MAIN-PERM-UNITARY-001` | Finite image is a bijection at the finite-permutation semantic tier. | `MAIN-CAND-IMAGE-001` | previous lower | `mainCaseColdPartialPermImage_bijective` | verifier feedback | `python3 tools/qbe.py check` | proved and retired |
| `MAIN-BLOCK-PROJECTION-001` | Project-local block projection predicate holds. | `MAIN-CLEAN-ENTRY-001`, `MAIN-PERM-UNITARY-001` | previous lower | `mainCaseColdPartialPerm_blockProjection` | conversion window | `python3 tools/qbe.py check` | proved and retired |
| `MAIN-RESOURCE-001` | Circuit transcript implements the table and has cost `(5,5,1,0)`. | `MAIN-BLOCK-PROJECTION-001` | previous lower | `mainCaseColdCircuit`, `mainCaseColdSchedule`, `mainCaseColdCircuitImage_eq_partialPermImage`, `mainCaseColdPartialPermCost_*` | candidate population | project gate | proved and retired |
| `MAIN-CANDIDATE-PACKAGE-001` | Package the COLD candidate and verified block-encoding certificate. | `MAIN-BLOCK-PROJECTION-001`, `MAIN-RESOURCE-001` | previous lower | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, `mainCaseColdPartialPermCandidate_cost` | proof obligations | project gate | proved; stale as a lower target |
| `MAIN-EXPORT-MAP-001` | Write export manifest fields from the named Lean certificate. | `MAIN-CANDIDATE-PACKAGE-001` | lower export worker | `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/export-plan.md` plus manifest | this packet | export checker plus project gate | active |
| `MAIN-EXPORT-IMPLEMENT-001` | Generate Qiskit and QASM3 artifacts for the certified transcript only. | `MAIN-EXPORT-MAP-001` | lower export worker | `qiskit/`, `qasm3/` artifacts | export plan | export checker plus project gate | pending |
| `MAIN-EXPORT-VERIFY-001` | Check basis action, clean support, passive `S`, normalizer, exact error, resource tuple, and no Pro-arm evidence. | `MAIN-EXPORT-IMPLEMENT-001` | lower verifier | verifier feedback packet | this packet | export checker plus project gate | pending |

The next active implementation leaf is `MAIN-EXPORT-MAP-001` or
`MAIN-EXPORT-IMPLEMENT-001`, depending on whether a manifest already exists.
There is no active Lean-proof leaf for a Lean-focused worker.  If assigned to
Lean, the correct action is to report `MAIN-CANDIDATE-PACKAGE-001` as stale
and avoid editing `QuantumBlockEncoding/MainCase.lean`.

## Ordered Lean Dependencies And Reuse

1. Reuse `mainCaseColdSystemIndex` and `mainCaseColdTarget` for the target
   support `(0,6)` and `(1,7)`.
2. Reuse `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, and
   `mainCaseColdCleanSignal` for export metadata.
3. Reuse `mainCaseColdPartialPermImage` as the reference full basis action.
4. Reuse `mainCaseColdCircuit`, `mainCaseColdSchedule`, and
   `mainCaseColdCircuitImage_eq_partialPermImage` as the transcript-to-table
   bridge.
5. Reuse `mainCaseColdPartialPermImage_bijective` for the finite-permutation
   semantic tier.  Do not claim a new rational-orthogonality theorem.
6. Reuse `mainCaseColdPartialPerm_blockProjection` for the clean-block
   equality.
7. Reuse `mainCaseColdPartialPermCost_*` and
   `mainCaseColdPartialPermCandidate_cost` for the resource tuple
   `(5,5,1,0)`.
8. Reuse `mainCaseColdPartialPermVerified` as the single Lean certificate named
   by the export manifest.

No new Lean lemma is needed for `MAIN-EXPORT-001`.  A later Lean worker should
add code only if the project introduces an explicit export-semantics record.
Until then, export verification belongs in executable checks and typed
verifier feedback.

## Failure Analysis

The mathematical target is consistent and already Lean-closed at the current
finite-permutation semantic tier.  The stale target is the older package leaf:
`MAIN-CANDIDATE-PACKAGE-001` has already closed locally.  Reopening it would be
a `stale_leaf` failure unless one of the compiled COLD declarations changes.

The export route can still fail in narrow, useful ways:

| Symptom | Error class | Repair route |
|---|---|---|
| Qiskit or QASM3 action disagrees with `mainCaseColdPartialPermImage` | `shape_or_register_gap` | fix export endianness or wire mapping, not the Lean target |
| Clean support is not exactly `(0,6),(1,7)` | `finite_matrix_counterexample` | reject the export transcript and regenerate from `mainCaseColdCircuit` |
| Export artifact cites `mainCasePro*` or previous Qiskit/QASM files as evidence | `invalid_route` | delete that evidence path and cite `mainCaseColdPartialPermVerified` only |
| Resource tuple differs from `(5,5,1,0)` | `source_translation_gap` | repair the manifest/checker; do not change `mainCaseColdPartialPermCandidate_cost` |
| Verifier lacks deterministic basis-action checking | `external_contract_gap` | add a backend-free basis-action function before review |

LCU, QSVT, sparse access, dilation, approximate search, and target mutation are
not repair routes for this leaf.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAIN-CANDIDATE-PACKAGE-001` as the stale prompt leaf; `MAIN-EXPORT-001` as the active frontier |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true`; no Lean edits in this packet |
| `lean_build_ok` | `true`; `python3 tools/qbe.py check` and `lake build && lake build Tests` passed after this Markdown-only packet |
| `finite_matrix_ok` | `true` for the compiled Lean table; export artifacts still pending |
| `block_entry_ok` | `true` by `mainCaseColdPartialPerm_blockProjection` |
| `ancilla_cleanup_ok` | `true` at the clean-block support level; no additional export ancilla |
| `normalizer_ok` | `true`, alpha is `1` |
| `unitarity_ok` | `true` at finite-permutation tier by `mainCaseColdPartialPermImage_bijective` |
| `resource_score` | `(5,5,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `5` |
| `depth` | `5` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` for the COLD Lean certificate; `false` for export verification because it is post-Lean artifact checking |
| `error_class` | `stale_leaf` for reopening `MAIN-CANDIDATE-PACKAGE-001`; `null` for the active export design |
| `next_route` | Generate Qiskit/QASM3 artifacts under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`, then run a deterministic export verifier against `mainCaseColdPartialPermImage` and the project gate. |

## Handoff

`MAIN-CANDIDATE-PACKAGE-001` is closed and should stay retired.  The export
worker should consume `mainCaseColdPartialPermVerified`,
`mainCaseColdCircuitImage_eq_partialPermImage`, and
`mainCaseColdPartialPermCandidate_cost`; generate only the certified transcript;
and verify basis action with the Lean index convention
`8*signal + 4*T + 2*tau + S`.
