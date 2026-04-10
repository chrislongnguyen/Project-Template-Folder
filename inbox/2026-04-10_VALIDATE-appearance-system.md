---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: validate
---

# Appearance System — VALIDATE

## Aggregate Score

29/31 PASS | 0 FAIL | 2 PARTIAL

## Verdict Table

| AC | Artifact | Criterion | Verdict | Evidence |
|----|----------|-----------|---------|----------|
| AC-1.1 | A1 VSCode | `settings.json` contains `"workbench.colorTheme": "Tokyo Night"` as top-level key | PASS | `.vscode/settings.json` line 3: `"workbench.colorTheme": "Tokyo Night"` |
| AC-1.2 | A1 VSCode | `settings.json` contains `"editor.fontFamily"` with value starting with `'JetBrains Mono'` | PASS | `.vscode/settings.json` line 10: `"editor.fontFamily": "'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace"` |
| AC-1.3 | A1 VSCode | `settings.json` contains `"editor.fontSize": 16` AND `"editor.lineHeight": 1.6` AND `"editor.letterSpacing": 0.5` | PASS | `.vscode/settings.json` line 11: `fontSize: 16`, line 12: `lineHeight: 1.6`, line 13: `letterSpacing: 0.5` |
| AC-1.4 | A1 VSCode | `workbench.colorCustomizations` contains `"[Tokyo Night]"` scope with `"editorCursor.foreground": "#F2C75C"` and `"editor.background": "#1a1b26"` | PASS | `.vscode/settings.json` lines 71-90: `"[Tokyo Night]"` block at line 71, `"editor.background": "#1a1b26"` at line 72, `"editorCursor.foreground": "#F2C75C"` at line 73 |
| AC-1.5 | A1 VSCode | `settings.json` contains `"editor.minimap.enabled": false` | PASS | `.vscode/settings.json` line 19: `"editor.minimap.enabled": false` |
| AC-1.6 | A1 VSCode | All pre-existing keys (folder-path-color, iconTheme, tree.indent, explorer settings) are preserved — diff shows zero deletions of pre-existing keys | PARTIAL | File has no prior git commit, so diff-based deletion verification is impossible. All named key categories ARE present: `workbench.iconTheme` (line 2), `workbench.tree.indent` (line 9), `explorer.compactFolders` (line 6), `explorer.decorations.*` (lines 7-8), `folder-path-color.folders` (lines 26-48). Cannot confirm zero deletions without a committed baseline. |
| AC-2.1 | A2 Ghostty | File contains `font-family = JetBrains Mono` and `font-size = 15` | PASS | `inbox/2026-04-10_ghostty-config.md` line 23: `font-family = JetBrains Mono`, line 24: `font-size = 15` |
| AC-2.2 | A2 Ghostty | File contains `theme = dark:tokyo-night,light:solarized-light` | PASS | `inbox/2026-04-10_ghostty-config.md` line 33: `theme = dark:tokyo-night,light:solarized-light` |
| AC-2.3 | A2 Ghostty | File contains `cursor-style = block` AND `cursor-style-blink = false` AND `cursor-color = #F2C75C` | PASS | `inbox/2026-04-10_ghostty-config.md` line 42: `cursor-style = block`, line 43: `cursor-style-blink = false`, line 44: `cursor-color = #F2C75C` |
| AC-2.4 | A2 Ghostty | File contains `background-opacity = 0.92` AND `background-blur-radius = 20` | PASS | `inbox/2026-04-10_ghostty-config.md` line 37: `background-opacity = 0.92`, line 38: `background-blur-radius = 20` |
| AC-2.5 | A2 Ghostty | File contains `adjust-cell-height = 6` | PASS | `inbox/2026-04-10_ghostty-config.md` line 50: `adjust-cell-height = 6` |
| AC-3.1 | A3 cmux | File is valid JSON containing `"sidebarTint": "dark"` | PASS | `inbox/2026-04-10_cmux-settings.md` line 21: `"sidebarTint": "dark"` inside JSON code block. JSON block is syntactically valid (3 keys, properly braced). |
| AC-3.2 | A3 cmux | File contains `"splitDividerColor": "#24283b"` (Night Surface, 30% chrome layer) | PASS | `inbox/2026-04-10_cmux-settings.md` line 23: `"splitDividerColor": "#24283b"` |
| AC-4.1 | A4 Obsidian | `appearance.json` contains `"cssTheme": "Minimal"` (changed from `"PLN"`) | PASS | `.obsidian/appearance.json` line 7: `"cssTheme": "Minimal"` |
| AC-4.2 | A4 Obsidian | `appearance.json` contains `"theme": "obsidian"` (dark mode retained) | PASS | `.obsidian/appearance.json` line 8: `"theme": "obsidian"` |
| AC-4.3 | A4 Obsidian | `enabledCssSnippets` array contains all three: `"ltc-bases-colors"`, `"ltc-reading-experience"`, `"ltc-folder-colors"` | PASS | `.obsidian/appearance.json` lines 2-6: array contains exactly `"ltc-bases-colors"`, `"ltc-reading-experience"`, `"ltc-folder-colors"` |
| AC-4.4 | A4 Obsidian | `appearance.json` contains `"baseFontSize": 16` | PASS | `.obsidian/appearance.json` line 9: `"baseFontSize": 16` |
| AC-5.1 | A5 CSS | `.markdown-reading-view` rule exists with `line-height: 1.8` (reading mode breathing room) | PASS | `.obsidian/snippets/ltc-reading-experience.css` lines 134-138: `.markdown-reading-view, .markdown-preview-view { ... line-height: 1.8 !important; ... }` |
| AC-5.2 | A5 CSS | `.cm-editor .cm-line` rule exists with `line-height: 1.6` (edit mode tighter) | PASS | `.obsidian/snippets/ltc-reading-experience.css` lines 142-144: `.cm-editor .cm-line { line-height: 1.6 !important; ... }` |
| AC-5.3 | A5 CSS | `.theme-dark` H1-H2 colors are `#F2C75C` (Gold); H3-H6 use a light readable color with >=4.5:1 contrast (NOT `#004851`) | PASS | `.obsidian/snippets/ltc-reading-experience.css` lines 63-75: `.theme-dark` block sets `--h1-color: #F2C75C`, `--h2-color: #F2C75C` (Gold). H3-H6 set to `--h3-color: #c0caf5` through `--h6-color: #c0caf5` (Ghost White, 10.6:1 on canvas). Original had `#e0d8c8` (off-palette) and the bug `#004851` was only in the light-mode `body` block -- dark mode fix is correct. |
| AC-5.4 | A5 CSS | `.theme-dark` block sets `--text-normal` to `#c0caf5` (Ghost White, replacing `#ddd`) | PASS | `.obsidian/snippets/ltc-reading-experience.css` line 74: `--text-normal: #c0caf5 !important;` inside `.theme-dark` block. Original committed version had `--text-normal: #ddd !important;` -- correctly replaced. |
| AC-5.5 | A5 CSS | `.canvas-node-content` rule exists with `font-size: 15px` and `line-height: 1.6` | PASS | `.obsidian/snippets/ltc-reading-experience.css` lines 148-151: `.canvas-node-content { font-size: 15px !important; line-height: 1.6 !important; }` |
| AC-5.6 | A5 CSS | All pre-existing rule blocks (full-width, header accents, table scroll, bases sticky, callouts, checkboxes) are preserved — diff shows zero deleted rule blocks | PASS | Compared current file against git commit `6e6cd1a` (original at `_genesis/obsidian/ltc-reading-experience.css`). All 8 original rule blocks present: full-width (line 9), brand colors+typography (line 15), header accents (lines 78-88), table scroll (lines 91-113), bases sticky (lines 116-120), callouts (lines 123-125), checkboxes (lines 128-130). Three blocks added (dark mode updated, reading/edit mode, canvas node). Zero deletions. |
| AC-6.1 | A6 macOS | Checklist contains exactly 8 items: (1) True Tone OFF, (2) Night Shift sunset-sunrise max warmth, (3) Refresh Rate 60Hz externals, (4) Increase Contrast ON, (5) Reduce Transparency ON, (6) Reduce Motion ON, (7) Cursor size +2, (8) Stillcolor install+enable | PASS | `inbox/macos-appearance-checklist.md` Steps 1-8: Step 1 True Tone OFF (line 12), Step 2 Night Shift (line 19), Step 3 Refresh Rate 60Hz (line 29), Step 4 Increase Contrast (line 37), Step 5 Reduce Transparency (line 43), Step 6 Reduce Motion (line 49), Step 7 Cursor Size +2 (line 55), Step 8 Stillcolor (line 61). Exactly 8 items. |
| AC-6.2 | A6 macOS | True Tone OFF is listed as Step 1 (must precede Night Shift) | PASS | `inbox/macos-appearance-checklist.md` line 8: "Apply these 8 settings in ORDER. True Tone must come FIRST." Line 12: "## Step 1 — True Tone: OFF" |
| AC-6.3 | A6 macOS | Each item includes exact System Settings navigation path | PASS | All 8 steps include **Path:** lines: Step 1 (line 14), Step 2 (line 22-24), Step 3 (line 31), Step 4 (line 39), Step 5 (line 45), Step 6 (line 51), Step 7 (line 57), Step 8 shows download URL + 4-step instructions (lines 63-70). |
| AC-6.4 | A6 macOS | Each item includes a verification step (what to look for after applying) | PASS | All 8 steps include **Verify:** lines: Step 1 (line 16), Step 2 (line 26), Step 3 (line 34), Step 4 (line 41), Step 5 (line 47), Step 6 (line 53), Step 7 (line 59), Step 8 (line 72). |
| AC-7.1 | A7 Palette | Table has exactly 12 rows matching `developer-appearance-guide.md` Shared Color Palette | PASS | `_genesis/reference/ltc-appearance-palette.md` lines 16-28: 12 table rows (Deep Night, Night Surface, Ghost White, LTC Gold, LTC Midnight, ALIGN Gold, LEARN Purple, PLAN Teal, EXECUTE Green, IMPROVE Rose, Slate, Error Red). Names and hex values match DESIGN.md section 4 palette exactly. |
| AC-7.2 | A7 Palette | Every row includes: Name, Hex, Contrast pair + ratio, Role, Apps columns | PARTIAL | Table header (line 15) has 7 columns: `#, Name, Hex, Contrast pairing, Ratio, Role, Apps`. DESIGN.md AC-7.2 specifies "Contrast pair + ratio" as one combined concept but the palette splits it into two columns (`Contrast pairing` + `Ratio`). All required data IS present -- Name, Hex, Contrast pair, Ratio, Role, Apps are all populated for every row. However, the column structure is 7 columns vs. the 5-column spec in AC-7.2 ("Name, Hex, Contrast pair + ratio, Role, Apps"). This is a structural variance that provides MORE information, not less. Substantively PASS but structurally deviates from the AC's column list. |
| AC-7.3 | A7 Palette | YAML frontmatter: `version: "1.0"`, `status: draft`, `last_updated: 2026-04-10` | PASS | `_genesis/reference/ltc-appearance-palette.md` lines 1-6: `version: "1.0"`, `status: draft`, `last_updated: 2026-04-10` |
| AC-7.4 | A7 Palette | `## Links` section with `[[developer-appearance-guide]]` and `[[brand-identity]]` | PASS | `_genesis/reference/ltc-appearance-palette.md` lines 39-42: `## Links` section contains `[[developer-appearance-guide]]` and `[[brand-identity]]` (plus two bonus links `[[ltc-reading-experience]]` and `[[ltc-folder-colors]]`). |

