#!/usr/bin/env bash
# Test: N4 Session Lifecycle Deprecation — AC-N4-01..AC-N4-06
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
CHEAT="$PROJ/_genesis/sops/session-lifecycle-cheatsheet.md"
SS="$PROJ/.claude/skills/session/session-start/SKILL.md"
SE="$PROJ/.claude/skills/session/session-end/SKILL.md"
PASS=0; FAIL=0; TOTAL=6

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== N4: Session Lifecycle Deprecation ==="
check "AC-N4-01 Cheatsheet exists" "test -f '$CHEAT'"
check "AC-N4-02 Deprecation notice (session-start deprecated)" "grep -qi 'deprecated' '$CHEAT' && grep -qi 'session-start' '$CHEAT'"
check "AC-N4-03 Deprecation notice (session-end deprecated)" "grep -qi 'deprecated' '$CHEAT' && grep -qi 'session-end' '$CHEAT'"
check "AC-N4-04 Replacement mapping (/resume)" "grep -qi 'resume' '$CHEAT'"
check "AC-N4-05 Replacement mapping (/compress)" "grep -qi 'compress' '$CHEAT'"
check "AC-N4-06 session-start SKILL.md marked deprecated" "grep -qi 'deprecated' '$SS'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
