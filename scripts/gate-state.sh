#!/bin/bash
# version: 1.3 | status: draft | last_updated: 2026-04-11
# gate-state.sh — DSBV gate state machine (C-01, C-08)
# Bash 3 compatible: no mapfile, no declare -A, no local -a
# JSON ops via awk/sed — no jq required
#
# State format: each gate is a single JSON line, e.g.:
#   "G1": { "status": "pending",  "approved_date": null, ... }
#
# State file path (DD-1 canonical): .claude/state/dsbv-{ws}-{sub}.json
# When subsystem omitted (deprecated): .claude/state/dsbv-{ws}.json
#
# Usage:
#   gate-state.sh init <workstream> [subsystem]                # Create state file
#   gate-state.sh read <workstream> [subsystem]                # Print state JSON
#   gate-state.sh advance <workstream> <gate> [subsystem]      # G1=approved → G2=pending, etc.
#   gate-state.sh reset <workstream> [subsystem]               # Reset all gates to initial
#   gate-state.sh set-subsystem <workstream> <subsystem>       # Set active subsystem (1-PD|2-DP|3-DA|4-IDM|null)
#   gate-state.sh update-loop <workstream> iteration <N> [subsystem]   # Add N to loop iteration
#   gate-state.sh update-loop <workstream> cost_tokens <N> [subsystem] # Add N to cost_tokens
#   gate-state.sh update-loop <workstream> fail_count <N> [subsystem]  # Add N to fail_count
#
# subsystem values (lowercase): pd|dp|da|idm|cross

STATE_DIR=".claude/state"

# ---------------------------------------------------------------------------
# iso_now: current UTC timestamp YYYY-MM-DDTHH:MM:SSZ
# ---------------------------------------------------------------------------
iso_now() {
  date -u "+%Y-%m-%dT%H:%M:%SZ"
}

# ---------------------------------------------------------------------------
# today_date: current UTC date YYYY-MM-DD
# ---------------------------------------------------------------------------
today_date() {
  date -u "+%Y-%m-%d"
}

# ---------------------------------------------------------------------------
# validate_subsystem <sub_lower>
# Accepts: pd|dp|da|idm|cross. Exits 1 on invalid.
# ---------------------------------------------------------------------------
validate_subsystem() {
  case "$1" in
    pd|dp|da|idm|cross) ;;
    *)
      echo "ERROR: Invalid subsystem '$1'. Must be one of: pd, dp, da, idm, cross" >&2
      exit 1
      ;;
  esac
}

# ---------------------------------------------------------------------------
# map_subsystem <sub_lower> → display label
# pd→1-PD, dp→2-DP, da→3-DA, idm→4-IDM, cross→_cross
# ---------------------------------------------------------------------------
map_subsystem() {
  case "$1" in
    pd)    echo "1-PD" ;;
    dp)    echo "2-DP" ;;
    da)    echo "3-DA" ;;
    idm)   echo "4-IDM" ;;
    cross) echo "_cross" ;;
  esac
}

# ---------------------------------------------------------------------------
# get_state_file <workstream> [subsystem]
# With subsystem: .claude/state/dsbv-{ws}-{sub}.json
# Without (deprecated): .claude/state/dsbv-{ws}.json + warning to stderr
# ---------------------------------------------------------------------------
get_state_file() {
  ws="$1"
  sub="$2"
  if [ -n "$sub" ]; then
    echo "${STATE_DIR}/dsbv-${ws}-${sub}.json"
  else
    echo "WARNING: WS-level state is deprecated. Use: gate-state.sh <cmd> <workstream> <subsystem>" >&2
    echo "${STATE_DIR}/dsbv-${ws}.json"
  fi
}

