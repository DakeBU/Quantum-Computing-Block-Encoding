# QBE-OP-OPTCTRL-001 Comparison Status

This status file separates checker speed, route-total agent time, and semantic
strength.  They answer different questions and should not be mixed.

## 1. External repositories are locally available

The following systems are surveyed by
`tools/compare_external_quantum_verifiers.py`:

| System | Local route | Current status on ABEIS main case |
| --- | --- | --- |
| Qiskit-QuantumKatas | custom Python/Qiskit kata evaluator | runnable same finite BE task |
| QASM-Eval | OpenQASM completion evaluator | runnable same gate transcript parser/distribution check, not clean-block BE proof |
| QUASAR | tool-server / hierarchical reward design | repository has no runnable local code yet |
| AI-Mandel | staged idea-to-tool workflow | Python compile check only, not a BE verifier |

The latest measured table is
`reports/external-quantum-verifier-comparison/latest.md`.

## 2. Finished-artifact checker baselines

`tools/run_route_ablation.py reference_qiskit` and
`tools/run_route_ablation.py reference_lean` measure only verifier/checker
time for known-correct artifacts.  They do not include AI writing, repair,
coordination, or token cost.

The latest checker rows are included in
`reports/route-ablation/QBE-OP-OPTCTRL-001/latest_results.md`.

## 3. Completed route-total ablation

The same target was sent through three Codex route-total paths:

| Route | Status | Agent/harness time | Checker time | Semantic level |
| --- | --- | ---: | ---: | --- |
| qiskit-only | passed | 306.741 s | 9.230 s | finite executable artifact |
| direct Lean | passed | 356.285 s | 0.610 s | Lean theorem route |
| ABEIS multi-agent | passed | 851.374 s | 0.607 s | Lean-certified ABEIS route |

The ABEIS row used real parallel lower-agent execution:

```text
parallel_lower_used = true
lower_count = 3
parallel_claim_valid = true
```

This validates the harness path, but it does not show that the current Codex
profile is time-optimal.  The run logs show that short upper/middle/reviewer
roles wrote their handoff files quickly but then produced large Codex CLI logs
and spent significant wall time in process cleanup.  The next harness
optimization should make short coordination roles deterministic or use a
low-token profile, reserving expensive model calls for lower proof/circuit
construction.

## 4. Harness self-test

The deterministic helper
`tools/route_ablation_agents/write_qiskit_reference.py` writes a complete
Python/Qiskit artifact to `QBE_ROUTE_ARTIFACT`.  The runner then executes that
file.  This proves that the qiskit-only route requires a real executable
artifact rather than a printed code snippet.

This is labelled `harness-selftest`, not `agent-route-total`.

## 5. Scaling evidence for why Lean matters

The hard-scaling forecast
`reports/verifier-comparison/QBE-OP-OPTCTRL-001/hard_scaling_forecast.md`
shows that dense Qiskit/NumPy unitary verification becomes a memory bottleneck
for larger members of the same block-encoding family.  This supports the
division of labor:

- finite executable checks for small instances, fixed-instance checks, and
  counterexamples;
- Lean theorem closure for reusable large-register block-encoding claims.
