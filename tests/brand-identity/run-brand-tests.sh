#!/usr/bin/env bash
# run-brand-tests.sh — Run brand identity validation against all fixtures.
# Usage: run-brand-tests.sh
# Exit: 0 = all assertions pass, 1 = any assertion fails
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="$SCRIPT_DIR/validate-brand.sh"
FIXTURES="$SCRIPT_DIR/fixtures"

TOTAL=0
PASSED=0
FAILED=0

# ═══════════════════════════════════════════════════════
# Test helper
# ═══════════════════════════════════════════════════════

assert_pass() {
    local file="$1"
    local name
    name=$(basename "$file")
    TOTAL=$((TOTAL + 1))

    output=$("$VALIDATOR" "$file" 2>&1)
    rc=$?
    if [ "$rc" -eq 0 ]; then
        echo "  PASS  $name (expected pass, got pass)"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL  $name (expected pass, got fail)"
        echo "$output" | sed 's/^/        /'
        FAILED=$((FAILED + 1))
    fi
}

assert_fail() {
    local file="$1"
    local name
    name=$(basename "$file")
    TOTAL=$((TOTAL + 1))

    output=$("$VALIDATOR" "$file" 2>&1)
    rc=$?
    if [ "$rc" -ne 0 ]; then
        echo "  PASS  $name (expected fail, got fail)"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL  $name (expected fail, got pass)"
        FAILED=$((FAILED + 1))
    fi
}

# ═══════════════════════════════════════════════════════
# Run assertions
# ═══════════════════════════════════════════════════════

echo "=== LTC Brand Identity Tests ==="
echo ""

for ext in html css svg py md; do
    good="$FIXTURES/good-sample.$ext"
    bad="$FIXTURES/bad-sample.$ext"

    if [ -f "$good" ]; then
        assert_pass "$good"
    else
        echo "  SKIP  good-sample.$ext (not found)"
    fi

    if [ -f "$bad" ]; then
        assert_fail "$bad"
    else
        echo "  SKIP  bad-sample.$ext (not found)"
    fi
done

# ═══════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════

echo ""
echo "=== Results: $PASSED/$TOTAL passed ==="

if [ "$FAILED" -gt 0 ]; then
    echo "$FAILED assertion(s) failed."
    exit 1
else
    echo "All assertions passed."
    exit 0
fi