# ---------------------------------------------------------------------------
# print_initial_json <workstream> [subsystem_lower]
# Emits the canonical initial state JSON. Each gate is on one line.
# If subsystem provided, sets "subsystem": "<display>" else null.
# ---------------------------------------------------------------------------
print_initial_json() {
  ws="$1"
  sub="$2"
  ts="$(iso_now)"
  printf '{\n'
  printf '  "workstream": "%s",\n' "$ws"
  if [ -n "$sub" ]; then
    sub_display="$(map_subsystem "$sub")"
    printf '  "subsystem": "%s",\n' "$sub_display"
  else
    printf '  "subsystem": null,\n'
  fi
  printf '  "current_phase": "design",\n'
  printf '  "gates": {\n'
  printf '    "G1": { "status": "pending",  "approved_date": null, "signal": null, "tier": null },\n'
  printf '    "G2": { "status": "locked",   "approved_date": null, "signal": null, "tier": null },\n'
  printf '    "G3": { "status": "locked",   "approved_date": null, "signal": null, "tier": null },\n'
  printf '    "G4": { "status": "locked",   "approved_date": null, "signal": null, "tier": null }\n'
  printf '  },\n'
  printf '  "loop_state": {\n'
  printf '    "iteration": 0,\n'
  printf '    "max_iterations": 3,\n'
  printf '    "fail_count": 0,\n'
  printf '    "cost_tokens": 0\n'
  printf '  },\n'
  printf '  "updated": "%s"\n' "$ts"
  printf '}\n'
}

# ---------------------------------------------------------------------------
# get_gate_status <file> <gate>
# Each gate is on a single line: "GN": { "status": "VALUE", ...
# Use grep to isolate the line, then sed to extract the status value.
# ---------------------------------------------------------------------------
get_gate_status() {
  json_file="$1"
  gate="$2"
  # grep the line containing "GN", then extract status value
  grep "\"${gate}\"" "$json_file" | sed 's/.*"status": *"\([^"]*\)".*/\1/'
}

# ---------------------------------------------------------------------------
# set_gate_status <file> <gate> <new_status>
# Replaces the status value on the gate's line using sed.
# Gate line format: "GN": { "status": "OLD_VALUE", ...
# ---------------------------------------------------------------------------
set_gate_status() {
  json_file="$1"
  gate="$2"
  new_status="$3"
  # sed: on the line matching the gate key, replace the status value
  sed "s/\\(\"${gate}\".*\"status\": *\"\\)[^\"]*\"/\\1${new_status}\"/" \
    "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
}

# ---------------------------------------------------------------------------
# set_gate_approved_date <file> <gate> <date_or_null>
# Replaces approved_date on the gate's line.
# Gate line format: ... "approved_date": null, ...
#                or ... "approved_date": "YYYY-MM-DD", ...
# ---------------------------------------------------------------------------
set_gate_approved_date() {
  json_file="$1"
  gate="$2"
  new_val="$3"   # pass quoted string like '"2026-04-09"' or literal 'null'

  if [ "$new_val" = "null" ]; then
    # Replace "approved_date": "..." or "approved_date": null → null
    sed "s/\\(\"${gate}\".*\"approved_date\": *\\)\"[^\"]*\"/\\1null/" \
      "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
  else
    # Replace "approved_date": null or "approved_date": "..." → "DATE"
    sed "s/\\(\"${gate}\".*\"approved_date\": *\\)null/\\1\"${new_val}\"/" \
      "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
    # Also handle if it already has a quoted date
    sed "s/\\(\"${gate}\".*\"approved_date\": *\\)\"[^\"]*\"/\\1\"${new_val}\"/" \
      "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
  fi
}

# ---------------------------------------------------------------------------
# set_current_phase <file> <new_phase>
# ---------------------------------------------------------------------------
set_current_phase() {
  json_file="$1"
  new_phase="$2"
  sed "s/\"current_phase\": *\"[^\"]*\"/\"current_phase\": \"${new_phase}\"/" \
    "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
}

# ---------------------------------------------------------------------------
# bump_updated <file>
# ---------------------------------------------------------------------------
bump_updated() {
  json_file="$1"
  ts="$(iso_now)"
  sed "s/\"updated\": *\"[^\"]*\"/\"updated\": \"${ts}\"/" \
    "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
}

