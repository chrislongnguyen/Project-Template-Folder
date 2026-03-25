#!/usr/bin/env bash
# validate-memory-structure.sh
# Checks that every ~/.claude/projects/*/memory/MEMORY.md contains exactly:
#   ## Agent Instructions
#   ## Briefing Card
#   ## Topic Index
# in that order. Exits 0 if all pass, 1 if any fail.

EXPECTED=("## Agent Instructions" "## Briefing Card" "## Topic Index")

total=0
pass=0
fail=0

for mem_file in ~/.claude/projects/*/memory/MEMORY.md; do
  [[ -f "$mem_file" ]] || continue

  # Extract project slug (directory name under projects/)
  slug=$(echo "$mem_file" | sed 's|.*/projects/\([^/]*\)/memory/MEMORY.md|\1|')

  # Extract ## headers in order into an array (POSIX-compatible, no mapfile)
  actual=()
  while IFS= read -r line; do
    actual+=("$line")
  done < <(grep "^## " "$mem_file")

  total=$(( total + 1 ))

  # Compare length first
  if [[ ${#actual[@]} -ne ${#EXPECTED[@]} ]]; then
    echo "FAIL: $slug — got: ${actual[*]}"
    fail=$(( fail + 1 ))
    continue
  fi

  # Compare each header in order
  mismatch=0
  for i in "${!EXPECTED[@]}"; do
    if [[ "${actual[$i]}" != "${EXPECTED[$i]}" ]]; then
      mismatch=1
      break
    fi
  done

  if [[ $mismatch -eq 1 ]]; then
    echo "FAIL: $slug — got: $(IFS='|'; echo "${actual[*]}")"
    fail=$(( fail + 1 ))
  else
    echo "PASS: $slug"
    pass=$(( pass + 1 ))
  fi
done

echo ""
echo "Checked $total files: $pass PASS, $fail FAIL"

[[ $fail -eq 0 ]] && exit 0 || exit 1
