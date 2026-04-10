---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: design
tags: [appearance, accessibility, productivity, vscode, obsidian, cmux, macos]
---

# Appearance System — DESIGN

> Defines the complete Soft Dark Mode appearance system across 4 applications (VSCode/Cursor, cmux, Obsidian, macOS) anchored to the 12-color LTC palette, optimized for astigmatism (1.5+2.5D) and night work (8pm–midnight).

**Source of truth:** `PERSONAL-KNOWLEDGE-BASE/distilled/developer-appearance-guide.md`

---

## 1. Scope

### In-scope (7 artifacts)

| ID | Artifact | App | Location | Who applies |
|----|----------|-----|----------|-------------|
| A1 | VSCode/Cursor appearance settings | VSCode / Cursor | `.vscode/settings.json` | agent-writes |
| A2 | Ghostty terminal config | cmux | `~/.config/ghostty/config` | human-applies |
| A3 | cmux UI settings | cmux | `~/.config/cmux/settings.json` | human-applies |
| A4 | Obsidian appearance config | Obsidian | `.obsidian/appearance.json` | agent-writes |
| A5 | Obsidian reading-experience CSS fix | Obsidian | `.obsidian/snippets/ltc-reading-experience.css` | agent-writes |
| A6 | macOS system settings checklist | macOS | `inbox/macos-appearance-checklist.md` | human-applies |
| A7 | Shared palette reference | All | `_genesis/reference/ltc-appearance-palette.md` | agent-writes |

### Out-of-scope

- Hardware purchases (monitors, lamps)
- Font installation (`brew install --cask font-jetbrains-mono` — prerequisite, not a deliverable)
- Obsidian community plugin installation (Minimal theme, Style Settings — user installs manually)
- Monitor OSD calibration (Samsung M7, Dell FHD, ViewFinity S8 — documented in research guide)
- Per-monitor font-size switching (workspace zoom — manual workflow, not an artifact)
- f.lux installation (optional upgrade over Night Shift — human decision)
- Stillcolor installation (third-party utility — human installs; documented in A6 checklist)

---

## 2. Principles

Source: `developer-appearance-guide.md` P1–P5

| ID | Principle | Rule |
|----|-----------|------|
| P1 | Soft Dark Mode | Background `#1a1b26`, text `#c0caf5`; NEVER `#000000` or `#FFFFFF`; target contrast 12–15:1 |
| P2 | 60-30-10 | 60% = `#1a1b26` canvas · 30% = `#24283b` chrome/sidebar · 10% = `#F2C75C` LTC Gold accent |
| P3 | Typography | JetBrains Mono, weight 400, size 16px (Retina baseline), line-height 1.6×, letter-spacing 0.3–0.5px |
| P4 | Color Temperature | Night Shift sunset-to-sunrise at maximum warmth (~2500K); True Tone OFF (prevents shimmer with Night Shift) |
| P5 | Flicker Elimination | Display brightness ≥30% (avoids PWM zone); Stillcolor suppresses temporal dithering |

---

## 3. Artifacts

### A1: VSCode/Cursor Appearance Settings

**File:** `.vscode/settings.json` (merge — preserve existing folder-path-color + iconTheme keys)
**App:** VSCode / Cursor
**What it does:** Adds Tokyo Night theme, JetBrains Mono typography, LTC Gold cursor/accent, and Soft Dark Mode color overrides to the existing workspace settings.

**Acceptance Criteria:**
- [ ] AC-1.1: `settings.json` contains `"workbench.colorTheme": "Tokyo Night"` as top-level key
- [ ] AC-1.2: `settings.json` contains `"editor.fontFamily"` with value starting with `'JetBrains Mono'`
- [ ] AC-1.3: `settings.json` contains `"editor.fontSize": 16` AND `"editor.lineHeight": 1.6` AND `"editor.letterSpacing": 0.5`
- [ ] AC-1.4: `workbench.colorCustomizations` contains `"[Tokyo Night]"` scope with `"editorCursor.foreground": "#F2C75C"` and `"editor.background": "#1a1b26"`
- [ ] AC-1.5: `settings.json` contains `"editor.minimap.enabled": false`
- [ ] AC-1.6: All pre-existing keys (folder-path-color, iconTheme, tree.indent, explorer settings) are preserved — diff shows zero deletions of pre-existing keys

---

### A2: Ghostty Terminal Config

