#!/bin/bash
# version: 1.1 | status: draft | last_updated: 2026-04-11
# gate-ceremony.sh — Convenience wrapper for the full DSBV gate transition sequence (E-FIX-2)
# Bash 3 compatible: no mapfile, no declare -A, no bash 4+ features
#
# Calls 4 individual scripts in order with fail-fast behavior.
# Each individual script remains independently callable.
#
# Usage:
#   gate-ceremony.sh <gate> <workstream> [artifact_path] [workstream_dir] [subsystem]
#     gate           : G1, G2, G3, or G4
#     workstream     : e.g. 1-ALIGN, 3-PLAN
#     artifact_path  : optional path to the artifact .md file (enables step 2 + 3)
#     workstream_dir : optional path to workstream dir (passed to gate-precheck.sh)
#     subsystem      : optional subsystem scope — pd, dp, da, idm, or cross
#                      when provided, forwards to gate-precheck.sh (4th arg) and
#                      gate-state.sh advance (3rd arg after gate) for subsystem-scoped
#                      state files; omit for backward-compatible workstream-level behavior
#
# Steps (in order):
#   1. gate-precheck.sh     — verify prerequisites for the gate
#   2. set-status-in-review.sh — mark artifact in-review (only if artifact_path provided)
#   3. verify-approval-record.sh — confirm approval row exists (only if artifact_path provided)
#   4. gate-state.sh advance   — advance gate state machine
#
# Exit 0: all steps completed successfully
# Exit 1: one or more steps failed (step output identifies the cause)

set -euo pipefail

# ---------------------------------------------------------------------------
# Resolve SCRIPTS_DIR relative to this file so the wrapper works regardless
# of the caller's cwd.
# ---------------------------------------------------------------------------
SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

GATE="${1:-}"
WORKSTREAM="${2:-}"
ARTIFACT_PATH="${3:-}"
WS_DIR_ARG="${4:-}"
SUBSYSTEM="${5:-}"

# ---------------------------------------------------------------------------
# validate args
# ---------------------------------------------------------------------------
if [ -z "$GATE" ] || [ -z "$WORKSTREAM" ]; then
  echo "Usage: gate-ceremony.sh <gate> <workstream> [artifact_path] [workstream_dir] [subsystem]" >&2
  echo "  gate          : G1, G2, G3, or G4" >&2
  echo "  workstream    : e.g. 1-ALIGN, 3-PLAN" >&2
  echo "  artifact_path : optional — enables set-status-in-review + verify-approval-record" >&2
  echo "  workstream_dir: optional — passed to gate-precheck.sh as third arg" >&2
  echo "  subsystem     : optional — pd, dp, da, idm, or cross (subsystem-scoped state)" >&2
  exit 1
fi

case "$GATE" in
  G1|G2|G3|G4) ;;
  *)
    echo "ERROR: Invalid gate '${GATE}'. Must be G1, G2, G3, or G4." >&2
    exit 1
    ;;
esac

if [ -n "$SUBSYSTEM" ]; then
  case "$SUBSYSTEM" in
    pd|dp|da|idm|cross) ;;
    *)
      echo "ERROR: Invalid subsystem '${SUBSYSTEM}'. Must be pd, dp, da, idm, or cross." >&2
      exit 1
      ;;
  esac
fi

# ---------------------------------------------------------------------------
# Step 1 — gate-precheck.sh
# ---------------------------------------------------------------------------
echo "--- Step 1: gate-precheck.sh ${GATE} ${WORKSTREAM} ---"
if [ -n "$SUBSYSTEM" ]; then
  # subsystem provided: forward as 4th arg (after workstream_dir, which may be empty)
  bash "${SCRIPTS_DIR}/gate-precheck.sh" "$GATE" "$WORKSTREAM" "$WS_DIR_ARG" "$SUBSYSTEM"
elif [ -n "$WS_DIR_ARG" ]; then
  bash "${SCRIPTS_DIR}/gate-precheck.sh" "$GATE" "$WORKSTREAM" "$WS_DIR_ARG"
else
  bash "${SCRIPTS_DIR}/gate-precheck.sh" "$GATE" "$WORKSTREAM"
fi

# ---------------------------------------------------------------------------
# Step 2 — set-status-in-review.sh (only if artifact_path provided)
# ---------------------------------------------------------------------------
if [ -n "$ARTIFACT_PATH" ]; then
  echo "--- Step 2: set-status-in-review.sh ${ARTIFACT_PATH} ---"
  bash "${SCRIPTS_DIR}/set-status-in-review.sh" "$ARTIFACT_PATH"
else
  echo "--- Step 2: skipped (no artifact_path provided) ---"
fi

# ---------------------------------------------------------------------------
# Step 3 — verify-approval-record.sh (only if artifact_path provided)
# ---------------------------------------------------------------------------
if [ -n "$ARTIFACT_PATH" ]; then
  echo "--- Step 3: verify-approval-record.sh ${ARTIFACT_PATH} ---"
  bash "${SCRIPTS_DIR}/verify-approval-record.sh" "$ARTIFACT_PATH"
else
  echo "--- Step 3: skipped (no artifact_path provided) ---"
fi

# ---------------------------------------------------------------------------
# Step 4 — gate-state.sh advance
# ---------------------------------------------------------------------------
echo "--- Step 4: gate-state.sh advance ${WORKSTREAM} ${GATE} ---"
if [ -n "$SUBSYSTEM" ]; then
  bash "${SCRIPTS_DIR}/gate-state.sh" advance "$WORKSTREAM" "$GATE" "$SUBSYSTEM"
else
  bash "${SCRIPTS_DIR}/gate-state.sh" advance "$WORKSTREAM" "$GATE"
fi

echo "OK: gate-ceremony complete for ${GATE} / ${WORKSTREAM}${SUBSYSTEM:+ / ${SUBSYSTEM}}"
