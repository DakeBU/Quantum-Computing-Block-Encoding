#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <workspace-root> <hard-task-id>" >&2
  exit 2
fi

ROOT="$(cd "$1" && pwd)"
TASK="$2"
export QBE_CODEX_MODEL="${QBE_CODEX_MODEL:-gpt-5.6-sol}"
AGENT_CMD='cd {root} && QBE_CODEX_MODEL=gpt-5.6-sol bash tools/qbe_codex_agent.sh {root} {prompt}'

cd "$ROOT"
mkdir -p runs/logs
printf '[%s] task=%s model=%s root=%s\n' "$(date '+%F %T %Z')" "$TASK" "$QBE_CODEX_MODEL" "$ROOT"

python3 tools/qbe.py sleep-run "$TASK" \
  --cycles 8 \
  --active-budget-minutes 360 \
  --agent-cmd "$AGENT_CMD" \
  --execute \
  --check-each-cycle \
  --context-mode focused \
  --blueprint-refresh \
  --adaptive-capacity \
  --hierarchical-harness \
  --upper-panel \
  --middle-panel \
  --lower-count 3 \
  --skip-article-update

python3 - "$TASK" <<'PY'
from __future__ import annotations

import json
import sys
from pathlib import Path

task = sys.argv[1]
root = Path.cwd()
state = json.loads((root / "runs" / "control" / f"{task}.json").read_text())
required = {
    "status": "complete",
    "stop": True,
    "lean_acceptance_complete": True,
    "executable_acceptance_complete": True,
}
failed = {key: (state.get(key), value) for key, value in required.items() if state.get(key) != value}
if failed:
    raise SystemExit(f"hard acceptance did not close: {failed}")
print(
    "full acceptance complete: "
    f"lean={state['lean_acceptance_complete']} "
    f"executable={state['executable_acceptance_complete']} "
    f"phase={state['search_phase']}"
)
PY
