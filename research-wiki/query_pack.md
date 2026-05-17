# Query Pack

Compressed context for agents.  Keep this short enough to paste into a new
session.

## Current Focus

- Finish primary target skeleton into concrete Lean semantics.
- Use `QBE-AUTO-001` as the first multi-agent proof-search target.

## Important Constraints

- Lean build gate is mandatory.
- New open problems need Lean-checkable acceptance tests.
- Trial results go to `runs/trials.jsonl` and `runs/trials_summary.csv`.
- Upper/middle/lower/reviewer agents coordinate through `runs/<run-id>/dialogue.md`.

## Key Docs

- `docs/agent_orchestration.md`
- `docs/sleep_run_guide.md`
- `docs/article_to_lean_workflow.md`
