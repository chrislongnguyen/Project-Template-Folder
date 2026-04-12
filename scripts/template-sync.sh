#!/usr/bin/env bash
# version: 3.2 | status: draft | last_updated: 2026-04-12
# LTC Project Template — Additive Sync Script
# Supports: --auto-add, --file/--action, --verify, --detect-path, --sync <version>, --reverse-clone <source>
# NEVER deletes local files.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || echo ".")"
OVERRIDE_REPO_ROOT=""   # set by --repo-root flag; overrides REPO_ROOT and detect-path target

LOG_FILE="${REPO_ROOT}/.template-sync-log.json"
CHECKPOINT_FILE="${REPO_ROOT}/.template-checkpoint.yml"
REMOTE="template"
BRANCH="main"
REF="${REMOTE}/${BRANCH}"

# --- Require jq ---
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install: brew install jq" >&2
  exit 2
fi

# --- Require python3 (for YAML read/write) ---
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is required." >&2
  exit 2
fi

# --- Abort guard: NEVER delete ---
# Checked at every checkout to ensure we never call rm or git clean
assert_no_delete() {
  : # operations in this script only add/checkout — never rm or git clean
}

# --- Logging ---
log_action() {
  local file="$1" action="$2" reason="${3:-}"
  local entry
  entry=$(jq -n \
    --arg f "$file" --arg a "$action" --arg r "$reason" --arg t "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    '{file: $f, action: $a, reason: $r, timestamp: $t}')
  if [[ -f "$LOG_FILE" ]]; then
    local tmp
    tmp=$(mktemp)
    jq ". += [$entry]" "$LOG_FILE" > "$tmp" && mv "$tmp" "$LOG_FILE"
  else
    jq -n "[$entry]" > "$LOG_FILE"
  fi
}

# --- Mode: --auto-add ---
do_auto_add() {
  local input_file="$1"
  local files_json
  if [[ "$input_file" == "-" ]]; then
    files_json=$(cat)
  else
    files_json=$(cat "$input_file")
  fi

  local added=0
  local reclassified=0

  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    # Fix #4: pre-check — if file already exists locally, reclassify to merge
    if [[ -f "$f" ]]; then
      echo "RECLASSIFY merge: $f (exists locally — use --file to handle)" >&2
      log_action "$f" "reclassified_to_merge" "file exists locally"
      (( reclassified++ )) || true
      continue
    fi
    # Ensure parent directory exists
    mkdir -p "$(dirname "$f")"
    git checkout "$REF" -- "$f"
    # Leave unstaged — do NOT stage
    git restore --staged "$f" 2>/dev/null || true
    echo "added: $f"
    log_action "$f" "auto_add" ""
    (( added++ )) || true
  done < <(echo "$files_json" | jq -r '.[]' | tr -d '\r')

  echo ""
  echo "auto-add complete: added=$added reclassified=$reclassified"
  echo "All files are UNSTAGED. Stage per-file before committing."
  echo "  git add <file>"
  echo "  git commit -m \"chore(govern): sync with project template\""
}

# --- Mode: --file --action ---
do_file_action() {
  local file="$1" action="$2"
  case "$action" in
    take)
      if [[ -f "$file" ]]; then
        echo "WARNING: $file exists locally. Overwriting with template version."
      fi
      mkdir -p "$(dirname "$file")"
      git checkout "$REF" -- "$file"
      git restore --staged "$file" 2>/dev/null || true
      echo "taken (unstaged): $file"
      log_action "$file" "take" "user explicit"
      ;;
    skip)
      echo "skipped: $file"
      log_action "$file" "skip" "user explicit"
      ;;
    *)
      echo "Error: --action must be 'take' or 'skip'" >&2
      exit 2
      ;;
  esac
}

