#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

mkdir -p runs/logs

AGENT_CMD='cd {root} && codex exec --dangerously-bypass-approvals-and-sandbox "$(cat {prompt})"'
PRO_PACKET="task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md"

# One batch is intentionally long enough for qbe.py's internal cycle counter
# to trigger exact-stall handling and Scenario 2 approximate search.  If a
# batch ends by active-time closeout before convergence, this wrapper starts
# another batch with the refreshed memory as context.
BATCH_CYCLES="${ABEIS_BATCH_CYCLES:-999}"
BATCH_ACTIVE_MINUTES="${ABEIS_BATCH_ACTIVE_MINUTES:-360}"
MAX_BATCHES_PER_TASK="${ABEIS_MAX_BATCHES_PER_TASK:-0}" # 0 means keep going.
MIN_BATCHES_PER_TASK="${ABEIS_MIN_BATCHES_PER_TASK:-1}"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')" "$*"
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
    # Hard cases may close through an exact certificate or through an explicit
    # approximate certificate.  A mere empty queue without a certified champion
    # is not enough to stop.
    certified = (
        "lean-certified" in blob
        or "lean certified" in blob
        or "certificate" in blob and ("epsilon" in blob or "exact" in blob)
    )
    if not certified:
        raise SystemExit(1)
    raise SystemExit(0)

raise SystemExit(0)
PY
}

inject_pro_packet() {
  local task="$1"
  local latest
  latest="$(latest_run_for_task "$task")"
  if [[ -z "${latest}" ]]; then
    log "skip Pro injection for ${task}: no latest run"
    return 1
  fi
  if [[ ! -f "$PRO_PACKET" ]]; then
    log "skip Pro injection for ${task}: missing ${PRO_PACKET}"
    return 1
  fi
  log "injecting Pro packet into ${latest}"
  python3 tools/qbe.py agent-note "$(basename "$latest")" --role upper --file "$PRO_PACKET"
}

run_batch() {
  local label="$1"
  local task="$2"
  shift 2
  log "BATCH START ${label}: task=${task}"
  if python3 tools/qbe.py sleep-run "$task" \
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
      "$@"; then
    log "BATCH DONE ${label}"
    return 0
  else
    local code=$?
    log "BATCH FAILED ${label} exit=${code}; next batch may repair from memory"
    return "$code"
  fi
}

run_until_converged() {
  local label="$1"
  local task="$2"
  shift 2
  local batch=0
  while true; do
    if [[ "$batch" -ge "$MIN_BATCHES_PER_TASK" ]] && converged "$task"; then
      log "CONVERGED ${label}: task=${task}"
      return 0
    fi
    batch=$((batch + 1))
    if [[ "$MAX_BATCHES_PER_TASK" != "0" && "$batch" -gt "$MAX_BATCHES_PER_TASK" ]]; then
      log "PAUSE ${label}: reached MAX_BATCHES_PER_TASK=${MAX_BATCHES_PER_TASK}"
      return 0
    fi
    if ! run_batch "${label}/batch${batch}" "$task" "$@"; then
      log "BATCH ERROR ${label}: sleeping 60s before the next repair attempt"
      sleep 60
    fi
  done
}

run_pro_mid_until_converged() {
  local label="$1"
  local task="$2"
  shift 2
  log "PRO MID-RUN SETUP ${label}: first ordinary cycle before external packet"
  python3 tools/qbe.py sleep-run "$task" \
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
    "$@" || true
  inject_pro_packet "$task" || true
  run_until_converged "$label" "$task" "$@"
}

log "ABEIS long repro suite start"
log "Batch policy: cycles=${BATCH_CYCLES}, active_minutes=${BATCH_ACTIVE_MINUTES}, min_batches=${MIN_BATCHES_PER_TASK}, max_batches=${MAX_BATCHES_PER_TASK}"

run_until_converged "HIER_COLD" QBE-ISO-MAIN-HIER-COLD-001 \
  --hierarchical-harness \
  --upper-panel \
  --middle-panel \
  --lower-count 2

run_pro_mid_until_converged "HIER_PRO_MID" QBE-ISO-MAIN-HIER-PRO-MID-001 \
  --hierarchical-harness \
  --upper-panel \
  --middle-panel \
  --lower-count 2

run_until_converged "HARD_COLD" QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001 \
  --hierarchical-harness \
  --upper-panel \
  --middle-panel \
  --lower-count 2

run_until_converged "HARD_HINTED" QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001 \
  --hierarchical-harness \
  --upper-panel \
  --middle-panel \
  --lower-count 2

log "final tool check"
python3 tools/qbe.py check || true
python3 tools/qbe.py trial-summary || true

log "ABEIS long repro suite end"
