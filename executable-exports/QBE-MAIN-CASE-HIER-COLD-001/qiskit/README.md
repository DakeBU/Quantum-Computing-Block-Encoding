# Qiskit Export: QBE-MAIN-CASE-HIER-COLD-001

Lean source declaration:
`QuantumBlockEncoding.MainCase.mainCaseColdPartialPermVerified`.

Concrete instance: `r=1`, `k=1`, and one passive `S` qubit.

Wire order for Qiskit integer-basis checks:

| Qiskit qubit | Register |
|---|---|
| `q[0]` | `S` |
| `q[1]` | `tau` |
| `q[2]` | `T` |
| `q[3]` | `signal` |

The exported transcript is:

```text
x(q[2]);
ccx(q[1], q[2], q[3]);
x(q[1]);
cx(q[3], q[2]);
cx(q[1], q[3]);
```

Check command:

```bash
python3 executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/export.py --json
```

The deterministic basis action is checked against the Lean convention
`8*signal + 4*T + 2*tau + S`.  This executable artifact is a post-Lean export
check, not a replacement for the Lean theorem.
