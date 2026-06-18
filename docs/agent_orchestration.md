# Agent Orchestration

QBE uses ARIS-style plain files, but the target is different: an overnight run
must move one query-operator task closer to a Lean-checked block-encoding
circuit certificate.

The implementation is intentionally local and inspectable:

- prompt decks live in `runs/<run-id>/`,
- agent dialogue lives in `runs/<run-id>/dialogue.md`,
- trial memory lives in `runs/trials.jsonl`,
- compressed run memory lives in `runs/trials_summary.csv`,
- the acceptance gate is `lake build && lake build Tests`.

![Layer-panel agent stack](assets/agent_stack.svg)

## Operational Contract

The automation is a four-role process over one shared repository.  It is not a
free-form chat room.

- Lean is the correctness source of truth.
- Markdown and LaTeX are the human proof map.
- `runs/trials.jsonl` and `runs/trials_summary.csv` are the memory that keeps
  later cycles from repeating failed work.
- `runs/<run-id>/dialogue.md` is the short handoff board.
- `runs/context-packs/` stores compact context packets for token-lean long
  runs.
- `runs/efficiency/` stores post-run efficiency reports.
- `python3 tools/qbe.py check` is the default gate.
- `.agents/skills/qbe-proof-diagnostics/SKILL.md` is the reviewer/middle
  checklist for hidden axioms, placeholders, suspicious semantic-flag
  promotions, and reusable proof-block memory.
- `proof-blueprints/<task-id>.md` is the compact system-of-record snapshot for
  the active task.  It is a QBE-specific adaptation of the blueprint/DAG
  control pattern studied in LeanMarathon.
- `QuantumBlockEncoding/Automation.lean` is the compiled process-contract
  layer.  Following the Lean4Agent workflow-verification pattern, it records
  role contracts, required artifacts, and workflow invariants such as
  certified-candidate promotion, closeout artifacts, and stale-route rejection.
  These checks audit the agent process; they do not replace the Lean theorem
  for the block encoding.

Every nontrivial cycle should leave four kinds of evidence:

- a Lean change, test, or explicit proof obligation,
- a Markdown/LaTeX correspondence update when paper notation is involved,
- a trial record explaining what changed or why the attempt was blocked.
- an article-facing update packet that tells the project technical report what
  can safely be updated and what must not be overclaimed.

## Three Strategy Modes

QBE deliberately separates three kinds of automation.

Operator block-encoding construction mode is the default.  The input is a
fixed operator \(A\), normalizer \(\alpha\), and clean-block convention.  Agents
search for candidate unitaries or circuits \(U_A\), prove unitarity and the
exact block-entry theorem in Lean, and compare candidates by
`BlockEncodingCost`: asymptotic scale first, then gate count, parallel depth,
auxiliary qubits, and unresolved oracle calls within a fixed concrete tier.

Paper benchmark mode is used for targets such as GHL2025.  The agents
translate the paper's construction as a fixed baseline, not as the whole
purpose of the project.  If a paper says "assume an oracle", the gap becomes a
circuit-level proof obligation unless the paper gives enough detail to
formalize the oracle.  The search policy is LBG-like proof-system maintenance:
record Lean feedback, failed proof routes, and reviewer findings; if a fixed
lemma fails, keep a small proof-attempt population under `proof-attempts/`.

Exploratory improvement mode starts from a paper benchmark or baseline
candidate and searches for a better implementation of the same operator
contract.  Agents may mutate and recombine circuit matrices, but only against
an explicit Lean-checkable acceptance predicate.  The search policy combines
LBG-like memory with an EoH-like candidate-evolution layer under
`candidate-populations/`.  Partial scores are search guidance; Lean proof
obligations decide acceptance.

The upper agent must identify the mode before broad lower-agent work begins.
The reviewer rejects any cycle that changes the operator contract, mutates a
paper benchmark inside the benchmark task, or treats a diagnostic score as a
theorem.

## Adaptive Layer Panels

Most inner cycles should stay cheap: one upper director, one middle
coordinator, lower workers, and a build gate.  When a long run reaches its
final audit, or when repeated failures show source, proof-DAG, or memory drift,
QBE can split the planning layers into bounded specialist panels.

Upper panel:

- target/source auditor: operator \(A\), normalizer, block projector, optional
  paper text, figures, register transcript, and cleanup;
- proof-DAG strategist: root theorem, active leaf, stale leaves, candidate
  families, and necessary-condition checks;
- process/memory auditor: trial logs, rejected routes, human reports, and
  compact retrieval state;
- director: synthesizes the three audits into one objective.

