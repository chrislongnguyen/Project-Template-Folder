#!/usr/bin/env bash
# version: 1.1 | last_updated: 2026-04-04
# strategic-compact.sh — PreToolUse hook
# Counts heavy tool calls and warns when context may be approaching limits.
# Triggers state-saver at threshold intervals.
set -euo pipefail

THRESHOLD=200
HEAVY_TOOLS="Read|Bash|WebFetch|WebSearch|Agent"

TOOL="${CLAUDE_TOOL_NAME:-}"
if [[ -n "$TOOL" ]]; then
  if ! echo "$TOOL" | grep -qE "^($HEAVY_TOOLS)$"; then
    exit 0
  fi
fi

COUNTER_DIR="/tmp/claude-strategic-compact"
DATE=$(date +%Y%m%d)
COUNTER_FILE="$COUNTER_DIR/count-$DATE"
mkdir -p "$COUNTER_DIR"

count=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
count=$((count + 1))
echo "$count" > "$COUNTER_FILE"

if (( count % THRESHOLD == 0 )); then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  STATE_SAVER="${CLAUDE_PLUGIN_ROOT:-$SCRIPT_DIR}/hooks/state-saver.sh"
  [[ -x "$STATE_SAVER" ]] || STATE_SAVER="$SCRIPT_DIR/state-saver.sh"
  if [[ -x "$STATE_SAVER" ]]; then
    bash "$STATE_SAVER" 2>/dev/null
  fi

  echo ""
  echo "CONTEXT INSTRUCTION: $count heavy tool calls this session (Read/Bash/WebFetch)."
  echo "Context may be approaching the 60-65% quality threshold."
  echo "STEP 1: Run /compress now to save full session context to vault."
  echo "STEP 2: Tell the user: 'Context is getting full. Start a new conversation to continue with full capability.'"
  echo "State snapshot has been auto-saved to vault as a recovery point."
  echo ""
fi

exit 0
