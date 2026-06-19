# Verifier Comparison: QBE-OP-OPTCTRL-001

This report compares verifier layers on the concrete main-case operator
`E_1 = |0><1|_time tensor |0><1|_type tensor I_state`.

Important interpretation:

- NumPy and Qiskit `Operator` checks are complete for this finite 4-qubit
  matrix instance when the circuit and target are both fully instantiated;
  Qiskit is compared with a `1e-12` numerical tolerance.
- QASM-Eval-style distribution/timeline/pulse checks are not used here;
  those checks are useful diagnostics but are not general proof closure for
  ABEIS block-encoding theorems.
- Lean remains the final repository acceptance gate because it stores the
  reusable theorem, definitions, resource tuple, and future dependencies.

| Verifier | Semantic level | Status | Median ms | Complete for this case | Final gate |
| --- | --- | --- | ---: | --- | --- |
| `numpy_exact_matrix` | exact finite matrix check | passed | 0.026 | True | False |
| `qiskit_operator` | exact finite Qiskit Operator check | passed | 0.462 | True | False |
| `lean_lake_build_tests` | formal theorem/proof gate | passed | 617.217 | True | True |

## What this does not measure

The table above measures only checker wall time.  It does not measure the
time or tokens needed for an AI agent to write the candidate Qiskit code,
write the Lean declarations and proofs, repair failures, or coordinate
multiple agents.  A fair harness comparison needs three layers:

1. checker time: parser/simulator/Lean build time;
2. artifact-production time: agent wall time to write and repair code;
3. token throughput: input, output, and total tokens per accepted candidate.

ABEIS records checker time here.  Route-total ablations are recorded
separately under `reports/route-ablation/QBE-OP-OPTCTRL-001/` because
they include AI writing, repair, coordination, and model-wrapper token
accounting where available.  The current route-total rows compare a
Qiskit-only agent route, a Lean-only agent route, and an ABEIS
multi-agent route on the same target.

The timing plot is generated at `docs/assets/verifier_time_comparison.png`.
Treat the plot as verification wall-clock evidence, not as a token-cost
measurement of the multi-agent harness.
