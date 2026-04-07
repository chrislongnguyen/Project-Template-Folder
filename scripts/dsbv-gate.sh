#!/usr/bin/env bash
# version: 2.2 | status: draft | last_updated: 2026-04-07
# dsbv-gate.sh — ALPEI workstream chain-of-custody gate
#
# Blocks commits to workstream N if workstream N-1 has no `status: validated` artifact.
# Full chain: 1-ALIGN → 2-LEARN → 3-PLAN → 4-EXECUTE → 5-IMPROVE
#
# Usage:
#   Standalone:    ./scripts/dsbv-gate.sh           (checks staged files)
#   Pre-commit:    reference from .pre-commit-config.yaml or .git/hooks/pre-commit
#   Manual check:  ./scripts/dsbv-gate.sh --check   (same behavior)
#   PreToolUse:    ./scripts/dsbv-gate.sh --pretool  (reads JSON from stdin)
#
# Exit codes (default/--check mode):
#   0 = pass (no workstream violations)
#   1 = blocked (workstream prerequisite not met)
#
# Exit codes (--pretool mode):
#   0 = allow
#   2 = block (matches Claude Code hook convention)

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
    local pattern_validated

    case "$ext" in
        md)
            # YAML frontmatter: first 20 lines, anchored key
            pattern_validated='^status:[[:space:]]*validated'
            if head -n 20 "$filepath" 2>/dev/null | grep -qE "$pattern_validated"; then
                return 0
            fi
            ;;
        sh|py)
            # Comment header: first 5 lines, inline format
            # e.g. # version: 1.0 | status: validated | last_updated: ...
            pattern_validated='status:[[:space:]]*validated'
            if head -n 5 "$filepath" 2>/dev/null | grep -qE "$pattern_validated"; then
                return 0
            fi
            ;;
        html)
            # HTML meta tag: first 30 lines
            # e.g. <meta name="status" content="validated">
            if head -n 30 "$filepath" 2>/dev/null | grep -qE 'content="validated"'; then
                return 0
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
    # LEARN skills use S2 validated (migrated 2026-04-06)
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
                if file_has_validated_status "$f"; then
                    return 0
                fi
            done < <(find "$dir" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.html' \) -print0 2>/dev/null)
        done
        return 1
    fi

    # Standard DSBV workstreams: check all eligible file types recursively
    # Status vocabulary: validated ONLY (S2 clean break — no Approved, no Review)
    while IFS= read -r -d '' f; do
        if file_has_validated_status "$f"; then
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

# --- Operational file exceptions ---------------------------------------------

# Returns 0 (is operational) if the file path matches operational file patterns
# that skip the chain-of-custody gate (same logic as dsbv-skill-guard.sh).
is_operational_file() {
    local filepath="$1"
    case "$filepath" in
        *retrospectives/*|*retros/*|*retro*)  return 0 ;;
        *changelog/*|*CHANGELOG*|*changelog*) return 0 ;;
        *metrics/*|*metrics*)                 return 0 ;;
        *decisions/*|*decision*)              return 0 ;;
        *reviews/*|*review*)                  return 0 ;;
        *risks/*|*risk*)                      return 0 ;;
        *drivers/*|*driver*)                  return 0 ;;
    esac
    return 1
}

# --- --pretool mode ----------------------------------------------------------

# PreToolUse handler: reads JSON from stdin, extracts file_path, enforces ALPEI chain.
pretool_main() {
    # Read full stdin JSON
    local json
    json="$(cat)"

    # Extract file_path from tool_input
    local file_path
    file_path="$(echo "$json" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"

    # No path extractable → allow (not a file write)
    if [[ -z "$file_path" ]]; then
        exit 0
    fi

    # Determine relative path from project root
    local rel_path
    rel_path="${file_path#"${PROJECT_ROOT}"/}"

    # Determine which workstream this file belongs to
    local target_workstream=""
    for ws in "${WORKSTREAMS[@]}"; do
        if [[ "$rel_path" == "${ws}/"* ]]; then
            target_workstream="$ws"
            break
        fi
    done

    # Not a workstream file → allow
    if [[ -z "$target_workstream" ]]; then
        exit 0
    fi

    # 2-LEARN files: always allow at write/edit time (exploratory — gate only at commit)
    if [[ "$target_workstream" == "2-LEARN" ]]; then
        exit 0
    fi

    # Scaffold files → allow (structural, not deliverables)
    local filename
    filename="$(basename "$file_path")"
    for scaffold in "${SCAFFOLD_FILENAMES[@]}"; do
        if [[ "$filename" == "$scaffold" ]]; then
            exit 0
        fi
    done

    # Operational files → allow (retros, changelog, metrics, decisions, reviews)
    if is_operational_file "$rel_path"; then
        exit 0
    fi

    # 1-ALIGN has no prerequisite → always allow
    local prereq
    prereq="$(get_prerequisite_workstream "$target_workstream")"
    if [[ -z "$prereq" ]]; then
        exit 0
    fi

    # Check if prerequisite workstream has ≥1 validated artifact
    if workstream_has_validated_artifact "$prereq"; then
        exit 0
    fi

    # Prerequisite NOT met → block with actionable message
    cat >&2 <<EOF
BLOCKED: Writing to ${target_workstream}/ — prerequisite ${prereq}/ has no validated artifacts.

The ALPEI chain-of-custody requires workstream N-1 to have ≥1 validated artifact
before workstream N can receive new deliverables.

To fix this:
  1. Complete work in ${prereq}/
  2. Set status: in-review on completed artifacts
  3. Get human validation (status: validated)

File attempted: ${file_path}
See: rules/alpei-chain-of-custody.md
EOF
    exit 2
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
                echo "  For 2-LEARN: check _cross/output/ or */specs/ for 'status: validated'."
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

# --- Dispatch ----------------------------------------------------------------

case "${1:-}" in
    --pretool)
        pretool_main
        ;;
    --check|"")
        main "$@"
        ;;
    *)
        echo "Usage: dsbv-gate.sh [--check | --pretool]" >&2
        exit 1
        ;;
esac
