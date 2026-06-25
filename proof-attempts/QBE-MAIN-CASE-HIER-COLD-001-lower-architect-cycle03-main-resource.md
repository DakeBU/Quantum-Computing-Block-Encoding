# Lower Architect Packet: QBE-MAIN-CASE-HIER-COLD-001 Cycle 3 MAIN-RESOURCE-001

## Source Fragment

No local paper-source archive is available for this task.  The source fragment
translated here is the task-owned operator contract plus the COLD image table
in `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md`.

The fixed operator is

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The benchmark has one clean signal qubit `b`, active system qubits `T` and
`tau`, and one passive qubit `S`.  The full basis index is
`8*b + 4*T + 2*tau + S`.  The COLD finite completion to realize is

| input active bits `(b,T,tau)` | output active bits `(b,T,tau)` |
|---|---|
| `000` | `111` |
| `001` | `100` |
| `010` | `101` |
| `011` | `000` |
| `100` | `001` |
| `101` | `010` |
| `110` | `011` |
| `111` | `110` |

The passive bit `S` is unchanged.  On full flattened indices this is exactly
`mainCaseColdPartialPermImage`.

## Definitions Before Claims

Use wire order `0 = signal b`, `1 = T`, `2 = tau`, and `3 = S`.  The passive
wire `S` is not acted on.

Define the COLD logical circuit schema by the following in-place reversible
gates:

1. `X` on signal `b`;
2. Toffoli with controls `T = 1` and `tau = 1`, target signal `b`;
3. CNOT with control `tau`, target `T`;
4. CNOT with control signal `b`, target `T`;
5. `X` on `tau`.

The sequential circuit is

```lean
[ Gate.oneQubit "X" 0
, Gate.multiControlled [(1, true), (2, true)] (Gate.oneQubit "X" 0)
, Gate.cnot 2 1
, Gate.cnot 0 1
, Gate.oneQubit "X" 2
]
```

The logical schedule can place the last two gates in one layer:

```lean
[ [Gate.oneQubit "X" 0]
, [Gate.multiControlled [(1, true), (2, true)] (Gate.oneQubit "X" 0)]
, [Gate.cnot 2 1]
, [Gate.cnot 0 1, Gate.oneQubit "X" 2]
]
```

The resource convention is the logical reversible gate library
`{X,CNOT,Toffoli}`.  The current `Resource` record has no Toffoli field, so this
packet stores the one logical Toffoli in the `cnot` bucket for this tier.  The
proposed resource is

```lean
Resource.ofCountsWithDepth 2 3 0 0 4
```

This gives score tuple `(gateCount, depth, auxiliaryQubits, oracleCalls) =
(5, 4, 1, 0)` after applying
`BlockEncodingCost.fromLayoutAndResource mainCaseColdSourceLayout`.

## Local Proof

Let the input active bits be `(b,t,u)`, where `u` is the `tau` bit.  All
arithmetic below is over bits with XOR written as `+` modulo two and ordinary
AND written by juxtaposition.

After the first gate and the Toffoli, the signal bit is

$$
b_2 = 1 + b + t u.
$$

The third gate changes the time bit to

$$
t_3 = t + u.
$$

The fourth gate uses the already-updated signal bit and changes the time bit
to

$$
t_4 = t + u + b_2 = 1 + b + t + u + t u.
$$

The last gate changes the type bit to

$$
u_5 = 1 + u.
$$

The final active output is therefore

