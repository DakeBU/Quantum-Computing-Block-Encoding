#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

if [[ $# -lt 1 ]]; then
  echo "usage: $0 HIER_COLD|HIER_PRO_MID|HARD_COLD|HARD_HINTED" >&2
  exit 2
fi

ARM="$1"
mkdir -p runs/logs

AGENT_CMD='cd {root} && bash tools/qbe_codex_agent.sh {root} {prompt}'
PRO_PACKET="task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md"
BATCH_CYCLES="${ABEIS_BATCH_CYCLES:-999}"
BATCH_ACTIVE_MINUTES="${ABEIS_BATCH_ACTIVE_MINUTES:-360}"
MAX_BATCHES_PER_TASK="${ABEIS_MAX_BATCHES_PER_TASK:-3}"

case "$ARM" in
  HIER_COLD)
    TASK="QBE-ISO-MAIN-HIER-COLD-001"
    PRO_MID=0
    EXTRA_FLAGS=(--hierarchical-harness --upper-panel --middle-panel --lower-count 2)
    ;;
  HIER_PRO_MID)
    TASK="QBE-ISO-MAIN-HIER-PRO-MID-001"
    PRO_MID=1
    EXTRA_FLAGS=(--hierarchical-harness --upper-panel --middle-panel --lower-count 2)
    ;;
  HARD_COLD)
    TASK="QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001"
    PRO_MID=0
    EXTRA_FLAGS=(--hierarchical-harness --upper-panel --middle-panel --lower-count 2)
    ;;
  HARD_HINTED)
    TASK="QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001"
    PRO_MID=0
    EXTRA_FLAGS=(--hierarchical-harness --upper-panel --middle-panel --lower-count 2)
    ;;
  *)
    echo "unknown arm: $ARM" >&2
    exit 2
    ;;
esac

log() {
  printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')" "$ARM" "$*"
}

latest_run_for_task() {
  local task="$1"
  ls -dt "runs/"*"${task}"-cycle* 2>/dev/null | head -n 1
}

converged() {
  local task="$1"
  python3 - "$task" <<'PY'
import json, pathlib, sys

task = sys.argv[1]
root = pathlib.Path.cwd()
control = root / "runs" / "control" / f"{task}.json"
if control.exists():
    controller = json.loads(control.read_text())
    if controller.get("status") == "complete" and controller.get("certified_root_anchors"):
        raise SystemExit(0)
idx = root / "research-wiki" / "retrieval-index" / f"{task}.json"
if not idx.exists():
    raise SystemExit(1)
data = json.loads(idx.read_text())
if data.get("lean_sorries"):
    raise SystemExit(1)
if data.get("dynamic_leaf_queue"):
    raise SystemExit(1)

run_dir = data.get("run_dir")
texts = [json.dumps(data, ensure_ascii=False)]
if run_dir:
    for name in ["memory_digest.md", "todo.md", "summary.md", "zh_summary.md"]:
        p = root / run_dir / name
        if p.exists():
            texts.append(p.read_text(encoding="utf-8", errors="ignore"))
blob = "\n".join(texts).lower()

is_main = "main-case" in task.lower()
is_hard = "hard-cubic" in task.lower() or "cubic-diagonal" in task.lower()

if is_main:
    export = root / "executable-exports" / task
    if not (export / "export-manifest.json").exists():
        raise SystemExit(1)
    if not (export / "qiskit").exists():
        raise SystemExit(1)
    if not ("qiskit" in blob and ("pass" in blob or "passed" in blob or "verified" in blob)):
        raise SystemExit(1)
    raise SystemExit(0)

if is_hard:
    certified = (
        "lean-certified" in blob
        or "lean certified" in blob
        or ("certificate" in blob and ("epsilon" in blob or "exact" in blob))
    )
    if not certified:
        raise SystemExit(1)
    raise SystemExit(0)

raise SystemExit(0)
PY
}

inject_pro_packet() {
  local latest
  latest="$(latest_run_for_task "$TASK")"
  if [[ -z "${latest}" ]]; then
    log "skip Pro injection: no latest run"
    return 1
  fi
  if [[ ! -f "$PRO_PACKET" ]]; then
    log "skip Pro injection: missing ${PRO_PACKET}"
    return 1
  fi
  log "injecting Pro packet into ${latest}"
  python3 tools/qbe.py agent-note "$(basename "$latest")" --role upper --file "$PRO_PACKET"
}

run_sleep_batch() {
  local label="$1"
  shift
  log "BATCH START ${label}: task=${TASK}"
  if python3 tools/qbe.py sleep-run "$TASK" \
      --cycles "$BATCH_CYCLES" \
      --active-budget-minutes "$BATCH_ACTIVE_MINUTES" \
      --agent-cmd "$AGENT_CMD" \
      --execute \
      --check-each-cycle \
      --report-language zh \
      --context-mode focused \
      --blueprint-refresh \
      --adaptive-capacity \
      --exact-stall-cycles 2 \
      --parallel-lower \
      "${EXTRA_FLAGS[@]}" \
      "$@"; then
    log "BATCH DONE ${label}"
    return 0
  else
    local code=$?
    log "BATCH FAILED ${label} exit=${code}"
    return "$code"
  fi
}

if [[ "$PRO_MID" == "1" ]]; then
  log "PRO MID-RUN SETUP: first ordinary cycle before external packet"
  python3 tools/qbe.py sleep-run "$TASK" \
    --cycles 1 \
    --active-budget-minutes 90 \
    --agent-cmd "$AGENT_CMD" \
    --execute \
    --check-each-cycle \
    --report-language zh \
    --context-mode focused \
    --blueprint-refresh \
    --adaptive-capacity \
    --exact-stall-cycles 2 \
    --parallel-lower \
    "${EXTRA_FLAGS[@]}" || true
  inject_pro_packet || true
fi

log "START arm=${ARM}, task=${TASK}, cycles=${BATCH_CYCLES}, active_minutes=${BATCH_ACTIVE_MINUTES}, max_batches=${MAX_BATCHES_PER_TASK}"

batch=0
while true; do
  if converged "$TASK"; then
    log "CONVERGED task=${TASK}"
    exit 0
  fi
  batch=$((batch + 1))
  if [[ "$MAX_BATCHES_PER_TASK" != "0" && "$batch" -gt "$MAX_BATCHES_PER_TASK" ]]; then
    log "PAUSE reached MAX_BATCHES_PER_TASK=${MAX_BATCHES_PER_TASK}"
    python3 tools/qbe.py check || true
    python3 tools/qbe.py trial-summary || true
    exit 0
  fi
  run_sleep_batch "batch${batch}"
  code=$?
  if [[ "$code" == "75" ]]; then
    log "controlled pause: unchanged proof state, dependency gap, or token budget"
    exit 0
  fi
  if [[ "$code" != "0" ]]; then
    log "batch error; sleeping 60s before bounded repair retry"
    sleep 60
  fi
done
