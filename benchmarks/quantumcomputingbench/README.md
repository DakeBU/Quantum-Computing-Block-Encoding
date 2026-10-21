# QuantumComputingBench

Graph-grounded quantum-computing QA for training and evaluating specialized models, built on QuantumComputinglib's existing Lean inventory and explicitly labelled curriculum plans.

**Status: project launched on 21 October 2026.** The [agent build goal](AGENT_GOAL.md) specifies the implementation and acceptance criteria; this announcement is not a dataset release or a model-performance result.

## Scope

Build both knowledge breadth and mathematical reasoning depth across the shared library: State Preparation, Block Encoding, and the source-anchored Quantum Information and Scientific Computing plans. Include natural-language questions, derivations and proofs, assumption and convention analysis, multi-node composition, and Lean tasks. State Preparation is an initial pilot, not the scope limit.

| Track | Typical tasks | Required evidence |
| --- | --- | --- |
| Knowledge and interpretation | Definitions, theorem scope, notation, physical meaning and applicable assumptions | Exact declaration or reviewed source anchors and a checked answer rubric |
| Mathematical reasoning | Derivation, lemma composition, missing assumptions, counterexamples and resource accounting | Reviewed mathematical argument, explicit supporting nodes, formal certificate where available |
| Lean capability | Statement reading, lemma selection, proof completion, repair and bounded tactic interaction | Frozen target and context, isolated execution, independent final proof and axiom checks |
| Planned curriculum | Source-grounded knowledge, conditional reasoning and analysis of missing bridges | Reviewed sources and an explicit planned or unformalized status; no fabricated Lean certificate |

Module-import distance is a structural measure, not mathematical proof depth. Questions record the nodes they use, edge meanings and justified reasoning steps separately. Planned/open research questions without a validated answer belong in a separate challenge collection, not the scored gold set.

## Build and contribute

Give an AI agent [AGENT_GOAL.md](AGENT_GOAL.md), starting from a fresh checkout of the canonical repository:

```text
https://github.com/DakeBU/QuantumComputinglib-QuantumComputingBench
```

The goal requires a versioned graph snapshot, task schema, generation and validation pipeline, split and contamination controls, scoring, coverage reports and incremental tested commits. Keep benchmark code, curated public data and documentation under this directory; do not duplicate or rewrite the mathematical library to make benchmark answers pass.

Training data and evaluation data have different release policies. Never commit API credentials, private gold answers or private assessment logs. Public test material must be labelled public, not described as contamination-free or secret.

## Graph and source inputs

- [`website/lean-graph-contract.json`](../../website/lean-graph-contract.json) defines the generated module-import and declaration-ownership evidence.
- [`web/library/declarations.json`](../../web/library/declarations.json) is the declaration inventory, regenerated from the pinned Lean sources.
- [`website/curriculum-parts.json`](../../website/curriculum-parts.json), [`website/research/atlas.json`](../../website/research/atlas.json) and [`website/research/state-preparation-wiki.json`](../../website/research/state-preparation-wiki.json) provide curriculum and conditional research routes.
- [`website/research/sources.json`](../../website/research/sources.json) and the [publication protocol](../../docs/theorem-publication-protocol.md) retain source, semantic and formalization boundaries.

Coverage is computed from a frozen snapshot and a per-node disposition ledger. Dataset size alone is not evidence of coverage or quality. The implemented graph does not yet provide an elaborated theorem-level proof dependency DAG; the benchmark must not invent one.
