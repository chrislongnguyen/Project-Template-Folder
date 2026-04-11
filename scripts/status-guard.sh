#!/usr/bin/env bash
# version: 2.3 | status: draft | last_updated: 2026-04-11
# status-guard.sh — Block commits that set status: validated (S2 human-only field)
#                   and block downgrading a validated file back to draft/in-progress/in-review
#
# Usage: ./scripts/status-guard.sh [--force-approve] [--allow-reopen]
#   Checks staged diffs for human-only status values across .md, .sh, .py, .html
#   Also checks: if a staged .md file's previously committed version was status: validated,
#   and the new version is NOT validated, the commit is blocked (downgrade protection).
#
#   S2 vocabulary — human-only values (agents must NEVER set these):
#     validated  (current S2 canonical)
#     Approved   (legacy — reject both)
#
#   Agents set: draft, in-progress, in-review
#   Only humans set: validated
#
# Exit 0: clean (no blocked status in diff)
# Exit 2: blocked (human-only status found in staged diff, or validated→downgrade detected)
#
# Override (either form works):
#   ./scripts/status-guard.sh --force-approve       # bypass all checks (human-approve flow)
#   FORCE_APPROVE=1 ./scripts/status-guard.sh
#
#   ./scripts/status-guard.sh --allow-reopen        # bypass downgrade check only
#   ALLOW_REOPEN=1 ./scripts/status-guard.sh
set -euo pipefail

# Parse CLI flags
FORCE_APPROVE_FLAG=0
ALLOW_REOPEN_FLAG=0
for arg in "$@"; do
  if [[ "$arg" == "--force-approve" ]]; then
    FORCE_APPROVE_FLAG=1
  fi
  if [[ "$arg" == "--allow-reopen" ]]; then
    ALLOW_REOPEN_FLAG=1
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

# --- Downgrade protection: block validated→draft/in-progress/in-review ---
# Skip if --allow-reopen / ALLOW_REOPEN=1 (human re-opening an approved artifact).
if [[ "$ALLOW_REOPEN_FLAG" != "1" ]] && [[ "${ALLOW_REOPEN:-0}" != "1" ]]; then
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
  downgrade_violations=""

  # Collect staged .md files only (YAML frontmatter carriers)
  staged_md_files=$(git -C "$REPO_ROOT" diff --cached --name-only -- '*.md' 2>/dev/null || true)

  for rel_file in $staged_md_files; do
    abs_file="${REPO_ROOT}/${rel_file}"

    # Get the previously committed status (HEAD version)
    prev_status=$(git -C "$REPO_ROOT" show "HEAD:${rel_file}" 2>/dev/null \
      | head -n 20 \
      | grep -E '^status:' \
      | head -1 \
      | sed 's/^status:[[:space:]]*//' \
      | tr -d '"'"'" \
      | tr -d '[:space:]' \
      || true)

    # Only act if previous committed status was "validated"
    if [[ "$prev_status" == "validated" ]]; then
      # Get the new (staged) status from the working-tree file
      new_status=$(head -n 20 "$abs_file" 2>/dev/null \
        | grep -E '^status:' \
        | head -1 \
        | sed 's/^status:[[:space:]]*//' \
        | tr -d '"'"'" \
        | tr -d '[:space:]' \
        || true)

      if [[ "$new_status" != "validated" ]]; then
        downgrade_violations="${downgrade_violations}  ${rel_file}: validated → ${new_status}\n"
      fi
    fi
  done

  if [[ -n "$downgrade_violations" ]]; then
    echo "BLOCKED: validated → downgrade detected — human approval required."
    echo "The following file(s) were status:validated in HEAD and are being downgraded:"
    echo ""
    printf "%b" "$downgrade_violations"
    echo ""
    echo "To re-open an approved artifact, run with --allow-reopen or ALLOW_REOPEN=1"
    exit 2
  fi
fi

exit 0
