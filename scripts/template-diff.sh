#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-12
# LTC Project Template — Pristine Diff Engine
# Computes the exact set of changes (added/modified/deleted) between two template
# git SHAs, with lineage classification per file.
#
# Implements DESIGN-template-release-management.md §3.3 pristine_diff algorithm.
#
# Usage:
#   template-diff.sh --from-sha <sha> --to-sha <sha> [--format json|text]
#                    [--from-version <semver>] [--to-version <semver>] [--help]
#
# Exit codes:
#   0   Success — changeset computed
#   1   Error (version chain skip, git failure, invalid args)
#   2   Usage error / missing dependency

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || echo ".")"
MANIFEST_SCRIPT="${SCRIPT_DIR}/template-manifest.sh"

# --- Defaults ---
FROM_SHA=""
TO_SHA=""
FORMAT="json"
FROM_VERSION=""
TO_VERSION=""

# --- Usage ---
usage() {
  cat <<'EOF'
Usage: template-diff.sh --from-sha <sha> --to-sha <sha> [OPTIONS]

Computes the pristine diff between two template commits.
Each changed file is classified by lineage and assigned a merge strategy.

REQUIRED:
  --from-sha <sha>          Starting commit SHA (e.g., last synced template SHA)
  --to-sha <sha>            Target commit SHA (e.g., latest template release SHA)

OPTIONS:
  --format json|text        Output format (default: json)
  --from-version <semver>   Override semver for from_sha (e.g., v1.2.0)
                            Used for version chain validation when SHA has no tag.
  --to-version <semver>     Override semver for to_sha (e.g., v2.1.0)
  --help                    Show this help

STRATEGY MAPPING:
  template + user_not_modified → auto-take
  template + user_modified     → conflict
  shared                       → 3-way-merge (section-merge for CLAUDE.md)
  domain-seed                  → skip
  domain                       → skip
  deprecated                   → flag-deprecated

VERSION CHAIN:
  If both --from-version and --to-version are provided, validates that no
  intermediate tagged releases are skipped. Exits 1 if a skip is detected.

EXAMPLES:
  template-diff.sh --from-sha abc1234 --to-sha def5678
  template-diff.sh --from-sha abc1234 --to-sha def5678 --format text
  template-diff.sh --from-sha abc1234 --to-sha def5678 \
    --from-version v1.2.0 --to-version v2.1.0

EXIT CODES:
  0   Success — changeset produced
  1   Version chain skip detected OR git/diff failure
  2   Usage error / missing dependency
EOF
}

# --- Dependency check ---
if ! command -v python3 >/dev/null 2>&1; then
  echo "Error: python3 is required." >&2
  exit 2
fi
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required." >&2
  exit 2
fi

# --- Arg parsing ---
while [ $# -gt 0 ]; do
  case "$1" in
    --from-sha)       FROM_SHA="$2";      shift 2 ;;
    --to-sha)         TO_SHA="$2";        shift 2 ;;
    --format)         FORMAT="$2";        shift 2 ;;
    --from-version)   FROM_VERSION="$2";  shift 2 ;;
    --to-version)     TO_VERSION="$2";    shift 2 ;;
    --help|-h)        usage; exit 0 ;;
    *)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

# --- Validate required args ---
if [ -z "$FROM_SHA" ] || [ -z "$TO_SHA" ]; then
  echo "Error: --from-sha and --to-sha are required." >&2
  usage >&2
  exit 2
fi

if [ "$FORMAT" != "json" ] && [ "$FORMAT" != "text" ]; then
  echo "Error: --format must be 'json' or 'text'." >&2
  exit 2
fi

# --- Resolve SHAs (validate they exist in the repo) ---
resolve_sha() {
  local sha="$1"
  local label="$2"
  local resolved
  resolved="$(git -C "$REPO_ROOT" rev-parse --verify "${sha}^{commit}" 2>/dev/null)" || {
    echo "Error: ${label} SHA '${sha}' not found in repository." >&2
    exit 1
  }
  echo "$resolved"
}

FROM_SHA="$(resolve_sha "$FROM_SHA" "--from-sha")"
TO_SHA="$(resolve_sha "$TO_SHA" "--to-sha")"

# --- Version chain validation ---
# If both --from-version and --to-version supplied, check for skipped intermediate releases.
# Also: if only SHAs given, try to find tags automatically.
get_version_from_sha() {
  local sha="$1"
  git -C "$REPO_ROOT" tag --points-at "$sha" 2>/dev/null | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -1 || true
}

if [ -z "$FROM_VERSION" ]; then
  FROM_VERSION="$(get_version_from_sha "$FROM_SHA")"
fi
if [ -z "$TO_VERSION" ]; then
  TO_VERSION="$(get_version_from_sha "$TO_SHA")"
fi

# Perform version chain check only when both versions are known
if [ -n "$FROM_VERSION" ] && [ -n "$TO_VERSION" ]; then
  python3 - "$FROM_VERSION" "$TO_VERSION" "$REPO_ROOT" <<'PYEOF'
import sys
import subprocess
import re

from_ver = sys.argv[1].lstrip('v')
to_ver   = sys.argv[2].lstrip('v')
repo     = sys.argv[3]

