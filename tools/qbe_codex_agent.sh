#!/usr/bin/env bash
set -u

if [ "$#" -lt 2 ]; then
  echo "usage: bash tools/qbe_codex_agent.sh <repo-root> <prompt-file>" >&2
  exit 2
fi

ROOT="$1"
PROMPT="$2"

MAX_ATTEMPTS="${QBE_CODEX_MAX_ATTEMPTS:-3}"
BASE_SLEEP_SECONDS="${QBE_CODEX_BASE_SLEEP_SECONDS:-60}"
MAX_SLEEP_SECONDS="${QBE_CODEX_MAX_SLEEP_SECONDS:-300}"
CODEX_ARGS="${QBE_CODEX_ARGS:---dangerously-bypass-approvals-and-sandbox}"
CODEX_BIN="${CODEX_BIN:-codex}"
CODEX_MODEL="${CODEX_MODEL:-gpt-5.6-sol}"
METRICS_FILE="${QBE_AGENT_METRICS:-}"
NON_RETRYABLE_EXIT_CODE="${QBE_CODEX_NON_RETRYABLE_EXIT_CODE:-78}"
STREAM_FULL_OUTPUT="${QBE_STREAM_FULL_OUTPUT:-0}"
child_pid=""
attempt_log=""

cd "$ROOT" || exit 2

# Publication builds are a maintainer/CI closeout concern. Agent subprocesses
# inherit this marker so repository scripts can reject accidental inner-cycle
# Blueprint or website rebuilds without affecting ordinary local and CI use.
export QBE_AGENT_INNER_CYCLE=1

terminate_child() {
  if [ -z "$child_pid" ]; then
    return 0
  fi
  if kill -0 "$child_pid" 2>/dev/null; then
    kill -TERM -- "-$child_pid" 2>/dev/null || kill -TERM "$child_pid" 2>/dev/null || true
    wait "$child_pid" 2>/dev/null || true
  fi
  child_pid=""
}

on_signal() {
  terminate_child
  if [ -n "$attempt_log" ]; then
    rm -f "$attempt_log"
  fi
  exit 130
}

trap on_signal INT TERM HUP

if ! command -v "$CODEX_BIN" >/dev/null 2>&1; then
  echo "Codex executable is not available: $CODEX_BIN" >&2
  exit 127
fi

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
  echo "[$(date)] qbe codex attempt ${attempt}/${MAX_ATTEMPTS} prompt=${PROMPT}" >&2
  attempt_started_at=$(date +%s)
  attempt_log="$(mktemp "${TMPDIR:-/tmp}/qbe-codex-attempt.XXXXXX")"
  scope_before=""
  if [ -n "${QBE_MUTATION_ALLOWLIST:-}" ]; then
    scope_before="$(mktemp "${TMPDIR:-/tmp}/qbe-scope-before.XXXXXX")"
    python3 tools/enforce_mutation_scope.py snapshot \
      --root "$ROOT" --output "$scope_before"
  fi
  read -r -a codex_args <<< "$CODEX_ARGS"
  QBE_ATTEMPT_LOG="$attempt_log" QBE_STREAM_FULL_OUTPUT="$STREAM_FULL_OUTPUT" setsid bash -c \
    'if [ "$QBE_STREAM_FULL_OUTPUT" = 1 ]; then
       set -o pipefail
       "$@" 2>&1 | tee "$QBE_ATTEMPT_LOG"
     else
       "$@" >"$QBE_ATTEMPT_LOG" 2>&1
     fi' \
    qbe-codex "$CODEX_BIN" exec --model "$CODEX_MODEL" "${codex_args[@]}" - \
    < "$PROMPT" &
  child_pid=$!
  attempt_status=0
  wait "$child_pid" || attempt_status=$?
  child_pid=""
  if [ -n "$scope_before" ]; then
    IFS=':' read -r -a mutation_paths <<< "$QBE_MUTATION_ALLOWLIST"
    scope_args=()
    for mutation_path in "${mutation_paths[@]}"; do
      scope_args+=(--allow "$mutation_path")
    done
    prompt_name="$(basename "$PROMPT")"
    case "$prompt_name" in
      10_upper_director.md|20_middle_formalizer.md|40_reviewer.md)
        scope_args+=(--atomic)
        ;;
    esac
    if ! python3 tools/enforce_mutation_scope.py check \
        --root "$ROOT" --before "$scope_before" "${scope_args[@]}"; then
      rm -f "$scope_before" "$attempt_log"
      echo "[$(date)] qbe codex mutation scope rejected" >&2
      exit 79
    fi
    rm -f "$scope_before"
  fi
  if [ "$attempt_status" -eq 0 ]; then
    attempt_finished_at=$(date +%s)
    active_seconds_total=$((active_seconds_total + attempt_finished_at - attempt_started_at))
    elapsed_seconds=$((attempt_finished_at - started_at))
    write_metrics "success" "$attempt" "$active_seconds_total" "$wait_seconds_total" "$elapsed_seconds"
    rm -f "$attempt_log"
    echo "[$(date)] qbe codex success" >&2
    exit 0
  fi
  attempt_finished_at=$(date +%s)
  active_seconds_total=$((active_seconds_total + attempt_finished_at - attempt_started_at))

  if grep -Eqi \
      'usage limit|upgrade to pro|purchase more credits|try again at|authentication failed|unauthorized|forbidden|does not have access|model[^[:cntrl:]]*not available' \
      "$attempt_log"; then
    elapsed_seconds=$((attempt_finished_at - started_at))
    write_metrics "provider-blocked" "$attempt" "$active_seconds_total" "$wait_seconds_total" "$elapsed_seconds"
    echo "[$(date)] qbe codex provider rejected the request; automatic retry disabled" >&2
    rm -f "$attempt_log"
    exit "$NON_RETRYABLE_EXIT_CODE"
  fi
  echo "[$(date)] qbe codex attempt failed; final output follows" >&2
  tail -n 40 "$attempt_log" >&2
  rm -f "$attempt_log"

  if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
    break
  fi
  sleep_seconds=$((BASE_SLEEP_SECONDS * attempt))
  if [ "$sleep_seconds" -gt "$MAX_SLEEP_SECONDS" ]; then
    sleep_seconds="$MAX_SLEEP_SECONDS"
  fi
  echo "[$(date)] qbe codex failed; retrying in ${sleep_seconds}s" >&2
  wait_seconds_total=$((wait_seconds_total + sleep_seconds))
  sleep "$sleep_seconds"
  attempt=$((attempt + 1))
done

elapsed_seconds=$(($(date +%s) - started_at))
write_metrics "exhausted" "$MAX_ATTEMPTS" "$active_seconds_total" "$wait_seconds_total" "$elapsed_seconds"
echo "[$(date)] qbe codex exhausted ${MAX_ATTEMPTS} attempts" >&2
exit 1
