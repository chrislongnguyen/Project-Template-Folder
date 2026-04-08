#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-08
# pre-flight.sh — Implements the 9 CLAUDE.md pre-flight checks
# Usage: ./scripts/pre-flight.sh <workstream>
# Example: ./scripts/pre-flight.sh 1-ALIGN
# Output: PASS/FAIL/WARN per check
set -euo pipefail

WORKSTREAM="${1:-}"
if [[ -z "$WORKSTREAM" ]]; then
  echo "Usage: $0 <workstream>"
  echo "  e.g., $0 1-ALIGN"
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0
WARN=0

check() {
  local id="$1" name="$2" result="$3" detail="${4:-}"
  printf "%-6s %-4s %s" "$id" "$result" "$name"
  [[ -n "$detail" ]] && printf " — %s" "$detail"
  echo ""
  case "$result" in
    PASS) PASS=$((PASS + 1)) ;;
    FAIL) FAIL=$((FAIL + 1)) ;;
    WARN) WARN=$((WARN + 1)) ;;
  esac
}

echo "Pre-Flight Check — $WORKSTREAM"
echo "================================"

# C1: WORKSTREAM — identify which workstream
if [[ -d "$WORKSTREAM" ]]; then
  check "C1" "Workstream directory exists" "PASS"
else
  check "C1" "Workstream directory exists" "FAIL" "$WORKSTREAM/ not found"
fi

# C2: ALIGNMENT — BLUEPRINT.md + charter
if [[ -f "_genesis/BLUEPRINT.md" ]]; then
  check "C2a" "BLUEPRINT.md present" "PASS"
else
  check "C2a" "BLUEPRINT.md present" "WARN" "_genesis/BLUEPRINT.md not found"
fi
CHARTER_DIR="1-ALIGN/charter"
if [[ -d "$CHARTER_DIR" ]] && ls "$CHARTER_DIR"/*.md >/dev/null 2>&1; then
  check "C2b" "Charter artifacts exist" "PASS"
else
  check "C2b" "Charter artifacts exist" "WARN" "No .md files in $CHARTER_DIR/"
fi

# C3: RISKS — UBS register
UBS_FILE="3-PLAN/risks/UBS_REGISTER.md"
if [[ -f "$UBS_FILE" ]]; then
  check "C3" "UBS Register present" "PASS"
else
  check "C3" "UBS Register present" "WARN" "$UBS_FILE not found"
fi

# C4: DRIVERS — UDS register
UDS_FILE="3-PLAN/drivers/UDS_REGISTER.md"
if [[ -f "$UDS_FILE" ]]; then
  check "C4" "UDS Register present" "PASS"
else
  check "C4" "UDS Register present" "WARN" "$UDS_FILE not found"
fi

# C5: TEMPLATES — DSBV process map routing
PROCESS_MAP="_genesis/frameworks/alpei-dsbv-process-map.md"
if [[ -f "$PROCESS_MAP" ]]; then
  WS_NAME=$(echo "$WORKSTREAM" | sed 's/^[0-9]-//')
  if grep -qi "## Routing.*$WS_NAME" "$PROCESS_MAP" 2>/dev/null; then
    check "C5" "Routing table found for $WS_NAME" "PASS"
  else
    check "C5" "Routing table found for $WS_NAME" "WARN" "No routing section in process map"
  fi
else
  check "C5" "DSBV process map present" "WARN" "$PROCESS_MAP not found"
fi

# C6: LEARNING — 2-LEARN has content
if [[ -d "2-LEARN" ]] && find "2-LEARN" -name "*.md" -maxdepth 3 2>/dev/null | head -1 | grep -q .; then
  check "C6" "Learning artifacts present" "PASS"
else
  check "C6" "Learning artifacts present" "WARN" "No .md files found in 2-LEARN/"
fi

# C7: VERSION — version registry exists and has entries
REGISTRY="_genesis/version-registry.md"
if [[ -f "$REGISTRY" ]]; then
  check "C7" "Version registry present" "PASS"
else
  check "C7" "Version registry present" "WARN" "$REGISTRY not found"
fi

# C8: EXECUTE — DESIGN.md prerequisite for Build
DESIGN_FILE="$WORKSTREAM/DESIGN.md"
if [[ -f "$DESIGN_FILE" ]]; then
  check "C8" "DESIGN.md exists for $WORKSTREAM" "PASS"
else
  check "C8" "DESIGN.md exists for $WORKSTREAM" "WARN" "No DESIGN.md — needed before Build phase"
fi

# C9: DOCUMENT — decisions directory
DECISIONS_DIR="1-ALIGN/decisions"
if [[ -d "$DECISIONS_DIR" ]]; then
  check "C9" "Decisions directory exists" "PASS"
else
  check "C9" "Decisions directory exists" "WARN" "$DECISIONS_DIR/ not found"
fi

echo "================================"
echo "Results: $PASS PASS | $FAIL FAIL | $WARN WARN"

if [[ $FAIL -gt 0 ]]; then
  exit 1
else
  exit 0
fi
