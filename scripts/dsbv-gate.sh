#!/usr/bin/env bash
# version: 2.0 | status: draft | last_updated: 2026-04-06
# dsbv-gate.sh — ALPEI workstream chain-of-custody gate
#
# Blocks commits to workstream N if workstream N-1 has no `status: validated` artifact.
# Full chain: 1-ALIGN → 2-LEARN → 3-PLAN → 4-EXECUTE → 5-IMPROVE
#
# Usage:
#   Standalone:    ./scripts/dsbv-gate.sh           (checks staged files)
#   Pre-commit:    reference from .pre-commit-config.yaml or .git/hooks/pre-commit
#   Manual check:  ./scripts/dsbv-gate.sh --check   (same behavior)
#
# Exit codes:
#   0 = pass (no workstream violations)
#   1 = blocked (workstream prerequisite not met)

set -euo pipefail

# --- Configuration -----------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Full ALPEI workstream chain — order is the gate order
WORKSTREAMS=("1-ALIGN" "2-LEARN" "3-PLAN" "4-EXECUTE" "5-IMPROVE")

# Scaffold files that are structural, not deliverables — skip them in gate checks
SCAFFOLD_FILENAMES=("README.md" "DESIGN.md" "SEQUENCE.md" "VALIDATE.md")

# --- File-type status extraction ----------------------------------------------

# Returns 0 if the given file contains a validated status marker for its file type.
# Skips scaffold filenames and exempt types (JSON, YAML, TOML, binaries).
file_has_validated_status() {
    local filepath="$1"
    local learn_compat="${2:-false}"  # if true, also accept 'approved' (LEARN compat)
    local filename
    filename="$(basename "$filepath")"
    local ext="${filename##*.}"

    # --- Scaffold exception: skip structural files ---
    for scaffold in "${SCAFFOLD_FILENAMES[@]}"; do
        if [[ "$filename" == "$scaffold" ]]; then
            return 1
        fi
    done

    # --- Exempt file types (config, binaries) — per versioning.md ---
    case "$ext" in
        json|yaml|toml)
            return 1
            ;;
    esac

    # --- Match by file type ---
    local pattern_validated pattern_approved

    case "$ext" in
        md)
            # YAML frontmatter: first 20 lines, anchored key
            pattern_validated='^status:[[:space:]]*validated'
            if head -n 20 "$filepath" 2>/dev/null | grep -qE "$pattern_validated"; then
                return 0
            fi
            # COMPAT: remove when LEARN skills migrate to S2 validated
            if [[ "$learn_compat" == "true" ]]; then
                pattern_approved='^status:[[:space:]]*approved'
                if head -n 20 "$filepath" 2>/dev/null | grep -qE "$pattern_approved"; then
                    return 0
                fi
            fi
            ;;
        sh|py)
            # Comment header: first 5 lines, inline format
            # e.g. # version: 1.0 | status: validated | last_updated: ...
            pattern_validated='status:[[:space:]]*validated'
            if head -n 5 "$filepath" 2>/dev/null | grep -qE "$pattern_validated"; then
                return 0
            fi
            # COMPAT: remove when LEARN skills migrate to S2 validated
            if [[ "$learn_compat" == "true" ]]; then
                pattern_approved='status:[[:space:]]*approved'
                if head -n 5 "$filepath" 2>/dev/null | grep -qE "$pattern_approved"; then
                    return 0
                fi
            fi
            ;;
        html)
            # HTML meta tag: first 30 lines
            # e.g. <meta name="status" content="validated">
            if head -n 30 "$filepath" 2>/dev/null | grep -qE 'content="validated"'; then
                return 0
            fi
            # COMPAT: remove when LEARN skills migrate to S2 validated
            if [[ "$learn_compat" == "true" ]]; then
                if head -n 30 "$filepath" 2>/dev/null | grep -qE 'content="approved"'; then
                    return 0
                fi
            fi
            ;;
        *)
            # Unknown extension — skip (treat as exempt)
            return 1
            ;;
    esac

    return 1
}

# --- Workstream prerequisite check -------------------------------------------

# Returns 0 if the given workstream has ≥1 validated artifact.
workstream_has_validated_artifact() {
    local workstream_dir="$1"
    local workstream_path="${PROJECT_ROOT}/${workstream_dir}"

    if [[ ! -d "$workstream_path" ]]; then
        return 1
    fi

    # LEARN special case: Option X cross-first pipeline
    # Check 2-LEARN/_cross/output/ and 2-LEARN/*/specs/ only
    # COMPAT: accept 'approved' in addition to 'validated' for LEARN during S2 migration
    if [[ "$workstream_dir" == "2-LEARN" ]]; then
        local learn_dirs=()
        # _cross/output/ (P-pages)
        if [[ -d "${workstream_path}/_cross/output" ]]; then
            learn_dirs+=("${workstream_path}/_cross/output")
        fi
        # all subsystem specs/ dirs
        while IFS= read -r -d '' d; do
            learn_dirs+=("$d")
        done < <(find "$workstream_path" -mindepth 2 -maxdepth 2 -type d -name 'specs' -print0 2>/dev/null)

        for dir in "${learn_dirs[@]}"; do
            while IFS= read -r -d '' f; do
                if file_has_validated_status "$f" "true"; then
                    return 0
                fi
            done < <(find "$dir" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.html' \) -print0 2>/dev/null)
        done
        return 1
    fi

    # Standard DSBV workstreams: check all eligible file types recursively
    # Status vocabulary: validated ONLY (S2 clean break — no Approved, no Review)
    while IFS= read -r -d '' f; do
        if file_has_validated_status "$f" "false"; then
            return 0
        fi
    done < <(find "$workstream_path" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.html' \) -print0 2>/dev/null)

    return 1
}

# --- Staged workstream detection ---------------------------------------------

# Prints space-separated list of workstreams touched by currently staged files.
get_staged_workstreams() {
    local staged_files
    staged_files="$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null || true)"

    if [[ -z "$staged_files" ]]; then
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

# Returns the prerequisite workstream (N-1) for a given workstream, or "" for the first.
get_prerequisite_workstream() {
    local target="$1"
    local prev=""

    for workstream in "${WORKSTREAMS[@]}"; do
        if [[ "$workstream" == "$target" ]]; then
            echo "$prev"
            return
        fi
        prev="$workstream"
    done

    echo ""
}

# --- Main --------------------------------------------------------------------

main() {
    local workstreams_touched
    workstreams_touched="$(get_staged_workstreams)"

    if [[ -z "$workstreams_touched" ]]; then
        # No ALPEI workstream files staged — gate passes
        exit 0
    fi

    local blocked=0

    for workstream in $workstreams_touched; do
        local prereq
        prereq="$(get_prerequisite_workstream "$workstream")"

        # First workstream (1-ALIGN) has no prerequisite — always passes
        if [[ -z "$prereq" ]]; then
            continue
        fi

        if ! workstream_has_validated_artifact "$prereq"; then
            echo "BLOCKED: Cannot commit to ${workstream}/ — no validated artifacts found in ${prereq}/."
            echo "  Gate requires: ≥1 file with 'status: validated' in ${prereq}/."
            if [[ "$prereq" == "2-LEARN" ]]; then
                echo "  For 2-LEARN: check _cross/output/ or */specs/ — 'status: approved' also accepted (S2 compat)."
            fi
            echo "  See: rules/alpei-chain-of-custody.md"
            echo ""
            blocked=1
        fi
    done

    if [[ $blocked -eq 1 ]]; then
        echo "DSBV chain-of-custody check FAILED. Validate prerequisite workstream before committing."
        exit 1
    fi

    exit 0
}

main "$@"
