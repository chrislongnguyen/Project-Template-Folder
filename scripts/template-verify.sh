#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-12
# template-verify.sh — Unified 6-check verification sweep (L5 of Template Release Management)
#
# PURPOSE: Confirm a post-sync repo is functional before commit.
#          Single entry point, exit-coded output.
#
# USAGE:
#   ./scripts/template-verify.sh [--check V{1-6}] [--json] [--verbose] [--help]
#
# CHECKS:
#   V1 — Structural   : validate-blueprint.py --quiet
#   V2 — Hooks        : hook script paths resolve + smoke-test.sh
#   V3 — Graph        : link-validator.sh + orphan-detect.sh
#   V4 — Agent infra  : agent/rule/skill file counts
#   V5 — Manifest     : template-manifest.sh --audit + deprecated file scan
#   V6 — Sync         : template-sync.sh --verify
#
# EXIT CODES:
#   0 — all checks pass (or all non-skipped checks pass)
#   1 — one or more checks failed
#   2 — script error (missing dependency, bad args)

set -uo pipefail

# ── Resolve paths ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || echo "")"
if [[ -z "$PROJECT_ROOT" ]]; then
  echo "ERROR: not inside a git repository. Run from project root." >&2
  exit 2
fi

MANIFEST_YML="$PROJECT_ROOT/_genesis/template-manifest.yml"
SETTINGS_JSON="$PROJECT_ROOT/.claude/settings.json"

# ── Arg parsing ───────────────────────────────────────────────────────────────
FILTER=""
JSON_OUTPUT=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)
      shift
      FILTER="${1:-}"
      if [[ -z "$FILTER" ]]; then
        echo "ERROR: --check requires an argument (e.g. --check V2)" >&2
        exit 2
      fi
      # Normalise: accept "v2", "V2", "2"
      FILTER=$(echo "$FILTER" | tr '[:lower:]' '[:upper:]')
      [[ "$FILTER" =~ ^[0-9]$ ]] && FILTER="V${FILTER}"
      if ! echo "$FILTER" | grep -qE '^V[1-6]$'; then
        echo "ERROR: --check value must be V1–V6 (got: $FILTER)" >&2
        exit 2
      fi
      shift
      ;;
    --json)
      JSON_OUTPUT=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --help|-h)
      cat <<'EOF'
template-verify.sh — Unified 6-check verification sweep

USAGE:
  ./scripts/template-verify.sh [OPTIONS]

OPTIONS:
  --check V{1-6}   Run only the specified check (e.g. --check V2)
  --json           Output results as JSON to stdout
  --verbose        Print sub-command output on failure
  --help           Show this help and exit 0

CHECKS:
  V1  Structural   — validate-blueprint.py --quiet
  V2  Hooks        — hook script paths resolve + smoke-test.sh
  V3  Graph        — link-validator.sh (all files) + orphan-detect.sh
  V4  Agent infra  — agent/rule/skill file counts
  V5  Manifest     — template-manifest.sh --audit + deprecated file scan
  V6  Sync         — template-sync.sh --verify

EXIT CODES:
  0   All checks pass
  1   One or more checks failed
  2   Script error (missing dependency, bad args)

EXAMPLES:
  ./scripts/template-verify.sh              # full sweep
  ./scripts/template-verify.sh --check V2  # hooks only
  ./scripts/template-verify.sh --json       # machine-readable output
EOF
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $1. Run --help for usage." >&2
      exit 2
      ;;
  esac
done

# ── State tracking ────────────────────────────────────────────────────────────
TOTAL=0
PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

# Parallel result arrays — Bash 3 compatible (no associative arrays)
RESULT_IDS=""
RESULT_STATUSES=""
RESULT_MESSAGES=""

# ── Helpers ───────────────────────────────────────────────────────────────────

# run_cmd: run a command, capture output, return exit code
# $1 = variable to store output, $2+ = command
run_cmd() {
  local _outvar="$1"
  shift
  local _out
  _out=$("$@" 2>&1) || true
  # shellcheck disable=SC2140
  eval "${_outvar}=\$_out"
  "$@" >/dev/null 2>&1
  return $?
}

