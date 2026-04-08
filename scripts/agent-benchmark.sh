#!/usr/bin/env bash
# version: 1.2 | status: draft | last_updated: 2026-04-08
# Agent Benchmark — Safety, Output Quality, Efficiency across 5 LTC agent files.
# Usage: ./scripts/agent-benchmark.sh baseline | validate [--judge]
#   --judge: Layer 2 LLM-as-Judge via Claude CLI (adds ~$1-2, requires `claude` in PATH)
set -euo pipefail
JUDGE=0
for arg in "$@"; do [ "$arg" = "--judge" ] && JUDGE=1; done
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS="$ROOT/.claude/agents"; DSBV="$ROOT/.claude/skills/dsbv/SKILL.md"
BASELINE="$ROOT/scripts/test-fixtures/agent-benchmark-baseline.txt"
PREFLIGHT="$ROOT/scripts/pre-flight.sh"
CTXPKG="$ROOT/.claude/skills/dsbv/references/context-packaging.md"
ALIGN_SCRIPT="$ROOT/scripts/alignment-check.sh"
SP=0; ST=0; QP=0; QT=0; EP_=0; ET=0; DETAILS=""

check() {
  local c="$1" id="$2" d="$3" r="$4" ev="${5:-}"
  case "$c" in
    S) ST=$((ST+1)); [ "$r" = "PASS" ] && SP=$((SP+1)) ;;
    Q) QT=$((QT+1)); [ "$r" = "PASS" ] && QP=$((QP+1)) ;;
    E) ET=$((ET+1)); [ "$r" = "PASS" ] && EP_=$((EP_+1)) ;;
  esac
  DETAILS+="$(printf '  %-7s %-6s %s' "$id" "$r" "$d")\n"
  [ "$r" = "FAIL" ] && [ -n "$ev" ] && DETAILS+="$(printf '                 -> %s' "$ev")\n"
  return 0
}
cm() { local n; n=$(grep -cE "$2" "$1" 2>/dev/null) && echo "$n" || echo 0; }
hm() { grep -qE "$2" "$1" 2>/dev/null && echo 1 || echo 0; }

t() { # t file pattern — returns 0 (true) or 1 (false) for if/else
  grep -qE "$2" "$1" 2>/dev/null
}

# === CATEGORY 1: SAFETY & CORRECTNESS ===

# S-01: Explorer — no WebSearch false claims
n=$(cm "$AGENTS/ltc-explorer.md" "WebSearch")
if [ "$n" -eq 0 ]; then check S S-01 "Explorer: zero WebSearch false refs" PASS
else check S S-01 "Explorer: zero WebSearch false refs" FAIL "Found $n refs"; fi

# S-02: Planner — no false orchestrator claim
n=$(cm "$AGENTS/ltc-planner.md" "(You are the declared orchestrator|MAY.*dispatch)")
if [ "$n" -eq 0 ]; then check S S-02 "Planner: no false orchestrator/dispatch" PASS
else check S S-02 "Planner: no false orchestrator/dispatch" FAIL "Found $n claims"; fi

# S-03: Planner EP-13 says NEVER call Agent()
if t "$AGENTS/ltc-planner.md" "NEVER call the Agent"; then
  check S S-03 "Planner EP-13: NEVER call Agent()" PASS
else check S S-03 "Planner EP-13: NEVER call Agent()" FAIL "Missing constraint"; fi

# S-04..S-07: Sub-Agent Safety section per agent
si=4
for a in ltc-explorer ltc-planner ltc-builder ltc-reviewer; do
  id=$(printf 'S-%02d' $si); si=$((si+1))
  if t "$AGENTS/${a}.md" "Sub-Agent Safety|## Safety"; then
    check S "$id" "${a}: Safety section exists" PASS
  else check S "$id" "${a}: Safety section exists" FAIL "Not found"; fi
done

