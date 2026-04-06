#!/usr/bin/env bash
# Test: ADR-002 validation (A1) — AC-12..AC-15
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
ADR="$PROJ/1-ALIGN/decisions/ADR-002-obsidian-cli.md"
PASS=0; FAIL=0; TOTAL=4

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A1: ADR-002 Validation ==="
check "AC-12 Status=validated + Option B" "grep -q 'status: validated' '$ADR' && grep -q 'Option B' '$ADR'"
check "AC-13 RICE evidence (3.6x)" "grep -q '3.6' '$ADR'"
check "AC-14 AP4 opt-out rationale" "grep -qi 'opt-out\|cli-blocked' '$ADR'"
check "AC-15 Vinh adoption strategy" "grep -qi 'frontmatter\|extend.*template\|schema' '$ADR'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
