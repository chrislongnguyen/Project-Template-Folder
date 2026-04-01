#!/usr/bin/env bash
# Test: Graceful degradation (A2 L13) — AC-05
# Verifies that SKILL.md documents fallback behavior when obsidian CLI is unavailable
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
SKILL="$PROJ/.claude/skills/obsidian/SKILL.md"
PASS=0; FAIL=0; TOTAL=3

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; ((PASS++)); else echo "  FAIL: $1"; ((FAIL++)); fi; }

echo "=== A2: Graceful Degradation ==="
check "Fallback section exists" "grep -qi 'fallback' '$SKILL'"
check "Grep/Glob mentioned as fallback" "grep -qi 'grep\|glob' '$SKILL'"
check "Error handling documented (version check or try/catch pattern)" "grep -qi 'obsidian.*version\|not running\|unavailable\|error' '$SKILL'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
