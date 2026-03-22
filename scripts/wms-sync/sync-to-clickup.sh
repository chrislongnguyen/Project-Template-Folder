#!/usr/bin/env bash
# LEP WMS Sync: .exec/ → ClickUp
#
# Reads .exec/status.json and syncs all tasks to ClickUp via the ClickUp MCP adapter.
# Uses .wms-sync.json for idempotency (won't create duplicates on re-run).
#
# Usage:
#   ./sync-to-clickup.sh [EXEC_DIR] [--dry-run]
#
# Arguments:
#   EXEC_DIR   Path to .exec/ directory (default: .exec)
#   --dry-run  Print the sync plan without making any API calls
#
# Exit codes:
#   0 = sync successful (or dry-run complete)
#   1 = fatal error (status.json missing, malformed, or fatal API failure)
#   2 = partial failure (some items failed; see output for details)
#
# Prerequisites:
#   - ClickUp MCP server must be active in the Claude Code session
#   - .exec/status.json must exist and be valid
#   - User must have confirmed the target ClickUp List before calling this script
#
# Protocol: skills/ltc-wms-adapters/clickup/adapter.md
# Field UUIDs: skills/ltc-wms-adapters/clickup/field-map.md
# Gotchas: skills/ltc-wms-adapters/clickup/gotchas.md

set -euo pipefail

# --- Arguments ---
# Parse positional and flag arguments in any order
DRY_RUN=false
EXEC_DIR=""
for arg in "$@"; do
    if [[ "$arg" == "--dry-run" ]]; then
        DRY_RUN=true
    elif [[ -z "$EXEC_DIR" ]]; then
        EXEC_DIR="$arg"
    fi
done
# Default to .exec in current working directory; resolve to absolute path
EXEC_DIR="${EXEC_DIR:-.exec}"
EXEC_DIR="$(cd "$(dirname "$EXEC_DIR")" 2>/dev/null && pwd)/$(basename "$EXEC_DIR")" 2>/dev/null || EXEC_DIR="$(pwd)/.exec"

STATUS_FILE="$EXEC_DIR/status.json"
SYNC_CACHE="$EXEC_DIR/.wms-sync.json"

# --- Validation ---
if [[ ! -f "$STATUS_FILE" ]]; then
    echo "ERROR: status.json not found at $STATUS_FILE" >&2
    echo "Run the execution-planner skill first to generate .exec/ files." >&2
    exit 1
fi

# Validate status.json is parseable
python3 -c "import json, sys; json.load(open('$STATUS_FILE'))" 2>/dev/null || {
    echo "ERROR: $STATUS_FILE is not valid JSON" >&2
    exit 1
}

# --- Status Mapping ---
# .exec/ → ClickUp status (per adapter.md §1)
# ready         → ready/prioritized
# blocked       → blocked
# in_progress   → in progress
# done          → review  (NEVER set to 'done' — human approves)
# rework        → do again (review failed)
# failed        → blocked

# --- Dry-run header ---
if [[ "$DRY_RUN" == "true" ]]; then
    echo "=== DRY RUN: ClickUp Sync Plan ==="
    echo "Source: $STATUS_FILE"
    echo ""
fi

# --- Extract project info ---
PROJECT=$(python3 -c "import json; d=json.load(open('$STATUS_FILE')); print(d.get('project','unknown'))")
SPEC_VERSION=$(python3 -c "import json; d=json.load(open('$STATUS_FILE')); print(d.get('spec_version','v1'))")
STAGE=$(python3 -c "import json; d=json.load(open('$STATUS_FILE')); print(d.get('pipeline_stage','unknown'))")

echo "Project: $PROJECT | Spec: $SPEC_VERSION | Stage: $STAGE"
echo ""

# --- Load sync cache (for idempotency) ---
if [[ -f "$SYNC_CACHE" ]]; then
    echo "INFO: Found existing sync cache at $SYNC_CACHE"
    echo "      Previously synced items will be updated (not duplicated)."
else
    echo "INFO: No sync cache found. All items will be created fresh."
fi
echo ""

