---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: sequence
tags: [appearance, accessibility, productivity, vscode, obsidian, cmux, macos]
---

# Appearance System — SEQUENCE

> Build order for 7 artifacts from `inbox/2026-04-10_DESIGN-appearance-system.md`.
> 2 rounds: Round 1 = 6 independent tasks (parallel). Round 2 = 1 dependent task.

---

## Build Order

### Round 1 — Foundation (parallel, no inter-dependencies)

| Task | Artifact | Write target | Size |
|------|----------|-------------|------|
| T1 | A7 — Palette reference | `_genesis/reference/ltc-appearance-palette.md` | S |
| T2 | A1 — VSCode settings merge | `.vscode/settings.json` | M |
| T3 | A4 — Obsidian appearance.json | `.obsidian/appearance.json` | S |
| T4 | A2 — Ghostty config template | `inbox/2026-04-10_ghostty-config.md` | S |
| T5 | A3 — cmux settings template | `inbox/2026-04-10_cmux-settings.md` | S |
| T6 | A6 — macOS checklist | `inbox/macos-appearance-checklist.md` | S |

### Round 2 — Dependent (after T3 completes)

| Task | Artifact | Write target | Size | Blocked by |
|------|----------|-------------|------|------------|
| T7 | A5 — CSS reading-experience fix | `.obsidian/snippets/ltc-reading-experience.css` | M | T3 |

---

## Task Specs

### T1: Palette Reference Document [independent]

**Artifact:** A7
**Depends on:** none
**Size:** S (<30 min)
**Write target:** `_genesis/reference/ltc-appearance-palette.md`
**DONE when:** AC-7.1 (12-row palette table), AC-7.2 (Name/Hex/Contrast/Role/Apps columns), AC-7.3 (frontmatter v1.0 draft 2026-04-10), AC-7.4 (Links section with wikilinks) — all 4 PASS.

---

### T2: VSCode/Cursor Settings Merge [independent]

**Artifact:** A1
**Depends on:** none
**Size:** M (30–60 min — must preserve all existing keys)
**Write target:** `.vscode/settings.json`
**DONE when:** AC-1.1 (Tokyo Night theme), AC-1.2 (JetBrains Mono fontFamily), AC-1.3 (fontSize:16 + lineHeight:1.6 + letterSpacing:0.5), AC-1.4 ([Tokyo Night] colorCustomizations with Gold cursor + dark bg), AC-1.5 (minimap disabled), AC-1.6 (zero deleted pre-existing keys) — all 6 PASS.

**Critical:** Read current `.vscode/settings.json` first. Merge — do NOT overwrite. Every existing key (workbench.iconTheme, folder-path-color.folders, explorer.*, workbench.colorCustomizations existing keys) must survive.

---

### T3: Obsidian Appearance Config [independent]

**Artifact:** A4
**Depends on:** none
**Size:** S (<30 min)
**Write target:** `.obsidian/appearance.json`
**DONE when:** AC-4.1 (cssTheme: "Minimal"), AC-4.2 (theme: "obsidian"), AC-4.3 (enabledCssSnippets has all 3), AC-4.4 (baseFontSize: 16) — all 4 PASS.

---

### T4: Ghostty Config Template [independent]

**Artifact:** A2 (human-applies)
**Depends on:** none
**Size:** S (<30 min)
**Write target:** `inbox/2026-04-10_ghostty-config.md`
**DONE when:** AC-2.1 (JetBrains Mono + size 15), AC-2.2 (tokyo-night theme string), AC-2.3 (block cursor, no blink, Gold color), AC-2.4 (opacity 0.92 + blur 20), AC-2.5 (adjust-cell-height 6) — all 5 PASS.

**Note:** Produce as a markdown file with install instructions + the raw config block. Human copies to `~/.config/ghostty/config`.

---

### T5: cmux Settings Template [independent]

**Artifact:** A3 (human-applies)
**Depends on:** none
**Size:** S (<30 min)
**Write target:** `inbox/2026-04-10_cmux-settings.md`
**DONE when:** AC-3.1 (valid JSON sidebarTint: "dark"), AC-3.2 (splitDividerColor: "#24283b") — both PASS.

**Note:** Produce as markdown with the JSON block + apply instructions. Human copies to `~/.config/cmux/settings.json`.

---

### T6: macOS System Settings Checklist [independent]

**Artifact:** A6 (human-applies)
**Depends on:** none
**Size:** S (<30 min)
**Write target:** `inbox/macos-appearance-checklist.md`
**DONE when:** AC-6.1 (exactly 8 items in correct order), AC-6.2 (True Tone OFF is Step 1), AC-6.3 (exact System Settings nav path per item), AC-6.4 (verification step per item) — all 4 PASS.

---

### T7: Obsidian Reading-Experience CSS Fix [depends on T3]

**Artifact:** A5
**Depends on:** T3 (theme context must be Minimal before CSS targeting is valid)
**Size:** M (30–60 min — must preserve all existing rule blocks)
**Write target:** `.obsidian/snippets/ltc-reading-experience.css`
**DONE when:** AC-5.1 (.markdown-reading-view line-height 1.8), AC-5.2 (.cm-editor .cm-line line-height 1.6), AC-5.3 (dark H1-H2 = #F2C75C, H3-H6 readable ≥4.5:1, NOT #004851), AC-5.4 (--text-normal #c0caf5), AC-5.5 (.canvas-node-content 15px/1.6), AC-5.6 (zero deleted rule blocks) — all 6 PASS.

**Critical bugs to fix:**
1. `.theme-dark` H1–H6 use `#004851` = 1.7:1 contrast on `#1a1b26` → WCAG fail → replace
2. `--text-normal: #ddd` → replace with `#c0caf5`
3. Missing `.markdown-reading-view` / `.cm-editor .cm-line` differentiation

---

## Dependency Graph

```
T1 (A7 palette)    ─────┐
T2 (A1 VSCode)     ─────┤
T3 (A4 Obsidian) ──┤    ├── Round 1 complete ──→ T7 (A5 CSS fix)
T4 (A2 Ghostty)    ─────┤
T5 (A3 cmux)       ─────┤
T6 (A6 macOS)      ─────┘
```

No circular dependencies. Critical path: T3 → T7 (2 tasks).

---

## AC Summary

| Task | ACs | DESIGN artifact |
|------|-----|----------------|
| T1 | 4 | A7 |
| T2 | 6 | A1 |
| T3 | 4 | A4 |
| T4 | 5 | A2 |
| T5 | 2 | A3 |
| T6 | 4 | A6 |
| T7 | 6 | A5 |
| **Total** | **31** | **7/7 covered** |

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| — | G2-Sequence | Pending | — | — |