## FAIL Items

None.

## PARTIAL Items

### PARTIAL-1: AC-1.6 — Pre-existing VSCode key preservation

- **File:** `.vscode/settings.json`
- **Criterion:** All pre-existing keys (folder-path-color, iconTheme, tree.indent, explorer settings) are preserved — diff shows zero deletions of pre-existing keys
- **Expected:** Git diff showing zero deletions of pre-existing keys
- **Actual:** File has no prior git commit. Cannot produce a diff. All named key categories (iconTheme, tree.indent, explorer.*, folder-path-color.folders) ARE present in the current file.
- **Reason for PARTIAL:** The AC explicitly requires "diff shows zero deletions" but no committed baseline exists for this file. All named categories are verified present. Full PASS requires a committed baseline to diff against.
- **Severity:** cosmetic — all substantive content is present; only the verification method (diff) is unavailable
- **Recommendation:** Commit `.vscode/settings.json` to establish baseline, then this AC becomes fully verifiable.

### PARTIAL-2: AC-7.2 — Palette table column structure

- **File:** `_genesis/reference/ltc-appearance-palette.md`
- **Criterion:** Every row includes: Name, Hex, Contrast pair + ratio, Role, Apps columns
- **Expected:** 5 data columns (Name, Hex, Contrast pair + ratio, Role, Apps) per AC text
- **Actual:** 7 columns — `#, Name, Hex, Contrast pairing, Ratio, Role, Apps`. The `#` column is extra (row numbering). "Contrast pair + ratio" is split into two separate columns. All required data is present and correct.
- **Reason for PARTIAL:** Structural deviation (7 columns vs. implied 5). The deviation provides strictly MORE information. Content is fully correct.
- **Severity:** cosmetic — all required data present; column split is a presentation choice that improves readability

