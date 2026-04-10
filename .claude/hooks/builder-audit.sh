#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-10
# builder-audit.sh — SubagentStop hook
# Detects builder self-check skipping: greps output for AC verification markers.
# Non-blocking: always exits 0. Warns to stderr only.
# Applies to ltc-builder outputs only; all other agent types are skipped.
#
# Gap S-1: builder self-check is unauditable via PreToolUse (#40580).
# This hook compensates by scanning final output for evidence of AC verification.
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

# AC-06: Only audit ltc-builder outputs — skip all other agent types
if [[ "$AGENT_TYPE" != "ltc-builder" ]]; then
  exit 0
fi

# Resolve project root (best-effort; skip if unavailable)
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")

# AC-04: Grep for AC markers in builder output
# Patterns: "AC-01", "AC-02" ... (individual ACs) OR "ACs: N/M" (summary line)
AC_FOUND=0
if echo "$LAST_MESSAGE" | grep -qE "AC-[0-9]|ACs: *[0-9]+/[0-9]+"; then
  AC_FOUND=1
fi

# AC-05: Warn to stderr, always exit 0
if [[ $AC_FOUND -eq 0 ]]; then
  echo "⚠ builder-audit — ltc-builder output has no AC verification markers." >&2
  echo "  Expected: 'AC-01', 'AC-02', ... or 'ACs: N/M' summary in completion report." >&2
  echo "  Gap S-1: builder may have skipped self-check. Review output before treating as done." >&2

  # Log to project log (best-effort, never blocks)
  if [[ -n "$PROJECT_ROOT" ]]; then
    LOG_DIR="$PROJECT_ROOT/.claude/logs"
    mkdir -p "$LOG_DIR" || true
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo 'unknown')] builder-audit WARN: ltc-builder output missing AC markers" \
      >> "$LOG_DIR/builder-audit.log" || true
  fi
fi

# Always exit 0 — non-blocking by design
exit 0