# S-08: Builder — hook constraint coverage (>=6 safety rules)
n=$(cm "$AGENTS/ltc-builder.md" "(NEVER|MUST NOT|DO NOT|HARD CONSTRAINT|STOP and report)")
if [ "$n" -ge 6 ]; then check S S-08 "Builder: >=6 safety constraints" PASS "Found $n"
else check S S-08 "Builder: >=6 safety constraints" FAIL "Found $n (need >=6)"; fi

# S-09..S-11: Builder references validation scripts
si=9
for s in validate-blueprint skill-validator template-check; do
  id=$(printf 'S-%02d' $si); si=$((si+1))
  if t "$AGENTS/ltc-builder.md" "$s"; then
    check S "$id" "Builder: references $s" PASS
  else check S "$id" "Builder: references $s" FAIL "Missing"; fi
done

# S-12..S-15: No agent self-approves validated status
si=12
for a in ltc-explorer ltc-planner ltc-builder ltc-reviewer; do
  id=$(printf 'S-%02d' $si); si=$((si+1))
  sa=$(cm "$AGENTS/${a}.md" "status:.*validated|set.*validated|mark.*validated")
  bad=0
  if [ "$sa" -gt 0 ]; then
    g=$(cm "$AGENTS/${a}.md" "(NEVER.*validated|Human.*ONLY.*validated|Agent NEVER self-approves)")
    [ "$g" -eq 0 ] && bad=1
  fi
  if [ "$bad" -eq 0 ]; then check S "$id" "${a}: no self-approval" PASS
  else check S "$id" "${a}: no self-approval" FAIL "$sa unguarded refs"; fi
done

# S-16..S-23: New agent section/tool checks
tc() { local cat="$1" id="$2" desc="$3" f="$4" pat="$5" # thin check helper
  if t "$f" "$pat"; then check "$cat" "$id" "$desc" PASS
  else check "$cat" "$id" "$desc" FAIL "Not found"; fi; }
tc S S-16 "Explorer: Output Contract section" "$AGENTS/ltc-explorer.md" "Output Contract"
tc S S-17 "Explorer: Pre-Flight section" "$AGENTS/ltc-explorer.md" "Pre-Flight"
tc S S-18 "Explorer: Post-Flight section" "$AGENTS/ltc-explorer.md" "Post-Flight"
tc S S-19 "Planner: Glob in tools" "$AGENTS/ltc-planner.md" "Glob"
# S-20: Planner Output Contract + BEGIN DESIGN (compound)
oc=$(hm "$AGENTS/ltc-planner.md" "Output Contract"); bd=$(hm "$AGENTS/ltc-planner.md" "BEGIN DESIGN")
if [ "$oc" -eq 1 ] && [ "$bd" -eq 1 ]; then check S S-20 "Planner: Output Contract + BEGIN DESIGN" PASS
else ev=""; [ "$oc" -eq 0 ] && ev="no Output Contract"; [ "$bd" -eq 0 ] && ev="${ev:+$ev, }no BEGIN DESIGN"
  check S S-20 "Planner: Output Contract + BEGIN DESIGN" FAIL "$ev"; fi
tc S S-21 "Planner: Pre-Design Checklist" "$AGENTS/ltc-planner.md" "Pre-Design Checklist"
tc S S-22 "Builder: Glob in tools" "$AGENTS/ltc-builder.md" "Glob"
tc S S-23 "Builder: assumptions/handoff ref" "$AGENTS/ltc-builder.md" "assumptions|handoff"

# === CATEGORY 2: OUTPUT QUALITY ===

# Q-01: Reviewer — aggregate score format
if t "$AGENTS/ltc-reviewer.md" "aggregate.*score|overall.*score|PASS.*FAIL.*tally"; then
  check Q Q-01 "Reviewer: aggregate score format" PASS
else check Q Q-01 "Reviewer: aggregate score format" FAIL "Not found"; fi

# Q-02: Reviewer — FAIL-{N} format
if t "$AGENTS/ltc-reviewer.md" 'FAIL-[{0-9N]'; then
  check Q Q-02 "Reviewer: FAIL-N identifier format" PASS