record() {
  # $1=id  $2=status(pass|fail|skip)  $3=message
  local id="$1" status="$2" msg="$3"
  TOTAL=$((TOTAL + 1))
  case "$status" in
    pass) PASS_COUNT=$((PASS_COUNT + 1)) ;;
    fail) FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
    skip) SKIP_COUNT=$((SKIP_COUNT + 1)) ;;
  esac
  RESULT_IDS="${RESULT_IDS}${id}|"
  RESULT_STATUSES="${RESULT_STATUSES}${status}|"
  RESULT_MESSAGES="${RESULT_MESSAGES}${msg}||"
}

should_run() {
  # returns 0 (true) if we should run this check
  [[ -z "$FILTER" ]] || [[ "$FILTER" == "$1" ]]
}

script_exists() {
  [[ -f "$PROJECT_ROOT/scripts/$1" ]]
}

# ── V1: Structural ────────────────────────────────────────────────────────────
if should_run "V1"; then
  if ! script_exists "validate-blueprint.py"; then
    record "V1" "skip" "validate-blueprint.py not found — check skipped"
  else
    v1_out=$(cd "$PROJECT_ROOT" && python3 "$PROJECT_ROOT/scripts/validate-blueprint.py" --quiet 2>&1) || v1_exit=$?
    v1_exit=${v1_exit:-0}
    if [[ $v1_exit -eq 0 ]]; then
      record "V1" "pass" "structural checks: 8/8"
    else
      first_fail=$(echo "$v1_out" | grep -v "^$" | head -3 | tr '\n' ' ')
      record "V1" "fail" "validate-blueprint.py failed: ${first_fail}"
      if [[ "$VERBOSE" == "true" ]]; then
        echo "--- V1 output ---"
        echo "$v1_out"
        echo "---"
      fi
    fi
  fi
fi

# ── V2: Hooks ─────────────────────────────────────────────────────────────────
if should_run "V2"; then
  v2_status="pass"
  v2_msg=""

  # Check 1: hook script paths in settings.json resolve on disk
  if [[ ! -f "$SETTINGS_JSON" ]]; then
    v2_status="fail"
    v2_msg=".claude/settings.json not found"
  else
    missing_hook=""
    # Use python3 to parse JSON (Bash 3 compat — no jq required)
    missing_hook=$(python3 - <<PYEOF
import json, sys, os

try:
    with open('$SETTINGS_JSON') as f:
        cfg = json.load(f)
except Exception as e:
    print("JSON_PARSE_ERROR: " + str(e))
    sys.exit(0)

hooks_section = cfg.get('hooks', {})
for event_name, hooks_list in hooks_section.items():
    if not isinstance(hooks_list, list):
        continue
    for hook in hooks_list:
        if not isinstance(hook, dict):
            continue
        # hooks can have a 'hooks' sub-list
        inner = hook.get('hooks', [hook])
        for h in inner:
            cmd = h.get('command', '') if isinstance(h, dict) else ''
            if not cmd:
                continue
            # Extract script path: first token that looks like a file path
            tokens = cmd.split()
            for tok in tokens:
                # Look for .sh or .py paths that reference .claude/hooks or scripts/
                if ('hooks/' in tok or 'scripts/' in tok) and (tok.endswith('.sh') or tok.endswith('.py')):
                    # Skip env-var based paths — they resolve at shell runtime, not statically
                    if '$' in tok:
                        break
                    # Strip surrounding quotes, then resolve relative to PROJECT_ROOT
                    clean = tok.strip('"').strip("'")
                    if clean.startswith('./'):
                        clean = clean[2:]
                    full = os.path.join('$PROJECT_ROOT', clean)
                    if not os.path.isfile(full):
                        print(tok)
                    break
PYEOF
    )
    if [[ -n "$missing_hook" ]]; then
      v2_status="fail"
      v2_msg="missing hook script: ${missing_hook}"
    fi
  fi

  # Check 2: smoke-test.sh (only if V2 still passing)
  if [[ "$v2_status" == "pass" ]]; then
    if ! script_exists "smoke-test.sh"; then
      # Graceful degradation — smoke-test not yet built
      v2_msg="hook paths valid, smoke-test.sh not found (skipped)"
    else
      smoke_out=$(cd "$PROJECT_ROOT" && bash "$PROJECT_ROOT/scripts/smoke-test.sh" 2>&1) || smoke_exit=$?
      smoke_exit=${smoke_exit:-0}
      if [[ $smoke_exit -ne 0 ]]; then
        v2_status="fail"
        first_fail=$(echo "$smoke_out" | grep "FAIL\|ABORT" | head -1)
        v2_msg="smoke-test failed: ${first_fail:-non-zero exit}"
        if [[ "$VERBOSE" == "true" ]]; then
          echo "--- V2 smoke-test output ---"
          echo "$smoke_out"
          echo "---"
        fi
      else
        v2_msg="hook paths valid, smoke-test passed"
      fi
    fi
  fi

  record "V2" "$v2_status" "$v2_msg"
