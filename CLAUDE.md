---
version: "1.6"
status: draft
last_updated: 2026-04-12
---
# CLAUDE.md — LTC Project Template

> Loaded every session. ≤120 lines. Details: `.claude/rules/` (auto-loaded) | `rules/` (on-demand).
> Global `~/.claude/CLAUDE.md` handles identity, communication, model routing.

<!-- ── CUSTOMIZE AFTER CLONING (replace placeholders) ──────────────── -->
## Project
- **Name:** LTC Project Template
- **Stack:** Markdown, Shell, Python, JS/TS (React 19 + Vite), Obsidian (Bases, Templater, Dataview), YAML
- **Purpose:** Enable LTC Project Managers to Effectively (Sustainable x Efficient x Scalable) build and operate AI-powered Operating Systems that construct domain sub-systems (currently: PD→DP→DA→IDM) to aid their work. Captures decisions, risks, and "why" in 5-workstream ALPEI structure.
- **EO:** Maintain the generic ALPEI template all LTC projects clone from. Consumer teams add domain subsystems after cloning.
## Build and Validate
- Template repo — no build step. Validate: `./scripts/template-check.sh`
- 53 scripts in `scripts/` (28 skills in `.claude/skills/`, 12 rules in `.claude/rules/`). Script index: `.claude/rules/script-registry.md`

