# AGENTS.md — {PROJECT_NAME}

> Universal agent rules (AAIF standard). Readable by Claude Code, Cursor, Gemini CLI, AntiGravity, and other AI tools.
> Keep minimal — Claude Code reads both CLAUDE.md and AGENTS.md, so avoid duplicating content.

## Build

- Install: `{npm install / pip install -r requirements.txt / etc.}`
- Test: `{npm test / pytest / etc.}`
- Lint: `{npm run lint / ruff check / etc.}`
- Build: `{npm run build / etc.}`

## Core Conventions

- {Add conventions that ALL AI tools in your team should follow}

## Brand Identity (full spec: `rules/brand-identity.md`)

Primary palette:
- Midnight Green #004851 (dark primary, Pantone 316C)
- Gold #F2C75C (accent primary, Pantone 141C)
- Dark Gunmetal #1D1F2A (text/dark backgrounds)
- White #FFFFFF (text/light backgrounds)

Accent priority: Gold > Ruby Red #9B1842 > Green #69994D > Dark Purple #653469

Logo: "LT Capital Partners" — Midnight Green on light bg, Gold on dark bg.
Typography: Tenorite (English), Work Sans (Vietnamese). Base 11pt, headlines 6x, sub-title 3x, body-title 1.6x.

When generating HTML, CSS, charts, or visual output:
- MUST use LTC palette — NEVER generic defaults (blue, gray, Bootstrap colors)
- Load `rules/brand-identity.md` for full color table and function mappings
