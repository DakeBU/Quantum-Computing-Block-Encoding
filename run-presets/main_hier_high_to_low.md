# Preset: main_hier_high_to_low

Task: `QBE-OP-OPTCTRL-COLD-CLEAN-001`

Purpose: reproduce the no-Pro Hierarchical Harness attempt for the transfer
operator

$$
E_k = |0\rangle\langle k|_{\mathrm{time}}
      \otimes |0\rangle\langle 1|_{\mathrm{type}}
      \otimes I .
$$

This preset is intentionally two-phase.

## Phase 1: High-Capacity Exact Search

Use this phase to let the Hierarchical Harness search broadly for an exact
block encoding.  This matches the high-budget stage of the recorded
`main_hier` attempt.

```bash
python3 tools/qbe.py sleep-run QBE-OP-OPTCTRL-COLD-CLEAN-001 \
  --cycles 999 \
  --active-budget-minutes 360 \
  --hierarchical-harness \
  --lower-count 6 \
  --fixed-capacity \
  --agent-cmd 'tools/codex_quota_wait.sh {root} {prompt}' \
  --execute \
  --check-each-cycle \
  --report-language zh \
  --context-mode focused \
  --blueprint-refresh
```

Expected phase-1 endpoint: a Lean-certified exact candidate.  In the recorded
run the best exact candidate was
`coldE1ExactImprove4Depth2_blockProjection` with resource tuple
`(gateCount, depth, auxiliaryQubits, oracleCalls) = (4,2,1,0)`.

## Phase 2: Low-Capacity Export And Report Closeout

Once the exact Lean certificate exists, do not keep spending the full panel.
Use the adaptive controller for Qiskit/export/report synchronization and
reviewer audit.

```bash
python3 tools/qbe.py sleep-run QBE-OP-OPTCTRL-COLD-CLEAN-001 \
  --cycles 999 \
  --active-budget-minutes 120 \
  --hierarchical-harness \
  --lower-count 6 \
  --adaptive-capacity \
  --agent-cmd 'tools/codex_quota_wait.sh {root} {prompt}' \
  --execute \
  --check-each-cycle \
  --report-language zh \
  --context-mode focused \
  --blueprint-refresh
```

Under adaptive capacity, `--lower-count 6` is only a maximum.  Because a
Lean-certified exact candidate already exists, the controller should suppress
broad proof-search panels and use a small closeout queue unless the reviewer
records a concrete mismatch.

Closeout artifacts:

- `paper-notes/problem-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/latest.tex`
- `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/`
- `reports/QBE-OP-OPTCTRL-COLD-CLEAN-001/`
- `reports/QBE-OP-OPTCTRL-COLD-CLEAN-001/figures/` with evolution,
  certified-circuit storyboard, Qiskit/export status, and proof-DAG PNGs
- selected-language summary and Pro prompt at the final closeout run
