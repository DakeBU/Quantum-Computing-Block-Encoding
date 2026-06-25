#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: tools/codex_prompt_agent.sh <repo-root> <prompt-file>" >&2
  exit 2
fi

ROOT="$1"
PROMPT="$2"

cd "$ROOT"
codex exec --dangerously-bypass-approvals-and-sandbox "$(cat "$PROMPT")"
