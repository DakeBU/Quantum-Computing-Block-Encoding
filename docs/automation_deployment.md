# QBE Automation Deployment Mode

This project adapts the ARIS idea of plain-file autonomous research workflows to
a Lean-first block-encoding proof project.  It also adapts the trial-memory
pattern from [Learning Beyond Gradients](https://trinkle23897.github.io/learning-beyond-gradients/)
and its [artifact repository](https://github.com/Trinkle23897/learning-beyond-gradients):
append detailed JSONL records, then rewrite compact summaries for future
agent iterations.

ARIS optimizes the loop:

```text
papers -> ideas -> experiments -> reviews -> paper
```

QBE uses the analogous proof loop:

```text
papers/open problems -> formal specs -> circuit search -> Lean proofs -> review -> docs
```

## Core Contract

Every automated run must preserve:

```bash
lake build && lake build Tests
```

The repository is allowed to contain skeletons and planned work, but completed
claims must compile.

## Two Hybrid Strategy Modes

QBE supports two explicit automation modes.  Both use trial memory and Lean
gates, but they use different search policies.

### Faithful Paper Reproduction

Use this mode when the goal is to reproduce an existing paper, such as the
GHL2025 Robin-boundary construction.  The upper agent should state that the
cycle is faithful mode, and lower agents should only implement definitions,
lemmas, circuit matrices, tests, or proof obligations that are needed for the
paper's construction.

Faithful mode rules:

- do not replace the paper construction with a new oracle,
- keep every unimplemented oracle as a named proof obligation,
- when a fixed lemma fails, record proof routes under `proof-attempts/` instead
  of changing the statement,
- update the Markdown/LaTeX proof map whenever Lean declarations move,
- prefer one lower worker per cycle when the target is delicate,
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
- record all failed constructions in the trial memory,
- promote repeated failures to open-problem proposals,
- keep reusable circuit lemmas in shared Lean modules,
- do not mark a construction complete until Lean checks the target.

The two modes share infrastructure, but their scientific standards are
different.  Faithful mode teaches the system how existing constructions work;
exploratory mode reuses that knowledge to search under new assumptions.

## Artifact Layout

```text
tasks/                 task contracts and progress logs
conversion-windows/    synchronized Lean/LaTeX/Markdown workspaces
paper-notes/           optional LaTeX derivations and theorem sketches
docs/                  human-readable roadmaps and explanations
QuantumBlockEncoding/  Lean source of truth
Tests/                 Lean build smoke tests
tools/qbe.py           stable local command surface for agents
.agents/skills/        project-local workflow prompts
```

## Three-Layer Agent Stack

The compiled contract in `QuantumBlockEncoding/Automation.lean` defines four
roles:

- upper: human-facing strategy, mode selection, and memory compression,
- middle: Lean/LaTeX/Markdown synchronization plus success/failure memory,
- lower: assigned Lean/circuit implementation attempts,
- reviewer: build, citation, resource, hidden-oracle, and mode-discipline
  review.

Generate one role deck:

```bash
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 2
```

Generate repeated decks:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 8 --lower-count 3 --dry-run
```

See `docs/agent_orchestration.md` and `docs/sleep_run_guide.md`.

## Faithful Agent Loop

1. Select a paper target from `Literature.lean` or `tasks/`.
2. Create or update a task contract that says the target is faithful mode.
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
