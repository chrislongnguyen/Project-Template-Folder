#!/bin/bash
# version: 1.2 | status: draft | last_updated: 2026-04-11
# gate-precheck.sh — Validate prerequisites before presenting a DSBV gate (C-04)
# Bash 3 compatible: no mapfile, no declare -A, no local -a, no bash 4+ features
#
# Usage:
#   gate-precheck.sh <gate> <workstream> [workstream_dir] [subsystem]
#     gate          : G1, G2, G3, or G4
#     workstream    : e.g. 1-ALIGN, 3-PLAN (used to find DESIGN.md, SEQUENCE.md, VALIDATE.md)
#     workstream_dir: optional path to workstream dir (default: ./<workstream>/)
#     subsystem     : optional subsystem scope (pd|dp|da|idm|cross)
#                     When provided: state file = dsbv-<ws>-<sub>.json,
#                     file search scoped to {workstream}/{S}-{SUB}/
#                     When omitted: workstream-level state (deprecated — use subsystem arg)
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
SUBSYSTEM="$4"

if [ -z "$GATE" ] || [ -z "$WORKSTREAM" ]; then
  echo "Usage: gate-precheck.sh <gate> <workstream> [workstream_dir] [subsystem]" >&2
  echo "  gate          : G1, G2, G3, or G4" >&2
  echo "  workstream    : e.g. 1-ALIGN, 3-PLAN" >&2
  echo "  workstream_dir: optional path to workstream dir (default: ./<workstream>/)" >&2
  echo "  subsystem     : optional pd|dp|da|idm|cross — scopes state file and file search" >&2
  exit 1
fi

