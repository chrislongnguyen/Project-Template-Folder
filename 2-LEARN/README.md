---
version: "1.0"
last_updated: 2026-03-30
owner: "Long Nguyen"
---
# LEARN workstream (Research Your Problem Domain)

> **This workstream is your problem research workspace.** Everything here is about understanding the specific problem YOUR project solves — not about learning to use this template.
>
> For template training materials, onboarding guides, and framework references → see `_genesis/training/` and `_genesis/reference/`.

## What Goes Here

| Folder | Purpose | Produced By |
|--------|---------|-------------|
| `input/` | Raw stakeholder input, interview notes, transcripts | Human (manual) or `/learn-input` |
| `input/raw/` | Unprocessed transcripts, photos, recordings | Human (manual) |
| `research/` | Synthesis docs, analysis, design specs | `/learn-research` or manual |
| `specs/` | Formal VANA specifications | `/learn-spec` |
| `output/` | Structured learning pages (7-page model) | `/learn-structure` |
| `templates/` | Output templates for learning artifacts | Template (don't modify) |
| `references/` | Research prompts, citation templates | Template (don't modify) |
| `config/` | Skill configuration (constraints, thresholds) | Template (don't modify) |
| `scripts/` | Validation scripts for learning outputs | Template (don't modify) |
| `archive/` | Completed or superseded research | Automatic during cleanup |

## How to Use

1. **Start:** `/learn` — the orchestrator guides you through all 6 steps
2. **Quick research:** `/learn-research` — run just the research step
3. **Formalize:** `/learn-spec` — convert notes to a VANA specification

All `/learn-*` skill outputs land in this workstream automatically.

## LEARN in ALPEI Flow

```
ALIGN → LEARN → PLAN → EXECUTE → IMPROVE
         ↑  ↓
         ↑  ├→ feeds BACK to ALIGN (refined understanding)
         ↑  └→ feeds FORWARD to PLAN (research inputs for strategy)
         ↑
         Human + Agent work together here
```

LEARN is the centerpiece of ALPEI. It sits between ALIGN and PLAN because you must understand the problem before you can plan the solution.

## What Does NOT Go Here

- Template training materials → `_genesis/training/`
- Framework references (10 UTs, ESD, ALPEI overview) → `_genesis/philosophy/`, `_genesis/frameworks/`, `_genesis/reference/`
- Architecture Decision Records → `1-ALIGN/decisions/`
- Risk/driver registers → `3-PLAN/risks/`, `3-PLAN/drivers/`

## Links

- [[DESIGN]]
- [[SKILL]]
- [[project]]
- [[workstream]]
