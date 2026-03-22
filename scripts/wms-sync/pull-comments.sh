#!/usr/bin/env bash
# LEP WMS Sync: Pull unprocessed WMS comments → .exec/ rework entries
#
# Implements the Agent Pull Pattern (spec §2.4).
# Reads .wms-sync.json to find ClickUp task IDs, then pulls comments on tasks
# in "review" or "rework" status. Creates rework entries in status.json for
# any unprocessed human feedback comments.
#
# Usage:
#   ./pull-comments.sh [EXEC_DIR] [--dry-run]
#
# Arguments:
#   EXEC_DIR   Path to .exec/ directory (default: .exec)
#   --dry-run  Print what would be updated without modifying status.json
#
# Exit codes:
#   0 = success (no new comments, or rework entries created)
#   1 = fatal error (missing files, malformed JSON)
#   2 = partial failure (some tasks could not be queried)
#
# Protocol: spec §2.4 (Agent Pull Pattern)
# Adapter: skills/ltc-wms-adapters/clickup/adapter.md §3

set -euo pipefail

# --- Arguments ---
EXEC_DIR="${1:-.exec}"
DRY_RUN=false
if [[ "${2:-}" == "--dry-run" ]] || [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    [[ "${1:-}" == "--dry-run" ]] && EXEC_DIR=".exec"
fi

STATUS_FILE="$EXEC_DIR/status.json"
SYNC_CACHE="$EXEC_DIR/.wms-sync.json"

# --- Validation ---
if [[ ! -f "$STATUS_FILE" ]]; then
    echo "ERROR: status.json not found at $STATUS_FILE" >&2
    exit 1
fi

if [[ ! -f "$SYNC_CACHE" ]]; then
    echo "INFO: No .wms-sync.json found. Run sync-to-clickup.sh first to populate cache."
    echo "INFO: No comments to pull (no WMS items synced yet)."
    exit 0
fi

# Validate files are parseable
python3 -c "import json; json.load(open('$STATUS_FILE'))" 2>/dev/null || {
    echo "ERROR: $STATUS_FILE is not valid JSON" >&2
    exit 1
}
python3 -c "import json; json.load(open('$SYNC_CACHE'))" 2>/dev/null || {
    echo "ERROR: $SYNC_CACHE is not valid JSON" >&2
    exit 1
}

echo "=== Pulling WMS Comments → .exec/ Rework Entries ==="
echo "Source: $SYNC_CACHE"
echo ""

# --- Find tasks that need comment checks ---
# Tasks in 'done' or 'rework' status may have human feedback comments
REVIEW_TASKS=$(python3 - <<'PYEOF'
import json, sys

with open(sys.argv[1]) as f:
    status_data = json.load(f)

with open(sys.argv[2]) as f:
    cache_data = json.load(f)

cached_items = cache_data.get("items", {})

for d_id, d_info in status_data.get("deliverables", {}).items():
    for t_id, t_info in d_info.get("tasks", {}).items():
        if t_info.get("status") in ("done", "rework"):
            wms_id = cached_items.get(t_id, {}).get("wms_id", "")
            if wms_id:
                print(f"{t_id}\t{wms_id}\t{t_info['name']}\t{t_info['status']}")
PYEOF
"$STATUS_FILE" "$SYNC_CACHE")

if [[ -z "$REVIEW_TASKS" ]]; then
    echo "INFO: No tasks in 'done' or 'rework' status with WMS IDs. Nothing to check."
    exit 0
fi

echo "Tasks to check for comments:"
echo "$REVIEW_TASKS" | while IFS=$'\t' read -r T_ID WMS_ID TASK_NAME STATUS; do
    echo "  $T_ID ($TASK_NAME) — ClickUp ID: $WMS_ID — current status: $STATUS"
done
echo ""

# --- Comment pull protocol ---
# The actual API calls must go through the ClickUp MCP server in the Claude Code session.
# This script outputs the required MCP actions for the agent to execute.

REWORK_FOUND=0

echo "$REVIEW_TASKS" | while IFS=$'\t' read -r T_ID WMS_ID TASK_NAME STATUS; do
    echo "--- Checking $T_ID ($TASK_NAME) ---"
    echo "MCP_ACTION: clickup_get_task_comments task_id=$WMS_ID"
    echo ""
    echo "AGENT INSTRUCTIONS for $T_ID:"
    echo "  1. Call clickup_get_task_comments with task_id=$WMS_ID"
    echo "  2. For each comment NOT already replied to with 'LEP rework created':"
    echo "     a. Parse the comment as a rework request"
    echo "     b. Add rework_log entry to $STATUS_FILE:"
    echo "        {"
    echo "          \"task_id\": \"$T_ID\","
    echo "          \"from_status\": \"$STATUS\","
    echo "          \"to_status\": \"rework\","
    echo "          \"reason\": \"<comment text>\","
    echo "          \"triggered_by\": \"wms_comment_pull\","
    echo "          \"timestamp\": \"<now ISO8601>\""
    echo "        }"
    echo "     c. Update task status in status.json to 'rework'"
    echo "     d. Reply to the WMS comment: 'LEP rework created for $T_ID. See .exec/ for details.'"
    echo "  3. Run sync-to-clickup.sh to push the 'rework' status back to ClickUp"
    echo ""
done

if [[ "$DRY_RUN" == "true" ]]; then
    echo "=== Dry-run complete. No changes made. ==="
else
    echo "=== Comment pull protocol complete. ==="
    echo "Execute the MCP_ACTION calls above via the ClickUp MCP server."
    echo "Then update status.json with any rework entries found."
fi

exit 0
