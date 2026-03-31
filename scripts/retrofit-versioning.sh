#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-29
# Retrofit version metadata on all files changed on feat/restructuring-i1 vs main.
# Idempotent — safe to run multiple times.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATE="2026-03-29"
OWNER="Long Nguyen"
DRY_RUN="${DRY_RUN:-0}"

changed=0
skipped=0
errors=0

log() { echo "[retrofit] $*"; }
log_change() { echo "  UPDATED: $1"; ((changed++)) || true; }
log_skip()   { echo "  SKIP:    $1 ($2)"; ((skipped++)) || true; }

# ── Exception predicates ─────────────────────────────────────────────────────

is_excluded_md() {
  local f="$1"
  # .gitkeep files
  [[ "$(basename "$f")" == ".gitkeep" ]] && return 0
  # test-fixtures/
  [[ "$f" == */test-fixtures/* ]] && return 0
  # archive/ directories
  [[ "$f" == */archive/* ]] && return 0
  # Project-root agent constitutions
  local rel="${f#$REPO_ROOT/}"
  [[ "$rel" == "CLAUDE.md" ]] && return 0
  [[ "$rel" == "GEMINI.md" ]] && return 0
  [[ "$rel" == "README.md" ]] && return 0
  # CHANGELOG
  [[ "$(basename "$f")" == "CHANGELOG.md" ]] && return 0
  # rules/*.md at repo root
  [[ "$rel" == rules/*.md ]] && return 0
  # Skill internal support files: references/, templates/, gotchas.md
  [[ "$f" == */.claude/skills/*/references/* ]] && return 0
  [[ "$f" == */.claude/skills/*/templates/* ]] && return 0
  [[ "$f" == */.claude/skills/*/gotchas.md ]] && return 0
  # _genesis/skills internal support files
  [[ "$f" == */_genesis/skills/*/templates/* ]] && return 0
  [[ "$f" == */_genesis/skills/*/gotchas.md ]] && return 0
  return 1
}

# ── Python helper for safe in-place edit ─────────────────────────────────────

py_patch_md() {
  python3 - "$1" "$DATE" "$OWNER" <<'PYEOF'
import sys, re

filepath = sys.argv[1]
date     = sys.argv[2]
owner    = sys.argv[3]

with open(filepath, 'r', encoding='utf-8') as fh:
    content = fh.read()

# Detect frontmatter
fm_match = re.match(r'^---\s*\n(.*?\n)---\s*\n', content, re.DOTALL)

if fm_match:
    fm_body = fm_match.group(1)
    rest    = content[fm_match.end():]

    # Skip malformed frontmatter (contains markdown headings like ## inside)
    if re.search(r'^##', fm_body, re.MULTILINE):
        sys.exit(2)  # signal: malformed, skip

    has_version      = bool(re.search(r'^version\s*:', fm_body, re.MULTILINE))
    has_last_updated = bool(re.search(r'^last_updated\s*:', fm_body, re.MULTILINE))
    has_owner        = bool(re.search(r'^owner\s*:', fm_body, re.MULTILINE))

    modified = False

    # Update last_updated if present
    if has_last_updated:
        new_body, n = re.subn(r'^(last_updated\s*:).*$', rf'\1 {date}', fm_body, flags=re.MULTILINE)
        if n and new_body != fm_body:
            fm_body = new_body
            modified = True

    # Add missing fields in order: version, last_updated, owner
    lines = fm_body.splitlines()
    insertions = []
    if not has_version:
        insertions.append(('version: "1.0"', 0))
        modified = True
    if not has_last_updated:
        insertions.append((f'last_updated: {date}', 1))
        modified = True
    if not has_owner:
        insertions.append((f'owner: "{owner}"', 2))
        modified = True

    if insertions:
        prefix_lines = []
        for text, _ in insertions:
            prefix_lines.append(text)
        fm_body = '\n'.join(prefix_lines) + '\n' + fm_body

    if not modified:
        sys.exit(0)  # no changes needed

    new_content = '---\n' + fm_body + '---\n' + rest

else:
    # No frontmatter — prepend it
    fm = f'---\nversion: "1.0"\nlast_updated: {date}\nowner: "{owner}"\n---\n\n'
    new_content = fm + content
    modified = True

if modified:
    with open(filepath, 'w', encoding='utf-8') as fh:
        fh.write(new_content)
    sys.exit(1)  # signal: changed

sys.exit(0)  # no change
PYEOF
}

py_patch_sh() {
  python3 - "$1" "$DATE" <<'PYEOF'
import sys, re

filepath = sys.argv[1]
date     = sys.argv[2]

with open(filepath, 'r', encoding='utf-8') as fh:
    lines = fh.readlines()

VERSION_RE = re.compile(r'^#\s*version:\s*\S+\s*\|\s*last_updated:\s*\S+')
SHEBANG_RE = re.compile(r'^#!')

# Check first 10 lines
for i, line in enumerate(lines[:10]):
    if VERSION_RE.match(line):
        new_line = re.sub(r'last_updated:\s*\S+', f'last_updated: {date}', line)
        if new_line != line:
            lines[i] = new_line
            with open(filepath, 'w', encoding='utf-8') as fh:
                fh.writelines(lines)
            sys.exit(1)
        sys.exit(0)

# Not found — insert after shebang (line 0) if present, else at line 1
insert_at = 1
if lines and SHEBANG_RE.match(lines[0]):
    insert_at = 1
elif not lines:
    insert_at = 0

version_line = f'# version: 1.0 | last_updated: {date}\n'
lines.insert(insert_at, version_line)

with open(filepath, 'w', encoding='utf-8') as fh:
    fh.writelines(lines)
sys.exit(1)
PYEOF
}

py_patch_html() {
  python3 - "$1" "$DATE" <<'PYEOF'
import sys, re

filepath = sys.argv[1]
date     = sys.argv[2]

with open(filepath, 'r', encoding='utf-8') as fh:
    content = fh.read()

VERSION_META   = re.compile(r'<meta\s+name=["\']version["\']', re.IGNORECASE)
UPDATED_META   = re.compile(r'<meta\s+name=["\']last-updated["\']', re.IGNORECASE)
CHARSET_META   = re.compile(r'(<meta\s+charset[^>]*>)', re.IGNORECASE)

modified = False

if VERSION_META.search(content):
    new_content = re.sub(
        r'(<meta\s+name=["\']version["\']\s+content=["\'])([^"\']*)(["\']\s*>)',
        r'\g<1>1.0\g<3>', content, flags=re.IGNORECASE)
    if new_content != content:
        content = new_content
        modified = True
else:
    inject = '<meta name="version" content="1.0">\n    <meta name="last-updated" content="' + date + '">'
    m = CHARSET_META.search(content)
    if m:
        content = content[:m.end()] + '\n    ' + inject + content[m.end():]
    else:
        content = content.replace('<head>', '<head>\n    ' + inject, 1)
    modified = True

if UPDATED_META.search(content):
    new_content = re.sub(
        r'(<meta\s+name=["\']last-updated["\']\s+content=["\'])([^"\']*)(["\']\s*>)',
        rf'\g<1>{date}\g<3>', content, flags=re.IGNORECASE)
    if new_content != content:
        content = new_content
        modified = True

if modified:
    with open(filepath, 'w', encoding='utf-8') as fh:
        fh.write(content)
    sys.exit(1)

sys.exit(0)
PYEOF
}

# ── Main loop ─────────────────────────────────────────────────────────────────

cd "$REPO_ROOT"

CHANGED_FILES="$(git diff main --name-only | sort)"
total=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')

log "Processing $total changed files..."
echo ""

while IFS= read -r rel; do
  [[ -z "$rel" ]] && continue
  abs="$REPO_ROOT/$rel"

  # Skip if file doesn't exist (deleted files)
  [[ -f "$abs" ]] || { log_skip "$rel" "deleted/missing"; continue; }

  ext="${rel##*.}"

  case "$ext" in
    md)
      if is_excluded_md "$abs"; then
        log_skip "$rel" "excluded"
        continue
      fi

      if [[ "$DRY_RUN" == "1" ]]; then
        log_change "$rel (dry-run)"
        continue
      fi

      rc=0; py_patch_md "$abs" || rc=$?
      if   [[ $rc -eq 1 ]]; then log_change "$rel"
      elif [[ $rc -eq 2 ]]; then log_skip   "$rel" "malformed frontmatter"
      # rc=0 = no change needed, silent
      fi
      ;;

    sh)
      if [[ "$DRY_RUN" == "1" ]]; then
        log_change "$rel (dry-run)"
        continue
      fi
      rc=0; py_patch_sh "$abs" || rc=$?
      [[ $rc -eq 1 ]] && log_change "$rel"
      ;;

    py)
      if [[ "$DRY_RUN" == "1" ]]; then
        log_change "$rel (dry-run)"
        continue
      fi
      rc=0; py_patch_sh "$abs" || rc=$?   # same logic for .py
      [[ $rc -eq 1 ]] && log_change "$rel"
      ;;

    html)
      if [[ "$DRY_RUN" == "1" ]]; then
        log_change "$rel (dry-run)"
        continue
      fi
      rc=0; py_patch_html "$abs" || rc=$?
      [[ $rc -eq 1 ]] && log_change "$rel"
      ;;

    *)
      # Non-targeted extension — skip silently
      ;;
  esac
done <<< "$CHANGED_FILES"

echo ""
log "Done. changed=$changed skipped=$skipped errors=$errors"
