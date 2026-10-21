# QuantumComputingBench agent implementation goal

## Objective

Build QuantumComputingBench in `DakeBU/QuantumComputinglib-QuantumComputingBench`: a reproducible, graph-grounded quantum-computing QA training corpus and evaluation benchmark for specialized mathematical and scientific models. Use the entire existing QuantumComputinglib Lean graph and its explicitly planned curriculum as the coverage universe. Deliver knowledge breadth, mathematical reasoning depth, and Lean capability tasks, with inspectable answers, provenance, evidence status and reproducible scoring.

Work incrementally and push tested, coherent milestones to this repository. Do not stop at a proposal, schema, generator, or a State Preparation-only demo. First establish an end-to-end pilot; then process the complete snapshot in resumable batches, validate the retained items and account for uncovered nodes. A large unreviewed question dump does not satisfy this goal.

## Start and operating boundaries

1. Read the checkout's `AGENTS.md`, `HARNESS.md`, applicable nested instructions, `docs/theorem-publication-protocol.md`, and this directory's README before changing files. Follow additional publication protocols if making mathematical source claims or changing production Lean.
2. Confirm the canonical remote is `https://github.com/DakeBU/QuantumComputinglib-QuantumComputingBench.git`. Inspect the current branch and dirty state, preserve collaborators' changes, and record the baseline commit. Use the current checkout rather than assuming the repository matches an older conversation.
3. If your environment has a persistent goal facility, create a goal using the Objective above and the acceptance criteria below; otherwise maintain the same objective and milestone state in a resumable local run manifest. Do not invent a token budget or create another user-visible task unless requested.
4. Keep this project under `benchmarks/quantumcomputingbench/`. The library owns mathematical truth and formalization status; the benchmark owns task selection, data, validation and scoring. Reuse the library rather than duplicating its foundations.
5. This assignment builds a benchmark, not a newly trained model. Do not launch Newton03 experiments, RL, long GPU runs, paid services, cluster-wide jobs or system administration changes. Generation endpoints are configurable; establish bounded call, token, time and spending limits before any model batch. Never commit credentials or execute untrusted generated Lean on an unsandboxed host.

## Inventory the full coverage universe

Create a deterministic snapshot adapter over the actual repository inputs:

- `QuantumBlockEncoding/**/*.lean`, the generated `web/library/declarations.json`, `docs/blueprint-coverage.json`, and `website/lean-graph-contract.json`.
- The graph exporter in `website/scripts/lean_graph.py` and the site assembly in `website/scripts/build_site.py`; reuse their identities and edge directions rather than inventing incompatible node IDs. Obtain any generated `data/lean-graph.json` through the supported build/export path, not an unpinned live website scrape.
- `website/curriculum-parts.json`, `website/content.py`, `docs/quantum-domain-roadmap.md`, `website/research/atlas.json`, `website/research/state-preparation-wiki.json`, `website/research/sources.json`, publication records and relevant source audits.

Inventory all available modules, public declarations, mathematical topics, planned nodes and relevant relations. Include all four textbook parts and shared foundations. System/evidence records, generated wrappers, private helpers or redundant declarations may not support useful mathematical questions: retain their IDs with an explicit disposition rather than generating trivial name-recall questions or silently removing them from the denominator. A planned topic without a local declaration keeps its source identity; never mint a fake Lean declaration to fill the gap.

Record the repository commit, toolchain and dependency manifest, input hashes, graph schema version, extraction method, source locations and timestamps. Separate current compiled evidence, legacy semantic/source-review debt, reviewed but unformalized source material, external adapter candidates, plans and open obligations. Compilation does not automatically resolve source-faithfulness debt.

The generated Lean graph currently contains module imports and module-to-declaration ownership, not elaborated theorem proof dependencies. Keep these edge types distinct from manually reviewed mathematical dependencies, curriculum prerequisites, lexical-reference hints and conditional Hypergraph transports. Preserve all AND premises and explicit alternative routes. Import proximity alone is not a proof of entailment or a verified reasoning chain.

## Design complementary QA tracks

Build original, substantive questions in at least these categories:

