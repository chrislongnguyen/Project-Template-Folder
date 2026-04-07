#!/usr/bin/env bash
# version: 2.0 | status: draft | last_updated: 2026-04-05
# LTC Project Template — Deterministic Categorization Script
# Compares local file tree to template remote via git ls-tree.
# Outputs valid JSON to stdout. Self-validates bucket counts.
set -euo pipefail

# --- Defaults ---
REMOTE="template"
BRANCH="main"
TEMPLATE_URL="https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git"

# --- Arg parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote) REMOTE="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    *) echo "Usage: $0 [--remote <name>] [--branch <name>]" >&2; exit 2 ;;
  esac
done

# --- Require jq ---
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install: brew install jq" >&2
  exit 2
fi

# --- Ensure remote exists ---
if ! git remote get-url "$REMOTE" &>/dev/null; then
  git remote add "$REMOTE" "$TEMPLATE_URL"
fi
git fetch "$REMOTE" --quiet

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
to_json_array() {
  local arr=("$@")
  if [[ ${#arr[@]} -eq 0 ]]; then
    echo "[]"
    return
  fi
  printf '%s\n' "${arr[@]}" | jq -R . | jq -s .
}

AUTO_JSON=$(to_json_array "${auto_add[@]+"${auto_add[@]}"}")
SEC_JSON=$(to_json_array "${flagged_security[@]+"${flagged_security[@]}"}")
REV_JSON=$(to_json_array "${flagged_review[@]+"${flagged_review[@]}"}")
MERGE_JSON=$(to_json_array "${merge[@]+"${merge[@]}"}")
UNCHANGED_JSON=$(to_json_array "${unchanged[@]+"${unchanged[@]}"}")

jq -n \
  --argjson auto_add "$AUTO_JSON" \
  --argjson security_sensitive "$SEC_JSON" \
  --argjson review_required "$REV_JSON" \
  --argjson merge "$MERGE_JSON" \
  --argjson unchanged "$UNCHANGED_JSON" \
  --argjson total "$total_template" \
  '{
    stats: {
      total_template_files: $total,
      auto_add: ($auto_add | length),
      flagged_security_sensitive: ($security_sensitive | length),
      flagged_review_required: ($review_required | length),
      merge: ($merge | length),
      unchanged: ($unchanged | length)
    },
    auto_add: $auto_add,
    flagged: {
      security_sensitive: $security_sensitive,
      review_required: $review_required
    },
    merge: $merge,
    unchanged: $unchanged
  }'
