# Preset: main_case_hierarchical_reproduction

Purpose: reproduce the transfer-operator main case under the current ABEIS
Hierarchical Harness, using two isolated arms.

Target:

$$
E_k = |0\rangle\langle k|_T \otimes |0\rangle\langle 1|_\tau \otimes I_S .
$$

The benchmark instantiation uses `r = 1`, `k = 1`, and one passive qubit.

## Arm A: no-Pro isolated run

```bash
python3 tools/qbe.py sleep-run QBE-MAIN-CASE-HIER-COLD-001 \
  --cycles 999 \
  --active-budget-minutes 90 \
  --hierarchical-harness \
  --lower-count 4 \
  --adaptive-capacity \
  --agent-cmd 'tools/codex_prompt_agent.sh {root} {prompt}' \
  --execute \
  --check-each-cycle \
  --report-language zh \
  --context-mode focused \
  --blueprint-refresh
```

## Arm B: Pro-assisted isolated run

```bash
python3 tools/qbe.py sleep-run QBE-MAIN-CASE-HIER-PRO-001 \
  --cycles 1 \
  --active-budget-minutes 45 \
  --hierarchical-harness \
  --lower-count 4 \
  --adaptive-capacity \
  --agent-cmd 'tools/codex_prompt_agent.sh {root} {prompt}' \
  --execute \
  --check-each-cycle \
  --report-language zh \
  --context-mode focused \
  --blueprint-refresh

python3 tools/qbe.py agent-note latest \
  --role upper \
  --file task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md

python3 tools/qbe.py sleep-run QBE-MAIN-CASE-HIER-PRO-001 \
  --cycles 999 \
  --active-budget-minutes 90 \
  --hierarchical-harness \
  --lower-count 4 \
  --adaptive-capacity \
  --agent-cmd 'tools/codex_prompt_agent.sh {root} {prompt}' \
  --execute \
  --check-each-cycle \
  --report-language zh \
  --context-mode focused \
  --blueprint-refresh
```

## Closeout expectation

Each arm should write:

- `reports/<task-id>/latest.md`
- `reports/<task-id>/zh_summary.md`
- `reports/<task-id>/figures/`
- `paper-notes/problem-exports/<task-id>/latest.tex`
- `executable-exports/<task-id>/qiskit/` after a named Lean certificate exists
- `cycle-pro-prompt` if the arm stops before meeting its target

Only Lean-certified candidates may be plotted as achieved candidates.  Pro,
human, simulator, or Python ideas may enter the harness as external input
events, but they remain unaccepted until promoted by a Lean theorem.
