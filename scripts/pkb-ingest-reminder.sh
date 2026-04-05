#!/usr/bin/env bash
# pkb-ingest-reminder.sh — check for uningested files in captured/
# version: 2.0 | status: Draft | last_updated: 2026-04-05
#
# Called by post-session hook. Prints reminder if captured/ has files
# not yet logged in _log.md. Always exits 0 (reminder, not blocker).

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CAPTURED="$REPO_ROOT/PERSONAL-KNOWLEDGE-BASE/captured"
LOG="$REPO_ROOT/PERSONAL-KNOWLEDGE-BASE/distilled/_log.md"

# Exit silently if PKB not scaffolded
[[ -d "$CAPTURED" ]] || exit 0
[[ -f "$LOG" ]] || exit 0

# Get list of files in captured/ (excluding hidden files)
captured_files=()
while IFS= read -r -d '' file; do
    captured_files+=("$(basename "$file")")
done < <(find "$CAPTURED" -maxdepth 1 -type f ! -name '.*' -print0 2>/dev/null)

# No files in captured/ — nothing to remind about
[[ ${#captured_files[@]} -eq 0 ]] && exit 0

# Check which files are NOT in _log.md
uningested=()
for file in "${captured_files[@]}"; do
    if ! grep -qF "$file" "$LOG" 2>/dev/null; then
        uningested+=("$file")
    fi
done

# Print reminder only if uningested files exist
if [[ ${#uningested[@]} -gt 0 ]]; then
    echo ""
    echo "📚 PKB Ingest Reminder: ${#uningested[@]} file(s) in captured/ not yet ingested:"
    for file in "${uningested[@]}"; do
        echo "   → $file"
    done
    echo "   Run /ingest to distil these into your knowledge base."
    echo ""
fi

# Always exit 0 — this is a reminder, not a blocker
exit 0
