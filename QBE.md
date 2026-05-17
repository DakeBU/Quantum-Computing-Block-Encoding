# QBE Dashboard

## Status

- Active task: none
- Build gate: run `python3 tools/qbe.py check`
- Primary target: Guseynov-Huang-Liu Robin block encoding skeleton

## Operating Rule

No task is complete until:

```bash
lake build && lake build Tests
```

succeeds.

## Next Steps

1. Run `python3 tools/qbe.py next-task`.
2. Create a conversion window with `python3 tools/qbe.py conversion-window <task-id> --title "..."`
3. Create a multi-agent run deck with `python3 tools/qbe.py run-cycle <task-id> --lower-count 2`.
4. Log attempts with `python3 tools/qbe.py trial-log ...`.
5. Read `docs/agent_orchestration.md`, `docs/sleep_run_guide.md`, and
   `docs/article_to_lean_workflow.md`.

## Automation Memory

- Dialogue boards: `runs/<run-id>/dialogue.md`
- Trial log: `runs/trials.jsonl`
- Trial summary: `runs/trials_summary.csv`
- Compiled role contract: `QuantumBlockEncoding/Automation.lean`
