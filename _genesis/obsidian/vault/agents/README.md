---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# agents

> "What has the AI agent produced that needs human review?"

## Purpose

Agent-generated notes and artifacts surfaced in the Obsidian vault.

Without a dedicated landing zone, agent outputs mix with human-authored notes — making it impossible to distinguish what has been reviewed from what is still AI-generated draft. This folder enforces the boundary: nothing leaves `agents/` until a human has triaged and promoted it to its proper workstream location.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| Agent research notes | Outputs from `ltc-explorer` runs awaiting human review |
| Draft artifacts | Agent-produced drafts pending promotion to workstream folders |

## How It Connects

```
AI agents (ltc-explorer, ltc-builder, ltc-planner)
    │
    └──> vault/agents/ (staging zone — unreviewed agent output)
              │
              └──> Human triage → promoted to vault/projects/, vault/research/,
                   or workstream folders (1-ALIGN/ through 5-IMPROVE/)
```

## Pre-Flight Checklist

- [ ] Review all files in `agents/` before each session — do not let drafts accumulate without triage
- [ ] Confirm promoted artifacts have been moved (not copied) — remove from `agents/` after promotion
- [ ] No orphaned or stale artifacts
