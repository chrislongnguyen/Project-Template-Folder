#!/usr/bin/env bash
# pkb-lint.sh — autonomous health check for the Personal Knowledge Base
# version: 2.2 | status: in-review | last_updated: 2026-04-11
#
# Runs 8 mechanical checks that need zero LLM involvement.
# Designed S > E > Sc: reliable first, fast second, scales to 1000+ pages.
#
# Usage:
#   ./scripts/pkb-lint.sh              # advisory mode (always exit 0)
#   ./scripts/pkb-lint.sh --strict     # exit 1 if any issues found
#   ./scripts/pkb-lint.sh --fix        # auto-fix what's fixable (index gaps)
#   ./scripts/pkb-lint.sh --json       # machine-readable output
#
# Wiring: add to PreToolUse(git commit) or run manually / on schedule.

set -euo pipefail

# ── Config ──────────────────────────────────────────────────────────────────
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PKB="$REPO_ROOT/PERSONAL-KNOWLEDGE-BASE"
DISTILLED="$PKB/distilled"
CAPTURED="$PKB/captured"
INDEX="$DISTILLED/_index.md"
LOG="$DISTILLED/_log.md"
STALE_DAYS=30

STRICT=false
FIX=false
JSON=false
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=true ;;
    --fix)    FIX=true ;;
    --json)   JSON=true ;;
  esac
done

# ── Helpers ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YEL='\033[0;33m'
GRN='\033[0;32m'
DIM='\033[0;90m'
RST='\033[0m'

issues=0
warnings=0
checks_run=0
results=()

pass()    { ((checks_run++)); $JSON || printf "  ${GRN}✓${RST} %-12s %s\n" "$1" "$2"; }
warn()    { ((checks_run++)); ((warnings++)); $JSON || printf "  ${YEL}⚠${RST} %-12s %s\n" "$1" "$2"; }
fail()    { ((checks_run++)); ((issues++));   $JSON || printf "  ${RED}✗${RST} %-12s %s\n" "$1" "$2"; }
detail()  { $JSON || printf "    ${DIM}→ %s${RST}\n" "$1"; }

json_add() { results+=("{\"check\":\"$1\",\"status\":\"$2\",\"detail\":\"$3\"}"); }

# ── Preflight ───────────────────────────────────────────────────────────────
if [[ ! -d "$PKB" ]]; then
  $JSON && echo '{"error":"PKB not found"}' || echo "PKB not found at $PKB"
  exit 0
fi

$JSON || echo "pkb-lint: PERSONAL-KNOWLEDGE-BASE/"

# ── CHECK-01: Uningested captures ──────────────────────────────────────────
uningested=()
if [[ -d "$CAPTURED" ]] && [[ -f "$LOG" ]]; then
  while IFS= read -r -d '' file; do
    name="$(basename "$file")"
    [[ "$name" == .* ]] && continue
    grep -qF "$name" "$LOG" 2>/dev/null || uningested+=("$name")
  done < <(find "$CAPTURED" -maxdepth 1 -type f -print0 2>/dev/null)
fi

