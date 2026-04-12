#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-12
# Thin Bash wrapper for template-merge-engine.py
# Called by template-sync.sh for merge operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$SCRIPT_DIR/template-merge-engine.py" "$@"