else check Q Q-02 "Reviewer: FAIL-N identifier format" FAIL "Not found"; fi

# Q-03: Reviewer — builder re-dispatch protocol
if t "$AGENTS/ltc-reviewer.md" "re-dispatch|builder.*fix|dispatch.*builder"; then
  check Q Q-03 "Reviewer: builder re-dispatch protocol" PASS
else check Q Q-03 "Reviewer: builder re-dispatch protocol" FAIL "Not found"; fi

# Q-04: DSBV — Generator/Critic loop
if t "$DSBV" "[Gg]enerator.*[Cc]ritic|[Cc]ritic.*loop|iterative.*loop"; then
  check Q Q-04 "DSBV: Generator/Critic loop" PASS
else check Q Q-04 "DSBV: Generator/Critic loop" FAIL "Not found"; fi

# Q-05: DSBV — max_iterations
if t "$DSBV" "max.iterations|maximum.*iterations|iteration.*limit|max.*retries"; then
  check Q Q-05 "DSBV: max_iterations defined" PASS
else check Q Q-05 "DSBV: max_iterations defined" FAIL "Not found"; fi

# Q-06: DSBV — exit_condition
if t "$DSBV" "exit.condition|exit.*criteria|termination.*condition|all.*AC.*pass"; then
  check Q Q-06 "DSBV: exit condition defined" PASS
else check Q Q-06 "DSBV: exit condition defined" FAIL "Not found"; fi

# Q-07: DSBV — escalation path
if t "$DSBV" "escalat|human.*override|report.*to.*user|report.*to.*Human"; then
  check Q Q-07 "DSBV: escalation path defined" PASS
else check Q Q-07 "DSBV: escalation path defined" FAIL "Not found"; fi

# Q-08: DSBV — circuit breaker + error classification
cb=$(hm "$DSBV" "circuit.break|error.*class|error.*categor")
et_=$(hm "$DSBV" "SYNTACTIC|SEMANTIC|ENVIRONMENTAL|SCOPE")
if [ "$cb" -eq 1 ] && [ "$et_" -eq 1 ]; then
  check Q Q-08 "DSBV: circuit breaker + error types" PASS
elif [ "$cb" -eq 1 ]; then
  check Q Q-08 "DSBV: circuit breaker + error types" FAIL "Missing error type taxonomy"
else
  check Q Q-08 "DSBV: circuit breaker + error types" FAIL "No circuit breaker"
fi

# Q-09: DSBV — both single+multi agent Build have loop
qs=$(hm "$DSBV" "single-agent.*Generator|single-agent.*loop|Steps.*single.*[Cc]ritic|all tasks complete.*[Cc]ritic|all tasks complete.*loop")
qm=$(hm "$DSBV" "multi-agent.*Generator|multi-agent.*loop|Steps.*multi.*[Cc]ritic|synthesized.*[Cc]ritic|[Cc]ritic.*loop.*synthesized|loop.*synthesized|synthesized.*output")
if [ "$qs" -eq 1 ] && [ "$qm" -eq 1 ]; then
  check Q Q-09 "DSBV: both Build modes have loop" PASS
else
  ev=""; [ "$qs" -eq 0 ] && ev="no single-agent loop"
  [ "$qm" -eq 0 ] && ev="${ev:+$ev, }no multi-agent loop"
  check Q Q-09 "DSBV: both Build modes have loop" FAIL "$ev"
fi

# Q-10..Q-14: New quality checks
tc Q Q-10 "DSBV: structured gate report format" "$DSBV" "GATE: G"
tc Q Q-11 "Reviewer: Smoke Test / LP-6 ref" "$AGENTS/ltc-reviewer.md" "Smoke Test|LP-6"
tc Q Q-12 "Reviewer: input pre-flight validation" "$AGENTS/ltc-reviewer.md" "[Pp]re-[Ff]light|input validation"
if [ -f "$CTXPKG" ] && t "$CTXPKG" "max_tool_calls"; then check Q Q-13 "Context-packaging: max_tool_calls" PASS
else check Q Q-13 "Context-packaging: max_tool_calls" FAIL "Not found"; fi
tc Q Q-14 "DSBV: parallel dispatch protocol" "$DSBV" "parallel|simultaneous|independent.*dispatch"

