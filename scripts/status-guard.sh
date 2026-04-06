#!/usr/bin/env bash
# version: 2.2 | status: draft | last_updated: 2026-04-06
# status-guard.sh — Block commits that set status: validated (S2 human-only field)
#
# Usage: ./scripts/status-guard.sh [--force-approve]
#   Checks staged diffs for human-only status values across .md, .sh, .py, .html
#
#   S2 vocabulary — human-only values (agents must NEVER set these):
#     validated  (current S2 canonical)
#     Approved   (legacy — reject both)
#
#   Agents set: draft, in-progress, in-review
#   Only humans set: validated
#
# Exit 0: clean (no blocked status in diff)
# Exit 2: blocked (human-only status found in staged diff)
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

# --- .md: YAML frontmatter (anchored to line) ---
md_validated=$(git -C "$REPO_ROOT" diff --cached --unified=0 -- '*.md' 2>/dev/null \
  | grep -E '^\+status:\s*"?validated"?\s*$' || true)

md_approved=$(git -C "$REPO_ROOT" diff --cached --unified=0 -- '*.md' 2>/dev/null \
  | grep -E '^\+status:\s*"?Approved"?\s*$' || true)

# --- .sh / .py: comment header format ---
script_validated=$(git -C "$REPO_ROOT" diff --cached --unified=0 -- '*.sh' '*.py' 2>/dev/null \
  | grep -E '^\+.*status:\s*validated' || true)

# --- .html: meta tag ---
html_validated=$(git -C "$REPO_ROOT" diff --cached --unified=0 -- '*.html' 2>/dev/null \
  | grep -E '^\+.*content="validated"' || true)

matches="${md_validated}${md_approved}${script_validated}${html_validated}"

if [[ -n "$matches" ]]; then
  echo "BLOCKED: staged diff sets status: validated — this field is human-only (S2 lifecycle)."
  echo "Agents set: draft, in-progress, in-review. Only humans set: validated."
  echo "If this is an authorized human override, re-run with FORCE_APPROVE=1"
  echo ""
  echo "Matching lines:"
  echo "$matches"
  exit 2
fi

exit 0