# --- Enumerate all tasks from status.json ---
TASKS=$(python3 - <<'PYEOF'
import json, sys

with open(sys.argv[1]) as f:
    data = json.load(f)

for d_id, d_info in data.get("deliverables", {}).items():
    for t_id, t_info in d_info.get("tasks", {}).items():
        print(f"{d_id}\t{t_id}\t{t_info['name']}\t{t_info['status']}\t{t_info.get('agent_model','sonnet')}")
PYEOF
"$STATUS_FILE")

if [[ -z "$TASKS" ]]; then
    echo "INFO: No tasks found in status.json. Nothing to sync."
    exit 0
fi

# --- Status translation function ---
translate_status() {
    local exec_status="$1"
    case "$exec_status" in
        ready)       echo "ready/prioritized" ;;
        blocked)     echo "blocked" ;;
        in_progress) echo "in progress" ;;
        done)        echo "review" ;;  # CRITICAL: never set to 'done' directly
        rework)      echo "do again (review failed)" ;;
        failed)      echo "blocked" ;;
        *)           echo "draft" ;;
    esac
}

# --- Sync loop ---
TOTAL=0
SYNCED=0
FAILED=0

while IFS=$'\t' read -r D_ID T_ID TASK_NAME EXEC_STATUS AGENT_MODEL; do
    TOTAL=$((TOTAL + 1))
    CU_STATUS=$(translate_status "$EXEC_STATUS")

    # Check if already in cache
    CACHED_ID=""
    if [[ -f "$SYNC_CACHE" ]]; then
        CACHED_ID=$(python3 -c "
import json
with open('$SYNC_CACHE') as f:
    cache = json.load(f)
print(cache.get('items', {}).get('$T_ID', {}).get('wms_id', ''))
" 2>/dev/null || echo "")
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        if [[ -n "$CACHED_ID" ]]; then
            echo "  UPDATE $T_ID ($TASK_NAME)"
            echo "         ClickUp ID: $CACHED_ID"
            echo "         Status: $EXEC_STATUS → $CU_STATUS"
        else
            echo "  CREATE $T_ID ($TASK_NAME)"
            echo "         Status: $CU_STATUS | Model tag: $AGENT_MODEL"
        fi
        SYNCED=$((SYNCED + 1))
        continue
    fi

    # --- LIVE SYNC (requires ClickUp MCP) ---
    # This script is a coordination wrapper. The actual API calls must be made
    # through the ClickUp MCP server in the Claude Code session.
    #
    # The agent executing this script should:
    # 1. Call clickup_create_task (if no cached ID) with:
    #    - name: TASK_NAME
    #    - task_type: null (built-in default)
    #    - status: CU_STATUS
    #    - custom_fields: [ID/Short Name = T_ID, DESIRED OUTCOMES, ACCEPTANCE CRITERIA]
    # 2. OR call clickup_update_task (if cached ID exists) with:
    #    - task_id: CACHED_ID
    #    - status: CU_STATUS
    # 3. Update .wms-sync.json with the returned task ID
    #
    # For now, print the required action for the agent to execute via MCP:
    if [[ -n "$CACHED_ID" ]]; then
        echo "MCP_ACTION: clickup_update_task task_id=$CACHED_ID status='$CU_STATUS' name='$TASK_NAME'"
    else
        echo "MCP_ACTION: clickup_create_task name='$TASK_NAME' status='$CU_STATUS' id_short_name='$T_ID' model_tag='$AGENT_MODEL'"
    fi
    SYNCED=$((SYNCED + 1))

done <<< "$TASKS"

# --- Summary ---
echo ""
echo "=== Sync Summary ==="
echo "Total tasks: $TOTAL"
echo "Synced: $SYNCED"
echo "Failed: $FAILED"
echo ""

if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry-run complete. No changes made."
fi

if [[ "$FAILED" -gt 0 ]]; then
    echo "WARN: $FAILED tasks failed to sync. Re-run to retry (idempotent)." >&2
    exit 2
fi

echo "Done. Update .wms-sync.json with returned ClickUp task IDs after live sync."
exit 0
