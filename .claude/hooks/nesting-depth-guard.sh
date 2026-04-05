#!/usr/bin/env bash
# version: 1.0 | status: Draft | last_updated: 2026-04-05
# nesting-depth-guard.sh — PostToolUse hook for Agent() calls
# EP-13 (Orchestrator Authority) observer.
#
# PURPOSE: Detect when Agent() is called from a sub-agent context (nesting violation).
# Logs every Agent() dispatch for audit trail. Warns if nesting is detected.
#
# LIMITATION: PostToolUse hooks fire in the calling session. If a sub-agent calls Agent(),
# this hook fires inside that sub-agent's isolated context — but whether PostToolUse
# hooks fire inside sub-agents at all is subject to platform behavior (related to #40580).
# As of 2026-04-05, there is no reliable mechanism to deterministically block sub-agent
# nesting (GitHub #40580). This hook provides observation + warning (Layer 2).
# Layer 3 enforcement: explicit Agent() prohibition in each leaf agent .md file.
#
# EXIT: Always 0. Nesting detection is advisory only.

set -euo pipefail

# Resolve project root
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$PROJECT_ROOT" ]]; then
  exit 0
fi

LOG_DIR="$PROJECT_ROOT/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/agent-nesting.log"

# Read dispatched agent info from env vars (Claude Code PostToolUse provides TOOL_INPUT_* vars)
DISPATCHED_AGENT="${TOOL_INPUT_subagent_type:-${TOOL_INPUT_description:-unknown}}"
CALLER_SESSION="${CLAUDE_SESSION_ID:-unknown}"
PARENT_AGENT="${CLAUDE_PARENT_AGENT_ID:-}"

TIMESTAMP=$(date -Iseconds)

# Log all Agent() dispatches — audit trail regardless of nesting
echo "[$TIMESTAMP] Agent() dispatch: target=${DISPATCHED_AGENT} | session=${CALLER_SESSION} | parent=${PARENT_AGENT:-none}" >> "$LOG_FILE"

# EP-13 nesting detection: CLAUDE_PARENT_AGENT_ID set means we are inside a sub-agent
if [[ -n "$PARENT_AGENT" ]]; then
  echo "⚠ EP-13 — Nesting detected: sub-agent context (parent=${PARENT_AGENT}) is dispatching '${DISPATCHED_AGENT}'." >&2
  echo "  Sub-agents are leaf nodes and must not spawn further agents (EP-13: Orchestrator Authority)." >&2
  echo "  See agent file Constraints section. Advisory only — cannot block deterministically (#40580)." >&2
fi

exit 0