## Coherence Check

**Do artifacts contradict each other?** No.

Cross-artifact consistency verified:
- **Color values consistent:** `#1a1b26` (canvas), `#c0caf5` (text), `#F2C75C` (accent), `#24283b` (chrome) are identical across A1 (VSCode), A2 (Ghostty), A3 (cmux), A4 (Obsidian), A5 (CSS), A7 (palette reference).
- **Font consistent:** JetBrains Mono specified in A1 (line 10), A2 (line 23), A5 (line 22 for monospace). Inter specified in A5 for Obsidian prose text (line 20-21) — not a contradiction; Obsidian uses Inter for prose, JetBrains Mono for code.
- **Theme consistent:** Tokyo Night referenced in A1 (line 3), A2 (line 33), A4 (cssTheme: Minimal for Obsidian — different app, not a contradiction; Obsidian uses Minimal theme + custom CSS, not Tokyo Night directly).
- **Dark mode consistent:** A1 `[Tokyo Night]` scope, A2 `dark:tokyo-night`, A4 `theme: obsidian` (Obsidian's dark mode value), A5 `.theme-dark` overrides — all aligned.
- **Font size:** A1 = 16px (editor), A2 = 15 (terminal), A4 = 16 (baseFontSize), A5 reading = 16px, A5 canvas = 15px — appropriate per-context sizing, no contradiction.

## Completeness Check

**All 7 artifacts present on disk?** Yes.

| ID | Artifact | Path | On disk |
|----|----------|------|---------|
| A1 | VSCode settings | `.vscode/settings.json` | Yes |
| A2 | Ghostty config | `inbox/2026-04-10_ghostty-config.md` | Yes |
| A3 | cmux settings | `inbox/2026-04-10_cmux-settings.md` | Yes |
| A4 | Obsidian appearance | `.obsidian/appearance.json` | Yes |
| A5 | Reading-experience CSS | `.obsidian/snippets/ltc-reading-experience.css` | Yes |
| A6 | macOS checklist | `inbox/macos-appearance-checklist.md` | Yes |
| A7 | Palette reference | `_genesis/reference/ltc-appearance-palette.md` | Yes |
