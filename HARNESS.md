# ASPBE Harness v2: Frontier Master–Worker Protocol

ASPBE formalizes state-preparation and block-encoding mathematics all the way
from a source or oracle contract to named Lean theorems, readable derivations,
circuit figures, and optional executable exports. The harness therefore needs
both broad mathematical freedom and hard evidence gates.

Harness v2 keeps the useful proof-DAG and verification infrastructure of the
original Upper/Middle/Lower/Reviewer pipeline, but changes the unit of work and
the meaning of a role:

> **A Worker owns one substantive mathematical advance end to end. A Master
> maintains the global proof frontier and merges evidence. Source, Lean,
> semantic, integration, and exposition checks are gates, not cognitive
> castes.**

The older role names remain accepted by `tools/qbe.py` as execution slots for
backward compatibility. They no longer restrict what an agent may notice,
prove, refactor, test, or explain.

## 1. Why the protocol changed

The first harness was intentionally layered. It reduced contract drift and
made verifier feedback explicit, but it also made some tasks too fine-grained.
A source reader could discover a decisive circuit convention yet be expected
only to report it upward; a Lean worker could see a better decomposition yet be
asked to edit one leaf; several workers could ingest almost the same context
and each return a role-local fragment. The run could remain busy while the
root theorem barely moved.

The Vandaele comparator audit is a representative failure mode. Local carry
arithmetic, modular subtraction, resource statements, and finite checks can
all advance independently, while the real source claim still lacks the exact
chain

```text
individual X/CNOT/Toffoli gates
  -> source subcircuits U₁,...,U₈
  -> Figure 4 adder semantics
  -> Figure 5 comparator semantics
  -> paper theorem and resource claim.
```

A branch, commit, new file, local lemma, or longer log is therefore not counted
as progress by itself. Progress is measured at the proof frontier.

The quoted external report motivating this revision mentions an approximately
30-fold efficiency gain for a Master–Worker arrangement. ASPBE treats that as
a hypothesis to test, not a project fact. The repository will measure accepted
mathematical delta per invocation and per token rather than repeat an
unverified headline number.

## 2. Invariants that never become optional

Worker freedom does not relax the scientific contract.

1. **Frozen target.** The target state/operator, normalizer, register order,
   clean ancilla convention, source equation, oracle model, and exact or
   approximate tolerance rung are explicit before broad search.
2. **Source fidelity.** Faithful-paper mode may expose a source error or
   ambiguity, but may not silently repair it, swap operands, add a hypothesis,
   or prove an easier replacement theorem.
3. **Lean acceptance.** An exact symbolic claim is accepted only when its named
   Lean root and required tests compile. Finite NumPy/Qiskit/OpenQASM checks
   are screening, counterexample, and export evidence.
4. **Typed uncertainty.** A missing theorem, external result, convention, or
   implementation bridge remains an explicit obstruction.
5. **Reader-facing traceability.** Every promoted circuit or formula can be
   traced to the source convention, mathematical statement, Lean declaration,
   and dependencies that justify it.

The default repository gate remains

```bash
lake build && lake build Tests
```

and reader-facing changes additionally use

```bash
bash scripts/build-all.sh
```

## 3. The scheduling object: a global proof frontier

The Master maintains a directed acyclic graph whose nodes are source claims,
definitions, semantic interfaces, Lean lemmas, finite diagnostics, resource
claims, figures, and final theorem roots. An edge `A -> B` means that `B`
depends on `A`.

Each active cycle names:

- the **root acceptance target**;
- the highest currently certified frontier;
- the smallest missing interfaces that genuinely block the root;
- independent exploratory forks worth running in parallel;
- the evidence required before any fork can be merged.

The frontier is not a flat to-do list. A low-level lemma is valuable when it
closes a dependency, compresses repeated work, falsifies a route, or changes the
next global decision. A proved leaf disconnected from the selected root is
recorded as reusable library work, not reported as closure progress for that
root.

## 4. What counts as a substantive mathematical advance

A Worker invocation is successful when it delivers at least one of the
following and records its effect on the frontier:

- closes a named theorem or a reusable interface needed by the root;
- converts a source equation or circuit into an exact, checkable semantic
  statement and removes a material convention ambiguity;
- supplies a counterexample or impossibility argument that retires a route and
  changes the proof plan;
