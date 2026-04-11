---
version: "1.1"
status: draft
last_updated: 2026-04-11
---
# codex.md — LTC Project Template

> OpenAI Codex / ChatGPT agent rules. Loaded every session.
> For full governance, see: `AGENTS.md` (cross-agent roster), `rules/` (shared rules).

## Project
- **Name:** LTC Project Template
- **Stack:** Markdown, Shell, Python, JS/TS (React 19 + Vite), Obsidian, YAML
- **Purpose:** Standard project scaffold for LTC Partners — a thinking system with 5-workstream ALPEI structure and AI agent config pre-loaded.
- **EO:** Maintain the generic ALPEI template all LTC projects clone from. Consumer teams add domain subsystems after cloning.

## Build
- Template repo — no build step. Validate structure: `./scripts/template-check.sh --quiet`

## Decision Priority — S > E > Sc (ALWAYS in this order)
1. **Sustainability** — will this hold up over time? reversible? maintainable?
2. **Efficiency** — simplest correct approach after S is satisfied
3. **Scalability** — only optimize for scale after S and E are satisfied

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
1-ALIGN/   — scope, RACI, decisions (charter, OKRs)
2-LEARN/   — research, constraints (6-state pipeline, NOT DSBV)
3-PLAN/    — architecture, risks, drivers, roadmaps
4-EXECUTE/ — src, tests, config, docs
5-IMPROVE/ — changelog, metrics, retros, reviews
_genesis/  — org knowledge, frameworks, templates, brand
rules/     — shared agent rules (all IDEs read these)
```

## Subsystems (PD → DP → DA → IDM)
**PD** (Problem Diagnosis) → **DP** (Data Pipeline) → **DA** (Data Analysis) → **IDM** (Insights & Decision Making)
- PD Effective Principles govern all downstream. Downstream MUST NEVER exceed upstream version.
- Every artifact is categorized by `subsystem × workstream`.

## DSBV Process (full spec: `rules/dsbv-process.md`)
**Design → Sequence → Build → Validate** — applies to ALIGN/PLAN/EXECUTE/IMPROVE (NOT LEARN).
- ALWAYS Design before Build. Human gates REQUIRED at G1–G4.
- NEVER self-set `status: validated` — human ONLY. Agent sets `draft`, `in-progress`, `in-review`.
- Chain of custody: workstream N cannot start Build until N-1 has ≥1 validated artifact.
- Pre-flight: check `/dsbv status` before starting any workstream task.

## Agent Roster (full spec: `rules/agent-system.md`)
| Agent | Model | Scope |
|-------|-------|-------|
| `ltc-explorer` | haiku | Research, discovery, read-only |
| `ltc-planner` | opus | Design + Sequence, synthesis |
| `ltc-builder` | sonnet | Build — artifacts, code, docs |
| `ltc-reviewer` | opus | Validate against DESIGN.md |

Dispatch: ONLY the orchestrator (main session) spawns agents. Sub-agents MUST NEVER spawn sub-agents.

## Filesystem Routing (full spec: `rules/filesystem-routing.md`)
- **Mode A:** `1-ALIGN/`, `3-PLAN/`, `4-EXECUTE/`, `5-IMPROVE/` → DSBV workstreams
- **Mode B:** `2-LEARN/` → pipeline only (NEVER write DESIGN/SEQUENCE/VALIDATE files here)
- **Mode C:** `PERSONAL-KNOWLEDGE-BASE/`, `DAILY-NOTES/`, `inbox/` → PKB/vault
- **Mode D:** `_genesis/` → OE-builder artifacts only (NEVER project artifacts here)

## Modular Rules
Shared rules: `rules/` | Agent roster: `AGENTS.md` | Full governance: `_genesis/`

## Links

- [[AGENTS]]
- [[CHANGELOG]]
- [[DESIGN]]
- [[VALIDATE]]
- [[agent-system]]
- [[architecture]]
- [[brand-identity]]
- [[dsbv-process]]
- [[filesystem-routing]]
- [[naming-rules]]
- [[project]]
- [[security]]
- [[security-rules]]
- [[standard]]
- [[workstream]]
