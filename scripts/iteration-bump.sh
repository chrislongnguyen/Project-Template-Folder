#!/usr/bin/env bash
# version: 1.2 | status: in-review | last_updated: 2026-04-09
#
# iteration-bump.sh — Bump all .md files in a subsystem to the next iteration
#
# Usage:
#   ./scripts/iteration-bump.sh --subsystem PD --from 1 --to 2 [--force]
#
# --force   Skip S1 readiness check (still prompts for confirmation)
#
# Safety checks (all must pass unless --force):
#   S1: readiness-report.sh Criterion 1-3 (C1-C3) all pass for this subsystem
#   S2: no uncommitted changes in target files
#   S3: --from matches actual current MAJOR version in target files
#   S4: upstream subsystem is at or above --to
#   S5: human confirmation prompt
#
# After bumping: calls generate-registry.sh to sync version-registry.md
# Does NOT commit — caller or /git-save does that.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"
TODAY="$(date +%Y-%m-%d)"

# ─── Config ───────────────────────────────────────────────────────────────────

ALL_SUBSYS=(PD DP DA IDM)
WORKSTREAM_DIRS=(1-ALIGN 2-LEARN 3-PLAN 4-EXECUTE 5-IMPROVE)

subsys_dir() {
  case "$1" in
    PD)  echo "1-PD"  ;;
    DP)  echo "2-DP"  ;;
    DA)  echo "3-DA"  ;;
    IDM) echo "4-IDM" ;;
    *)   echo ""      ;;
  esac
}

subsys_upstream() {
  case "$1" in
    PD)  echo ""    ;;
    DP)  echo "PD"  ;;
    DA)  echo "DP"  ;;
    IDM) echo "DA"  ;;
    *)   echo ""    ;;
  esac
}

# ─── Argument parsing ─────────────────────────────────────────────────────────

SUBSYSTEM=""
FROM_ITER=""
TO_ITER=""
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subsystem)
      SUBSYSTEM="$2"
      shift 2
      ;;
    --from)
      FROM_ITER="$2"
      shift 2
      ;;
    --to)
      TO_ITER="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    *)
      echo "Usage: $0 --subsystem PD|DP|DA|IDM --from N --to M [--force]" >&2
      exit 1
      ;;
  esac
done

# Validate required args
if [[ -z "$SUBSYSTEM" || -z "$FROM_ITER" || -z "$TO_ITER" ]]; then
  echo "ERROR: --subsystem, --from, and --to are all required." >&2
  echo "Usage: $0 --subsystem PD|DP|DA|IDM --from N --to M [--force]" >&2
  exit 1
fi

SUBSYS_FOLDER="$(subsys_dir "$SUBSYSTEM")"
if [[ -z "$SUBSYS_FOLDER" ]]; then
  echo "ERROR: Unknown subsystem '${SUBSYSTEM}'. Valid: PD DP DA IDM" >&2
  exit 1
fi

if ! [[ "$FROM_ITER" =~ ^[0-9]+$ ]] || ! [[ "$TO_ITER" =~ ^[0-9]+$ ]]; then
  echo "ERROR: --from and --to must be integers." >&2
  exit 1
fi

if (( TO_ITER != FROM_ITER + 1 )); then
  echo "ERROR: --to must be exactly --from + 1. Got from=${FROM_ITER} to=${TO_ITER}." >&2
  exit 1
fi

# ─── Helpers ─────────────────────────────────────────────────────────────────

