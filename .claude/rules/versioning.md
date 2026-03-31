# Versioning — Always-On Rule

Every file you edit MUST have version metadata:

- **Markdown files (`.md`):** YAML frontmatter with `version` and `last_updated` fields
- **Shell/Python scripts (`.sh`, `.py`):** Comment header `# version: X.Y | last_updated: YYYY-MM-DD`
- **HTML files:** `<meta name="version" content="X.Y">` and `<meta name="last-updated" content="YYYY-MM-DD">`
- **JSON/YAML/TOML config, binary files (PDF, PPTX):** Exempt — git history is sufficient

**Rules:**
1. `last_updated` MUST be today's absolute date (never relative like "today" or "yesterday")
2. If a file has no frontmatter, ADD it before making other changes
3. Bump `version` when the content changes meaningfully (not for whitespace/typo fixes)
4. Before committing: verify ALL staged files have current metadata
5. `VERSION` (root) and `4-IMPROVE/changelog/CHANGELOG.md` must be updated with every PR
