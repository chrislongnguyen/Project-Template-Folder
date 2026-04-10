#!/usr/bin/env bash
# version: 2.0 | last_updated: 2026-04-09
# verify-agent-dispatch.sh — PreToolUse hook for Agent tool
# Enforces context packaging template, model routing, gate state, and budget checks.
#
# BLOCKING (exit 1): missing CP markers (C-13)
# WARN only (exit 0): budget field (C-17), model routing (C-07), gate state (C-02),
#                     stage-agent compatibility (C-17 additional)
#
# Bash 3 compatible: indexed arrays only, no declare -A, no mapfile.
set -euo pipefail

# Read hook input from stdin (JSON)
INPUT=$(cat)

# Extract the prompt parameter from the Agent tool input
PROMPT=$(echo "$INPUT" | jq -r '.tool_input.prompt // ""')

# ---------------------------------------------------------------------------
# CHECK 1: 5/5 Context Packaging markers — BLOCKING (C-13)
# ---------------------------------------------------------------------------
REQUIRED_MARKERS=(
  "## 1. EO"
  "## 2. INPUT"
  "## 3. EP"
  "## 4. OUTPUT"
  "## 5. VERIFY"
)

MISSING=()

for MARKER in "${REQUIRED_MARKERS[@]}"; do
  if ! echo "$PROMPT" | grep -qF "$MARKER"; then
    MISSING+=("$MARKER")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "ERROR: Agent dispatch blocked — missing context packaging markers:" >&2
  for M in "${MISSING[@]}"; do
    echo "  - $M" >&2
  done
  echo "" >&2
  echo "Agent dispatch must use context packaging template (all 5 fields)." >&2
  echo "See .claude/skills/dsbv/references/context-packaging.md" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# CHECK 2: Budget field — WARN only (C-17)
# ---------------------------------------------------------------------------
if ! echo "$PROMPT" | grep -qE "### Budget|max_tool_calls"; then
  echo "WARN: Agent dispatch missing budget field (### Budget / max_tool_calls)." >&2
  echo "      Recommended for token governance. Non-blocking." >&2
fi

# ---------------------------------------------------------------------------
# CHECK 3: Model routing — WARN only (C-07)
# Expected: ltc-builder→sonnet, ltc-planner→opus, ltc-reviewer→opus, ltc-explorer→haiku
# ---------------------------------------------------------------------------
SUBAGENT_TYPE=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // ""')
DECLARED_MODEL=$(echo "$INPUT" | jq -r '.tool_input.model // ""')

# If subagent_type is empty, try to infer agent name from prompt text
if [ -z "$SUBAGENT_TYPE" ]; then
  if echo "$PROMPT" | grep -q "ltc-builder"; then
    SUBAGENT_TYPE="ltc-builder"
  elif echo "$PROMPT" | grep -q "ltc-planner"; then
    SUBAGENT_TYPE="ltc-planner"
  elif echo "$PROMPT" | grep -q "ltc-reviewer"; then
    SUBAGENT_TYPE="ltc-reviewer"
  elif echo "$PROMPT" | grep -q "ltc-explorer"; then
    SUBAGENT_TYPE="ltc-explorer"
  fi
fi

if [ -n "$SUBAGENT_TYPE" ] && [ -n "$DECLARED_MODEL" ]; then
  EXPECTED_MODEL=""
  case "$SUBAGENT_TYPE" in
    ltc-builder)  EXPECTED_MODEL="sonnet" ;;
    ltc-planner)  EXPECTED_MODEL="opus"   ;;
    ltc-reviewer) EXPECTED_MODEL="opus"   ;;
    ltc-explorer) EXPECTED_MODEL="haiku"  ;;
  esac

  if [ -n "$EXPECTED_MODEL" ]; then
    # Check if declared model contains expected tier name (handles full model IDs)
    if ! echo "$DECLARED_MODEL" | grep -qi "$EXPECTED_MODEL"; then
      echo "WARN: Model routing mismatch for ${SUBAGENT_TYPE}." >&2
      echo "      Expected model tier: ${EXPECTED_MODEL}" >&2
      echo "      Declared model: ${DECLARED_MODEL}" >&2
      echo "      Non-blocking (CCR does not honor model param). Ref: agent-dispatch.md" >&2
    fi
  fi
