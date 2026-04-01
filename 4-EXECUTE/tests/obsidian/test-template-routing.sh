#!/usr/bin/env bash
# Test: Template routing rule validation (A8) — AC-42..AC-44
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
RULE="$PROJ/.claude/rules/alpei-template-usage.md"
PASS=0; FAIL=0; TOTAL=3

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A8: Template Routing Rule ==="
check "AC-42 Rule file exists with version frontmatter" "test -f '$RULE' && grep -q 'version:' '$RULE'"
check "AC-43 All 5 workstreams mapped (≥5 mentions)" "[ \$(grep -c 'ALIGN\|LEARN\|PLAN\|EXECUTE\|IMPROVE' '$RULE') -ge 5 ]"
check "AC-44 References our _genesis/templates/ files" "grep -q '_genesis/templates\|_TEMPLATE' '$RULE'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
