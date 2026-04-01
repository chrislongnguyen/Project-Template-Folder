#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-30
# dsbv-gate.sh — Workstream-boundary enforcement for DSBV/APEI flow
#
# Ensures APEI workstreams are committed in order: ALIGN → PLAN → EXECUTE → IMPROVE.
# A workstream may only receive commits if the preceding workstream has at least one artifact
# with status: Approved or status: Review in its YAML frontmatter.
#
# Usage:
#   Standalone:    ./scripts/dsbv-gate.sh           (checks staged files)
#   Pre-commit:    reference from .pre-commit-config.yaml or .git/hooks/pre-commit
#   Manual check:  ./scripts/dsbv-gate.sh --check   (checks staged files, same behavior)
#
# Exit codes:
#   0 = pass (no workstream violations)
#   1 = blocked (workstream prerequisite not met)

set -euo pipefail

# --- Configuration -----------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ordered APEI workstreams — each requires the previous to have approved artifacts
WORKSTREAMS=("1-ALIGN" "3-PLAN" "4-EXECUTE" "5-IMPROVE")

# --- Functions ----------------------------------------------------------------

# Check if a workstream directory has at least one .md file with status: Approved or Review
# in YAML frontmatter (first 20 lines).
workstream_has_approved_artifact() {
    local workstream_dir="$1"
    local workstream_path="${PROJECT_ROOT}/${workstream_dir}"

    if [[ ! -d "$workstream_path" ]]; then
        return 1
    fi

    # Search all .md files in the workstream (recursive) for status frontmatter
    local found=0
    while IFS= read -r -d '' mdfile; do
        # Read first 20 lines — frontmatter lives at the top
        if head -n 20 "$mdfile" | grep -qiE '^status:\s*(Approved|Review)'; then
            found=1
            break
        fi
    done < <(find "$workstream_path" -name '*.md' -type f -print0 2>/dev/null)

    [[ $found -eq 1 ]]
}

# Get the list of workstreams touched by staged files
get_staged_workstreams() {
    local staged_files
    staged_files="$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null || true)"

    if [[ -z "$staged_files" ]]; then
        # No staged files — nothing to check
        echo ""
        return
    fi

    local workstreams_touched=()
    for workstream in "${WORKSTREAMS[@]}"; do
        if echo "$staged_files" | grep -q "^${workstream}/"; then
            workstreams_touched+=("$workstream")
        fi
    done

    echo "${workstreams_touched[*]}"
}

# Get the prerequisite workstream for a given workstream (the one before it in APEI order)
get_prerequisite_workstream() {
    local target_workstream="$1"
    local prev=""

    for workstream in "${WORKSTREAMS[@]}"; do
        if [[ "$workstream" == "$target_workstream" ]]; then
            echo "$prev"
            return
        fi
        prev="$workstream"
    done

    echo ""
}

# --- Main ---------------------------------------------------------------------

main() {
    local workstreams_touched
    workstreams_touched="$(get_staged_workstreams)"

    if [[ -z "$workstreams_touched" ]]; then
        # No APEI workstream files staged — gate passes
        exit 0
    fi

    local blocked=0

    for workstream in $workstreams_touched; do
        local prereq
        prereq="$(get_prerequisite_workstream "$workstream")"

        # First workstream (ALIGN) has no prerequisite — always passes
        if [[ -z "$prereq" ]]; then
            continue
        fi

        if ! workstream_has_approved_artifact "$prereq"; then
            echo "BLOCKED: Cannot commit to ${workstream}/ — no approved artifacts found in ${prereq}/."
            echo "  Run '/dsbv validate $(echo "$prereq" | sed 's/^[0-9]-//' | tr '[:upper:]' '[:lower:]')' first."
            echo "  (Looking for 'status: Approved' or 'status: Review' in ${prereq}/ frontmatter)"
            echo ""
            blocked=1
        fi
    done

    if [[ $blocked -eq 1 ]]; then
        echo "DSBV workstream-boundary check FAILED. Fix prerequisites before committing."
        exit 1
    fi

    exit 0
}

main "$@"
