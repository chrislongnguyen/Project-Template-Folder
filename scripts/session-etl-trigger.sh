#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-07
# session-etl-trigger.sh — UserPromptSubmit hook wrapper for session-etl.py
#
# Debounce: if last run was <10 minutes ago, exit 0 immediately.
# Otherwise: run session-etl.py in background (nohup + disown) and update timestamp.
# Must complete in <100ms — this blocks the user prompt.

set -euo pipefail

TIMESTAMP_FILE="${HOME}/.claude/.session-etl-last-run"
DEBOUNCE_SECONDS=600  # 10 minutes

# Locate the script relative to this file's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ETL_SCRIPT="${SCRIPT_DIR}/session-etl.py"

# Debounce check
if [[ -f "${TIMESTAMP_FILE}" ]]; then
    last_run=$(cat "${TIMESTAMP_FILE}" 2>/dev/null || echo 0)
    now=$(date +%s)
    elapsed=$(( now - last_run ))
    if (( elapsed < DEBOUNCE_SECONDS )); then
        exit 0
    fi
fi

# Guard: Python must exist and script must exist
if ! command -v python3 &>/dev/null; then
    exit 0
fi
if [[ ! -f "${ETL_SCRIPT}" ]]; then
    exit 0
fi

# Update timestamp BEFORE launching so concurrent prompts don't double-fire
date +%s > "${TIMESTAMP_FILE}"

# Launch in background — nohup so it survives shell exit, disown so it's detached
nohup python3 "${ETL_SCRIPT}" \
    >> "${HOME}/.claude/session-etl.log" 2>&1 &
disown $!

exit 0