**File:** human-applies: `~/.config/ghostty/config`
**App:** cmux (Ghostty renderer)
**What it does:** Configures cmux terminal rendering with Tokyo Night theme, JetBrains Mono, Soft Dark background, Gold cursor, astigmatism-optimized line height.

**Acceptance Criteria:**
- [ ] AC-2.1: File contains `font-family = JetBrains Mono` and `font-size = 15`
- [ ] AC-2.2: File contains `theme = dark:tokyo-night,light:solarized-light`
- [ ] AC-2.3: File contains `cursor-style = block` AND `cursor-style-blink = false` AND `cursor-color = #F2C75C`
- [ ] AC-2.4: File contains `background-opacity = 0.92` AND `background-blur-radius = 20`
- [ ] AC-2.5: File contains `adjust-cell-height = 6`

---

### A3: cmux UI Settings

**File:** human-applies: `~/.config/cmux/settings.json`
**App:** cmux
**What it does:** Configures cmux sidebar and workspace UI to match the Soft Dark chrome layer.

**Acceptance Criteria:**
- [ ] AC-3.1: File is valid JSON containing `"sidebarTint": "dark"`
- [ ] AC-3.2: File contains `"splitDividerColor": "#24283b"` (Night Surface, 30% chrome layer)

---

### A4: Obsidian Appearance Config

**File:** `.obsidian/appearance.json`
**App:** Obsidian
**What it does:** Switches theme from PLN to Minimal, sets dark mode, ensures all 3 CSS snippets remain enabled, sets base font size.

**Acceptance Criteria:**
- [ ] AC-4.1: `appearance.json` contains `"cssTheme": "Minimal"` (changed from `"PLN"`)
- [ ] AC-4.2: `appearance.json` contains `"theme": "obsidian"` (dark mode retained)
- [ ] AC-4.3: `enabledCssSnippets` array contains all three: `"ltc-bases-colors"`, `"ltc-reading-experience"`, `"ltc-folder-colors"`
- [ ] AC-4.4: `appearance.json` contains `"baseFontSize": 16`

---

### A5: Obsidian Reading-Experience CSS Fix

**File:** `.obsidian/snippets/ltc-reading-experience.css`
**App:** Obsidian
**What it does:** Fixes 2 bugs in existing CSS + adds reading/edit mode differentiation.

**Known bugs to fix:**
1. Dark-mode headings use `#004851` (Midnight Green) on `#1a1b26` canvas = ~1.7:1 contrast — invisible, fails WCAG AA (4.5:1)
2. `--text-normal: #ddd` in dark mode is off-palette (should be `#c0caf5`)
3. Missing reading-mode vs. edit-mode typography differentiation

**Acceptance Criteria:**
- [ ] AC-5.1: `.markdown-reading-view` rule exists with `line-height: 1.8` (reading mode breathing room)
- [ ] AC-5.2: `.cm-editor .cm-line` rule exists with `line-height: 1.6` (edit mode tighter)
- [ ] AC-5.3: `.theme-dark` H1–H2 colors are `#F2C75C` (Gold, 10.7:1 on `#1a1b26` ✅); H3–H6 use a light readable color with ≥4.5:1 contrast (NOT `#004851`)
- [ ] AC-5.4: `.theme-dark` block sets `--text-normal` to `#c0caf5` (Ghost White, replacing `#ddd`)
- [ ] AC-5.5: `.canvas-node-content` rule exists with `font-size: 15px` and `line-height: 1.6`
- [ ] AC-5.6: All pre-existing rule blocks (full-width, header accents, table scroll, bases sticky, callouts, checkboxes) are preserved — diff shows zero deleted rule blocks

---

### A6: macOS System Settings Checklist

**File:** `inbox/macos-appearance-checklist.md`
**App:** macOS System Settings
**What it does:** Step-by-step checklist of 8 system settings the human applies via System Settings UI.

**Acceptance Criteria:**
- [ ] AC-6.1: Checklist contains exactly 8 items: (1) True Tone OFF, (2) Night Shift sunset–sunrise max warmth, (3) Refresh Rate 60Hz externals, (4) Increase Contrast ON, (5) Reduce Transparency ON, (6) Reduce Motion ON, (7) Cursor size +2, (8) Stillcolor install+enable
- [ ] AC-6.2: True Tone OFF is listed as Step 1 (must precede Night Shift)
- [ ] AC-6.3: Each item includes exact System Settings navigation path
- [ ] AC-6.4: Each item includes a verification step (what to look for after applying)

---

### A7: Shared Palette Reference

