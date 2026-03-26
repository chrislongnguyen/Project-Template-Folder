#!/usr/bin/env bash
# L3 Hook: PreToolUse — check VANA-SPEC has all required §sections
# Fires before any Write tool call targeting a *-design.md file
# Usage: pre-spec-write.sh <file_path>
# Exit code: 0 = ok to proceed, 1 = BLOCKED (missing sections)
set -euo pipefail

FILE_PATH="$1"

if [[ "$FILE_PATH" == *"-design.md"* ]]; then
  required_sections=("§0 Force Analysis" "§1 System Identity" "§2 Verb" "§3 Adverb" "§4 Noun" "§5 Adjective" "§6 System Boundaries")
  missing=()
  for section in "${required_sections[@]}"; do
    if ! grep -q "$section" "$FILE_PATH" 2>/dev/null; then
      missing+=("$section")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo "BLOCKED: VANA-SPEC missing sections: ${missing[*]}" >&2
    exit 1
  fi
fi
exit 0
