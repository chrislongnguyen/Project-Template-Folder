#!/usr/bin/env bash
# Test: N3 Briefing Card Staleness Guard — AC-N3-01..AC-N3-04
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
SESSION_START="$PROJ/.claude/skills/session/session-start/SKILL.md"
RESUME="$PROJ/.claude/skills/session/resume/SKILL.md"
PASS=0; FAIL=0; TOTAL=4

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== N3: Briefing Card Staleness Guard ==="
check "AC-N3-01 Staleness check in session-start OR resume" "grep -qi 'stale\|staleness' '$SESSION_START' || grep -qi 'stale\|staleness' '$RESUME'"
check "AC-N3-02 Day threshold defined (7 or 14 days)" "grep -qiE '7 day|14 day|days? ago' '$SESSION_START' || grep -qiE '7 day|14 day|days? ago' '$RESUME'"
check "AC-N3-03 Warning message pattern" "grep -qi 'memory briefing card\|briefing.*stale\|last updated' '$SESSION_START' || grep -qi 'memory briefing card\|briefing.*stale\|last updated' '$RESUME'"
check "AC-N3-04 MEMORY.md referenced" "grep -qi 'MEMORY.md' '$SESSION_START' || grep -qi 'MEMORY.md' '$RESUME'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
