#!/usr/bin/env bash
# Acceptance test runner — runs ALL test scripts, produces pass/fail summary
# AC-11: exits 0 only if all tests pass
set -uo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL=0; PASSED=0; FAILED=0; SKIPPED=0

TESTS=(
  "ab-retest.sh --dry-run"
  "test-skill-syntax.sh"
  "test-security-rule.sh"
  "test-fallback.sh"
  "test-adr.sh"
  "test-vault-scaffold.sh"
  "test-tool-routing.sh"
  "test-frontmatter-schema.sh"
  "test-template-routing.sh"
)

echo "╔══════════════════════════════════════════════════════╗"
echo "║  Obsidian CLI — Acceptance Test Suite (44 ACs)      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

RESULTS=()
for test_cmd in "${TESTS[@]}"; do
  script="${test_cmd%% *}"
  args="${test_cmd#"$script"}"
  ((TOTAL++))

  if [ ! -f "$DIR/$script" ]; then
    echo "SKIP: $script (not found)"
    ((SKIPPED++))
    RESULTS+=("SKIP  $script")
    continue
  fi

  echo "────────────────────────────────────────"
  if bash "$DIR/$script" $args 2>&1; then
    ((PASSED++))
    RESULTS+=("PASS  $script")
  else
    ((FAILED++))
    RESULTS+=("FAIL  $script")
  fi
  echo ""
done

echo "╔══════════════════════════════════════════════════════╗"
echo "║  SUMMARY                                            ║"
echo "╠══════════════════════════════════════════════════════╣"
for r in "${RESULTS[@]}"; do
  printf "║  %-50s ║\n" "$r"
done
echo "╠══════════════════════════════════════════════════════╣"
printf "║  TOTAL: %d  PASS: %d  FAIL: %d  SKIP: %d          ║\n" "$TOTAL" "$PASSED" "$FAILED" "$SKIPPED"
echo "╚══════════════════════════════════════════════════════╝"

# Exit with failure count (0 = all pass)
exit "$FAILED"