get_frontmatter_field() {
  local file="$1" field="$2" default="${3:-}"
  local val
  val=$(awk '
    BEGIN { in_fm=0 }
    /^---/ {
      if (in_fm == 0) { in_fm=1; next }
      else { exit }
    }
    in_fm && /^'"$field"':/ {
      sub(/^'"$field"':[[:space:]]*/, "")
      gsub(/"/, "")
      print; exit
    }
  ' "$file" 2>/dev/null) || true
  echo "${val:-$default}"
}

# Collect all target .md files for this subsystem across all workstreams
collect_target_files() {
  local folder="$1"
  local files=()
  for ws in "${WORKSTREAM_DIRS[@]}"; do
    local dir="${REPO_ROOT}/${ws}/${folder}"
    [[ -d "$dir" ]] || continue
    while IFS= read -r f; do
      files+=("$f")
    done < <(find "$dir" -name "*.md" 2>/dev/null | sort)
  done
  printf '%s\n' "${files[@]}"
}

# ─── Safety Checks ────────────────────────────────────────────────────────────

echo "iteration-bump.sh — ${SUBSYSTEM} (I${FROM_ITER} → I${TO_ITER})"
echo ""

# S1: Readiness check (Criterion 1-3) — skip with --force
if [[ $FORCE -eq 0 ]]; then
  echo "[S1] Running readiness check for ${SUBSYSTEM}..."
  READINESS_SCRIPT="${SCRIPT_DIR}/readiness-report.sh"
  if [[ ! -x "$READINESS_SCRIPT" ]]; then
    echo "ERROR: readiness-report.sh not found or not executable at ${READINESS_SCRIPT}" >&2
    exit 1
  fi
  # Capture readiness output and check for READY status
  READINESS_OUTPUT=$("$READINESS_SCRIPT" --subsystem "$SUBSYSTEM" 2>&1)
  echo "$READINESS_OUTPUT"
  echo ""
  # Extract the status column for this subsystem — must contain "READY" not "NOT READY"
  STATUS_LINE=$(echo "$READINESS_OUTPUT" | grep "| ${SUBSYSTEM} " || true)
  if [[ -z "$STATUS_LINE" ]]; then
    echo "ERROR: Could not parse readiness output for ${SUBSYSTEM}." >&2
    echo "       Use --force to skip readiness check." >&2
    exit 1
  fi
  if echo "$STATUS_LINE" | grep -q "NOT READY"; then
    echo "ERROR: [S1] Subsystem ${SUBSYSTEM} is NOT READY for iteration advancement." >&2
    echo "       Resolve blockers above, or use --force to skip this check." >&2
    exit 1
  fi
  echo "[S1] PASS — all Criterion 1-3 conditions met."
else
  echo "[S1] SKIPPED (--force)"
fi

# Collect target files
TARGET_FILES=()
while IFS= read -r _line; do
  TARGET_FILES+=("$_line")
done < <(collect_target_files "$SUBSYS_FOLDER")

if [[ ${#TARGET_FILES[@]} -eq 0 ]]; then
  echo "ERROR: No .md files found under */${SUBSYS_FOLDER}/ in any workstream." >&2
  exit 1
fi

echo ""
echo "[S2] Checking for uncommitted changes in ${#TARGET_FILES[@]} target files..."

DIRTY_FILES=()
for f in "${TARGET_FILES[@]}"; do
  # Check if the file has uncommitted changes (staged or unstaged)
  REL_PATH="${f#$REPO_ROOT/}"
  if ! git -C "$REPO_ROOT" diff --quiet -- "$REL_PATH" 2>/dev/null || \
     ! git -C "$REPO_ROOT" diff --cached --quiet -- "$REL_PATH" 2>/dev/null; then
    DIRTY_FILES+=("$REL_PATH")
  fi
done

if [[ ${#DIRTY_FILES[@]} -gt 0 ]]; then
  echo "ERROR: [S2] Uncommitted changes detected in target files:" >&2
  for f in "${DIRTY_FILES[@]}"; do
    echo "  - $f" >&2
  done
  echo "       Commit or stash changes before running iteration-bump.sh." >&2
  exit 1
fi
echo "[S2] PASS — no uncommitted changes in target files."

# S3: --from matches actual current MAJOR version in target files
echo ""
echo "[S3] Verifying current MAJOR version = ${FROM_ITER} in target files..."

MISMATCH_FILES=()
for f in "${TARGET_FILES[@]}"; do
  ver=$(get_frontmatter_field "$f" "version" "")
  if [[ -z "$ver" ]]; then
    # Files without a version field are skipped silently
    continue
  fi
  major="${ver%%.*}"
  if [[ ! "$major" =~ ^[0-9]+$ ]]; then
    continue
  fi
  if (( major != FROM_ITER )); then
    MISMATCH_FILES+=("${f#$REPO_ROOT/} (version: ${ver})")
  fi
done

if [[ ${#MISMATCH_FILES[@]} -gt 0 ]]; then
  echo "ERROR: [S3] --from=${FROM_ITER} does not match actual MAJOR version in:" >&2
  for f in "${MISMATCH_FILES[@]}"; do
    echo "  - $f" >&2
  done
  echo "       Check --from value or investigate version drift." >&2
  exit 1
fi
echo "[S3] PASS — all versioned files have MAJOR = ${FROM_ITER}."

# S4: Upstream subsystem at or above --to
echo ""
UPSTREAM="$(subsys_upstream "$SUBSYSTEM")"
if [[ -n "$UPSTREAM" ]]; then
  echo "[S4] Checking upstream subsystem ${UPSTREAM} is at I${TO_ITER} or higher..."
  UPSTREAM_FOLDER="$(subsys_dir "$UPSTREAM")"
  UPSTREAM_MAX=0
  for ws in "${WORKSTREAM_DIRS[@]}"; do
    dir="${REPO_ROOT}/${ws}/${UPSTREAM_FOLDER}"
    [[ -d "$dir" ]] || continue
    while IFS= read -r f; do
      ver=$(get_frontmatter_field "$f" "version" "1.0")
      major="${ver%%.*}"
      if [[ "$major" =~ ^[0-9]+$ ]] && (( major > UPSTREAM_MAX )); then
        UPSTREAM_MAX=$major
      fi
    done < <(find "$dir" -name "*.md" 2>/dev/null)
  done

  if (( UPSTREAM_MAX < TO_ITER )); then
    echo "ERROR: [S4] Upstream ${UPSTREAM} is at I${UPSTREAM_MAX}, which is below I${TO_ITER}." >&2
    echo "       Advance ${UPSTREAM} to I${TO_ITER} first." >&2
    exit 1
  fi
  echo "[S4] PASS — ${UPSTREAM} is at I${UPSTREAM_MAX} (≥ I${TO_ITER})."
else
  echo "[S4] PASS — ${SUBSYSTEM} has no upstream dependency."
fi

# S5: Human confirmation
echo ""
echo "──────────────────────────────────────────────────────────"
echo "  Subsystem : ${SUBSYSTEM} (${SUBSYS_FOLDER})"
echo "  Bump      : I${FROM_ITER} → I${TO_ITER}"
echo "  Files     : ${#TARGET_FILES[@]} .md files across all workstreams"
echo "  Changes   : version → ${TO_ITER}.0 | status → draft | iteration → ${TO_ITER}"
echo "──────────────────────────────────────────────────────────"
printf "This will bump %d files from I%s to I%s. Proceed? [y/N] " \
  "${#TARGET_FILES[@]}" "$FROM_ITER" "$TO_ITER"
read -r CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Aborted. No files were modified."
  exit 0
fi

# ─── Execute Bump ─────────────────────────────────────────────────────────────

echo ""
echo "Bumping ${#TARGET_FILES[@]} files..."

BUMPED=0
SKIPPED=0

for f in "${TARGET_FILES[@]}"; do
  # Check if file has frontmatter at all (starts with ---)
  first_line=$(head -1 "$f" 2>/dev/null || true)
  if [[ "$first_line" != "---" ]]; then
    echo "  SKIP (no frontmatter): ${f#$REPO_ROOT/}"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Use awk to rewrite frontmatter fields in one pass
  tmpfile=$(mktemp)
  awk -v to_iter="$TO_ITER" -v today="$TODAY" '
    BEGIN { in_fm=0; fm_done=0; saw_version=0; saw_status=0; saw_last_updated=0; saw_iteration=0 }
    /^---/ {
      if (in_fm == 0) {
        in_fm=1
        print
        next
      } else {
        # End of frontmatter — inject any missing required fields before closing ---
        if (!saw_version)      print "version: \"" to_iter ".0\""
        if (!saw_status)       print "status: draft"
        if (!saw_last_updated) print "last_updated: " today
        if (!saw_iteration)    print "iteration: " to_iter
        in_fm=0
        fm_done=1
        print
        next
      }
    }
    in_fm && /^version:/ {
      print "version: \"" to_iter ".0\""
      saw_version=1
      next
    }
    in_fm && /^status:/ {
      print "status: draft"
      saw_status=1
      next
    }
    in_fm && /^last_updated:/ {
      print "last_updated: " today
      saw_last_updated=1
      next
    }
    in_fm && /^iteration:/ {
      print "iteration: " to_iter
      saw_iteration=1
      next
    }
    { print }
  ' "$f" > "$tmpfile"

  mv "$tmpfile" "$f"
  echo "  BUMPED: ${f#$REPO_ROOT/}"
  BUMPED=$((BUMPED + 1))
done

# ─── Post-bump: regenerate registry ───────────────────────────────────────────

echo ""
echo "Regenerating version registry..."
GENERATE_SCRIPT="${SCRIPT_DIR}/generate-registry.sh"
if [[ -x "$GENERATE_SCRIPT" ]]; then
  "$GENERATE_SCRIPT"
else
  echo "WARNING: generate-registry.sh not found or not executable — skipping registry update." >&2
fi

# ─── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "──────────────────────────────────────────────────────────"
echo "  Bumped  : ${BUMPED} files (I${FROM_ITER} → I${TO_ITER})"
[[ $SKIPPED -gt 0 ]] && echo "  Skipped : ${SKIPPED} files (no frontmatter)"
echo "  Next    : review changes, then commit with /git-save"
echo "  Rollback: git revert HEAD (after commit)"
echo "──────────────────────────────────────────────────────────"