1. **Knowledge and understanding:** definitions, theorem statements and scope, assumptions, notation, physical interpretation, equivalent formulations and conditions for applying a library result. Test mathematics rather than memorizing file names.
2. **Mathematical reasoning:** single-node derivations, several-lemma composition, cross-module and cross-topic arguments, choice between routes, missing-hypothesis diagnosis, boundary cases, counterexamples, and explanation of why a tempting inference fails.
3. **Quantum semantics and resources:** register and tensor order, normalization, relative/global phase, clean versus dirty ancillas, PREPARE/SELECT/unprepare composition, exact versus approximate statements, success probability, oracle access and construction cost, query versus logical-gate versus finite-bit complexity. Charge input preparation, postselection, amplification and readout where relevant.
4. **Lean capability:** read a formal statement, choose and instantiate an admissible lemma, fill a proof body, repair a broken proof, translate between an approved NL statement and a fixed formal target, and optionally perform bounded incremental tactic interactions. Include tests of applicability and convention mismatches, not only syntax recall.
5. **Planned curriculum and frontiers:** source-supported knowledge and conditional reasoning for planned topics, comparison of known assumptions, and identification of missing adapters or proof obligations. Keep unsolved research challenges separate from ordinary scored questions.

Use both single-node and multi-node questions. Aim for support-size and reasoning-depth buckets such as 1, 2, 3–4, 5–8 and 9+ where genuinely supported; do not pad a proof to reach a bucket. Record distinct support nodes, structural graph distance and reviewed semantic inference steps separately. Unknown theorem-level depth remains unknown. An automatic tactic call or a long import path is not itself a mathematical difficulty label.

Use State Preparation for an early coherent pilot, while deliberately including Block Encoding and source-reviewed planned topics. Expand to the entire inventory; do not limit the project to the earlier finite rational supplied-matrix certificate tasks. Include easy and intermediate material as well as difficult composition, so the corpus can serve training and diagnostic evaluation rather than only frontier testing.

## Evidence and answer validation

Every scored item needs an unambiguous question, sufficient stated context, an answer or explicit acceptable-answer rubric, and evidence supporting that answer. Keep formal proof validity, NL semantic alignment and answer quality as separate fields.

- For an existing-node item, inspect the actual declaration and complete type, ambient definitions and relevant proof or source. Preserve all required hypotheses; do not silently weaken the target or move missing proof ingredients into new assumptions.
- For a mathematical composition, provide a checked argument and an explicit mapping from each substantive step to supporting nodes or a newly justified bridge. Review the composition itself, not just the existence of its ingredients.
- For a Lean-certified item, freeze imports, definitions, target and approved axiom policy. Replay the complete proof independently in an isolated verifier, check transitive axiom dependencies and reject `sorryAx` or unapproved axioms. An empty goal list, a legal tactic, a substring scan or exit code zero alone is not a certificate.
- For false claims and negative examples, supply a validated counterexample or proof of negation. Parsing failure, timeout, missing APIs and unsuccessful search are not mathematical refutations.
- For planned material, inspect accessible primary sources with exact version/page/theorem anchors. A title, abstract, planned graph edge or upstream compilation record cannot support an invented local proof. A source-validated answer may be admitted to a clearly separate non-Lean-certified track; an open question without a validated answer remains an unscored challenge.
- Store real authoring and review provenance. Separate candidate, validated and released states. Do not fabricate independent reviewers or mark self-review as independent. If an independent review cannot be performed, retain the item as a draft or in the explicitly appropriate provisional track.
- Write original questions and explanations. Check source licenses and permitted training/data reuse; this repository's license does not automatically grant redistribution rights to external textbook passages. Attribute sources and avoid copying long source proofs into the dataset.

The benchmark may support later process supervision, but it must not claim to provide a free, universally correct PRM. In particular, legal execution, useful progress, final formal success and faithful NL explanation are different labels.

## Versioned item schema and data layout

Implement a versioned machine-readable schema with stable item IDs and at least:

- question, language, answer format, reference answer and scoring rubric;
- track, topic, skills, difficulty rationale and evidence status;
- target node IDs, supporting node IDs, relation types, graph version and actual support/step counts;
- assumptions, conventions, exact formal target/imports where applicable, and task/context hashes;
- source and license provenance, generation lineage/template/parameter family, validation and review records;
- split group, exposure/retrieval policy and release policy;
- verification receipts and typed unresolved issues, without exposing private evaluator material in model inputs.

Adapt the following layout as needed, documenting deviations and reusing existing tooling:

```text
benchmarks/quantumcomputingbench/
  README.md
  AGENT_GOAL.md
  schemas/
  configs/
  src/
  scripts/
  tests/
  data/public/<version>/
  manifests/<version>/
  reports/<version>/
```

Keep raw generations, private gold, credentials and private evaluation logs outside the tracked public tree, with explicit ignore rules. Persist a resumable local state with per-node dispositions and per-item lineage; publish only curated, appropriate artifacts. Large outputs need a documented artifact/release mechanism rather than bloating Git history.

## Splits and contamination controls