**File:** `_genesis/reference/ltc-appearance-palette.md`
**App:** All (canonical reference)
**What it does:** Single source of truth for the 12-color palette used across all app configs.

**Acceptance Criteria:**
- [ ] AC-7.1: Table has exactly 12 rows matching `developer-appearance-guide.md` §Shared Color Palette
- [ ] AC-7.2: Every row includes: Name · Hex · Contrast pair + ratio · Role · Apps columns
- [ ] AC-7.3: YAML frontmatter: `version: "1.0"`, `status: draft`, `last_updated: 2026-04-10`
- [ ] AC-7.4: `## Links` section with `[[developer-appearance-guide]]` and `[[brand-identity]]`

---

## 4. Shared Palette (canonical)

All colors WCAG AA (≥4.5:1) on canvas `#1a1b26` unless noted.

| # | Name | Hex | Contrast pairing | Role | Apps |
|---|------|-----|-----------------|------|------|
| 1 | Deep Night | `#1a1b26` | — (canvas) | Background 60% | All |
| 2 | Night Surface | `#24283b` | — (chrome) | Sidebar, panels 30% | VSCode, Obsidian, cmux |
| 3 | Ghost White | `#c0caf5` | 10.6:1 on canvas | Primary text | All |
| 4 | LTC Gold | `#F2C75C` | 10.7:1 on canvas | Cursor, active tab, accent 10% | All |
| 5 | LTC Midnight | `#004851` | gold on it: 5.6:1 ✅ | Button/selection BG (not text) | VSCode, Obsidian |
| 6 | ALIGN Gold | `#F2C75C` | 10.7:1 on canvas | 1-ALIGN folder color | VSCode, Obsidian |
| 7 | LEARN Purple | `#B05CE8` | 5.1:1 on canvas | 2-LEARN folder color | VSCode, Obsidian |
| 8 | PLAN Teal | `#5ED4DB` | 9.7:1 on canvas | 3-PLAN folder color | VSCode, Obsidian |
| 9 | EXECUTE Green | `#7ACC5C` | 8.6:1 on canvas | 4-EXECUTE folder color | VSCode, Obsidian |
| 10 | IMPROVE Rose | `#E85D75` | 4.7:1 on canvas | 5-IMPROVE folder color | VSCode, Obsidian |
| 11 | Slate | `#7B8FA6` | 4.6:1 on canvas | System folders (muted) | VSCode, Obsidian |
| 12 | Error Red | `#f7768e` | 5.1:1 on canvas | Errors, deleted lines | VSCode, cmux |

---

## 5. Alignment Table

| Requirement | Artifact(s) | AC(s) |
|-------------|-------------|-------|
| P1 Soft Dark — bg `#1a1b26`, text `#c0caf5` | A1, A2, A4, A5 | AC-1.4, AC-2.2, AC-4.2, AC-5.4 |
| P2 60-30-10 canvas/chrome/accent | A1, A2, A3 | AC-1.4, AC-2.4, AC-3.2 |
| P3 Typography JetBrains Mono 16px 1.6× | A1, A2, A5 | AC-1.2, AC-1.3, AC-2.1, AC-2.5, AC-5.1, AC-5.2 |
| P4 Color Temperature Night Shift/True Tone | A6 | AC-6.1, AC-6.2 |
| P5 Flicker brightness + Stillcolor | A6 | AC-6.1 |
| Tokyo Night theme across apps | A1, A2, A4 | AC-1.1, AC-2.2, AC-4.1 |
| LTC Gold cursor/accent | A1, A2 | AC-1.4, AC-2.3 |
| Obsidian PLN → Minimal theme switch | A4 | AC-4.1 |
| Obsidian CSS snippets all enabled | A4 | AC-4.3 |
| Obsidian dark-mode heading visibility fix | A5 | AC-5.3 |
| Reading vs. edit mode differentiation | A5 | AC-5.1, AC-5.2 |
| Canvas node readability | A5 | AC-5.5 |
| cmux sidebar dark + split divider | A3 | AC-3.1, AC-3.2 |
| macOS 8 accessibility/display settings | A6 | AC-6.1–AC-6.4 |
| 12-color palette documented | A7 | AC-7.1, AC-7.2 |
| No regressions in existing configs | A1, A5 | AC-1.6, AC-5.6 |

**Orphan check:** 16 requirements → 16 mapped. 7 artifacts → 7 covered. **Zero orphans.**

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| — | G1-Design | Pending | — | — |
