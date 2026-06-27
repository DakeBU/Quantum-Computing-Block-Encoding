# Middle Source Contract: MAIN-EXPORT-MAP-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02`

## Source Anchor

The source anchor is the task-owned operator contract in
`tasks/QBE-MAIN-CASE-HIER-COLD-001.md`.  No local paper-source archive is
available for this task.

The object being translated for export is the concrete transfer operator

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The benchmark instance fixes `r=1`, `k=1`, one passive `S` qubit, one clean
signal qubit at `0`, normalizer `1`, exact error `0`, and system register order
`(T,tau,S)`.

## Lean Source

The named Lean certificate for export is:

```lean
def mainCaseColdPartialPermVerified :
    VerifiedOperatorBlockEncoding Rat 3

theorem mainCaseColdPartialPermCandidate_cost :
    mainCaseColdPartialPermCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 5, depth := 5, oracleCalls := 0 }
```

The export must also cite:

| Role | Lean declaration |
|---|---|
| target matrix | `mainCaseColdTarget` |
| finite image table | `mainCaseColdPartialPermImage` |
| circuit transcript | `mainCaseColdCircuit`, `mainCaseColdSchedule` |
| transcript-to-table bridge | `mainCaseColdCircuitImage_eq_partialPermImage` |
| clean projector | `mainCaseColdBlockProjection`, `mainCaseColdCleanSignal` |
| normalizer and exact error | `mainCaseColdExactNormalizer`, `mainCaseColdExactError` |
| resource tuple | `mainCaseColdPartialPermCost_*`, `mainCaseColdPartialPermCandidate_cost` |

## Register Contract

The Lean system index is

```text
4*T + 2*tau + S
```

and the Lean full index is

```text
8*signal + 4*T + 2*tau + S
```

Therefore executable integer bit weights are:

| Source register | Lean bit weight | Qiskit qubit |
|---|---:|---|
| `S` | `0` | `q[0]` |
| `tau` | `1` | `q[1]` |
| `T` | `2` | `q[2]` |
| `signal` | `3` | `q[3]` |

The stale map `T=0`, `tau=1`, `S=2`, `signal=3` is retired.  It is not a valid
source for generated artifacts.

## Export Transcript

The exported circuit must implement exactly:

```text
X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal
```

For Qiskit with the qubit list `[S, tau, T, signal]`, this is:

```text
x(q[2]);
ccx(q[1], q[2], q[3]);
x(q[1]);
cx(q[3], q[2]);
cx(q[1], q[3]);
```

The passive `S` qubit must be present and untouched.

## Ownership

| Item | Owner class | Status |
|---|---|---|
| `E_1`, register order, clean signal, normalizer, exact error | active user/operator target | fixed; do not mutate |
| `mainCaseColdPartialPermVerified` and cost theorem | compiled COLD Lean certificate | source for export |
| executable wire map and manifest fields | QBE-local semantic glue | repaired in this packet |
| Qiskit/QASM3 code and generated manifest | post-Lean export artifacts | pending lower implementation |
| external cited theorem or paper primitive | external contract | none needed |

## Lower-Facing Contract

Lower export work should target `MAIN-EXPORT-IMPLEMENT-001` next.

Allowed write scope:

- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/`
- `runs/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02/`

Do not edit `QuantumBlockEncoding/MainCase.lean` unless deterministic export
verification exposes a mismatch in the compiled COLD declarations.  Do not use
`mainCasePro*` declarations or previous Qiskit/QASM exports as evidence.

The export verifier must check the generated basis action against
`mainCaseColdPartialPermImage` on all 16 basis states, clean-block support
`(0,6)` and `(1,7)`, passive `S`, normalizer `1`, exact error `0`, resource
tuple `(5,5,1,0)`, QASM3 parser acceptance, and absence of Pro-arm evidence.

Required gate after generated files:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```
