#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-29
# dsbv-skill-guard.sh — PreToolUse hook for Write|Edit on zone artifacts
#
# Enforces: "No ad-hoc artifacts. If work is not in a DESIGN.md, it is not in scope."
# (DSBV Rule, .claude/rules/dsbv.md)
#
# Behavior:
#   1. Reads PreToolUse JSON from stdin (tool_name, tool_input.file_path)
#   2. Checks if file is in a zone directory (1-ALIGN/, 2-PLAN/, 3-EXECUTE/, 4-IMPROVE/)
#   3. If not a zone file → ALLOW (exit 0)
#   4. If a DSBV process file (DESIGN.md, SEQUENCE.md, VALIDATE.md) → ALLOW
#   5. If zone's DESIGN.md exists → ALLOW (Design phase completed)
#   6. If zone's DESIGN.md does NOT exist → BLOCK (exit 2)
#
# This enforces the OUTCOME (DESIGN.md exists) rather than the PROCESS
# (skill was invoked). Rationale:
#   - DESIGN.md is the contract — if it exists, Design happened
#   - File check is deterministic and fast (<10ms)
#   - Immune to LT-8 (agent can't rationalize past a file-existence check)
#   - Per D6: hooks > rules > skills (this is the highest enforcement tier)
#
# Exit codes:
#   0 = allow (file is not a zone artifact, or DESIGN.md exists)
#   2 = block (zone artifact write without DESIGN.md)
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

# --- Determine if this is a zone artifact ----------------------------------

# Extract zone from file path
# Matches: /any/path/1-ALIGN/anything, /any/path/2-PLAN/anything, etc.
ZONE=""
ZONE_PATTERN=""
if [[ "$FILE_PATH" =~ /1-ALIGN/ ]]; then
    ZONE="1-ALIGN"
    ZONE_PATTERN="align"
elif [[ "$FILE_PATH" =~ /2-PLAN/ ]]; then
    ZONE="2-PLAN"
    ZONE_PATTERN="plan"
elif [[ "$FILE_PATH" =~ /3-EXECUTE/ ]]; then
    ZONE="3-EXECUTE"
    ZONE_PATTERN="execute"
elif [[ "$FILE_PATH" =~ /4-IMPROVE/ ]]; then
    ZONE="4-IMPROVE"
    ZONE_PATTERN="improve"
else
    # Not a zone file — allow (could be _genesis/, scripts/, .claude/, etc.)
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

# Some zone files are operational — they get updated incrementally, not as
# part of a DSBV Build phase. These include retrospectives, changelogs,
# metrics, decision records, and learning outputs.
RELATIVE_PATH="${FILE_PATH#*/${ZONE}/}"
case "$RELATIVE_PATH" in
    retrospectives/*|retros/*) exit 0 ;;    # Retros are IMPROVE operational
    changelog/*|CHANGELOG*) exit 0 ;;        # Changelogs are incremental
    metrics/*) exit 0 ;;                     # Metrics are incremental
    decisions/*) exit 0 ;;                   # ADRs can be written anytime
    learning/*) exit 0 ;;                    # Learning outputs from research
    reviews/*) exit 0 ;;                     # Review packages
    skills/*) exit 0 ;;                      # Skills are operational tools, evolve incrementally
esac

# --- Check if DESIGN.md exists for this zone -------------------------------

# Walk up from file path to find project root, then check zone's DESIGN.md
# Strategy: find the zone directory in the path, then look for DESIGN.md there
PROJECT_ROOT="${FILE_PATH%%/${ZONE}/*}"
DESIGN_FILE="${PROJECT_ROOT}/${ZONE}/DESIGN.md"

if [[ -f "$DESIGN_FILE" ]]; then
    # DESIGN.md exists — Design phase was completed, allow the write
    exit 0
fi

# --- BLOCK: No DESIGN.md found --------------------------------------------

# Provide actionable feedback to the agent via stderr (exit 2 sends stderr
# as feedback to Claude, per Claude Code hooks specification)
cat >&2 <<BLOCK_MSG
BLOCKED: Writing to ${ZONE}/ without a DESIGN.md.

The DSBV rule requires: "No ad-hoc artifacts. If work is not in DESIGN.md,
it is not in scope."

To fix this:
  1. Run '/dsbv design ${ZONE_PATTERN}' to create the Design specification
  2. Get human approval on the DESIGN.md
  3. Then proceed with Build phase writes

This hook enforces the DSBV phase ordering:
  Design (DESIGN.md) → Sequence → Build (zone artifacts) → Validate

File attempted: ${FILE_PATH}
Expected first: ${DESIGN_FILE}
BLOCK_MSG

exit 2
