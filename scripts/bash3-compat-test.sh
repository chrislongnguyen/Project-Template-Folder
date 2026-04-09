#!/bin/bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# bash3-compat-test.sh
# Usage: bash3-compat-test.sh [directory]
# Audits all .sh files in directory for bash 4+ patterns that break under
# macOS default /bin/bash (version 3.2).
#
# Exit 0 = no bash 4+ patterns found and all files pass bash -n
# Exit 1 = one or more violations found

TARGET_DIR="${1:-.}"
FOUND=0
SELF="$(basename "$0")"

# -------------------------------------------------------
# Pass 1: grep for known bash 4+ constructs (non-comment lines only)
# -------------------------------------------------------
while IFS= read -r -d '' f; do
    # Skip this script itself to avoid self-match on pattern strings
    [ "$(basename "$f")" = "$SELF" ] && continue

    # mapfile / readarray
    HITS=$(grep -nE "^[^#]*(mapfile|readarray)" "$f" 2>/dev/null || true)
    if [ -n "$HITS" ]; then
        echo "BASH4+ (mapfile/readarray) in $f:"
        echo "$HITS"
        FOUND=1
    fi

    # declare -A (associative arrays)
    HITS=$(grep -nE "^[^#]*declare[[:space:]]+-A[[:space:]]" "$f" 2>/dev/null || true)
    if [ -n "$HITS" ]; then
        echo "BASH4+ (declare -A) in $f:"
        echo "$HITS"
        FOUND=1
    fi

    # ${var,,} or ${var^^} case conversion
    HITS=$(grep -nE "^[^#]*\$\{[a-zA-Z_][a-zA-Z_0-9]*(,,|\^\^)\}" "$f" 2>/dev/null || true)
    if [ -n "$HITS" ]; then
        echo "BASH4+ (case conversion) in $f:"
        echo "$HITS"
        FOUND=1
    fi

    # |& pipe shorthand (not in comments)
    HITS=$(grep -nE "^[^#]*[^|]\|&" "$f" 2>/dev/null || true)
    if [ -n "$HITS" ]; then
        echo "BASH4+ (|& pipe) in $f:"
        echo "$HITS"
        FOUND=1
    fi
done < <(find "$TARGET_DIR" -name "*.sh" -print0 2>/dev/null)

# -------------------------------------------------------
# Pass 2: bash -n syntax check under /bin/bash (3.2)
# -------------------------------------------------------
while IFS= read -r -d '' f; do
    SYNTAX_ERR=$(/bin/bash -n "$f" 2>&1)
    if [ -n "$SYNTAX_ERR" ]; then
        echo "SYNTAX FAIL ($f): $SYNTAX_ERR"
        FOUND=1
    fi
done < <(find "$TARGET_DIR" -name "*.sh" -print0 2>/dev/null)

# -------------------------------------------------------
# Summary
# -------------------------------------------------------
if [ "$FOUND" -eq 0 ]; then
    echo "OK: No bash 4+ patterns found in $TARGET_DIR"
fi
exit "$FOUND"