# ---------------------------------------------------------------------------
# set_subsystem_field <file> <subsystem_or_null>
# Replaces the "subsystem": ... line. Handles both null and quoted string values.
# Line format (null):   "subsystem": null,
# Line format (string): "subsystem": "1-PD",
# ---------------------------------------------------------------------------
set_subsystem_field() {
  json_file="$1"
  new_val="$2"  # either literal: null  OR  a subsystem code like 1-PD
  if [ "$new_val" = "null" ]; then
    sed 's/"subsystem": *"[^"]*"/"subsystem": null/' \
      "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
    # Also handle case where it is already null (no-op safe)
    sed 's/"subsystem": *null/"subsystem": null/' \
      "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
  else
    # Replace null → "value"
    sed "s/\"subsystem\": *null/\"subsystem\": \"${new_val}\"/" \
      "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
    # Replace existing quoted value → "value"
    sed "s/\"subsystem\": *\"[^\"]*\"/\"subsystem\": \"${new_val}\"/" \
      "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
  fi
}

# ---------------------------------------------------------------------------
# cmd_set_subsystem <workstream> <subsystem>
# Sets the active subsystem in the state file.
# Allowed values: 1-PD, 2-DP, 3-DA, 4-IDM, null
# ---------------------------------------------------------------------------
cmd_set_subsystem() {
  ws="$1"
  subsystem="$2"

  if [ -z "$ws" ] || [ -z "$subsystem" ]; then
    echo "ERROR: set-subsystem requires <workstream> and <subsystem> arguments" >&2
    echo "       Allowed values: 1-PD, 2-DP, 3-DA, 4-IDM, null" >&2
    exit 1
  fi

  case "$subsystem" in
    1-PD|2-DP|3-DA|4-IDM|null) ;;
    *)
      echo "ERROR: Invalid subsystem '${subsystem}'. Must be one of: 1-PD, 2-DP, 3-DA, 4-IDM, null" >&2
      exit 1
      ;;
  esac

  state_file="$(get_state_file "$ws")"

  if [ ! -f "$state_file" ]; then
    echo "ERROR: State file not found: $state_file" >&2
    echo "       Run 'gate-state.sh init $ws' first." >&2
    exit 2
  fi

  set_subsystem_field "$state_file" "$subsystem"
  bump_updated "$state_file"
  echo "OK: subsystem set to ${subsystem} in $state_file"
}

# ---------------------------------------------------------------------------
# cmd_init <workstream> [subsystem]
# ---------------------------------------------------------------------------
cmd_init() {
  ws="$1"
  sub="$2"
  if [ -z "$ws" ]; then
    echo "ERROR: init requires <workstream> argument" >&2
    exit 1
  fi

  if [ -n "$sub" ]; then
    validate_subsystem "$sub"
  fi

  state_file="$(get_state_file "$ws" "$sub")"

  if [ ! -d "$STATE_DIR" ]; then
    mkdir -p "$STATE_DIR"
  fi

  if [ -f "$state_file" ]; then
    echo "INFO: State file already exists: $state_file" >&2
    echo "      Use 'reset' to reinitialize." >&2
    exit 0
  fi

  print_initial_json "$ws" "$sub" > "$state_file"
  echo "OK: Created $state_file"
}

# ---------------------------------------------------------------------------
# cmd_read <workstream> [subsystem]
# ---------------------------------------------------------------------------
cmd_read() {
  ws="$1"
  sub="$2"
  if [ -z "$ws" ]; then
    echo "ERROR: read requires <workstream> argument" >&2
    exit 1
  fi

  if [ -n "$sub" ]; then
    validate_subsystem "$sub"
  fi

  state_file="$(get_state_file "$ws" "$sub")"

  if [ ! -f "$state_file" ]; then
    echo "ERROR: State file not found: $state_file" >&2
    echo "       Run 'gate-state.sh init $ws${sub:+ $sub}' first." >&2
    exit 2
  fi

  cat "$state_file"
}

