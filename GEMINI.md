# GEMINI.md — {PROJECT_NAME}

> AntiGravity IDE agent rules. Loaded every session. Keep under 50 lines; details go to `.agents/rules/`.

## Project

- **Name:** {PROJECT_NAME}
- **Stack:** {e.g., TypeScript, React, Node.js}
- **Purpose:** {One sentence — what this project does}

## Build

- Install: `{npm install / pip install -r requirements.txt / etc.}` | Test: `{npm test / pytest / etc.}` | Lint: `{npm run lint / etc.}`

## Rules

- Follow existing patterns in the codebase before inventing new ones
- Write tests for new functionality
- Commit atomic changes with descriptive messages
- PREFER editing existing files over creating new ones
- If anything contradicts this file, flag the contradiction before proceeding

## Conventions

- {Add your naming conventions, code style, etc.}

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

## Naming (full spec: `rules/naming-rules.md`)

All LTC items follow UNG: `{SCOPE}_{FA}.{ID}.{NAME}`. Before creating any named item (repo, folder, ClickUp project/deliverable, Drive item), load `rules/naming-rules.md`.

## Structure
`src/` code | `docs/` reference | `scripts/` utilities | `tests/` tests | `rules/` LTC global rules

## Modular Rules & Skills

Workspace rules: `.agents/rules/` | Workspace skills: `.agents/skills/`
