#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TASK_ID="${1:-QBE-AUTO-002}"
HOURS="${QBE_HOURS:-6}"
LOWER_COUNT="${QBE_LOWER_COUNT:-1}"
if [ -n "${QBE_AGENT_CMD:-}" ]; then
  AGENT_CMD="$QBE_AGENT_CMD"
else
  AGENT_CMD='cd {root} && codex exec --dangerously-bypass-approvals-and-sandbox "$(cat {prompt})"'
fi

cd "$ROOT" || exit 1

deadline=$(($(date +%s) + HOURS * 3600))
cycle=1

echo "[$(date)] theorem-closure batch started"
echo "task=$TASK_ID hours=$HOURS lower_count=$LOWER_COUNT"
echo "deadline_epoch=$deadline"

while [ "$(date +%s)" -lt "$deadline" ]; do
  echo "[$(date)] inner cycle $cycle start"
  python3 tools/qbe.py sleep-run "$TASK_ID" \
    --cycles 1 \
    --lower-count "$LOWER_COUNT" \
    --agent-cmd "$AGENT_CMD" \
    --execute \
    --check-each-cycle \
    --skip-reviewer
  code=$?
  echo "[$(date)] inner cycle $cycle exit=$code"
  if [ "$code" -ne 0 ]; then
    echo "[$(date)] inner cycle failed; sleeping before retry"
    sleep 60
  else
    sleep 2
  fi
  cycle=$((cycle + 1))
done

echo "[$(date)] deadline reached; starting final upper/middle/reviewer audit"
python3 tools/qbe.py sleep-run "$TASK_ID" \
  --cycles 1 \
  --lower-count 0 \
  --agent-cmd "$AGENT_CMD" \
  --execute \
  --check-each-cycle
final_code=$?
echo "[$(date)] theorem-closure batch finished; final_audit_exit=$final_code"
exit "$final_code"
