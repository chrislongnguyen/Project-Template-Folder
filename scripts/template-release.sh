#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-12
# LTC Project Template — Release Management Script
# Validates, tags, and generates release notes for a new template version.
# Bash 3 compatible: no associative arrays, no ${var,,}, no |&
set -euo pipefail

# --- Constants ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RELEASES_DIR="$REPO_ROOT/_genesis/releases"
NOTES_TEMPLATE="$REPO_ROOT/_genesis/templates/release-notes-template.md"
CHANGELOG="$REPO_ROOT/CHANGELOG.md"
MANIFEST="$REPO_ROOT/_genesis/template-manifest.yml"
VERSION_FILE="$REPO_ROOT/VERSION"

# --- Usage ---
usage() {
  cat <<'EOF'
Usage:
  template-release.sh --dry-run <version> [--requires <version>]
      Preview release without creating git objects.
      Outputs: planned tag, changelog skeleton, notes file path.
      Exit 0 on success; exit 1 on validation failure.

  template-release.sh --tag <version> [--requires <version>]
      Run all --validate checks, generate release notes file,
      and create annotated git tag.

  template-release.sh --validate <version>
      Check CHANGELOG entry, manifest existence, and clean git status.
      Exit 0 only if all 3 checks pass.

  template-release.sh --help
      Show this message.

Options:
  --requires <version>   Set the 'requires:' field in release notes frontmatter.
                         If omitted, reads from VERSION file.

Version format: v{MAJOR}.{MINOR}.{PATCH}  (e.g. v2.1.0)
EOF
}

# --- Helpers ---
die() { echo "ERROR: $*" >&2; exit 1; }

