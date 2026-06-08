#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TASK_ID="${1:-QBE-AUTO-002}"
HOURS="${QBE_HOURS:-6}"
LOWER_COUNT="${QBE_LOWER_COUNT:-2}"
CONTEXT_MODE="${QBE_CONTEXT_MODE:-focused}"
PARALLEL_LOWER="${QBE_PARALLEL_LOWER:-1}"
METRICS_FILE="${QBE_AGENT_METRICS:-runs/metrics/theorem-closure-$(date +%Y%m%d-%H%M%S).tsv}"
if [ -n "${QBE_AGENT_CMD:-}" ]; then
  AGENT_CMD="$QBE_AGENT_CMD"
else
  AGENT_CMD='cd {root} && codex exec --dangerously-bypass-approvals-and-sandbox "$(cat {prompt})"'
fi

cd "$ROOT" || exit 1

mkdir -p "$(dirname "$METRICS_FILE")"
export QBE_AGENT_METRICS="$METRICS_FILE"
active_budget=$((HOURS * 3600))
cycle=1

active_used_seconds() {
  if [ ! -s "$METRICS_FILE" ]; then
    echo 0
    return 0
  fi
  awk -F '\t' '{s += $4} END {printf "%d", s}' "$METRICS_FILE"
}

sleep_run_extra_args=()
if [ "$PARALLEL_LOWER" != "0" ] && [ "$LOWER_COUNT" -gt 1 ]; then
  sleep_run_extra_args+=(--parallel-lower)
fi

echo "[$(date)] theorem-closure batch started"
echo "task=$TASK_ID active_hours=$HOURS lower_count=$LOWER_COUNT context_mode=$CONTEXT_MODE parallel_lower=$PARALLEL_LOWER"
echo "active_budget_seconds=$active_budget"
echo "agent_metrics=$METRICS_FILE"

python3 tools/qbe.py update-task "$TASK_ID" --status active --active
python3 tools/qbe.py blueprint-status "$TASK_ID" --refresh
python3 tools/qbe.py write-context-pack "$TASK_ID" --cycle 1

while [ "$(active_used_seconds)" -lt "$active_budget" ]; do
  active_used="$(active_used_seconds)"
  echo "[$(date)] inner cycle $cycle start active_used=${active_used}/${active_budget}"
  python3 tools/qbe.py blueprint-status "$TASK_ID" --refresh
  python3 tools/qbe.py sleep-run "$TASK_ID" \
    --cycles 1 \
    --lower-count "$LOWER_COUNT" \
    --context-mode "$CONTEXT_MODE" \
    --blueprint-refresh \
    --agent-cmd "$AGENT_CMD" \
    --execute \
    --check-each-cycle \
    --skip-reviewer \
    "${sleep_run_extra_args[@]}"
  code=$?
  active_used="$(active_used_seconds)"
  echo "[$(date)] inner cycle $cycle exit=$code active_used=${active_used}/${active_budget}"
  if [ "$code" -ne 0 ]; then
    echo "[$(date)] inner cycle failed; sleeping before retry"
    sleep 60
  else
    sleep 2
  fi
  cycle=$((cycle + 1))
done

echo "[$(date)] active-time budget reached; starting final upper/middle/reviewer audit"
python3 tools/qbe.py sleep-run "$TASK_ID" \
  --cycles 1 \
  --lower-count 0 \
  --context-mode "$CONTEXT_MODE" \
  --blueprint-refresh \
  --agent-cmd "$AGENT_CMD" \
  --execute \
  --check-each-cycle
final_code=$?
python3 tools/qbe.py efficiency-report --task "$TASK_ID"
active_used="$(active_used_seconds)"
echo "[$(date)] theorem-closure batch finished; final_audit_exit=$final_code active_used=${active_used}/${active_budget}"
exit "$final_code"
