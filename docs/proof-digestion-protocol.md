# QuantumComputinglib Proof Digestion Protocol

QuantumComputinglib adopts a source-first lifecycle:

Formalize → Audit → Compress → Explain.

The goal is not to leave researchers with a large machine-generated circuit
proof forest. The library must preserve full Lean/source evidence while
presenting a purified graph of the quantum primitives and construction
mechanisms that actually matter.

## 0. Three declaration levels

Apply review effort according to mathematical role.

- **A. Source Anchor** — a source-facing theorem/definition or explicit original
  quantum contract. It requires Statement Seal, binder/definition audit,
  source-proof/construction coverage, semantic round trip, Proof Seal,
  publication and purification.
- **B. Canonical Quantum Library Node** — a reusable state/channel/oracle,
  linear-algebra, circuit, block-encoding or resource lemma. Require Lean
  proof/axiom cleanliness, local/upstream search, canonicality, genuine
  consumers, and duplicate/wrapper purification.
- **C. Internal Provider** — proof/circuit implementation glue used to build an
  Anchor or canonical node. Require compilation, no fake closure, and
  reachability/dead-code cleanup, but do not give it independent source credit.

This keeps exact quantum contracts maximally strict without forcing every
register-level helper through an unnecessarily expensive source-facing audit.

This protocol complements AGENTS.md, HARNESS.md, and
docs/theorem-publication-protocol.md.

## 1. Freeze the quantum contract before proof search

Every new or materially changed source-facing theorem or definition is a
**Source Anchor**. Before proof search, pin:

- exact source/version/theorem or original-result contract;
- scalar field and dimension parameters;
- subsystem/register order and basis convention;
- normalization and global/relative phase convention;
- clean ancillas, dirty workspace, preserved/overwritten registers and garbage
  sectors;
- oracle input/output semantics, coherent access, inverses and controls;
- norm/error/success-probability convention;
- resource model: query, logical gate, Clifford+T/finite-bit, depth,
  connectivity, preprocessing and readout;
- the exact final Lean signature and a versioned statement digest.

The final signature may be elaborated in an untracked temporary probe. The
production tree remains zero-sorry.

After STATEMENT_SEALED, proof workers may modify internal proof machinery but
must not weaken the state/operator/circuit contract or add convenient access
assumptions. A genuine correction creates a versioned successor and invalidates
dependent source-topology/audit evidence.

## 2. Binder audit

Recursively expand project-owned Prop aliases, structures, typeclasses and
contract bundles. Classify every logical input as:

- SOURCE: explicit premise of the cited statement;
- STANDING: field of a separately audited source-wide convention/assumption;
- TYPING: pure carrier/dimension/type formation data implicit in the source;
- RULED: exact human-approved correction;
- EXCESS: any other proof result or convenience premise.

EXCESS fails a source-facing Anchor.

The invariant is:

    proof ingredient = dependency edge
    source hypothesis = theorem binder

For example, if a block-encoding theorem needs a normalized PREPARE state,
SELECT correctness, an inverse/unprepare identity, or a nonzero accepted
branch, those facts must be produced by dependencies and applied inside the
proof unless the source theorem itself assumes them. The existence of producer
lemmas does not justify moving their conclusions into the public theorem
interface.

High-risk quantum drift points include hidden register-order changes, silent
basis identifications, replacing coherent oracle access by classical access,
dropping relative phases between labels, assuming clean ancillas not present in
the source, and mixing query complexity with compiled gate complexity.

## 3. Definition audit

Every source-facing definition declares one of:

- literal;
- characterized;
- quotient/representative.

### Literal

The body must agree with the source formula on the whole public carrier. No
default/zero fallback is allowed to invent semantics outside a valid locus.

### Characterized

When the source object is uniquely characterized by Phi, first prove and audit
the real source well-definedness theorem: there exists a unique x satisfying
Phi. Only then may classical choice define the object, and the definition must
land with a full characterization/uniqueness theorem.

### Quotient / representative

Quantum mathematics often contains non-canonical representatives. Record the
equivalence relation, the choice mechanism, and which downstream statements are
representative independent. Existence of a representative is not a claim of
canonicality.

High-risk examples include representatives modulo global phase, purification,
unitary dilation, spectral/Kraus decompositions, tensor-factor reorderings and
basis-dependent matrix representatives. In particular, purification and unitary
dilation are generally non-unique: the protocol must not manufacture a false
unique object merely to make classical choice convenient.

## 4. Source Proof Graph independent of implementation Lean

Before the Lean implementation is allowed to shape the story, reconstruct the
source proof/construction topology from the source itself.

The source-topology extractor/reviewer may inspect the pinned source and sealed
Anchor interface but may not use implementation Lean to decide how the author
proved or constructed the object.

Every in-scope theorem, definition, displayed circuit/formula, citation, and
substantive proof/construction paragraph receives one disposition:

- NODE with a stable source identity; or
- EXCLUDED with an explicit reason.

Missing bridges remain SOURCE_GAP nodes. For circuit arguments, a diagram arrow
is not self-certifying: the graph records the theorem/subcircuit semantics that
justify the transformation and the consumer use-site.

This prevents a route from appearing complete because all named theorems were
covered while register bookkeeping, phase reconciliation, garbage cleanup or
resource-accounting paragraphs were omitted.

