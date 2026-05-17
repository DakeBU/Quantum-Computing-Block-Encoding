# Runs

This directory is the persistent memory for unattended QBE agent work.

Generated files:

- `trials.jsonl`: append-only records of plans, attempts, builds, reviews, and
  handoffs.
- `trials_summary.csv`: compact summary rewritten from the JSONL log.
- `<run-id>/`: one prompt deck, dialogue board, and handoff file for a cycle.

Create one prompt deck:

```bash
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 2
```

Create repeated decks without executing external agents:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 8 --lower-count 3 --dry-run
```

Every completed run should record:

- task id,
- agent role,
- attempted construction or proof change,
- changed files,
- Lean build-gate result,
- next handoff.