# === CATEGORY 3: OPERATIONAL EFFICIENCY ===

if [ -f "$PREFLIGHT" ]; then
  check E E-01 "Pre-flight script exists" PASS
  if bash -n "$PREFLIGHT" 2>/dev/null; then
    check E E-02 "Pre-flight: valid bash syntax" PASS
  else check E E-02 "Pre-flight: valid bash syntax" FAIL "bash -n error"; fi
  pc=0
  for kw in WORKSTREAM ALIGNMENT RISKS DRIVERS TEMPLATES LEARNING VERSION EXECUTE DOCUMENT; do
    grep -qi "$kw" "$PREFLIGHT" 2>/dev/null && pc=$((pc+1)) || true
  done
  if [ "$pc" -ge 9 ]; then check E E-03 "Pre-flight: 9 CLAUDE.md checks" PASS "$pc/9"
  else check E E-03 "Pre-flight: 9 CLAUDE.md checks" FAIL "$pc/9"; fi
else
  check E E-01 "Pre-flight script exists" FAIL "pre-flight.sh not found"
  check E E-02 "Pre-flight: valid bash syntax" FAIL "script missing"
  check E E-03 "Pre-flight: 9 CLAUDE.md checks" FAIL "script missing"
fi

# E-04: Planner BLOCKED protocol
if t "$AGENTS/ltc-planner.md" "BLOCK|STOP.*report|cannot.*proceed|dependency.*missing"; then
  check E E-04 "Planner: BLOCKED protocol" PASS
else check E E-04 "Planner: BLOCKED protocol" FAIL "Not found"; fi

# E-05: Explorer honest fallback (QMD, not WebSearch)
eq=$(hm "$AGENTS/ltc-explorer.md" "[Qq][Mm][Dd]|mcp__qmd")
ew=$(cm "$AGENTS/ltc-explorer.md" "WebSearch")
if [ "$eq" -eq 1 ] && [ "$ew" -eq 0 ]; then
  check E E-05 "Explorer: honest fallback (QMD only)" PASS
elif [ "$eq" -eq 1 ]; then
  check E E-05 "Explorer: honest fallback (QMD only)" FAIL "QMD ok but WebSearch refs=$ew"
else check E E-05 "Explorer: honest fallback (QMD only)" FAIL "Missing QMD"; fi

# E-06: alignment-check.sh exists and valid syntax
if [ -f "$ALIGN_SCRIPT" ] && bash -n "$ALIGN_SCRIPT" 2>/dev/null; then
  check E E-06 "alignment-check.sh exists + valid" PASS
elif [ -f "$ALIGN_SCRIPT" ]; then check E E-06 "alignment-check.sh exists + valid" FAIL "bash -n error"
else check E E-06 "alignment-check.sh exists + valid" FAIL "Not found"; fi

# E-07: Pipeline state schema documented
tc E E-07 "Pipeline state schema documented" "$DSBV" "pipeline.json|pipeline.*state|pipeline.*schema"

# E-08: Auto-recall hook has intent-based filtering
HOOKS_DIR="$ROOT/.claude/hooks"
if [ -d "$HOOKS_DIR" ] && grep -rqE "intent|relevance.*filter|intent.*filter" "$HOOKS_DIR" 2>/dev/null; then
  check E E-08 "Auto-recall: intent-based filtering" PASS
else check E E-08 "Auto-recall: intent-based filtering" FAIL "No intent filter in hooks"; fi

