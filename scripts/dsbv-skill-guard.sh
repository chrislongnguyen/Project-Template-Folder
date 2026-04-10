#!/usr/bin/env bash
# version: 1.3 | status: draft | last_updated: 2026-04-07
# dsbv-skill-guard.sh — PreToolUse hook for Write|Edit on workstream artifacts
#
# Enforces: "No ad-hoc artifacts. If work is not in a DESIGN.md, it is not in scope."
# (DSBV Skill, .claude/skills/dsbv/SKILL.md)
#
# Behavior:
#   1. Reads PreToolUse JSON from stdin (tool_name, tool_input.file_path)
#   2. Checks if file is in a workstream directory (1-ALIGN/, 3-PLAN/, 4-EXECUTE/, 5-IMPROVE/)
#   3. If not a workstream file → ALLOW (exit 0)
#   4. If a DSBV process file (DESIGN.md, SEQUENCE.md, VALIDATE.md) → ALLOW
#   5. If workstream's DESIGN.md exists → ALLOW (Design stage completed)
#   6. If workstream's DESIGN.md does NOT exist → BLOCK (exit 2)
#
# This enforces the OUTCOME (DESIGN.md exists) rather than the PROCESS
# (skill was invoked). Rationale:
#   - DESIGN.md is the contract — if it exists, Design happened
#   - File check is deterministic and fast (<10ms)
#   - Immune to LT-8 (agent can't rationalize past a file-existence check)
#   - Per D6: hooks > rules > skills (this is the highest enforcement tier)
#
# Exit codes:
#   0 = allow (file is not a workstream artifact, or DESIGN.md exists)
#   2 = block (workstream artifact write without DESIGN.md)
#
# Install: Add to .claude/settings.json PreToolUse hooks for Write|Edit matcher

set -euo pipefail

# --- Read hook input from stdin -------------------------------------------

INPUT=$(cat)

# Extract file path from tool input
# Write tool: tool_input.file_path
# Edit tool: tool_input.file_path
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [[ -z "$FILE_PATH" ]]; then
    # No file path in input — not a file write, allow
    exit 0
fi

# --- Determine if this is a workstream artifact ----------------------------------

# Extract workstream from file path
# Matches: /any/path/1-ALIGN/anything, /any/path/3-PLAN/anything, etc.
WORKSTREAM=""
WORKSTREAM_PATTERN=""
if [[ "$FILE_PATH" =~ /1-ALIGN/ ]]; then
    WORKSTREAM="1-ALIGN"
    WORKSTREAM_PATTERN="align"
elif [[ "$FILE_PATH" =~ /3-PLAN/ ]]; then
    WORKSTREAM="3-PLAN"
    WORKSTREAM_PATTERN="plan"
elif [[ "$FILE_PATH" =~ /4-EXECUTE/ ]]; then
    WORKSTREAM="4-EXECUTE"
    WORKSTREAM_PATTERN="execute"
elif [[ "$FILE_PATH" =~ /5-IMPROVE/ ]]; then
    WORKSTREAM="5-IMPROVE"
    WORKSTREAM_PATTERN="improve"
elif [[ "$FILE_PATH" =~ /2-LEARN/ ]]; then
    # LEARN uses the learning pipeline, NOT DSBV.
    # Block DSBV files; allow everything else.
    BASENAME=$(basename "$FILE_PATH")
    case "$BASENAME" in
        DESIGN.md|SEQUENCE.md|VALIDATE.md)
            cat >&2 <<BLOCK_MSG
BLOCKED: Creating DSBV artifact in 2-LEARN/.

LEARN uses the learning pipeline (input → research → specs → output → archive),
NOT the DSBV process. DESIGN.md, SEQUENCE.md, and VALIDATE.md must NEVER exist
in 2-LEARN/.

See: .claude/rules/filesystem-routing.md (Mode B)
File attempted: ${FILE_PATH}
BLOCK_MSG
            exit 2
            ;;
        *)
            # Non-DSBV file in LEARN — allow (pipeline artifacts)
            exit 0
            ;;
    esac
