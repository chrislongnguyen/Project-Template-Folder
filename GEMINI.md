---
version: "1.0"
status: draft
last_updated: 2026-04-07
---
# GEMINI.md — LTC Project Template

> AntiGravity IDE agent rules. Loaded every session. Keep under 80 lines; details go to `.agents/rules/`.
> Cross-agent roster: `AGENTS.md` | Shared rules: `rules/`

## Project
- **Name:** LTC Project Template | **Stack:** Markdown, Shell, Python
- **Purpose:** Standard project scaffold for LTC Partners — a thinking system with 5-workstream ALPEI structure and AI agent config pre-loaded.

## Build
- Template repo — no build step. Validate structure: `./scripts/template-check.sh --quiet`

## Rules
- Follow existing codebase patterns before inventing new ones; write tests for new functionality
- Commit atomic changes with descriptive messages; PREFER editing existing files over creating new ones
- If anything contradicts this file, flag the contradiction before proceeding

## Conventions
- Frontmatter values: lowercase (except `work_stream` which uses numbered SCREAMING: `1-ALIGN`)
- Frontmatter keys: snake_case (`last_updated`, `work_stream`)
- File versions: MAJOR.MINOR where MAJOR = iteration (Iteration 1=1.x, Iteration 2=2.x). Never 0.x.
- Python: snake_case | JS: camelCase | Shell: kebab-case filenames

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

## Agent System (full spec: `rules/agent-system.md`)
Your AI agent has 8 structural limits (LLM Truths). The 7-Component System compensates. Three principles: derisk before output, know the agent's physics, human + agent = complementary.

## System Design (full spec: `rules/general-system.md`)
Every system has 6 components: Input, User, Action, Principles, Tools, Environment → Outcome. Establish RACI first, then analyze forces. Design: Problem Discovery → System Design → VANA Requirements.

## Agent Diagnostics (full spec: `rules/agent-diagnostic.md`)
When agent output is wrong: trace through 6 configurable components (EP → Input → EOP → Environment → Tools → Agent) before blaming the model.

## Structure (5-Workstream ALPEI)
`1-ALIGN/` scope + RACI + decisions | `2-LEARN/` research + constraints (pipeline, NOT DSBV) | `3-PLAN/` architecture + risks | `4-EXECUTE/` src + tests | `5-IMPROVE/` changelog + retros | `_genesis/` org knowledge | `rules/` shared agent rules

## Modular Rules & Skills
Workspace rules: `.agents/rules/` | Workspace skills: `.agents/skills/` | Cross-agent roster: `AGENTS.md`

## Template Version
If `./scripts/template-check.sh` exists, run it with `--quiet` at session start. If behind, warn user. If missing, skip silently.

## Links

- [[AGENTS]]
- [[CHANGELOG]]
- [[DESIGN]]
- [[VALIDATE]]
- [[agent-diagnostic]]
- [[agent-system]]
- [[architecture]]
- [[brand-identity]]
- [[deliverable]]
- [[general-system]]
- [[iteration]]
- [[naming-rules]]
- [[project]]
- [[security]]
- [[security-rules]]
- [[standard]]
- [[task]]
