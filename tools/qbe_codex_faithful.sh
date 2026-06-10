#!/usr/bin/env bash
set -u

if [ "$#" -lt 2 ]; then
  echo "usage: bash tools/qbe_codex_faithful.sh <repo-root> <prompt-file>" >&2
  exit 2
fi

ROOT="$1"
PROMPT="$2"

MAX_ATTEMPTS="${QBE_CODEX_MAX_ATTEMPTS:-3}"
BASE_SLEEP_SECONDS="${QBE_CODEX_BASE_SLEEP_SECONDS:-60}"
MAX_SLEEP_SECONDS="${QBE_CODEX_MAX_SLEEP_SECONDS:-300}"
CODEX_ARGS="${QBE_CODEX_ARGS:---dangerously-bypass-approvals-and-sandbox}"
METRICS_FILE="${QBE_AGENT_METRICS:-}"

cd "$ROOT" || exit 2

write_metrics() {
  if [ -z "$METRICS_FILE" ]; then
    return 0
  fi
  local status="$1"
  local attempts="$2"
  local active_seconds="$3"
  local wait_seconds="$4"
  local elapsed_seconds="$5"
  mkdir -p "$(dirname "$METRICS_FILE")"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$(date '+%Y-%m-%d %H:%M:%S')" \
    "$status" \
    "$attempts" \
    "$active_seconds" \
    "$wait_seconds" \
    "$elapsed_seconds" \
    "$PROMPT" >> "$METRICS_FILE"
}

attempt=1
active_seconds_total=0
wait_seconds_total=0
started_at=$(date +%s)
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  echo "[$(date)] faithful codex attempt ${attempt}/${MAX_ATTEMPTS} prompt=${PROMPT}" >&2
  attempt_started_at=$(date +%s)
  if codex exec $CODEX_ARGS - < "$PROMPT"; then
    attempt_finished_at=$(date +%s)
    active_seconds_total=$((active_seconds_total + attempt_finished_at - attempt_started_at))
    elapsed_seconds=$((attempt_finished_at - started_at))
    write_metrics "success" "$attempt" "$active_seconds_total" "$wait_seconds_total" "$elapsed_seconds"
    echo "[$(date)] faithful codex success" >&2
    exit 0
  fi
  attempt_finished_at=$(date +%s)
  active_seconds_total=$((active_seconds_total + attempt_finished_at - attempt_started_at))

  if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
    break
  fi
  sleep_seconds=$((BASE_SLEEP_SECONDS * attempt))
  if [ "$sleep_seconds" -gt "$MAX_SLEEP_SECONDS" ]; then
    sleep_seconds="$MAX_SLEEP_SECONDS"
  fi
  echo "[$(date)] faithful codex failed; retrying in ${sleep_seconds}s" >&2
  wait_seconds_total=$((wait_seconds_total + sleep_seconds))
  sleep "$sleep_seconds"
  attempt=$((attempt + 1))
done

elapsed_seconds=$(($(date +%s) - started_at))
write_metrics "exhausted" "$MAX_ATTEMPTS" "$active_seconds_total" "$wait_seconds_total" "$elapsed_seconds"
echo "[$(date)] faithful codex exhausted ${MAX_ATTEMPTS} attempts" >&2
exit 1