Middle panel:

- source-correspondence formalizer: source TeX, Lean declarations, and cited
  contracts;
- memory/retrieval curator: proof-DAG status, verifier feedback, stale target
  retirement, and compact context;
- report/export maintainer: preferred-language summaries, Markdown/LaTeX proof
  maps, and technical-report status;
- coordinator: writes exactly one lower-1 natural-language proof task, one
  lower-2 Lean implementation task, and one lower-3 verifier task.

The default 6h wrapper runs upper and middle panels only at the final audit.
Enable inner panels only when the run is demonstrably losing source
faithfulness or repeating stale work.

## LexElim Scheduling

QBE's candidate and proof-route scheduler is lexicographic.  It does not
collapse all feedback into one scalar reward.  The scheduler keeps an active
set of candidates or proof routes and filters them with this priority order:

```text
Lean-certified target correctness
> necessary-condition diagnostics
> asymptotic tier
> (gateCount, depth, auxiliaryQubits, oracleCalls)
> reusable proof-progress gain
> token/time cost
```

Use `LexElim-Out` for faithful paper-benchmark and theorem-closure work.  It
is deliberately conservative: the source theorem and Lean statement must be
correct before lower-priority resource or proof-progress signals matter.

Use `LexElim-In` for exploratory operator construction.  It uses all feedback
fields when choosing the next candidate pull, but only hard rejection or
certified domination retires a candidate.  Soft failures or high token cost
lower priority; they do not delete useful insight.

This scheduler determines agent count:

- If the next action is one precise Lean leaf, use one lower worker.
- If the task is exploratory or has mixed hard/soft feedback, use three lower
  roles in parallel: natural-language architect, Lean worker, and
  necessary-condition verifier.
- If source correspondence or memory is stale, run upper/middle panels before
  any lower workers.
- If a concrete Lean failure has a known class, add lower 4 as a reducer; do
  not use it as a fourth broad proof searcher.

## Blueprint And DAG Control

LeanMarathon's useful control lesson for QBE is that long Lean runs need a
durable blueprint, not only a long chat transcript.  QBE keeps the blueprint
split across Lean source, conversion windows, proof obligations, paper notes,
cited-results memory, and a compact generated snapshot:

```bash
python3 tools/qbe.py blueprint-refresh QBE-AUTO-002
python3 tools/qbe.py blueprint-status QBE-AUTO-002 --refresh
python3 tools/qbe.py write-context-pack QBE-AUTO-002 --cycle 1
```

In this document, a DAG is a directed acyclic graph.  For Lean work, its nodes
are source proof steps, Lean definitions, lemmas, external contracts, theorem
targets, and explicit obligations.  A directed edge `A -> B` says that `B`
depends on `A`.  Long theorem closure should prove active leaves first and
reuse them, instead of repeatedly asking a lower agent to attack the root
theorem.

The snapshot records:

- the current directive,
- the inferred stage,
- dynamic leaf candidates,
- open obligation signals,
- task-relevant Lean declarations,
- correspondence artifacts,
- the latest dialogue signal.

Use it before overnight work:

```bash
python3 tools/qbe.py run-cycle QBE-AUTO-002 \
  --cycle 1 \
  --lower-count 1 \
  --context-mode focused \
  --blueprint-refresh
```

Use `--lower-count 3 --context-mode full` instead when the target is still an
exploratory construction problem and the three lower roles must run in
parallel.

The upper/middle agents should retire stale leaves when the blueprint reports
that a lower target is already compiled.  The lower agent should work on one
dynamic leaf.  The reviewer should treat Lean plus proof-map correspondence as
the gate, not agent self-assessment.

When three lower agents are used, QBE deliberately mixes three proof modes:

- lower 1 is a natural-language proof architect.  It reads the source TeX,
  current Lean declarations, and proof obligations, then writes the dependency
  proof and active-leaf table.
- lower 2 is a Lean implementation worker.  It implements exactly one ready
  leaf from that table and runs `python3 tools/qbe.py check`.
- lower 3 is a necessary-condition verifier.  It checks exact finite matrix
  entries, path support, branch vanish/cancellation, register shape, or small
  convention identities that must hold before lower 2 spends a large Lean
  proof attempt.

This is not a weaker proof path.  Natural-language proof planning is used to
make the dependency graph small and source-faithful before Lean tactic search
spends tokens, and diagnostic checks reject wrong targets before Lean search
gets expensive.  Lower 4 should be used only as a refiner/reducer after a
specific Lean failure has been classified.

