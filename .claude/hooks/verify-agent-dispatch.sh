#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-31
# verify-agent-dispatch.sh — PreToolUse hook for Agent tool
# Blocks Agent() calls that are missing the 5-field context packaging template.
# Required markers: ## 1. EO, ## 2. INPUT, ## 5. VERIFY
# On missing markers: exits non-zero with blocking message.
# On all markers present: exits 0 (pass).
set -euo pipefail

# Read hook input from stdin (JSON)
INPUT=$(cat)

# Extract the prompt parameter from the Agent tool input
PROMPT=$(echo "$INPUT" | jq -r '.tool_input.prompt // ""')

# Define required context packaging markers
REQUIRED_MARKERS=(
  "## 1. EO"
  "## 2. INPUT"
  "## 5. VERIFY"
)

MISSING=()

for MARKER in "${REQUIRED_MARKERS[@]}"; do
  if ! echo "$PROMPT" | grep -qF "$MARKER"; then
    MISSING+=("$MARKER")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "ERROR: Agent dispatch blocked — missing context packaging markers:" >&2
  for M in "${MISSING[@]}"; do
    echo "  - $M" >&2
  done
  echo "" >&2
  echo "Agent dispatch must use context packaging template. See .claude/skills/dsbv/references/context-packaging.md" >&2
  exit 1
fi

exit 0
