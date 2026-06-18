# Runs

This directory is the local persistent memory for unattended ABEIS agent work.
Only this README is tracked in the public repository; generated run logs and
prompt decks are intentionally ignored.

Generated files:

- `trials.jsonl`: append-only records of plans, attempts, builds, reviews, and
  handoffs.
- `trials_summary.csv`: compact summary rewritten from the JSONL log.
- `<run-id>/`: one prompt deck, dialogue board, summaries, Pro prompt, and
  handoff files for a cycle or convergence batch.

Create one prompt deck:

```bash
python3 tools/qbe.py run-cycle <task-id> --cycle 1 --lower-count 2
```

Create repeated decks without executing external agents:

```bash
python3 tools/qbe.py sleep-run <task-id> --cycles 8 --lower-count 3 --dry-run
```

Every completed run should record:

- task id,
- agent role,
- attempted construction or proof change,
- changed files,
- Lean build-gate result,
- next handoff.
