---
version: "1.2"
status: draft
last_updated: 2026-04-06
---
# CLAUDE.md — LTC Project Template

> Claude Code agent rules. Loaded every session. Keep under 100 lines; details go to `.claude/rules/`.
> Members: global `~/.claude/CLAUDE.md` handles identity, communication, model routing.
> This file handles project structure, rules, and processes. Template: `_genesis/templates/global-claude-md-example.md`.

<!-- ── CUSTOMIZE AFTER CLONING (replace placeholders) ──────────────── -->

## Project

- **Name:** LTC Project Template
- **Stack:** Markdown, Shell, Python
- **Purpose:** Standard project scaffold for LTC Partners — a thinking system that captures decisions, risks, and "why" in a 5-workstream ALPEI structure with AI agent config pre-loaded.

## Build

- Template repo — no build step. Validate structure: `./scripts/template-check.sh --quiet`

<!-- ── LTC STANDARD (do not modify below this line) ────────────────── -->

## Rules

- Follow existing patterns before inventing new ones
- Write tests for new functionality
- Commit atomic changes with descriptive messages
- PREFER editing existing files over creating new ones
- Document the "why" in artifacts, not just the "what"

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
- **HIGH risk** (delete, push, force ops, deploy, touch .env/secrets/): ALWAYS require explicit confirmation. Prefer branches, prefer reversible.
- Full spec covers blast radius, backup awareness, PII handling, external API rules

## Agent System (full spec: `rules/agent-system.md`)
8 LLM Truths + 7-CS. Agent roster in auto-loaded `agent-dispatch.md`. Agent files: `.claude/agents/`. Tool routing: `rules/tool-routing.md`.

## System Design (full spec: `rules/general-system.md`)
Universal 8-component model (EI→EU→EA→EO + EP→EOE→EOT→EOP) + RACI + force analysis + VANA requirements. Load BEFORE designing any system or writing any spec.

## Agent Diagnostics (full spec: `rules/agent-diagnostic.md`)
Trace 6 configurable components before blaming the model. Derisk checklist + symptom-to-component lookup in full spec.

## Filesystem Routing (full spec: `rules/filesystem-routing.md`)

4 modes — load the rule before writing to any project directory:
- **Mode A:** DSBV workstreams (ALIGN, PLAN, EXECUTE, IMPROVE) → subsystem dirs + DSBV phase files
- **Mode B:** Learning pipeline (LEARN only) → pipeline dirs, **NO DSBV files**
- **Mode C:** PKB + vault dirs → `/ingest`, `/vault-capture` write here, NOT to 2-LEARN
- **Mode D:** Genesis (`_genesis/`) → OE-builder artifacts only, never in ALPEI dirs

## DSBV Process (full spec: `_genesis/templates/dsbv-process.md`)
Every DSBV workstream (ALIGN, PLAN, EXECUTE, IMPROVE — **not LEARN**) uses **Design → Sequence → Build → Validate**. Run `/dsbv` for guided flow. No workstream artifact is produced outside DSBV.
- Phase ordering: Design before Build, Validate before workstream complete.
- ALPEI flow constraint: workstream N cannot reach Review until N-1 has ≥1 Approved artifact.
- Human gates: each phase transition requires explicit human approval.
- VANA gate: at Validate phase, verify deliverable against VANA criteria for current UES version. No VANA criteria met = not done. Ref: `_genesis/frameworks/ltc-ues-versioning.md`

## EOP Governance (full spec: `_genesis/reference/ltc-eop-gov.md`)
Before creating or reviewing any skill, load `_genesis/reference/ltc-eop-gov.md`. Run `./scripts/skill-validator.sh <skill-dir>` before committing skill changes. Use `/ltc-skill-creator` for guided skill creation.

## Feedback (full spec: `.claude/skills/ltc-feedback/SKILL.md`)
When a user expresses frustration, confusion, or suggests an improvement, offer: "Want me to capture this as feedback? Takes 30 seconds with /ltc-feedback." Creates a structured GitHub Issue using 7-CS force analysis (EA→EO, UBS, risk scoring, root cause classification).

## Before Every Task — Pre-Flight Protocol

1. **WORKSTREAM** — `/dsbv status` to identify. If ambiguous, ask.
2. **ALIGNMENT** — `_genesis/BLUEPRINT.md` + `1-ALIGN/charter/` for EO, stakeholders, success criteria. Every task traces to an objective.
3. **RISKS** — `3-PLAN/risks/UBS_REGISTER.md`. Human adoption first (S > E > Sc).
4. **DRIVERS** — `3-PLAN/drivers/UDS_REGISTER.md`.
5. **TEMPLATES** — grep `## Routing:` in `_genesis/frameworks/alpei-dsbv-process-map.md`, load before proceeding.
6. **LEARNING** — `2-LEARN/`. Don't reinvent what exists.
7. **VERSION** — metadata consistent with DSBV phase, no cross-workstream regression.
8. **EXECUTE** — Sustainability > Efficiency > Scalability.
9. **DOCUMENT** — decisions in `1-ALIGN/decisions/` for non-trivial choices.

If any check fails: state which check and why → propose minimum fix → wait for human approval.

## Structure (5×4×4 Matrix)

5 workstreams × 4 DSBV stages × 4 sub-systems (PD→DP→DA→IDM)

```
ALIGN workstream (Right Outcome)    → 1-ALIGN/ (charter, decisions, okrs)
LEARN workstream (Problem Research) → 2-LEARN/ (input, research, specs, output — learning pipeline)
PLAN workstream (Minimize Risks)    → 3-PLAN/ (architecture, risks, drivers, roadmap)
EXECUTE workstream (Deliver)        → 4-EXECUTE/ (src, tests, config, docs)
IMPROVE workstream (Learn & Grow)   → 5-IMPROVE/ (changelog, metrics, retros, reviews)
Agent config & rules (operational)  → CLAUDE.md, AGENTS.md, .claude/, _genesis/
```

**Core Equation:** Success = Efficient & Scalable Management of Failure Risks

Every artifact must be categorized: which subsystem x which workstream. No chat-only decisions.

## Modular Rules & Skills
Path-scoped rules: `.claude/rules/` | On-demand skills: `.claude/skills/` | Global: `_genesis/`

## Template Version
If `./scripts/template-check.sh` exists, run `./scripts/template-check.sh --quiet` at session start. If behind, warn user. If missing, skip.

## Links

- [[AGENTS]]
- [[BLUEPRINT]]
- [[CHANGELOG]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UBS_REGISTER]]
- [[UDS_REGISTER]]
- [[VALIDATE]]
- [[agent-diagnostic]]
- [[agent-dispatch]]
- [[agent-system]]
- [[alpei-dsbv-process-map]]
- [[architecture]]
- [[brand-identity]]
- [[charter]]
- [[deliverable]]
- [[dsbv-process]]
- [[filesystem-routing]]
- [[general-system]]
- [[global-claude-md-example]]
- [[ltc-eop-gov]]
- [[ltc-ues-versioning]]
- [[naming-rules]]
- [[project]]
- [[roadmap]]
- [[security]]
- [[security-rules]]
- [[standard]]
- [[task]]
- [[tool-routing]]
- [[workstream]]
