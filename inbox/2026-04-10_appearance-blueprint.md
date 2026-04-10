---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: blueprint
tags: [appearance, productivity, accessibility, vscode, obsidian, cmux, macos]
---

# LTC Appearance Blueprint

> **Single source of truth.** Claude Code reads this before making any appearance change across any app.
> Profile: Long Nguyen · Astigmatism 1.5+2.5D · Night work 8pm–midnight · 4 monitors.

---

## The 5 Principles

```
P1  SOFT DARK MODE      Never pure black, never pure white
P2  60-30-10            Canvas · Chrome · Accent — strict proportions
P3  TYPOGRAPHY          JetBrains Mono, sized per monitor, spaced for blur
P4  COLOR TEMPERATURE   2500K at night, True Tone OFF
P5  FLICKER-FREE        Brightness ≥30%, Stillcolor kills temporal dithering
```

### P1 — Soft Dark Mode
Pure black (#000000) + pure white (#FFFFFF) = 21:1 contrast = halation for astigmatic eyes. The fix: reduce luminance extremes.

```
Background  →  #1a1b26   (dark gray, not black)
Text        →  #c0caf5   (off-white, not white)
Contrast    →  10–15:1   (above WCAG AAA, below halation threshold)
```

### P2 — 60-30-10
```
60%  CANVAS   #1a1b26   Editor/terminal/note background — zero stimulus
30%  CHROME   #24283b   Sidebar, status bar, panels — spatial hierarchy
10%  ACCENT   #F2C75C   Cursor, active tab, folder labels — navigation signal
```
Gold (#F2C75C) is the ONLY accent color. Scarcity is what makes it work.

### P3 — Typography by Monitor
```
Monitor                PPI    Distance   Font Size  Line Height  Letter Spacing
─────────────────────────────────────────────────────────────────────────────
MacBook Air M3 Retina  227    ~55cm      16px       1.6×         0.3px
Samsung ViewFinity S8  ~108   ~65cm      17px       1.6×         0.4px
Dell FHD 1080p          ~92   ~65cm      18px       1.7×         0.5px
Samsung M7 43" TV (4K) ~102   measure→   see table  1.7×         0.5px
```
**Samsung M7 font size by actual distance:**
60cm→21px · 80cm→28px · 100cm→35px · 120cm→42px · 150cm→52px

**Font stack:** `'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace`
**Weight:** 400 (Normal) — never 300 (too thin), never 700 for code (crowding)

### P4 — Color Temperature
- Night Shift: ON · Sunset to Sunrise · Maximum Warmth (~2500K)
- **True Tone: OFF** (must be first — True Tone + Night Shift = shimmer)
- Upgrade: f.lux (62% blue reduction vs Night Shift's 37%) — disable Night Shift if using

### P5 — Flicker Elimination
- Display brightness: ≥30% always (below 30% = PWM flicker zone)
- Stillcolor: installed, enabled per display (suppresses temporal dithering)
- Cursor: static block, no blink

---

## The 12-Color Palette

```
#  Name              Hex        Contrast on #1a1b26  Role
── ──────────────────── ─────────  ───────────────────  ───────────────────────────────
1  Deep Night         #1a1b26    —  (canvas)            Background 60% — all apps
2  Night Surface      #24283b    —  (chrome)            Sidebar / panels 30% — VSCode, Obsidian, cmux
3  Ghost White        #c0caf5    10.6:1 ✅              Primary text — all apps
4  LTC Gold           #F2C75C    10.7:1 ✅              Cursor, active tab, accent 10% — all apps
5  LTC Midnight       #004851    bg only (gold on it: 5.6:1 ✅)  Button/selection background — VSCode, Obsidian
6  ALIGN Gold         #F2C75C    10.7:1 ✅              1-ALIGN folder — VSCode, Obsidian
7  LEARN Purple       #B05CE8    5.1:1  ✅              2-LEARN folder — VSCode, Obsidian
8  PLAN Teal          #5ED4DB    9.7:1  ✅              3-PLAN folder — VSCode, Obsidian
9  EXECUTE Green      #7ACC5C    8.6:1  ✅              4-EXECUTE folder — VSCode, Obsidian
10 IMPROVE Rose       #E85D75    4.7:1  ✅              5-IMPROVE folder — VSCode, Obsidian
11 Slate              #7B8FA6    4.6:1  ✅              System folders (muted) — VSCode, Obsidian
12 Error Red          #f7768e    5.1:1  ✅              Errors, deleted lines — VSCode, cmux
```

**Folder 3-tier system:**
```
TIER 1 (ALPEI — vivid, 3px border, 700 weight):  colors 6–10
TIER 2 (Human-facing — vivid, diff palette, 3px): inbox=Orange, DAILY-NOTES=Sky Blue,
                                                    MISC-TASKS=Yellow, PEOPLE=Magenta, PKB=Blue
TIER 3 (System — muted slate, no border, 400w):   _genesis, plugins, rules, scripts, tools, dot-folders
```

---

## Per-App Settings

### VSCode / Cursor

```json
{
  "workbench.colorTheme": "Tokyo Night",
  "editor.fontFamily": "'JetBrains Mono', 'Fira Code', monospace",
  "editor.fontSize": 16,
  "editor.lineHeight": 1.6,
  "editor.letterSpacing": 0.5,
  "editor.fontLigatures": true,
  "editor.fontWeight": "400",
  "editor.cursorBlinking": "expand",
  "editor.cursorStyle": "block",
  "editor.renderWhitespace": "boundary",
  "editor.minimap.enabled": false,
  "editor.wordWrap": "on",
  "workbench.colorCustomizations": {
    "[Tokyo Night]": {
      "editor.background": "#1a1b26",
      "editorCursor.foreground": "#F2C75C",
      "tab.activeBorderTop": "#F2C75C",
      "activityBar.activeBorder": "#F2C75C",
      "activityBarBadge.background": "#F2C75C",
      "activityBarBadge.foreground": "#1D1F2A",
      "list.activeSelectionBackground": "#00485166",
      "list.hoverBackground": "#0048511A",
      "list.highlightForeground": "#F2C75C",
      "button.background": "#004851",
      "tree.indentGuidesStroke": "#00485155",
      "sideBar.border": "#00485122",
      "focusBorder": "#F2C75C66"
    }
  },
  "terminal.integrated.fontFamily": "'JetBrains Mono', monospace",
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.lineHeight": 1.5
}
```

**Display switching:** Add `"window.zoomLevel": 0` (MacBook/S8) or `0.5` (Dell) in separate workspace files.

---

### cmux / Ghostty

**`~/.config/ghostty/config`** (Ghostty INI — no quotes around values):
```ini
# Font
font-family = JetBrains Mono
font-size = 15

# Theme
theme = dark:tokyo-night,light:solarized-light

# Background — Soft Dark
background-opacity = 0.92
background-blur-radius = 20

# Cursor — static gold block
cursor-style = block
cursor-style-blink = false
cursor-color = #F2C75C

# Padding + line height
window-padding-x = 10
window-padding-y = 8
adjust-cell-height = 6

# Shell
shell-integration = zsh
```

**`~/.config/cmux/settings.json`:**
```json
{
  "sidebarTint": "dark",
  "workspaceColors": true,
  "splitDividerColor": "#24283b"
}
```
Reload: `Cmd+Shift+,`

---

### Obsidian

**Theme:** Minimal (install via Settings → Appearance → Themes)
**Plugin needed:** Style Settings (for Minimal theme customization)

**`appearance.json` settings** (applied by agent):
```json
{
  "cssTheme": "Minimal",
  "theme": "obsidian",
  "baseFontSize": 16,
  "enabledCssSnippets": ["ltc-bases-colors", "ltc-reading-experience", "ltc-folder-colors"]
}
```

**CSS overrides** (in `ltc-reading-experience.css`):
```css
/* Reading mode — more breathing room */
.markdown-reading-view, .markdown-preview-view {
  font-size: 16px !important;
  line-height: 1.8 !important;
  letter-spacing: 0.3px !important;
}

/* Edit/source mode — tighter */
.cm-editor .cm-line {
  line-height: 1.6 !important;
  letter-spacing: 0.3px !important;
}

/* Dark mode headings — fix invisible #004851 bug */
.theme-dark {
  --h1-color: #F2C75C !important;  /* Gold 10.7:1 ✅ */
  --h2-color: #F2C75C !important;
  --h3-color: #c0caf5 !important;  /* Ghost White 10.6:1 ✅ */
  --h4-color: #c0caf5 !important;
  --text-normal: #c0caf5 !important;
}
```

**Folder colors:** Already built in `ltc-folder-colors.css` (3-tier system, v1.1).

---

### macOS System

Execute in this exact order (True Tone FIRST):

```
1. Displays → True Tone → OFF                     ← prevents Night Shift shimmer
2. Displays → Night Shift → Sunset to Sunrise, MAX warmth
3. Displays → Refresh Rate → 60 Hz (all externals)
4. Accessibility → Display → Increase Contrast → ON
5. Accessibility → Display → Reduce Transparency → ON
6. Accessibility → Display → Reduce Motion → ON
7. Accessibility → Display → Cursor size → +2 notches
8. Install Stillcolor (stillcolor.app) → enable per display → No Dithering
```

---

## Night-Work Checklist (8pm session start)

```
[ ] Night Shift active (auto — verify menu bar)
[ ] True Tone OFF (permanent — no action needed)
[ ] Stillcolor active (runs at login — verify menu bar icon)
[ ] Room lamp ON, warm white (2700–3000K)
[ ] Cursor IDE: Tokyo Night visible, Gold cursor present
[ ] cmux: background dark gray (not black), JetBrains Mono
[ ] Obsidian: Minimal theme, folder colors visible
[ ] Display brightness: 35–50%
```

---

## Prerequisites (human installs once)

```bash
# Font
brew install --cask font-jetbrains-mono

# cmux
brew tap manaflow-ai/cmux && brew install --cask cmux

# VSCode extension (Tokyo Night)
# CMD+Shift+P → "Install Extensions" → search "Tokyo Night" by enkia
# OR: code --install-extension enkia.tokyo-night

# Obsidian: Community Themes → Minimal (install in-app)
# Obsidian: Community Plugins → Style Settings (install in-app)

# Stillcolor: download from stillcolor.app
```

---

## Links

- [[developer-appearance-guide]] — full research doc (59 sources, critic-reviewed)
- [[ltc-reading-experience]] — Obsidian reading CSS snippet
- [[ltc-folder-colors]] — Obsidian folder 3-tier color snippet
- [[ltc-bases-colors]] — Obsidian Bases table colors
- [[cursor-appearance]] — VSCode/Cursor appearance system doc
- [[brand-identity]] — LTC brand spec (Midnight Green + Gold)
