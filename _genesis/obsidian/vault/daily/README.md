---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# daily

> "What did we learn or decide today?"

## Purpose

Daily notes — learning log, reflections, and captured observations.

Daily notes that are never reviewed or linked rot into noise — creating the illusion of a learning system without the substance. This folder exists separately from `inbox/` to hold time-stamped reflections with intentional structure, not unprocessed captures. Files here follow a naming convention that enables Obsidian date queries.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| Daily note files | One file per day, named `YYYY-MM-DD.md`, containing reflections, decisions, and learning observations |

## How It Connects

```
vault/inbox/ (raw captures during the day)
    │
    └──> vault/daily/ (end-of-day structured reflection)
              │
              └──> vault/research/ — insights promoted to research notes
                   2-LEARN/ — learning observations feed the LEARN workstream
                   5-IMPROVE/ — retros draw from accumulated daily notes
```

## Pre-Flight Checklist

- [ ] Use `YYYY-MM-DD.md` naming — enables Obsidian date filters and Bases queries
- [ ] Link daily notes to relevant `vault/projects/` entries when decisions are made
- [ ] No orphaned or stale artifacts
