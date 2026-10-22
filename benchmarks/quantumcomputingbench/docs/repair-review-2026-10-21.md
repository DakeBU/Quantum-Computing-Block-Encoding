# Local Lean repair and release-v3 audit

## Outcome and scope

Baseline: colleague's `loty` commit
`86b9e677566498da04faebcf4e5ed57f177c6bb1`. This change targets `loty`, not
`main`. Production Lean definitions, theorem contracts, audit records and all
old datasets/reports are unchanged. Generated Python bytecode is untracked,
not deleted from history or from the user's local results.

The objective is a library-backed knowledge/reasoning/Lean QA corpus for
specialized-model training and diagnostic evaluation. This is a corrected pilot,
not a claim that a whole-graph dataset, safe arbitrary-tactic executor, faithful
white-box teacher, or universal PRM has now been completed.

## Corrections, including the question context

| Withdrawn key | Defect | Correct boundary and local check |
| --- | --- | --- |
| `qs-resource-depth-parallel-vs-serial` | Interprets max ancilla bookkeeping as a universal physical peak bound | Defined counts are checked; disjoint simultaneous unit demands give 2 > max(1,1). Physical scheduling/reuse remains a separate contract. |
| `neg-prepare-firstcolumn-positivity` | Treats sufficient strict positivity of a flat API as necessary | The lower theorem accepts nonnegative amplitudes and positive total mass. A sparse vector with a zero entry is prepared; the zero-subtree guard is checked. |
| `neg-ry-not-half-only-at-pi` | Confuses amplitude-plane and Bloch rotation angles | RY(2 alpha) is the amplitude-plane rotation by alpha; its parameter equals the Bloch rotation angle. The false premise was also removed from assumptions/conventions. |
| `k-becost-lexicographic-order` | Derives priority from supposedly zero oracle gate cost | Unexpanded elementary counts are zero, but Resource.gates charges one abstract oracle unit. Score priority is an explicit design choice. |

No historical definition is changed to make a benchmark answer true. Corrected
successors retain `supersedes`. All four original gold keys are prohibited by
scoring/export entry points; the old files remain available for audit.

The three original Lean candidates also had unqualified names/missing direct
imports and reference tactics that their own restricted verifier rejected.
Successors use fully qualified targets and exact imported lemma applications.
These are honest interface-application exercises, not novel proof discovery.

## Actual Lean evidence

Pinned toolchain: Lean **4.29.1**. The complete repository gate executed:

1. `lake build`;
2. `lake build Tests`;
3. every production/test module target in the supported gate, in batches of 40
   (**202 targets**), including modules omitted by a root-only build.

A pre-existing complete local build checkout was reused only after comparing the
entire production/test source, toolchain and dependency-configuration identity:

`1e65e7d2984e4542ca2747837d71c516847e4e987d3bbd6c48b8a803eb36806e`

The build checkout commit is retained in the evidence report. Its production
proof inputs match the working branch exactly; this is content-bound gate
inheritance permitted by the library protocol, not reuse based on age/name.
An attempted separate cache bootstrap could not create a junction in the local
Windows environment; this was ENV_BLOCKED, not negative mathematical evidence.
No dependency pin was changed to bypass it.

The fixed `lean/ReferenceChecks.lean` pack compiled **16 named reference
theorems**. Actual generated harnesses then replayed all **three** repaired Lean
proof bodies against their frozen targets. Every accepted root had a transitive
axiom set contained in `{propext, Classical.choice, Quot.sound}`.

Two real Lean negative controls were run in temporary engineering files:

- A placeholder proof produced `sorryAx` and was rejected by the axiom evaluator.
- A proof of the wrong theorem/type failed elaboration and was rejected as
  unproven, not as a refutation of the mathematical target.

See [the machine-readable evidence](../reports/release-v3/lean-reference-checks.json).
These runs execute only inspected, trusted reference code. They do **not** enable
the untrusted-output container gate or constitute an independent NL/source review.

## Released and provisional data

- **26** unchanged authored items retain exact-content-bound prior AI reviews.
  No reviewer identity or new review is fabricated. Review inheritance is
  explicitly recorded, not presented as a fresh human review.
