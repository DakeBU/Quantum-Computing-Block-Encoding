# Competitor Protocol: Cubic State-Preparation Benchmark

Task: `QBE-OP-CUBIC-STATEPREP-001`

## Environment Note

The executable environment should use the repository virtual environment:

```text
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements-executable.txt
```

with Qiskit installed.  This means Qiskit-based finite checks are runnable when
the optional executable dependencies are installed.  The report still must not claim that Qiskit, QASM-Eval, QUASAR,
QuantumKatas, or AI-Mandel fails on this benchmark until each route is run with
the shared prompt and metric protocol below.

## Shared Prompt

```text
For positive integer n, let N = 2^n and x_j = j/N.  Construct a block
encoding for the rank-one operator O_n = |v><0^n| where v_j = x_j^3.
The requested approximation tolerance is epsilon = 1e-10.

Report:
1. the candidate circuit/unitary family;
2. whether the target is normalized or block-encoded with alpha;
3. gate count, depth, auxiliary qubits, and oracle calls;
4. what verifier was used;
5. whether the claim is only for a fixed small n or for symbolic n.
```

## Metrics

| Metric | ABEIS route | Executable-circuit route |
|---|---|---|
| candidate construction time | agent wall-clock and tokens until Lean target/candidate appears | agent wall-clock and tokens until Qiskit/QASM/etc. code appears |
| verifier time | Lean build time for named theorem or target declaration | simulator/parser/test time for produced code |
| scale target | symbolic family in `n` | fixed small instance unless the system proves a family |
| acceptance | Lean certificate at advertised tier | own verifier pass; if no Lean theorem, record as executable evidence only |

## Current Status

ABEIS has initialized the target in Lean and generated scaling diagnostics.
No final approximate block-encoding candidate has been certified yet.

The first fair executable comparison has now been run locally.  See
`external_comparison.md` and `external_comparison_scaling.png`.  The result is:
finite dense Qiskit/QuantumKatas-style checks can validate small instances of
the same cubic target, but those checks materialize dense matrices and do not
produce a symbolic theorem for arbitrary `n`.  The next ABEIS work remains the
symbolic Scenario 2 route: norm/normalizer bridge, approximate arithmetic
synthesis, candidate unitary transcript, and Lean block-entry theorem.
