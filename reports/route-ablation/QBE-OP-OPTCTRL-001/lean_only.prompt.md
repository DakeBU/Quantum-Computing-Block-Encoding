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

Write or repair Lean declarations for the same target directly, without using
ABEIS candidate-population or multi-agent memory.  The final artifact must be a
named Lean theorem proving the clean-block equality and a named declaration for
the resource tuple.

Do not use `sorry`, `axiom`, hidden constants, or an oracle assumption.  Report
which Lean declarations compile and which checker command was used.

If this prompt is run by `tools/run_route_ablation.py`, the environment
variable `QBE_ABLATION_RUN_DIR` names the run directory.  Write any route notes
there, but committed Lean changes must still be checked by `lake build Tests`.