if [[ ${#uningested[@]} -eq 0 ]]; then
  pass "UNINGESTED" "All captured/ files are in _log.md"
else
  warn "UNINGESTED" "${#uningested[@]} file(s) in captured/ not yet ingested"
  for f in "${uningested[@]}"; do detail "$f"; done
fi

# ── CHECK-02: Shallow pages (below L2 minimum) ────────────────────────────
shallow=()
while IFS= read -r -d '' file; do
  name="$(basename "$file")"
  [[ "$name" == _* ]] && continue  # skip _index.md, _log.md
  # Count questions_answered entries (lines starting with "  - " inside frontmatter)
  in_fm=false
  in_qa=false
  count=0
  while IFS= read -r line; do
    if [[ "$line" == "---" ]]; then
      $in_fm && break  # end of frontmatter
      in_fm=true
      continue
    fi
    if $in_fm && [[ "$line" =~ ^questions_answered: ]]; then
      in_qa=true
      continue
    fi
    if $in_qa; then
      if [[ "$line" =~ ^[[:space:]]+- ]]; then
        [[ "$line" =~ ^[[:space:]]*# ]] && continue  # skip comments
        ((count++))
      elif [[ ! "$line" =~ ^[[:space:]]*# ]] && [[ -n "$line" ]]; then
        break  # left the questions_answered block
      fi
    fi
  done < "$file"

  if [[ $count -gt 0 ]] && [[ $count -lt 6 ]]; then
    rel="${file#$DISTILLED/}"
    shallow+=("$rel ($count/12)")
  elif [[ $count -eq 0 ]]; then
    rel="${file#$DISTILLED/}"
    shallow+=("$rel (no questions_answered)")
  fi
done < <(find "$DISTILLED" -name '*.md' -type f -print0 2>/dev/null)

if [[ ${#shallow[@]} -eq 0 ]]; then
  pass "SHALLOW" "All pages meet L2 minimum (≥6 questions)"
else
  fail "SHALLOW" "${#shallow[@]} page(s) below L2 minimum"
  for s in "${shallow[@]}"; do detail "$s"; done
fi

# ── CHECK-03: Missing frontmatter fields ───────────────────────────────────
missing_fm=()
required_fields=("version" "status" "last_updated" "topic" "source")
while IFS= read -r -d '' file; do
  name="$(basename "$file")"
  [[ "$name" == _* ]] && continue
  rel="${file#$DISTILLED/}"
  missing=()
  for field in "${required_fields[@]}"; do
    if ! grep -q "^${field}:" "$file" 2>/dev/null; then
      missing+=("$field")
    fi
  done
  [[ ${#missing[@]} -gt 0 ]] && missing_fm+=("$rel: missing ${missing[*]}")
done < <(find "$DISTILLED" -name '*.md' -type f -print0 2>/dev/null)

if [[ ${#missing_fm[@]} -eq 0 ]]; then
  pass "FRONTMATTER" "All pages have required fields"
else
  fail "FRONTMATTER" "${#missing_fm[@]} page(s) with missing frontmatter"
  for m in "${missing_fm[@]}"; do detail "$m"; done
fi

# ── CHECK-04: Orphan pages (no inbound [[links]]) ─────────────────────────
orphans=()
while IFS= read -r -d '' file; do
  name="$(basename "$file" .md)"
  [[ "$name" == _* ]] && continue
  # Search all other .md files in distilled/ for [[name]]
  inbound=$(grep -rl "\[\[$name\]\]" "$DISTILLED" 2>/dev/null | grep -v "$file" | wc -l | tr -d ' ')
  # Also check _index.md
  in_index=$(grep -c "\[\[$name\]\]" "$INDEX" 2>/dev/null || echo 0)
  total=$((inbound + in_index))
  if [[ $total -eq 0 ]]; then
    rel="${file#$DISTILLED/}"
    orphans+=("$rel")
  fi
done < <(find "$DISTILLED" -name '*.md' -type f -not -name '_*' -print0 2>/dev/null)

if [[ ${#orphans[@]} -eq 0 ]]; then
  pass "ORPHANS" "All pages have ≥1 inbound link"
else
  warn "ORPHANS" "${#orphans[@]} page(s) with no inbound [[links]]"
  for o in "${orphans[@]}"; do detail "$o"; done
fi

# ── CHECK-05: Broken [[links]] ────────────────────────────────────────────
broken=()
while IFS= read -r -d '' file; do
  rel="${file#$DISTILLED/}"
  # Extract [[link-targets]] from file
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    # Skip special targets (_index, _log, external)
    [[ "$target" == _* ]] && continue
    # Skip known cross-repo wikilinks (repo-level files that exist in main repo, not PKB)
    # These are intentional backlinks to repo artifacts — not broken links
    case "$target" in
      CLAUDE|AGENTS|DESIGN|SEQUENCE|VALIDATE|SKILL|CHANGELOG|README) continue ;;
      architecture|project|workstream|security|task|documentation|standard|simple|friction) continue ;;
      iteration|anti-patterns|GEMINI|BLUEPRINT|charter|versioning|"Developer's guide"*) continue ;;
      agent-dispatch|context-packaging|ltc-builder|ltc-explorer|ltc-planner|ltc-reviewer) continue ;;
      brand-identity|cursor-appearance|ltc-bases-colors|ltc-folder-colors|ltc-reading-experience) continue ;;
      red.anthropic*|"Developer's"*) continue ;;
    esac
    # Check if a .md file with this name exists anywhere in distilled/
    found=$(find "$DISTILLED" -name "${target}.md" -type f 2>/dev/null | head -1)
    # Also check captured/
    [[ -z "$found" ]] && found=$(find "$CAPTURED" -name "${target}.md" -type f 2>/dev/null | head -1)
    [[ -z "$found" ]] && broken+=("$rel → [[$target]]")
  done < <(grep -oE '\[\[[^]]+' "$file" 2>/dev/null | sed 's/^\[\[//' | sed 's/|.*//' | sort -u)
done < <(find "$DISTILLED" -name '*.md' -type f -print0 2>/dev/null)

if [[ ${#broken[@]} -eq 0 ]]; then
  pass "LINKS" "All [[links]] resolve"
else
  warn "LINKS" "${#broken[@]} broken [[link(s)]]"
  for b in "${broken[@]}"; do detail "$b"; done
fi

# ── CHECK-06: Index coverage ──────────────────────────────────────────────
not_indexed=()
if [[ -f "$INDEX" ]]; then
  while IFS= read -r -d '' file; do
    name="$(basename "$file" .md)"
    [[ "$name" == _* ]] && continue
    if ! grep -q "\[\[$name\]\]" "$INDEX" 2>/dev/null; then
      rel="${file#$DISTILLED/}"
      not_indexed+=("$rel")
    fi
  done < <(find "$DISTILLED" -name '*.md' -type f -not -name '_*' -print0 2>/dev/null)
fi

if [[ ${#not_indexed[@]} -eq 0 ]]; then
  pass "INDEX" "All pages listed in _index.md"
else
  fail "INDEX" "${#not_indexed[@]} page(s) missing from _index.md"
  for n in "${not_indexed[@]}"; do detail "$n"; done
  if $FIX; then
    for n in "${not_indexed[@]}"; do
      name="$(basename "$n" .md)"
      echo "- [[$name]] — (auto-added by lint)" >> "$INDEX"
    done
    detail "AUTO-FIX: added ${#not_indexed[@]} entries to _index.md"
  fi
fi

# ── CHECK-07: Stale pages ─────────────────────────────────────────────────
stale=()
cutoff=$(date -v-${STALE_DAYS}d +%Y-%m-%d 2>/dev/null || date -d "${STALE_DAYS} days ago" +%Y-%m-%d 2>/dev/null || echo "")
if [[ -n "$cutoff" ]]; then
  while IFS= read -r -d '' file; do
    name="$(basename "$file")"
    [[ "$name" == _* ]] && continue
    updated=$(grep -m1 "^last_updated:" "$file" 2>/dev/null | sed 's/last_updated: *//' | tr -d '"' | cut -c1-10)
    if [[ -n "$updated" ]] && [[ "$updated" < "$cutoff" ]]; then
      rel="${file#$DISTILLED/}"
      stale+=("$rel (last: $updated)")
    fi
  done < <(find "$DISTILLED" -name '*.md' -type f -print0 2>/dev/null)
fi

if [[ ${#stale[@]} -eq 0 ]]; then
  pass "STALE" "No pages older than ${STALE_DAYS} days"
else
  warn "STALE" "${#stale[@]} page(s) not updated in ${STALE_DAYS}+ days"
  for s in "${stale[@]}"; do detail "$s"; done
fi

# ── CHECK-08: Log integrity ───────────────────────────────────────────────
log_ok=true
if [[ ! -f "$LOG" ]]; then
  fail "LOG" "_log.md does not exist"
  log_ok=false
elif ! grep -q "^| Date" "$LOG" 2>/dev/null && ! grep -q "^|---" "$LOG" 2>/dev/null; then
  # Allow empty log (new PKB)
  log_entries=$(grep -c "^| 20" "$LOG" 2>/dev/null || echo 0)
  if [[ $log_entries -eq 0 ]]; then
    pass "LOG" "_log.md exists (empty — no ingests yet)"
  else
    pass "LOG" "_log.md has $log_entries entries"
  fi
else
  log_entries=$(grep -c "^| 20" "$LOG" 2>/dev/null || echo 0)
  pass "LOG" "_log.md has $log_entries entries"
fi

# ── Summary ─────────────────────────────────────────────────────────────────
$JSON || echo ""

total_issues=$((issues + warnings))

if $JSON; then
  echo "{\"checks\":$checks_run,\"issues\":$issues,\"warnings\":$warnings}"
elif [[ $total_issues -eq 0 ]]; then
  printf "  ${GRN}CLEAN${RST} — %d checks, 0 issues\n" "$checks_run"
else
  printf "  %d check(s), ${RED}%d issue(s)${RST}, ${YEL}%d warning(s)${RST}\n" "$checks_run" "$issues" "$warnings"
fi

# Exit code
if $STRICT && [[ $issues -gt 0 ]]; then
  exit 1
fi
exit 0
