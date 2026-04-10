#!/usr/bin/env bash
# version: 1.1 | status: draft | last_updated: 2026-04-11
#
# generate-registry.sh — Rebuild _genesis/version-registry.md table from frontmatter source truth.
#
# Usage:
#   ./scripts/generate-registry.sh          # overwrite registry in place
#   ./scripts/generate-registry.sh --dry-run # print generated table to stdout, do not write
#
# Run `chmod +x scripts/generate-registry.sh` once after cloning.
#
# Idempotent: running twice produces identical output given unchanged frontmatter.

set -euo pipefail

# ── Repo root ────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR/..")"
REGISTRY="$REPO_ROOT/_genesis/version-registry.md"
TODAY="$(date +%Y-%m-%d)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

# ── Helpers ──────────────────────────────────────────────────────────────────

# Extract a frontmatter field value from a file.
# Returns "—" if file does not exist or field is absent.
get_field() {
  local file="$1" field="$2"
  if [[ ! -f "$file" ]]; then
    echo "—"
    return
  fi
  # Match YAML front-matter block (between first pair of --- delimiters)
  local val
  val=$(awk '
    BEGIN { in_fm=0; found=0 }
    /^---/ {
      if (in_fm == 0) { in_fm=1; next }
      else { exit }
    }
    in_fm && /^'"$field"':/ {
      sub(/^'"$field"':[[:space:]]*/, "")
      gsub(/"/, "")   # strip surrounding quotes
      print; found=1; exit
    }
  ' "$file")
  echo "${val:-—}"
}

# Count non-README, non-DSBV .md files in a directory tree (build artifacts).
count_build_artifacts() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then echo 0; return; fi
  find "$dir" -maxdepth 1 -name "*.md" \
    ! -name "DESIGN.md" ! -name "SEQUENCE.md" ! -name "VALIDATE.md" \
    ! -name "README.md" | wc -l | tr -d ' '
}

# Derive a composite version/status for a Build cell from all build artifact files.
# version  = highest version present (or "—" if none)
# status   = most "advanced" status present (draft < in-progress < in-review < validated < archived)
build_cell_summary() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then echo "— | — | 0"; return; fi

  local files
  files=$(find "$dir" -maxdepth 1 -name "*.md" \
    ! -name "DESIGN.md" ! -name "SEQUENCE.md" ! -name "VALIDATE.md" \
    ! -name "README.md")

  if [[ -z "$files" ]]; then echo "— | Not Started | 0"; return; fi

  local count=0 best_status="draft" best_ver="—" latest_date="—"
  # Status rank: higher number = more advanced
  status_rank() {
    case "$1" in
      "not started"|"not-started") echo 0 ;;
      "pending")     echo 1 ;;
      "draft")       echo 2 ;;
      "in-progress") echo 3 ;;
      "in-review")   echo 4 ;;
      "validated")   echo 5 ;;
      "archived")    echo 6 ;;
      *)             echo 0 ;;
    esac
  }
  local best_rank=0

  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    count=$((count + 1))
    local ver stat lud
    ver=$(get_field "$f" "version")
    stat=$(get_field "$f" "status")
    lud=$(get_field "$f" "last_updated")

    # Track highest version (lexicographic — good enough for MAJOR.MINOR)
    if [[ "$ver" != "—" ]]; then
      if [[ "$best_ver" == "—" ]] || [[ "$ver" > "$best_ver" ]]; then
        best_ver="$ver"
      fi
    fi
    # Track latest date
    if [[ "$lud" != "—" ]]; then
      if [[ "$latest_date" == "—" ]] || [[ "$lud" > "$latest_date" ]]; then
        latest_date="$lud"
      fi
    fi
    # Track most advanced status
    local rank
    rank=$(status_rank "$(echo "$stat" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')")
    if (( rank > best_rank )); then
      best_rank=$rank
      best_status="$stat"
    fi
  done <<< "$files"

  echo "${best_ver} | ${best_status} | ${count} | ${latest_date}"
}

# Pad a string to a fixed width with trailing spaces.
pad() { printf "%-${2}s" "$1"; }

# ── Status rank helper (Bash 3 compatible — no nested functions) ──────────────

