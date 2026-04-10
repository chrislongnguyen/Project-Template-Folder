---
title: cmux / Ghostty Config Template
applies_to: ~/.config/ghostty/config
last_updated: 2026-04-10
---

# cmux / Ghostty Appearance Config

**Apply:** Copy the config block below to `~/.config/ghostty/config`
**Reload:** `Cmd+Shift+,` (live reload, no restart needed)
**Note:** cmux uses Ghostty as its terminal renderer. `~/.tmux.conf` does NOT apply.

## Steps
1. `mkdir -p ~/.config/ghostty`
2. Copy config block below to `~/.config/ghostty/config`
3. Open cmux → press `Cmd+Shift+,` to reload
4. Verify: background is dark gray (not black), font is JetBrains Mono, cursor is gold block

## Config

```ini
# ── FONT ────────────────────────────────────────────────
font-family = JetBrains Mono
font-size = 15
# Adjust font-size per monitor:
#   MacBook Air Retina: 15
#   Samsung ViewFinity S8: 16
#   Dell FHD: 17
#   Samsung M7 43" TV: measure distance first (see appearance-blueprint.md)

# ── THEME ───────────────────────────────────────────────
# Soft Dark Mode — matches VSCode Tokyo Night + Obsidian Minimal
theme = dark:tokyo-night,light:solarized-light

# ── BACKGROUND ──────────────────────────────────────────
# Soft dark: #1a1b26 (not pure black — eliminates halation for astigmatism)
background-opacity = 0.92
background-blur-radius = 20

# ── CURSOR ──────────────────────────────────────────────
# Gold static block — matches VSCode cursor color, no flicker
cursor-style = block
cursor-style-blink = false
cursor-color = #F2C75C

# ── PADDING + LINE HEIGHT ───────────────────────────────
window-padding-x = 10
window-padding-y = 8
# Adds ~6px per cell height → equivalent to 1.6× line height for astigmatism
adjust-cell-height = 6

# ── SHELL ───────────────────────────────────────────────
shell-integration = zsh
```

## Font Size by Distance (Samsung M7 43" TV)

| Distance | Font size |
|----------|-----------|
| 60cm | 21px |
| 80cm | 28px |
| 100cm | 35px |
| 120cm | 42px |
| 150cm | 52px |

Measure your actual sitting distance to determine correct value.
