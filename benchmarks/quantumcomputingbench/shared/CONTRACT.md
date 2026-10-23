# One mathematical core, compatible reader and formal views

QuantumComputingBench has one graph-grounded mathematical core registry.
`tracks/non-lean/` and `tracks/lean/` are contribution/view namespaces, not
independent datasets with independent core counts. Frozen historical releases
remain where they are; reader pages resolve their exact admitted source records.

## Binding rules

1. Reuse an existing `core_id` when the mathematical target, assumptions and
   requested reasoning are the same. A Lean translation, proof syntax task,
   paraphrase or numerical variant is a view, not a new mathematical core.
2. Every view binds `core_id`, `contract_hash`, graph snapshot, source identities,
   family and split. A changed mathematical contract is a successor requiring
   semantic review; changing the hash is not permission to invent a new core.
3. All views and target-solution aliases share one split. If existing frozen
   splits conflict, quarantine the affected composition rather than moving a
   test answer into training or rewriting history.
4. Graph import/ownership edges, reviewed mathematical prerequisites and
   conditional Hypergraph transports remain distinct. Preserve every AND premise
   and failure boundary. A navigation path is not a certified proof chain.
5. NL mathematical/source review, formal target alignment, fixed reference
   compilation and isolated prediction evaluation are separate evidence fields.
   Reading Lean source or finding a declaration never means a new proof ran.
6. Proposed aliases, external collaborator acknowledgment and reviewer identities
   must describe real decisions/actions. Their existence is not inferred from a
   file, a shared target node or a successful script.
7. Retained cores bind their frozen benchmark graph snapshot, not an unversioned
   live website. New library nodes require a separately generated/reviewed snapshot
   before proposal admission. Do not patch a frozen snapshot or silently mix node
   identities/source hashes across graph versions. Submit the refresh request and
   source evidence with your candidate if the current registry lacks its anchor.
8. A withheld core remains reserved in `withheld_cores`, with its original
   contract, graph scope, family and split. It is not current gold. Proposing a
   correction does not restore it automatically, and withdrawal does not erase
   its stable-release obligation. Question changes require an explicit reviewed
   successor; an answer-only repair cannot silently alter the original premises.
9. The first question-contract correction uses an explicit version-2 successor
   with a distinct content-bound contract-change review. It binds the entire
   predecessor, both contract hashes, changed question, complete new answer and
   rubric. The reader displays the revision; the original stays audit-only.
   This does not assert equivalence of old and new requested reasoning. Core,
   family, split, graph/source scope and support-step count stay reserved. A
   companion bound to the old hash is stale, not automatically upgraded. The
   current implementation supports one first correction per frozen core;
   further chains or changes outside the explicitly supported migrations require
   a separately designed and reviewed migration, not an extra JSON override.
   Payload schema `qcb.textbook_question_successor.v1` changes only the question.
   Schema `qcb.textbook_question_successor.v2` additionally requires an explicit,
   changed nonempty convention list. It still denotes question version 2, not a
   second correction. A distinct `independent-question-convention-successor-review`
   binds both literal convention lists, both whole contract hashes, the whole
   candidate digest and `changed_contract_fields: ["question", "conventions"]`,
   with substantive reconstruction and separate contract/convention assessments.
   No other contract field is overridable. Historical conventions appear only
   in the folded revision audit, not among active premises. Browser acceptance
   must check this distinction before a stable gate can pass.

## Explicit assumption corrections

Payload schema `qcb.textbook_question_successor.v3` is a narrow alternative to
V1/V2, not permission to combine them or make a second correction. It still
means the **first question version 2**. Its exact payload shape is V1 plus
`assumptions`; only `question` and `assumptions` may change among the nine
contract fields. The ordered assumptions must be nonempty, different and free
of blank or trim-equivalent duplicate strings. Literal bytes are not normalized
when computing contracts. Conventions, graph/source scope, family and split are
not overridable. A complete summary, answer, rubric and all original ordered
per-step node assignments remain required.

A new, genuinely distinct `independent-assumption-successor-review` must bind
the complete candidate/predecessor, both centrally recomputed contracts,
literal `original_assumptions` and `current_assumptions`, and exactly
`changed_contract_fields: ["question", "assumptions"]`. It includes substantive
reconstruction, contract-change and assumption-change assessments. The
`assumption_edit_map` covers every old/new index exactly once. Each entry has
`disposition`, `old_index`, `new_index`, `old_assumption`, `new_assumption` and
`reason`; retained literals must be equal, replaced literals different, and the
absent side of an added/removed entry is null. Plan208's bounded correction may
replace index0 only: precision assumption index1 stays literally at index1.

The fixed `semantic_slot_assessment` addresses domain/quantifiers,
target/normalization, phase/registers, error/success, source/convention
noninterference and oracle/resource model. These are real review obligations,
not a truth classifier implemented by string fields. An impeccable JSON record
does not establish mathematical truth, real independence or expert approval.
An obstruction report or implementation-design review is not approval of a
complete new candidate. Maintainer inspection of the actual mathematics is
still necessary, including any hidden weakening expressed in prose.

Current premises appear before the question; both old/current lists and
contract hashes are disclosed in the folded revision audit. A historical
assertion may be quoted for refutation elsewhere, but is not an active premise.
Prompts, downloads, grading and formal-view proposals must bind the resolved
current object. Active task/context identities are recomputed; old identities,
validation and receipts are audit-only, and old Lean companions do not transfer.
The actual browser report must check exact active/historical premise lists and
bind the new reader-source digest. Missing, stale or rejected review withholds
the core, with no fallback to the old answer. Implementing this migration alone
does not restore any withheld core or satisfy a stable-release gate.

## Concurrent collaborators

Before authoring, fetch current main, read the registry and open contribution PRs,
and inspect the proposed topic/core reservations. Work on separate branches.
Use UUID-named files under your track's `proposals/`, with an existing core ID
or an explicitly unadmitted candidate ID, a proposed contract and the required
source/review fields. Do not edit frozen datasets or the other track's files.

Reservations in a branch are advisory, not a global lock. Merge-time validation
rejects incompatible contracts for the same core, split/family conflicts and
duplicate views. Maintainer semantic reconciliation resolves independently
proposed IDs before either is counted as new. Neither collaborator may turn a
local counter or an unmerged PR into a claim of global exclusivity.

A non-Lean collaborator can author mathematics, complete solutions and rubrics
without installing Lean. A Lean collaborator attaches a formal view to the same
core when the target is equivalent, or returns a typed mismatch/obligation.
Neither silently strengthens hypotheses to make a proof compile. New production
library work follows the library publication protocol in addition to this one.

## Publication

The textbook presents admitted core content once, with separate reader/formal
paths and reciprocal links. Provisional/quarantined material stays in an audit
area, never an exercise answer or current training export. The public edition
states which chapters are source-reviewed, locally formalized, planned, or still
under editorial review. Stable presentation is not a claim of full-graph coverage,
novel theorem discovery, universal PRM truth or sandbox acceptance.