def parse_ver(v):
    m = re.match(r'^(\d+)\.(\d+)\.(\d+)$', v)
    if not m:
        return None
    return (int(m.group(1)), int(m.group(2)), int(m.group(3)))

fv = parse_ver(from_ver)
tv = parse_ver(to_ver)

if fv is None or tv is None:
    # Not proper semver — skip chain check
    sys.exit(0)

if tv <= fv:
    # Not upgrading — nothing to check
    sys.exit(0)

# Get all repo semver tags
try:
    result = subprocess.check_output(
        ['git', '-C', repo, 'tag', '--list'],
        stderr=subprocess.DEVNULL
    ).decode().strip()
except Exception:
    sys.exit(0)

all_tags = []
for tag in result.splitlines():
    parsed = parse_ver(tag.lstrip('v'))
    if parsed is not None:
        all_tags.append(parsed)

all_tags.sort()

# Find intermediate releases (strictly between from and to)
skipped = [t for t in all_tags if fv < t < tv]

if skipped:
    skipped_strs = ['v{}.{}.{}'.format(*t) for t in skipped]
    print(
        'ERROR: version chain skip detected — from v{} to v{} skips intermediate releases: {}. '
        'Sync to each intermediate release first.'.format(from_ver, to_ver, ', '.join(skipped_strs)),
        file=sys.stderr
    )
    sys.exit(1)

sys.exit(0)
PYEOF
fi

# --- Compute tree diff ---
# git ls-tree outputs: <mode> <type> <blob_sha>\t<path>
# We extract path and blob SHA for comparison.

get_tree() {
  local sha="$1"
  git -C "$REPO_ROOT" ls-tree -r "$sha" 2>/dev/null | awk '{print $3 "\t" $4}'
}

# Write trees to temp files for python processing
TMPDIR_LOCAL="$(python3 -c 'import tempfile,os; print(tempfile.mkdtemp())')"
trap 'rm -rf "$TMPDIR_LOCAL"' EXIT

OLD_TREE_FILE="${TMPDIR_LOCAL}/old_tree.tsv"
NEW_TREE_FILE="${TMPDIR_LOCAL}/new_tree.tsv"
CHANGESET_FILE="${TMPDIR_LOCAL}/changeset.json"

get_tree "$FROM_SHA" > "$OLD_TREE_FILE"
get_tree "$TO_SHA"   > "$NEW_TREE_FILE"

# --- Classify each changed file using template-manifest.sh ---
# Build a temp file list of template remote files (use TO_SHA tree as proxy for "template files")
TEMPLATE_FILES_FILE="${TMPDIR_LOCAL}/template_files.txt"
git -C "$REPO_ROOT" ls-tree -r "$TO_SHA" --name-only 2>/dev/null > "$TEMPLATE_FILES_FILE" || true

# --- Python: compute changeset and call classify per file ---
python3 - \
  "$OLD_TREE_FILE" \
  "$NEW_TREE_FILE" \
  "$FROM_SHA" \
  "$TO_SHA" \
  "$FORMAT" \
  "$REPO_ROOT" \
  "$MANIFEST_SCRIPT" \
  "$TEMPLATE_FILES_FILE" \
  "$CHANGESET_FILE" \
<<'PYEOF'
import sys
import os
import json
import subprocess

old_tree_file    = sys.argv[1]
new_tree_file    = sys.argv[2]
from_sha         = sys.argv[3]
to_sha           = sys.argv[4]
fmt              = sys.argv[5]
repo_root        = sys.argv[6]
manifest_script  = sys.argv[7]
template_files_f = sys.argv[8]
changeset_file   = sys.argv[9]

def read_tree(path):
    """Read a tree TSV file → dict of {filepath: blob_sha}."""
    result = {}
    with open(path) as f:
        for line in f:
            line = line.rstrip('\n')
            if not line:
                continue
            parts = line.split('\t', 1)
            if len(parts) == 2:
                blob_sha, filepath = parts
                result[filepath] = blob_sha
    return result

def classify_file(filepath, manifest_script, template_files_f):
    """
    Call template-manifest.sh --classify <path> if script exists.
    Falls back to a heuristic if the script is unavailable.
    """
    if os.path.isfile(manifest_script) and os.access(manifest_script, os.X_OK):
        try:
            result = subprocess.check_output(
                [manifest_script, '--classify', filepath],
                stderr=subprocess.DEVNULL
            ).decode().strip()
            if result in ('template', 'shared', 'domain-seed', 'domain', 'deprecated'):
                return result
        except subprocess.CalledProcessError:
            pass
    # Heuristic fallback (when manifest script unavailable / manifest YAML not yet present)
    return heuristic_classify(filepath)

