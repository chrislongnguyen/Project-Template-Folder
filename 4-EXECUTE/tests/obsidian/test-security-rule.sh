#!/usr/bin/env bash
# Test: Security rule validation (A4) — AC-16..AC-20
# AP entries live in both the always-on rule AND the full SKILL.md
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
RULE="$PROJ/.claude/rules/obsidian-security.md"
SKILL="$PROJ/.claude/skills/obsidian/SKILL.md"
PASS=0; FAIL=0; TOTAL=5

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A4: Security Rule Validation ==="
check "AC-16 AP1-AP5 present (≥5 entries across rule+skill)" "[ \$(grep -oh 'AP[1-5]' '$RULE' '$SKILL' 2>/dev/null | wc -l) -ge 5 ]"
check "AC-17 AP4 opt-OUT with cli-blocked" "grep -q 'cli-blocked' '$RULE' || grep -q 'cli-blocked' '$SKILL'"
check "AC-18 Write-path whitelist defined" "grep -qi 'write-path\|whitelist\|designated' '$RULE' || grep -qi 'write-path\|whitelist\|designated' '$SKILL'"
check "AC-19 .claude/ hybrid sweep" "grep -qi '\.claude.*grep\|hybrid\|grep sweep' '$RULE' || grep -qi '\.claude.*grep\|hybrid\|grep sweep' '$SKILL'"
check "AC-20 Layer discipline rule" "grep -qi 'knowledge layer\|layer discipline\|read-only' '$RULE' || grep -qi 'knowledge layer\|layer discipline\|read-only' '$SKILL'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
