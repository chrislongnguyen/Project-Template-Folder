#!/usr/bin/env bash
# version: 1.3 | status: Draft | last_updated: 2026-04-05
# session-reconstruct.sh — SessionStart hook (Layer 2 reconstruction)
# Emits git state + cross-project landscape + last session summary as JSON
# for the Claude Code plugin system.
#
# NOTE: This hook reads from ~/.claude/projects/ (Claude Code's own memory)
# and git state. No vault dependency — works on any machine with Claude Code.
#
# Dedup: if a global version is running via CLAUDE_PLUGIN_ROOT, skip this one.
set -euo pipefail

# Dedup guard: skip if global/plugin version is handling this event
if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" ]] && [[ -x "${CLAUDE_PLUGIN_ROOT}/hooks/session-reconstruct.sh" ]]; then
  exit 0
fi

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

emit_pipeline_state() {
  local state_dir="$HOME/.claude/state"
  [[ -d "$state_dir" ]] || state_dir="$(git rev-parse --show-toplevel 2>/dev/null)/.claude/state" 2>/dev/null || return 0
  local pipeline_file
  # Check vault path first (state-saver writes here)
  for candidate in "$HOME/LTC/LongHNguyen/07-Claude/state/pipeline.json" "$state_dir/pipeline.json"; do
    if [[ -f "$candidate" ]]; then
      pipeline_file="$candidate"
      break
    fi
  done
  [[ -n "${pipeline_file:-}" && -f "$pipeline_file" ]] || return 0
  echo "## Pipeline State"
  python3 -c "
import json
with open('$pipeline_file') as f:
    s = json.load(f)
print(f\"Workstream: {s.get('workstream','?')} | Stage: {s.get('stage','?')} | Task: {s.get('task_id','?')}\")
print(f\"Last agent: {s.get('last_sub_agent','?')} | Result: {s.get('last_result','?')}\")
done = s.get('completed_tasks', [])
if done:
    print(f\"Completed: {', '.join(done[-5:])}\")
" 2>/dev/null || echo "(pipeline state unreadable)"
  echo ""
}

emit_last_session() {
  [[ -d "$PROJECTS_DIR" ]] || return 0
  local cwd_encoded
  cwd_encoded=$(pwd | sed 's|[/_.]|-|g')
  local proj_path="$PROJECTS_DIR/$cwd_encoded"
  [[ -d "$proj_path" ]] || return 0
  local summary=""
  for candidate in "$proj_path"/*/session-memory/summary.md "$proj_path"/session-memory/summary.md; do
    if [[ -f "$candidate" ]]; then
      summary="$candidate"
      break
    fi
  done
  [[ -n "$summary" && -f "$summary" ]] || return 0
  echo "## Last Session"
  head -20 "$summary"
  echo ""
}

main() {
  emit_git_state
  emit_pipeline_state
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
