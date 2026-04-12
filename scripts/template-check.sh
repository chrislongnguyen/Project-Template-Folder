#!/usr/bin/env bash
# version: 3.0 | status: draft | last_updated: 2026-04-12
# LTC Project Template — Deterministic Categorization Script
# Compares local file tree to template remote via git ls-tree.
# Outputs valid JSON to stdout. Self-validates bucket counts.
# v3.0: Each file entry now includes a `lineage` field from template-manifest.sh --classify.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Usage ---
usage() {
  cat <<'EOF'
Usage: template-check.sh [OPTIONS]

Compares local repo to template remote and outputs categorized JSON.

OPTIONS:
  --remote <name>   Git remote name for template (default: template)
  --branch <name>   Branch to compare against (default: main)
  --quiet           Suppress progress messages on stderr
  --help            Show this help and exit

OUTPUT:
  Valid JSON to stdout with 5 buckets: auto_add, flagged (security_sensitive,
  review_required), merge, unchanged. Each file entry is an object:
    {"path": "scripts/foo.sh", "lineage": "template"}
  Lineage values: template | shared | domain-seed | domain | deprecated | unknown

EXIT CODES:
  0   Success
  1   Bucket mismatch (internal error)
  2   Usage error / missing dependency
EOF
}

# --- Defaults ---
REMOTE="template"
BRANCH="main"
TEMPLATE_URL="https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git"
QUIET=false

# --- Arg parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote) REMOTE="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --quiet)  QUIET=true; shift ;;
    --help)   usage; exit 0 ;;
    *) echo "Usage: $0 [--remote <name>] [--branch <name>] [--quiet] [--help]" >&2; exit 2 ;;
  esac
done

# --- Require jq ---
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install: brew install jq" >&2
  exit 2
fi

# --- Ensure remote exists ---
if ! git remote get-url "$REMOTE" &>/dev/null; then
  $QUIET || echo "Adding remote $REMOTE → $TEMPLATE_URL" >&2
  git remote add "$REMOTE" "$TEMPLATE_URL"
fi
if $QUIET; then
  git fetch "$REMOTE" --quiet 2>/dev/null
else
  git fetch "$REMOTE" --quiet
fi

REF="${REMOTE}/${BRANCH}"

# --- Build file lists ---
TEMPLATE_FILES=$(git ls-tree -r --name-only "$REF")
LOCAL_FILES=$(git ls-files)

# --- Classification helpers ---

