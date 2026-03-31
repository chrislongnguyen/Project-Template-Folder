#!/usr/bin/env bash
# version: 1.1 | last_updated: 2026-03-29
# Pre-commit hook: validate version metadata on staged files.
# Exit 0 = pass (warnings ok) | Exit 2 = blocking errors

errors=0
warnings=0
total=0

# Skip patterns
skip_pattern="test-fixtures/|archive/|\.gitkeep"

while IFS= read -r file; do
    # Skip deleted files
    [ ! -f "$file" ] && continue

    # Skip exempted paths
    echo "$file" | grep -qE "$skip_pattern" && continue

    # Skip empty files
    [ ! -s "$file" ] && continue

    # Skip binary files (check with git)
    if git diff --cached --numstat -- "$file" 2>/dev/null | grep -q "^-"; then
        continue
    fi
    # Alternate binary check: look for null bytes in first 512 bytes
    if head -c 512 "$file" 2>/dev/null | tr -d '[:print:][:space:]' | grep -q .; then
        continue
    fi

    ext="${file##*.}"
    total=$((total + 1))

    case "$ext" in
        md)
            first_line=$(head -1 "$file" 2>/dev/null)
            if [ "$first_line" = "---" ]; then
                # Has frontmatter — check for required fields in first 30 lines
                has_version=$(head -30 "$file" | grep -c "^version:")
                has_updated=$(head -30 "$file" | grep -c "^last_updated:")
                if [ "$has_version" -eq 0 ] && [ "$has_updated" -eq 0 ]; then
                    echo "x ERROR: $file -- missing 'version' and 'last_updated' in frontmatter"
                    errors=$((errors + 1))
                elif [ "$has_version" -eq 0 ]; then
                    echo "x ERROR: $file -- missing 'version' in frontmatter"
                    errors=$((errors + 1))
                elif [ "$has_updated" -eq 0 ]; then
                    echo "x ERROR: $file -- missing 'last_updated' in frontmatter"
                    errors=$((errors + 1))
                fi
            else
                echo "! WARN:  $file -- no frontmatter found"
                warnings=$((warnings + 1))
            fi
            ;;
        sh|py)
            has_version=$(head -10 "$file" | grep -c "# version:")
            if [ "$has_version" -eq 0 ]; then
                echo "! WARN:  $file -- no '# version:' header found"
                warnings=$((warnings + 1))
            fi
            ;;
        html)
            has_version=$(head -30 "$file" | grep -c '<meta name="version"')
            if [ "$has_version" -eq 0 ]; then
                echo "! WARN:  $file -- no <meta name=\"version\"> found"
                warnings=$((warnings + 1))
            fi
            ;;
    esac
done < <(git diff --cached --name-only 2>/dev/null)

echo "  $total files checked, $errors errors, $warnings warnings"

if [ "$errors" -gt 0 ]; then
    echo "Commit blocked: fix frontmatter errors above before committing."
    exit 2
fi

exit 0
