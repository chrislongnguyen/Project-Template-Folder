#!/usr/bin/env bash
# version: 1.1 | status: Draft | last_updated: 2026-04-05
# verify-deliverables.sh — SubagentStop hook
# Checks that sub-agent output references expected deliverables before completing.
# Also checks context packaging markers (## 1. EO, ## 5. VERIFY) per agent-dispatch.md.
# Non-blocking failure: logs warning but does not block (human reviews).
# Blocking failure: if AC check file exists and any AC is FAIL, blocks with message.
#
# NOTE: PreToolUse exit codes are IGNORED for Agent() calls (GitHub #40580).
# This SubagentStop hook is the only enforcement point for context packaging.
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

# Check context packaging markers in sub-agent output
# These markers indicate the agent was invoked with the 5-field template
CP_WARNINGS=""
if [[ -n "$LAST_MESSAGE" ]]; then
  if ! echo "$LAST_MESSAGE" | grep -q "## 1\. EO"; then
    CP_WARNINGS="${CP_WARNINGS}\n  - Missing '## 1. EO' — agent may not have received context package"
  fi
  if ! echo "$LAST_MESSAGE" | grep -q "## 5\. VERIFY"; then
    CP_WARNINGS="${CP_WARNINGS}\n  - Missing '## 5. VERIFY' — agent may not have self-verified"
  fi
fi

if [[ -n "$CP_WARNINGS" ]]; then
  echo "⚠ Context packaging check for '${AGENT_TYPE}':${CP_WARNINGS}" >&2
  echo "Agent output may lack structured verification. Review before trusting." >&2
  # Non-blocking: warn only (context packaging is best-effort due to #40580)
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
