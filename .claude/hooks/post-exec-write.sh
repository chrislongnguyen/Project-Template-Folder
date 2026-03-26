#!/usr/bin/env bash
# L3 Hook: PostToolUse — trigger readiness check on .exec/ files
# Fires after any Write tool call targeting .exec/*.md
# Usage: post-exec-write.sh <file_path>
# Exit code: always 0 (WARN, not BLOCKED — allows the write but flags the issue)
set -euo pipefail

FILE_PATH="$1"

if [[ "$FILE_PATH" == *".exec/"*".md"* ]]; then
  EXEC_DIR=$(dirname "$(dirname "$FILE_PATH")")
  python3 scripts/stage-validators/validate-exec-readiness.py "$EXEC_DIR" 2>&1 || {
    echo "WARN: .exec/ file failed readiness checks. Review before proceeding." >&2
  }
fi
exit 0
