#!/usr/bin/env bash
# Test: Tool routing validation (A5) — AC-35..AC-37
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
ROUTE="$PROJ/rules/tool-routing.md"
PASS=0; FAIL=0; TOTAL=3

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A5: Tool Routing Validation ==="
check "AC-35 obsidian-cli row exists" "grep -qi 'obsidian' '$ROUTE'"
check "AC-36 3-tool hierarchy (QMD)" "grep -qi 'QMD\|hierarchy\|routing' '$ROUTE'"
check "AC-37 .claude/ sweep noted" "grep -qi '\.claude\|mandatory\|sweep' '$ROUTE'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