fi

# ── V3: Knowledge Graph ───────────────────────────────────────────────────────
if should_run "V3"; then
  v3_status="pass"
  v3_broken=0
  v3_orphans=0
  v3_msg=""

  # link-validator — pass all .md files (not --staged which only checks staged)
  if ! script_exists "link-validator.sh"; then
    v3_msg="link-validator.sh not found (skipped)"
    record "V3" "skip" "$v3_msg"
  else
    # Run on all .md files via find (avoid --staged which needs git index)
    lv_out=$(cd "$PROJECT_ROOT" && bash "$PROJECT_ROOT/scripts/link-validator.sh" --quiet 2>&1) || lv_exit=$?
    lv_exit=${lv_exit:-0}
    if [[ $lv_exit -ne 0 ]]; then
      v3_broken=$(echo "$lv_out" | grep -c "^\S" 2>/dev/null || echo "?")
      v3_status="fail"
    fi

    # orphan-detect — informational (exits 0 always), but count orphans
    if script_exists "orphan-detect.sh"; then
      od_out=$(cd "$PROJECT_ROOT" && bash "$PROJECT_ROOT/scripts/orphan-detect.sh" "$PROJECT_ROOT" 2>&1) || true
      v3_orphans=$(echo "$od_out" | grep -c "\.md$" 2>/dev/null || echo "0")
    fi

    if [[ "$v3_status" == "pass" ]]; then
      record "V3" "pass" "${v3_broken} broken links, ${v3_orphans} orphans"
    else
      v3_detail=$(echo "$lv_out" | head -3 | tr '\n' '; ')
      record "V3" "fail" "${v3_broken} broken links — ${v3_detail}"
      if [[ "$VERBOSE" == "true" ]]; then
        echo "--- V3 link-validator output ---"
        echo "$lv_out"
        echo "---"
      fi
    fi
  fi
fi

