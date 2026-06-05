# Proof Blueprints

QBE proof blueprints are compact system-of-record snapshots for one task.

They are inspired by similar blueprint/DAG-control patterns in LeanMarathon,
but adapted to QBE's block-encoding target:

- Lean declarations are the correctness core;
- Markdown and LaTeX artifacts are the human proof map;
- proof obligations and cited-results ledgers keep unproved contracts explicit;
- dynamic leaf candidates tell lower agents which local proof node to attempt.

Refresh a blueprint before long runs:

```bash
python3 tools/qbe.py blueprint-refresh <task-id>
```
