#!/usr/bin/env bash
# version: 2.0 | status: Draft | last_updated: 2026-04-05
# Structural validator for ltc-brainstorming I3 upgrade
# Usage: ./scripts/validate-brainstorming-i3.sh
# Exit 0 = all pass, Exit 1 = one or more fail

set -uo pipefail

SKILL_DIR="$(dirname "$0")/../.claude/skills/ltc-brainstorming"
SKILL_MD="$SKILL_DIR/SKILL.md"
MODES_MD="$SKILL_DIR/references/discovery-modes.md"

PASS=0
FAIL=0

check() {
  local id="$1" desc="$2" result="$3"
  if [ "$result" = "0" ]; then
    echo "  PASS  $id: $desc"
    ((PASS++)) || true
  else
    echo "  FAIL  $id: $desc"
    ((FAIL++)) || true
  fi
}

echo "=== validate-brainstorming-i3 ==="

# AC-S1: SKILL.md ≤ 220 lines
lines=$(wc -l < "$SKILL_MD")
[ "$lines" -le 220 ]
check "AC-S1" "SKILL.md ≤ 220 lines (got $lines)" $?

# AC-S2: discovery-modes.md exists
[ -f "$MODES_MD" ]
check "AC-S2" "discovery-modes.md exists" $?

# AC-S3: All 6 protocol elements present in discovery-modes.md
for element in "EO Gate" "EO Clarifier" "ESD Decomposer" "Premises Check" "Force Analysis" "S/E/Sc Comparator"; do
  grep -q "$element" "$MODES_MD" 2>/dev/null
  check "AC-S3" "Mode present: $element" $?
done

# AC-S4: Both terminal states present in SKILL.md
grep -q "/dsbv" "$SKILL_MD"
check "AC-S4a" "Terminal state: /dsbv present" $?
grep -q "Discovery Complete" "$SKILL_MD"
check "AC-S4b" "Terminal state: Discovery Complete present" $?

# AC-S5: Frontmatter has ≥3 trigger phrases
count=$(grep -oE "(I'm thinking|what if|how should I)" "$SKILL_MD" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
[ "$count" -ge 3 ]
check "AC-S5" "≥3 trigger phrases in frontmatter (got $count)" $?

# AC-S6: No broken references to deleted skills
for banned in "writing-plans" "session-start" "session-end"; do
  ! grep -q "$banned" "$SKILL_MD" 2>/dev/null
  check "AC-S6" "No reference to '$banned'" $?
done

# AC-S7: Each mode has trigger + action + exit fields in discovery-modes.md
for field in "Trigger" "Action" "Exit"; do
  count=$(grep -c "^## $field\|^**$field\|$field:" "$MODES_MD" 2>/dev/null || echo 0)
  [ "$count" -ge 4 ]
  check "AC-S7" "Field '$field' appears ≥4 times in modes (got $count)" $?
done

echo ""
echo "Result: $PASS pass, $FAIL fail"
[ "$FAIL" -eq 0 ]