After a multi-hour run, write an efficiency report before planning the next
batch:

```bash
python3 tools/qbe.py efficiency-report --task QBE-AUTO-002
```

This mirrors the useful control surface from the sibling
Auto-Sampling-Theory-In-Sleep project: long runs should leave a compact status
artifact, not only a long terminal log.

## Project Article Update Loop

The middle agent also maintains the bridge from Lean/proof-cycle work to the
ABEIS technical report.  This adapts the useful ARIS paper-writing discipline
to theorem proving: every manuscript claim must be backed by Lean, a source
anchor, a cited-result row, a proof-attempt record, or an explicit obligation.

Every 6h/convergence closeout writes public-facing problem artifacts:

```text
runs/<run-id>/problem_export.tex
paper-notes/problem-exports/<task-id>/latest.tex
```

Maintainer runs may additionally request project-paper update packets:

```text
runs/<run-id>/article_update.md
runs/<run-id>/article_update.tex
paper-notes/problem-exports/<task-id>/latest.tex
```

If `../Auto_Proof_Papers/ABEIS/main.tex` exists, QBE also mirrors the latest
generated status into the local technical-report workspace only when the
maintainer explicitly enables the project-article update:

```text
../Auto_Proof_Papers/ABEIS/appendix/generated_cycle_status.tex
../Auto_Proof_Papers/ABEIS/problem_exports/<task-id>.tex
```

Use the command manually when needed:

```bash
python3 tools/qbe.py project-article-update <task-id> \
  --cycle 1 \
  --run-id latest
```

The generated status is safe to overwrite at closeout.  Polished report sections
should change only when a stable Lean theorem, source-contract correction,
reviewer finding, or system-design lesson is actually supported.

## Roles

Upper agent:

- acts as the human-intervention window,
- classifies the mode,
- chooses one cycle objective,
- defines non-goals,
- decomposes the task into middle/lower/reviewer packets,
- compresses useful memory into the next handoff.

Middle coordinator:

- owns the Lean/natural-language conversion layer during inner cycles,
- maps paper symbols to Lean declarations,
- maintains proof obligations and open assumptions,
- records success and failure memory,
- turns upper strategy into narrow lower-agent tasks.

Middle specialists, when enabled, split that work into source correspondence,
memory/retrieval, and report/export maintenance before the coordinator writes
the final lower packet.

Lower agents:

- lower 1 writes natural-language construction/proof DAGs tied to the fixed
  operator contract and, when present, the cited paper source,
- lower 2 implements exactly one assigned Lean leaf or candidate repair,
- lower 3 runs necessary-condition diagnostics and typed feedback, including
  finite unitarity, clean-block entry checks, cleanup checks, and schedule/depth
  checks,
- lower 4, when scheduled, refines a concrete Lean failure,
- all lower agents edit only the assigned scope and report blockers without
  changing the objective.

Reviewer:

- checks the diff, build result, and docs correspondence,
- looks for hidden oracle assumptions,
- checks normalizers, ancillas, `BlockEncodingCost`, resource counts, and
  citations,
- enforces operator-construction, paper-benchmark, and improvement-mode
  discipline,
- decides whether a gap should become an open problem.

## Cycle Anatomy

One cycle should look like this:

1. Upper reads the task, trial memory, dialogue, and current diff, then chooses
   the exact objective and mode.
2. Middle updates the operator/Lean/natural-language correspondence window,
   optional paper note, and proof-obligation ledger, then gives lower agents
   concrete candidate or Lean targets.  LaTeX export waits until 6h or
   convergence closeout.
3. Lower agents attempt those targets in narrow file scopes and run the gate
   when they edit Lean.
4. Reviewer audits the result, records blocking/advisory findings, and
   recommends the next smallest objective.

If a lower agent discovers that the assignment is too broad, it should record
the missing lemma or circuit as a proof obligation.  If it proposes a different
candidate \(U_A\), it must keep the same target operator and record the
candidate score separately.

## Create A Prompt Deck

```bash
cd /path/to/Auto-Quantum-Computing-Bloack-Encoding-In-Sleep
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 3
```

This creates a directory like:

```text
runs/20260517-153000-QBE-AUTO-001-cycle01/
  00_context.md
  10_upper_director.md
  20_middle_formalizer.md
  30_lower_searcher_1.md
  30_lower_searcher_2.md
  30_lower_searcher_3.md
  40_reviewer.md
  90_handoff.md
  dialogue.md
```

You can give each prompt file to a separate coding agent. They do not need to
share a chat window. Their shared state is the repository plus `dialogue.md`.

## Make Agents Converse