# ---------------------------------------------------------------------------
# cmd_advance <workstream> <gate> [subsystem]
# Transitions the specified gate from pending → approved and cascades to
# the next gate (locked → pending). Also updates current_phase.
# ---------------------------------------------------------------------------
cmd_advance() {
  ws="$1"
  gate="$2"
  sub="$3"

  if [ -z "$ws" ] || [ -z "$gate" ]; then
    echo "ERROR: advance requires <workstream> and <gate> arguments" >&2
    exit 1
  fi

  case "$gate" in
    G1|G2|G3|G4) ;;
    *)
      echo "ERROR: Invalid gate '$gate'. Must be G1, G2, G3, or G4." >&2
      exit 1
      ;;
  esac

  if [ -n "$sub" ]; then
    validate_subsystem "$sub"
  fi

  state_file="$(get_state_file "$ws" "$sub")"

  if [ ! -f "$state_file" ]; then
    echo "ERROR: State file not found: $state_file" >&2
    echo "       Run 'gate-state.sh init $ws' first." >&2
    exit 2
  fi

  current_status="$(get_gate_status "$state_file" "$gate")"

  case "$current_status" in
    approved)
      echo "ERROR: $gate is already approved (terminal state)." >&2
      exit 2
      ;;
    locked)
      echo "ERROR: $gate is locked. The preceding gate must be approved first." >&2
      exit 2
      ;;
    pending) ;;
    *)
      echo "ERROR: Unknown gate status '${current_status}' for ${gate}. State file may be corrupt." >&2
      exit 2
      ;;
  esac

  today="$(today_date)"

  # Advance target gate: pending → approved + set approved_date
  set_gate_status "$state_file" "$gate" "approved"
  set_gate_approved_date "$state_file" "$gate" "$today"

  # Cascade: unlock next gate and update stage
  case "$gate" in
    G1)
      set_gate_status "$state_file" "G2" "pending"
      set_current_phase "$state_file" "sequence"
      bump_updated "$state_file"
      echo "OK: G1 approved → stage=sequence, G2 unlocked (pending)"
      ;;
    G2)
      set_gate_status "$state_file" "G3" "pending"
      set_current_phase "$state_file" "build"
      bump_updated "$state_file"
      echo "OK: G2 approved → stage=build, G3 unlocked (pending)"
      ;;
    G3)
      set_gate_status "$state_file" "G4" "pending"
      set_current_phase "$state_file" "validate"
      bump_updated "$state_file"
      echo "OK: G3 approved → stage=validate, G4 unlocked (pending)"
      ;;
    G4)
      set_current_phase "$state_file" "complete"
      bump_updated "$state_file"
      echo "OK: G4 approved → stage=complete (workflow finished)"
      ;;
  esac
}

# ---------------------------------------------------------------------------
# get_loop_field <file> <field>
# Extracts a numeric value from loop_state: "field": NUMBER
# ---------------------------------------------------------------------------
get_loop_field() {
  json_file="$1"
  field="$2"
  grep "\"${field}\":" "$json_file" | sed 's/.*"[^"]*": *\([0-9]*\).*/\1/'
}

# ---------------------------------------------------------------------------
# set_loop_field <file> <field> <new_value>
# Replaces a numeric value in loop_state: "field": OLD → "field": NEW
# ---------------------------------------------------------------------------
set_loop_field() {
  json_file="$1"
  field="$2"
  new_val="$3"
  sed "s/\"${field}\": *[0-9]*/\"${field}\": ${new_val}/" \
    "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"
}

