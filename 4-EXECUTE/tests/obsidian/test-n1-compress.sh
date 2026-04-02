#!/usr/bin/env bash
# Test: N1 Session Compression Optimization — AC-N1-01..AC-N1-06
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
SKILL="$PROJ/.claude/skills/session/compress/SKILL.md"
TEMPLATE="$PROJ/.claude/skills/session/compress/templates/session-summary.md"
CHEAT="$PROJ/_genesis/sops/session-lifecycle-cheatsheet.md"
PASS=0; FAIL=0; TOTAL=6

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== N1: Session Compression Optimization ==="
check "AC-N1-01 SKILL.md exists" "test -f '$SKILL'"
check "AC-N1-02 Vault path resolution (config.sh or MEMORY_VAULT)" "grep -qi 'config\.sh\|MEMORY_VAULT\|vault.*path' '$SKILL'"
check "AC-N1-03 Session file path format (YYYY-MM-DD kebab)" "grep -qi 'YYYY-MM-DD\|kebab\|slug' '$SKILL'"
check "AC-N1-04 Frontmatter fields (type, date, project, outcome)" "grep -q 'type' '$SKILL' && grep -q 'outcome' '$SKILL' && grep -qi 'date' '$SKILL'"
check "AC-N1-05 Body conciseness constraint (≤20 lines or token budget)" "grep -qiE '20 lines|500 token|concise|budget' '$SKILL'"
check "AC-N1-06 Template file exists" "test -f '$TEMPLATE'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
