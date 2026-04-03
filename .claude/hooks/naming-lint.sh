#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-03
# naming-lint.sh — PostToolUse + PreToolUse Write hook
# Checks: (1) frontmatter status/version casing, (2) spaces/dots in filenames

set -euo pipefail

INPUT=$(cat)

HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$HOOK_EVENT" || -z "$FILE_PATH" ]]; then
  exit 0
fi

# ── PreToolUse: filename pattern check ──────────────────────────────────────
if [[ "$HOOK_EVENT" == "PreToolUse" ]]; then
  BASENAME=$(basename "$FILE_PATH")
  DIRNAME=$(dirname "$FILE_PATH")

  WARN=""
  if [[ "$DIRNAME" =~ [[:space:]] ]]; then
    WARN="Path directory contains spaces: '$DIRNAME'. LTC UNG requires hyphens not spaces."
  elif [[ "$BASENAME" =~ ^[0-9]+\.[[:space:]] ]]; then
    WARN="Filename starts with a numbered prefix followed by a dot and space (e.g. '1. ALIGN'). Use hyphens: '1-ALIGN'."
  elif [[ "$BASENAME" =~ [[:space:]] ]]; then
    WARN="Filename contains spaces: '$BASENAME'. LTC UNG requires hyphens not spaces."
  fi

  if [[ -n "$WARN" ]]; then
    jq -n \
      --arg msg "$WARN" \
      '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "allow", "additionalContext": $msg}}'
  fi
  exit 0
fi

# ── PostToolUse: frontmatter casing lint ────────────────────────────────────
if [[ "$HOOK_EVENT" == "PostToolUse" ]]; then
  # Only lint .md files
  if [[ "$FILE_PATH" != *.md ]]; then
    exit 0
  fi

  CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty')
  if [[ -z "$CONTENT" ]]; then
    exit 0
  fi

  WARNS=()

  # Check status: value — must be lowercase
  STATUS_VAL=$(echo "$CONTENT" | grep -m1 '^status:' | sed 's/status:[[:space:]]*//' | tr -d '"'"'" || true)
  if [[ -n "$STATUS_VAL" ]]; then
    case "$STATUS_VAL" in
      Draft|Review|Approved)
        WARNS+=("Frontmatter 'status: $STATUS_VAL' should be lowercase: 'status: $(echo "$STATUS_VAL" | tr '[:upper:]' '[:lower:]')'.")
        ;;
    esac
  fi

  # Check version: value — must be a string like "1.0", not a bare float
  VERSION_VAL=$(echo "$CONTENT" | grep -m1 '^version:' | sed 's/version:[[:space:]]*//' | tr -d '"'"'" || true)
  if [[ -n "$VERSION_VAL" ]]; then
    if echo "$VERSION_VAL" | grep -qE '[A-Z]'; then
      WARNS+=("Frontmatter 'version: $VERSION_VAL' appears malformed — expected numeric like '1.0'.")
    fi
  fi

  # Check required fields presence (version, status, last_updated)
  FRONTMATTER=$(echo "$CONTENT" | sed -n '/^---$/,/^---$/p')
  if [[ -n "$FRONTMATTER" ]]; then
    [[ -z "$VERSION_VAL" ]] && WARNS+=("Missing required frontmatter field: 'version'.")
    [[ -z "$STATUS_VAL" ]] && WARNS+=("Missing required frontmatter field: 'status'.")
    LAST_UPDATED=$(echo "$CONTENT" | grep -m1 '^last_updated:' || true)
    [[ -z "$LAST_UPDATED" ]] && WARNS+=("Missing required frontmatter field: 'last_updated'.")
  fi

  if [[ ${#WARNS[@]} -gt 0 ]]; then
    MSG=$(printf '%s ' "${WARNS[@]}")
    jq -n --arg msg "$MSG" '{"additionalContext": $msg}'
  fi
  exit 0
fi

exit 0