# --- Mode: --detect-path ---
do_detect_path() {
  # Detect the CWD repo (caller's repo), not the script's home repo.
  # --repo-root flag overrides when caller needs to point at a specific path.
  local target_root
  if [ -n "${OVERRIDE_REPO_ROOT:-}" ]; then
    target_root="$OVERRIDE_REPO_ROOT"
  else
    target_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
  fi

  # Commit count check — 0 or 1 commits = fresh clone
  local commit_count
  commit_count=$(git -C "$target_root" rev-list --count HEAD 2>/dev/null || echo 0)

  if [ "$commit_count" -le 1 ]; then
    echo "PATH A"
    return 0
  fi

  # ALPEI structure check
  if [ ! -d "${target_root}/1-ALIGN" ] || [ ! -d "${target_root}/.claude/rules" ]; then
    echo "PATH B"
    return 0
  fi

  echo "PATH C"
}

# --- YAML helpers (python3, Bash 3 compatible) ---
# Read a scalar field from a simple YAML file.
# Usage: yaml_get <file> <key>
yaml_get() {
  local file="$1" key="$2"
  python3 - "$file" "$key" <<'PYEOF'
import sys, re
fname, key = sys.argv[1], sys.argv[2]
try:
    with open(fname) as f:
        for line in f:
            line = line.rstrip('\n')
            m = re.match(r'^' + re.escape(key) + r'\s*:\s*"?([^"#\n]*)"?\s*(?:#.*)?$', line)
            if m:
                print(m.group(1).strip())
                sys.exit(0)
except IOError:
    pass
# return empty string if not found
print('')
PYEOF
}

# Write (or overwrite) .template-checkpoint.yml with given fields.
# Usage: write_checkpoint <last_sync_sha> <last_sync_date> <template_version> <migration_path> <history_json>
write_checkpoint() {
  local sha="$1" date="$2" version="$3" path="$4" history="$5"
  local remote_url
  remote_url=$(git -C "$REPO_ROOT" remote get-url "$REMOTE" 2>/dev/null || echo "")

  python3 - "$CHECKPOINT_FILE" "$sha" "$date" "$version" "$path" "$history" "$remote_url" <<'PYEOF'
import sys, json

fname       = sys.argv[1]
sha         = sys.argv[2]
date        = sys.argv[3]
version     = sys.argv[4]
path        = sys.argv[5]
history_raw = sys.argv[6]
remote_url  = sys.argv[7]

try:
    history = json.loads(history_raw)
except Exception:
    history = []

lines = [
    '# Template sync checkpoint — populated by template-sync.sh on every sync.',
    '# Downstream repos: populate this file after first sync from the LTC Project Template.',
    '# DO NOT edit manually unless recovering from a failed sync.',
    '',
    '# version of this checkpoint file format',
    'schema_version: "1.0"',
    '',
    '# git SHA of the template commit at last sync (empty = never synced / bootstrap needed)',
    'last_sync_sha: "{}"'.format(sha),
    '',
    '# ISO date of last sync (YYYY-MM-DD)',
    'last_sync_date: "{}"'.format(date),
    '',
    '# semver tag of template at last sync (e.g. "v2.0.0")',
    'template_version: "{}"'.format(version),
    '',
    '# URL of the template remote — used by template-sync.sh to auto-add remote',
    'template_remote_url: "{}"'.format(remote_url),
    '',
    '# migration path used: A (fresh clone), B (reverse clone), or C (version upgrade)',
    'migration_path: "{}"'.format(path),
    '',
    '# list of prior sync records — prepend a new entry after each successful sync',
    'sync_history:',
]

if not history:
    lines.append('  []')
else:
    for entry in history:
        lines.append('  - sha: "{}"'.format(entry.get('sha', '')))
        lines.append('    version: "{}"'.format(entry.get('version', '')))
        lines.append('    date: "{}"'.format(entry.get('date', '')))

with open(fname, 'w') as f:
    f.write('\n'.join(lines) + '\n')
PYEOF
}

