# External Quantum Verifier/Harness Comparison

This report compares locally downloaded external quantum-code systems against
the ABEIS main transfer-operator task.  It separates two questions:

1. Can the external repository directly check the same finite block-encoding
   artifact?
2. If not, what harness or feedback idea is still comparable?

| System | Same finite BE task? | Status | Median ms | Semantic level | Role in fair comparison |
| --- | --- | --- | ---: | --- | --- |
| Qiskit-QuantumKatas | True | passed | 249.655 | finite Qiskit Operator block equality inside Python test | Runnable executable-code route for the same finite E_1 task; useful for artifact-route ablation, not a reusable Lean theorem. |
| QASM-Eval | False | passed | 737.980 | syntax/element/distribution/timeline evaluator; the quick check target is the same gate transcript but not block-entry equality over all basis states | Typed executable feedback and pass@k protocol; not directly a BE theorem verifier. |
| QUASAR | False | not-runnable |  | not available locally | Harness/reward-design comparison only until runnable code is available. |
| AI-Mandel | False | passed | 10.238 | script compile check only; PyTheus execution is not a BE verifier | Research-loop and expert-tool staging comparison; not a direct circuit verifier for E_1. |

Interpretation:

- Qiskit-QuantumKatas is the closest direct executable-code route.  We can
  formulate the ABEIS `E_1` target as a kata-style Python/Qiskit task and
  check it with a deterministic `Operator` assertion.
- QASM-Eval is valuable for typed syntax, element, distribution, and timeline
  feedback.  Its released evaluator is not a block-entry verifier over all
  basis states.  If the matching `openqasm3` parser stack is available,
  the local quick executable route checks the same gate transcript through
  QASM-Eval's distribution-style policy; otherwise it is recorded as
  `blocked-env` rather than counted as a pass.
- QUASAR's local repository does not yet expose runnable code, so it can only
  be compared at the harness-design level for now.
- AI-Mandel is a multi-agent idea-to-tool loop for quantum-physics discovery.
  It is relevant to staging and external-tool execution, not as a direct BE
  verifier for this task.

A first route-total experiment has now run the same target through
Qiskit-only, direct-Lean, and ABEIS multi-agent harnesses.  See
`reports/route-ablation/QBE-OP-OPTCTRL-001/latest_results.md`.  Exact
provider token counts remain wrapper-dependent; the current report
records wall time, checker time, token proxies, semantic level, and
whether ABEIS used real parallel lower agents.
