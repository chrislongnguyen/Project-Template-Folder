#!/bin/bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# gate-precheck.sh — Validate prerequisites before presenting a DSBV gate (C-04)
# Bash 3 compatible: no mapfile, no declare -A, no local -a, no bash 4+ features
#
# Usage:
#   gate-precheck.sh <gate> <workstream> [workstream_dir]
#     gate          : G1, G2, G3, or G4
#     workstream    : e.g. 1-ALIGN, 3-PLAN (used to find DESIGN.md, SEQUENCE.md, VALIDATE.md)
#     workstream_dir: optional path to workstream dir (default: ./<workstream>/)
#
# Exit 0: all prerequisites for this gate are met
# Exit 1: one or more prerequisites missing (specific message to stderr)
#
# Prerequisites per gate:
#   G1: DESIGN.md exists in workstream dir AND contains at least 1 line matching "AC-"
#   G2: SEQUENCE.md exists in workstream dir AND contains at least 1 line matching "T[0-9]" or "Task"
#   G3: SEQUENCE.md exists AND .claude/logs/dsbv-metrics.jsonl has >= 1 entry
#       (if metrics log absent: WARN but do not block)
#   G4: VALIDATE.md exists in workstream dir AND contains a line matching "ACs:.*[0-9]"
#       or "## Aggregate" or "pass"
#
# Root causes addressed: RC-01, RC-11
# ACs: AC-12, AC-13, AC-33

# ---------------------------------------------------------------------------
# validate_args
# ---------------------------------------------------------------------------
GATE="$1"
WORKSTREAM="$2"
WS_DIR_ARG="$3"

if [ -z "$GATE" ] || [ -z "$WORKSTREAM" ]; then
  echo "Usage: gate-precheck.sh <gate> <workstream> [workstream_dir]" >&2
  echo "  gate        : G1, G2, G3, or G4" >&2
  echo "  workstream  : e.g. 1-ALIGN, 3-PLAN" >&2
  echo "  workstream_dir: optional path to workstream dir (default: ./<workstream>/)" >&2
  exit 1
fi

case "$GATE" in
  G1|G2|G3|G4) ;;
  *)
    echo "ERROR: Invalid gate '${GATE}'. Must be G1, G2, G3, or G4." >&2
    exit 1
    ;;
esac

# ---------------------------------------------------------------------------
# resolve_workstream_dir
# ---------------------------------------------------------------------------
resolve_workstream_dir() {
  # Try <workstream>/ from current directory first
  if [ -d "./${WORKSTREAM}" ]; then
    echo "./${WORKSTREAM}"
    return 0
  fi

  # If workstream_dir arg provided, use that
  if [ -n "$WS_DIR_ARG" ]; then
    if [ -d "$WS_DIR_ARG" ]; then
      echo "$WS_DIR_ARG"
      return 0
    else
      echo "ERROR: Provided workstream_dir '${WS_DIR_ARG}' does not exist." >&2
      return 1
    fi
  fi

  echo "ERROR: Workstream directory not found: '${WORKSTREAM}/' in '$(pwd)'. Pass workstream_dir as third argument." >&2
  return 1
}

WS_DIR="$(resolve_workstream_dir)" || exit 1

# ---------------------------------------------------------------------------
# find_file_in_ws <filename>
# Search workstream dir up to depth 3, return first match or empty string
# ---------------------------------------------------------------------------
find_file_in_ws() {
  fname="$1"
  found="$(find "$WS_DIR" -maxdepth 3 -name "$fname" 2>/dev/null | head -1)"
  echo "$found"
}

# ---------------------------------------------------------------------------
# check_g1: DESIGN.md exists AND has >= 1 "AC-" line
# ---------------------------------------------------------------------------
check_g1() {
  design_file="$(find_file_in_ws "DESIGN.md")"

  if [ -z "$design_file" ]; then
    echo "ERROR: G1 prerequisite failed — DESIGN.md not found in '${WS_DIR}'." >&2
    echo "  Create a DESIGN.md with acceptance criteria before presenting G1." >&2
    exit 1
  fi

  if ! grep -q "AC-" "$design_file" 2>/dev/null; then
    echo "ERROR: G1 prerequisite failed — no acceptance criteria found in '${design_file}'." >&2
    echo "  DESIGN.md must contain at least one line matching 'AC-' (e.g., AC-01, AC-02)." >&2
    exit 1
  fi

  echo "OK: G1 prerequisites met — DESIGN.md found with acceptance criteria."
  exit 0
}

