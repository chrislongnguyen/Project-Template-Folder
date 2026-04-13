---
version: "2.0"
status: draft
last_updated: 2026-04-06
type: template
iteration: 2
---

# principles

> "What standards are we unwilling to compromise on?"

## Purpose

Non-negotiable standards derived from philosophy — the WHAT we commit to.

Without principles, teams are forced to re-derive foundational standards in every project — producing inconsistent interpretations that fragment quality. This directory exists separately from `philosophy/` (belief-level) and `frameworks/` (method-level) to hold the commitments that sit between them: actionable standards that can be violated and must therefore be stated explicitly.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| _(files currently empty — principles are captured inline across Vinh frameworks)_ | Core standards live in `_genesis/frameworks/ltc-10-ultimate-truths.md` and the ALPEI framework documents pending extraction into dedicated principle files |

## How It Connects

```
_genesis/philosophy/ (WHY — beliefs)
    │
    └──> _genesis/principles/ (WHAT — commitments)
              │
              ├──> _genesis/frameworks/ — frameworks must not violate principles
              ├──> _genesis/security/ — security hierarchy is a derived principle
              ├──> CLAUDE.md § Agent Diagnostics — 8 LLM Truths are a principle set
              └──> All workstream Pre-Flight Checklists — principles surface as gate criteria
```

## Pre-Flight Checklist

- [ ] Confirm each principle traces to at least one philosophy statement in `_genesis/philosophy/`
- [ ] Verify principles are stated as commitments ("We will never…", "We always…"), not aspirations
- [ ] No orphaned or stale artifacts

## Naming Convention

Principle files use descriptive kebab-case: `sustainability-over-efficiency.md`, `human-adoption-first.md`.

## Links

- [[CLAUDE]]
- [[iteration]]
- [[ltc-10-ultimate-truths]]
- [[project]]
- [[security]]
- [[workstream]]
