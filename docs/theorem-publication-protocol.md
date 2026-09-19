# ASPBE theorem publication and mathematical graph protocol

This is QuantumComputinglib's adaptation of Samplinglib's theorem-publication
and conceptual-mirror protocols, reviewed at Samplinglib commit
`6ff87f915bdba4471785b254c408e722c0b5dd51`. It does not import Samplinglib's
current mathematical priorities or turn conceptual similarities into Lean uses.

## 1. One mathematical objective, one authored lesson, one source of status

Before nontrivial proof work, read `AGENTS.md`, `HARNESS.md`, this protocol and
the bounded task/source packet. A universal worker owns a substantive theorem
advance end to end. Source reading, mathematics, counterexamples, Lean, circuit
semantics and exposition are modes, not fixed agent castes. Do not spawn agents
merely to duplicate a complete source context or repeat an unchanged attempt.

Use the existing task/conversion-window and trial ledgers. New research targets
are authored in `website/research/state-preparation-wiki.json`; reusable
mechanisms in `website/research/atlas.json`; source audit metadata in
`website/research/sources.json`. The same records produce human and agent views.
Do not keep a competing manually scored chapter/progress spreadsheet.

```bash
python3 website/scripts/research_atlas.py context --route spw-envelope
python3 website/scripts/research_atlas.py context --query "low rank normalized function"
```

Every new or changed production Lean module must have a publication record in
`website/research/publications.json`. A record binds **the whole module**, the
Lean toolchain, dependency manifest, source statement and anchor, authored
lesson, all emitted public declarations, source-obligation mapping, assumptions,
graph contribution and independent round-trip packets. Changes to imports,
private helpers, scoped variables or notation invalidate the module binding.
The checker does not claim that its source inventory is an elaborated proof-term
extractor; unsupported/uninventoried production modules fail closed for review.

An unchanged historical module without these records retains visible legacy
publication/audit debt. It is not retroactively reviewed by adding this policy.
The migration boundary is the Git diff base, not a contributor opt-out.

## 2. A mathematician must be able to reconstruct the argument

Author a statement and mathematical proof once, then link it from chapters,
cases, methods, graphs and the publication record. Define every object, range,
quantifier and hypothesis before using it. Provide the displayed equations and
actual proof steps; a list of tactic names is not a mathematical proof.

Immediately beside each statement/proof, provide separate initially closed
Lean disclosures. Extract exact current source; do not maintain a hand-copied
Lean proof that can diverge. Identify local calls, Mathlib calls, other imported
libraries and external references separately. A source citation is not a local
Lean dependency. A prerequisite alone does not partially prove a downstream
source theorem unless a specific proof obligation is discharged.

Keep the source's wording/version/anchor and classify every meaningful
assumption difference: `same`, `source-implicit`, `mathematically-necessary`,
`API-limitation`, `generalization`, or `unresolved`. Explain differences in
mathematical language. An API inconvenience is not a correction of the source.

For ASPBE the semantic slots include:

- target vector/operator/state family/density matrix and normalization;
- dimensions, scalar field, qubit order, basis equivalences and Fourier sign;
- oracle input/output, coherent parameter access, inverses and controls;
- clean ancillas, dirty workspace, overwritten registers and garbage sectors;
- relative phases, especially across parameter labels;
- norm, approximation, probability/confidence and all success sectors;
- gate set, exact-real versus finite-bit model, classical preprocessing, query
  construction, depth, connectivity, logical synthesis and readout costs.

Only include relevant hypotheses, but explain non-obvious exclusions. A count
of real rotations is not a Clifford+T bit-complexity theorem. An experimental
fidelity estimate is not an ideal-circuit Lean certificate.

## 3. Mandatory encoder–denoiser, with independently bound reviews

Compilation proves the formal proposition, not fidelity to the source.

1. Pin the source statement and exact module/toolchain/dependency context.
2. Export a source-blind decoder packet containing the formal statement,
   ambient definitions and conventions, **not** the source title, desired
   conclusion, previous verdict or author's assumption classifications.
3. Give that packet to a distinct decoder. Store its packet digest, run identity,
   reconstructed mathematics and evidence artifact; do not fabricate a reviewer
   or use the proving agent's own paraphrase as independent evidence.
