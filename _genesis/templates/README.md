---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# templates

> "Is there a template for this, or are we inventing from scratch?"

## Purpose

DSBV stage templates, VANA-SPEC, ADR, research, review, and 15+ artifact starters.

Creating artifacts without templates produces inconsistent structure that breaks Obsidian Bases queries, agent parsing, and review automation. This directory exists separately from `frameworks/` because templates are fill-in starters (HOW to produce an artifact) while frameworks are thinking models (HOW to reason about a problem). Always check here before creating a blank artifact.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `design-template.md` | DSBV Design stage — spec structure for any workstream |
| `dsbv-process.md` | DSBV process template — Sequence stage scaffolding |
| `review-template.md` | DSBV Validate stage — review package template |
| `vana-spec-template.md` | VANA acceptance criteria spec (Verb Adverb Noun Adjective) |
| `adr-template.md` | Architecture Decision Record |
| `charter-template.md` | 1-ALIGN charter template |
| `architecture-template.md` | System architecture document template |
| `research-template.md` | 2-LEARN research output template |
| `research-methodology.md` | Research methodology reference |
| `risk-entry-template.md` | UBS risk register entry |
| `driver-entry-template.md` | UDS driver register entry |
| `force-analysis-template.md` | Force analysis template (UBS + UDS combined) |
| `okr-template.md` | OKR template for 1-ALIGN |
| `roadmap-template.md` | 3-PLAN roadmap template |
| `retro-template.md` | 5-IMPROVE retrospective template |
| `metrics-baseline-template.md` | 5-IMPROVE metrics baseline |
| `standup-template.md` | Team standup note template |
| `spike-template.md` | Technical spike/exploration template |
| `test-plan-template.md` | 4-EXECUTE test plan template |
| `sop-template.md` | SOP authoring template |
| `wiki-page-template.md` | System wiki page template |
| `feedback-template.md` | User feedback capture template |
| `dsbv-context-template.md` | Context packaging template for agent dispatch |
| `dsbv-eval-template.md` | DSBV evaluation/gate criteria template |
| `readme-blueprint.md` | Type A/B/C/D README authoring guide (this doc's own template) |
| `global-claude-md-example.md` | Example CLAUDE.md for new projects |
| `MEMORY-seed.md` | Starter MEMORY.md for new project memory |
| `memory-seeds/` | Per-topic seed files for project memory initialization |
| `ltc-bases-theme-startup.md` | Obsidian Bases theme startup template |

## How It Connects

```
_genesis/frameworks/ (thinking models)
    │
    └──> _genesis/templates/ (artifact starters derived from frameworks)
              │
              ├──> All 5 workstreams — every DSBV artifact starts from a template here
              ├──> CLAUDE.md § ALPEI Template Usage — always-on rule enforces template-first
              ├──> .claude/rules/alpei-template-usage.md — agents check here before creating
              └──> scripts/template-check.sh — validates template presence and structure
```

## Pre-Flight Checklist

- [ ] Before creating any workstream artifact, grep `_genesis/templates/` for an applicable template
- [ ] Verify templates have correct frontmatter placeholders matching `_genesis/reference/frontmatter-schema.md`
- [ ] No orphaned or stale artifacts

## Naming Convention

Templates use descriptive kebab-case ending in `-template.md`. The README blueprint is `readme-blueprint.md`. Agent context templates use `dsbv-{type}-template.md`.

## Links

- [[AGENTS]]
- [[alpei-blueprint]]
- [[CLAUDE]]
- [[DESIGN]]
- [[MEMORY-seed]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[adr]]
- [[adr-template]]
- [[alpei-template-usage]]
- [[architecture]]
- [[architecture-template]]
- [[charter]]
- [[charter-template]]
- [[design-template]]
- [[driver-entry-template]]
- [[dsbv-context-template]]
- [[dsbv-eval-template]]
- [[dsbv-process]]
- [[feedback-template]]
- [[force-analysis-template]]
- [[frontmatter-schema]]
- [[global-claude-md-example]]
- [[iteration]]
- [[ltc-bases-theme-startup]]
- [[methodology]]
- [[metrics-baseline-template]]
- [[okr]]
- [[okr-template]]
- [[project]]
- [[readme-blueprint]]
- [[research-methodology]]
- [[research-template]]
- [[retro-template]]
- [[review-template]]
- [[risk-entry-template]]
- [[roadmap]]
- [[roadmap-template]]
- [[sop-template]]
- [[spike-template]]
- [[standup-template]]
- [[test-plan-template]]
- [[vana-spec-template]]
- [[wiki-page-template]]
- [[workstream]]
