#!/usr/bin/env bash
set -euo pipefail

vendor="${1:?vendor name required}"
prompt="${2:?prompt path required}"

case "$vendor" in
  glm)
    echo "Replace this example with your GLM CLI invocation." >&2
    echo "Prompt file: $prompt" >&2
    exit 2
    ;;
  minimax)
    echo "Replace this example with your Minimax CLI invocation." >&2
    echo "Prompt file: $prompt" >&2
    exit 2
    ;;
  gemini)
    echo "Replace this example with your Gemini CLI invocation." >&2
    echo "Prompt file: $prompt" >&2
    exit 2
    ;;
  gpt)
    echo "Replace this example with your GPT/OpenAI wrapper invocation." >&2
    echo "Prompt file: $prompt" >&2
    exit 2
    ;;
  custom)
    echo "Replace this example with your custom model wrapper invocation." >&2
    echo "Prompt file: $prompt" >&2
    exit 2
    ;;
  *)
    echo "Unknown vendor: $vendor" >&2
    exit 2
    ;;
esac
