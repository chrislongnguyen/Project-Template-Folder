#!/usr/bin/env bash
# Test: Vault scaffold validation (A3) — AC-32..AC-34
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
VAULT_STRUCT="$PROJ/_genesis/obsidian/vault-structure.md"
PASS=0; FAIL=0; TOTAL=2

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A3: Vault Scaffold Validation ==="
check "AC-32 vault-structure.md exists" "[ -f '$VAULT_STRUCT' ]"
check "AC-33 vault-structure.md covers vault=repo architecture" "grep -qi 'vault.*repo\|ALPEI.*folder\|17.*folder' '$VAULT_STRUCT'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
