---
version: "2.0"
status: draft
last_updated: 2026-04-07
---
# codex.md — LTC Project Template

> OpenAI Codex agent rules. Loaded every session.
> For full governance, see: `AGENTS.md` (cross-agent roster), `rules/` (shared rules).

## Project
- **Name:** LTC Project Template
- **Stack:** Markdown, Shell, Python
- **Purpose:** Standard project scaffold for LTC Partners — a thinking system with 5-workstream ALPEI structure and AI agent config pre-loaded.

## Build
- Template repo — no build step. Validate structure: `./scripts/template-check.sh --quiet`

## Rules
- Follow existing codebase patterns before inventing new ones
- Write tests for new functionality
- Commit atomic changes with descriptive messages
- PREFER editing existing files over creating new ones
- Document the "why" in artifacts, not just the "what"

## Brand Identity (full spec: `rules/brand-identity.md`)
Primary palette:
- Midnight Green #004851 (dark primary)
- Gold #F2C75C (accent primary)
- Dark Gunmetal #1D1F2A (text/dark backgrounds)
- White #FFFFFF (text/light backgrounds)

Accent priority: Gold > Ruby Red #9B1842 > Green #69994D > Dark Purple #653469
Typography: **Inter** (English), **Work Sans** (Vietnamese). Both via Google Fonts.

When generating HTML, CSS, charts, or visual output:
- MUST use LTC palette — NEVER generic defaults
- Load `rules/brand-identity.md` for full color table

## Naming (full spec: `rules/naming-rules.md`)
All LTC items follow UNG: `{SCOPE}_{FA}.{ID}.{NAME}`. Load `rules/naming-rules.md` before creating named items.

## Security (full spec: `rules/security-rules.md`)
- NEVER hardcode secrets in source code, prompts, or tool arguments
- All secrets in `.env` or `secrets/` via env vars only
- LOW risk (read, search, lint, test): proceed without confirmation
- MEDIUM risk (edit, commit, install): proceed, user can review
- HIGH risk (delete, push, force ops, deploy, touch .env/secrets/): ALWAYS confirm

## Agent System (full spec: `rules/agent-system.md`)
8 LLM structural limits (Truths). 7-Component System compensates. Three principles: derisk before output, know the physics, human + agent = complementary.

## Structure (5-Workstream ALPEI)
```
1-ALIGN/   — scope, RACI, stakeholders, decisions
2-LEARN/   — research, constraints, effective principles (pipeline, NOT DSBV)
3-PLAN/    — architecture, risks, drivers, roadmaps
4-EXECUTE/ — src, tests, config, docs
5-IMPROVE/ — changelog, metrics, retros, reviews
_genesis/  — org knowledge, frameworks, templates, brand
rules/     — shared agent rules (all IDEs read these)
```

## Modular Rules
Shared rules: `rules/` | Agent roster: `AGENTS.md` | Full governance: `_genesis/`