# Read sync_history array from checkpoint as JSON array string.
read_checkpoint_history() {
  python3 - "$CHECKPOINT_FILE" <<'PYEOF'
import sys, re, json

fname = sys.argv[1]
try:
    with open(fname) as f:
        content = f.read()
except IOError:
    print('[]')
    sys.exit(0)

# Simple YAML list parser for sync_history
entries = []
in_history = False
current = {}
for line in content.splitlines():
    if re.match(r'^sync_history\s*:', line):
        in_history = True
        continue
    if in_history:
        # stop if we hit a new top-level key
        if line and not line.startswith(' ') and not line.startswith('\t') and not line.startswith('#'):
            break
        m = re.match(r'^\s+-\s+sha\s*:\s*"?([^"#\n]*)"?\s*$', line)
        if m:
            if current:
                entries.append(current)
            current = {'sha': m.group(1).strip()}
            continue
        m = re.match(r'^\s+version\s*:\s*"?([^"#\n]*)"?\s*$', line)
        if m and current is not None:
            current['version'] = m.group(1).strip()
            continue
        m = re.match(r'^\s+date\s*:\s*"?([^"#\n]*)"?\s*$', line)
        if m and current is not None:
            current['date'] = m.group(1).strip()
            continue

if current:
    entries.append(current)

print(json.dumps(entries))
PYEOF
}

# Resolve the full SHA for a git tag from the template remote.
# Usage: resolve_remote_tag <tag>  → prints sha or exits 1
resolve_remote_tag() {
  local tag="$1"
  local sha
  # First try local tags (already fetched)
  sha=$(git -C "$REPO_ROOT" rev-parse --verify "refs/tags/${tag}^{}" 2>/dev/null || true)
  if [ -n "$sha" ]; then
    echo "$sha"
    return 0
  fi
  # Try ls-remote
  sha=$(git -C "$REPO_ROOT" ls-remote "$REMOTE" "refs/tags/${tag}" 2>/dev/null | awk '{print $1}' | head -1 || true)
  if [ -n "$sha" ]; then
    echo "$sha"
    return 0
  fi
  echo "Error: tag '${tag}' not found on remote '${REMOTE}'. Check the version and retry." >&2
  return 1
}

