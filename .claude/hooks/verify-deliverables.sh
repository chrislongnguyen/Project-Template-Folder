#!/usr/bin/env bash
# version: 2.0 | status: draft | last_updated: 2026-04-09
# verify-deliverables.sh — SubagentStop hook
# Checks that sub-agent output references expected deliverables before completing.
# Also checks context packaging markers (## 1. EO, ## 5. VERIFY) per agent-dispatch.md.
# EP-12 (Verified Handoff): checks DONE format Blockers field — blocks if non-none/non-warn.
# Non-blocking failure: logs warning but does not block (human reviews).
# Blocking failure: EP-12 Blockers non-none (exit 1) | AC file pattern missing (exit 2).
#
# EP-12 SCOPE: Applies to ltc-builder and ltc-reviewer outputs only (DONE format required).
# ltc-planner and ltc-explorer produce full content reports — exempt. Their handoffs rely
# on human gates G1+G2 in the DSBV process. This is intentional, not a gap.
#
# NOTE: PreToolUse exit codes are IGNORED for Agent() calls (GitHub #40580).
# This SubagentStop hook is the only enforcement point for context packaging.
set -euo pipefail

# Read hook input from stdin (JSON)
INPUT=$(cat)

# Extract sub-agent details
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
LAST_MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message // ""')
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')

# Prevent infinite loops
if [[ "$STOP_HOOK_ACTIVE" == "true" ]]; then
  exit 0
fi

# Resolve project root
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$PROJECT_ROOT" ]]; then
  exit 0
fi

# Check context packaging markers in sub-agent output
# These markers indicate the agent was invoked with the 5-field template
CP_WARNINGS=""
if [[ -n "$LAST_MESSAGE" ]]; then
  if ! echo "$LAST_MESSAGE" | grep -q "## 1\. EO"; then
    CP_WARNINGS="${CP_WARNINGS}\n  - Missing '## 1. EO' — agent may not have received context package"
  fi
  if ! echo "$LAST_MESSAGE" | grep -q "## 5\. VERIFY"; then
    CP_WARNINGS="${CP_WARNINGS}\n  - Missing '## 5. VERIFY' — agent may not have self-verified"
  fi
fi

if [[ -n "$CP_WARNINGS" ]]; then
  echo "⚠ Context packaging check for '${AGENT_TYPE}':${CP_WARNINGS}" >&2
  echo "Agent output may lack structured verification. Review before trusting." >&2
  # Non-blocking: warn only (context packaging is best-effort due to #40580)
fi

# EP-12 (Verified Handoff): parse DONE format Blockers field
# Format: DONE: <path> | ACs: <x>/<y> | Blockers: <none | WARN ... | FAIL ...>
# Applies to ltc-builder and ltc-reviewer only (per sub-agent-output.md).
# ltc-planner and ltc-explorer are exempt — they produce full content, not DONE reports.
if [[ -n "$LAST_MESSAGE" ]]; then
  DONE_LINE=$(echo "$LAST_MESSAGE" | grep -E "^DONE:" | head -1 || true)
  if [[ -n "$DONE_LINE" ]] && echo "$DONE_LINE" | grep -q "Blockers:"; then
    BLOCKERS=$(echo "$DONE_LINE" | sed 's/.*Blockers: *//' | xargs)
    if [[ -z "$BLOCKERS" ]]; then
      echo "⚠ EP-12 — DONE format incomplete: Blockers field is empty. Review before treating as done." >&2
    elif echo "$BLOCKERS" | grep -qi "^none"; then
      : # Clean handoff — all ACs pass, no blockers
    elif echo "$BLOCKERS" | grep -qi "WARN"; then
      echo "⚠ EP-12 — Handoff has warnings (non-blocking): ${BLOCKERS}" >&2
    else
      echo "✗ EP-12 — Handoff blocked. Sub-agent reported unresolved blockers:" >&2
      echo "  ${BLOCKERS}" >&2
      echo "  Resolve blockers before treating this output as ground truth (EP-12: Verified Handoff)." >&2
      exit 1
    fi
  fi
fi

# ── C-03: Enhanced DONE line schema validation ───────────────────────────────
# Validate all 3 fields are present and well-formed.
# Only runs when a DONE line was found (builder/reviewer agents).
ARTIFACT_PATH=""
ACS_PASS=""
ACS_TOTAL=""
BLOCKERS_TEXT=""

if [[ -n "$LAST_MESSAGE" ]]; then
  DONE_LINE_SCHEMA=$(echo "$LAST_MESSAGE" | grep -E "^DONE:" | head -1 || true)
  if [[ -n "$DONE_LINE_SCHEMA" ]]; then
    # Extract field 1: path (between "DONE: " and " | ACs:")
    ARTIFACT_PATH=$(echo "$DONE_LINE_SCHEMA" | sed 's/^DONE: *//' | sed 's/ *|.*//' | xargs)
    # Extract field 2: ACs value (between "ACs: " and " | Blockers:")
    ACS_FIELD=$(echo "$DONE_LINE_SCHEMA" | sed 's/.*ACs: *//' | sed 's/ *|.*//' | xargs)
    # Extract field 3: Blockers value (after "Blockers: ")
    BLOCKERS_TEXT=$(echo "$DONE_LINE_SCHEMA" | sed 's/.*Blockers: *//' | xargs)

    # Validate field 1: non-empty path
    if [[ -z "$ARTIFACT_PATH" ]]; then
      echo "✗ C-03 — DONE line schema invalid: path field is empty" >&2
      exit 1
    fi

    # Validate field 2: ACs matches N/M pattern
    if ! echo "$ACS_FIELD" | grep -qE "^[0-9]+/[0-9]+$"; then
      echo "✗ C-03 — DONE line schema invalid: ACs field '${ACS_FIELD}' does not match N/M pattern" >&2
      exit 1
    fi
    ACS_PASS=$(echo "$ACS_FIELD" | cut -d/ -f1)
    ACS_TOTAL=$(echo "$ACS_FIELD" | cut -d/ -f2)

    # Validate field 3: non-empty blockers
    if [[ -z "$BLOCKERS_TEXT" ]]; then
      echo "✗ C-03 — DONE line schema invalid: Blockers field is empty" >&2
      exit 1
    fi
  fi