def heuristic_classify(filepath):
    """Simple heuristic when manifest script is unavailable."""
    deprecated_patterns = ['.claude/commands/']
    for p in deprecated_patterns:
        if filepath.startswith(p):
            return 'deprecated'
    shared_exact = {'CLAUDE.md', '.claude/settings.json'}
    if filepath in shared_exact:
        return 'shared'
    domain_seed_prefixes = (
        '1-ALIGN/', '2-LEARN/', '3-PLAN/', '4-EXECUTE/', '5-IMPROVE/',
        'PERSONAL-KNOWLEDGE-BASE/', 'DAILY-NOTES/', 'inbox/',
    )
    if filepath.startswith(domain_seed_prefixes):
        return 'domain-seed'
    # Anything else in the template tree → template
    return 'template'

def check_user_modified(filepath, from_sha, repo_root):
    """
    Compare file content at from_sha (last template sync point) against current local file.
    If they differ, the user has modified the file.
    Returns True if user-modified, False otherwise.
    """
    local_path = os.path.join(repo_root, filepath)
    if not os.path.isfile(local_path):
        # File doesn't exist locally — not user-modified (deleted or absent)
        return False
    # Get template content at from_sha
    try:
        template_content = subprocess.check_output(
            ['git', '-C', repo_root, 'show', '{}:{}'.format(from_sha, filepath)],
            stderr=subprocess.DEVNULL
        )
    except subprocess.CalledProcessError:
        # File didn't exist at from_sha — can't compare; treat as user-modified (conservative)
        return True
    # Read local file
    with open(local_path, 'rb') as f:
        local_content = f.read()
    return template_content != local_content

def determine_strategy(lineage, user_modified, filepath):
    """Determine merge strategy from lineage and user_modified flag."""
    if lineage in ('domain-seed', 'domain'):
        return 'skip'
    if lineage == 'deprecated':
        return 'flag-deprecated'
    if lineage == 'template':
        if user_modified:
            return 'conflict'
        return 'auto-take'
    if lineage == 'shared':
        # Special case: CLAUDE.md uses section-merge
        if filepath == 'CLAUDE.md':
            return 'section-merge'
        return '3-way-merge'
    # Unknown lineage — conservative
    return 'conflict'

# --- Compute diff ---
old_tree = read_tree(old_tree_file)
new_tree = read_tree(new_tree_file)

old_set = set(old_tree.keys())
new_set = set(new_tree.keys())

added    = sorted(new_set - old_set)
deleted  = sorted(old_set - new_set)
modified = sorted(
    f for f in (old_set & new_set)
    if old_tree[f] != new_tree[f]
)

changeset = []

for filepath in added:
    lineage  = classify_file(filepath, manifest_script, template_files_f)
    user_mod = check_user_modified(filepath, from_sha, repo_root)
    strategy = determine_strategy(lineage, user_mod, filepath)
    changeset.append({
        'path':        filepath,
        'change_type': 'added',
        'lineage':     lineage,
        'strategy':    strategy,
    })

for filepath in deleted:
    lineage  = classify_file(filepath, manifest_script, template_files_f)
    # Deleted files: user_modified check not applicable (file gone from template)
    strategy = determine_strategy(lineage, False, filepath)
    changeset.append({
        'path':        filepath,
        'change_type': 'deleted',
        'lineage':     lineage,
        'strategy':    strategy,
    })

for filepath in modified:
    lineage  = classify_file(filepath, manifest_script, template_files_f)
    user_mod = check_user_modified(filepath, from_sha, repo_root)
    strategy = determine_strategy(lineage, user_mod, filepath)
    changeset.append({
        'path':        filepath,
        'change_type': 'modified',
        'lineage':     lineage,
        'strategy':    strategy,
    })

output = {
    'from_sha':      from_sha[:7],
    'to_sha':        to_sha[:7],
    'total_changes': len(changeset),
    'changeset':     changeset,
}

# Write to changeset file for bash to consume
with open(changeset_file, 'w') as f:
    json.dump(output, f, indent=2)

# Print based on format
if fmt == 'json':
    print(json.dumps(output, indent=2))
else:
    # Text format
    print('Template diff: {} → {}'.format(from_sha[:7], to_sha[:7]))
    print('Total changes: {}'.format(len(changeset)))
    print()
    if not changeset:
        print('No changes detected.')
    else:
        col_w = [4, 12, 12, 20]
        header = '{:<{}} {:<{}} {:<{}} {:<{}}'.format(
            'TYPE', col_w[0], 'CHANGE', col_w[1], 'LINEAGE', col_w[2], 'PATH', col_w[3]
        )
        print(header)
        print('-' * (sum(col_w) + 3))
        for entry in changeset:
            ct    = entry['change_type'][:col_w[0]]
            lin   = entry['lineage'][:col_w[2]]
            strat = entry['strategy'][:col_w[1]]
            path  = entry['path']
            print('{:<{}} {:<{}} {:<{}} {}'.format(
                ct, col_w[0], strat, col_w[1], lin, col_w[2], path
            ))
        print()
        print('Strategy legend:')
        print('  auto-take      — apply template change directly')
        print('  conflict       — template changed, user also modified → manual resolution needed')
        print('  3-way-merge    — shared file: merge template + user changes')
        print('  section-merge  — shared file with heading-level merge (e.g., CLAUDE.md)')
        print('  skip           — domain/domain-seed file: do not apply template change')
        print('  flag-deprecated — file removed from template: review for local deletion')

sys.exit(0)
PYEOF
