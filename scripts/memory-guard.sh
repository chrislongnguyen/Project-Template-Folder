#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-29
# memory-guard.sh — PreToolUse hook (Write)
# Validates MEMORY.md structure before allowing writes.
# Ensures required sections exist in correct order:
#   ## Agent Instructions → ## Briefing Card → ## Topic Index

# Always exit 0 — use JSON decision block to signal block/allow.
set -euo pipefail

# Read full JSON from stdin
INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only act on Write tool — Edit/MultiEdit can't be validated pre-state
[[ "$TOOL_NAME" != "Write" ]] && exit 0

# Extract file path
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only act on memory/MEMORY.md files
case "$FILE_PATH" in
  */memory/MEMORY.md) ;;
  *) exit 0 ;;
esac

# Extract content (jq -r decodes \n to real newlines)
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty')

# Find line numbers of each required section
# Use { grep || true; } to prevent pipefail from killing the script on no match
LINE_AI=$({ echo "$CONTENT" | grep -n '^## Agent Instructions' || true; } | head -1 | cut -d: -f1)
LINE_BC=$({ echo "$CONTENT" | grep -n '^## Briefing Card'      || true; } | head -1 | cut -d: -f1)
LINE_TI=$({ echo "$CONTENT" | grep -n '^## Topic Index'        || true; } | head -1 | cut -d: -f1)

# Validate: all three must exist
if [[ -z "$LINE_AI" || -z "$LINE_BC" || -z "$LINE_TI" ]]; then
  echo '{"decision":"block","reason":"MEMORY.md structure violation: missing or misordered required sections. Must have ## Agent Instructions → ## Briefing Card → ## Topic Index"}'
  exit 0
fi

# Validate: correct order (AI < BC < TI)
if [[ "$LINE_AI" -ge "$LINE_BC" || "$LINE_BC" -ge "$LINE_TI" ]]; then
  echo '{"decision":"block","reason":"MEMORY.md structure violation: missing or misordered required sections. Must have ## Agent Instructions → ## Briefing Card → ## Topic Index"}'
  exit 0
fi

# All checks pass — allow silently
exit 0