else
    # Not a workstream file — allow (could be _shared/, scripts/, .claude/, etc.)
    exit 0
fi

# --- Allow DSBV process files themselves -----------------------------------

# DESIGN.md, SEQUENCE.md, VALIDATE.md are produced BY the DSBV process.
# They must be writable without a pre-existing DESIGN.md (chicken-and-egg).
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
    DESIGN.md|SEQUENCE.md|VALIDATE.md)
        exit 0
        ;;
esac

# --- Allow operational files (updated outside DSBV cycles) -----------------

# Some workstream files are operational — they get updated incrementally, not as
# part of a DSBV Build stage. These include retrospectives, changelogs,
# metrics, decision records, and learning outputs.
RELATIVE_PATH="${FILE_PATH#*/${WORKSTREAM}/}"
case "$RELATIVE_PATH" in
    retrospectives/*|retros/*|*retro*) exit 0 ;;  # Retros are IMPROVE operational
    changelog/*|CHANGELOG*|*changelog*) exit 0 ;;  # Changelogs are incremental
    metrics/*|*metrics*) exit 0 ;;                  # Metrics are incremental
    decisions/*|*decision*) exit 0 ;;               # ADRs can be written anytime
    learning/*) exit 0 ;;                           # Learning outputs from research
    reviews/*|*review*) exit 0 ;;                   # Review packages
    skills/*) exit 0 ;;                             # Skills are operational tools
    risks/*|*risk*) exit 0 ;;                       # Risk registers are ongoing operational
    drivers/*|*driver*) exit 0 ;;                   # Driver registers are ongoing operational
    */README.md|README.md) exit 0 ;;                # READMEs are structural, not DSBV artifacts
    _cross/*) exit 0 ;;                             # Cross-cutting artifacts are operational
    charter/*) exit 0 ;;                            # Charter working dir is navigational
    architecture/*) exit 0 ;;                       # Architecture working dir is navigational
esac

# --- Check if DESIGN.md exists for this workstream -------------------------------

# Walk up from file path to find project root, then check workstream's DESIGN.md
# Strategy: find the workstream directory in the path, then look for DESIGN.md there
PROJECT_ROOT="${FILE_PATH%%/${WORKSTREAM}/*}"
DESIGN_FILE="${PROJECT_ROOT}/${WORKSTREAM}/DESIGN.md"

if [[ -f "$DESIGN_FILE" ]]; then
    # Workstream-level DESIGN.md exists — allow the write
    exit 0
fi

# Also check subsystem-level DESIGN.md (subsystem-first layout)
# Extract subsystem from path: {WORKSTREAM}/{N}-{SUB}/...
SUB_DIR=$(echo "$RELATIVE_PATH" | cut -d'/' -f1)
if [[ "$SUB_DIR" =~ ^[0-9]+-[A-Z]+$ ]] || [[ "$SUB_DIR" == "_cross" ]]; then
    SUB_DESIGN="${PROJECT_ROOT}/${WORKSTREAM}/${SUB_DIR}/DESIGN.md"
    if [[ -f "$SUB_DESIGN" ]]; then
        # Subsystem-level DESIGN.md exists — allow the write
        exit 0
    fi
fi

# --- BLOCK: No DESIGN.md found --------------------------------------------

# Provide actionable feedback to the agent via stderr (exit 2 sends stderr
# as feedback to Claude, per Claude Code hooks specification)
cat >&2 <<BLOCK_MSG
BLOCKED: Writing to ${WORKSTREAM}/ without a DESIGN.md.

The DSBV rule requires: "No ad-hoc artifacts. If work is not in DESIGN.md,
it is not in scope."

To fix this:
  1. Run '/dsbv design ${WORKSTREAM_PATTERN}' to create the Design specification
  2. Get human approval on the DESIGN.md
  3. Then proceed with Build stage writes

This hook enforces the DSBV stage ordering:
  Design (DESIGN.md) → Sequence → Build (workstream artifacts) → Validate

File attempted: ${FILE_PATH}
Expected first: ${DESIGN_FILE}
BLOCK_MSG

exit 2