# Validate subsystem value if provided
if [ -n "$SUBSYSTEM" ]; then
  case "$SUBSYSTEM" in
    pd|dp|da|idm|cross) ;;
    *)
      echo "ERROR: Invalid subsystem '${SUBSYSTEM}'. Must be one of: pd dp da idm cross" >&2
      exit 1
      ;;
  esac
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
# Search workstream dir up to depth 3, return first match or empty string.
# When SUBSYSTEM is set, scope search to {WS_DIR}/{N}-{SUBSYSTEM_UPPER}/.
# ---------------------------------------------------------------------------
find_file_in_ws() {
  fname="$1"
  search_root="$WS_DIR"

  if [ -n "$SUBSYSTEM" ]; then
    # Map subsystem code to directory prefix (pd->1, dp->2, da->3, idm->4, cross->_)
    sub_upper="$(echo "$SUBSYSTEM" | tr '[:lower:]' '[:upper:]')"
    case "$SUBSYSTEM" in
      pd)    sub_dir="${WS_DIR}/1-${sub_upper}" ;;
      dp)    sub_dir="${WS_DIR}/2-${sub_upper}" ;;
      da)    sub_dir="${WS_DIR}/3-${sub_upper}" ;;
      idm)   sub_dir="${WS_DIR}/4-${sub_upper}" ;;
      cross) sub_dir="${WS_DIR}/_cross" ;;
    esac
    if [ -d "$sub_dir" ]; then
      search_root="$sub_dir"
    fi
    # If subsystem dir absent, fall through to WS_DIR (graceful degradation)
  fi

  found="$(find "$search_root" -maxdepth 3 -name "$fname" 2>/dev/null | head -1)"
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
    echo "  Build stage cannot be verified without a SEQUENCE.md." >&2
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
# check_subsystem_ordering
# Enforces the PD >= DP >= DA >= IDM version ceiling.
# Subsystem ordering: PD(1) >= DP(2) >= DA(3) >= IDM(4).
# When subsystem is null or empty in state file → skip (return 0, no-op).
# When subsystem is non-null → read upstream subsystem's DESIGN.md version
# and compare. If current subsystem version > upstream version → exit 1.
#
# State file location: .claude/state/dsbv-<ws>-<sub>.json  (subsystem arg provided)
#                     .claude/state/dsbv-<workstream>.json   (deprecated: no subsystem arg)
# Reads: "subsystem": "<value>" field from state JSON
# Reads: version from DESIGN.md frontmatter (line: "^version:")
# ---------------------------------------------------------------------------
check_subsystem_ordering() {
  # Determine state file path.
  # When SUBSYSTEM arg provided: use subsystem-scoped state file.
  # When omitted: fall back to workstream-level file with deprecation warning.
  if [ -n "$SUBSYSTEM" ]; then
    # Normalise workstream for filename: lowercase, strip leading digit+dash
    ws_key="$(echo "$WORKSTREAM" | tr '[:upper:]' '[:lower:]')"
    state_file=".claude/state/dsbv-${ws_key}-${SUBSYSTEM}.json"
  else
    state_file=".claude/state/dsbv-${WORKSTREAM}.json"
    if [ -f "$state_file" ]; then
      echo "DEPRECATION WARNING: gate-precheck.sh called without subsystem arg; reading workstream-level state '${state_file}'. Pass subsystem as 4th arg (pd|dp|da|idm|cross) to use subsystem-scoped state." >&2
    fi
  fi

  if [ ! -f "$state_file" ]; then
    # No state file: subsystem feature not active — skip silently
    return 0
  fi

  # Extract subsystem value from state JSON
  # Line format: "subsystem": null  OR  "subsystem": "1-PD"
  subsystem_raw="$(grep '"subsystem"' "$state_file" | sed 's/.*"subsystem": *\(.*\)/\1/' | sed 's/[", ]//g' | sed 's/,//')"

  # If null or empty → skip ordering check entirely
  if [ -z "$subsystem_raw" ] || [ "$subsystem_raw" = "null" ]; then
    return 0
  fi

  # Map subsystem code to numeric rank
  # PD=1, DP=2, DA=3, IDM=4
  subsystem_rank=0
  case "$subsystem_raw" in
    1-PD)  subsystem_rank=1 ;;
    2-DP)  subsystem_rank=2 ;;
    3-DA)  subsystem_rank=3 ;;
    4-IDM) subsystem_rank=4 ;;
    *)
      echo "WARN: check_subsystem_ordering — unrecognised subsystem '${subsystem_raw}', skipping version ordering check." >&2
      return 0
      ;;
  esac

  # PD (rank=1) has no upstream — skip version ordering for PD
  if [ "$subsystem_rank" -le 1 ]; then
    return 0
  fi

  # Derive upstream subsystem code (rank - 1)
  upstream_rank=$((subsystem_rank - 1))
  case "$upstream_rank" in
    1) upstream_subsystem="1-PD" ;;
    2) upstream_subsystem="2-DP" ;;
    3) upstream_subsystem="3-DA" ;;
  esac

  # Read current subsystem's DESIGN.md version
  current_design="$(find "$WS_DIR" -maxdepth 3 -path "*/${subsystem_raw}/DESIGN.md" 2>/dev/null | head -1)"
  if [ -z "$current_design" ]; then
    # Cannot find current DESIGN.md — cannot enforce ordering, skip
    return 0
  fi

  current_version="$(grep '^version:' "$current_design" | sed 's/version: *"\?\([0-9.]*\)"\?.*/\1/' | head -1)"

  # Read upstream subsystem's DESIGN.md version
  upstream_design="$(find "$WS_DIR" -maxdepth 3 -path "*/${upstream_subsystem}/DESIGN.md" 2>/dev/null | head -1)"
  if [ -z "$upstream_design" ]; then
    echo "ERROR: Subsystem version ordering check failed — upstream subsystem '${upstream_subsystem}' has no DESIGN.md in '${WS_DIR}'." >&2
    echo "  PD >= DP >= DA >= IDM version ceiling requires upstream DESIGN.md to exist." >&2
    exit 1
  fi

  upstream_version="$(grep '^version:' "$upstream_design" | sed 's/version: *"\?\([0-9.]*\)"\?.*/\1/' | head -1)"

  if [ -z "$current_version" ] || [ -z "$upstream_version" ]; then
    echo "WARN: check_subsystem_ordering — could not read version from one or both DESIGN.md files (current='${current_version}', upstream='${upstream_version}'). Skipping." >&2
    return 0
  fi

  # Compare MAJOR.MINOR versions using awk (Bash 3 safe, no bc needed)
  # Returns 1 if current > upstream, 0 otherwise
  ordering_ok="$(awk -v cur="$current_version" -v up="$upstream_version" '
    BEGIN {
      split(cur, ca, ".")
      split(up,  ua, ".")
      cur_major = ca[1]+0; cur_minor = (ca[2]+0)
      up_major  = ua[1]+0; up_minor  = (ua[2]+0)
      if (cur_major > up_major) { print "FAIL" }
      else if (cur_major == up_major && cur_minor > up_minor) { print "FAIL" }
      else { print "OK" }
    }')"

  if [ "$ordering_ok" = "FAIL" ]; then
    echo "ERROR: Subsystem version ordering violated — ${subsystem_raw} version ${current_version} exceeds upstream ${upstream_subsystem} version ${upstream_version}." >&2
    echo "  PD >= DP >= DA >= IDM: downstream subsystem MUST NOT exceed upstream version." >&2
    echo "  Fix: advance upstream ${upstream_subsystem} DESIGN.md to at least version ${current_version} first." >&2
    exit 1
  fi

  echo "OK: Subsystem version ordering check passed — ${upstream_subsystem} ${upstream_version} >= ${subsystem_raw} ${current_version}."
}

# Run subsystem ordering check before gate-specific check.
# When subsystem is null/empty in state, this is a no-op (null-safe).
check_subsystem_ordering

# ---------------------------------------------------------------------------
# dispatch to gate check
# ---------------------------------------------------------------------------
case "$GATE" in
  G1) check_g1 ;;
  G2) check_g2 ;;
  G3) check_g3 ;;
  G4) check_g4 ;;
esac