# --- Mode: --sync <target-version> ---
do_sync() {
  local target_version="$1"
  # Strip leading 'v' for display, keep for tag resolution
  local tag="$target_version"
  # Normalise: ensure tag starts with 'v'
  case "$tag" in
    v*) ;;
    *) tag="v${tag}" ;;
  esac
  local today
  today=$(date +%Y-%m-%d)

  echo "template-sync --sync ${tag}"
  echo "==============================="

  # [1] Read checkpoint
  local last_sync_sha last_sync_version history_json
  last_sync_sha=""
  last_sync_version=""
  history_json="[]"

  if [ -f "$CHECKPOINT_FILE" ]; then
    last_sync_sha=$(yaml_get "$CHECKPOINT_FILE" "last_sync_sha")
    last_sync_version=$(yaml_get "$CHECKPOINT_FILE" "template_version")
    history_json=$(read_checkpoint_history)
  fi

  if [ -z "$last_sync_sha" ]; then
    # BOOTSTRAP MODE
    echo ""
    echo "No checkpoint found. What template version was this repo originally cloned from? (e.g., v2.0.0)"
    printf "> "
    local bootstrap_version
    read -r bootstrap_version
    case "$bootstrap_version" in
      v*) ;;
      *) bootstrap_version="v${bootstrap_version}" ;;
    esac
    echo "Resolving SHA for ${bootstrap_version}..."
    last_sync_sha=$(resolve_remote_tag "$bootstrap_version") || exit 1
    last_sync_version="$bootstrap_version"
    echo "Resolved ${bootstrap_version} → ${last_sync_sha}"
    # Write initial checkpoint
    write_checkpoint "$last_sync_sha" "$today" "$last_sync_version" "C" "[]"
    echo "Checkpoint initialised."
    echo ""
  fi

  # [2] Fetch template remote, resolve target SHA
  echo "[2] Fetching template remote..."
  git -C "$REPO_ROOT" fetch "$REMOTE" 2>/dev/null || {
    echo "Warning: could not fetch remote '${REMOTE}'. Proceeding with local refs." >&2
  }
  local target_sha
  target_sha=$(resolve_remote_tag "$tag") || exit 1
  echo "    ${tag} → ${target_sha}"

  # [3] Compute pristine diff
  echo "[3] Computing pristine diff: ${last_sync_sha:0:7} → ${target_sha:0:7} ..."
  local diff_script="${SCRIPT_DIR}/template-diff.sh"
  if [ ! -f "$diff_script" ]; then
    echo "Error: template-diff.sh not found at ${diff_script}" >&2
    exit 1
  fi

  local diff_output
  diff_output=$(bash "$diff_script" \
    --from-sha "$last_sync_sha" \
    --to-sha   "$target_sha" \
    --from-version "$last_sync_version" \
    --to-version   "$tag" \
    --format json) || {
    echo "Error: template-diff.sh failed — aborting sync." >&2
    exit 1
  }

  local total_changes
  total_changes=$(echo "$diff_output" | jq '.total_changes')
  echo "    ${total_changes} file(s) changed"

  # [4] + [5] + [6] Apply strategy per file, log all actions
  local merge_script="${SCRIPT_DIR}/template-merge-engine.sh"
  local count_auto=0 count_merge=0 count_skip=0 count_conflict=0 count_deprecated=0

  while IFS= read -r entry; do
    local fpath fstrategy fchange
    fpath=$(echo "$entry"     | jq -r '.path')
    fstrategy=$(echo "$entry" | jq -r '.strategy')
    fchange=$(echo "$entry"   | jq -r '.change_type')

    case "$fstrategy" in
      auto-take)
        mkdir -p "${REPO_ROOT}/$(dirname "$fpath")"
        git -C "$REPO_ROOT" checkout "${REMOTE}/${BRANCH}" -- "$fpath" 2>/dev/null || \
          git -C "$REPO_ROOT" checkout "$target_sha" -- "$fpath" 2>/dev/null || {
            echo "  CONFLICT (checkout failed): ${fpath}" >&2
            log_action "$fpath" "conflict" "checkout failed"
            count_conflict=$((count_conflict + 1))
            continue
          }
        git -C "$REPO_ROOT" restore --staged "$fpath" 2>/dev/null || true
        echo "  auto-taken: ${fpath}"
        log_action "$fpath" "auto_take" "strategy=auto-take change=${fchange}"
        count_auto=$((count_auto + 1))
        ;;
      section-merge|3-way-merge)
        if [ -f "$merge_script" ]; then
          bash "$merge_script" "$fstrategy" \
            --repo-root  "$REPO_ROOT" \
            --file       "$fpath" \
            --from-sha   "$last_sync_sha" \
            --to-sha     "$target_sha" \
            --remote     "$REMOTE" \
            --branch     "$BRANCH" 2>/dev/null || {
            echo "  CONFLICT (merge engine failed): ${fpath}"
            log_action "$fpath" "conflict" "merge engine failed for strategy=${fstrategy}"
            count_conflict=$((count_conflict + 1))
            continue
          }
          echo "  merged (${fstrategy}): ${fpath}"
          log_action "$fpath" "merge" "strategy=${fstrategy} change=${fchange}"
          count_merge=$((count_merge + 1))
        else
          echo "  CONFLICT (merge engine missing): ${fpath}"
          log_action "$fpath" "conflict" "merge engine not found; strategy=${fstrategy}"
          count_conflict=$((count_conflict + 1))
        fi
        ;;
      skip)
        echo "  skipped: ${fpath} (domain file)"
        log_action "$fpath" "skip" "strategy=skip change=${fchange}"
        count_skip=$((count_skip + 1))
        ;;
      flag-deprecated)
        echo "  DEPRECATED: ${fpath} — removed from template; review for local deletion"
        log_action "$fpath" "flag_deprecated" "strategy=flag-deprecated change=${fchange}"
        count_deprecated=$((count_deprecated + 1))
        ;;
      conflict)
        echo "  CONFLICT: ${fpath} — template file was modified locally; manual resolution needed"
        log_action "$fpath" "conflict" "strategy=conflict change=${fchange}"
        count_conflict=$((count_conflict + 1))
        ;;
      *)
        echo "  CONFLICT (unknown strategy '${fstrategy}'): ${fpath}"
        log_action "$fpath" "conflict" "unknown strategy=${fstrategy}"
        count_conflict=$((count_conflict + 1))
        ;;
    esac
  done < <(echo "$diff_output" | jq -c '.changeset[]')

  # [6] Summary
  echo ""
  echo "Sync summary: auto-taken=${count_auto} merged=${count_merge} skipped=${count_skip} conflicts=${count_conflict} deprecated=${count_deprecated}"
  echo ""

  # [7] Verify (skip if script missing)
  local verify_script="${SCRIPT_DIR}/template-verify.sh"
  if [ -f "$verify_script" ]; then
    echo "[7] Running template-verify.sh ..."
    if ! bash "$verify_script"; then
      echo ""
      echo "ERROR: template-verify.sh reported failures. Checkpoint NOT updated." >&2
      echo "Fix the failures above, then re-run --sync to update the checkpoint." >&2
      exit 1
    fi
    echo "    Verify passed."
  else
    echo "[7] template-verify.sh not found — skipping verification step."
  fi

  # [8] Update checkpoint — ONLY after verify passes (or is missing)
  local old_sha_short="${last_sync_sha:0:7}"
  local old_version="$last_sync_version"

  # Prepend old entry to history
  local new_history
  new_history=$(python3 - "$history_json" "$old_sha_short" "$old_version" "$today" <<'PYEOF'
import sys, json
existing = json.loads(sys.argv[1])
new_entry = {'sha': sys.argv[2], 'version': sys.argv[3], 'date': sys.argv[4]}
# prepend
updated = [new_entry] + existing
print(json.dumps(updated))
PYEOF
)

  write_checkpoint "$target_sha" "$today" "$tag" "C" "$new_history"
  echo "[8] Checkpoint updated: last_sync_sha=${target_sha:0:7} template_version=${tag}"

  # [9] Guidance
  echo ""
  echo "Sync complete. Run: git add -p && git commit -m 'chore(govern): sync with template ${tag}'"
}

