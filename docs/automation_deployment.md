# QBE Automation Deployment Mode

This project adapts the ARIS idea of plain-file autonomous research workflows to
a Lean-first block-encoding proof project.  It also adapts the trial-memory
pattern from [Learning Beyond Gradients](https://trinkle23897.github.io/learning-beyond-gradients/)
and its [artifact repository](https://github.com/Trinkle23897/learning-beyond-gradients):
append detailed JSONL records, then rewrite compact summaries for future
agent iterations.  It preserves a Learning-Beyond-Gradients-like
upper/middle/lower plus reviewer hierarchy for maintaining the proof system
across cycles.  It also studies similar Lean-agent patterns in
[MathCode](https://github.com/math-ai-org/mathcode), especially proof
diagnostics, theorem-store-like reuse, persistent proof feedback,
tree-of-subgoals decomposition, and skills/tools/plugins.  It also studies the
blueprint/DAG-control pattern in
[LeanMarathon](https://github.com/YuanheZ/LeanMarathon) and its
[paper](https://arxiv.org/abs/2606.05400): target review before broad proving,
dynamic leaves, bounded worker/refiner roles, and deterministic gates.
Exploratory construction mode also preserves an
[EoH](https://github.com/FeiLiu36/EoH)-like population layer for evolving
candidate circuit/oracle families under a fixed acceptance predicate.
For lexicographic candidate selection, it adds a LexElim-style scheduler
inspired by Xue--Wan--Lu--Zhang's lexicographic bandit algorithms.  QBE uses
the scheduler pattern, not the stochastic-bandit sample-complexity theorem:
candidate circuits and proof routes are active arms, and feedback is a vector
of hard and soft signals.

ARIS optimizes the loop:

```text
papers -> ideas -> experiments -> reviews -> paper
```

QBE uses the analogous proof loop:

```text
papers/open problems -> formal specs -> circuit search -> Lean proofs -> review -> docs
```

The LeanMarathon-like QBE control layer is:

```text
task + source proof + Lean declarations
  -> proof-blueprint snapshot
  -> dynamic leaf lower work
  -> Lean gate and reviewer
  -> refiner-style repair of connected obstruction areas
```

These layers are complementary.  LeanMarathon-style harness control does not
replace the LBG-like role hierarchy or the EoH-like exploratory population.  It
adds a stronger system-of-record and dynamic-leaf discipline so the existing
upper/middle/lower/reviewer loop spends fewer tokens on stale or drifted proof
targets.

## Layered Architecture

| Layer | Similar pattern | QBE use |
|---|---|---|
| Plain-file substrate | ARIS | Skills, manifests, task files, conversion windows, wiki, reviews, and run logs. |
| Iterative controller | Learning Beyond Gradients | Upper/middle/lower/reviewer cycles, trial memory, failure compression, and proof-system maintenance. |
| Exploratory search | EoH | Candidate populations for new circuit/oracle constructions, only in exploratory mode. |
| Lexicographic scheduler | Xue--Wan--Lu--Zhang 2026 | Active-set filtering with hard Lean gates, necessary diagnostics, asymptotic tiers, and `(gateCount, depth, auxiliaryQubits, oracleCalls)` in priority order. |
| Lean harness control | LeanMarathon | Proof-blueprint snapshots, target review, dynamic leaves, refiner-style repair, and deterministic gates. |
| Proof diagnostics | MathCode | Hidden-assumption scans, theorem-reuse memory, and proof-attempt diagnostics. |

QBE's advantage is the domain boundary: each layer is specialized to
gate-level quantum block-encoding work rather than generic empirical research,
generic heuristic design, or generic Lean autoformalization.

## Core Contract

Every automated run must preserve:

```bash
lake build && lake build Tests
```

The repository is allowed to contain skeletons and planned work, but completed
claims must compile.

## Three Strategy Modes

QBE supports three explicit automation modes.  All use trial memory and Lean
gates, but they use different search policies.

### Operator Block-Encoding Construction

Use this mode when the user gives a target operator \(A\), normalizer
\(\alpha\), and clean-block convention.  The agents search for candidate
unitaries or circuits \(U_A\), prove the exact block-entry and unitarity
statements in Lean, and rank candidates by asymptotic scale first, then gate
count, parallel depth, auxiliary qubits, and unresolved oracle calls within one
concrete tier.

Operator mode rules:

- keep the operator contract fixed,
- store alternative candidates under `candidate-populations/`,
- use `LexElim-In`: all feedback fields may guide the next candidate pull, but
  lower-priority proof-progress or token-cost signals cannot override Lean
  correctness, necessary diagnostics, asymptotic tier, or resource tuple order,
- use parser/unit-test/simulator-style checks only as necessary-condition
  diagnostics,
- accept only Lean-closed block-entry and unitarity theorems.

### Paper Benchmark

Use this mode when the goal is to reproduce an existing paper, such as the
GHL2025 Robin-boundary construction.  The upper agent should state that the
cycle is paper-benchmark mode, and lower agents should only implement
definitions, lemmas, circuit matrices, tests, or proof obligations that are
needed for the paper's construction.

Paper-benchmark rules:

- do not replace the paper construction with a new oracle,
- keep every unimplemented oracle as a named proof obligation,
- when a fixed lemma fails, record proof routes under `proof-attempts/` instead
  of changing the statement,
- update the Markdown/LaTeX proof map whenever Lean declarations move,
- use `LexElim-Out`: filter proof routes layer by layer, and do not compare
  lower-priority resource improvements before the source theorem and Lean
  statement are correct,
- prefer one lower worker per cycle when one exact proof leaf is already
  selected; use three lower roles when proof architecture, Lean implementation,
  and necessary diagnostics are genuinely separate,
- use reviewer findings to prevent hidden oracle assumptions.

### Exploratory Construction

Use this mode when the paper or open problem lacks a concrete gate-level
construction and the goal is to search for one.  This is where QBE is allowed
to use AI as a construction engine.

Exploratory mode rules:

- start from a precise acceptance predicate,
- maintain candidate circuit families under `candidate-populations/` when
  multiple construction ideas compete,
- allow EoH-like mutation, recombination, selection, and archive pressure only
  inside that candidate space,
- use LexElim-In active-set filtering so hard rejection and certified
  domination retire candidates, while soft failures only reduce priority,
- record all failed constructions in the trial memory,
- promote repeated failures to open-problem proposals,
- keep reusable circuit lemmas in shared Lean modules,
- do not mark a construction complete until Lean checks the target.

The two modes share infrastructure, but their scientific standards are
different.  Faithful mode teaches the system how existing constructions work;
exploratory mode reuses that knowledge to search under new assumptions.

## MathCode-Inspired Diagnostics

QBE should use MathCode-like diagnostics without changing QBE's acceptance
standard:

- scan for `sorry`, `admit`, forbidden `axiom`/`constant`/`postulate`, and
  suspicious semantic-flag promotions;
- record useful failed proof routes in `proof-attempts/` instead of losing
  them in chat history;
- turn repeated successful local arguments into named Lean declarations;
- use tree-of-subgoals decomposition only as proof-attempt scaffolding, never
  as committed accepted proof with placeholders;
- keep a future backlog item for focused Lean checks or persistent Lean
  feedback, while retaining the full `lake build && lake build Tests` gate.

See `docs/mathcode_reference_notes.md` and
`.agents/skills/qbe-proof-diagnostics/SKILL.md`.

## Artifact Layout

```text
tasks/                 task contracts and progress logs
conversion-windows/    synchronized Lean/LaTeX/Markdown workspaces
paper-notes/           optional LaTeX derivations and theorem sketches
proof-obligations/     explicit unproved theorem/circuit obligations
proof-blueprints/      compact task system-of-record snapshots
docs/                  human-readable roadmaps and explanations
QuantumBlockEncoding/  Lean source of truth
Tests/                 Lean build smoke tests
tools/qbe.py           stable local command surface for agents
.agents/skills/        project-local workflow prompts
```

The public/user closeout path writes preferred-language summaries, compact
memory, and problem-specific LaTeX proof notes.  Synchronizing the ABEIS
authors' technical report is maintainer infrastructure and requires an
explicit maintainer command such as `project-article-update` or
`sleep-run --project-article-update`.

## Layer-Panel Agent Stack

The compiled contract in `QuantumBlockEncoding/Automation.lean` defines four
roles:

- upper: human-facing strategy, mode selection, and memory compression,
- middle: Lean/LaTeX/Markdown synchronization plus success/failure memory,
- lower: proof DAG, Lean implementation, and necessary-condition diagnostics,
- reviewer: build, citation, resource, hidden-oracle, and mode-discipline
  review.

Generate one role deck:

```bash
python3 tools/qbe.py run-cycle QBE-AUTO-001 \
  --cycle 1 \
  --lower-count 3 \
  --blueprint-refresh
```

Generate repeated decks:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 8 --lower-count 3 --dry-run
```

See `docs/agent_orchestration.md` and `docs/sleep_run_guide.md`.

For theorem-closure work where upper and middle have already fixed the Lean
target, use focused proof burst mode instead of repeating the full role stack
every cycle:

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

This keeps Lean build gates on every cycle while reducing repeated planning
tokens.  It should be used only after a full planning cycle has identified a
single theorem or a single strictly smaller obstruction as the lower-agent
target.

### Exploratory Improvement

Use this mode after a paper benchmark or baseline candidate exists and the
goal is to improve the same operator contract.  The target \(A\) and block
predicate remain fixed, but candidate circuits may be mutated, recombined, and
ranked by `BlockEncodingCost`.

### Mixed-Backend Agent Profiles

ABEIS does not hard-code one model vendor.  The harness can dispatch different
roles, and different lower slots, to different installed agent backends:
Codex, Claude, GPT/OpenAI wrappers, Gemini, GLM, Minimax, deterministic local
scripts, or custom shell commands.  This mirrors the ARIS-style principle that
the user controls the research workflow, while ABEIS keeps Lean as the final
certificate gate.

Profiles live under `agent-profiles/`.  A profile maps prompt stems or role
keys to command templates.  Prompt-stem keys such as `30_lower_searcher_1`
win first, then slot keys such as `lower1`, then role keys such as `lower`,
then `default`.

```bash
python3 tools/qbe.py sleep-run QBE-OP-001 \
  --cycles 4 \
  --lower-count 3 \
  --parallel-lower \
  --agent-profile mixed-vendors.example.json \
  --execute \
  --check-each-cycle
```

The useful default split for hard block-encoding work is:

- upper: strongest target-audit and planning model available,
- middle: model or toolchain that is good at Lean/natural-language
  correspondence and memory compression,
- lower1: natural-language construction/proof architect,
- lower2: Lean implementation worker,
- lower3: deterministic or model-assisted necessary-condition verifier,
- reviewer: independent backend when possible.

This profile mechanism changes search diversity and cost.  It does not change
what counts as success: only named Lean declarations and the configured build
gate certify a block-encoding candidate.

## Paper-Benchmark Agent Loop

1. Select a paper target from `Literature.lean` or `tasks/`.
2. Create or update a task contract that says the target is paper-benchmark
   mode.
3. Create a conversion window with `tools/qbe.py conversion-window`.
4. Translate paper notation into Lean declarations.
5. Add circuit semantics and tests in small steps.
6. Add proof obligations for every unproved oracle or resource claim.
7. Run `tools/qbe.py check`.
8. Update Markdown and LaTeX so a human can compare Lean with the source paper.

Every substantial attempt should also run:

```bash
python3 tools/qbe.py trial-log --task <task-id> --role lower --kind attempt --status blocked --notes "..."
python3 tools/qbe.py trial-summary
```

## Exploratory Open Problem Loop

When an agent discovers that a paper assumes an oracle without an implementable
gate-level construction:

1. Add a candidate to `OpenProblems.lean`.
2. Include a precise acceptance test.
3. Create a Markdown expansion in `docs/open_problems.md`.
4. If a construction idea exists, create a task under `tasks/`.
5. Keep the problem open until the Lean certificate exists.

## Conversion Window Discipline

The conversion window is the user's interface between mathematical prose and
Lean:

- LaTeX keeps the paper notation.
- Markdown explains the construction and choices.
- Lean names the exact declarations and checks them.

A symbol that cannot be mapped should become a missing-definition or
proof-obligation item, not an implicit assumption.

See `docs/article_to_lean_workflow.md` for the full paper-to-Lean process.

## Suggested First Automation Targets

1. Finish `GHL2025.oneTermRobinClaim` from skeleton to concrete matrix
   semantics.
2. Add gate semantics for `Circuit`.
3. Formalize the sparse-access oracle resource counts.
4. Add a real proof obligation ledger for the Robin heat example.
5. Convert one planned paper from `Literature.lean` into a skeleton module.
