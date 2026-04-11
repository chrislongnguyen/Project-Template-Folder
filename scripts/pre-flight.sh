#!/usr/bin/env bash
# version: 1.2 | status: draft | last_updated: 2026-04-11
# pre-flight.sh — Implements the 9 CLAUDE.md pre-flight checks
# Check legend: C1=Workstream C2=Alignment C3=Risks C4=Drivers C5=Templates C6=Learning C7=Version C8=Execute C9=Document
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

# Criterion 1: WORKSTREAM — identify which workstream
if [[ -d "$WORKSTREAM" ]]; then
  check "C1" "Workstream directory exists" "PASS"
else
  check "C1" "Workstream directory exists" "FAIL" "$WORKSTREAM/ not found"
fi

# Criterion 2: ALIGNMENT — BLUEPRINT.md + ALIGN subsystem dirs
if [[ -f "_genesis/BLUEPRINT.md" ]]; then
  check "C2a" "BLUEPRINT.md present" "PASS"
else
  check "C2a" "BLUEPRINT.md present" "WARN" "_genesis/BLUEPRINT.md not found"
fi
# Charters are per-subsystem; check 1-ALIGN/1-PD as canary for subsystem scaffold
CHARTER_DIR="1-ALIGN/1-PD"
if [[ -d "$CHARTER_DIR" ]]; then
  check "C2b" "ALIGN subsystem dirs exist" "PASS"
else
  check "C2b" "ALIGN subsystem dirs exist" "WARN" "$CHARTER_DIR/ not found — run /setup to scaffold"
fi

# Criterion 3: RISKS — UBS register
UBS_FILE="3-PLAN/_cross/UBS_REGISTER.md"
if [[ -f "$UBS_FILE" ]]; then
  check "C3" "UBS Register present" "PASS"
else
  check "C3" "UBS Register present" "WARN" "$UBS_FILE not found"
fi

# Criterion 4: DRIVERS — UDS register
UDS_FILE="3-PLAN/_cross/UDS_REGISTER.md"
if [[ -f "$UDS_FILE" ]]; then
  check "C4" "UDS Register present" "PASS"
else
  check "C4" "UDS Register present" "WARN" "$UDS_FILE not found"
fi

# Criterion 5: TEMPLATES — DSBV process map routing
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

# Criterion 6: LEARNING — 2-LEARN has content
if [[ -d "2-LEARN" ]] && find "2-LEARN" -name "*.md" -maxdepth 3 2>/dev/null | head -1 | grep -q .; then
  check "C6" "Learning artifacts present" "PASS"
else
  check "C6" "Learning artifacts present" "WARN" "No .md files found in 2-LEARN/"
fi

# Criterion 7: VERSION — version registry exists and has entries
REGISTRY="_genesis/version-registry.md"
if [[ -f "$REGISTRY" ]]; then
  check "C7" "Version registry present" "PASS"
else
  check "C7" "Version registry present" "WARN" "$REGISTRY not found"
fi

# Criterion 8: EXECUTE — DESIGN.md prerequisite for Build
DESIGN_FILE="$WORKSTREAM/DESIGN.md"
if [[ -f "$DESIGN_FILE" ]]; then
  check "C8" "DESIGN.md exists for $WORKSTREAM" "PASS"
else
  check "C8" "DESIGN.md exists for $WORKSTREAM" "WARN" "No DESIGN.md — needed before Build stage"
fi

# Criterion 9: DOCUMENT — cross-cutting dir in ALIGN (decisions go in subsystem dirs)
DECISIONS_DIR="1-ALIGN/_cross"
if [[ -d "$DECISIONS_DIR" ]]; then
  check "C9" "Cross-cutting dir exists in ALIGN" "PASS"
else
  check "C9" "Cross-cutting dir exists in ALIGN" "WARN" "$DECISIONS_DIR/ not found"
fi

echo "================================"
echo "Results: $PASS PASS | $FAIL FAIL | $WARN WARN"

if [[ $FAIL -gt 0 ]]; then
  exit 1
else
  exit 0
fi