# --- Mode: --reverse-clone ---
# Read-only operation: classifies files in a source repo and outputs a YAML triage manifest.
# NEVER modifies the source repo or the current working directory.
do_reverse_clone() {
  local source_repo="$1"

  # Validate source repo path
  if [[ ! -d "${source_repo}/.git" ]]; then
    echo "ERROR: ${source_repo} is not a git repository" >&2
    exit 1
  fi

  # Get all tracked files from source repo (read-only)
  local source_files
  source_files=$(git -C "$source_repo" ls-files)

  # Output triage manifest header
  echo "# Reverse-Clone Triage Manifest"
  echo "# Source: ${source_repo}"
  echo "# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# Instructions: Copy files marked 'keep' into the fresh template clone."
  echo ""
  echo "source_repo: \"${source_repo}\""
  echo "generated: \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\""
  echo "files:"

  local keep_count=0
  local skip_count=0
  local merge_count=0

  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    local lineage
    lineage=$(bash "${SCRIPT_DIR}/template-manifest.sh" --classify "$f" 2>/dev/null || echo "unknown")

    case "$lineage" in
      domain)
        echo "  - path: \"${f}\""
        echo "    action: keep"
        echo "    reason: \"User-created domain content — port to new clone\""
        (( keep_count++ )) || true
        ;;
      shared)
        echo "  - path: \"${f}\""
        echo "    action: manual-merge"
        echo "    reason: \"Shared file — review your customizations and re-apply to new clone\""
        (( merge_count++ )) || true
        ;;
      template)
        echo "  - path: \"${f}\""
        echo "    action: skip"
        echo "    reason: \"Template file — fresh clone provides this\""
        (( skip_count++ )) || true
        ;;
      domain-seed)
        echo "  - path: \"${f}\""
        echo "    action: replace"
        echo "    reason: \"Scaffold file — replace with your content in new clone\""
        (( skip_count++ )) || true
        ;;
      deprecated)
        echo "  - path: \"${f}\""
        echo "    action: delete"
        echo "    reason: \"Deprecated in v2.0.0 — do not port\""
        (( skip_count++ )) || true
        ;;
      *)
        echo "  - path: \"${f}\""
        echo "    action: review"
        echo "    reason: \"Unknown lineage — manual review required\""
        (( merge_count++ )) || true
        ;;
    esac
  done <<< "$source_files"

  echo ""
  echo "summary:"
  echo "  keep: ${keep_count}"
  echo "  manual_merge: ${merge_count}"
  echo "  skip: ${skip_count}"
  echo "  total: $(( keep_count + merge_count + skip_count ))"
}