# ---------------------------------------------------------------------------
# cmd_update_loop <workstream> <field> <value> [subsystem]
# Updates loop_state fields in the state file.
# Fields: iteration (add value), cost_tokens (add value), fail_count (add value)
# ---------------------------------------------------------------------------
cmd_update_loop() {
  ws="$1"
  field="$2"
  value="$3"
  sub="$4"

  if [ -z "$ws" ] || [ -z "$field" ] || [ -z "$value" ]; then
    echo "ERROR: update-loop requires <workstream> <field> <value>" >&2
    echo "       field must be one of: iteration, cost_tokens, fail_count" >&2
    exit 1
  fi

  case "$field" in
    iteration|cost_tokens|fail_count) ;;
    *)
      echo "ERROR: Unknown loop field '$field'. Must be: iteration, cost_tokens, fail_count" >&2
      exit 1
      ;;
  esac

  # Validate value is a non-negative integer
  case "$value" in
    ''|*[!0-9]*)
      echo "ERROR: value must be a non-negative integer, got: '$value'" >&2
      exit 1
      ;;
  esac

  if [ -n "$sub" ]; then
    validate_subsystem "$sub"
  fi

  state_file="$(get_state_file "$ws" "$sub")"

  if [ ! -f "$state_file" ]; then
    echo "ERROR: State file not found: $state_file" >&2
    echo "       Run 'gate-state.sh init $ws' first." >&2
    exit 2
  fi

  current="$(get_loop_field "$state_file" "$field")"
  if [ -z "$current" ]; then
    echo "ERROR: Could not read field '${field}' from $state_file" >&2
    exit 2
  fi

  new_val=$((current + value))
  set_loop_field "$state_file" "$field" "$new_val"
  bump_updated "$state_file"
  echo "OK: ${field} ${current} → ${new_val}"
}

# ---------------------------------------------------------------------------
# cmd_reset <workstream> [subsystem]
# ---------------------------------------------------------------------------
cmd_reset() {
  ws="$1"
  sub="$2"
  if [ -z "$ws" ]; then
    echo "ERROR: reset requires <workstream> argument" >&2
    exit 1
  fi

  if [ -n "$sub" ]; then
    validate_subsystem "$sub"
  fi

  state_file="$(get_state_file "$ws" "$sub")"

  if [ ! -f "$state_file" ]; then
    echo "ERROR: State file not found: $state_file" >&2
    echo "       Run 'gate-state.sh init $ws${sub:+ $sub}' first." >&2
    exit 2
  fi

  print_initial_json "$ws" "$sub" > "$state_file"
  echo "OK: Reset $state_file to initial state"
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
subcommand="$1"
shift

case "$subcommand" in
  init)
    cmd_init "$@"
    ;;
  read)
    cmd_read "$@"
    ;;
  advance)
    cmd_advance "$@"
    ;;
  reset)
    cmd_reset "$@"
    ;;
  set-subsystem)
    cmd_set_subsystem "$@"
    ;;
  update-loop)
    cmd_update_loop "$@"
    ;;
  ""|--help|-h)
    echo "Usage:"
    echo "  gate-state.sh init <workstream> [subsystem]                        # Create state file"
    echo "  gate-state.sh read <workstream> [subsystem]                        # Print state JSON"
    echo "  gate-state.sh advance <workstream> <gate> [subsystem]              # G1=approved → G2=pending, etc."
    echo "  gate-state.sh reset <workstream> [subsystem]                       # Reset all gates to initial"
    echo "  gate-state.sh set-subsystem <workstream> <subsystem>               # Set active subsystem (1-PD|2-DP|3-DA|4-IDM|null)"
    echo "  gate-state.sh update-loop <workstream> iteration <N> [subsystem]   # Add N to loop iteration"
    echo "  gate-state.sh update-loop <workstream> cost_tokens <N> [subsystem] # Add N to cost_tokens"
    echo "  gate-state.sh update-loop <workstream> fail_count <N> [subsystem]  # Add N to fail_count"
    echo ""
    echo "subsystem values (lowercase): pd|dp|da|idm|cross"
    echo "State files (DD-1): .claude/state/dsbv-<workstream>-<subsystem>.json"
    echo "Deprecated (WS-level): .claude/state/dsbv-<workstream>.json"
    exit 0
    ;;
  *)
    echo "ERROR: Unknown subcommand '$subcommand'" >&2
    echo "Run 'gate-state.sh --help' for usage." >&2
    exit 1
    ;;
esac
