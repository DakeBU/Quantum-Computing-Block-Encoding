# Agentic theorem proving references, 2025--2026

Source directory:
`../outer_papers/automation_systems/agentic_theorem_proving_2026/`.

## References

| Key | Source | ABEIS counterpart design |
| --- | --- | --- |
| `hierarchical-provers-2602.10512` | [arXiv:2602.10512](https://arxiv.org/abs/2602.10512), also cited under the "Don't Eliminate Cut" framing | Keep reusable circuit-entry, register-map, normalizer, and cleanup lemmas as proof-DAG cuts; do not repeatedly inline them into every block-encoding theorem. |
| `statistical-provability-2602.10538` | [arXiv:2602.10538](https://arxiv.org/abs/2602.10538) | Track finite-budget proof progress: active time, verifier calls, average truncated proof length, stale repeated leaves, and high-reuse proof states. |
| `cpl-2509.14274` | [arXiv:2509.14274](https://arxiv.org/abs/2509.14274), [repo](https://github.com/auto-res/ConjecturingProvingLoop) | In exploratory oracle/circuit construction, separate candidate generation from proving and feed verified Lean lemmas back into context packs. |
| `leanconjecturer-2506.22005` | [arXiv:2506.22005](https://arxiv.org/abs/2506.22005), [repo](https://github.com/auto-res/LeanConjecturer) | Filter candidate block-encoding conjectures by Lean syntax, dimension shape, non-triviality, and finite block-entry diagnostics before lower proof search. |
| `lean-rademacher-2503.19605` | [arXiv:2503.19605](https://arxiv.org/abs/2503.19605), [repo](https://github.com/auto-res/lean-rademacher) | Mostly an ASTIS reference; for ABEIS it is a process example for staging large formalizations as reusable technical-lemma pipelines. |
| `lean4agent-2606.06523` | [arXiv:2606.06523](https://arxiv.org/abs/2606.06523) | Treat the agent workflow as an auditable object: structural role/artifact checks, semantic pre/postconditions, and trajectory failure localization. Current ABEIS implementation is a lightweight Lean process-contract layer in `QuantumBlockEncoding/Automation.lean`; future work is a log-level `WorkflowCertificate`. |

## Reviewer rules

- If the same proof fragment appears in two circuit paths, require a named DAG
  node before another lower-agent attempt.
- A passing finite diagnostic is only a necessary-condition signal; theorem
  closure remains Lean.
- Exploratory candidate generation is allowed only after the acceptance
  predicate, registers, matrix target, normalizer, and assumptions are fixed.
- Faithful reproduction mode must not use conjecture generation to change a
  paper theorem.
- Workflow verification is process verification: it can reject a bad run,
  missing artifact, stale route, or uncertified population promotion, but it
  cannot accept a quantum block-encoding theorem.
