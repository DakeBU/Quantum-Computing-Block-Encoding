# Math 2.0 positioning and public-claims protocol

QuantumComputinglib builds human-understanding infrastructure for quantum
computing. ASPBE is the state-preparation and block-encoding construction
system; QuantumComputinglib is the library and teaching surface.

Our original aims predate and resonate with [Terence Tao, *Math 2.0*, Caltech (2026)](https://teorth.github.io/tao-web/slides/math-2-0-caltech-2026.pdf).
Slides 18–21 explain why sustainable AI-assisted mathematics should strengthen
human understanding. Slides 22, 25 and 26 give the nine examples mapped here.
They are examples, not an official fixed nine-goal standard. Describe the talk as resonating with our original aims, without implying endorsement or collaboration. Invite quantum-algorithm, formalization, education and mathematical-AI collaborators to improve the teaching and test which proof mechanisms generalize.

## Positioning hierarchy

1. **Foundations — directions 2 and 3:** maintain a living source/knowledge
   network and a high-quality reusable Lean library.
2. **Core value — directions 1 and 8:** solve exposition problems and build
   interactive, motivated texts. Explain the mechanism, not merely the verdict.
3. **Research agenda — directions 4, 5, 6, 7 and 9:** use those foundations for
   cross-pollination, proof-tool ablations, theorem neighborhoods, auditable
   math-model material and analysis of model failures.

The canonical website implementation is `website/scripts/build_site.py` and
`website/static/site.css`; `/math-2-0/` is generated from these. Do not hand-edit
generated output or create another theorem/completion ledger.

## Evidence before publicity

For each advertised contribution, provide a reader link to its evidence and
label the claim as **existing**, **next step**, or **hypothesis to evaluate**.
Prefer one worked construction and its exact boundary over global completion
or novelty claims. Reuse the canonical source, publication and proof-digestion
records; this document does not replace their gates.

- Living networks connect source statements, mechanisms, named Lean roots and
  missing obligations. Planned chapters do not imply local theorem closure.
- Compressed graphs must preserve lossless drill-down to hypotheses, adapters
  and proof obligations. The Functor Hypergraph is a navigation name; it is not
  evidence of a certified category-theoretic functor.
- Cross-pollination is a proposed transfer until its exact bridge is checked.
  Graph shape alone establishes neither novelty nor mathematical correctness.
- Source-blind **encoder–denoiser** review encodes a source statement in Lean
  and independently reconstructs its meaning from Lean, auditing assumptions
  and semantic drift. It supports ablation design but is not itself a
  theorem-level ablation. Such an ablation holds the conclusion fixed, removes
  a named theory/tool/input, and provides a replacement proof or explicit
  obstruction. Existing harness-route ablations answer a different question.
- A theorem-neighborhood experiment changes a named condition and checks the
  resulting statement, or supplies a scoped counterexample. Failure of a proof
  attempt is not evidence that the generalized statement is false.
- Our own or appropriately licensed Lean/natural-language pairs and typed
  failures can support interpretable open math tools. External references are
  not automatically eligible model data. In particular, the ATLAS v1 CC BY-NC
  rider prohibits ML training, fine-tuning, distillation, evaluation and
  development; retain the existing attribution and access restrictions.
  Training or evaluation requires license review and measured results.
  The project does not currently claim a trained model, access to its
  private internal reasoning, or certified model safety.
- A Lean theorem describes the declared mathematical model. Exact-real,
  finite-bit, gate-synthesis, noisy-hardware and application assumptions remain
  separate. Model-level counterexamples can expose boundaries or hallucinated
  assumptions; they do not certify real-world hardware reliability.

## Reader-facing presentation

The first screen should answer: what can I understand here, where can I start,
and how can I inspect the proof? Keep three clear entry actions: reading guide,
worked case and Lean graph. Put the four textbook parts below them, with short
status labels. Keep all nine directions on the dedicated contribution page.

Public posts should name one concrete contribution, link to its reader route,
and avoid unsupported adjectives such as complete, optimal or fully safe.
When presenting the family, link Samplinglib, BanditRLlib and
QuantumComputinglib as complementary domains with a shared understanding
mission; do not suggest they already share a compiled cross-library import.
