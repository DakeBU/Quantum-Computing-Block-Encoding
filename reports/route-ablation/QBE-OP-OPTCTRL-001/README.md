# Route Ablation: QBE-OP-OPTCTRL-001

This directory contains controlled prompts for comparing three artifact
routes on the same block-encoding target:

- Qiskit-only finite executable check;
- direct Lean theorem route;
- full ABEIS hierarchical multi-agent route.

All routes use the same target envelope.  A fair run must use the same
model family, budget, and temperature policy where possible.

| Route | Prompt | Initial input-token proxy | Final semantic level |
| --- | --- | ---: | --- |
| `qiskit_only` | `reports/route-ablation/QBE-OP-OPTCTRL-001/qiskit_only.prompt.md` | 356 | finite Qiskit Operator equality |
| `lean_only` | `reports/route-ablation/QBE-OP-OPTCTRL-001/lean_only.prompt.md` | 371 | direct Lean theorem |
| `abeis_multi_agent` | `reports/route-ablation/QBE-OP-OPTCTRL-001/abeis_multi_agent.prompt.md` | 334 | Lean-certified ABEIS candidate population entry |

Required measurements:

- agent wall time from prompt dispatch to accepted artifact;
- checker/compile time;
- exact provider input/output/total tokens;
- repair iterations;
- final semantic level;
- whether the artifact is reusable as a Lean dependency.
- for ABEIS route: whether real `--parallel-lower` execution was used,
  lower-count, agent profile, and whether the parallelism claim is valid.

Checker-only reference baselines:

```bash
python3 -m pip install qiskit
python3 tools/run_route_ablation.py reference_qiskit
python3 tools/run_route_ablation.py reference_lean
```

Actual route-total runs:

```bash
python3 tools/run_route_ablation.py qiskit_only --agent-cmd '<same model wrapper on {prompt}>'
python3 tools/run_route_ablation.py lean_only --agent-cmd '<same model wrapper on {prompt}>'
python3 tools/run_route_ablation.py abeis_multi_agent \
  --execute-abeis \
  --lower-count 3 \
  --agent-profile codex-parallel.example.json \
  --agent-timeout-s 900
```

For `qiskit_only`, the runner sets `QBE_ROUTE_ARTIFACT` and the default
checker runs that file.  The agent command must therefore create a complete
Python/Qiskit script at that path, not just print code in chat.

The ABEIS route refuses to run without `--execute-abeis`.  It uses a short
route-ablation mini-harness: upper and middle write compact handoffs, lower
roles run in parallel, then reviewer and `lake build Tests` close the gate.
This prevents a single chat session from being recorded as parallel
lower-agent evidence.

Latest measured route-total rows:

| Route | Status | Agent/harness s | Checker s | Notes |
| --- | --- | ---: | ---: | --- |
| `qiskit_only` | passed | 306.741 | 9.230 | finite executable artifact |
| `lean_only` | passed | 356.285 | 0.610 | direct Lean theorem route |
| `abeis_multi_agent` | passed | 851.374 | 0.607 | real `lower_count=3` parallel lower agents |

The ABEIS row validates the parallel-agent harness, but it also reveals high
coordination/log overhead for the current Codex profile.  The next optimization
is to use deterministic or low-token coordination roles and save expensive
model calls for lower proof/circuit construction.

Do not compare Qiskit checker time against Lean agent-writing time.  The
whole point is to compare route-total time and tokens separately from
checker time.
