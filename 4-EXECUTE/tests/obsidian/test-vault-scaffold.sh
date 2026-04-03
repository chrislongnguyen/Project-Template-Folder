#!/usr/bin/env bash
# Test: Vault scaffold validation (A3) — AC-32..AC-34
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
VAULT="$PROJ/4-EXECUTE/src/vault"
PASS=0; FAIL=0; TOTAL=3

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A3: Vault Scaffold Validation ==="
check "AC-32 Required folders exist (≥6 items)" "[ \$(ls '$VAULT' 2>/dev/null | wc -l) -ge 6 ]"
check "AC-33 READMEs have zone: frontmatter (≥5)" "[ \$(grep -rl 'zone:' '$VAULT'/*/README.md 2>/dev/null | wc -l) -ge 5 ]"
check "AC-34 VAULT_GUIDE covers Option C" "grep -qi 'flat\|frontmatter.*tag\|Option C' '$VAULT/vault-guide.md'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