fi

# ---------------------------------------------------------------------------
# CHECK 4 + 5: Gate state check + Stage-agent compatibility — WARN only (C-02, C-17)
# ---------------------------------------------------------------------------
# Determine state dir relative to repo root. Hook fires from repo root.
STATE_DIR=".claude/state"

if [ -d "$STATE_DIR" ]; then
  # Try to extract workstream from prompt (e.g. 1-ALIGN, 3-PLAN)
  WORKSTREAM=""
  for WS in "1-ALIGN" "2-LEARN" "3-PLAN" "4-EXECUTE" "5-IMPROVE"; do
    if echo "$PROMPT" | grep -q "$WS"; then
      WORKSTREAM="$WS"
      break
    fi
  done

  if [ -n "$WORKSTREAM" ]; then
    STATE_FILE="${STATE_DIR}/dsbv-${WORKSTREAM}.json"

    if [ -f "$STATE_FILE" ]; then
      # Extract current_phase using grep/sed (avoid jq for state file)
      CURRENT_PHASE=$(grep '"current_phase"' "$STATE_FILE" | sed 's/.*"current_phase": *"\([^"]*\)".*/\1/')

      # Gate state check: agent-role-specific gate requirements
      case "$SUBAGENT_TYPE" in
        ltc-builder)
          G2_STATUS=$(grep '"G2"' "$STATE_FILE" | sed 's/.*"status": *"\([^"]*\)".*/\1/')
          if [ "$G2_STATUS" != "approved" ]; then
            echo "WARN: Dispatching ltc-builder but G2 (Sequence approved) is not approved." >&2
            echo "      G2 status: ${G2_STATUS} | workstream: ${WORKSTREAM}" >&2
            echo "      Build stage requires G2 approval. Non-blocking." >&2
          fi
          ;;
        ltc-reviewer)
          G3_STATUS=$(grep '"G3"' "$STATE_FILE" | sed 's/.*"status": *"\([^"]*\)".*/\1/')
          if [ "$G3_STATUS" != "approved" ]; then
            echo "WARN: Dispatching ltc-reviewer but G3 (Build approved) is not approved." >&2
            echo "      G3 status: ${G3_STATUS} | workstream: ${WORKSTREAM}" >&2
            echo "      Validate stage requires G3 approval. Non-blocking." >&2
          fi
          ;;
        ltc-planner)
          if echo "$PROMPT" | grep -qi "sequence"; then
            G1_STATUS=$(grep '"G1"' "$STATE_FILE" | sed 's/.*"status": *"\([^"]*\)".*/\1/')
            if [ "$G1_STATUS" != "approved" ]; then
              echo "WARN: Dispatching ltc-planner for Sequence but G1 (Design approved) is not approved." >&2
              echo "      G1 status: ${G1_STATUS} | workstream: ${WORKSTREAM}" >&2
              echo "      Sequence stage requires G1 approval. Non-blocking." >&2
            fi
          fi
          ;;
      esac

      # Stage-agent compatibility check (C-17 additional)
      if [ "$SUBAGENT_TYPE" = "ltc-planner" ] && [ -n "$CURRENT_PHASE" ]; then
        case "$CURRENT_PHASE" in
          build|validate)
            echo "WARN: Dispatching ltc-planner during '${CURRENT_PHASE}' stage (workstream: ${WORKSTREAM})." >&2
            echo "      ltc-planner is unusual in build/validate stages — verify this is intentional." >&2
            echo "      Non-blocking." >&2
            ;;
        esac
      fi
    fi
  fi
fi

exit 0
