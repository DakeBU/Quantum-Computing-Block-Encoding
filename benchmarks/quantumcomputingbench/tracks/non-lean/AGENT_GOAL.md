# Goal: graph-grounded natural-language QuantumComputingBench

Continue QuantumComputingBench in this repository on a dedicated branch from
current main. Read AGENTS.md, HARNESS.md and the shared contribution contract
before changes. Preserve existing work, historical reports, frozen releases and
other contributors' branches. Keep all published prose in English.

Build substantive quantum-computing QA across the actual library graph, with
breadth and multi-step mathematical reasoning, not a declaration-name quiz.
Start with State Preparation and its reusable linear-algebra, normalization,
phase, register, circuit and resource contracts; also cover Block Encoding,
Quantum Information and Scientific Computing where the source evidence supports
the target. Use derivations, constructions, counterexamples, assumption diagnosis
and composition. An import path length is not a reasoning-depth measurement.

No Lean installation is required. Do not run Lean, install toolchains or system
packages, start Docker, use paid model calls, launch GPU training or contact an
administrator. Inspect complete relevant Lean definitions as source text, exact
source statements and graph identities. Record source commit, file/declaration
or paper-section anchors and licensing. Keep planned/source-only material
explicitly separate from locally formalized results; do not claim that a Lean
proof certifies an unverified natural-language translation.

Export the shared registry with `scripts/curriculum.py export` (paths are relative
to `benchmarks/quantumcomputingbench/`). Read existing cores and open contribution
PRs before authoring. If a target is already present, propose a refinement/view
of that core with the unchanged contract hash, family, split and snapshot. If it
is genuinely new, generate a fresh UUID and put a proposal in this track's
`proposals/` folder with `core_id: candidate:<UUID>`, `admission:
candidate_not_counted` and `dedup_review_required: true`. Do not allocate permanent
core numbers yourself. Record semantic equivalence and specialization separately;
a different wording or a Lean rendering is not another core.

Provide explicit assumptions/conventions before each question, a complete
checkable mathematical answer, a useful partial-credit rubric and precise source
checks. Seek a genuinely distinct content-bound mathematical review. Record the
actual reviewer identity, uncertainty and exact item digest; never fabricate a
human approval or call self-review independent. Reader second-pass records use
`reports/textbook-v1/reader-reviews/`, method
`independent-mathematical-reader-review`, and include per-item `core_id`,
`item_digest`, `verdict`, `semantic_core_verdict`, `reasoning` and `source_checks`.
Do not mark all records accepted by a templated or mechanical verdict.

All equivalent views and aliases inherit the same split/family. Do not leak a
test solution into a training view, call a public-solution set blind, or count
Lean/NL duplicates twice. Preserve quarantines until separately reviewed repairs
are admitted. Advisory reservations do not establish exclusive ownership.

If a question itself is false or underspecified, preserve it and submit an
explicit question-contract successor, not an answer-only patch or a new core ID.
The first correction binds the predecessor item and contract, version2, full new
question/answer/rubric/exposition and a distinct contract-change review. Preserve
family/split/graph scope and disclose changed requested reasoning rather than
claiming equivalence. Use the LA206 successor as a worked example. Further
assumption/graph changes or multi-successor chains need maintainer reconciliation.
The SP108/SP111 successors show how to keep a false degree assertion visible for
refutation, then state the correct exact degree or universal upper bound without
excluding zero-step/endpoint cases. Do not turn a necessary condition into a
sufficient one in either the reference, rubric or process-step explanation.

Read the current quantum-contract checkpoint before extending planned material.
Keep exact operators, projected branches and normalized state targets distinct;
do not infer universal postselection necessity from a particular implementation.
Distinguish operator symmetry from state positivity, and fixed-tolerance
consistency from exact equality on a finite estimator grid. Check the full
reference, rubric and process steps, even when the central formula is correct.
Record shared subproofs such as the concentration step in plan-319/plan-407;
shared graph nodes do not establish either complete equivalence or distinctness.

Read the latest Hermite/directed-qubitization checkpoint:
SP107 derives normalization from the actual coefficients; SP113 derives its unit
anchor from the existing grid and endpoint value, not positivity. Do not repeat
the incorrect diagnosis that its original question lacked that unit premise.
Plan502 distinguishes a generally sufficient pairing from universal necessity;
plan504 retains leakage until projection and uses directed U/U-adjoint maps.
These exact changes are mathematical reader evidence, not new formal closure.

Apply the latest rank/regularity distinctions: threshold
width two needs the stated bounded suffix; all-cut rank one implies a product
state with short arbitrary-real preparation; this does not supply an effective
finite-bit compiler. Existing Hermite/TT compilers must be acknowledged. Write
the smoothness claim as the indexed family forall k,C^k(f_k), not C-infinity of
one fixed bridge. Historical cohort reports are snapshot-bound, not permission
to pool the current cohorts or silently transfer old-contract companions.

Read the operator/bond checkpoint before extending related exercises. Distinguish
global unitarity, full inverse, a fixed clean row and deterministic cleanup;
keep rational versus real witnesses, fixed versus existential support maps,
finite-square injectivity, wire-induced permutations and exact stored phase
explicit. Backend list counts are not optimal lower bounds; typed bond maxima
are not minimal ranks. BE004/BE112 share assessed subproofs across inherited
train/dev assignments: do not claim independent held-out evidence or pooling
clearance for those fragments. LA219 remains reserved pending a separately
reviewed convention-aware migration; do not force it into a question-only schema.

Run the benchmark unit tests and `scripts/curriculum.py validate` with a supported
Python environment. Submit coherent PR milestones with exact changed targets,
source evidence, review status, test results and unresolved gaps. Do not rewrite
another contributor's branch or publish a stable claim before the release gates
actually pass. Your handoff must distinguish authored, reviewed, admitted and
still provisional work.