status_rank() {
  case "$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')" in
    "not started"|"not-started") echo 0 ;;
    "pending")     echo 1 ;;
    "draft")       echo 2 ;;
    "in-progress") echo 3 ;;
    "in-review")   echo 4 ;;
    "validated")   echo 5 ;;
    "archived")    echo 6 ;;
    *)             echo 0 ;;
  esac
}

# ── Table builder ─────────────────────────────────────────────────────────────

build_table() {
  # DSBV workstreams (exclude 2-LEARN — it uses a pipeline, not DSBV)
  local dsbv_ws
  dsbv_ws="1-ALIGN 3-PLAN 4-EXECUTE 5-IMPROVE"

  # Column widths — widened for {WS}×{SUB}×{Stage} row key
  local w1=32 w2=38 w3=9 w4=13 w5=9 w6=14 w7=10

  # Header
  printf "| %-${w1}s | %-${w2}s | %-${w3}s | %-${w4}s | %-${w5}s | %-${w6}s | %-${w7}s |\n" \
    "Workstream×Sub×Stage" "Deliverable" "Version" "Status" "AC Pass" "Last Updated" "Map Cell"
  printf "|-%s-|-%s-|-%s-|-%s-|-%s-|-%s-|-%s-|\n" \
    "$(printf '%0.s-' $(seq 1 $w1))" \
    "$(printf '%0.s-' $(seq 1 $w2))" \
    "$(printf '%0.s-' $(seq 1 $w3))" \
    "$(printf '%0.s-' $(seq 1 $w4))" \
    "$(printf '%0.s-' $(seq 1 $w5))" \
    "$(printf '%0.s-' $(seq 1 $w6))" \
    "$(printf '%0.s-' $(seq 1 $w7))"

  # ── DSBV workstreams — subsystem-granular rows ──────────────────────────────
  for ws in $dsbv_ws; do
    local ws_dir="$REPO_ROOT/$ws"
    [[ ! -d "$ws_dir" ]] && continue

    # Collect numbered subsystem dirs matching {N}-{NAME} pattern (1-PD, 2-DP, 3-DA, 4-IDM)
    # Exclude _cross (handled separately) and any non-subsystem dirs (charter, decisions, etc.)
    local subdirs
    subdirs=$(find "$ws_dir" -mindepth 1 -maxdepth 1 -type d \
      ! -name "_cross" ! -name ".*" | grep -E '/[0-9]+-[A-Z]+$' | sort)

    # Build list of dirs to iterate: numbered subdirs first, then _cross if eligible
    local all_subdirs="$subdirs"

    # DD-4: _cross rows only when _cross/DESIGN.md exists
    local cross_dir="$ws_dir/_cross"
    if [[ -d "$cross_dir" ]] && [[ -f "$cross_dir/DESIGN.md" ]]; then
      all_subdirs="$subdirs
$cross_dir"
    fi

    # If no subdirs exist at all, emit a single workstream-level row per stage
    if [[ -z "$all_subdirs" ]]; then
      for stage in "Design" "Sequence" "Build" "Validate"; do
        local phase_file deliverable
        case "$stage" in
          Design)   phase_file="DESIGN.md"   ; deliverable="DESIGN.md" ;;
          Sequence) phase_file="SEQUENCE.md" ; deliverable="SEQUENCE.md" ;;
          Validate) phase_file="VALIDATE.md" ; deliverable="VALIDATE.md" ;;
          Build)    phase_file=""            ; deliverable="build artifacts" ;;
        esac
        local ver status lud
        if [[ "$stage" == "Build" ]]; then
          local summary
          summary=$(build_cell_summary "$ws_dir")
          IFS='|' read -r ver status bc lud <<< "$summary"
          ver="$(echo "$ver" | xargs)"; status="$(echo "$status" | xargs)"
          bc="$(echo "$bc" | xargs)"; lud="$(echo "$lud" | xargs)"
          deliverable="build artifacts (${bc} files)"
        else
          local f="$ws_dir/$phase_file"
          ver=$(get_field "$f" "version")
          status=$(get_field "$f" "status")
          lud=$(get_field "$f" "last_updated")
          [[ "$ver" == "—" ]] && status="Not Started"
        fi
        printf "| %-${w1}s | %-${w2}s | %-${w3}s | %-${w4}s | %-${w5}s | %-${w6}s | %-${w7}s |\n" \
          "${ws}×(root)×${stage}" "$deliverable" "$ver" "$status" "—" "$lud" "TBD"
      done
      continue
    fi

    # Per-subsystem rows
    while IFS= read -r sub_dir; do
      [[ -z "$sub_dir" ]] && continue
      local sub_name
      sub_name="$(basename "$sub_dir")"

      for stage in "Design" "Sequence" "Build" "Validate"; do
        local phase_file deliverable
        case "$stage" in
          Design)   phase_file="DESIGN.md"   ; deliverable="DESIGN.md" ;;
          Sequence) phase_file="SEQUENCE.md" ; deliverable="SEQUENCE.md" ;;
          Validate) phase_file="VALIDATE.md" ; deliverable="VALIDATE.md" ;;
          Build)    phase_file=""            ; deliverable="build artifacts" ;;
        esac

        local row_ver row_status row_lud
        if [[ "$stage" == "Build" ]]; then
          local summary
          summary=$(build_cell_summary "$sub_dir")
          IFS='|' read -r row_ver row_status bc row_lud <<< "$summary"
          row_ver="$(echo "$row_ver" | xargs)"; row_status="$(echo "$row_status" | xargs)"
          bc="$(echo "$bc" | xargs)"; row_lud="$(echo "$row_lud" | xargs)"
          deliverable="build artifacts (${bc} files)"
        else
          local f="$sub_dir/$phase_file"
          row_ver=$(get_field "$f" "version")
          row_status=$(get_field "$f" "status")
          row_lud=$(get_field "$f" "last_updated")
          # File absent → Not Started
          [[ "$row_ver" == "—" ]] && row_status="Not Started"
        fi

        local row_key="${ws}×${sub_name}×${stage}"
        printf "| %-${w1}s | %-${w2}s | %-${w3}s | %-${w4}s | %-${w5}s | %-${w6}s | %-${w7}s |\n" \
          "$row_key" "$deliverable" "$row_ver" "$row_status" "—" "$row_lud" "TBD"
      done
    done <<< "$all_subdirs"
  done

  # ── 2-LEARN pipeline row ────────────────────────────────────────────────────
  local learn_dir="$REPO_ROOT/2-LEARN"
  local learn_count=0 learn_status="Not Started" learn_date="—"
  if [[ -d "$learn_dir" ]]; then
    learn_count=$(find "$learn_dir" -name "*.md" ! -name "README.md" | wc -l | tr -d ' ')
    learn_date=$(find "$learn_dir" -name "*.md" ! -name "README.md" -newer /dev/null \
      -exec stat -f "%Sm %N" -t "%Y-%m-%d" {} \; 2>/dev/null \
      | sort -r | head -1 | awk '{print $1}' || echo "—")
    [[ -z "$learn_date" ]] && learn_date="—"
    [[ "$learn_count" -gt 0 ]] && learn_status="in-progress"
  fi
  printf "| %-${w1}s | %-${w2}s | %-${w3}s | %-${w4}s | %-${w5}s | %-${w6}s | %-${w7}s |\n" \
    "2-LEARN×Pipeline" \
    "input/, research/, specs/, output/" \
    "1.x" \
    "$learn_status" \
    "—" \
    "$learn_date" \
    "TBD"
  echo "| _\(LEARN uses learning pipeline, not DSBV — no Design/Sequence/Validate rows\)_ | | | | | | |"

  # ── Summary rows ───────────────────────────────────────────────────────────
  echo ""
  echo "### Summary Rows (no DSBV expansion)"
  echo ""
  printf "| %-20s | %-50s | %-9s | %-12s | %-14s |\n" \
    "Workstream" "Description" "Version" "Status" "Last Updated"
  printf "|-%s-|-%s-|-%s-|-%s-|-%s-|\n" \
    "$(printf '%0.s-' $(seq 1 20))" \
    "$(printf '%0.s-' $(seq 1 50))" \
    "$(printf '%0.s-' $(seq 1 9))" \
    "$(printf '%0.s-' $(seq 1 12))" \
    "$(printf '%0.s-' $(seq 1 14))"
  printf "| %-20s | %-50s | %-9s | %-12s | %-14s |\n" \
    "GOVERN" \
    "Operational infra — CLAUDE.md, .claude/rules/, agents/, hooks/" \
    "1.x" \
    "Active" \
    "$TODAY"

  # _genesis: latest version among .md files in _genesis/
  local gen_ver="—" gen_date="—"
  if [[ -d "$REPO_ROOT/_genesis" ]]; then
    while IFS= read -r f; do
      local v d
      v=$(get_field "$f" "version")
      d=$(get_field "$f" "last_updated")
      if [[ "$v" != "—" ]]; then
        if [[ "$gen_ver" == "—" ]] || [[ "$v" > "$gen_ver" ]]; then gen_ver="$v"; fi
      fi
      if [[ "$d" != "—" ]]; then
        if [[ "$gen_date" == "—" ]] || [[ "$d" > "$gen_date" ]]; then gen_date="$d"; fi
      fi
    done < <(find "$REPO_ROOT/_genesis" -maxdepth 2 -name "*.md")
  fi
  printf "| %-20s | %-50s | %-9s | %-12s | %-14s |\n" \
    "_genesis" \
    "Reference layer — BLUEPRINT.md, brand, frameworks, SOPs, templates" \
    "$gen_ver" \
    "draft" \
    "$gen_date"
}