4. A reviewer distinct from both formalizer and decoder receives an anti-anchored
   comparison packet: pinned source, formal context and reconstruction, without
   the previous verdict. It checks the semantic slots and writes its own verdict.
5. Source, actual Lean theorem, discovered mismatch and proposed repair remain
   four distinct objects. A repair never silently overwrites the source. An
   independent review of the exact repair, its necessity/minimality and supporting
   mathematics is required before it can be advertised as a justified correction.

`website/scripts/check_research_publications.py` checks exact content bindings,
source-present evidence paths, distinct identities, declarations, graph fields
and accepted independent-review records. Identity strings and files are necessary
mechanical conditions, not proof that a human/agent actually performed an honest
review. Maintainers inspect the bounded evidence at admission. No script claims
to establish natural-language equivalence, reviewer independence in the world,
or scientific novelty automatically.

## 4. Three graph truth layers; no false implication arrows

**Overview / mathematical methods** organizes sources, domains, mechanisms and
frontiers. Its links are curated and searchable. They are not proof implication.

**Underlying Lean Graph** retains the existing generated module imports and
module-to-declaration ownership. A module import is module-level structure, not
a proof that every declaration depends on every imported theorem. Lexical
reference scans, if used, must be dashed and called incomplete reference signals.
Only a future elaborated proof-term exporter may claim theorem dependencies.

**Functor Hypergraph** records conditional mathematical correspondences. Every
edge retains its complete AND-tail set, head set, formula, mechanism, hypothesis
map, conclusion map, failure boundary, sources, candidate Lean substrates and
independent-review status. Never split a hyperedge into independently sufficient
arrows from each input. SP + SELECT + unprepare can implement an LCU block; a
single prepared state does not supply an arbitrary matrix. BE + input state + a
nonzero accepted branch can supply SP, but overlap/amplification costs remain.

The term "Functor Hypergraph" is a navigation name, not a certified categorical
claim. A certified functor additionally requires typed source/target categories,
object and morphism maps, and identity/composition Lean certificates. All initial
transports are explicitly curated/proposed, with independent conceptual review
pending. Do not promote them just because a nearby Lean substrate compiles.

Use stable `concept:`, `family:`, `transport:` and exact generated
`module:` / `declaration:` identities. Reuse one shared node across sources and
views. Compression is a presentation over those identities, not a new theorem.

## 5. Domain expansion and shared-node reuse

QuantumComputinglib may expand beyond the current State Preparation and Block
Encoding parts into Quantum Information and Quantum Scientific Computing, but
scope growth does not create a second proof system or a second foundational
API. The curriculum plan in `docs/quantum-domain-roadmap.md` is descriptive;
canonical source, graph, publication and completion records remain the files
named in Section 1.

Before adding a foundational quantum node, the author must perform a reuse
audit in this order: local ASPBE declarations, Mathlib, then attributed external
quantum Lean libraries. Record whether the result is reused directly, reached
through a narrow adapter, or reimplemented locally with a reason. Toolchain,
license or API incompatibility is a typed boundary. Copying a theorem statement
into a new namespace does not satisfy the reuse audit.

Cross-domain sharing follows these rules:

- density operators, tensor-system conventions, partial trace, channels,
  measurements, norms/distances, circuits, query models and resource records
  should each have one canonical compatible node whenever their semantics
  coincide;
- a source textbook may keep its notation in exposition, but a notation adapter
  should point to the shared formal object rather than duplicate it;
- State Preparation → Block Encoding edges retain PREPARE, SELECT,
  unprepare/inverse, coefficient/phase and clean-register hypotheses;
- Block Encoding → State Preparation edges retain the input-state, nonzero
  accepted-branch, normalization, postselection and amplification hypotheses;
- scientific-computing chapters reuse the existing Block Encoding substrate
  instead of formalizing a second block-encoding API;
- representation-theoretic QIT nodes sit above the shared finite-dimensional
  quantum-state/channel layer unless the source genuinely requires a different
  setting.

For Quantum Information publications, semantic review additionally checks
positivity/complete positivity, subsystem order, purification/partial-trace
conventions, support conditions and metric normalizations. For scientific
algorithms it additionally checks input-state preparation, oracle/query
construction, precision, success probability, amplification, output/readout
cost and whether a complexity statement is query-level, logical-gate-level or
finite-bit compiled.

