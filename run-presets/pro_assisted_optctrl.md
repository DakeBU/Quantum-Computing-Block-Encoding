# Preset: pro_assisted_optctrl

Task: `QBE-OP-OPTCTRL-001`

Purpose: reproduce the Pro-assisted transfer-operator evolution attempt.  This
attempt is a legitimate ABEIS run because the ChatGPT Pro answer is treated as
an insight packet, not as an accepted proof.  The candidate becomes an achieved
solution only after Lean proves the block-encoding certificate.

## Input Policy

The run has three external-input channels:

1. the raw operator target in the task packet;
2. human expert comments through the dialogue board;
3. a ChatGPT Pro construction/proof idea copied into the insight pool.

The Pro packet should be self-contained: target operator, proposed unitary or
matrix action, clean-block proof sketch, unitarity proof sketch, resource
claim, and any assumptions.

## Reproducible Manual-Injection Shape

Create a cycle, add the Pro answer as an upper-level insight note, then let the
Hierarchical Harness formalize and verify it.

```bash
python3 tools/qbe.py run-cycle QBE-OP-OPTCTRL-001 \
  --cycle 1 \
  --context-mode focused \
  --blueprint-refresh

python3 tools/qbe.py agent-note latest \
  --role upper \
  --file path/to/pro-assisted-optctrl-insight.md

python3 tools/qbe.py sleep-run QBE-OP-OPTCTRL-001 \
  --cycles 999 \
  --active-budget-minutes 360 \
  --hierarchical-harness \
  --lower-count 3 \
  --fixed-capacity \
  --agent-cmd 'tools/codex_quota_wait.sh {root} {prompt}' \
  --execute \
  --check-each-cycle \
  --report-language zh \
  --context-mode focused \
  --blueprint-refresh
```

Recorded endpoint: `OptimalControl.evolvedEqFlipVerified` and
`OptimalControl.evolvedEqFlipZeroErrorApprox`, with resource tuple
`(gateCount, depth, auxiliaryQubits, oracleCalls) = (4,2,1,0)`.

For future reproductions, a fully scripted Pro-assisted profile may replace the
manual `agent-note` step by writing the Pro packet into
`candidate-populations/` before `sleep-run`.