- **12** corrected/new candidates: four corrected NL questions, three repaired
  Lean exercises and five exact-answer diagnostics. Local reference evidence is
  attached, but independent NL/source review remains pending.
- **8** other historical unresolved candidates remain candidates.
- Total retained items: **46**; all **5,153** universe nodes retain dispositions.
- Released primary targets: **30** distinct nodes; released target-or-support
  membership: **94** nodes. Neither figure is whole-graph mathematical coverage.
- **127** exporter modules still have no released source-linked question.

The [review queue](../manifests/release-v3/review-queue.json) identifies the exact
authoring/content hashes and source anchors needed by a genuinely independent
reviewer. A Lean proof of a formal proposition does not self-certify the NL
question, its rubric, physical interpretation, or external-source fidelity.

## Split and reproduction repairs

The old public test consisted only of four planned questions. V3 now has
train=11, dev=4, test_public=11. The public test contains **seven core** and
**four planned** questions. Explicit real-amplitude, Givens, Thin-LQ and banded
construction holdouts propagate through target-solution/family unions.

The split is retrospective and public: old questions/answers were already
published. It must not be advertised as unseen, secret or contamination-free.
Shared foundational support is allowed and disclosed. Planned curriculum and
conditional Hypergraph transports never become local Lean implication edges.

LF-canonical SHA256 hashes survive Windows/Linux checkouts while still detecting
substantive changes. A narrowly pinned legacy adapter blob preserves v2's
original pipeline provenance; production library inputs cannot use that escape.
V3 separately freezes the generator/validator/scorer/schema/configuration hashes.
Scoring/baseline entry points validate the release and its manifest before use.

The new source-packet issuer is bounded, resumable and module-diverse. It
prioritizes missing primary targets and preserves full AND-tail Hypergraph
records. It is source-reading preparation, not automatic QA authoring or review;
issuing a packet adds zero released coverage. No model endpoint was called.

## Verification and acceptance boundary

All **74 benchmark tests pass**. They cover the original lifecycle and new withdrawal, context,
split, text-hash, source-packet, bounded-output and proof-evidence regressions.
The original library Harness suite ran **87 tests: 86 passed, one Windows
symlink-only test skipped** because symlink creation is unavailable locally.
CI is separately observable, not assumed green.

Container fixes include binding the readable harness file rather than a host
0700 temporary directory, a writable non-root tmpfs, requiring the configured
vetted image digest, and bounded pipe draining before memory allocation grows.
Their software-contract tests pass. **No local Docker/Podman pinned-image
integration test was possible, so certification remains ENV_BLOCKED.** Formal
release admission remains closed. A live isolated verifier can supply scoring
evidence only with exact item/task/context/snapshot/proof bindings; a JSON receipt
or trusted-local reference receipt cannot award formal evaluation credit.

No real model baseline, paid API batch, training experiment, Newton03 run, remote
administrator request or main-branch merge was performed in this repair.

## Structured handoff

- Mathematical delta: explicit counterexamples retire false gold inferences;
  sparse preparation and the actual half-angle/resource interfaces replace them.
- Highest certified frontier: exact local reference propositions and the complete
  unchanged production Lean gate, **not** independent NL fidelity or isolated PRM.
- Failure classes: REFUTED for the universal max-ancilla/strict-necessity
  inferences; IMPLEMENTATION_FAILED for old formal import/grammar integration;
  ENV_BLOCKED for container integration. These classes are not interchangeable.
- Salvage: original valid questions/reviews and all historical reports retained;
  useful boundary witnesses live in the fixed benchmark reference pack.
- Direction fingerprint: `qcb-v3-local-reference-and-gold-boundaries`.
- Parallel work: none; no duplicated review contexts or invented independence.
- Source/Lean/Hypergraph distinction: preserved. No new production Source Anchor
  or paper-faithfulness promotion; QA independent review/Exposition Seal pending.
- Next acceptance step: independently review the 12 candidates, then provision
  and test a vetted isolated verifier before admitting formal evaluation tasks.
  Continue substantive whole-graph authoring using the frozen coverage ledger.