validate_semver() {
  local v="$1"
  if [[ ! "$v" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    die "Invalid version format '$v'. Must be v{MAJOR}.{MINOR}.{PATCH} (e.g. v2.1.0)"
  fi
}

tag_exists() {
  local v="$1"
  git -C "$REPO_ROOT" tag -l "$v" | grep -q "^${v}$"
}

changelog_has_entry() {
  local v="$1"
  # Strip leading 'v' for CHANGELOG lookup — entries may appear as [2.1.0] or ## 2.1.0
  local bare="${v#v}"
  grep -qE "(## \[?${bare}\]?|^\[${bare}\])" "$CHANGELOG"
}

manifest_valid() {
  if [[ ! -f "$MANIFEST" ]]; then
    return 1
  fi
  # Minimal YAML validity: file is non-empty and not just whitespace
  grep -qv '^[[:space:]]*$' "$MANIFEST"
}

git_status_clean() {
  local status
  status=$(git -C "$REPO_ROOT" status --porcelain 2>/dev/null)
  [[ -z "$status" ]]
}

get_prior_version() {
  if [[ -f "$VERSION_FILE" ]]; then
    local v
    v=$(tr -d '[:space:]' < "$VERSION_FILE")
    # Prepend 'v' if missing
    if [[ "$v" =~ ^[0-9] ]]; then
      echo "v${v}"
    else
      echo "$v"
    fi
  else
    echo "none"
  fi
}

# --- Check: CHANGELOG entry ---
check_changelog() {
  local version="$1"
  if changelog_has_entry "$version"; then
    echo "  [PASS] CHANGELOG.md has entry for $version"
    return 0
  else
    echo "  [FAIL] CHANGELOG.md missing entry for $version — add '## [${version#v}]' or '## ${version#v}' before tagging"
    return 1
  fi
}

# --- Check: manifest ---
check_manifest() {
  if manifest_valid; then
    echo "  [PASS] _genesis/template-manifest.yml exists and is non-empty"
    return 0
  else
    echo "  [FAIL] _genesis/template-manifest.yml missing or empty — run manifest generation before releasing"
    return 1
  fi
}

# --- Check: clean working tree ---
check_clean() {
  if git_status_clean; then
    echo "  [PASS] Working tree is clean (no uncommitted changes)"
    return 0
  else
    echo "  [FAIL] Uncommitted changes detected — commit or stash before tagging"
    git -C "$REPO_ROOT" status --short >&2
    return 1
  fi
}

# --- Check: every existing tag has a CHANGELOG entry ---
check_tag_changelog_parity() {
  local found_gap=0
  local tags
  tags=$(git -C "$REPO_ROOT" tag -l 'v[0-9]*' 2>/dev/null || true)
  if [[ -z "$tags" ]]; then
    echo "  [INFO] No existing v[0-9]* tags found — parity check skipped"
    return 0
  fi
  echo "  Checking existing tags against CHANGELOG.md..."
  while IFS= read -r tag; do
    [[ -z "$tag" ]] && continue
    if changelog_has_entry "$tag"; then
      echo "    [PASS] $tag — found in CHANGELOG.md"
    else
      echo "    [FAIL] $tag — missing CHANGELOG.md entry"
      found_gap=1
    fi
  done <<< "$tags"
  return $found_gap
}

# --- Mode: --validate ---
do_validate() {
  local version="$1"
  local all_pass=0

  echo ""
  echo "Validating release $version..."
  echo ""

  check_changelog "$version" || all_pass=1
  check_manifest             || all_pass=1
  check_clean                || all_pass=1

  echo ""
  echo "Tag/CHANGELOG parity audit:"
  check_tag_changelog_parity || all_pass=1

  echo ""
  if [[ $all_pass -eq 0 ]]; then
    echo "VALIDATE PASS: $version is ready to tag."
  else
    echo "VALIDATE FAIL: $version has one or more blocking issues. Fix before tagging."
    return 1
  fi
}

# --- Mode: --dry-run ---
do_dry_run() {
  local version="$1"
  local requires="$2"
  local notes_path="$RELEASES_DIR/${version}.md"

  echo ""
  echo "DRY RUN — no git objects will be created"
  echo ""
  echo "  Tag:        $version"
  echo "  Notes file: $notes_path"
  echo "  Requires:   $requires"
  echo ""
  echo "CHANGELOG skeleton to add (paste above [Unreleased]):"
  echo ""
  echo "  ## [${version#v}] — $(date +%Y-%m-%d)"
  echo "  ### Added"
  echo "  - TODO"
  echo "  ### Changed"
  echo "  - TODO"
  echo "  ### Fixed"
  echo "  - TODO"
  echo ""

  # Verify tag does NOT already exist
  if tag_exists "$version"; then
    die "Tag $version already exists. Use a different version."
  fi
  echo "  [PASS] Tag $version does not yet exist."

  # Verify notes template exists
  if [[ ! -f "$NOTES_TEMPLATE" ]]; then
    die "Release notes template not found: $NOTES_TEMPLATE"
  fi
  echo "  [PASS] Release notes template found."
  echo ""
  echo "DRY RUN COMPLETE — no git objects created."
}

# --- Mode: --tag ---
do_tag() {
  local version="$1"
  local requires="$2"
  local notes_path="$RELEASES_DIR/${version}.md"
  local release_date
  release_date=$(date +%Y-%m-%d)

  # Run validate first
  do_validate "$version"

  echo ""
  echo "Generating release notes: $notes_path"

  # Ensure releases dir exists
  mkdir -p "$RELEASES_DIR"

  # Verify notes template
  if [[ ! -f "$NOTES_TEMPLATE" ]]; then
    die "Release notes template not found: $NOTES_TEMPLATE"
  fi

  # Verify tag does NOT already exist
  if tag_exists "$version"; then
    die "Tag $version already exists."
  fi

  # Copy template, substitute placeholders
  local bare="${version#v}"
  sed \
    -e "s/release_version: \"\"/release_version: \"$version\"/" \
    -e "s/release_date: \"\"/release_date: \"$release_date\"/" \
    -e "s/requires: \"\"/requires: \"$requires\"/" \
    -e "s/{VERSION}/$bare/g" \
    -e "s/{PRIOR_VERSION}/${requires#v}/g" \
    -e "s/YYYY-MM-DD/$release_date/g" \
    "$NOTES_TEMPLATE" > "$notes_path"

  echo "  [DONE] Notes file created: $notes_path"

  # Create annotated git tag
  echo ""
  echo "Creating git tag $version..."
  git -C "$REPO_ROOT" tag -a "$version" -m "Template release $version"
  echo "  [DONE] Tag created: $version"

  echo ""
  echo "TAG COMPLETE."
  echo "  Tag:        $version"
  echo "  Notes:      $notes_path"
  echo "  Requires:   $requires"
  echo ""
  echo "Next steps:"
  echo "  1. Review and fill in $notes_path"
  echo "  2. git push origin $version"
}

# --- Arg parsing ---
MODE=""
VERSION=""
REQUIRES=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --dry-run)
      [[ $# -lt 2 ]] && die "--dry-run requires a version argument"
      MODE="dry-run"
      VERSION="$2"
      shift 2
      ;;
    --tag)
      [[ $# -lt 2 ]] && die "--tag requires a version argument"
      MODE="tag"
      VERSION="$2"
      shift 2
      ;;
    --validate)
      [[ $# -lt 2 ]] && die "--validate requires a version argument"
      MODE="validate"
      VERSION="$2"
      shift 2
      ;;
    --requires)
      [[ $# -lt 2 ]] && die "--requires requires a version argument"
      REQUIRES="$2"
      shift 2
      ;;
    *)
      die "Unknown argument: $1. Run --help for usage."
      ;;
  esac
done

if [[ -z "$MODE" ]]; then
  usage
  exit 1
fi

# Validate semver format
validate_semver "$VERSION"

# Resolve --requires default
if [[ -z "$REQUIRES" ]]; then
  REQUIRES=$(get_prior_version)
fi

# Dispatch
case "$MODE" in
  dry-run)  do_dry_run "$VERSION" "$REQUIRES" ;;
  tag)      do_tag     "$VERSION" "$REQUIRES" ;;
  validate) do_validate "$VERSION" ;;
esac
