#!/usr/bin/env bash
# version: 1.1 | status: draft | last_updated: 2026-04-09
#
# readiness-report.sh — Check iteration advancement readiness per subsystem
# Criteria: Criterion 1 (C1) = all workstreams have ≥1 validated artifact
#           Criterion 2 (C2) = IMPROVE retro-*.md validated
#           Criterion 3 (C3) = upstream subsystem iteration ≥ current
#
# Usage:
#   ./scripts/readiness-report.sh               # check all 4 subsystems
#   ./scripts/readiness-report.sh --subsystem PD # check one subsystem

set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

# ─── Config (bash 3 compatible — no associative arrays) ──────────────────────

# Subsystem codes in chain order
ALL_SUBSYS=(PD DP DA IDM)

# Map code → folder name
subsys_dir() {
  case "$1" in
    PD)  echo "1-PD"  ;;
    DP)  echo "2-DP"  ;;
    DA)  echo "3-DA"  ;;
    IDM) echo "4-IDM" ;;
    *)   echo ""      ;;
  esac
}

# Map code → upstream code (empty = no upstream)
subsys_upstream() {
  case "$1" in
    PD)  echo ""    ;;
    DP)  echo "PD"  ;;
    DA)  echo "DP"  ;;
    IDM) echo "DA"  ;;
    *)   echo ""    ;;
  esac
}

WORKSTREAM_DIRS=(1-ALIGN 2-LEARN 3-PLAN 4-EXECUTE 5-IMPROVE)

# ─── Argument parsing ─────────────────────────────────────────────────────────

FILTER=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --subsystem)
      FILTER="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 [--subsystem PD|DP|DA|IDM]" >&2
      exit 1
      ;;
  esac
done

if [[ -n "$FILTER" ]]; then
  if [[ -z "$(subsys_dir "$FILTER")" ]]; then
    echo "Unknown subsystem: $FILTER. Valid: PD DP DA IDM" >&2
    exit 1
  fi
  ALL_SUBSYS=("$FILTER")
fi

# ─── Helpers ─────────────────────────────────────────────────────────────────

# Read a frontmatter field from a file; print default if missing
get_frontmatter_field() {
  local file="$1" field="$2" default="${3:-}"
  local val
  val=$(grep -m1 "^${field}:" "$file" 2>/dev/null | sed 's/^[^:]*:[[:space:]]*//' | tr -d '"') || true
  echo "${val:-$default}"
}

# Return highest MAJOR version number found in .md files under a directory
max_iteration_in_dir() {
  local dir="$1"
  local max=0
  while IFS= read -r f; do
    local ver major
    ver=$(get_frontmatter_field "$f" "version" "1.0")
    major="${ver%%.*}"
    if [[ "$major" =~ ^[0-9]+$ ]] && (( major > max )); then
      max=$major
    fi
  done < <(find "$dir" -name "*.md" 2>/dev/null)
  echo "$max"
}

# Return current iteration (highest MAJOR) for a subsystem across all workstreams
subsystem_iteration() {
  local code="$1"
  local folder
  folder=$(subsys_dir "$code")
  local max=1
  for ws in "${WORKSTREAM_DIRS[@]}"; do
    local dir="${REPO_ROOT}/${ws}/${folder}"
    [[ -d "$dir" ]] || continue
    local m
    m=$(max_iteration_in_dir "$dir")
    (( m > max )) && max=$m
  done
  echo "$max"
}

# Criterion 1 (C1): All 5 workstreams have ≥1 file with status: validated in subsystem dir
check_c1() {
  local code="$1"
  local folder
  folder=$(subsys_dir "$code")
  local missing=""

  for ws in "${WORKSTREAM_DIRS[@]}"; do
    local dir="${REPO_ROOT}/${ws}/${folder}"
    if [[ ! -d "$dir" ]]; then
      missing="${missing}${ws} "
      continue
    fi
    if ! grep -rl "^status: validated" "$dir" --include="*.md" -q 2>/dev/null; then
      missing="${missing}${ws} "
    fi
  done

  if [[ -z "$missing" ]]; then
    echo "pass"
  else
    echo "fail:missing validated in: ${missing% }"
  fi
}

