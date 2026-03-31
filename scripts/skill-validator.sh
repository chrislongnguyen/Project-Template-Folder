#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-29
set -euo pipefail

# LTC Skill Validator — EOP Governance Checks
# Validates AI agent skill directories against 8 deterministic checks.
# Pure bash + grep + awk — no external dependencies.

# ── Color & Symbol ────────────────────────────────────────────────
CI_MODE=false
RED='\033[0;31m'
YLW='\033[0;33m'
GRN='\033[0;32m'
RST='\033[0m'
SYM_PASS="✓"
SYM_FAIL="✗"

disable_color() {
  RED="" YLW="" GRN="" RST=""
  SYM_PASS="PASS"
  SYM_FAIL="FAIL"
}

# ── Globals ───────────────────────────────────────────────────────
WARN_COUNT=0
HARD_FAIL=false
ALL_MODE=false
STAGED_MODE=false
SKILL_DIRS=()

# ── Usage ─────────────────────────────────────────────────────────
usage() {
  cat <<'USAGE'
Usage:
  skill-validator.sh <skill-dir>           Validate a single skill
  skill-validator.sh --all                 Validate all skills in repo
  skill-validator.sh --staged              Validate skills with staged changes
  skill-validator.sh --ci <skill-dir>      CI mode (no color, no emoji)
  skill-validator.sh --ci --all            CI mode + all skills
USAGE
  exit 2
}