# Security-sensitive: NEVER auto-add
is_security_sensitive() {
  local f="$1"
  [[ "$f" == .env* ]] || \
  [[ "$f" == secrets/** ]] || \
  [[ "$f" =~ \.pem$ ]] || \
  [[ "$f" =~ \.key$ ]] || \
  [[ "$f" =~ \.p12$ ]] || \
  [[ "$f" =~ \.pfx$ ]]
}

# Agent/infra config: review-required (not auto-add)
is_review_required() {
  local f="$1"
  [[ "$f" == .claude/** ]] || \
  [[ "$f" == .agents/** ]] || \
  [[ "$f" == .cursor/** ]] || \
  [[ "$f" == .github/** ]] || \
  [[ "$f" == rules/** ]] || \
  [[ "$f" == _genesis/** ]] || \
  [[ "$f" == scripts/** ]] || \
  [[ "$f" == "CLAUDE.md" ]] || \
  [[ "$f" == "GEMINI.md" ]] || \
  [[ "$f" == ".mcp.json" ]] || \
  [[ "$f" == ".pre-commit-config.yaml" ]] || \
  [[ "$f" == ".gitignore" ]] || \
  [[ "$f" == ".gitleaks.toml" ]] || \
  [[ "$f" == "VERSION" ]] || \
  [[ "$f" == ".templateignore" ]]
}

file_exists_locally() {
  echo "$LOCAL_FILES" | grep -qxF "$1"
}

content_differs() {
  ! git diff --quiet "$REF" -- "$1" 2>/dev/null
}

# --- Lineage lookup (v3.0) ---
# Calls template-manifest.sh --classify for a single file path.
# Falls back to "unknown" if the script is missing, manifest is absent, or call fails.
MANIFEST_SCRIPT="${SCRIPT_DIR}/template-manifest.sh"
get_lineage() {
  local f="$1"
  if [[ ! -x "$MANIFEST_SCRIPT" ]]; then
    echo "unknown"
    return
  fi
  local result
  result="$(bash "$MANIFEST_SCRIPT" --classify "$f" 2>/dev/null)" || { echo "unknown"; return; }
  # Validate that the result is a known lineage value
  case "$result" in
    template|shared|domain-seed|domain|deprecated) echo "$result" ;;
    *) echo "unknown" ;;
  esac
}

# --- Categorize ---
auto_add=()
flagged_security=()
flagged_review=()
merge=()
unchanged=()

while IFS= read -r f; do
  [[ -z "$f" ]] && continue

  if ! file_exists_locally "$f"; then
    # New file — classify by sensitivity
    if is_security_sensitive "$f"; then
      flagged_security+=("$f")
    elif is_review_required "$f"; then
      flagged_review+=("$f")
    else
      auto_add+=("$f")
    fi
  else
    # File exists locally — check content
    if content_differs "$f"; then
      merge+=("$f")
    else
      unchanged+=("$f")
    fi
  fi
done <<< "$TEMPLATE_FILES"

# --- Self-validate: bucket counts must equal total template files ---
total_template=$(echo "$TEMPLATE_FILES" | grep -c . || true)
total_bucketed=$(( ${#auto_add[@]} + ${#flagged_security[@]} + ${#flagged_review[@]} + ${#merge[@]} + ${#unchanged[@]} ))

if [[ "$total_template" -ne "$total_bucketed" ]]; then
  echo "Error: bucket mismatch — template=$total_template bucketed=$total_bucketed" >&2
  exit 1
fi

# --- Build JSON output ---
# v3.0: each entry is {"path": "...", "lineage": "..."} instead of a plain string.
to_json_array() {
  # Args: each element is a file path string
  local arr=("$@")
  if [[ ${#arr[@]} -eq 0 ]]; then
    echo "[]"
    return
  fi
  local objects="["
  local first=true
  local f lineage
  for f in "${arr[@]}"; do
    lineage="$(get_lineage "$f")"
    if $first; then
      first=false
    else
      objects="${objects},"
    fi
    # Use jq to safely encode path and lineage strings
    objects="${objects}$(jq -n --arg p "$f" --arg l "$lineage" '{"path":$p,"lineage":$l}')"
  done
  objects="${objects}]"
  echo "$objects"
}

# Write JSON arrays to temp files to avoid Windows CLI arg-length limits (#21)
TMPDIR_TC=$(mktemp -d)
trap 'rm -rf "$TMPDIR_TC"' EXIT

to_json_array "${auto_add[@]+"${auto_add[@]}"}" > "$TMPDIR_TC/auto.json"
to_json_array "${flagged_security[@]+"${flagged_security[@]}"}" > "$TMPDIR_TC/sec.json"
to_json_array "${flagged_review[@]+"${flagged_review[@]}"}" > "$TMPDIR_TC/rev.json"
to_json_array "${merge[@]+"${merge[@]}"}" > "$TMPDIR_TC/merge.json"
to_json_array "${unchanged[@]+"${unchanged[@]}"}" > "$TMPDIR_TC/unchanged.json"

jq -n \
  --slurpfile auto_add "$TMPDIR_TC/auto.json" \
  --slurpfile security_sensitive "$TMPDIR_TC/sec.json" \
  --slurpfile review_required "$TMPDIR_TC/rev.json" \
  --slurpfile merge "$TMPDIR_TC/merge.json" \
  --slurpfile unchanged "$TMPDIR_TC/unchanged.json" \
  --argjson total "$total_template" \
  '{
    stats: {
      total_template_files: $total,
      auto_add: ($auto_add[0] | length),
      flagged_security_sensitive: ($security_sensitive[0] | length),
      flagged_review_required: ($review_required[0] | length),
      merge: ($merge[0] | length),
      unchanged: ($unchanged[0] | length)
    },
    auto_add: $auto_add[0],
    flagged: {
      security_sensitive: $security_sensitive[0],
      review_required: $review_required[0]
    },
    merge: $merge[0],
    unchanged: $unchanged[0]
  }'
