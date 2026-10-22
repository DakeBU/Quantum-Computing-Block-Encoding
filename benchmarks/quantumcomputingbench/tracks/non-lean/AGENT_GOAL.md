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

Run the benchmark unit tests and `scripts/curriculum.py validate` with a supported
Python environment. Submit coherent PR milestones with exact changed targets,
source evidence, review status, test results and unresolved gaps. Do not rewrite
another contributor's branch or publish a stable claim before the release gates
actually pass. Your handoff must distinguish authored, reviewed, admitted and
still provisional work.
