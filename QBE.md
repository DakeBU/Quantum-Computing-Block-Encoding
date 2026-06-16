# QBE Dashboard

## Status

- Active task: `QBE-AUTO-002`
- Build gate: run `python3 tools/qbe.py check`
- Primary target: given a query operator \(A\), synthesize a block-encoding
  unitary \(U_A\), prove the block-entry and unitarity contract in Lean, and
  rank candidates by depth, gate count, auxiliary qubits, and unresolved oracle
  calls.
- Active paper benchmark: `QBE-AUTO-002`, the Guseynov-Huang-Liu Robin
  construction, used as the first source-backed training case for the platform.

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

Operator-construction and paper-benchmark modes must keep three views
synchronized:

- Lean source in `QuantumBlockEncoding/`
- Markdown conversion windows in `conversion-windows/`
- LaTeX proof maps in `paper-notes/`

In `operatorBlockEncoding` mode, the synchronized views must also record the
fixed operator \(A\), normalizer \(\alpha\), candidate unitary or circuit, and
`BlockEncodingCost`.  In `paperBenchmark` mode, the paper construction is a
fixed baseline; improvements belong in a separate operator/improvement task.

## Automation Memory

- Dialogue boards: `runs/<run-id>/dialogue.md`
- Trial log: `runs/trials.jsonl`
- Trial summary: `runs/trials_summary.csv`
- Compiled role contract: `QuantumBlockEncoding/Automation.lean`