# ---------------------------------------------------------------------------
# check_g2: SEQUENCE.md exists AND has >= 1 task line (T[0-9] or "Task")
# ---------------------------------------------------------------------------
check_g2() {
  sequence_file="$(find_file_in_ws "SEQUENCE.md")"

  if [ -z "$sequence_file" ]; then
    echo "ERROR: G2 prerequisite failed — SEQUENCE.md not found in '${WS_DIR}'." >&2
    echo "  Create a SEQUENCE.md with task definitions before presenting G2." >&2
    exit 1
  fi

  if ! grep -qE "T[0-9]|Task" "$sequence_file" 2>/dev/null; then
    echo "ERROR: G2 prerequisite failed — no task entries found in '${sequence_file}'." >&2
    echo "  SEQUENCE.md must contain at least one line matching 'T[0-9]' or 'Task'." >&2
    exit 1
  fi

  echo "OK: G2 prerequisites met — SEQUENCE.md found with task definitions."
  exit 0
}

# ---------------------------------------------------------------------------
# check_g3: SEQUENCE.md exists AND metrics log has >= 1 entry
#           (missing metrics log = WARN but do not block)
# ---------------------------------------------------------------------------
check_g3() {
  sequence_file="$(find_file_in_ws "SEQUENCE.md")"

  if [ -z "$sequence_file" ]; then
    echo "ERROR: G3 prerequisite failed — SEQUENCE.md not found in '${WS_DIR}'." >&2
    echo "  Build phase cannot be verified without a SEQUENCE.md." >&2
    exit 1
  fi

  # Locate metrics log: .claude/logs/dsbv-metrics.jsonl relative to project root
  # Try upward from cwd to find .claude/logs/
  metrics_log=""
  candidate_dir="$(pwd)"
  # Search up to 4 levels
  i=0
  while [ $i -lt 5 ]; do
    candidate="${candidate_dir}/.claude/logs/dsbv-metrics.jsonl"
    if [ -f "$candidate" ]; then
      metrics_log="$candidate"
      break
    fi
    parent="$(dirname "$candidate_dir")"
    if [ "$parent" = "$candidate_dir" ]; then
      break
    fi
    candidate_dir="$parent"
    i=$((i + 1))
  done

  if [ -z "$metrics_log" ]; then
    echo "WARN: G3 — metrics log '.claude/logs/dsbv-metrics.jsonl' not found." >&2
    echo "  Build completions have not been recorded yet." >&2
    echo "  Proceeding without metrics verification (non-blocking)." >&2
    echo "OK: G3 prerequisites met (with warning) — SEQUENCE.md found; metrics log absent."
    exit 0
  fi

  # Check log has at least 1 entry
  line_count="$(grep -c "" "$metrics_log" 2>/dev/null || echo 0)"
  if [ "$line_count" -lt 1 ]; then
    echo "WARN: G3 — metrics log exists but contains no entries." >&2
    echo "  Proceeding without metrics verification (non-blocking)." >&2
    echo "OK: G3 prerequisites met (with warning) — SEQUENCE.md found; metrics log empty."
    exit 0
  fi

  echo "OK: G3 prerequisites met — SEQUENCE.md found, metrics log has ${line_count} entries."
  exit 0
}

# ---------------------------------------------------------------------------
# check_g4: VALIDATE.md exists AND has aggregate/score line
# ---------------------------------------------------------------------------
check_g4() {
  validate_file="$(find_file_in_ws "VALIDATE.md")"

  if [ -z "$validate_file" ]; then
    echo "ERROR: G4 prerequisite failed — VALIDATE.md not found in '${WS_DIR}'." >&2
    echo "  Create a VALIDATE.md with an aggregate score before presenting G4." >&2
    exit 1
  fi

  if ! grep -qiE "ACs:.*[0-9]|## Aggregate|pass" "$validate_file" 2>/dev/null; then
    echo "ERROR: G4 prerequisite failed — no aggregate score line found in '${validate_file}'." >&2
    echo "  VALIDATE.md must contain a line matching 'ACs: N/M', '## Aggregate', or 'pass'." >&2
    exit 1
  fi

  echo "OK: G4 prerequisites met — VALIDATE.md found with aggregate score."
  exit 0
}

# ---------------------------------------------------------------------------
# dispatch to gate check
# ---------------------------------------------------------------------------
case "$GATE" in
  G1) check_g1 ;;
  G2) check_g2 ;;
  G3) check_g3 ;;
  G4) check_g4 ;;
esac