$$
(b',T',\tau') =
(1 + b + T\tau,\; 1 + b + T + \tau + T\tau,\; 1 + \tau).
$$

Evaluating this expression on all eight active inputs gives the COLD table
above.  Since the circuit never touches `S`, lifting the active permutation by
the identity on `S` gives the full `Fin 16` table
`mainCaseColdPartialPermImage`.

The clean-block theorem already proved in Lean then applies without changing
the target: the only clean input columns that remain in the clean signal block
are `(b,T,tau,S) = (0,1,1,S)`, and they map to `(0,0,0,S)`.  This gives the
nonzero system entries `(0,6)` and `(1,7)`, which are exactly
`mainCaseColdTarget`.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Fixed target `E_1`, clean signal, normalizer, and exact error. | task packet | previous lower | `mainCaseColdTarget`, `mainCaseColdQueryTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CAND-IMAGE-001` | COLD finite permutation table. | `MAIN-SOURCE-001` | previous lower | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CLEAN-ENTRY-001` | Clean block equals target. | `MAIN-CAND-IMAGE-001` | previous lower | `mainCaseColdPartialPerm_clean_eq_target` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-PERM-UNITARY-001` | Finite image is bijective. | `MAIN-CAND-IMAGE-001` | previous lower | `mainCaseColdPartialPermImage_bijective` | verifier feedback | `python3 tools/qbe.py check` | proved at finite-permutation tier |
| `MAIN-BLOCK-PROJECTION-001` | Project-local block projection predicate holds. | `MAIN-CLEAN-ENTRY-001` | previous lower | `mainCaseColdPartialPerm_blockProjection` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-RESOURCE-SCHEMA-001` | Define COLD-local logical circuit, schedule, resource, cost, and cost field theorems. | this packet, `MAIN-BLOCK-PROJECTION-001` | next Lean lower | planned `mainCaseColdCircuit`, `mainCaseColdSchedule`, `mainCaseColdLogicalResource`, `mainCaseColdPartialPermCost_*` | this packet | `python3 tools/qbe.py check`; `lake build && lake build Tests` | next active leaf |
| `MAIN-CIRCUIT-IMAGE-001` | Prove the logical gate image equals `mainCaseColdPartialPermImage` on `Fin 16`. | `MAIN-RESOURCE-SCHEMA-001` | later Lean lower or verifier | planned `mainCaseColdGateImages_eval` | this packet | finite check plus build gate | ready after schema definitions |
| `MAIN-CANDIDATE-PACKAGE-001` | Package the candidate and verified certificate at the accepted semantic tier. | `MAIN-BLOCK-PROJECTION-001`, `MAIN-RESOURCE-SCHEMA-001`, optional `MAIN-CIRCUIT-IMAGE-001` | later lower/refiner | planned `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified` | proof-obligation ledger | build gate | blocked until resource field theorems compile |

The next active Lean leaf is `MAIN-RESOURCE-SCHEMA-001`.

## Ordered Lean Lemmas

1. Reuse `mainCaseColdSourceLayout_auxiliaryQubits`,
   `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix`,
   `mainCaseColdPartialPermImage_bijective`, and
   `mainCaseColdPartialPerm_blockProjection`.
2. Add `mainCaseColdCircuit : Circuit` using the five gates listed above.
3. Add `mainCaseColdSchedule : LayeredCircuit` using the four layers listed
   above.
4. Add `mainCaseColdLogicalResource : Resource :=
   Resource.ofCountsWithDepth 2 3 0 0 4`.
5. Add `mainCaseColdPartialPermCost : BlockEncodingCost :=
   BlockEncodingCost.fromLayoutAndResource
     mainCaseColdSourceLayout mainCaseColdLogicalResource`.
6. Prove field theorems:
   `mainCaseColdPartialPermCost_gateCount = 5`,
   `mainCaseColdPartialPermCost_depth = 4`,
   `mainCaseColdPartialPermCost_auxiliaryQubits = 1`, and
   `mainCaseColdPartialPermCost_oracleCalls = 0`.
7. Add a COLD-local finite gate-image evaluator only if the worker is ready to
   close `MAIN-CIRCUIT-IMAGE-001`.  The theorem statement should be:
   `∀ x : Fin 16, mainCaseColdEvalGateImages mainCaseColdGateImages x =
   mainCaseColdPartialPermImage x`.
8. Package `mainCaseColdPartialPermCandidate` and
   `mainCaseColdPartialPermVerified` only after the resource field theorems
   compile.  If the candidate uses the finite-permutation semantic tier for
   `isUnitary`, the record must say so by naming
   `mainCaseColdPartialPermImageIsPermutation`; do not claim rational
   orthogonality unless a separate matrix bridge is proved.

## Failure Analysis

The target is mathematically consistent.  A finite check of the proposed
five-gate schema against the COLD table passed for all active inputs and after
lifting by the passive identity on `S`.

The current blocker is not a counterexample.  The blocker is a
`symbolic_bridge_gap`: Lean does not yet contain the COLD-local circuit,
schedule, logical resource record, cost field theorems, or optional gate-image
equality for this schema.

Reject any implementation route that:

- changes `mainCaseColdTarget`, the clean signal value, the normalizer, or the
  passive identity on `S`;
- imports a previous Pro/cold-start/optimal-control candidate as the COLD
  certificate;
- advertises `oracleCalls = 0` while using an unresolved oracle gate;
- uses `Circuit.resource` for the `Gate.multiControlled` macro but still
  claims the logical tuple `(5,4,1,0)`;
- marks `mainCaseColdResourceSchemaObligation.proved = true` without compiled
  resource field theorems.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAIN-RESOURCE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` for existing Lean before this packet; no Lean edit in this attempt |
| `lean_build_ok` | `true`; `python3 tools/qbe.py check` and `lake build && lake build Tests` passed after the Markdown updates |
| `finite_matrix_ok` | `true` for the proposed active and full lifted image table |
| `block_entry_ok` | `true`, by reuse of `mainCaseColdPartialPerm_blockProjection` |
| `ancilla_cleanup_ok` | `true` at the clean-block support level already proved; no new ancilla is introduced by the logical schema |
| `normalizer_ok` | `true`, by `mainCaseColdQueryTarget_normalizer` and `alpha = 1` |
| `unitarity_ok` | `true` at finite-permutation tier by `mainCaseColdPartialPermImage_bijective`; rational-orthogonal matrix bridge remains deferred |
| `resource_score` | proposed logical tuple `(5,4,1,0)`, not yet Lean-certified |
| `auxiliary_qubits` | `1` |
| `gate_count` | `5` proposed |
| `depth` | `4` proposed |
| `oracle_calls` | `0` proposed |
| `closed_theorem_ok` | `false` for `MAIN-RESOURCE-001` until cost field theorems compile |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | Implement `MAIN-RESOURCE-SCHEMA-001` in `QuantumBlockEncoding/MainCase.lean`, then run `python3 tools/qbe.py check` and `lake build && lake build Tests`. |