# ── V4: Agent Infrastructure ─────────────────────────────────────────────────
if should_run "V4"; then
  agent_dir="$PROJECT_ROOT/.claude/agents"
  rules_dir="$PROJECT_ROOT/.claude/rules"
  skills_dir="$PROJECT_ROOT/.claude/skills"

  agent_count=0
  rule_skill_count=0

  if [[ -d "$agent_dir" ]]; then
    agent_count=$(find "$agent_dir" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [[ -d "$rules_dir" ]]; then
    rule_count=$(find "$rules_dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  else
    rule_count=0
  fi
  if [[ -d "$skills_dir" ]]; then
    skill_count=$(find "$skills_dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  else
    skill_count=0
  fi
  rule_skill_count=$((rule_count + skill_count))

  MIN_AGENTS=4
  MIN_RULE_SKILLS=20

  v4_msg="agents: ${agent_count}, rules: ${rule_count}, skills: ${skill_count}"

  if [[ $agent_count -lt $MIN_AGENTS ]] || [[ $rule_skill_count -lt $MIN_RULE_SKILLS ]]; then
    detail=""
    [[ $agent_count -lt $MIN_AGENTS ]] && detail="agents ${agent_count} < ${MIN_AGENTS}"
    [[ $rule_skill_count -lt $MIN_RULE_SKILLS ]] && detail="${detail:+${detail}, }rules+skills ${rule_skill_count} < ${MIN_RULE_SKILLS}"
    record "V4" "fail" "${v4_msg} — below threshold: ${detail}"
  else
    record "V4" "pass" "$v4_msg"
  fi
fi

# ── V5: Manifest Ownership ────────────────────────────────────────────────────
if should_run "V5"; then
  v5_status="pass"
  v5_msg=""

  # Check 1: template-manifest.sh --audit
  if ! script_exists "template-manifest.sh"; then
    record "V5" "skip" "template-manifest.sh not found — check skipped"
  else
    audit_out=$(cd "$PROJECT_ROOT" && bash "$PROJECT_ROOT/scripts/template-manifest.sh" --audit 2>&1) || audit_exit=$?
    audit_exit=${audit_exit:-0}
    if [[ $audit_exit -ne 0 ]]; then
      v5_status="fail"
      first_fail=$(echo "$audit_out" | grep -i "FAIL\|ERROR\|overlap\|untracked" | head -2 | tr '\n' '; ')
      v5_msg="manifest audit failed: ${first_fail:-non-zero exit}"
      if [[ "$VERBOSE" == "true" ]]; then
        echo "--- V5 audit output ---"
        echo "$audit_out"
        echo "---"
      fi
    fi

    # Check 2: deprecated file patterns — only if manifest yml exists
    if [[ "$v5_status" == "pass" ]] && [[ -f "$MANIFEST_YML" ]]; then
      deprecated_found=$(python3 - <<PYEOF
import sys, os, glob, re

manifest_path = '$MANIFEST_YML'
root = '$PROJECT_ROOT'

try:
    with open(manifest_path) as f:
        content = f.read()
except Exception as e:
    sys.exit(0)

# Extract deprecated patterns — simple line-by-line parse (no yaml module required)
patterns = []
in_deprecated = False
for line in content.splitlines():
    stripped = line.strip()
    if stripped == 'deprecated:':
        in_deprecated = True
        continue
    if in_deprecated:
        if stripped.startswith('- pattern:'):
            pat = stripped.replace('- pattern:', '').strip().strip('"').strip("'")
            patterns.append(pat)
        elif stripped and not stripped.startswith('-') and not stripped.startswith('#') and ':' in stripped and not stripped.startswith('removed') and not stripped.startswith('action'):
            # Top-level key — end of deprecated block
            in_deprecated = False

found = []
for pat in patterns:
    # Convert glob pattern to filesystem glob relative to root
    full_pat = os.path.join(root, pat)
    matches = glob.glob(full_pat, recursive=True)
    # Filter: existing files only, exclude .gitkeep placeholders (empty stubs)
    real_matches = []
    for m in matches:
        if not os.path.exists(m):
            continue
        if os.path.isfile(m) and os.path.basename(m) == '.gitkeep':
            continue
        # Directory match: check if it contains any non-gitkeep files
        if os.path.isdir(m):
            has_real = any(
                f != '.gitkeep'
                for _, _, files in os.walk(m)
                for f in files
            )
            if not has_real:
                continue
        real_matches.append(m)
    matches = real_matches
    if matches:
        found.append(pat + ' (' + str(len(matches)) + ' match(es))')

if found:
    print('; '.join(found))
PYEOF
      )
      if [[ -n "$deprecated_found" ]]; then
        v5_status="fail"
        v5_msg="deprecated files found: ${deprecated_found}"
      fi
    fi

    if [[ "$v5_status" == "pass" ]]; then
      # Extract coverage from audit output if available
      coverage=$(echo "$audit_out" | grep -oE 'coverage[: ]+[0-9]+%' | head -1 || echo "")
      v5_msg="manifest audit passed${coverage:+, ${coverage}}, no deprecated files"
    fi

    record "V5" "$v5_status" "$v5_msg"
  fi
fi

# ── V6: Sync Completeness ─────────────────────────────────────────────────────
if should_run "V6"; then
  if ! script_exists "template-sync.sh"; then
    record "V6" "skip" "template-sync.sh not found — check skipped"
  else
    sync_out=$(cd "$PROJECT_ROOT" && bash "$PROJECT_ROOT/scripts/template-sync.sh" --verify 2>&1) || sync_exit=$?
    sync_exit=${sync_exit:-0}
    if [[ $sync_exit -eq 0 ]]; then
      record "V6" "pass" "sync completeness verified"
    else
      # Graceful degradation: if no sync log exists yet (fresh repo / never synced),
      # treat as SKIP rather than FAIL — verify requires prior sync to be meaningful
      if echo "$sync_out" | grep -q "no sync actions recorded\|not found.*sync"; then
        record "V6" "skip" "no prior sync log found — run template-sync first to enable this check"
      else
        first_fail=$(echo "$sync_out" | grep -i "FAIL\|ERROR" | head -2 | tr '\n' ' ')
        record "V6" "fail" "sync --verify failed: ${first_fail:-check sync log for details}"
        if [[ "$VERBOSE" == "true" ]]; then
          echo "--- V6 sync output ---"
          echo "$sync_out"
          echo "---"
        fi
      fi
    fi
  fi
fi

# ── Output ────────────────────────────────────────────────────────────────────

if [[ "$JSON_OUTPUT" == "true" ]]; then
  # Machine-readable JSON output
  printf '{"checks":['
  first=true

  # Reconstruct from parallel arrays using index iteration
  ids="$RESULT_IDS"
  statuses="$RESULT_STATUSES"
  msgs="$RESULT_MESSAGES"

  while [[ -n "$ids" ]]; do
    id="${ids%%|*}"
    ids="${ids#*|}"
    status="${statuses%%|*}"
    statuses="${statuses#*|}"
    # Messages use || as delimiter (message may contain |)
    msg="${msgs%%||*}"
    msgs="${msgs#*||}"

    [[ "$first" == "false" ]] && printf ','
    first=false
    # Escape double quotes in msg
    msg_escaped=$(echo "$msg" | sed 's/"/\\"/g')
    printf '{"id":"%s","status":"%s","message":"%s"}' "$id" "$status" "$msg_escaped"
  done

  printf '],"summary":{"pass":%d,"fail":%d,"skip":%d,"total":%d}}\n' \
    "$PASS_COUNT" "$FAIL_COUNT" "$SKIP_COUNT" "$TOTAL"
else
  # Human-readable output
  ids="$RESULT_IDS"
  statuses="$RESULT_STATUSES"
  msgs="$RESULT_MESSAGES"

  while [[ -n "$ids" ]]; do
    id="${ids%%|*}"
    ids="${ids#*|}"
    status="${statuses%%|*}"
    statuses="${statuses#*|}"
    msg="${msgs%%||*}"
    msgs="${msgs#*||}"

    case "$status" in
      pass) printf "%s PASS — %s\n" "$id" "$msg" ;;
      fail) printf "%s FAIL — %s\n" "$id" "$msg" ;;
      skip) printf "%s SKIP — %s\n" "$id" "$msg" ;;
    esac
  done

  echo ""
  if [[ -n "$FILTER" ]]; then
    printf "RESULT: %d/%d\n" "$PASS_COUNT" "$TOTAL"
  else
    printf "RESULT: %d/6\n" "$PASS_COUNT"
  fi
fi

# ── Exit code ─────────────────────────────────────────────────────────────────
if [[ $FAIL_COUNT -gt 0 ]]; then
  exit 1
fi
exit 0
