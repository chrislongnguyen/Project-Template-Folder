#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-10
# dsbv-provenance-guard.sh — PreToolUse hook for Write|Edit
# P1: Auto-init gate state + enforce agent provenance for DSBV phase artifacts.
#
# Breaks the circular dependency: state tracking no longer depends on the
# orchestrator calling gate-state.sh init. This hook auto-initializes state
# when a DSBV artifact Write is detected, then checks provenance.
#
# BLOCKING: Write to DESIGN.md/SEQUENCE.md/VALIDATE.md without prior Agent()
#           dispatch to the designated agent (detected via dispatch audit log).
# NON-BLOCKING: state init failures (degrade gracefully).
#
# Bash 3 compatible.
set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Extract file path from Write or Edit tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BASENAME=$(basename "$FILE_PATH")

# ---------------------------------------------------------------------------
# GATE 1: Is this a DSBV phase artifact?
# Only check DESIGN.md, SEQUENCE.md, VALIDATE.md
# ---------------------------------------------------------------------------
case "$BASENAME" in
  DESIGN.md|SEQUENCE.md|VALIDATE.md) ;;
  *) exit 0 ;;  # Not a DSBV artifact — pass through
esac

# Determine workstream from path (e.g. 1-ALIGN, 3-PLAN, 4-EXECUTE, 5-IMPROVE)
WORKSTREAM=""
for WS in "1-ALIGN" "3-PLAN" "4-EXECUTE" "5-IMPROVE"; do
  if echo "$FILE_PATH" | grep -q "$WS"; then
    WORKSTREAM="$WS"
    break
  fi
done

# Also check _genesis/templates/ — template DESIGN.md is exempt from provenance
if echo "$FILE_PATH" | grep -q "_genesis/templates/"; then
  # Template files are governance artifacts — provenance check still applies
  # but workstream is GOVERN (no gate state tracking)
  WORKSTREAM="GOVERN"
fi

if [ -z "$WORKSTREAM" ]; then
  # Can't determine workstream — warn but don't block
  echo "WARN: Writing DSBV artifact '${BASENAME}' but cannot determine workstream from path." >&2
  echo "      Path: ${FILE_PATH}" >&2
  exit 0
fi

# ---------------------------------------------------------------------------
# GATE 2: Auto-init gate state (P1 — breaks circular dependency)
# ---------------------------------------------------------------------------
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
STATE_DIR="${PROJECT_ROOT:-.}/.claude/state"
GATE_STATE_SCRIPT="${PROJECT_ROOT:-.}/scripts/gate-state.sh"

if [ "$WORKSTREAM" != "GOVERN" ] && [ -f "$GATE_STATE_SCRIPT" ]; then
  STATE_FILE="${STATE_DIR}/dsbv-${WORKSTREAM}.json"
  if [ ! -f "$STATE_FILE" ]; then
    # Auto-init — this is the key fix. State is created by the HOOK, not the orchestrator.
    mkdir -p "$STATE_DIR"
    bash "$GATE_STATE_SCRIPT" init "$WORKSTREAM" 2>&1 || true
    echo "INFO: Auto-initialized gate state for ${WORKSTREAM} (provenance guard)." >&2
  fi
fi

# ---------------------------------------------------------------------------
# GATE 3: Provenance check — was the designated agent dispatched?
# ---------------------------------------------------------------------------
AUDIT_LOG="${PROJECT_ROOT:-.}/.claude/logs/dsbv-dispatch-audit.jsonl"

# Determine required agent for this artifact
REQUIRED_AGENT=""
case "$BASENAME" in
  DESIGN.md)   REQUIRED_AGENT="ltc-planner" ;;
  SEQUENCE.md) REQUIRED_AGENT="ltc-planner" ;;
  VALIDATE.md) REQUIRED_AGENT="ltc-reviewer" ;;
esac

if [ -z "$REQUIRED_AGENT" ]; then
  exit 0
fi

# Check if the dispatch audit log has a recent entry for the required agent
# "Recent" = within this session (approximated by entries in last 30 minutes)
PROVENANCE_OK=false

if [ -f "$AUDIT_LOG" ]; then
  # Look for the required agent in the last 20 log entries
  # (simple heuristic — session rarely has >20 Agent() calls)
  RECENT_MATCH=$(tail -20 "$AUDIT_LOG" 2>/dev/null | grep -c "\"agent\":\"${REQUIRED_AGENT}\"" || true)
  RECENT_MATCH=$(echo "$RECENT_MATCH" | tr -d '[:space:]')
  if [ -n "$RECENT_MATCH" ] && [ "$RECENT_MATCH" -gt 0 ] 2>/dev/null; then
    PROVENANCE_OK=true
  fi
fi

if [ "$PROVENANCE_OK" = false ]; then
  echo "" >&2
  echo "============================================================" >&2
  echo "BLOCKED: DSBV Provenance Guard" >&2
  echo "============================================================" >&2
  echo "Writing ${BASENAME} requires prior dispatch to ${REQUIRED_AGENT}." >&2
  echo "" >&2
  echo "  Artifact: ${BASENAME}" >&2
  echo "  Required agent: ${REQUIRED_AGENT}" >&2
  echo "  Audit log: ${AUDIT_LOG}" >&2
  echo "  Recent dispatches to ${REQUIRED_AGENT}: 0" >&2
  echo "" >&2
  echo "The orchestrator must dispatch to ${REQUIRED_AGENT} using the" >&2
  echo "5-field context packaging template before writing ${BASENAME}." >&2
  echo "Producing phase artifacts inline is not permitted." >&2
  echo "" >&2
  echo "Ref: SKILL.md 'do NOT produce it inline'" >&2
  echo "     .claude/rules/agent-dispatch.md" >&2
  echo "============================================================" >&2
  exit 1
fi

exit 0
