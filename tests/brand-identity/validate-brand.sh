#!/usr/bin/env bash
# validate-brand.sh — Validates one source file against LTC brand identity rules.
# Usage: validate-brand.sh <file-path>
# Exit: 0 = all pass, 1 = any fail
# Supports: .html, .css, .svg, .py, .md
set -uo pipefail

# ═══════════════════════════════════════════════════════
# Pattern Declarations (centralized — ScalAdj-AC2)
# Source: rules/brand-identity.md
# ═══════════════════════════════════════════════════════

REQUIRED_COLORS=("#004851" "#F2C75C")

REQUIRED_FONTS=("Inter" "Work Sans")

FORBIDDEN_PATTERNS=(
    "#007bff"       # Bootstrap primary
    "#1f77b4"       # matplotlib default blue
    "#ff7f0e"       # matplotlib default orange
    "#0d6efd"       # Bootstrap 5 primary
    "#6c757d"       # Bootstrap secondary
    "tab:blue"      # matplotlib named default
    "tab:orange"    # matplotlib named default
    "Arial"         # generic font
    "Helvetica"     # generic font
    "Roboto"        # generic font
    "DejaVu Sans"   # matplotlib default font
)

# Python-specific forbidden patterns
PYTHON_FORBIDDEN=(
    "plt.style.use"         # overrides LTC palette
    "mpl.style.use"         # overrides LTC palette
    "default_cmap"          # matplotlib default colormap
    "tab10"                 # matplotlib default cycle
    "tab20"                 # matplotlib default cycle
)

# ═══════════════════════════════════════════════════════
# Argument validation
# ═══════════════════════════════════════════════════════

FILE="${1:-}"
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    echo "Usage: validate-brand.sh <file-path>" >&2
    echo "Error: File not found: $FILE" >&2
    exit 1
fi

FILENAME=$(basename "$FILE")
EXT="${FILENAME##*.}"
ERRORS=0

# ═══════════════════════════════════════════════════════
# Check 1: Required colors
# ═══════════════════════════════════════════════════════

check_colors() {
    local missing=0
    for color in "${REQUIRED_COLORS[@]}"; do
        if ! grep -qi "$color" "$FILE"; then
            missing=1
            echo "[FAIL] colors: missing $color in $FILENAME"
        fi
    done
    if [ "$missing" -eq 0 ]; then
        echo "[PASS] colors: $FILENAME"
    fi
    return $missing
}

# ═══════════════════════════════════════════════════════
# Check 2: Required fonts
# ═══════════════════════════════════════════════════════

check_fonts() {
    local missing=0
    for font in "${REQUIRED_FONTS[@]}"; do
        if ! grep -q "$font" "$FILE"; then
            missing=1
            echo "[FAIL] fonts: missing '$font' in $FILENAME"
        fi
    done
    if [ "$missing" -eq 0 ]; then
        echo "[PASS] fonts: $FILENAME"
    fi
    return $missing
}

# ═══════════════════════════════════════════════════════
# Check 3: Forbidden defaults
# ═══════════════════════════════════════════════════════

check_forbidden() {
    local found=0
    for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
        local matches
        matches=$(grep -ni "$pattern" "$FILE" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            found=1
            while IFS= read -r line; do
                echo "[FAIL] forbidden: '$pattern' found — $FILENAME:$line"
            done <<< "$matches"
        fi
    done
    if [ "$found" -eq 0 ]; then
        echo "[PASS] forbidden: $FILENAME"
    fi
    return $found
}

# ═══════════════════════════════════════════════════════
# Check 4: Google Fonts loaded (HTML/CSS/MD only)
# ═══════════════════════════════════════════════════════

check_google_fonts() {
    case "$EXT" in
        html|css|md)
            if grep -q "fonts.googleapis.com" "$FILE" || grep -q "@import.*fonts.googleapis" "$FILE"; then
                echo "[PASS] google-fonts: $FILENAME"
                return 0
            else
                echo "[FAIL] google-fonts: missing Google Fonts <link> or @import in $FILENAME"
                return 1
            fi
            ;;
        *)
            # Not applicable for SVG/Python
            return 0
            ;;
    esac
}

# ═══════════════════════════════════════════════════════
# Check 5: SVG-specific attribute checks
# ═══════════════════════════════════════════════════════

check_svg_attributes() {
    if [ "$EXT" != "svg" ]; then
        return 0
    fi

    local found=0
    # Check for forbidden colors in fill/stroke attributes (case-insensitive)
    for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
        local matches
        matches=$(grep -ni "\\(fill\\|stroke\\).*$pattern" "$FILE" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            found=1
            while IFS= read -r line; do
                echo "[FAIL] svg-attr: forbidden '$pattern' in fill/stroke — $FILENAME:$line"
            done <<< "$matches"
        fi
    done
    if [ "$found" -eq 0 ]; then
        echo "[PASS] svg-attr: $FILENAME"
    fi
    return $found
}

# ═══════════════════════════════════════════════════════
# Check 6: Python-specific checks
# ═══════════════════════════════════════════════════════

check_python() {
    if [ "$EXT" != "py" ]; then
        return 0
    fi

    local found=0
    for pattern in "${PYTHON_FORBIDDEN[@]}"; do
        local matches
        matches=$(grep -n "$pattern" "$FILE" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            found=1
            while IFS= read -r line; do
                echo "[FAIL] python: forbidden '$pattern' — $FILENAME:$line"
            done <<< "$matches"
        fi
    done
    if [ "$found" -eq 0 ]; then
        echo "[PASS] python: $FILENAME"
    fi
    return $found
}

# ═══════════════════════════════════════════════════════
# Run all checks
# ═══════════════════════════════════════════════════════

check_colors      || ERRORS=$((ERRORS + 1))
check_fonts       || ERRORS=$((ERRORS + 1))
check_forbidden   || ERRORS=$((ERRORS + 1))
check_google_fonts || ERRORS=$((ERRORS + 1))
check_svg_attributes || ERRORS=$((ERRORS + 1))
check_python      || ERRORS=$((ERRORS + 1))

if [ "$ERRORS" -gt 0 ]; then
    exit 1
else
    exit 0
fi
