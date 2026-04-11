#!/usr/bin/env bash
# version: 2.3 | status: draft | last_updated: 2026-04-11
# dsbv-gate.sh — ALPEI workstream chain-of-custody gate
#
# Blocks commits to workstream N if workstream N-1 has no `status: validated` artifact.
# Full chain: 1-ALIGN → 2-LEARN → 3-PLAN → 4-EXECUTE → 5-IMPROVE
#
# DD-3 subsystem-level enforcement:
#   Cross-workstream: {W}-{WS}/{S}-{SUB}/ checks {W-1}-{WS_PREV}/{S}-{SUB}/ for >=1 validated
#   LEARN->PLAN:      3-PLAN/{S}-{SUB}/ checks 2-LEARN/ (any location) for >=1 validated
#   Cross-subsystem:  Subsystem S Build requires S-1 DESIGN.md in same workstream
#   _cross exception: No upstream subsystem dependency (WS-level chain only)
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

# --- Subsystem prerequisite checks (DD-3) ------------------------------------

# Extract subsystem dir (e.g. "1-PD", "2-DP", "_cross") from a relative path.
# Path form: {W}-{WS}/{S}-{SUB}/...  or  {W}-{WS}/_cross/...
# Prints the subsystem token, or "" if not in a subsystem subdir.
extract_subsystem() {
    local rel_path="$1"
    # Strip leading workstream prefix (e.g. "3-PLAN/")
    local after_ws="${rel_path#*/}"
    # First path component is the subsystem dir
    local sub_dir="${after_ws%%/*}"
    # Must match N-NAME pattern or _cross
    case "$sub_dir" in
        [0-9]*-*|_cross)
            echo "$sub_dir"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Extract numeric subsystem index from a subsystem dir token (e.g. "2-DP" -> 2).
# Returns "" for _cross or non-numeric.
subsystem_index() {
    local sub_dir="$1"
    case "$sub_dir" in
        _cross) echo "" ;;
        [0-9]*) echo "${sub_dir%%-*}" ;;
        *)      echo "" ;;
    esac
}

# Returns 0 if the named subsystem dir in the given workstream has >=1 validated artifact.
# AC-26: cross-workstream subsystem check.
subsystem_has_validated_artifact() {
    local workstream_dir="$1"
    local sub_dir="$2"
    local sub_path="${PROJECT_ROOT}/${workstream_dir}/${sub_dir}"

    if [[ ! -d "$sub_path" ]]; then
        return 1
    fi

    while IFS= read -r -d '' f; do
        if file_has_validated_status "$f"; then
            return 0
        fi
    done < <(find "$sub_path" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.html' \) -print0 2>/dev/null)

    return 1
}

# Returns 0 if subsystem S-1 DESIGN.md exists in the given workstream.
# AC-27: cross-subsystem ordering check.
prev_subsystem_design_exists() {
    local workstream_dir="$1"
    local current_sub_index="$2"
    local prev_index=$((current_sub_index - 1))

    if [[ $prev_index -lt 1 ]]; then
        # No previous subsystem — first subsystem, no upstream dependency
        return 0
    fi

    # Find a subsystem dir whose numeric prefix = prev_index
    local ws_path="${PROJECT_ROOT}/${workstream_dir}"
    if [[ ! -d "$ws_path" ]]; then
        return 1
    fi

    local found=1
    for d in "${ws_path}"/*/; do
        local dname
        dname="$(basename "$d")"
        local didx
        didx="$(subsystem_index "$dname")"
        if [[ "$didx" == "$prev_index" ]]; then
            if [[ -f "${d}DESIGN.md" ]]; then
                found=0
            fi
            break
        fi
    done

    return $found
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
        *UBS_REGISTER*|*ubs*)                 return 0 ;;
        *UDS_REGISTER*|*uds*)                 return 0 ;;
        *okr*|*OKR*)                          return 0 ;;
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

    # Extract subsystem from path
    local target_sub
    target_sub="$(extract_subsystem "$rel_path")"

    # --- AC-27: Cross-subsystem ordering check (skip _cross per AC-28) ---
    if [[ -n "$target_sub" && "$target_sub" != "_cross" ]]; then
        local sub_idx
        sub_idx="$(subsystem_index "$target_sub")"
        if [[ -n "$sub_idx" ]] && ! prev_subsystem_design_exists "$target_workstream" "$sub_idx"; then
            local prev_idx=$((sub_idx - 1))
            cat >&2 <<EOF
BLOCKED: Writing to ${target_workstream}/${target_sub}/ — subsystem ${prev_idx} DESIGN.md not found in ${target_workstream}/.

DD-3 cross-subsystem rule: subsystem S Build requires subsystem S-1 DESIGN.md in the same workstream.
Subsystem order: PD(1) → DP(2) → DA(3) → IDM(4).

File attempted: ${file_path}
See: rules/alpei-chain-of-custody.md
EOF
            exit 2
        fi
    fi

    # --- AC-26 / AC-26b: Cross-workstream check at subsystem level ---

    # LEARN→PLAN special case (AC-26b): check 2-LEARN/ any location
    if [[ "$prereq" == "2-LEARN" ]]; then
        if workstream_has_validated_artifact "2-LEARN"; then
            exit 0
        fi
        cat >&2 <<EOF
BLOCKED: Writing to ${target_workstream}/${target_sub}/ — 2-LEARN/ has no validated artifacts.

LEARN→PLAN chain-of-custody: 3-PLAN requires ≥1 validated artifact anywhere in 2-LEARN/
(check 2-LEARN/_cross/output/ or 2-LEARN/*/specs/ for 'status: validated').

File attempted: ${file_path}
See: rules/alpei-chain-of-custody.md
EOF
        exit 2
    fi

    # Standard cross-workstream check: subsystem-scoped if subsystem present (AC-26),
    # else full-workstream fallback.
    local ws_check_pass=0
    if [[ -n "$target_sub" && "$target_sub" != "_cross" ]]; then
        # AC-26: check same subsystem dir in prerequisite workstream
        if subsystem_has_validated_artifact "$prereq" "$target_sub"; then
            ws_check_pass=1
        fi
    else
        # _cross or no subsystem: full workstream check
        if workstream_has_validated_artifact "$prereq"; then
            ws_check_pass=1
        fi
    fi

    if [[ $ws_check_pass -eq 1 ]]; then
        exit 0
    fi

    # Prerequisite NOT met → block with actionable message
    cat >&2 <<EOF
BLOCKED: Writing to ${target_workstream}/${target_sub}/ — prerequisite ${prereq}/${target_sub}/ has no validated artifacts.

The ALPEI chain-of-custody (DD-3) requires the matching subsystem in workstream N-1 to have
≥1 validated artifact before workstream N can receive new deliverables.

To fix this:
  1. Complete work in ${prereq}/${target_sub}/
  2. Set status: in-review on completed artifacts
  3. Get human validation (status: validated)

File attempted: ${file_path}
See: rules/alpei-chain-of-custody.md
EOF
    exit 2
}