## 5. Alternative constructions are OR-routes

When two sufficient constructions exist, represent them as alternative route
nodes/hyperedges rather than combining every prerequisite into one false AND.

Examples include:

- direct amplitude loading versus structured tensor/MPS preparation;
- LCU/PREPARE–SELECT routes versus signal-processing routes;
- postselection versus amplitude-amplified routes;
- multiple block-encoding constructions with different oracle/resource models.

The source route and the implementation route may differ, but both provenance
records remain explicit.

Before choosing a proof/construction route, record formalization cost, existing
QuantumComputinglib/Mathlib/external reuse, new reusable primitives, hidden
circuit-semantic prerequisites, and reader/pedagogical quality.

## 6. Four graph views

### Source Proof / Construction Graph

**Question:** How did the source derive or construct the result?

Tracks source theorem/circuit/formula topology, bookkeeping, source gaps and
OR-routes.

### Lean Dependency Graph

**Question:** What does the checked implementation actually depend on?

Tracks compiler-backed declarations/modules and reviewed theorem dependencies.

### Compressed Quantum Spine

**Question:** After removing implementation bookkeeping, which quantum
primitives actually recur?

Typical families include state/isometry preparation, unitary embedding,
controlled operations, PREPARE–SELECT–unprepare, projection/postselection,
block encoding, amplitude amplification, polynomial/signal transformations,
channel/state representations, tensor-system adapters and resource accounting.

### Functor Hypergraph

**Question:** Which mechanisms persist after changing representation, oracle,
resource model, state/operator class or error metric?

These are reviewed conceptual transports, not formal theorem edges unless
separately certified.

## 7. Paper/construction decomposition

For each formalized paper/result, maintain:

    G_paper = G_existing ∪ G_bookkeeping ∪ G_new_reusable ∪ G_new_topology.

- existing: already available QuantumComputinglib/Mathlib/admitted external
  substrate;
- bookkeeping: register/order/phase/resource composition and other source-faithful
  glue between known primitives;
- new reusable: new canonical quantum lemmas/interfaces with future consumers;
- new topology: a new composition of primitives/constructions.

This decomposition helps a researcher ask whether a result adds mainly
bookkeeping, a new primitive, or a new construction architecture. It is not an
automatic novelty score.

## 8. Proof Seal

A Source Anchor becomes PROOF_SEALED only if:

- the final Lean signature matches the Statement Seal;
- focused and repository checks compile the actual target;
- unauthorized axioms/placeholders/fake wrapper closures are absent;
- the binder audit has no EXCESS;
- every conditional circuit/mathematical premise is supplied by dependencies;
- source-blind reconstruction and independent source review are accepted, or
  the mismatch remains explicitly published;
- the Source Proof Graph exposes discharged and remaining source obligations.

Executable Qiskit/NumPy/QASM evidence remains supporting evidence only.

## 9. Purification gate

PROVED and MERGED are not the final reader-facing state.

After integration, purification checks:

- dead declarations left by failed proof/construction attempts;
- duplicate semantic APIs;
- wrapper-only lemmas;
- import minimization;
- canonicalization of shared state/channel/oracle/resource primitives;
- proof/construction-route compression;
- graph compression into reusable quantum mechanism families;
- elaboration cost;
- reader compression.

The public site defaults to the compressed construction spine while preserving a
lossless drill-down to the full source and Lean evidence.

The rule is:

> **Do not leave machine garbage for humans.**

## 10. Lifecycle

    SOURCE_PINNED
      -> STATEMENT_SEALED
      -> SOURCE_TOPOLOGY_REVIEWED
      -> PROVED_LOCAL
      -> PROOF_SEALED
      -> PUBLISHED
      -> MERGED
      -> PURIFIED

Existing task/route status remains the repository integration status. MERGED is
not synonymous with PURIFIED.

## 11. Required proof-digestion record

New Source Anchors and major paper routes must record:

- statement_seal: source revision, statement version, signature digest, binder
  audit and definition kind;
- source_proof_coverage: inventory, reviewed nodes, excluded-with-reason items,
  source gaps and alternative routes;
- proof_digestion: existing substrate, bookkeeping, new reusable primitives and
  new topology;
- purification: pending/purified state, dead-code audit, duplicate-semantics
  audit, canonicalization, compressed-spine delta and reader default view.

These are normative protocol requirements. Existing publication JSON/checkers
may migrate incrementally, but no migration may weaken source fidelity,
semantic review, Lean correctness, graph truth, circuit-resource semantics or
website gates.


## Design provenance

The source-first statement-sealing, independent source dependency/coverage
graph, binder audit, definition audit, explicit alternative-route, and
post-proof cleanup ideas were informed by Scott N. Armstrong's October 2026
autoformalization workflow and the public LeanAutoformalizationSkills project:
https://www.scottnarmstrong.com/2026/10/autoformalization-is-now-very-easy/ and
https://github.com/scottnarmstrong/LeanAutoformalizationSkills.

This library adapts those ideas to its own trust model rather than copying the
workflow verbatim: production Lean remains zero-sorry, the existing
encoder-denoiser/source review remains mandatory, and the four-view
source/Lean/compressed/Functor proof-digestion stack plus PURIFIED reader state
are project-specific requirements.
