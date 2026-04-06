---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# projects

> "What is the current state of each active project?"

## Purpose

Project-level notes and dashboards within the Obsidian vault.

Project notes without a home become scattered across `daily/` and `inbox/` — making it impossible to get a coherent view of project state from the vault. This folder provides one note per project as the Obsidian-side anchor, linking to the git repo workstream folders via `[[wikilinks]]`. It does not duplicate workstream artifacts — it provides navigation and dashboards only.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| Project anchor notes | One note per active project — status, links to workstream folders, open questions |
| Obsidian Bases dashboards | `.base` files for querying project artifact status across the vault |

## How It Connects

```
Git repo workstream folders (1-ALIGN/ through 5-IMPROVE/)
    │
    └──> vault/projects/ (Obsidian-side navigation layer)
              │
              ├──> vault/daily/ — daily notes link back to relevant project notes
              ├──> vault/research/ — research notes linked to project context
              └──> vault/agents/ — agent outputs promoted to project notes after triage
```

## Pre-Flight Checklist

- [ ] Confirm each active project has exactly one anchor note in `projects/`
- [ ] Verify Bases dashboards query against correct frontmatter fields (case-sensitive)
- [ ] No orphaned or stale artifacts