# === OUTPUT ===
TP=$((SP+QP+EP_)); TT=$((ST+QT+ET))
emit() {
  echo ""; echo "AGENT BENCHMARK REPORT ($1)"; echo "==============================="
  printf '  %-24s %s\n' "Safety Score:" "$SP/$ST"
  printf '  %-24s %s\n' "Output Quality Score:" "$QP/$QT"
  printf '  %-24s %s\n' "Efficiency Score:" "$EP_/$ET"
  printf '  %-24s %s\n' "TOTAL:" "$TP/$TT"
  echo ""; echo "DETAILS:"; echo -e "$DETAILS"
}
save() {
  mkdir -p "$(dirname "$1")"
  printf 'SP=%d\nST=%d\nQP=%d\nQT=%d\nEP_=%d\nET=%d\nTP=%d\nTT=%d\n' \
    "$SP" "$ST" "$QP" "$QT" "$EP_" "$ET" "$TP" "$TT" > "$1"
}
pm() {
  echo "PM IMPACT SUMMARY"; echo "================="
  if [ "$SP" -eq "$ST" ]; then echo "  Safety: ALL CLEAR"; else
    [ "$(cm "$AGENTS/ltc-explorer.md" "WebSearch")" -gt 0 ] && echo "  - Explorer claims WebSearch -> failed fallbacks when Exa down" || true
    [ "$(cm "$AGENTS/ltc-planner.md" "(declared orchestrator|MAY.*dispatch)")" -gt 0 ] && echo "  - Planner false orchestrator -> silent dispatch failures" || true
    [ "$(hm "$AGENTS/ltc-builder.md" "Sub-Agent Safety|## Safety")" -eq 0 ] && echo "  - Builder no Safety section -> missing hook-loss guardrails" || true
    [ "$(hm "$AGENTS/ltc-explorer.md" "Output Contract")" -eq 0 ] && echo "  - Explorer no Output Contract -> unstructured research returns" || true
    [ "$(hm "$AGENTS/ltc-explorer.md" "Pre-Flight")" -eq 0 ] && echo "  - Explorer no Pre-Flight -> accepts incomplete inputs" || true
    [ "$(hm "$AGENTS/ltc-planner.md" "BEGIN DESIGN")" -eq 0 ] && echo "  - Planner no BEGIN DESIGN markers -> orchestrator cant parse output" || true
    [ "$(hm "$AGENTS/ltc-planner.md" "Pre-Design Checklist")" -eq 0 ] && echo "  - Planner no Pre-Design Checklist -> skips alignment checks" || true
    [ "$(hm "$AGENTS/ltc-builder.md" "assumptions|handoff")" -eq 0 ] && echo "  - Builder no handoff contract -> silent assumption drift" || true
  fi
  if [ "$QP" -eq "$QT" ]; then echo "  Output Quality: ALL CLEAR"; else
    [ "$(hm "$DSBV" "[Gg]enerator.*[Cc]ritic")" -eq 0 ] && echo "  - No Generator/Critic loop -> manual re-dispatch needed" || true
    [ "$(hm "$DSBV" "circuit.break")" -eq 0 ] && echo "  - No circuit breaker -> infinite retries on unfixable errors" || true
    [ "$(hm "$AGENTS/ltc-reviewer.md" 'FAIL-[{0-9N]')" -eq 0 ] && echo "  - No FAIL-N format -> builder cant identify specific fixes" || true
    [ "$(hm "$DSBV" "GATE: G")" -eq 0 ] && echo "  - No structured gate report -> human gates lack actionable data" || true
    [ "$(hm "$AGENTS/ltc-reviewer.md" "Smoke Test|LP-6")" -eq 0 ] && echo "  - Reviewer no smoke test -> broken scripts pass review" || true
    [ "$(hm "$AGENTS/ltc-reviewer.md" "[Pp]re-[Ff]light|input validation")" -eq 0 ] && echo "  - Reviewer no input validation -> reviews run on incomplete data" || true
  fi
  if [ "$EP_" -eq "$ET" ]; then echo "  Efficiency: ALL CLEAR"; else
    [ ! -f "$PREFLIGHT" ] && echo "  - No pre-flight script -> agents skip readiness, waste tokens" || true
    [ "$(hm "$AGENTS/ltc-planner.md" "BLOCK|STOP.*report")" -eq 0 ] && echo "  - No BLOCKED protocol -> planner hallucinates on missing deps" || true
    [ "$(cm "$AGENTS/ltc-explorer.md" "WebSearch")" -gt 0 ] && echo "  - WebSearch phantom tool -> wasted fallback attempts" || true
    [ ! -f "$ALIGN_SCRIPT" ] && echo "  - No alignment-check.sh -> orphan conditions undetected" || true
    [ "$(hm "$DSBV" "pipeline.json|pipeline.*state")" -eq 0 ] && echo "  - No pipeline state schema -> cant resume after crash" || true
  fi
  echo ""
}
fd() { [ "$1" -gt 0 ] && echo "+$1" || echo "$1"; }

judge() {
  if [ "$JUDGE" -eq 0 ]; then return 0; fi
  if ! command -v claude &>/dev/null; then
    echo ""; echo "JUDGE: 'claude' CLI not found in PATH — skipping Layer 2."
    return 0
  fi
  echo ""; echo "LLM-AS-JUDGE (Layer 2 — Opus)"
  echo "=============================="
  echo "Evaluating content quality of agent files..."
  echo ""

  local RUBRIC
  RUBRIC=$(cat <<'RUBRIC_EOF'
You are an expert reviewer of AI agent configuration files. Score each item PASS or FAIL with 1-line evidence.

Review these files and evaluate:

J-01: ltc-builder.md Sub-Agent Safety section — do the 10 rules correctly map to the 14 hooks listed in the DESIGN? (Read the file, count rules, check each compensates a specific hook)
J-02: ltc-planner.md EP-13 section — is the leaf-node constraint coherent and does it include a BLOCKED protocol for requesting research?
J-03: ltc-reviewer.md VALIDATE.md v2 format — does it define aggregate score, FAIL-{N} format, AND builder re-dispatch format with all required fields (task ID, file, expected, actual, fix, AC)?
J-04: dsbv/SKILL.md Generator/Critic loop — does the loop have: (a) max_iterations cap, (b) exit condition, (c) structured FAIL→builder handoff, (d) escalation to human on max iterations?
J-05: dsbv/SKILL.md Circuit breaker — does it classify errors into ≥3 types with different retry strategies, AND have a hard stop for persistent failures?
J-06: ltc-explorer.md Output Contract — does it define required_sections (findings, sources, confidence, unknowns), size_bounds per tier (lite/mid/deep/full), AND citation cross-reference rule?
J-07: ltc-planner.md Output Contract with BEGIN/END markers — are markers unambiguous (BEGIN DESIGN.md / END DESIGN.md), AND are metadata fields (STATUS, ALIGNMENT_CHECK, BLOCKERS) present?
J-08: ltc-planner.md BLOCKED protocol — does it follow STOP, report what is needed, partial output, orchestrator re-dispatches explorer? Is the flow coherent end-to-end?
J-09: ltc-builder.md handoff/assumptions fields — are assumptions[], uncertain_fields[], confidence_score described with enough specificity to be actionable by a reviewer?
J-10: ltc-reviewer.md smoke test protocol — does it explicitly state read-only boundary, AND list specific test commands per artifact type (bash -n, python import, skill-validator)?

Output format (exactly):
J-01 PASS|FAIL evidence-in-one-line
J-02 PASS|FAIL evidence-in-one-line
J-03 PASS|FAIL evidence-in-one-line
J-04 PASS|FAIL evidence-in-one-line
J-05 PASS|FAIL evidence-in-one-line
J-06 PASS|FAIL evidence-in-one-line
J-07 PASS|FAIL evidence-in-one-line
J-08 PASS|FAIL evidence-in-one-line
J-09 PASS|FAIL evidence-in-one-line
J-10 PASS|FAIL evidence-in-one-line
RUBRIC_EOF
)

  local JUDGE_FILES=""
  JUDGE_FILES+="--- ltc-explorer.md ---"$'\n'
  JUDGE_FILES+="$(cat "$AGENTS/ltc-explorer.md")"$'\n\n'
  JUDGE_FILES+="--- ltc-builder.md ---"$'\n'
  JUDGE_FILES+="$(cat "$AGENTS/ltc-builder.md")"$'\n\n'
  JUDGE_FILES+="--- ltc-planner.md ---"$'\n'
  JUDGE_FILES+="$(cat "$AGENTS/ltc-planner.md")"$'\n\n'
  JUDGE_FILES+="--- ltc-reviewer.md ---"$'\n'
  JUDGE_FILES+="$(cat "$AGENTS/ltc-reviewer.md")"$'\n\n'
  JUDGE_FILES+="--- dsbv/SKILL.md (first 300 lines) ---"$'\n'
  JUDGE_FILES+="$(head -300 "$DSBV")"$'\n'

  local TMPFILE
  TMPFILE=$(mktemp /tmp/agent-judge-XXXXXX.txt)
  printf '%s\n\n%s\n' "${JUDGE_FILES}" "${RUBRIC}" > "$TMPFILE"
  local JUDGE_RESULT
  JUDGE_RESULT=$(cat "$TMPFILE" | claude -p --model claude-opus-4-6 2>&1) || {
    echo "  JUDGE ERROR: Claude CLI call failed. Output: $JUDGE_RESULT"
    rm -f "$TMPFILE"
    return 0
  }
  rm -f "$TMPFILE"

  local JP=0 JT=10
  while IFS= read -r line; do
    case "$line" in
      J-0*|J-1*) echo "  $line"
            [[ "$line" == *"PASS"* ]] && JP=$((JP+1))
            ;;
    esac
  done <<< "$JUDGE_RESULT"

  echo ""
  printf '  Judge Score: %d/%d\n' "$JP" "$JT"
  if [ "$JP" -eq "$JT" ]; then
    echo "  Verdict: ALL CONTENT CORRECT — Layer 2 confirms Layer 1 structure."
  else
    echo "  Verdict: $((JT-JP)) content issues found — review J-* FAIL items above."
  fi
  echo ""
}