# --- Mode: --verify ---
do_verify() {
  local pass=0 fail=0

  echo "template-sync --verify"
  echo "======================"

  # AC-1: Log file exists
  if [[ -f "$LOG_FILE" ]]; then
    echo "AC-1 PASS: $LOG_FILE exists"
    (( pass++ )) || true
  else
    echo "AC-1 FAIL: $LOG_FILE not found — no sync actions recorded"
    (( fail++ )) || true
  fi

  # AC-2: Decisions recorded (log has entries)
  if [[ -f "$LOG_FILE" ]]; then
    local count
    count=$(jq 'length' "$LOG_FILE")
    if [[ "$count" -gt 0 ]]; then
      echo "AC-2 PASS: $count actions logged"
      (( pass++ )) || true
    else
      echo "AC-2 FAIL: log is empty"
      (( fail++ )) || true
    fi
  else
    echo "AC-2 SKIP: no log file"
    (( fail++ )) || true
  fi

  # AC-3: No deletions in log
  if [[ -f "$LOG_FILE" ]]; then
    local deletes
    deletes=$(jq '[.[] | select(.action == "delete")] | length' "$LOG_FILE")
    if [[ "$deletes" -eq 0 ]]; then
      echo "AC-3 PASS: no delete actions in log"
      (( pass++ )) || true
    else
      echo "AC-3 FAIL: $deletes delete actions found — violation"
      (( fail++ )) || true
    fi
  else
    echo "AC-3 SKIP: no log file"
    (( fail++ )) || true
  fi

  # AC-4: Added files are unstaged (not in index as staged)
  if [[ -f "$LOG_FILE" ]]; then
    local staged_count=0
    while IFS= read -r f; do
      if git diff --cached --name-only | grep -qxF "$f"; then
        echo "AC-4 WARN: $f is staged (should be unstaged)"
        (( staged_count++ )) || true
      fi
    done < <(jq -r '.[] | select(.action == "auto_add" or .action == "take") | .file' "$LOG_FILE" | tr -d '\r')
    if [[ "$staged_count" -eq 0 ]]; then
      echo "AC-4 PASS: all added files are unstaged"
      (( pass++ )) || true
    else
      echo "AC-4 FAIL: $staged_count files are staged — review before committing"
      (( fail++ )) || true
    fi
  else
    echo "AC-4 SKIP: no log file"
    (( fail++ )) || true
  fi

  echo ""
  echo "Result: $pass/4 passed"
  [[ "$fail" -eq 0 ]]
}

