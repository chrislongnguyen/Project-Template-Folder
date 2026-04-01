#!/usr/bin/env bash
# Test: Security rule validation (A4) — AC-16..AC-20
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
RULE="$PROJ/.claude/rules/obsidian-security.md"
PASS=0; FAIL=0; TOTAL=5

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A4: Security Rule Validation ==="
check "AC-16 AP1-AP5 present (≥5 entries)" "[ \$(grep -c 'AP[1-5]' '$RULE') -ge 5 ]"
check "AC-17 AP4 opt-OUT with cli-blocked" "grep -A2 'AP4' '$RULE' | grep -q 'cli-blocked'"
check "AC-18 Write-path whitelist defined" "grep -qi 'write-path\|whitelist\|designated' '$RULE'"
check "AC-19 .claude/ hybrid sweep" "grep -qi '\.claude.*grep\|hybrid\|grep sweep' '$RULE'"
check "AC-20 Layer discipline rule" "grep -qi 'knowledge layer\|layer discipline\|read-only' '$RULE'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
