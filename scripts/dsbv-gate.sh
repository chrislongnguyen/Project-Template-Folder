#!/usr/bin/env bash
# dsbv-gate.sh — Zone-boundary enforcement for DSBV/APEI flow
#
# Ensures APEI zones are committed in order: ALIGN → PLAN → EXECUTE → IMPROVE.
# A zone may only receive commits if the preceding zone has at least one artifact
# with status: Approved or status: Review in its YAML frontmatter.
#
# Usage:
#   Standalone:    ./scripts/dsbv-gate.sh           (checks staged files)
#   Pre-commit:    reference from .pre-commit-config.yaml or .git/hooks/pre-commit
#   Manual check:  ./scripts/dsbv-gate.sh --check   (checks staged files, same behavior)
#
# Exit codes:
#   0 = pass (no zone violations)
#   1 = blocked (zone prerequisite not met)

set -euo pipefail

# --- Configuration -----------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ordered APEI zones — each requires the previous to have approved artifacts
ZONES=("1-ALIGN" "2-PLAN" "3-EXECUTE" "4-IMPROVE")

# --- Functions ----------------------------------------------------------------

# Check if a zone directory has at least one .md file with status: Approved or Review
# in YAML frontmatter (first 20 lines).
zone_has_approved_artifact() {
    local zone_dir="$1"
    local zone_path="${PROJECT_ROOT}/${zone_dir}"

    if [[ ! -d "$zone_path" ]]; then
        return 1
    fi

    # Search all .md files in the zone (recursive) for status frontmatter
    local found=0
    while IFS= read -r -d '' mdfile; do
        # Read first 20 lines — frontmatter lives at the top
        if head -n 20 "$mdfile" | grep -qiE '^status:\s*(Approved|Review)'; then
            found=1
            break
        fi
    done < <(find "$zone_path" -name '*.md' -type f -print0 2>/dev/null)

    [[ $found -eq 1 ]]
}

# Get the list of zones touched by staged files
get_staged_zones() {
    local staged_files
    staged_files="$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null || true)"

    if [[ -z "$staged_files" ]]; then
        # No staged files — nothing to check
        echo ""
        return
    fi

    local zones_touched=()
    for zone in "${ZONES[@]}"; do
        if echo "$staged_files" | grep -q "^${zone}/"; then
            zones_touched+=("$zone")
        fi
    done

    echo "${zones_touched[*]}"
}

# Get the prerequisite zone for a given zone (the one before it in APEI order)
get_prerequisite_zone() {
    local target_zone="$1"
    local prev=""

    for zone in "${ZONES[@]}"; do
        if [[ "$zone" == "$target_zone" ]]; then
            echo "$prev"
            return
        fi
        prev="$zone"
    done

    echo ""
}

# --- Main ---------------------------------------------------------------------

main() {
    local zones_touched
    zones_touched="$(get_staged_zones)"

    if [[ -z "$zones_touched" ]]; then
        # No APEI zone files staged — gate passes
        exit 0
    fi

    local blocked=0

    for zone in $zones_touched; do
        local prereq
        prereq="$(get_prerequisite_zone "$zone")"

        # First zone (ALIGN) has no prerequisite — always passes
        if [[ -z "$prereq" ]]; then
            continue
        fi

        if ! zone_has_approved_artifact "$prereq"; then
            echo "BLOCKED: Cannot commit to ${zone}/ — no approved artifacts found in ${prereq}/."
            echo "  Run '/dsbv validate $(echo "$prereq" | sed 's/^[0-9]-//' | tr '[:upper:]' '[:lower:]')' first."
            echo "  (Looking for 'status: Approved' or 'status: Review' in ${prereq}/ frontmatter)"
            echo ""
            blocked=1
        fi
    done

    if [[ $blocked -eq 1 ]]; then
        echo "DSBV zone-boundary check FAILED. Fix prerequisites before committing."
        exit 1
    fi

    exit 0
}

main "$@"