# --- Main --------------------------------------------------------------------

main() {
    local staged_files
    staged_files="$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null || true)"

    if [[ -z "$staged_files" ]]; then
        exit 0
    fi

    local blocked=0

    # Collect unique workstream+subsystem pairs from staged files
    # Format: "WORKSTREAM|SUBSYSTEM" (SUBSYSTEM may be empty)
    local pairs=""
    local file
    while IFS= read -r file; do
        local ws=""
        for ws_candidate in "${WORKSTREAMS[@]}"; do
            if [[ "$file" == "${ws_candidate}/"* ]]; then
                ws="$ws_candidate"
                break
            fi
        done
        [[ -z "$ws" ]] && continue

        local sub
        sub="$(extract_subsystem "$file")"
        local pair="${ws}|${sub}"

        # Deduplicate
        case "$pairs" in
            *"${pair}"*) ;;
            *) pairs="${pairs} ${pair}" ;;
        esac
    done <<EOF
$staged_files
EOF

    for pair in $pairs; do
        local workstream="${pair%%|*}"
        local sub="${pair##*|}"

        local prereq
        prereq="$(get_prerequisite_workstream "$workstream")"

        # First workstream (1-ALIGN) has no prerequisite — always passes
        if [[ -z "$prereq" ]]; then
            continue
        fi

        # --- AC-27: Cross-subsystem ordering check (skip _cross per AC-28) ---
        if [[ -n "$sub" && "$sub" != "_cross" ]]; then
            local sub_idx
            sub_idx="$(subsystem_index "$sub")"
            if [[ -n "$sub_idx" ]] && ! prev_subsystem_design_exists "$workstream" "$sub_idx"; then
                local prev_idx=$((sub_idx - 1))
                echo "BLOCKED: ${workstream}/${sub}/ — subsystem ${prev_idx} DESIGN.md not found in ${workstream}/."
                echo "  DD-3: Subsystem S Build requires S-1 DESIGN.md in same workstream."
                echo "  See: rules/alpei-chain-of-custody.md"
                echo ""
                blocked=1
            fi
        fi

        # --- AC-26 / AC-26b: Cross-workstream check ---

        # LEARN→PLAN special case (AC-26b)
        if [[ "$prereq" == "2-LEARN" ]]; then
            if ! workstream_has_validated_artifact "2-LEARN"; then
                echo "BLOCKED: Cannot commit to ${workstream}/ — no validated artifacts found in 2-LEARN/."
                echo "  For LEARN→PLAN: check 2-LEARN/_cross/output/ or 2-LEARN/*/specs/ for 'status: validated'."
                echo "  See: rules/alpei-chain-of-custody.md"
                echo ""
                blocked=1
            fi
            continue
        fi

        # Standard cross-workstream: subsystem-scoped (AC-26) or full-workstream (_cross / no sub)
        local ws_ok=0
        if [[ -n "$sub" && "$sub" != "_cross" ]]; then
            if subsystem_has_validated_artifact "$prereq" "$sub"; then
                ws_ok=1
            fi
        else
            if workstream_has_validated_artifact "$prereq"; then
                ws_ok=1
            fi
        fi

        if [[ $ws_ok -eq 0 ]]; then
            local scope_label="${workstream}/"
            [[ -n "$sub" ]] && scope_label="${workstream}/${sub}/"
            local prereq_label="${prereq}/"
            [[ -n "$sub" && "$sub" != "_cross" ]] && prereq_label="${prereq}/${sub}/"
            echo "BLOCKED: Cannot commit to ${scope_label} — no validated artifacts found in ${prereq_label}."
            echo "  Gate requires: ≥1 file with 'status: validated' in ${prereq_label}."
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
