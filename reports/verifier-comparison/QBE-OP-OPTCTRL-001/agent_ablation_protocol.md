# Controlled Agent Ablation Protocol

The verifier timing plot answers only one question: how long does a finished
artifact take to check?  It does not answer whether agents write Qiskit,
Lean, or ABEIS artifacts faster.  That requires a controlled ablation.

Run the same operator target through three routes with the same model, budget,
and prompt envelope:

1. `qiskit_operator_route`: ask the agent to produce Qiskit code and a
   `qiskit.quantum_info.Operator` equality check for the finite instance.
2. `lean_route`: ask the agent to produce the Lean declarations and proofs
   directly, without ABEIS multi-agent memory or candidate populations.
3. `abeis_multi_agent_route`: use the full upper/middle/lower/reviewer
   harness with candidate population, typed verifier feedback, and Lean gate.

For each route, record:

- artifact-production wall time: agent runtime from prompt dispatch to final
  accepted artifact;
- checker/compile wall time: parser, simulator, Qiskit Operator, `lake build`,
  or equivalent verifier time;
- input tokens, output tokens, total tokens, and number of repair iterations;
- final semantic level: finite executable check, Lean concrete theorem, or
  Lean parametric theorem;
- whether the result is reusable as a future dependency.

Do not compare Qiskit checker time against Lean total agent time.  The fair
comparison is route-total time and tokens, with checker time reported as a
separate component.