# ── Registry rewrite ──────────────────────────────────────────────────────────

rewrite_registry() {
  local table
  table=$(build_table)

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "## Workstream×Stage Progress Matrix"
    echo ""
    echo "$table"
    return
  fi

  [[ ! -f "$REGISTRY" ]] && { echo "ERROR: registry not found at $REGISTRY" >&2; exit 1; }

  # Read current frontmatter version to bump it
  local cur_ver
  cur_ver=$(get_field "$REGISTRY" "version")
  local new_ver
  if [[ "$cur_ver" =~ ^([0-9]+)\.([0-9]+)$ ]]; then
    local major="${BASH_REMATCH[1]}" minor="${BASH_REMATCH[2]}"
    new_ver="${major}.$((minor + 1))"
  else
    new_ver="$cur_ver"
  fi

  # Build new file content:
  # 1. Updated frontmatter
  # 2. Everything from "# VERSION REGISTRY" line up to (but not including) "## Workstream×Stage"
  # 3. Injected table
  # 4. Everything after the old table (from "### Summary" onward — but we now generate summaries
  #    inside build_table, so skip old summary block and keep the tail after it)

  # Sections to preserve (after the generated table+summary rows):
  # "### Recently Modified Files" section through end of file, OR
  # the status key note and everything below "---" after the matrix.

  # Strategy: split file into 3 parts:
  #   PART_A = frontmatter block (regenerated)
  #   PART_B = everything from "# VERSION REGISTRY" to the line before "## Workstream×Stage"
  #   PART_C = everything from the first "---" separator AFTER the matrix to end of file
  #            (i.e., "## Sub-System Version Progression" onward)

  local tmpfile
  tmpfile=$(mktemp)

  # Extract PART_B: from "# VERSION REGISTRY" to line before "## Workstream×Stage"
  local part_b
  part_b=$(awk '
    /^# VERSION REGISTRY/ { in_b=1 }
    in_b && /^## Workstream.Stage/ { exit }
    in_b { print }
  ' "$REGISTRY")

  # Extract PART_C: from "## Sub-System Version Progression" to end
  local part_c
  part_c=$(awk '
    /^## Sub-System Version Progression/ { found=1 }
    found { print }
  ' "$REGISTRY")

  {
    # Frontmatter
    printf -- "---\n"
    printf "version: \"%s\"\n" "$new_ver"
    printf "status: draft\n"
    printf "last_updated: %s\n" "$TODAY"
    printf "purpose: \"Workstream×stage progress dashboard — auto-generated by generate-registry.sh\"\n"
    printf -- "---\n"
    echo ""
    # PART_B (header + preamble)
    echo "$part_b"
    # Table section header
    echo "## Workstream×Stage Progress Matrix"
    echo ""
    echo "$table"
    echo ""
    printf "> **Status key:** Not Started | Pending | draft | in-progress | in-review | validated | archived\n"
    printf "> **Not Started** = this cell's primary artifact does not exist yet. **Pending** = upstream workstream not yet validated.\n"
    printf "> **Map Cell** = TBD until Consumer 1 ships.\n"
    echo ""
    echo "---"
    echo ""
    # PART_C
    echo "$part_c"
  } > "$tmpfile"

  mv "$tmpfile" "$REGISTRY"
  echo "generate-registry.sh: registry updated → $REGISTRY (version: $new_ver, date: $TODAY)"
}

rewrite_registry
