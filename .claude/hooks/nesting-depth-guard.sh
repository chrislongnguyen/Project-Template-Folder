#!/usr/bin/env bash
# version: 2.0 | status: draft | last_updated: 2026-04-10
# nesting-depth-guard.sh — PostToolUse hook for Agent() calls
# EP-13 (Orchestrator Authority) observer + P2 dispatch audit logger.
#
# PURPOSE:
#   1. Detect sub-agent nesting violations (EP-13)
#   2. Log every Agent() dispatch to structured JSONL audit log (P2)
#      → consumed by dsbv-provenance-guard.sh to verify stage artifact provenance
#
# LIMITATION: PostToolUse hooks fire in the calling session. If a sub-agent calls Agent(),
# this hook fires inside that sub-agent's isolated context — but whether PostToolUse
# hooks fire inside sub-agents at all is subject to platform behavior (related to #40580).
#
# EXIT: Always 0. Nesting detection + audit logging are advisory/observational.

set -euo pipefail

# Resolve project root
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$PROJECT_ROOT" ]]; then
  exit 0
fi

LOG_DIR="$PROJECT_ROOT/.claude/logs"
mkdir -p "$LOG_DIR"

# Legacy text log (backward compatible)
NESTING_LOG="$LOG_DIR/agent-nesting.log"

# P2: Structured JSONL audit log (consumed by dsbv-provenance-guard.sh)
AUDIT_LOG="$LOG_DIR/dsbv-dispatch-audit.jsonl"

# Read dispatched agent info from env vars (Claude Code PostToolUse provides TOOL_INPUT_* vars)
DISPATCHED_AGENT="${TOOL_INPUT_subagent_type:-${TOOL_INPUT_description:-unknown}}"
CALLER_SESSION="${CLAUDE_SESSION_ID:-unknown}"
PARENT_AGENT="${CLAUDE_PARENT_AGENT_ID:-}"
AGENT_NAME="${TOOL_INPUT_name:-}"

TIMESTAMP=$(date -u "+%Y-%m-%dT%H:%M:%SZ")

# Legacy text log
echo "[$TIMESTAMP] Agent() dispatch: target=${DISPATCHED_AGENT} | session=${CALLER_SESSION} | parent=${PARENT_AGENT:-none}" >> "$NESTING_LOG"

# P2: Structured JSONL audit log
# This is the provenance chain — dsbv-provenance-guard.sh reads this to verify
# that the designated agent was dispatched before a DSBV artifact Write.
printf '{"ts":"%s","agent":"%s","name":"%s","session":"%s","parent":"%s"}\n' \
  "$TIMESTAMP" "$DISPATCHED_AGENT" "$AGENT_NAME" "$CALLER_SESSION" "${PARENT_AGENT:-none}" \
  >> "$AUDIT_LOG"

# EP-13 nesting detection: CLAUDE_PARENT_AGENT_ID set means we are inside a sub-agent
if [[ -n "$PARENT_AGENT" ]]; then
  echo "⚠ EP-13 — Nesting detected: sub-agent context (parent=${PARENT_AGENT}) is dispatching '${DISPATCHED_AGENT}'." >&2
  echo "  Sub-agents are leaf nodes and must not spawn further agents (EP-13: Orchestrator Authority)." >&2
  echo "  See agent file Constraints section. Advisory only — cannot block deterministically (#40580)." >&2
fi

exit 0
