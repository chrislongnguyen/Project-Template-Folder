# GEMINI.md — {PROJECT_NAME}

> AntiGravity IDE agent rules. Loaded every session. Keep under 80 lines; details go to `.agents/rules/`.

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
Typography: **Inter** (English), **Work Sans** (Vietnamese). Both via Google Fonts. Base 11pt, headlines 6x, sub-title 3x, body-title 1.6x.

When generating HTML, CSS, charts, or visual output:
- MUST use LTC palette — NEVER generic defaults (blue, gray, Bootstrap colors)
- Load `rules/brand-identity.md` for full color table and function mappings

## Naming (full spec: `rules/naming-rules.md`)

All LTC items follow UNG: `{SCOPE}_{FA}.{ID}.{NAME}`. Before creating any named item (repo, folder, ClickUp project/deliverable, Drive item), load `rules/naming-rules.md`.

## Security (full spec: `rules/security-rules.md`)

### Secrets
- NEVER hardcode secrets (API keys, tokens, passwords, connection strings) in source code, prompts, or tool arguments
- All secrets MUST live in `.env` or `secrets/` (both gitignored). Reference via environment variables only
- Before completing any task, scan your output for patterns that look like secrets (API keys, tokens, passwords, PII). This check is pattern-based. If found — stop, redact, alert the user

### Execution Risk Tiers
- LOW (read files, search, lint, run tests): proceed without confirmation
- MEDIUM (edit files, git commit, install packages): proceed, user can review
- HIGH (delete files, git push, force operations, deploy, modify CI/CD, touch .env/secrets/): ALWAYS require explicit user confirmation

### Blast Radius
- Operate only within the project directory unless explicitly instructed otherwise
- For destructive or experimental operations, prefer git worktrees or branches — never on main directly
- Prefer reversible actions (git commit) over irreversible ones (file deletion of untracked files)
- When making external API calls or web requests, never include secrets, PII, or confidential data unless the endpoint is explicitly authorized

### Backup Awareness
- Before overwriting non-git-tracked files, warn the user that the original is not recoverable
- NEVER force-push without confirming the remote state and getting explicit approval
- If a file cannot be easily recreated, flag this before modifying it

## Structure
`src/` code | `docs/` reference | `scripts/` utilities | `tests/` tests | `rules/` LTC global rules

## Modular Rules & Skills

Workspace rules: `.agents/rules/` | Workspace skills: `.agents/skills/`
