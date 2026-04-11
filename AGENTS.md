---
version: "1.2"
status: draft
last_updated: 2026-04-11
work_stream: 0-GOVERN
type: agent-config
iteration: 1
---
# AGENTS.md — LTC Project Template

> Cross-agent coordination manifest. Read by all AI agents (Claude Code, Gemini CLI, Cursor, Codex) at session start.
> Agent-specific configs: `.claude/` (Claude Code), `.cursor/` (Cursor), `.agents/` (AntiGravity), `GEMINI.md` (Gemini CLI), `codex.md` (Codex).

## Agent Roster

This project uses a 4-agent MECE architecture. All agents serve the DSBV (Design, Sequence, Build, Validate) lifecycle within the ALPEI workstream framework.

| Agent | Role | Stage | Model Tier | Config |
|-------|------|-------|------------|--------|
| **ltc-planner** | Orchestrator — designs what to build, sequences work, synthesizes outputs | Design + Sequence | High reasoning (opus) | `.claude/agents/ltc-planner.md` |
| **ltc-builder** | Producer — writes code, creates documents, produces artifacts | Build | Fast execution (sonnet) | `.claude/agents/ltc-builder.md` |
| **ltc-reviewer** | Validator — reviews artifacts against DESIGN.md acceptance criteria | Validate | High reasoning (opus) | `.claude/agents/ltc-reviewer.md` |
| **ltc-explorer** | Researcher — pre-DSBV discovery, codebase exploration, root-cause tracing | Pre-DSBV | Fast/cheap (haiku) | `.claude/agents/ltc-explorer.md` |

> **Source of truth:** `.claude/rules/agent-dispatch.md` — Claude Code enforcement rules for agent invocation. Update there first; this file is the cross-IDE summary.

## Nesting Rules

- **ltc-planner** may dispatch ltc-builder, ltc-reviewer, and ltc-explorer
- **ltc-builder, ltc-reviewer, ltc-explorer** are leaf nodes — they MUST NOT call other agents
- Maximum nesting depth: 2 (orchestrator + 1 sub-agent)

## Context Packaging

Every agent invocation must use the 5-field context package:

1. **EO** — Effective Outcome: what the agent must achieve
2. **INPUT** — Files, data, and context the agent needs
3. **EP** — Effective Principles: rules and constraints that govern the work
4. **OUTPUT** — Expected deliverable format and location
5. **VERIFY** — How to confirm the output is correct

Full template: `.claude/skills/dsbv/references/context-packaging.md`

## Project Framework

### ALPEI Workstreams (5 concurrent)

| # | Workstream | Purpose | Directory |
|---|-----------|---------|-----------|
| 1 | ALIGN | Choose the right outcome — scope, RACI, stakeholders | `1-ALIGN/` |
| 2 | LEARN | Understand constraints — UBS, UDS, effective principles | `2-LEARN/` |
| 3 | PLAN | Minimize risks — architecture, risk registers, roadmaps | `3-PLAN/` |
| 4 | EXECUTE | Deliver — source code, tests, configs, docs | `4-EXECUTE/` |
| 5 | IMPROVE | Learn & grow — metrics, changelogs, retros, feedback | `5-IMPROVE/` |

### DSBV Stages (4 per workstream, except LEARN)

Design → Sequence → Build → Validate. Each stage has a human gate.
**LEARN** uses a pipeline (input → research → specs → output → archive), NOT DSBV.

### Subsystems (4 per workstream)

1-PD (Problem Diagnosis) → 2-DP (Data Pipeline) → 3-DA (Data Analysis) → 4-IDM (Insights & Decision Making)

## Shared Rules (all agents)

| Rule | Location | Purpose |
|------|----------|---------|
| Brand identity | `rules/brand-identity.md` | LTC visual standards — colors, fonts, logos |
| Agent system | `rules/agent-system.md` | 8 LLM Truths + 7-Component System |
| System design | `rules/general-system.md` | Universal system model + RACI + force analysis |
| Agent diagnostics | `rules/agent-diagnostic.md` | 6-component trace for agent failures |
| Security | `rules/security-rules.md` | Secrets, risk tiers, blast radius |
| Naming | `rules/naming-rules.md` | UNG grammar for all named items |
| Filesystem routing | `rules/filesystem-routing.md` | 4-mode routing for artifact placement |
| Tool routing | `rules/tool-routing.md` | Which tools for which tasks |

## IDE-Specific Configuration

| IDE | Config Location | Rules | Skills |
|-----|----------------|-------|--------|
| Claude Code | `.claude/` | `.claude/rules/` (12 files) | `.claude/skills/` (see `.claude/skills/` for full list) |
| Cursor | `.cursor/` | `.cursor/rules/` (6 files) | — |
| AntiGravity | `.agents/` | `.agents/rules/` (6 files) | `.agents/skills/` |
| Gemini CLI | `GEMINI.md` | Inline | — |
| Codex | `codex.md` | Inline | — |

## Key References

- Project blueprint: `_genesis/alpei-blueprint.md`
- Version registry: `_genesis/version-registry.md`
- Process map: `_genesis/frameworks/alpei-dsbv-process-map.md`
- Templates: `_genesis/templates/`

## Links

- [[alpei-blueprint]]
- [[CLAUDE]]
- [[DESIGN]]
- [[GEMINI]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[agent-diagnostic]]
- [[agent-dispatch]]
- [[agent-system]]
- [[alpei-dsbv-process-map]]
- [[architecture]]
- [[brand-identity]]
- [[codex]]
- [[context-packaging]]
- [[deliverable]]
- [[filesystem-routing]]
- [[general-system]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[naming-rules]]
- [[project]]
- [[security]]
- [[security-rules]]
- [[tool-routing]]
- [[version-registry]]
- [[workstream]]
