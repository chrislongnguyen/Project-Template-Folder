#!/usr/bin/env bash
# version: 2.1 | status: Draft | last_updated: 2026-04-05
# status-guard.sh — Block commits that set status: Approved (human-only field)
#
# Usage: ./scripts/status-guard.sh [--force-approve]
#   Checks staged diffs for +status: Approved or +status: "Approved"
#
# Exit 0: clean (no Approved in diff)
# Exit 2: blocked (Approved found in staged diff)
#
# Override (either form works):
#   ./scripts/status-guard.sh --force-approve
#   FORCE_APPROVE=1 ./scripts/status-guard.sh
set -euo pipefail

# Parse CLI flags
FORCE_APPROVE_FLAG=0
for arg in "$@"; do
  if [[ "$arg" == "--force-approve" ]]; then
    FORCE_APPROVE_FLAG=1
  fi
done

# Human override — CLI flag or env var
if [[ "$FORCE_APPROVE_FLAG" == "1" ]] || [[ "${FORCE_APPROVE:-0}" == "1" ]]; then
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"

# Check staged diffs for added lines setting status to Approved
matches=$(git -C "$REPO_ROOT" diff --cached --unified=0 -- '*.md' 2>/dev/null \
  | grep -E '^\+status:\s*"?Approved"?\s*$' || true)

if [[ -n "$matches" ]]; then
  echo "BLOCKED: staged diff sets status: Approved — this field is human-only."
  echo "If this is intentional, re-run with FORCE_APPROVE=1"
  echo ""
  echo "Matching lines:"
  echo "$matches"
  exit 2
fi

exit 0
