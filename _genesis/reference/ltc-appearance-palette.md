---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: reference
tags: [appearance, palette, brand, accessibility]
---

# LTC Appearance Palette

> Canonical 12-color palette for the LTC productivity appearance system.
> All colors verified WCAG AA (≥4.5:1) on canvas `#1a1b26` unless noted.
> Source: `PERSONAL-KNOWLEDGE-BASE/distilled/developer-appearance-guide.md`

| # | Name | Hex | Contrast pairing | Ratio | Role | Apps |
|---|------|-----|-----------------|-------|------|------|
| 1 | Deep Night | `#1a1b26` | — (canvas) | — | Background 60% — editor/terminal/notes | All |
| 2 | Night Surface | `#24283b` | — (chrome) | — | Sidebar, panels, status bar 30% | VSCode, Obsidian, cmux |
| 3 | Ghost White | `#c0caf5` | on `#1a1b26` | 10.6:1 ✅ | Primary text | All |
| 4 | LTC Gold | `#F2C75C` | on `#1a1b26` | 10.7:1 ✅ | Cursor, active tab, accent 10% | All |
| 5 | LTC Midnight | `#004851` | gold `#F2C75C` on it | 5.6:1 ✅ | Button/selection background (never text on dark canvas) | VSCode, Obsidian |
| 6 | ALIGN Gold | `#F2C75C` | on `#1a1b26` | 10.7:1 ✅ | 1-ALIGN folder color | VSCode, Obsidian |
| 7 | LEARN Purple | `#B05CE8` | on `#1a1b26` | 5.1:1 ✅ | 2-LEARN folder color | VSCode, Obsidian |
| 8 | PLAN Teal | `#5ED4DB` | on `#1a1b26` | 9.7:1 ✅ | 3-PLAN folder color | VSCode, Obsidian |
| 9 | EXECUTE Green | `#7ACC5C` | on `#1a1b26` | 8.6:1 ✅ | 4-EXECUTE folder color | VSCode, Obsidian |
| 10 | IMPROVE Rose | `#E85D75` | on `#1a1b26` | 4.7:1 ✅ | 5-IMPROVE folder color | VSCode, Obsidian |
| 11 | Slate | `#7B8FA6` | on `#1a1b26` | 4.6:1 ✅ | System/agent folders (muted tier 3) | VSCode, Obsidian |
| 12 | Error Red | `#f7768e` | on `#1a1b26` | 5.1:1 ✅ | Errors, deleted git lines | VSCode, cmux |

## Usage Rules

- **Deep Night (#1a1b26)** is the ONLY canvas color. Never use `#000000`.
- **Ghost White (#c0caf5)** is the ONLY primary text color. Never use `#FFFFFF`.
- **LTC Gold (#F2C75C)** is the ONLY accent color. Use sparingly (10% rule).
- **LTC Midnight (#004851)** is a background-only color — place Gold or white text ON TOP of it. Never use it as foreground text on the dark canvas.
- Colors 6–10 (ALPEI workstream colors) are for folder labels only, not UI chrome.
- Color 11 (Slate) communicates "system/infrastructure — don't touch."

## Links

- [[developer-appearance-guide]]
- [[brand-identity]]
- [[ltc-reading-experience]]
- [[ltc-folder-colors]]
