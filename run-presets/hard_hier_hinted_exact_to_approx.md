# Preset: hard_hier_hinted_exact_to_approx

Task: `QBE-OP-CUBIC-DIAGONAL-CLEAN-001`

Purpose: reproduce the hinted Hierarchical Harness attempt for the diagonal
cubic operator

$$
O_n = \sum_{j=0}^{2^n-1} (j/2^n)^3 |j\rangle\langle j| .
$$

Human hint used by this preset:

```text
First construct a block encoding of
O_0 = sum_j (j/2^n) |j><j|, then use QSVT.
```

The hint is an insight-pool input.  It is not a certificate.  Lean still must
prove the final block-encoding theorem or the declared approximation theorem.

## Phase 1: High-Capacity Exact Search With Hint

Use this phase to spend a bounded high-capacity budget on the exact route.

```bash
python3 tools/qbe.py sleep-run QBE-OP-CUBIC-DIAGONAL-CLEAN-001 \
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

Recorded phase-1 state: the exact route exposed a blocked semantic bridge for
the `O_0` multiplexed-rotation construction.  The QSVT hint remained a useful
candidate-family strategy, but no final cubic Lean certificate was promoted.

## Phase 2: Adaptive Approximate Search

After exact stagnation, switch to the adaptive controller.  The default
`--exact-stall-cycles 2` is a short patience budget for new runs; for a resumed
run whose memory already records a blocked route, the controller may open
Scenario 2 immediately.  In that case, the old exact bridge is no longer the
main objective.  It may be reused as a component or negative diagnostic, but
upper/middle should spend the reduced budget on a Lean-checkable approximate
target and an explicit epsilon ladder.

```bash
python3 tools/qbe.py sleep-run QBE-OP-CUBIC-DIAGONAL-CLEAN-001 \
  --cycles 999 \
  --active-budget-minutes 180 \
  --hierarchical-harness \
  --lower-count 6 \
  --adaptive-capacity \
  --exact-stall-cycles 2 \
  --agent-cmd 'tools/codex_quota_wait.sh {root} {prompt}' \
  --execute \
  --check-each-cycle \
  --report-language zh \
  --context-mode focused \
  --blueprint-refresh
```

Scenario 2 policy:

1. Start at `epsilon = 1e-10`.
2. If that tier stalls under the bounded generation budget, upper may relax
   epsilon.
3. Every relaxation must appear in the memory digest, candidate population,
   selected-language closeout summary, and Pro prompt.
4. Only Lean-certified approximate candidates are plotted as achieved points.

Closeout artifacts:

- `paper-notes/problem-exports/QBE-OP-CUBIC-DIAGONAL-CLEAN-001/latest.tex`
- `candidate-populations/QBE-OP-CUBIC-DIAGONAL-CLEAN-001.md`
- `reports/QBE-OP-CUBIC-DIAGONAL-CLEAN-001/`
- selected-language summary and Pro prompt at final closeout