<!-- ── LTC STANDARD (do not modify below this line) ────────────────── -->
## Rules
- ALWAYS follow existing patterns before inventing new ones
- ALWAYS write tests for new functionality
- ALWAYS commit atomic changes with user-facing concise, descriptive messages
- PREFER editing existing files over creating new ones
- ALWAYS document the "why" in artifacts, not just the "what"
## Knowledge Graph
All workflow .md files have `## Links` with [[wikilinks]] forming a traversable graph (~400 nodes). Follow links forward for dependencies; use `/obsidian` backlinks for "what depends on this?". Reasoning pattern: read file → follow 2-3 relevant links → synthesize.
Search: QMD `mcp__qmd__query` (semantic vec + keyword lex over vault/PKB) | Grep (exact match in repo) | `/obsidian` (graph: backlinks, orphans, outgoing-links via Local REST API). Ref: `rules/tool-routing.md`
## Architecture: 5x4x4 Matrix
5 workstreams x 4 DSBV stages x 4 sub-systems (PD->DP->DA->IDM)
```
ALIGN (Right Outcome)    → 1-ALIGN/ (charter, decisions, okrs)
LEARN (Problem Research) → 2-LEARN/ (6-state pipeline S1-S5+Complete, NOT DSBV)
PLAN  (Minimize Risks)   → 3-PLAN/ (architecture, risks, drivers, roadmap)
EXECUTE (Deliver)        → 4-EXECUTE/ (src, tests, config, docs)
IMPROVE (Learn & Grow)   → 5-IMPROVE/ (changelog, metrics, retros, reviews)
```
**Core Equation:** Success = Efficient & Scalable Management of Failure Risks
Every artifact MUST be categorized by subsystem x workstream. NEVER make chat-only decisions.
## Architecture: Subsystems (full spec: `_genesis/alpei-blueprint.md` Part 4)
**PD** (Problem Diagnosis) -> **DP** (Data Pipeline) -> **DA** (Data Analysis) -> **IDM** (Insights & Decision Making).
PD output: Effective Principles for entire UES. DP: processed data. DA: extracted insights. IDM: actionable decisions.
PD governs all: PD's EP ALWAYS takes precedence over downstream. Downstream MUST NEVER exceed upstream UES version.
## Architecture: PKB (full spec: `PERSONAL-KNOWLEDGE-BASE/README.md`)
Capture (raw, immutable) -> Distill (AI-maintained wiki) -> Express (outputs). Route: `PERSONAL-KNOWLEDGE-BASE/`, `DAILY-NOTES/`, `inbox/` only. NEVER `2-LEARN/`.
QMD provides vec (semantic) and lex (keyword) search over vault + PKB. Use `mcp__qmd__query` for recall, `mcp__qmd__get` for retrieval.
## Effective Principles (full spec: `_genesis/reference/ltc-effective-agent-principles-registry.md`)
14 EPs (EP-01 through EP-14): 11 DERISK, 3 OUTPUT. Reflects UT#5: managing failure risk > maximising output. ALWAYS load registry when designing or reviewing any system component.
## Brand Identity (full spec: `rules/brand-identity.md`)
**MANDATORY for ALL visual output.** Load full spec BEFORE generating any visual artifact.
**NEVER** use generic colors/fonts. Every visual artifact MUST use LTC colors (Midnight Green #004851, Gold #F2C75C) and Inter font.
## Naming (full spec: `rules/naming-rules.md`)
UNG: `{SCOPE}_{FA}.{ID}.{NAME}`. ALWAYS load `rules/naming-rules.md` BEFORE creating any named item.
## Security (full spec: `rules/security-rules.md`)
- **Secrets:** NEVER hardcode in source/prompts/tool args. MUST use `.env`/`secrets/` via env vars. ALWAYS scan output before completing any task.
- **LOW** (read, search, lint, test): proceed. **MEDIUM** (edit, commit, install): proceed, user reviews.
- **HIGH** (delete, push, force ops, deploy, .env/secrets/): ALWAYS require explicit confirmation.
## Agent System (full spec: `rules/agent-system.md`)
8 LLM Truths + 7-CS. Roster: explorer=haiku | planner=opus | builder=sonnet | reviewer=opus. Dispatch: `agent-dispatch.md`. Files: `.claude/agents/`.
EP-13: ONLY orchestrator (main session) calls `Agent()` — sub-agents MUST NEVER call `Agent()`. Dispatch vs. Team mode are distinct patterns.
## Filesystem Routing (full spec: `rules/filesystem-routing.md`)
**A:** DSBV workstreams (ALIGN/PLAN/EXECUTE/IMPROVE) -> subsystem dirs + DSBV files. **B:** LEARN -> pipeline dirs, NEVER DSBV files.
**C:** PKB + vault dirs (`/ingest`, `/vault-capture` write here, NEVER 2-LEARN). **D:** `_genesis/` -> OE-builder ONLY, NEVER ALPEI dirs.
## DSBV Process (full spec: `_genesis/templates/dsbv-process.md`)
**Design -> Sequence -> Build -> Validate** for ALIGN/PLAN/EXECUTE/IMPROVE (not LEARN). Run `/dsbv`.
- ALWAYS Design before Build. Human gates REQUIRED at each transition. Workstream N MUST have N-1 >=1 Approved artifact.
- VANA gate at Validate: verify against UES version criteria. Ref: `_genesis/frameworks/ltc-ues-versioning.md`
- Status: `draft -> in-progress -> in-review -> validated -> archived`. Agent sets draft/in-progress/in-review. **Human ONLY sets validated.** Ref: `.claude/rules/versioning.md`
## Enforcement and Scripts (full spec: `.claude/rules/enforcement-layers.md`)
Tier (strongest first): **hooks > scripts > rules > skills**. Config: `.claude/settings.json`.
7 hook types: `SessionStart` (3), `PreToolUse` (13), `PostToolUse` (6), `SubagentStop` (2), `PreCompact` (1), `Stop` (3), `UserPromptSubmit` (1) — 29 total hooks covering naming, DSBV gates, status-guard, routing, frontmatter inject, state-save, ripple-check, changelog, recall.
## Pre-Flight Protocol (automated: `scripts/pre-flight.sh`)
9 checks before every task: (1) WORKSTREAM `/dsbv status` (2) ALIGNMENT `BLUEPRINT.md`+`1-ALIGN/1-PD/` (3) RISKS `UBS_REGISTER.md` S>E>Sc (4) DRIVERS `UDS_REGISTER.md` (5) TEMPLATES from `alpei-dsbv-process-map.md` (6) LEARNING `2-LEARN/` (7) VERSION metadata (8) EXECUTE S>E>Sc (9) DOCUMENT decisions in `1-ALIGN/_cross/`.
If any check fails: MUST state which and why -> propose minimum fix -> ALWAYS wait for human approval.
## Rules Architecture
`.claude/rules/` = auto-loaded summaries (12 files, always in context). `rules/` = full specs loaded on-demand. Dual-directory pattern: lean context, full specs accessible.
## Self-Update Rule
Trigger: MUST update when new rule/skill/script added OR >2 days drift. MUST NOT exceed 120 lines. Method: `git log --since="2 days" .claude/ scripts/ rules/`.

## Links

- [[AGENTS]]
- [[alpei-blueprint]]
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
- [[enforcement-layers]]
- [[filesystem-routing]]
- [[general-system]]
- [[global-claude-md-example]]
- [[ltc-effective-agent-principles-registry]]
- [[ltc-ues-versioning]]
- [[naming-rules]]
- [[project]]
- [[roadmap]]
- [[security]]
- [[security-rules]]
- [[standard]]
- [[task]]
- [[tool-routing]]
- [[versioning]]
- [[workstream]]