A cross-domain conceptual edge is still not a Lean dependency. Promotion of a
shared node or adapter requires the same whole-module binding,
encoder–denoiser, independent review and CI gates as any other production
theorem.

## 6. Contribution topology is not an automatic novelty detector

Attach graph contribution to the same publication packet, with a baseline/head,
changed identities/edges, unchanged mathematical contract and remaining boundary:

- `add-node`: an actual new declaration/interface or separately labelled
  proposal; distinguish foundational novelty from a new local formalization.
- `shortcut`: an alternative proof/construction under matched assumptions,
  norms, registers and cost tier; expose the reused path and new path.
- `reorganisation`: extract or refactor a shared mechanism and preserve its
  consumers; prove required adapters rather than just move files.
- `bridge`: connect different mathematical settings with explicit hypothesis,
  conclusion and failure maps; proposed transport is not formal implication.

Git module/import diffs are actual repository deltas, not elaborated theorem
support or novelty certificates. No graph shape, node count, citation count or
fan-out score alone decides whether a paper is marginal or conceptually new.
The Hermite view must credit the prior function-to-MPS/sequential-preparation
literature, including Holmes–Matsuura 2005.04351, while identifying the exact
source-specific ASPBE construction/certification delta separately.

## 7. Wiki and lower-bound discipline

Every StatePreparationWiki item has a target, structural assumptions, input and
oracle model, error convention, resource tuple, prerequisites, bounded steps,
acceptance tests, next advance and lower-bound comparison key. These are
research targets, not blanket declarations that nobody has solved any variant.
Sources checked only at metadata/abstract level say so. Unavailable primary
sources remain candidates and cannot support performance claims.

Match dimension, rank/smoothness promise, precision, gates, ancillas,
connectivity, success and oracle construction before comparing upper/lower
bounds. Do not announce a lower-bound breakthrough by changing the input model.
The ordinary arbitrary-vector barrier is a baseline, not the new research goal.
Progress is generated from existing textbook/implementation records plus the
Wiki contracts. Local theorem closure, source-route closure and still-pending
compiler/resource obligations must remain separately visible.

## 8. Aesthetic and reproducibility gates are part of publication

Use the site's existing Book/Sans/High-contrast themes and common sidebar. Math
belongs in MathJax display/inline environments with readable line breaks and a
copyable LaTeX source. Long formulas/code may scroll **inside** their own panel,
never force the entire mobile page to overflow. Keep diagrams legible with
complete labels, explicit arrow meanings, register order, input/output sectors
and a visible evidence legend. Colour never substitutes for text/status.

New graph layouts require keyboard selection, screen-reader labels, search and
focus, stable links, complete AND inputs, responsive mobile/desktop checks,
reduced-motion behavior and exportable maintained diagrams. Check final rendered
output, not just JSON or a screenshot of an old build. Browser geometry,
interaction and MathJax tests are automated; screenshots are review artifacts,
not a claim that an unavailable human/vision review happened.

```bash
python3 website/scripts/research_atlas.py check
python3 -m unittest website.scripts.test_research_atlas
python3 website/scripts/check_research_publications.py --base BASE_COMMIT
lake build && lake build Tests
bash scripts/build-all.sh
python3 website/scripts/research_atlas.py check-site --root _site
python3 website/scripts/check_site.py --root _site --require-blueprint
python3 website/scripts/test_research_browser.py --root _site
```

Use focused tests while editing; aggregate gates once on the integrated candidate
and again only after relevant changes. Existing unchanged proof artifacts may
be inherited only under the repository's current proof-input equality check.
Do not weaken a failed gate, insert a dummy report or mark skipped files green.

## 9. Bounded scheduling and handoff

After the first failure and two unchanged repeats of the same mathematical
route, stop and diagnose: false statement, missing hypothesis, convention
mismatch, API obstruction or target too large. Return a sharper residual,
minimal counterexample, smaller theorem or retired route; do not pad the run.
One stabilization owner integrates shared imports, website mappings and status.

The handoff includes the exact theorem/circuit delta, reused local/external
results, commit-bound tests and reviews, graph contribution, source mismatch,
remaining proof/finite-bit boundary, and the next dependency-ready objective.
No branch, commit, diagram or larger registry is itself a mathematical advance.
