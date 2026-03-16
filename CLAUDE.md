# CLAUDE.md — {PROJECT_NAME}

> Constitutional rules for the AI agent. Loaded every session.
> Keep this under 50 lines. Move file-specific details to `.claude/rules/`.

## Project

- **Name:** {PROJECT_NAME}
- **Stack:** {e.g., TypeScript, React, Node.js}
- **Purpose:** {One sentence — what this project does}

## Rules

- Follow existing patterns in the codebase before inventing new ones
- Write tests for new functionality
- Commit atomic changes with descriptive messages

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

## Structure

```
src/           — Application source code
docs/          — Reference documentation
scripts/       — Build and utility scripts
tests/         — Test suites
rules/         — LTC global rules (brand identity, naming, security, effectiveness)
```

## Modular Rules

File-specific conventions live in `.claude/rules/` (loaded on demand):
- See `.claude/rules/` for path-scoped rules

## Skills

On-demand procedures live in `.claude/skills/` (loaded when invoked):
- See `.claude/skills/` for available skills
