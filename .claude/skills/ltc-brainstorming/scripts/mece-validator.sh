#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-29
# MECE Validator — checks VANA-SPEC for basic structural integrity
# Usage: ./mece-validator.sh /path/to/spec.md
# Exit: 0 = pass, 1 = fail
set -euo pipefail

SPEC="${1:?Usage: mece-validator.sh /path/to/spec.md}"
ERRORS=0

echo "=== MECE Validator ==="
echo "Spec: $SPEC"
echo ""

# Check file exists
if [ ! -f "$SPEC" ]; then
    echo "FAIL: Spec file not found: $SPEC"
    exit 1
fi

# Check 1: §0 Force Analysis present with recursive decomposition
echo "Check 1: §0 Force Analysis present"
if grep -q "§0 Force Analysis\|§0\.1 UBS" "$SPEC"; then
    if grep -q "Recursive Decomposition" "$SPEC"; then
        echo "  PASS: §0 Force Analysis with recursive decomposition found"
    else
        echo "  FAIL: §0 Force Analysis found but missing Recursive Decomposition"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  FAIL: §0 Force Analysis section not found"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: §6 System Boundaries with all 4 layers (two-pass: locate §6, then search within)
echo "Check 2: §6 System Boundaries completeness"
LAYERS_FOUND=0
SECTION_START=$(grep -n "§6\|System Boundaries" "$SPEC" | head -1 | cut -d: -f1)
if [ -n "$SECTION_START" ]; then
    for layer in "Layer 1" "Layer 2" "Layer 3" "Layer 4"; do
        if tail -n +"$SECTION_START" "$SPEC" | grep -q "$layer"; then
            LAYERS_FOUND=$((LAYERS_FOUND + 1))
        fi
    done
fi
if [ "$LAYERS_FOUND" -eq 4 ]; then
    echo "  PASS: All 4 boundary layers present"
else
    echo "  FAIL: Only $LAYERS_FOUND/4 boundary layers found"
    ERRORS=$((ERRORS + 1))
fi

# Check 3: AC ID uniqueness — scoped to lines before AC-TEST-MAP (avoid false positives)
echo "Check 3: AC ID uniqueness"
# Determine the boundary line: AC-TEST-MAP section start (or end of file)
TESTMAP_BOUNDARY=$(grep -n "AC-TEST-MAP" "$SPEC" | head -1 | cut -d: -f1)
if [ -n "$TESTMAP_BOUNDARY" ]; then
    AC_IDS=$(head -n "$((TESTMAP_BOUNDARY - 1))" "$SPEC" | grep -oE '(Verb|SustainAdv|EffAdv|ScalAdv|Noun|SustainAdj|EffAdj|ScalAdj)-AC[0-9]+' | sort)
else
    AC_IDS=$(grep -oE '(Verb|SustainAdv|EffAdv|ScalAdv|Noun|SustainAdj|EffAdj|ScalAdj)-AC[0-9]+' "$SPEC" | sort)
fi
UNIQUE_AC_IDS=$(echo "$AC_IDS" | sort -u)
UNIQUE_AC=$(echo "$UNIQUE_AC_IDS" | grep -c . || true)

# Find duplicates within scoped region
DUPLICATES=$(echo "$AC_IDS" | sort | uniq -d)
if [ -z "$DUPLICATES" ]; then
    echo "  PASS: No duplicate AC IDs ($UNIQUE_AC unique IDs found)"
else
    echo "  FAIL: Duplicate AC IDs found:"
    echo "$DUPLICATES" | while read -r dup; do
        COUNT=$(echo "$AC_IDS" | grep -c "^${dup}$")
        echo "    $dup appears $COUNT times"
    done
    ERRORS=$((ERRORS + 1))
fi

# Check 4: AC-TEST-MAP coverage (every AC in §2-§5 appears in AC-TEST-MAP)
echo "Check 4: AC-TEST-MAP MECE coverage"
if grep -q "AC-TEST-MAP" "$SPEC"; then
    # Extract ACs that appear in the AC-TEST-MAP section
    # Look for AC IDs after the AC-TEST-MAP header
    TESTMAP_START=$(grep -n "AC-TEST-MAP" "$SPEC" | head -1 | cut -d: -f1)
    if [ -n "$TESTMAP_START" ]; then
        TESTMAP_ACS=$(tail -n +"$TESTMAP_START" "$SPEC" | grep -oE '(Verb|SustainAdv|EffAdv|ScalAdv|Noun|SustainAdj|EffAdj|ScalAdj)-AC[0-9]+' | sort -u)
        # Get ACs from §2-§5 only (before §6 or AC-TEST-MAP)
        SECTION_ACS=$(head -n "$((TESTMAP_START - 1))" "$SPEC" | grep -oE '(Verb|SustainAdv|EffAdv|ScalAdv|Noun|SustainAdj|EffAdj|ScalAdj)-AC[0-9]+' | sort -u)

        MISSING_FROM_MAP=$(comm -23 <(echo "$SECTION_ACS") <(echo "$TESTMAP_ACS") 2>/dev/null || true)
        if [ -z "$MISSING_FROM_MAP" ]; then
            echo "  PASS: All ACs from §2-§5 appear in AC-TEST-MAP"
        else
            echo "  FAIL: ACs in §2-§5 missing from AC-TEST-MAP:"
            echo "$MISSING_FROM_MAP" | sed 's/^/    /'
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo "  WARN: Could not locate AC-TEST-MAP section start"
    fi
else
    echo "  FAIL: No AC-TEST-MAP section found"
    ERRORS=$((ERRORS + 1))
fi

# Check 5: Source references follow format conventions
echo "Check 5: Source reference format"
SOURCE_REFS=$(grep -oE 'T0\.P[0-9]+:[A-Za-z0-9]+:[A-Za-z0-9]+' "$SPEC" 2>/dev/null | wc -l | tr -d ' ')
if [ "$SOURCE_REFS" -gt 0 ]; then
    echo "  PASS: $SOURCE_REFS source references in Page:Row:Col format"
else
    echo "  WARN: No source references in T0.Pn:Row:Col format found (may be placeholder)"
fi

echo ""
echo "=== Results ==="
if [ "$ERRORS" -eq 0 ]; then
    echo "PASS: All checks passed"
    exit 0
else
    echo "FAIL: $ERRORS check(s) failed"
    exit 1
fi