MODE="${1:-help}"
case "$MODE" in
  baseline) emit "BASELINE"; save "$BASELINE"; echo "Baseline saved: $BASELINE"; pm; judge ;;
  validate)
    NS=$SP; NST=$ST; NQ=$QP; NQT=$QT; NE=$EP_; NET=$ET; NT=$TP; NTT=$TT
    if [ -f "$BASELINE" ]; then
      # shellcheck source=/dev/null
      source "$BASELINE"
      OS=$SP; OST=$ST; OQ=$QP; OQT=$QT; OE=$EP_; OET=$ET; OT=$TP; OTT=$TT
      SP=$NS; ST=$NST; QP=$NQ; QT=$NQT; EP_=$NE; ET=$NET; TP=$NT; TT=$NTT
      echo ""; echo "AGENT BENCHMARK REPORT (COMPARISON)"; echo "===================================="
      printf '  %-24s %-8s %-8s %s\n' "" "OLD" "NEW" "DELTA"
      printf '  %-24s %-8s %-8s %s\n' "Safety Score:" "$OS/$OST" "$NS/$NST" "$(fd $((NS-OS)))"
      printf '  %-24s %-8s %-8s %s\n' "Output Quality Score:" "$OQ/$OQT" "$NQ/$NQT" "$(fd $((NQ-OQ)))"
      printf '  %-24s %-8s %-8s %s\n' "Efficiency Score:" "$OE/$OET" "$NE/$NET" "$(fd $((NE-OE)))"
      printf '  %-24s %-8s %-8s %s\n' "TOTAL:" "$OT/$OTT" "$NT/$NTT" "$(fd $((NT-OT)))"
      echo ""; echo "DETAILS (NEW):"; echo -e "$DETAILS"
    else
      echo "WARNING: No baseline at $BASELINE — run 'baseline' first."; echo ""
      emit "VALIDATE (no baseline)"
    fi
    pm; judge ;;
  *) echo "Usage: $0 {baseline|validate} [--judge]"; exit 1 ;;
esac
