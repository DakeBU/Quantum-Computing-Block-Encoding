# Middle Source Contract: QBE-MAIN-CASE-HIER-COLD-001 Cycle 3

Status update: this packet has been implemented.  The declarations
`mainCaseColdQueryTarget`, `mainCaseColdBlockProjection`, and
`mainCaseColdPartialPerm_blockProjection` now compile.  New lower work should
use
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-lower-packets-cycle03-main-resource.md`
and target `MAIN-RESOURCE-001`.

## Source Anchor

The source object is the task-owned operator contract:

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The benchmark instance has one qubit each for `T`, `tau`, and `S`, with system
flattening `4*T + 2*tau + S`.  The clean signal qubit is `0`, the normalizer is
`1`, and the exact error target is `0`.  No local paper-source archive exists
for this task, and no cited external theorem is active for this packet.

## Compiled Dependencies

| Role | Lean declaration | Status |
|---|---|---|
| system flattening | `mainCaseColdSystemIndex` | compiled |
| target matrix | `mainCaseColdTarget` | compiled |
| clean signal and embedding | `mainCaseColdCleanSignal`, `mainCaseColdCleanEmbed` | compiled |
| candidate image and matrix | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | compiled |
| clean-entry theorem | `mainCaseColdPartialPerm_entry` | proved |
| exact clean-block certificate | `mainCaseColdPartialPermExactCleanBlock` | compiled |
| clean block equals target | `mainCaseColdPartialPerm_clean_eq_target` | proved |
| finite bijection | `mainCaseColdPartialPermImage_bijective` | proved |

## Active Leaf

Leaf id: `MAIN-BLOCK-PROJECTION-001`.

Target file: `QuantumBlockEncoding/MainCase.lean`.

Allowed write scope: add task-local `mainCaseCold*` declarations only.  Do not
refer to `mainCasePro*` as a certificate, do not copy previous task-specific
candidate names, and do not add Qiskit/QASM exports.

Required declarations:

```lean
def mainCaseColdQueryTarget : QueryOperatorTarget Rat 8 8

def mainCaseColdBlockProjection
    (U : Matrix (2 * 8) (2 * 8) Rat) : Prop :=
  Matrix.PointwiseEq
    (signalSystemBlockProjection 2 8 8 U mainCaseColdCleanSignal)
    mainCaseColdTarget

theorem mainCaseColdPartialPerm_blockProjection :
    mainCaseColdBlockProjection mainCaseColdPartialPermMatrix
```

Optional declaration if it is useful for the next resource leaf:

```lean
def mainCaseColdSourceLayout : RegisterLayout
```

The proof of `mainCaseColdPartialPerm_blockProjection` may use finite entry
calculation over `Fin 8`, `signalSystemBlockProjection`,
`signalSystemBlockRowIndex`, `signalSystemBlockColIndex`,
`mainCaseColdPartialPermMatrix`, `BlockEncodingClassics.permMatrix`,
`mainCaseColdPartialPermImage`, and `mainCaseColdTarget`.

## Not This Leaf

Do not add `mainCaseColdPartialPermCandidate` or
`mainCaseColdPartialPermVerified` unless the same patch also supplies an honest
task-local circuit/resource schema and cost field theorems.  The current
`Resource` interface has concrete `Nat` gate and depth fields, so a fabricated
zero-cost or unknown-cost resource record is contract drift.

Do not schedule executable export.  Qiskit/QASM3 export remains blocked until a
named COLD Lean certificate states the block predicate, finite-permutation or
unitarity witness, and resource tuple.

## Feedback Fields

Lower 2 should run `python3 tools/qbe.py check` and log typed feedback with:

`leaf=MAIN-BLOCK-PROJECTION-001`,
`source_correspondence_ok`,
`lean_parse_ok`,
`lean_build_ok`,
`finite_matrix_ok`,
`block_entry_ok`,
`ancilla_cleanup_ok`,
`normalizer_ok`,
`unitarity_ok`,
`resource_score`,
`auxiliary_qubits`,
`gate_count`,
`depth`,
`oracle_calls`,
`closed_theorem_ok`,
`error_class`,
and `next_route`.

Expected next route after success: `MAIN-RESOURCE-001`.
