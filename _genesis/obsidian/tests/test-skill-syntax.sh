#!/usr/bin/env bash
# Test: SKILL.md syntax + content validation (A2) — AC-21..AC-31
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
SKILL="$PROJ/.claude/skills/obsidian/SKILL.md"
PASS=0; FAIL=0; TOTAL=11

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi; }

echo "=== A2: SKILL.md Validation ==="
check "AC-21 key=value syntax (no --flag in commands)" "! grep -P '^obsidian\s.*--|^\s+obsidian\s.*--' '$SKILL'"
check "AC-22 graph:walk removed" "! grep -q 'graph:walk' '$SKILL'"
check "AC-23 search:context documented" "grep -q 'search:context' '$SKILL'"
check "AC-24 orphans command documented" "grep -q 'orphans' '$SKILL'"
check "AC-25 backlinks + outgoing-links" "grep -q 'backlinks' '$SKILL' && grep -qE 'outgoing-links|links' '$SKILL'"
check "AC-26 cli-blocked (AP4 opt-out)" "grep -q 'cli-blocked' '$SKILL'"
check "AC-27 Vault targeting / worktree warning" "grep -qi 'worktree\|vault.*targeting\|single.*vault' '$SKILL'"
check "AC-28 3-tool routing (QMD)" "grep -qi 'QMD\|routing' '$SKILL'"
check "AC-29 Graceful degradation" "grep -qi 'fallback\|graceful\|grep' '$SKILL'"
check "AC-30 .claude/ grep sweep" "grep -qi '\.claude.*grep\|hybrid\|mandatory.*sweep' '$SKILL'"
check "AC-31 skill-validator.sh passes" "$PROJ/scripts/skill-validator.sh '$PROJ/.claude/skills/obsidian/'"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
