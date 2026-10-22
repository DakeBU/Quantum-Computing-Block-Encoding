# Native natural-language QA goal and collaboration contract

This additive task builds native mathematical knowledge and reasoning QA using
Python only. It does **not** require new Lean installation, compilation or isolated
Lean replay. The broader historical goal remains in AGENT_GOAL.md; this narrower
objective and resumable milestone state are in `manifests/nl-goal.json`.

## Actual baseline

- User's `loty` source archive matches canonical branch commit
  `5fd07170d84f60a16d564d75cd72e87e26c5b837` for production Lean and benchmark files.
- At inspection, only `origin/loty` contained that commit. `origin/main` was
  `3b56da964f97511cc478d942d513b3e01b9328ee`, without the corrected v3 tooling.
- Work branch: `qcb/nl-qa`, based on loty, not main.
- Baseline Python tests: 74 passed. No fresh Lean verification performed.
- No system package, Lean, Lake or container runtime is installed by this task.

## Preserve v3 truth and history

All existing v3-bound pipeline files, schema/configuration hashes, authored
records, repair evidence, withdrawn answers, contributor identities, production
Lean sources and historical reports are preserved. New files `qcb_nl.py`,
`nl_qa.py`, `native-nl-v1.schema.json` and `test_nl.py` form an additive successor.
The frozen v3 snapshot is reused with its exact input identity and provenance.

Old provisional repairs can be reviewed but are **not new problem cores**.
Source inspection of an existing formal proposition is not compilation; inherited
formal receipts retain original run identity and may not be described as rerun.

## Mathematical content

A native question supplies its mathematical setup and asks about mathematics,
not code vocabulary. Its answer and rubric require no declaration/file/tactic
name recall. Graph/source identities remain backstage metadata. New cores cover
concepts, proofs, genuine several-step composition, boundary cases, invalid
reasoning, counterexamples, physical interpretation and explicit resource models.

`evidence_relation` distinguishes:

- `local_source_supported`: the literal mathematical interface is supported by
  inspected complete local declarations/definitions, without new compilation;
- `nl_bridge_from_inspected_source`: an original NL derivation/bridge from those
  interfaces; not an already compiled counterpart of that whole argument;
- `primary_source_nl_only`: a planned/unformalized result grounded in inspected
  pinned primary text; no claimed local formal counterpart.

Authoring stages are candidate, independently content-reviewed, and released.
Unresolved questions stay provisional. Open research without an established
answer is unscored. Numerical checks support witnesses, not parametric proofs.
Primary source rights remain those of their owners; original questions and
explanations are not permission to redistribute textbook text or long proofs.

## One core across all views

Each new mathematical problem has one stable `core_id`. NL, Lean/hybrid views,
paraphrases and trivial numeric substitutions must alias that core. Family/core
unions determine splits; legacy target/family overlap triggers semantic checking.
A target node may support many genuinely different questions; neither matching
node sets nor different wording alone proves problem equality or novelty.

`manifests/nl-v1/core-registry.json` is a **coordination proposal**, not a fabricated
acknowledgment. It lists new IDs, family/split groups and old views for reconciliation.
Actual Lean-equipped collaborator acknowledgment is required before shared
integration; until then `integration_allowed=false`. No contact or approval is
inferred from a metadata file. Reviewers check novelty against v3 independently.

For the Lean collaborator, formal candidate exports include the exact NL target,
quantifiers/assumptions, target/support node IDs and source anchors. They are
candidate formalization tasks, not proof bodies or new verification receipts.

## Coverage and depth

The full frozen universe remains the denominator. Primary-target coverage is
reported separately from incidental support mentions. Support size, authored and
reviewed semantic steps, and structural graph distance are separate quantities.
Unknown theorem-level depth remains unknown. Module imports never entail theorem
claims. Conditional transports retain all AND premises and failure boundaries.

## Incremental completion

1. Establish baseline and coordination ledger (no duplicate goal).
2. Author first 50 coherent distinct candidate cores in bounded topic batches.
3. Independently review mathematics/source/novelty, reject or repair defects,
   validate schema/hashes/duplicates/grouped splits and scoring fixtures.
4. Expand in additional bounded batches toward several hundred reviewed cores
   and wider graph areas. Fifty candidates alone is not completion.

No paid generation, training, GPU job or system administration is authorized.
Real baseline calls require separate endpoint/budget authorization. Public test
questions with public answers are reproducible diagnostics, not blind or known
contamination-free assessment. Private gold/raw generations stay outside the
public tree. Push only tested milestones to the working branch when authenticated;
never main or rewritten shared history. Missing GitHub credentials are a publishing
blocker, not a reason to stop substantive Python/NL work.
