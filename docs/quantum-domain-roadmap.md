# QuantumComputinglib long-term curriculum and shared Lean-graph roadmap

This document is a **curriculum and architecture plan**, not a second completion
ledger. The machine-readable source registry remains
`website/research/sources.json`; theorem publication/admission remains governed
by `website/research/publications.json`,
`docs/theorem-publication-protocol.md`, the Lean inventory, and the generated
Implementation Map. A planned chapter here is not a formalized theorem.

## 1. Current textbook: two parts, one shared foundation

The current nine guided chapters should be read as two primary parts.

### Part I — State Preparation

Chapters 1–4 establish the shared finite-matrix/circuit conventions and then
specialize them to the state-preparation contract

[
U|0^nangle=|psiangle.
]

The shared chapters physically appear once. Block Encoding reuses the same
matrix, register, unitary and circuit-semantics nodes rather than receiving
parallel copies.

### Part II — Block Encoding

Chapters 5–9 build on those same foundations and study

[
|A-alphaPi UPi^dagger|learepsilon,
]

together with LCU/product/sparse/dilation routes, certified cases, resource
accounting and proof-gated search.

The relation between the two parts is **directional and typed**.

- **State Preparation → Block Encoding.** A verified preparation can supply a
  PREPARE component, but a complete block encoding also needs the matching
  SELECT/action, inverse or unprepare semantics, coefficient/phase convention,
  register layout and clean-block proof.
- **Block Encoding → State Preparation.** Applying a clean block to an input can
  create an unnormalized desired branch, but state preparation additionally
  needs a specified input, a nonzero accepted branch, normalization, success
  probability and, where efficiency is claimed, postselection/amplification
  cost.

This is the quantum analogue of organizing two strongly related subjects in
one library without declaring them equivalent. Conceptual graph edges may show
these transports; only named Lean theorems may be shown as formal implication
edges.

## 2. Planned Part III — Quantum Information and symmetry