fi

# ── C-03: Artifact existence check ───────────────────────────────────────────
# If DONE line was found and path is non-empty, verify the artifact exists.
if [[ -n "$ARTIFACT_PATH" ]]; then
  # Skip http/https URLs
  if ! echo "$ARTIFACT_PATH" | grep -qE "^https?://"; then
    # Absolute path: check directly; relative path: resolve against PROJECT_ROOT
    if echo "$ARTIFACT_PATH" | grep -q "^/"; then
      FULL_ARTIFACT_PATH="$ARTIFACT_PATH"
    else
      FULL_ARTIFACT_PATH="$PROJECT_ROOT/$ARTIFACT_PATH"
    fi
    if ! test -f "$FULL_ARTIFACT_PATH"; then
      echo "✗ C-03 — Artifact claimed but not found on disk: ${ARTIFACT_PATH}" >&2
      exit 1
    fi
  fi
fi

# ── C-16: Metrics logging ─────────────────────────────────────────────────────
# Append one JSON object to dsbv-metrics.jsonl (best-effort, never blocks).
# Runs whenever DONE line was found and parsed; safe to run even if some fields empty.
if [[ -n "$ARTIFACT_PATH" && -n "$ACS_PASS" && -n "$ACS_TOTAL" ]]; then
  LOG_DIR="$PROJECT_ROOT/.claude/logs"
  mkdir -p "$LOG_DIR" || true

  # Detect phase from artifact path
  PHASE="unknown"
  if echo "$ARTIFACT_PATH" | grep -qi "DESIGN"; then
    PHASE="design"
  elif echo "$ARTIFACT_PATH" | grep -qi "SEQUENCE"; then
    PHASE="sequence"
  elif echo "$ARTIFACT_PATH" | grep -qi "VALIDATE"; then
    PHASE="validate"
  elif echo "$ARTIFACT_PATH" | grep -qi "BUILD\|build\|4-EXECUTE\|src"; then
    PHASE="build"
  fi

  TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo "")
  # Escape double-quotes in text fields for valid JSON
  SAFE_TASK=$(echo "$ARTIFACT_PATH" | sed 's/"/\\"/g')
  SAFE_AGENT=$(echo "$AGENT_TYPE" | sed 's/"/\\"/g')
  SAFE_BLOCKERS=$(echo "$BLOCKERS_TEXT" | sed 's/"/\\"/g')

  echo "{\"timestamp\":\"${TIMESTAMP}\",\"agent\":\"${SAFE_AGENT}\",\"phase\":\"${PHASE}\",\"task\":\"${SAFE_TASK}\",\"acs_pass\":${ACS_PASS},\"acs_total\":${ACS_TOTAL},\"blockers\":\"${SAFE_BLOCKERS}\"}" \
    >> "$LOG_DIR/dsbv-metrics.jsonl" || true
fi

# Check for AC verification file: .claude/ac/<agent-type>.json
# Format: {"criteria": [{"id": "AC-01", "description": "...", "pattern": "regex"}]}
AC_FILE="$PROJECT_ROOT/.claude/ac/${AGENT_TYPE}.json"
if [[ ! -f "$AC_FILE" ]]; then
  # No AC file for this agent type — skip verification
  exit 0
fi

# Verify each AC pattern exists in the sub-agent's last message
FAIL_COUNT=0
FAIL_LIST=""

while IFS= read -r line; do
  AC_ID=$(echo "$line" | jq -r '.id')
  AC_DESC=$(echo "$line" | jq -r '.description')
  AC_PATTERN=$(echo "$line" | jq -r '.pattern')

  if ! echo "$LAST_MESSAGE" | grep -qE "$AC_PATTERN"; then
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAIL_LIST="${FAIL_LIST}\n  - ${AC_ID}: ${AC_DESC}"
  fi
done < <(jq -c '.criteria[]' "$AC_FILE")

if [[ $FAIL_COUNT -gt 0 ]]; then
  # Log to project log
  LOG_DIR="$PROJECT_ROOT/.claude/logs"
  mkdir -p "$LOG_DIR"
  echo "[$(date -Iseconds)] SubagentStop WARN: ${AGENT_TYPE} failed ${FAIL_COUNT} ACs:${FAIL_LIST}" >> "$LOG_DIR/hook-verify.log"

  # Output warning to stderr (shown to user)
  echo "⚠ Sub-agent '${AGENT_TYPE}' output missing ${FAIL_COUNT} acceptance criteria:${FAIL_LIST}" >&2
  echo "Review output before treating as complete." >&2

  # Block: exit 2 prevents sub-agent from completing
  exit 2
fi

exit 0