# ── Argument parsing ──────────────────────────────────────────────
parse_args() {
  local positional=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --ci)     CI_MODE=true; disable_color; shift ;;
      --all)    ALL_MODE=true; shift ;;
      --staged) STAGED_MODE=true; shift ;;
      --help|-h) usage ;;
      -*) echo "Unknown flag: $1"; usage ;;
      *)  positional+=("$1"); shift ;;
    esac
  done

  if $ALL_MODE; then
    discover_all_skills
  elif $STAGED_MODE; then
    discover_staged_skills
  elif [[ ${#positional[@]} -eq 1 ]]; then
    SKILL_DIRS=("${positional[0]}")
  elif [[ ${#positional[@]} -eq 0 ]]; then
    echo "Error: provide a skill directory, --all, or --staged"
    usage
  else
    echo "Error: expected exactly one skill directory"
    usage
  fi
}

# ── Discovery helpers ─────────────────────────────────────────────
discover_all_skills() {
  local repo_root
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
  while IFS= read -r skillmd; do
    SKILL_DIRS+=("$(dirname "$skillmd")")
  done < <(find "$repo_root" -name SKILL.md \
    -not -path '*/.claude/worktrees/*' \
    -not -path '*/node_modules/*' \
    -not -path '*/test-fixtures/*' 2>/dev/null || true)

  if [[ ${#SKILL_DIRS[@]} -eq 0 ]]; then
    echo "No SKILL.md files found."
    exit 0
  fi
}

discover_staged_skills() {
  local seen_dirs=()
  while IFS= read -r staged_file; do
    local dir
    dir=$(dirname "$staged_file")
    # Walk up to find the directory containing SKILL.md
    while [[ "$dir" != "." && "$dir" != "/" ]]; do
      if [[ -f "$dir/SKILL.md" ]]; then
        # Deduplicate
        local already=false
        for s in "${seen_dirs[@]+"${seen_dirs[@]}"}"; do
          [[ "$s" == "$dir" ]] && already=true && break
        done
        if ! $already; then
          seen_dirs+=("$dir")
          SKILL_DIRS+=("$dir")
        fi
        break
      fi
      dir=$(dirname "$dir")
    done
  done < <(git diff --cached --name-only 2>/dev/null || true)

  if [[ ${#SKILL_DIRS[@]} -eq 0 ]]; then
    echo "No staged skill files found."
    exit 0
  fi
}

# ── Frontmatter extraction ───────────────────────────────────────
# Extracts YAML frontmatter lines (between first --- and second ---)
# Sets: FM_START, FM_END, FRONTMATTER (text), BODY_START, BODY_LINES (count)
extract_frontmatter() {
  local file="$1"
  FM_START=0
  FM_END=0
  FRONTMATTER=""
  BODY_START=0
  BODY_LINES=0

  local total_lines
  total_lines=$(wc -l < "$file" | tr -d ' ')

  local line_num=0
  local in_fm=false
  local fm_text=""

  while IFS= read -r line || [[ -n "$line" ]]; do
    line_num=$((line_num + 1))
    if [[ $line_num -eq 1 ]]; then
      if [[ "$line" == "---" ]]; then
        FM_START=1
        in_fm=true
        continue
      else
        # No frontmatter
        BODY_START=1
        BODY_LINES=$total_lines
        return
      fi
    fi
    if $in_fm; then
      if [[ "$line" == "---" ]]; then
        FM_END=$line_num
        in_fm=false
        BODY_START=$((line_num + 1))
        BODY_LINES=$((total_lines - line_num))
        break
      else
        fm_text+="$line"$'\n'
      fi
    fi
  done < "$file"

  FRONTMATTER="$fm_text"

  # Handle unclosed frontmatter
  if $in_fm; then
    FM_END=0
    FRONTMATTER=""
    BODY_START=1
    BODY_LINES=$total_lines
  fi
}

# Extract the description value from frontmatter (handles multi-line YAML)
extract_description() {
  local fm="$1"
  local desc=""
  local in_desc=false

  while IFS= read -r line; do
    if $in_desc; then
      # Continuation line: starts with space/tab
      if [[ "$line" =~ ^[[:space:]] ]]; then
        # Strip leading whitespace
        local trimmed
        trimmed=$(echo "$line" | sed 's/^[[:space:]]*//')
        desc+=" $trimmed"
      else
        # New key or empty line — description ended
        break
      fi
    else
      if [[ "$line" =~ ^description: ]]; then
        in_desc=true
        # Extract value after "description:"
        local val
        val="${line#description:}"
        # Trim leading space
        val="${val#"${val%%[![:space:]]*}"}"
        # Strip surrounding quotes if present
        val="${val%\"}"
        val="${val#\"}"
        val="${val%\'}"
        val="${val#\'}"
        desc="$val"
      fi
    fi
  done <<< "$fm"

  # Strip trailing quote if multi-line closed with one
  desc="${desc%\"}"
  desc="${desc%\'}"
  echo "$desc"
}

# ── Report helpers ────────────────────────────────────────────────
report_pass() {
  local check="$1" msg="$2"
  printf "  ${GRN}%s${RST} %-10s %s\n" "$SYM_PASS" "$check" "$msg"
}

report_warn() {
  local check="$1" msg="$2" eop="$3"
  WARN_COUNT=$((WARN_COUNT + 1))
  printf "  ${YLW}%s${RST} %-10s %s ${YLW}[WARN]${RST} → %s\n" "$SYM_FAIL" "$check" "$msg" "$eop"
}

report_hard_fail() {
  local check="$1" msg="$2" eop="$3"
  HARD_FAIL=true
  printf "  ${RED}%s${RST} %-10s %s ${RED}[HARD FAIL]${RST} → %s\n" "$SYM_FAIL" "$check" "$msg" "$eop"
}

# ── The 8 Checks ─────────────────────────────────────────────────

check_01() {
  local skill_dir="$1"
  if [[ ! -d "$skill_dir" ]]; then
    report_hard_fail "CHECK-01" "Not a directory: $skill_dir" "EOP-01"
    return
  fi
  if [[ ! -f "$skill_dir/SKILL.md" ]]; then
    report_hard_fail "CHECK-01" "SKILL.md not found in $skill_dir" "EOP-01"
    return
  fi
  report_pass "CHECK-01" "Skill is a directory with SKILL.md"
}

check_02() {
  local skill_dir="$1"
  $HARD_FAIL && return
  local file="$skill_dir/SKILL.md"

  extract_frontmatter "$file"

  if [[ $FM_START -eq 0 || $FM_END -eq 0 ]]; then
    report_hard_fail "CHECK-02" "No valid YAML frontmatter" "EOP-01"
    return
  fi

  if echo "$FRONTMATTER" | grep -q "^name:"; then
    report_pass "CHECK-02" "Frontmatter has 'name'"
  else
    report_hard_fail "CHECK-02" "Frontmatter missing 'name' field" "EOP-01"
  fi
}

check_03() {
  local skill_dir="$1"
  $HARD_FAIL && return
  local file="$skill_dir/SKILL.md"

  # Frontmatter already extracted in check_02
  local desc
  desc=$(extract_description "$FRONTMATTER")
  local desc_len=${#desc}

  if [[ $desc_len -ge 50 ]]; then
    report_pass "CHECK-03" "Description >= 50 chars ($desc_len chars)"
  else
    report_hard_fail "CHECK-03" "Description is $desc_len chars (need >= 50)" "EOP-04"
  fi
}

check_04() {
  local skill_dir="$1"
  $HARD_FAIL && return
  local file="$skill_dir/SKILL.md"

  local desc
  desc=$(extract_description "$FRONTMATTER")

  # Check for trigger-like phrases (case-insensitive)
  local trigger_pattern="[Uu]se [Ww]hen|[Uu]se [Tt]his|[Tt]rigger [Ww]hen|[Ii]nvoke [Ww]hen|[Uu]se [Ff]or"
  local matched_trigger=""
  matched_trigger=$(echo "$desc" | grep -oE "$trigger_pattern" | head -1) || true

  if [[ -n "$matched_trigger" ]]; then
    report_pass "CHECK-04" "Trigger language found: \"$matched_trigger\""
    return
  fi

  # Fallback: description >= 80 chars AND contains an action verb
  local desc_len=${#desc}
  if [[ $desc_len -ge 80 ]]; then
    local verb_pattern="create|build|run|execute|generate|analyze|review|validate|check|deploy|test|fix|debug|scaffold"
    local matched_verb=""
    matched_verb=$(echo "$desc" | grep -ioE "$verb_pattern" | head -1) || true
    if [[ -n "$matched_verb" ]]; then
      report_pass "CHECK-04" "Description >= 80 chars with action verb: \"$matched_verb\""
      return
    fi
  fi

  report_warn "CHECK-04" "No trigger language found" "EOP-04"
}

check_05() {
  local skill_dir="$1"
  $HARD_FAIL && return
  local file="$skill_dir/SKILL.md"

  # Check for ## Gotchas heading (case-insensitive)
  if grep -iq "^## *gotchas" "$file"; then
    report_pass "CHECK-05" "Gotchas section found in SKILL.md"
    return
  fi

  # Check for gotchas.md file
  if [[ -f "$skill_dir/gotchas.md" ]]; then
    report_pass "CHECK-05" "gotchas.md file found"
    return
  fi

  report_warn "CHECK-05" "No gotchas section found" "EOP-03"
}

check_06() {
  local skill_dir="$1"
  $HARD_FAIL && return

  # Waiver: body <= 40 lines
  if [[ $BODY_LINES -le 40 ]]; then
    report_pass "CHECK-06" "Waived (body is $BODY_LINES lines, <= 40)"
    return
  fi

  if [[ -d "$skill_dir/references" || -d "$skill_dir/templates" ]]; then
    local found=""
    [[ -d "$skill_dir/references" ]] && found="references/"
    [[ -d "$skill_dir/templates" ]] && found="${found:+$found, }templates/"
    report_pass "CHECK-06" "$found directory exists"
    return
  fi

  report_warn "CHECK-06" "No references/ or templates/ directory" "EOP-02"
}

check_07() {
  local skill_dir="$1"
  $HARD_FAIL && return
  local file="$skill_dir/SKILL.md"

  # Waiver: body <= 40 lines
  if [[ $BODY_LINES -le 40 ]]; then
    report_pass "CHECK-07" "Waived (body is $BODY_LINES lines, <= 40)"
    return
  fi

  # Extract body (after frontmatter)
  local body=""
  if [[ $BODY_START -gt 0 ]]; then
    body=$(tail -n +"$BODY_START" "$file")
  else
    body=$(cat "$file")
  fi

  # Search for gate language
  local gate_pattern="GATE|HARD-GATE|Do NOT proceed|must pass before|Wait for.*approval|verify.*before|check.*before proceeding"
  local matched=""
  matched=$(echo "$body" | grep -oE "$gate_pattern" | head -1) || true

  if [[ -n "$matched" ]]; then
    report_pass "CHECK-07" "Gate language found: \"$matched\""
  else
    report_warn "CHECK-07" "No validation gate language found" "EOP-06"
  fi
}

check_08() {
  local skill_dir="$1"
  $HARD_FAIL && return

  if [[ $BODY_LINES -gt 200 ]]; then
    report_warn "CHECK-08" "SKILL.md is $BODY_LINES lines (limit: 200) — consider extracting detail to references/" "EOP-05"
  else
    report_pass "CHECK-08" "Context budget OK ($BODY_LINES body lines, limit: 200)"
  fi
}

# ── Validate a single skill ──────────────────────────────────────
validate_skill() {
  local skill_dir="$1"
  # Normalize: strip trailing slash
  skill_dir="${skill_dir%/}"

  WARN_COUNT=0
  HARD_FAIL=false

  echo "skill-validator: $skill_dir/"

  check_01 "$skill_dir"
  check_02 "$skill_dir"
  check_03 "$skill_dir"
  check_04 "$skill_dir"
  check_05 "$skill_dir"
  check_06 "$skill_dir"
  check_07 "$skill_dir"
  check_08 "$skill_dir"

  echo ""

  if $HARD_FAIL; then
    printf "  Result: ${RED}HARD FAIL${RST} — fix blocking issues above\n"
    return 1
  elif [[ $WARN_COUNT -ge 3 ]]; then
    printf "  Result: ${RED}FAIL${RST} with %d warnings (threshold: 3)\n" "$WARN_COUNT"
    return 1
  elif [[ $WARN_COUNT -gt 0 ]]; then
    printf "  Result: ${GRN}PASS${RST} with %d warning(s) (threshold: 3)\n" "$WARN_COUNT"
    return 0
  else
    printf "  Result: ${GRN}PASS${RST} — all checks clean\n"
    return 0
  fi
}

# ── Main ──────────────────────────────────────────────────────────
main() {
  parse_args "$@"

  local total=0
  local passed=0
  local failed=0

  for skill_dir in "${SKILL_DIRS[@]}"; do
    total=$((total + 1))
    if validate_skill "$skill_dir"; then
      passed=$((passed + 1))
    else
      failed=$((failed + 1))
    fi
    echo ""
  done

  # Summary for multi-skill runs
  if [[ $total -gt 1 ]]; then
    echo "────────────────────────────────────────"
    printf "Summary: %d skill(s) checked — ${GRN}%d passed${RST}, ${RED}%d failed${RST}\n" "$total" "$passed" "$failed"
  fi

  if [[ $failed -gt 0 ]]; then
    exit 1
  fi
  exit 0
}

main "$@"