# --- Help ---
do_help() {
  cat <<'EOF'
template-sync.sh — LTC Project Template Sync (v3.1)

USAGE:
  template-sync.sh --detect-path
  template-sync.sh --sync <target-version>
  template-sync.sh --auto-add [--input <file>]
  template-sync.sh --file <path> --action <take|skip>
  template-sync.sh --verify
  template-sync.sh --reverse-clone <source-repo-path>
  template-sync.sh --help

MODES:

  --detect-path
      Detects the migration path appropriate for this repo.
      Outputs one of:
        PATH A  — fresh clone (0-1 commits, trivial)
        PATH B  — pre-ALPEI repo (missing 1-ALIGN/ or .claude/rules/)
        PATH C  — version upgrade (incremental sync via checkpoint)
      Exits 0 on success.

  --sync <target-version>
      Full orchestration mode (implements DESIGN §1.4 steps 1-9):
        [1] Read .template-checkpoint.yml. If missing or empty SHA,
            enters BOOTSTRAP MODE: prompts for original clone version,
            resolves its SHA, writes initial checkpoint, then proceeds.
        [2] Fetch template remote; resolve target tag SHA.
        [3] Run template-diff.sh --from-sha <last> --to-sha <target>.
        [4-6] Apply strategy per file (auto-take / section-merge /
              3-way-merge / skip / conflict / flag-deprecated).
              All actions logged to .template-sync-log.json.
        [7] Run scripts/template-verify.sh if it exists.
              FAIL → print failures, do NOT update checkpoint.
        [8] Update .template-checkpoint.yml (only after verify passes).
        [9] Print commit guidance.
      NEVER deletes local files.

  --auto-add [--input <file>]
      Read a JSON array of file paths from stdin (or --input file) and
      checkout each from the template remote if not already present.
      Existing files are reclassified to "merge" and skipped.
      All added files are left UNSTAGED.

  --file <path> --action <take|skip>
      take: overwrite local file with template version (unstaged).
      skip: record a skip decision in the log.

  --verify
      Run 4 structural checks on the sync log and staging area.
      Exits 0 if all checks pass.

  --reverse-clone <source-repo-path>
      Path B migration mode for pre-ALPEI repos with severe divergence.
      READ-ONLY: classifies every tracked file in the source repo using
      template-manifest.sh --classify and emits a YAML triage manifest
      to stdout. NEVER modifies the source repo.

      Actions in the manifest:
        keep          — domain file; port to new template clone
        manual-merge  — shared or unknown file; re-apply customisations
        replace       — domain-seed scaffold; replace with your content
        skip          — template file; fresh clone provides this
        delete        — deprecated file; do not port

  --remote <name>      Override template remote name (default: template)
  --branch <name>      Override template branch (default: main)
  --repo-root <path>   Override detection target and sync root (default: CWD repo)
  --help               Show this help and exit 0

EXAMPLES:
  template-sync.sh --detect-path
  template-sync.sh --sync v3.0.0
  template-sync.sh --auto-add --input auto-add-files.json
  template-sync.sh --file scripts/new-tool.sh --action take
  template-sync.sh --verify
  template-sync.sh --reverse-clone /path/to/old-repo > triage.yml
EOF
}

# --- Arg dispatch ---
MODE=""
FILE_PATH=""
ACTION=""
INPUT_FILE="-"
SYNC_VERSION=""
REVERSE_CLONE_SOURCE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --auto-add)        MODE="auto-add"; shift ;;
    --input)           INPUT_FILE="$2"; shift 2 ;;
    --file)            FILE_PATH="$2"; shift 2 ;;
    --action)          ACTION="$2"; shift 2 ;;
    --verify)          MODE="verify"; shift ;;
    --detect-path)     MODE="detect-path"; shift ;;
    --sync)            MODE="sync"; SYNC_VERSION="$2"; shift 2 ;;
    --reverse-clone)   MODE="reverse-clone"; REVERSE_CLONE_SOURCE="$2"; shift 2 ;;
    --remote)          REMOTE="$2"; REF="${REMOTE}/${BRANCH}"; shift 2 ;;
    --branch)          BRANCH="$2"; REF="${REMOTE}/${BRANCH}"; shift 2 ;;
    --repo-root)
      OVERRIDE_REPO_ROOT="$2"
      REPO_ROOT="$2"
      LOG_FILE="${REPO_ROOT}/.template-sync-log.json"
      CHECKPOINT_FILE="${REPO_ROOT}/.template-checkpoint.yml"
      shift 2
      ;;
    --help|-h)         do_help; exit 0 ;;
    *)
      echo "Error: unknown option: $1" >&2
      do_help >&2
      exit 2
      ;;
  esac
done

assert_no_delete

case "$MODE" in
  detect-path) do_detect_path ;;
  sync)
    if [ -z "$SYNC_VERSION" ]; then
      echo "Error: --sync requires a target version (e.g., --sync v3.0.0)" >&2
      exit 2
    fi
    do_sync "$SYNC_VERSION"
    ;;
  auto-add) do_auto_add "$INPUT_FILE" ;;
  verify)   do_verify ;;
  reverse-clone)
    if [ -z "$REVERSE_CLONE_SOURCE" ]; then
      echo "Error: --reverse-clone requires a source repo path (e.g., --reverse-clone /path/to/old-repo)" >&2
      exit 2
    fi
    do_reverse_clone "$REVERSE_CLONE_SOURCE"
    ;;
  "")
    if [ -n "$FILE_PATH" ] && [ -n "$ACTION" ]; then
      do_file_action "$FILE_PATH" "$ACTION"
    else
      echo "Error: specify a mode. Run: $0 --help" >&2
      exit 2
    fi
    ;;
esac