- replaces several repeated proof traces by one reusable Lean block;
- integrates previously separate mathematical and Lean layers into a theorem
  chain that reaches a higher frontier node;
- makes a reader-facing circuit explanation exact by linking every register,
  transformation, output bit, and displayed conclusion to the corresponding
  theorem nodes.

The following do **not** count on their own:

- creating a branch, commit, prompt, report, or placeholder declaration;
- restating the task in more prose;
- repeating an unchanged failed route;
- proving a convenient arithmetic identity while leaving the advertised gate
  circuit uninterpreted;
- drawing an attractive circuit whose operand order, carry convention, or Lean
  certificate cannot be identified;
- passing a finite example and promoting it as an arbitrary-width theorem.

A Worker may also return a **substantive obstruction**. It must be sharp enough
to change the graph: a minimal counterexample, an irreducible source ambiguity,
a missing library interface, a false intermediate claim, or a resource theorem
whose assumptions do not follow from the source.

## 5. Master responsibilities

The Master is a global synthesizer, not a serial author of every artifact.

1. Freeze or revalidate the contract and evidence class.
2. Maintain the proof-frontier ledger and identify the actual bottleneck.
3. Issue a small number of independent Worker objectives, each large enough to
   produce a substantive advance.
4. Give Workers the smallest sufficient context pack plus pointers to durable
   repository memory; do not duplicate the full conversation by default.
5. Compare returned mathematical deltas, reconcile conventions, and merge only
   mutually consistent evidence.
6. Route deterministic checks to scripts and CI rather than spending model
   context re-performing them in prose.
7. Stop or redirect a route when repeated work does not move the frontier.
8. Publish one synthesized state: what is now proved, what is falsified, what
   remains, and which next forks are genuinely independent.

The Master must not hide uncertainty by averaging incompatible Worker answers.
A disagreement becomes a source audit, finite discriminator, or Lean proof
obligation.

## 6. Universal Worker responsibilities

A Worker is deliberately cross-layer. It may inspect the paper, derive the
mathematics, search existing Lean declarations, add definitions and lemmas,
write tests, construct a counterexample, improve a diagram, and update the
human proof map when those actions are needed for its objective.

Existing skills such as source audit, proof diagnostics, proof DAGs, block-
encoding route selection, mathematical writing, and proof export are **lenses
and tools**. They are not permanent job boundaries.

Every Worker returns a compact handoff packet:

```text
Objective / frontier node:
Mathematical delta:
Named evidence (Lean roots, tests, source anchors, finite witnesses):
Assumptions and conventions:
Files changed:
Reusable cross-layer insights:
Typed obstruction or rejected routes:
Residual risk / confidence:
Recommended merge and next independent forks:
Context digest for the next reader:
```

A Worker should not stop at the first role boundary. For example, discovering
that a source comparator reverses its operands should immediately trigger the
smallest discriminating example, the corrected formal statement, and the
consequence for the theorem/figure map when feasible.

## 7. Evidence gates, not fixed verifier personalities

Promotion uses five gates. They may be checked by different models, the same
model in a fresh context, scripts, CI, or a human maintainer.

| Gate | Question | Typical evidence |
| --- | --- | --- |
| Source | Is this the literal theorem/circuit and convention? | equation/figure anchors, register transcript, explicit interpretation decisions |
| Semantic | Does the construction implement the stated map? | basis-state theorem, matrix-entry theorem, minimal counterexamples, finite truth tables |
| Lean | Is the advertised symbolic claim accepted? | named declarations, `lake build`, test modules, no hidden `sorry`/axiom drift |
| Integration | Does it compose with the library and resource contract? | imports, root theorem, register cleanup, resource tuple, public-gate checks |
| Exposition | Can a reader reconstruct the argument without guessing? | theorem-linked equations, readable circuit/dataflow diagram, Concept → Math → Lean map |

The gates are asymmetric. Passing exposition cannot compensate for a failed
semantic gate; passing a finite semantic check cannot compensate for a missing
symbolic Lean root.

## 8. Parallelism and the Master bottleneck

Parallel Workers are useful only for independent uncertainty. Good forks
include competing constructions, a source audit versus a generic proof, or a
finite falsification track versus a symbolic implementation track. Two
Workers should not independently ingest the same large context to prove the
same unclassified leaf.

To prevent the Master from becoming the next bottleneck:

