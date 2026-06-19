# Route-Ablation Results

| Run | Route | Evidence | Status | Agent s | Checker s | Accepted | Parallel audit | Semantic level |
| --- | --- | --- | --- | ---: | ---: | --- | --- | --- |
| `20260619-015443-reference_qiskit` | `reference_qiskit` | checker-baseline | passed |  | 0.311 | True | n/a | finite Qiskit Operator equality |
| `20260619-015443-reference_lean` | `reference_lean` | checker-baseline | passed |  | 0.606 | True | n/a | Lean existing Tests gate |
| `20260619-020250-reference_qiskit` | `reference_qiskit` | checker-baseline | passed |  | 0.314 | True | n/a | finite Qiskit Operator equality |
| `20260619-020250-reference_lean` | `reference_lean` | checker-baseline | passed |  | 0.621 | True | n/a | Lean existing Tests gate |
| `20260619-021051-reference_qiskit` | `reference_qiskit` | checker-baseline | passed |  | 0.473 | True | n/a | finite Qiskit Operator equality |
| `20260619-021051-reference_lean` | `reference_lean` | checker-baseline | passed |  | 0.663 | True | n/a | Lean existing Tests gate |
| `20260619-021354-qiskit_only` | `qiskit_only` | harness-selftest | passed | 0.028 | 0.307 | True | n/a | finite executable artifact, checker supplied by route |
| `20260619-021737-qiskit_only` | `qiskit_only` | agent-route-total | passed | 306.741 | 9.230 | True | n/a | finite executable artifact, checker supplied by route |
| `20260619-022322-lean_only` | `lean_only` | agent-route-total | passed | 356.285 | 0.610 | True | n/a | direct Lean theorem route |
| `20260619-025308-abeis_multi_agent` | `abeis_multi_agent` | agent-route-total | passed | 851.374 | 0.607 | True | used=True, lower_count=3, valid=True | Lean-certified ABEIS candidate population route |

Evidence levels:

- `checker-baseline`: finished-artifact verifier timing only; no AI writing
  or repair time is measured.
- `harness-selftest`: deterministic local script proving that the runner
  enforces executable artifacts; not an AI route-total comparison.
- `agent-route-total`: real model route with prompt dispatch, artifact
  production, checker time, and token accounting where available.

AI route-total runs must use the same prompt envelope and model budget,
and exact provider tokens must be filled from the model wrapper when
available.
