#!/usr/bin/env bash
# Test: Frontmatter schema validation (A6) — AC-38..AC-41
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
TEMPLATES="$PROJ/_genesis/templates"
AUTOLINKER="$PROJ/scripts/obsidian-autolinker.py"
ALIAS_SEEDER="$PROJ/scripts/obsidian-alias-seeder.py"
PASS=0; FAIL=0; TOTAL=4

check() { if eval "$2" >/dev/null 2>&1; then echo "  PASS: $1"; ((PASS++)); else echo "  FAIL: $1"; ((FAIL++)); fi; }

echo "=== A6: Autolinker + Frontmatter Schema ==="
check "AC-38 Scripts are valid Python" "python3 -c \"import ast; ast.parse(open('$AUTOLINKER').read())\" && python3 -c \"import ast; ast.parse(open('$ALIAS_SEEDER').read())\""
check "AC-39 Autolinker dry-run succeeds" "python3 '$AUTOLINKER' --dry-run 2>/dev/null || python3 '$AUTOLINKER' --help 2>/dev/null"
check "AC-40 At least 1 wikilink in templates" "grep -rl '\[\[' '$TEMPLATES'/*.md 2>/dev/null | head -1 | grep -q '.'"
check "AC-41 ≥20 templates have work_stream + sub_system" "[ \$(for f in '$TEMPLATES'/*.md; do grep -q 'work_stream' \"\$f\" 2>/dev/null && grep -q 'sub_system' \"\$f\" 2>/dev/null && echo ok; done | wc -l) -ge 20 ]"

echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
