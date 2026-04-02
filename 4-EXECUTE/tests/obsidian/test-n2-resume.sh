#!/usr/bin/env bash
# Test: N2 2-Pass Resume — AC-N2-01..AC-N2-07
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
SKILL="$PROJ/.claude/skills/session/resume/SKILL.md"
CHEAT="$PROJ/_genesis/sops/session-lifecycle-cheatsheet.md"
PASS=0; FAIL=0; TOTAL=7

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== N2: 2-Pass Resume ==="
check "AC-N2-01 SKILL.md exists" "test -f '$SKILL'"
check "AC-N2-02 2-pass protocol documented (Pass 1 + Pass 2)" "grep -qi 'pass 1\|pass 2\|2-pass\|frontmatter.*scan' '$SKILL'"
check "AC-N2-03 Token budget ≤5K documented" "grep -qiE '5.?K|5000|≤5K|5k token' '$SKILL'"
check "AC-N2-04 Pass 1 frontmatter-only (~500 tokens)" "grep -qiE '500 token|frontmatter.*scan|frontmatter.*only' '$SKILL'"
check "AC-N2-05 Pass 2 single file body load" "grep -qi 'single.*most relevant\|body.*load\|full file' '$SKILL'"
check "AC-N2-06 Staleness warning (>7 days)" "grep -qiE 'stale|7 day|staleness' '$SKILL'"
check "AC-N2-07 Fallback for pre-refactor files" "grep -qi 'fallback\|pre-refactor\|backward' '$SKILL'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
