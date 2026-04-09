#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# C-10: Registry Sync PostToolUse hook
# Purpose: Warn when a workstream artifact is edited but version-registry.md
#          has not been updated this session.
# Hook type: PostToolUse (Write|Edit)
# Exit: 0 always (non-blocking advisory)

INPUT=$(cat)

TOOL=$(echo "$INPUT" | jq -r '.tool_name // ""')
FILE=$(echo "$INPUT" | jq -r '.tool_input.path // .tool_input.file_path // ""')

# Only act on Write or Edit tool calls
case "$TOOL" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

# Check if path matches a workstream artifact pattern: /[1-5]-UPPERCASE/
if ! echo "$FILE" | grep -qE '/[1-5]-[A-Z]+/'; then
  exit 0
fi

# State file tracks whether we have already warned this session
STATE_DIR="$(dirname "$0")/../.claude/state"
DIRTY_FLAG="$STATE_DIR/registry-dirty.json"

# If already warned this session, stay quiet
if [ -f "$DIRTY_FLAG" ]; then
  exit 0
fi

# First time this session — create the flag and emit the warning
mkdir -p "$STATE_DIR"
echo "{\"warned_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"first_file\":\"$FILE\"}" > "$DIRTY_FLAG"

echo "WARNING: Workstream artifact edited: $FILE — remember to update version-registry.md before committing" >&2

exit 0
