#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-30
# verify-deliverables.sh — SubagentStop hook
# Checks that sub-agent output references expected deliverables before completing.
# Non-blocking failure: logs warning but does not block (human reviews).
# Blocking failure: if AC check file exists and any AC is FAIL, blocks with message.
set -euo pipefail

# Read hook input from stdin (JSON)
INPUT=$(cat)

# Extract sub-agent details
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
LAST_MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message // ""')
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')

# Prevent infinite loops
if [[ "$STOP_HOOK_ACTIVE" == "true" ]]; then
  exit 0
fi

# Resolve project root
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$PROJECT_ROOT" ]]; then
  exit 0
fi

# Check for AC verification file: .claude/ac/<agent-type>.json
# Format: {"criteria": [{"id": "AC-01", "description": "...", "pattern": "regex"}]}
AC_FILE="$PROJECT_ROOT/.claude/ac/${AGENT_TYPE}.json"
if [[ ! -f "$AC_FILE" ]]; then
  # No AC file for this agent type — skip verification
  exit 0
fi

# Verify each AC pattern exists in the sub-agent's last message
FAIL_COUNT=0
FAIL_LIST=""

while IFS= read -r line; do
  AC_ID=$(echo "$line" | jq -r '.id')
  AC_DESC=$(echo "$line" | jq -r '.description')
  AC_PATTERN=$(echo "$line" | jq -r '.pattern')

  if ! echo "$LAST_MESSAGE" | grep -qE "$AC_PATTERN"; then
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAIL_LIST="${FAIL_LIST}\n  - ${AC_ID}: ${AC_DESC}"
  fi
done < <(jq -c '.criteria[]' "$AC_FILE")

if [[ $FAIL_COUNT -gt 0 ]]; then
  # Log to project log
  LOG_DIR="$PROJECT_ROOT/.claude/logs"
  mkdir -p "$LOG_DIR"
  echo "[$(date -Iseconds)] SubagentStop WARN: ${AGENT_TYPE} failed ${FAIL_COUNT} ACs:${FAIL_LIST}" >> "$LOG_DIR/hook-verify.log"

  # Output warning to stderr (shown to user)
  echo "⚠ Sub-agent '${AGENT_TYPE}' output missing ${FAIL_COUNT} acceptance criteria:${FAIL_LIST}" >&2
  echo "Review output before treating as complete." >&2

  # Block: exit 2 prevents sub-agent from completing
  exit 2
fi

exit 0
