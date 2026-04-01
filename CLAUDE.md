---
version: "1.0"
last_updated: 2026-03-30
---
# CLAUDE.md — LTC Project Template

> Claude Code agent rules. Loaded every session. Keep under 100 lines; details go to `.claude/rules/`.
> Members: global `~/.claude/CLAUDE.md` handles identity, communication, model routing.
> This file handles project structure, rules, and processes. Template: `_genesis/templates/GLOBAL_CLAUDE_MD_EXAMPLE.md`.

<!-- ── CUSTOMIZE AFTER CLONING (replace placeholders) ──────────────── -->

## Project

- **Name:** LTC Project Template
- **Stack:** Markdown, Shell, Python
- **Purpose:** Standard project scaffold for LTC Partners — a thinking system that captures decisions, risks, and "why" in a 4-zone APEI structure with AI agent config pre-loaded.

## Build

- Template repo — no build step. Validate structure: `./scripts/template-check.sh --quiet`

<!-- ── LTC STANDARD (do not modify below this line) ────────────────── -->

## Rules

- Follow existing patterns before inventing new ones
- Write tests for new functionality
- Commit atomic changes with descriptive messages
- PREFER editing existing files over creating new ones
- If anything contradicts this file, flag the contradiction before proceeding

## Brand Identity (full spec: `rules/brand-identity.md`)

**MANDATORY for ALL visual output** — HTML, CSS, SVG, charts, slide decks, diagrams, emails, PDFs.
Non-compliance = broken output. Load `rules/brand-identity.md` BEFORE generating any visual artifact.

Primary: Midnight Green #004851 | Gold #F2C75C | Dark Gunmetal #1D1F2A | White #FFFFFF
Accent priority: Gold > Ruby Red #9B1842 > Green #69994D > Dark Purple #653469
Logo: "LT Capital Partners" — Midnight Green on light bg, Gold on dark bg.
Typography: **Inter** (English), **Work Sans** (Vietnamese). Google Fonts. Scale: Title 32pt → H1 20pt → H2 16pt → H3 14pt → H4/Body 11pt → Caption 9pt. All headings Bold (700) Midnight Green.

**NEVER:** Use generic/default colors or fonts (no Bootstrap blue, Tailwind gray, Arial, Helvetica, Roboto, system defaults). Never omit Google Fonts `<link>`/`@import`. Every visual artifact MUST include LTC colors and fonts.

## Naming (full spec: `rules/naming-rules.md`)

All LTC items follow UNG: `{SCOPE}_{FA}.{ID}.{NAME}`. Load `rules/naming-rules.md` before creating any named item.

## Security (full spec: `rules/security-rules.md`)

- **Secrets:** NEVER hardcode secrets in source/prompts/tool args. Use `.env` or `secrets/` via env vars. Scan output for secret patterns before completing any task
- **LOW risk** (read, search, lint, test): proceed without confirmation
- **MEDIUM risk** (edit, commit, install): proceed, user can review
- **HIGH risk** (delete, push, force ops, deploy, touch .env/secrets/): ALWAYS require explicit user confirmation
- **Blast radius:** Operate within project dir only. Prefer branches over main. Prefer reversible actions
- Full spec covers backup awareness, PII handling, external API rules

## Agent System (full spec: `rules/agent-system.md`)
8 LLM Truths + 7-CS (AI specialization of the universal 8-component model). Load full spec for details.
Multi-agent roster: ltc-planner (Opus, Design+Seq), ltc-builder (Sonnet, Build), ltc-reviewer (Opus, Validate), ltc-explorer (Haiku, Research). Agent files: `.claude/agents/`. Tool routing: `rules/tool-routing.md`.

## System Design (full spec: `rules/general-system.md`)
Universal 8-component model (EI→EU→EA→EO + EP→EOE→EOT→EOP) + RACI + force analysis + VANA requirements. Load BEFORE designing any system or writing any spec.

## Agent Diagnostics (full spec: `rules/agent-diagnostic.md`)
Trace 6 configurable components before blaming the model. Derisk checklist + symptom-to-component lookup in full spec.

## DSBV Process (full spec: `_genesis/templates/DSBV_PROCESS.md`)
Every zone uses **Design → Sequence → Build → Validate**. Run `/dsbv` for guided flow. No zone artifact is produced outside DSBV. Phase ordering enforced: Design before Build, Validate before zone complete.

## EOP Governance (full spec: `_genesis/reference/ltc-eop-gov.md`)
Before creating or reviewing any skill, load `_genesis/reference/ltc-eop-gov.md`. Run `./scripts/skill-validator.sh <skill-dir>` before committing skill changes. Use `/ltc-skill-creator` for guided skill creation.

## Feedback (full spec: `.claude/skills/quality/feedback/SKILL.md`)
When a user expresses frustration, confusion, or suggests an improvement, offer: "Want me to capture this as feedback? Takes 30 seconds with /feedback." Feedback creates a GitHub Issue for template maintainers.

## Before Every Task — Pre-Flight Protocol

1. **CHECK ZONE:** Which zone is this task in? Run `/dsbv status` to see current progress
2. **CHECK ALIGNMENT:** Read `1-ALIGN/charter/` — understand purpose, stakeholders, success criteria
3. **CHECK RISKS:** Read `3-PLAN/risks/UBS_REGISTER.md` — what can go wrong with this task
4. **CHECK DRIVERS:** Read `3-PLAN/drivers/UDS_REGISTER.md` — what you can leverage
5. **CHECK LEARNING:** Scan `2-LEARN/` — prior research, specs, and reference materials
6. **EXECUTE** with 3 pillars: Sustainability > Efficiency > Scalability
7. **DOCUMENT** decisions in `1-ALIGN/decisions/` for non-trivial architectural choices

## Structure (5x4 Matrix)

```
Zone 0 — Agent Governance         → CLAUDE.md, AGENTS.md, .claude/, rules/, 0-GOVERN/ (DSBV artifacts)
Zone 1 — ALIGN (Right Outcome)    → 1-ALIGN/ (charter, decisions, okrs)
Zone 2 — LEARN (Problem Research) → 2-LEARN/ (input, research, specs, output — learning pipeline outputs)
Zone 3 — PLAN (Minimize Risks)    → 3-PLAN/ (architecture, risks, drivers, roadmap)
Zone 4 — EXECUTE (Deliver)        → 4-EXECUTE/ (src, tests, config, docs)
Zone 5 — IMPROVE (Learn & Grow)   → 5-IMPROVE/ (changelog, metrics, retros, reviews)
Shared  — Org Knowledge Base      → _genesis/ (brand, frameworks, security, sops, templates)
```

**Core Equation:** Success = Efficient & Scalable Management of Failure Risks

Every artifact must be categorized: which subsystem x which workstream. No chat-only decisions.

## Modular Rules & Skills
Path-scoped rules: `.claude/rules/` | On-demand skills: `.claude/skills/` | Global: `_genesis/`

## Version Control (full spec: `_genesis/frameworks/HISTORY_VERSION_CONTROL.md`)
- When editing any zone artifact, update its `version` and `last_updated` frontmatter
- Follow I0-I4 branching strategy — never commit directly to main
- Commit messages: `type(zone): description` (e.g., `feat(align): add stakeholder analysis`)
- Update `5-IMPROVE/changelog/CHANGELOG.md` as part of every PR
- Every decision with multiple viable options → ADR in `1-ALIGN/decisions/`
- Chain of thought: document the "why" in the artifact, not just the "what"

## Template Version
If `./scripts/template-check.sh` exists, run `./scripts/template-check.sh --quiet` at session start. If behind, warn user. If missing, skip.