- use a durable frontier ledger rather than reconstructing global state from
  chat logs;
- require compact structured handoffs with evidence digests;
- delegate builds, style checks, declaration inventories, and replay tests to
  deterministic tools;
- merge at bounded synchronization windows rather than after every local edit;
- appoint a temporary **anchor Worker** for a mathematically independent theorem
  family when the frontier becomes too wide;
- let the anchor synthesize its family, but keep contract changes and final
  promotion with the Master;
- retire stale branches and duplicate leaves after their reusable delta has
  been admitted.

An anchor is temporary and objective-scoped. It is not a return to permanent
Upper/Middle/Lower castes.

## 9. Efficiency measurements

Harness v2 records quantities tied to scientific output:

- accepted substantive advances per Worker invocation;
- root-frontier nodes closed per 100k input/output tokens;
- fraction of Worker context duplicated across forks;
- cycles to the first falsifying example for a wrong route;
- reusable theorem nodes added versus task-local flat proof lines;
- Master synthesis tokens per accepted Worker delta;
- reopened or reverted theorem claims after review;
- fraction of figures whose displayed claims have named Lean roots;
- wall-clock and provider cost when available.

Branch count, commit count, generated prose length, and number of active agents
are observability data, not success metrics.

## 10. Backward-compatible execution slots

`tools/qbe.py` currently exposes `upper`, `middle`, `lower1`–`lower4`, and
`reviewer` profile keys. Harness v2 interprets them as scheduling slots:

- `upper` is normally a Master/frontier refresh pass;
- `middle` may be a Master synthesis pass or a Universal Worker owning a
  conversion/integration objective;
- `lower1`–`lower4` are parallel Universal Worker slots with different objective
  packets or optional lenses;
- `reviewer` is a fresh-context evidence-gate pass, not a cognitively weaker or
  narrower agent.

This mapping lets existing runs and logs remain reproducible. A future CLI may
add native `master`, `worker`, and `anchor` keys, but documentation must not
pretend those keys already exist.

## 11. Worked scheduling example: Vandaele Figures 4 and 5

The root target is not “prove some complement arithmetic.” It is:

```text
literal source gates
  -> U₁,...,U₈ semantics
  -> Figure 4 adder with exact operand/carry convention
  -> X–ADD–X Figure 5 data and flag semantics
  -> comparator theorem and resource statement.
```

A useful parallel cycle is:

- **Worker A — literal circuit witness.** Transcribe the printed five-bit
  Figure 4 gate sequence; prove or exhaustively verify its basis action; record
  wire order and the exact carry bit.
- **Worker B — arbitrary-width semantics.** Derive reusable local carry
  invariants and lift them through `U₁,...,U₈`; use
  `BinaryCarryTelescoping.lean` only as an internal arithmetic dependency, not
  as a substitute for the adder circuit theorem.
- **Worker C — adversarial source audit.** Compare the paper equation, Figure 4
  operand placement, and Figure 5 X–ADD–X wrapper; produce minimal examples for
  `a < b` versus `b < a` and state exactly which convention makes each claim
  true.
- **Worker D — theorem-linked explanation.** Draw separate data-wire and
  carry-wire flows and attach theorem names to every arrow; reject the diagram
  if a novice must infer which register is overwritten.

The Master merges these only after they agree on register order and carry
convention. The intended public explanation must visibly separate

```math
b \longmapsto (b-a) \bmod 2^n
```

from the raw carry predicate, and must say whether the flag is `[b<a]` or
`[a<b]` under the literal source wiring. A one-bit audit is a discriminator;
it is not the arbitrary-width Figure 4 closure.

## 12. Minimal cycle protocol

1. Refresh the root contract and proof frontier.
2. Select at most a few independent uncertainties.
3. Give each Universal Worker one substantive objective and a compact context
   pack.
4. Require the structured handoff packet.
5. Run source/semantic checks early enough to kill wrong routes cheaply.
6. Run the Lean and repository gates on merge candidates.
7. Synthesize one global delta and retire stale work.
8. Update the human proof map and diagram when the mathematical frontier has
   changed.
9. Record efficiency data before opening more parallelism.

The operational agent instructions live in `AGENTS.md`. The Master and Worker
prompt contracts live in `.agents/skills/qbe-frontier-master/SKILL.md` and
`.agents/skills/qbe-substantive-worker/SKILL.md`.
