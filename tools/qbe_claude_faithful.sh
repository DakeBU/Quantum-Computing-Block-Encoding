#!/usr/bin/env bash
set -u

if [ "$#" -lt 2 ]; then
  echo "usage: bash tools/qbe_claude_faithful.sh <repo-root> <prompt-file>" >&2
  exit 2
fi

ROOT="$1"
PROMPT="$2"

MAX_ATTEMPTS="${QBE_CLAUDE_MAX_ATTEMPTS:-18}"
BASE_SLEEP_SECONDS="${QBE_CLAUDE_BASE_SLEEP_SECONDS:-180}"
MAX_SLEEP_SECONDS="${QBE_CLAUDE_MAX_SLEEP_SECONDS:-1800}"
MAX_BUDGET_USD="${QBE_CLAUDE_MAX_BUDGET_USD:-8}"

cd "$ROOT" || exit 2

attempt=1
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  echo "[$(date)] faithful claude attempt ${attempt}/${MAX_ATTEMPTS} prompt=${PROMPT}" >&2
  if claude -p --permission-mode bypassPermissions --effort high \
      --max-budget-usd "$MAX_BUDGET_USD" "$(cat "$PROMPT")"; then
    echo "[$(date)] faithful claude success" >&2
    exit 0
  fi

  sleep_seconds=$((BASE_SLEEP_SECONDS * attempt))
  if [ "$sleep_seconds" -gt "$MAX_SLEEP_SECONDS" ]; then
    sleep_seconds="$MAX_SLEEP_SECONDS"
  fi
  echo "[$(date)] faithful claude failed; retrying in ${sleep_seconds}s" >&2
  sleep "$sleep_seconds"
  attempt=$((attempt + 1))
done

echo "[$(date)] faithful claude exhausted ${MAX_ATTEMPTS} attempts" >&2
exit 1
