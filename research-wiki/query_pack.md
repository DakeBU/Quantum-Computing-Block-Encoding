# Query Pack

Compressed context for agents.  Keep this short enough to paste into a new
session.

## Current Focus

- Finish the GHL2025 Robin target from faithful skeleton into concrete Lean
  circuit matrix semantics.
- Use `QBE-AUTO-002` for the semantics backend, then return to `QBE-AUTO-001`
  to close the Robin block-extraction statement.

## Important Constraints

- Lean build gate is mandatory.
- New open problems need Lean-checkable acceptance tests.
- Trial results go to `runs/trials.jsonl` and `runs/trials_summary.csv`.
- Upper/middle/lower/reviewer agents coordinate through `runs/<run-id>/dialogue.md`.
- Faithful paper mode must update Lean, Markdown conversion windows, and LaTeX
  proof maps together.

## Key Docs

- `docs/agent_orchestration.md`
- `docs/sleep_run_guide.md`
- `docs/article_to_lean_workflow.md`