The simplest conversation protocol is a shared board:

```bash
python3 tools/qbe.py agent-note latest --role upper \
  --message "Cycle objective: formalize the Robin one-term normalizer and reject any construction that leaves the coefficient oracle abstract."

python3 tools/qbe.py agent-note latest --role middle \
  --message "Mapped A, U, alpha, and ancilla projector. Missing: concrete coefficient state-preparation circuit."

python3 tools/qbe.py agent-note latest --role lower \
  --message "Attempted diagonal coefficient encoding; blocked because coefficient arithmetic circuit is not represented yet."

python3 tools/qbe.py agent-note latest --role reviewer \
  --message "This should be promoted to an arithmetic-oracle open problem unless a gate-level coefficient circuit is added."
```

The dialogue board is markdown, so a human can edit it directly if that is more
convenient.

## Trial Memory

Every serious attempt should be logged:

```bash
python3 tools/qbe.py trial-log \
  --task QBE-AUTO-001 \
  --role lower \
  --kind attempt \
  --status blocked \
  --lean-gate not-run \
  --from-git \
  --notes "Diagonal coefficient encoding needs an explicit reversible arithmetic circuit."

python3 tools/qbe.py trial-summary
```

This follows the useful part of the Learning Beyond Gradients artifact pattern:
append rich JSONL records, then rewrite a small CSV summary after each attempt.
The JSONL file preserves detail; the CSV gives the upper agent a short memory.

QBE also uses a MathCode-like theorem-reuse discipline: useful proved Lean
fragments should become named declarations rather than being rediscovered in
future runs.  For QBE, the reusable fragments are usually finite index
conversions, signal-zero projection lemmas, branch-decomposition lemmas,
normalizer algebra, dagger-entry bridges, and gate-list/matrix-product
semantics.  See `docs/mathcode_reference_notes.md`.

## Overnight Pattern

Dry run first:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 3 --lower-count 3 --dry-run
```

This only creates prompt decks and trial records. It does not call any external
agent.

When you have a local agent CLI, pass it as an execution template. The template
can use these placeholders:

- `{root}`: repository root,
- `{prompt}`: prompt file path,
- `{run_dir}`: run directory,
- `{task}`: task id,
- `{cycle}`: cycle number,
- `{role}`: inferred agent role.

Example shape:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 \
  --cycles 8 \
  --lower-count 3 \
  --blueprint-refresh \
  --agent-cmd 'cd {root} && codex exec --full-auto "$(cat {prompt})"' \
  --execute \
  --check-each-cycle
```

Adjust the `codex exec` flags to the CLI you actually use. The QBE side only
requires that the command reads the prompt, edits the repository if needed, and
returns a process exit code.

## Focused Proof Burst

When upper and middle have already identified a fixed Lean theorem, do not run
a full upper/middle/lower/reviewer cycle on every iteration.  That pattern is
useful for planning, but it is token-expensive during local theorem closure.

Use a full planning cycle when the route is unclear:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-002 \
  --cycles 1 \
  --lower-count 3 \
  --context-mode full \
  --blueprint-refresh \
  --agent-cmd 'cd {root} && codex exec --dangerously-bypass-approvals-and-sandbox "$(cat {prompt})"' \
  --execute \
  --check-each-cycle
```

Use focused proof burst mode after the target is fixed:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-002 \
  --cycles 12 \
  --lower-count 1 \
  --context-mode focused \
  --blueprint-refresh \
  --upper-every 6 \
  --middle-every 6 \
  --reviewer-every 6 \
  --agent-cmd 'cd {root} && codex exec --dangerously-bypass-approvals-and-sandbox "$(cat {prompt})"' \
  --execute \
  --check-each-cycle
```

In focused mode, prompt decks still exist for all roles, but only the selected
roles are executed in a given cycle.  The lower agent runs every cycle.  Upper,
middle, and reviewer are periodic safeguards: they should re-plan only when the
fixed theorem changes, the lower agent repeatedly produces only restated
obstructions, or Lean failures indicate a source-contract mismatch.

This is the preferred setting for faithful-paper theorem closure after the
source proof has already been audited.

## Stop Conditions

Stop or require human review when:

- Lean fails and the reviewer cannot localize the error,
- a lower agent edits outside its assigned scope,
- a paper assumption cannot be converted into a circuit-level target,
- trial summaries repeat the same failure without a new construction idea,
- the proof would need a theorem not yet represented in the project.

In those cases, promote the gap into `proof-obligations/` or
`open-problem-proposals/` instead of pretending the oracle is solved.