# Criterion 2 (C2): 5-IMPROVE/{folder}/retro-*.md exists with status: validated
check_c2() {
  local code="$1"
  local folder
  folder=$(subsys_dir "$code")
  local improve_dir="${REPO_ROOT}/5-IMPROVE/${folder}"

  if [[ ! -d "$improve_dir" ]]; then
    echo "fail:no 5-IMPROVE/${folder} dir"
    return
  fi

  local found=0
  while IFS= read -r f; do
    local fname
    fname="$(basename "$f")"
    if [[ "$fname" == retro-*.md ]]; then
      if grep -q "^status: validated" "$f" 2>/dev/null; then
        found=1
        break
      fi
    fi
  done < <(find "$improve_dir" -name "retro-*.md" 2>/dev/null)

  if [[ $found -eq 1 ]]; then
    echo "pass"
  else
    echo "fail:no validated retro-*.md in 5-IMPROVE/${folder}"
  fi
}

# Criterion 3 (C3): upstream subsystem iteration >= current subsystem iteration
check_c3() {
  local code="$1"
  local upstream
  upstream=$(subsys_upstream "$code")

  if [[ -z "$upstream" ]]; then
    echo "pass:none"
    return
  fi

  local current_iter upstream_iter
  current_iter=$(subsystem_iteration "$code")
  upstream_iter=$(subsystem_iteration "$upstream")

  if (( upstream_iter >= current_iter )); then
    echo "pass:${upstream}=I${upstream_iter}"
  else
    echo "fail:${upstream}=I${upstream_iter}<I${current_iter}"
  fi
}

# ─── Report ───────────────────────────────────────────────────────────────────

TODAY=$(date +%Y-%m-%d)
echo "Iteration Readiness Report (${TODAY})"
# Legend: C1 = Criterion 1 (all workstreams validated) | C2 = Criterion 2 (IMPROVE retro validated) | C3 = Criterion 3 (upstream ≥ current)
echo ""
printf "| %-9s | %-9s | %-10s | %-10s | %-18s | %s\n" \
  "Subsystem" "Iteration" "C1 ALPEI" "C2 Retro" "C3 Upstream" "Status"
printf "|%-11s|%-11s|%-12s|%-12s|%-20s|%s\n" \
  "-----------" "-----------" "------------" "------------" "--------------------" "--------"

for ss in "${ALL_SUBSYS[@]}"; do
  iter=$(subsystem_iteration "$ss")

  c1_raw=$(check_c1 "$ss")
  c2_raw=$(check_c2 "$ss")
  c3_raw=$(check_c3 "$ss")

  # C1
  if [[ "$c1_raw" == "pass" ]]; then c1_sym="✓"; c1_reason=""; else
    c1_sym="✗"; c1_reason="${c1_raw#fail:}"; fi

  # C2
  if [[ "$c2_raw" == "pass" ]]; then c2_sym="✓"; c2_reason=""; else
    c2_sym="✗"; c2_reason="${c2_raw#fail:}"; fi

  # C3
  c3_detail="${c3_raw#*:}"
  if [[ "$c3_raw" == pass* ]]; then
    c3_sym="✓"; c3_display="✓ (${c3_detail})"; c3_reason=""
  else
    c3_sym="✗"; c3_display="✗ (${c3_detail})"; c3_reason="upstream ${c3_detail}"
  fi

  # Overall
  if [[ "$c1_sym" == "✓" && "$c2_sym" == "✓" && "$c3_sym" == "✓" ]]; then
    status_col="READY"
  else
    blockers=""
    [[ -n "$c1_reason" ]] && blockers="${blockers}C1: ${c1_reason}; "
    [[ -n "$c2_reason" ]] && blockers="${blockers}C2: ${c2_reason}; "
    [[ -n "$c3_reason" ]] && blockers="${blockers}C3: ${c3_reason}"
    blockers="${blockers%%; }"
    status_col="NOT READY — ${blockers}"
  fi

  printf "| %-9s | I%-8s | %-10s | %-10s | %-18s | %s\n" \
    "$ss" "$iter" "$c1_sym" "$c2_sym" "$c3_display" "$status_col"
done

echo ""
