#!/usr/bin/env bash
# session-reconstruct.sh — SessionStart hook (Layer 2 reconstruction)
# Emits git state + cross-project landscape + last session summary as JSON
# for the Claude Code plugin system.
set -euo pipefail

PROJECTS_DIR="$HOME/.claude/projects"

emit_git_state() {
  git rev-parse --git-dir >/dev/null 2>&1 || return 0
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "unknown")
  echo "## Git State"
  echo "Branch: \`${branch}\`"
  local log
  log=$(git log --oneline -10 2>/dev/null || true)
  if [[ -n "$log" ]]; then
    echo "### Recent (last 10 commits)"
    echo '```'
    echo "$log"
    echo '```'
  fi
  local status
  status=$(git status --short 2>/dev/null | head -15 || true)
  echo "### Working Tree"
  if [[ -n "$status" ]]; then
    echo '```'
    echo "$status"
    echo '```'
  else
    echo "Clean"
  fi
  local diffstat
  diffstat=$(git diff --stat HEAD~3 2>/dev/null || true)
  if [[ -n "$diffstat" ]]; then
    echo "### Recent Changes"
    echo '```'
    echo "$diffstat"
    echo '```'
  fi
  echo ""
}

emit_cross_project() {
  [[ -d "$PROJECTS_DIR" ]] || return 0
  local cwd_encoded
  cwd_encoded=$(pwd | sed 's|[/_.]|-|g')
  local found=0
  local output=""
  for memory_file in "$PROJECTS_DIR"/*/memory/MEMORY.md; do
    [[ -f "$memory_file" ]] || continue
    local proj_dir
    proj_dir=$(echo "$memory_file" | sed "s|${PROJECTS_DIR}/||" | cut -d'/' -f1)
    [[ "$proj_dir" == "$cwd_encoded" ]] && continue
    local proj_name
    proj_name=$(sed -n 's/^# Session Memory — //p' "$memory_file" | head -1)
    [[ -z "$proj_name" ]] && proj_name="$proj_dir"
    local card
    card=$(sed -n '/^## Briefing Card$/,/^## /{/^## Briefing Card$/d;/^## /d;p;}' "$memory_file" | \
           sed '/^$/d' | head -4)
    [[ -z "$card" ]] && continue
    output+="**${proj_name}**"$'\n'
    output+="${card}"$'\n'$'\n'
    found=1
  done
  if [[ $found -eq 1 ]]; then
    echo "## Cross-Project Landscape"
    echo "$output"
  fi
}

emit_last_session() {
  [[ -d "$PROJECTS_DIR" ]] || return 0
  local cwd_encoded
  cwd_encoded=$(pwd | sed 's|[/_.]|-|g')
  local proj_path="$PROJECTS_DIR/$cwd_encoded"
  [[ -d "$proj_path" ]] || return 0
  local summary=""
  while IFS= read -r -d '' candidate; do
    summary="$candidate"
    break
  done < <(find "$proj_path" -name "summary.md" -path "*/session-memory/*" -print0 2>/dev/null | head -z -1 2>/dev/null || true)
  if [[ -z "$summary" ]]; then
    for candidate in "$proj_path"/*/session-memory/summary.md "$proj_path"/session-memory/summary.md; do
      if [[ -f "$candidate" ]]; then
        summary="$candidate"
        break
      fi
    done
  fi
  [[ -n "$summary" && -f "$summary" ]] || return 0
  echo "## Last Session"
  head -20 "$summary"
  echo ""
}

main() {
  emit_git_state
  emit_cross_project
  emit_last_session
}

# Collect output
OUTPUT=$(main)

# If empty, exit silently
[[ -z "$OUTPUT" ]] && exit 0

# JSON-escape the output
ESCAPED=$(echo "$OUTPUT" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read())[1:-1])')

# Emit JSON for Claude Code plugin system
cat <<ENDJSON
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${ESCAPED}"
  }
}
ENDJSON
