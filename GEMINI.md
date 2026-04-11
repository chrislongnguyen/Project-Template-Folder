---
version: "1.1"
status: draft
last_updated: 2026-04-11
---
# GEMINI.md — LTC Project Template

> Gemini CLI agent rules. Loaded every session. Keep under 100 lines; details go to `rules/`.
> Cross-agent roster: `AGENTS.md` | Shared rules: `rules/`

## Project
- **Name:** LTC Project Template | **Stack:** Markdown, Shell, Python, JS/TS (React 19 + Vite), Obsidian, YAML
- **Purpose:** Standard project scaffold for LTC Partners — a thinking system with 5-workstream ALPEI structure and AI agent config pre-loaded.
- **EO:** Maintain the generic ALPEI template all LTC projects clone from. Consumer teams add domain subsystems after cloning.

## Build
- Template repo — no build step. Validate structure: `./scripts/template-check.sh --quiet`

## Decision Priority — S > E > Sc (ALWAYS in this order)
1. **Sustainability** — will this hold up over time? reversible? maintainable?
2. **Efficiency** — simplest correct approach after S is satisfied
3. **Scalability** — only optimize for scale after S and E are satisfied

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
- NEVER hardcode secrets in source code, prompts, or tool arguments — use `.env`/`secrets/` via env vars
- Scan output for secret patterns before completing any task. If found — stop, redact, alert user
- LOW (read, search, lint, test): proceed | MEDIUM (edit, commit, install): proceed, user reviews
- HIGH (delete, push, force ops, deploy, touch .env/secrets/): ALWAYS require explicit user confirmation

## Agent System (full spec: `rules/agent-system.md`)
Your AI agent has 8 structural limits (LLM Truths). The 7-Component System compensates. Three principles: derisk before output, know the agent's physics, human + agent = complementary.

## System Design (full spec: `rules/general-system.md`)
Every system has 6 components: Input, User, Action, Principles, Tools, Environment → Outcome. Establish RACI first, then analyze forces. Design: Problem Discovery → System Design → VANA Requirements.

## Agent Diagnostics (full spec: `rules/agent-diagnostic.md`)
When agent output is wrong: trace through 6 configurable components (EP → Input → EOP → Environment → Tools → Agent) before blaming the model.

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
- ALWAYS Design before Build. Human gates REQUIRED at G1–G4 (approve DESIGN, SEQUENCE, deliverables, VALIDATE).
- NEVER self-set `status: validated` — human ONLY. Agent sets `draft`, `in-progress`, `in-review`.
- Chain of custody: workstream N cannot start Build until N-1 has ≥1 validated artifact.
- Pre-flight: run `/dsbv status` before starting any workstream task.

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

## Modular Rules & Skills
Shared rules: `rules/` | Agent roster: `AGENTS.md` | Full governance: `_genesis/`

## Template Version
If `./scripts/template-check.sh` exists, run it with `--quiet` at session start. If behind, warn user. If missing, skip silently.

## Links

- [[AGENTS]]
- [[CHANGELOG]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[agent-diagnostic]]
- [[agent-system]]
- [[architecture]]
- [[brand-identity]]
- [[deliverable]]
- [[dsbv-process]]
- [[filesystem-routing]]
- [[general-system]]
- [[iteration]]
- [[naming-rules]]
- [[project]]
- [[security]]
- [[security-rules]]
- [[standard]]
- [[task]]
- [[workstream]]
