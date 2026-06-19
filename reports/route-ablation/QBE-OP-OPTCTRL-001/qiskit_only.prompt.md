# Controlled route ablation target: QBE-OP-OPTCTRL-001

Target operator:

```text
E_1 = |0><1|_time tensor |0><1|_type tensor I_state
```

Concrete register convention:

- state bit: bit 0;
- type bit: bit 1;
- time bit: bit 2;
- block-encoding auxiliary bit: bit 3;
- clean block is the top-left block where the auxiliary input and output are 0.

Expected target block:

```text
target[0, 6] = 1
target[1, 7] = 1
all other 8 x 8 entries are 0
```

Candidate circuit used by the current ABEIS champion:

```text
CCX(type, time -> aux);
X(type);
X(time);
X(aux)
```

Resource tuple order:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

The first comparison is semantic acceptance.  The second comparison is route
cost: agent wall time, checker time, exact provider tokens, repair iterations,
and final semantic level.

## Route

Write a self-contained Python/Qiskit artifact that defines:

```python
def build_circuit():
    ...
```

Then verify with `qiskit.quantum_info.Operator` that the clean auxiliary block
equals the target block above, using tolerance `1e-12`.

If this prompt is run by `tools/run_route_ablation.py`, write the complete
executable Python artifact to the path in the environment variable
`QBE_ROUTE_ARTIFACT`.  The default checker will run that file.

Do not mention Lean.  Do not assume a hidden oracle.  Report the circuit, the
checker code, the resource tuple, and any limitations.