Design splits before broad generation. Group paraphrases, template variants, numerical substitutions, reverse questions and questions exposing the same target solution into the same split group. Add meaningful parameter, construction-family, theorem-family or topic holdouts rather than relying only on random row splits. Shared foundational lemmas may legitimately occur across splits; document that reuse instead of claiming all dependency sets are disjoint.

Distinguish closed-book model evaluation, an approved-library-interface setting, and full open-library/tool-assisted evaluation. Specify exactly what the model can retrieve in each track. Questions about a public theorem whose complete proof is accessible measure retrieval/application under that setting, not necessarily novel proof discovery. Block reference answers and disallowed task-specific proofs in restricted settings; verify those boundaries with tests.

Publish training and development materials under their stated license. Declare whether test questions and answers are public, evaluator-only or later-release. Public test sets may be reproducible, but must not be described as secret or contamination-free. Never push private gold to this public repository. If genuinely blind assessment is desired, use new private evaluation instances and a separate authorized storage/release process. Do not claim knowledge of a model's pretraining exposure.

## Reproducible generation and scoring

Provide documented commands to snapshot inputs, validate the schema, enumerate and generate candidates, validate/review items, assign/check splits, export a release, score predictions and regenerate coverage reports. Make generation resumable and deterministic where possible, with seeds, configurations, provider/model versions and actual token/time/cost records. Support dry-run and local-fixture tests without an API key; mock results never count as model or mathematical validation.

Use exact or symbolic grading when appropriate, independent Lean checking for formal tasks, and explicit content rubrics for explanations and proofs. Treat model judges as fallible; calibrate against a genuinely reviewed sample, record disagreement and leave uncertain answers for review. Do not reward word count or accept a conclusion without its required assumptions. Report correctness, evidence status and explanation/semantic fidelity separately.

Produce a coverage matrix over topics, current/planned status, nodes, edge types, question categories, difficulty/depth buckets, split groups and validation classes. Every node in the frozen universe must have a disposition: covered by released QA, candidate pending review, deliberately excluded with a concrete reason, or blocked by missing evidence. Summarize uncovered regions and prioritize meaningful mathematical gaps; do not count an unvalidated candidate as released coverage.

Run at least a small real baseline when an authorized model endpoint and budget are available, reporting checkpoint, exposure setting, measured cost and per-track results. Otherwise provide the runner and explicitly leave performance unmeasured. A benchmark must not invent scores merely to complete a README table.

## Milestones and incremental pushes

1. **Foundation:** audit inputs; freeze a snapshot; implement schema, IDs, evidence classes, split rules, ignore boundaries and validator tests. Keep the README navigable and the announcement accurate.
2. **End-to-end pilot:** release a small, genuinely validated cross-category batch with knowledge, composition and Lean tasks plus separately labelled planned/source-grounded examples. Show generation through scoring and coverage, including adversarial checks and a nontrivial multi-node question. Do not promote open challenges into gold to fill a quota.
3. **Whole-graph expansion:** process the full snapshot in bounded resumable batches; broaden topic and depth coverage, reject duplicates and trivial variants, and publish validated batches with updated manifests, coverage and limitations. Continue beyond the pilot until every node has an accountable disposition and each supported mathematical area has meaningful QA.
4. **Evaluation release:** freeze a version, split manifests and scoring configuration; publish a dataset card, contamination policy, licenses, baselines where measured and a documented reproduction path. Make subsequent library changes create a new snapshot or explicit migration, not silently change old answers.

Before each push, inspect the diff, run relevant benchmark tests and repository gates, and commit only coherent changes. Use normal fast-forward collaboration; never force-push, delete others' work, rewrite history or bypass branch protection. If direct push is unavailable, use the repository's PR process and report that state. Test failures are recorded with their cause, not suppressed.

For Lean-bearing changes run the required Lean gates, and for website changes run the current publication/Pages gates. Preserve existing proofs, reports, source-audit records and historical evidence. Keep the canonical repository and website links current. Do not hand-edit generated declaration counts, invent a parallel theorem-completion ledger, or claim a deployed site is updated without checking the actual deployment.

## Completion criteria

This goal is complete only when the repository contains a working benchmark pipeline, a validated versioned QA release spanning the supported graph areas, a complete node-disposition ledger, meaningful knowledge and multi-node reasoning coverage, isolated Lean evaluation, tested split/leakage boundaries, reproducible scoring and honest coverage/validation reports. Planned and open regions remain visible with their correct status.

A proposal, empty scaffold, synthetic count, compilation-only NL gold set or pilot-only dataset is not completion. At every handoff report the exact commit, delivered validated scope, tests actually run, unresolved blockers, coverage gaps and the next resumable batch. Progress is validated mathematical coverage and usable training/evaluation material, not the number of generated questions or commits.
