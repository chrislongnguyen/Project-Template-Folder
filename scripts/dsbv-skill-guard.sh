#!/usr/bin/env bash
# version: 1.5 | status: draft | last_updated: 2026-04-11
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
#   5. If file is in a subsystem dir ({N}-{SUB}/ or _cross/):
#      a. Subsystem-level DESIGN.md exists → ALLOW
#      b. WS-level DESIGN.md alone → BLOCK (subsystem needs its own DESIGN.md)
#   6. If file is at workstream root (no subsystem): WS-level DESIGN.md → ALLOW
#   7. Otherwise → BLOCK (exit 2)
#
# DD-1 canonical path: {W}-{WS}/{S}-{SUB}/DESIGN.md
# Subsystem dirs: 1-PD | 2-DP | 3-DA | 4-IDM | _cross
#
# This enforces the OUTCOME (DESIGN.md exists at the correct level) rather than
# the PROCESS (skill was invoked). Rationale:
#   - DESIGN.md is the contract — if it exists at subsystem level, Design happened
#   - File check is deterministic and fast (<10ms)
#   - Immune to LT-8 (agent can't rationalize past a file-existence check)
#   - Per D6: hooks > rules > skills (this is the highest enforcement tier)
#
# Exit codes:
#   0 = allow (file is not a workstream artifact, or correct DESIGN.md exists)
#   2 = block (subsystem artifact write without subsystem-level DESIGN.md)
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

# --- Determine subsystem from file path -------------------------------------------

# Extract subsystem dir from path using {W}-{WS}/{S}-{SUB}/ pattern
# Matches: 1-PD, 2-DP, 3-DA, 4-IDM, _cross
# RELATIVE_PATH is already relative to the workstream dir (e.g. "1-PD/pd-charter.md")
PROJECT_ROOT="${FILE_PATH%%/${WORKSTREAM}/*}"
SUB_DIR=$(echo "$RELATIVE_PATH" | cut -d'/' -f1)

# Determine if the file is inside a known subsystem dir
# Step 1: broad regex catches numeric-prefixed dirs and _cross
IS_SUBSYSTEM=0
if [[ "$SUB_DIR" =~ ^[0-9]+-[A-Za-z]+$ ]] || [[ "$SUB_DIR" == "_cross" ]]; then
    # Step 2: canonical validation — only accepted subsystem names qualify.
    # Non-matching dirs (e.g. a stray "1-OLD/" dir) fall through to WS-level check.
    case "$SUB_DIR" in
        1-PD|2-DP|3-DA|4-IDM|_cross) IS_SUBSYSTEM=1 ;;
        *) IS_SUBSYSTEM=0 ;;
    esac
fi

# --- Check DESIGN.md at the correct level ----------------------------------------

if [[ "$IS_SUBSYSTEM" -eq 1 ]]; then
    # File is inside a subsystem dir — ONLY subsystem-level DESIGN.md satisfies guard.
    # WS-level DESIGN.md alone does NOT satisfy (AC-10).
    SUB_DESIGN="${PROJECT_ROOT}/${WORKSTREAM}/${SUB_DIR}/DESIGN.md"
    if [[ -f "$SUB_DESIGN" ]]; then
        # Subsystem-level DESIGN.md exists — allow
        exit 0
    fi
    # WS-level DESIGN.md present but subsystem-level absent — still BLOCK
    DESIGN_FILE="$SUB_DESIGN"
    BLOCK_HINT="Run '/dsbv design ${WORKSTREAM_PATTERN}' scoped to subsystem ${SUB_DIR}"
else
    # File is at workstream root (no subsystem) — WS-level DESIGN.md is sufficient
    DESIGN_FILE="${PROJECT_ROOT}/${WORKSTREAM}/DESIGN.md"
    if [[ -f "$DESIGN_FILE" ]]; then
        exit 0
    fi
    BLOCK_HINT="Run '/dsbv design ${WORKSTREAM_PATTERN}' to create the Design specification"
fi

# --- BLOCK: No DESIGN.md found at required level ----------------------------------

# Provide actionable feedback to the agent via stderr (exit 2 sends stderr
# as feedback to Claude, per Claude Code hooks specification)
cat >&2 <<BLOCK_MSG
BLOCKED: Writing to ${WORKSTREAM}/${SUB_DIR}/ without a subsystem-level DESIGN.md.

The DSBV rule requires: "No ad-hoc artifacts. If work is not in DESIGN.md,
it is not in scope."

A workstream-level DESIGN.md does NOT satisfy this guard for subsystem writes.
Each subsystem requires its own DESIGN.md at: ${DESIGN_FILE}

To fix this:
  1. ${BLOCK_HINT}
  2. Get human approval on the DESIGN.md
  3. Then proceed with Build stage writes

This hook enforces the DSBV stage ordering:
  Design (DESIGN.md) → Sequence → Build (workstream artifacts) → Validate

File attempted: ${FILE_PATH}
Expected first: ${DESIGN_FILE}
BLOCK_MSG

exit 2