A future Quantum Information part will use Felix Leditzky's
[Representation-theoretic methods in quantum information theory](https://www.felixleditzky.info/teaching/FT25/math595-repth-qit.pdf)
as a principal curriculum anchor, while reusing external Lean libraries through
reviewed adapters rather than copying incompatible foundations.

The intended progression is:

1. finite-dimensional quantum states, density operators and measurements;
2. composite systems, partial trace, Schmidt decomposition, purification and
   entanglement;
3. state/channel distances and operational interpretations;
4. finite-group/unitary-group representation theory needed by QIT;
5. Schur–Weyl duality, Young diagrams/tableaux and the quantum method of types;
6. invariant families such as Werner/isotropic states;
7. de Finetti reductions and symmetry-based compression;
8. approximate cloning, spectrum estimation and weak Schur sampling.

The order is intentionally graph-driven: quantum states, tensor products,
partial trace, positive operators and channel semantics become **shared
foundation nodes** consumed both by QIT chapters and by later scientific
algorithms. Representation-theoretic nodes sit above that shared layer and are
not baked into the lower circuit model.

## 3. Planned Part IV — Quantum Algorithms for Scientific Computation

A second long-term anchor is Lin Lin and Nathan Wiebe,
[Quantum Algorithms for Scientific Computation, 29 April 2026 edition](https://math.berkeley.edu/~linlin/qasc/live_notes_0429.pdf).

The user-supplied copy of this edition is not vendored into the repository:
the same titled and dated 447-page edition is publicly hosted by the authors, so
the source registry stores the public reference instead of introducing a large
binary snapshot. If a future required appendix/edition is not publicly
available, it may be stored under a source-evidence path with provenance and
license/reuse review; it must not silently become proof memory.

The planned scientific-computing spine is:

- **background/foundations:** quantum states and circuits; density operators;
  probability, channels and state/channel distances; reversible classical
  processing; query/access models; perturbation theory; statistical estimates;
- **algorithmic transforms:** the existing Block Encoding part, followed by
  qubitization, amplitude amplification, QSP, QSVT, Hamiltonian simulation,
  operator splitting, phase estimation/Fourier transforms and amplitude
  estimation;
- **applications:** quantum walks, eigenvalue/ground-state problems, linear
  systems, linear differential equations and open quantum systems.

Block Encoding is therefore not duplicated as a later textbook chapter. The
scientific-computing part points back to the existing certified Block Encoding
nodes and adds only genuinely new transforms and application theorems.

## 4. One graph, minimal duplicated nodes

The target architecture is a single shared proof graph.

```text
L0  finite linear algebra / finite sums / norms / permutations
      ↓
L1  quantum objects
    normalized vectors · density operators · tensor systems · projectors
    partial trace · isometries · unitaries · positive operators
      ↓
L2  operational semantics
    measurements · channels · circuits · registers · classical reversible maps
    oracle/query contracts · resource/cost records
      ↓
L3  construction interfaces
    state preparation · PREPARE/SELECT · block encoding · LCU · sparse access
    dilation · amplification
      ↓
L4  transforms / algorithms
    QSP · QSVT · qubitization · Hamiltonian simulation · phase estimation
    symmetry / Schur-Weyl transforms
      ↓
L5  scientific and information-theoretic applications
```

A new theorem should reuse the lowest compatible node. A domain chapter must
not introduce its own second definition of a density matrix, partial trace,
unitary circuit, trace distance, query oracle or block encoding merely because
the source textbook uses different notation.

### Node-reuse gate

Before adding a foundational declaration:

1. search ASPBE/QuantumComputinglib;
2. search Mathlib under the pinned toolchain;
3. search the attributed quantum Lean references;
4. if an external result is suitable, write a **narrow adapter contract** and
   preserve its source/toolchain/license boundary;
5. only then add a new local node, with a written reason why reuse/adaptation
   was insufficient.

The goal is not literally the fewest declarations. It is the fewest
**semantically duplicated** nodes consistent with readable APIs, stable
toolchains and proof locality.

## 5. External quantum Lean references in the bigger picture

These projects are references or adapter candidates; the label is not a claim
that ASPBE imports or owns their theorems.

| Upstream | Planned use in the shared graph | Boundary |
| --- | --- | --- |
| [duckki/quantum-computing-lean](https://github.com/duckki/quantum-computing-lean) | finite states, gates, projectors, small circuit identities and organizational patterns | reference atlas unless an explicit adapter is compiled |
| [Timeroot/Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo) | finite-dimensional quantum/classical information, channels, distributions, entropy/capacity APIs | reference/adapter candidate; local theorem claims require a checked boundary |
| [Hayata-Yamasaki-Group/lean-quantum](https://github.com/Hayata-Yamasaki-Group/lean-quantum) | states, qudits, channels, partial trace, entropy, trace inequalities and operator conventions | reference/adapter candidate; do not duplicate higher-level QIT foundations without an audit |
| [QudeLeap/Lean-QuantumAlg-Bench](https://github.com/QudeLeap/Lean-QuantumAlg-Bench) | benchmark statements for quantum algorithms | benchmark targets are not proof memory |
| [QuAIR/Lean-QIT-Bench](https://github.com/QuAIR/Lean-QIT-Bench) | benchmark statements for quantum information | unresolved statements remain tests/targets, not certified upstream lemmas |
| ATLAS v1 / Mathlib | general algebra, matrix analysis, probability and analysis leaves | preserve their existing license/toolchain/admission rules |

For each external library we prefer a small compatibility layer over wholesale
API duplication. Toolchain mismatch is an explicit frontier, never hidden by
copy-pasting theorem statements.

## 6. Protocol for adding a future textbook section

Every future section must move through the same gates as current ASPBE work.

1. **Source freeze.** Pin edition/version, exact statement/definition anchors,
   notation and any referenced prerequisites.
2. **Mechanism placement.** Identify which existing graph nodes are reused and
   which new node/hyperedge is genuinely needed.
3. **Mathematical authoring.** Give the natural-language statement, equations,
   proof and hidden assumptions once.
4. **Lean formalization.** Add or adapt only the required declarations.
5. **Encoder–denoiser review.** Run the source-blind reconstruction and a
   distinct anti-anchored reviewer as required by the publication protocol.
6. **Truth-layer update.** Update conceptual graph, actual module/import graph,
   and theorem-dependency evidence without turning conceptual relations into
   Lean implications.
7. **Reader publication.** Only after the required Lean/integration/site gates
   pass may a planned item become a positive theorem card.

For new quantum-information material the semantic checklist additionally
includes positivity/complete positivity, subsystem order, partial traces,
normalization, support conditions and metric conventions. For scientific
algorithms it additionally includes input-state cost, query model, precision,
success probability, output/readout cost and the distinction between
mathematical oracle complexity and an explicit gate implementation.

## 7. Immediate next steps

The near-term order is deliberately conservative:

1. keep the current teaching surface as **Part I State Preparation / Part II
   Block Encoding** while sharing Chapters 1–2 rather than duplicating them;
2. finish source-faithful Vandaele comparator/adder formalization before using
   its arithmetic circuits as generic memory;
3. build the QIT shared foundations that are simultaneously useful to
   Leditzky's notes and Lin–Wiebe (density operators, channels, distances,
   subsystem operations), preferring reviewed external adapters;
4. let the Lin–Wiebe scientific-computing route reuse current block-encoding
   nodes instead of re-formalizing Chapter 9 under a second API;
5. only after those shared interfaces stabilize, expand into
   representation-theoretic QIT and later scientific-application chapters.
