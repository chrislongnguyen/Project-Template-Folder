#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-08
#
# LEARN Skills Benchmark Suite — Orchestrator
#
# Runs L1 (static contract validation) + L2 (state simulation) deterministically.
# L3 (LLM-as-Judge) is run via --l3 flag which dispatches Opus sub-agents.
#
# Usage:
#   ./scripts/learn-benchmark.sh          # L1 + L2 only
#   ./scripts/learn-benchmark.sh --l3     # L1 + L2 + L3
#   ./scripts/learn-benchmark.sh --json   # JSON output for all layers
#

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Parse flags
RUN_L3=false
JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --l3)   RUN_L3=true ;;
        --json) JSON_MODE=true ;;
    esac
done

PASS=0
FAIL=0
TOTAL=0

# ── L1: Static Contract Validation ──────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  L1: Static Contract Validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if $JSON_MODE; then
    L1_OUTPUT=$(python3 "$SCRIPT_DIR/learn-benchmark-l1.py" --json 2>&1)
    echo "$L1_OUTPUT"
    L1_PASSED=$(echo "$L1_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['passed'])")
    L1_FAILED=$(echo "$L1_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['failed'])")
    L1_TOTAL=$(echo "$L1_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['total'])")
else
    python3 "$SCRIPT_DIR/learn-benchmark-l1.py" 2>&1 && L1_EXIT=0 || L1_EXIT=$?
    # Parse summary from last line
    L1_PASSED=$(python3 "$SCRIPT_DIR/learn-benchmark-l1.py" --json 2>&1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['passed'])")
    L1_FAILED=$(python3 "$SCRIPT_DIR/learn-benchmark-l1.py" --json 2>&1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['failed'])")
    L1_TOTAL=$(python3 "$SCRIPT_DIR/learn-benchmark-l1.py" --json 2>&1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['total'])")
fi

PASS=$((PASS + L1_PASSED))
FAIL=$((FAIL + L1_FAILED))
TOTAL=$((TOTAL + L1_TOTAL))

# ── L2: State Simulation ────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  L2: State Simulation Fixtures"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if $JSON_MODE; then
    L2_OUTPUT=$(python3 "$SCRIPT_DIR/learn-benchmark-l2.py" --json 2>&1)
    echo "$L2_OUTPUT"
    L2_PASSED=$(echo "$L2_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['passed'])")
    L2_FAILED=$(echo "$L2_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['failed'])")
    L2_TOTAL=$(echo "$L2_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['total'])")
else
    python3 "$SCRIPT_DIR/learn-benchmark-l2.py" 2>&1 && L2_EXIT=0 || L2_EXIT=$?
    L2_PASSED=$(python3 "$SCRIPT_DIR/learn-benchmark-l2.py" --json 2>&1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['passed'])")
    L2_FAILED=$(python3 "$SCRIPT_DIR/learn-benchmark-l2.py" --json 2>&1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['failed'])")
    L2_TOTAL=$(python3 "$SCRIPT_DIR/learn-benchmark-l2.py" --json 2>&1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['summary']['total'])")
fi

PASS=$((PASS + L2_PASSED))
FAIL=$((FAIL + L2_FAILED))
TOTAL=$((TOTAL + L2_TOTAL))

# ── L3: LLM-as-Judge (optional) ────────────────────────────────────────────

if $RUN_L3; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  L3: LLM-as-Judge (Opus)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  L3 requires interactive agent dispatch."
    echo "  Run from Claude Code session:"
    echo ""
    echo "    For each skill in learn*/SKILL.md:"
    echo "    1. Read the SKILL.md + its references/"
    echo "    2. Read scripts/learn-benchmark-l3-rubric.md"
    echo "    3. Dispatch ltc-reviewer (Opus) with rubric + skill content"
    echo "    4. Collect JSON scores"
    echo "    5. Repeat 3x for majority vote"
    echo ""
    echo "  Rubric: scripts/learn-benchmark-l3-rubric.md"
    echo ""
fi

# ── Summary ─────────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  LEARN Benchmark Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$TOTAL" -gt 0 ]; then
    PCT=$(( (PASS * 100) / TOTAL ))
else
    PCT=0
fi

echo "  L1 (Static):     ${L1_PASSED}/${L1_TOTAL}"
echo "  L2 (Simulation): ${L2_PASSED}/${L2_TOTAL}"
if $RUN_L3; then
    echo "  L3 (Judge):      (interactive — see above)"
fi
echo ""
echo "  Total: ${PASS}/${TOTAL} PASS (${PCT}%) | ${FAIL} FAIL"
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo "  Result: FAIL"
    exit 1
else
    echo "  Result: PASS"
    exit 0
fi
