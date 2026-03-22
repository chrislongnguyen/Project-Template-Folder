#!/usr/bin/env bash
# L3 Hook: Session start — pull unresolved WMS comments
# Called by session-start protocol to check for human feedback on done/rework tasks
# Usage: session-start-comments.sh [exec_dir]
# Default exec_dir: .exec
# Exit code: always 0 (INFO only, never blocks)
set -euo pipefail

EXEC_DIR="${1:-.exec}"

if [ -d "$EXEC_DIR" ] && [ -f "$EXEC_DIR/status.json" ]; then
  review_tasks=$(python3 -c "
import json, sys
with open('$EXEC_DIR/status.json') as f:
    data = json.load(f)
for d_id, d in data.get('deliverables', {}).items():
    for t_id, t in d.get('tasks', {}).items():
        if t.get('status') in ('done', 'rework'):
            print(t_id)
" 2>/dev/null)

  if [ -n "$review_tasks" ]; then
    echo "INFO: Tasks with potential unprocessed comments: $review_tasks"
    echo "Run: scripts/wms-sync/pull-comments.sh $EXEC_DIR"
  fi
fi
exit 0
