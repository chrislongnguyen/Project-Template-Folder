---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# inbox

> "Has everything in the inbox been triaged to its proper location?"

## Purpose

Unsorted captures — quick notes, links, and ideas awaiting triage.

An inbox that is never emptied becomes a second storage system — defeating the purpose of having a structured vault. This folder enforces a single boundary: captures land here first, then get triaged to their permanent location. Nothing in `inbox/` is considered actionable or findable until promoted.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| Quick captures | Fleeting notes, URLs, ideas, and observations created during the day |
| Pending triage | Any item not yet sorted into `daily/`, `research/`, `projects/`, or a workstream folder |

## How It Connects

```
Any source (browser, meeting, conversation, agent output)
    │
    └──> vault/inbox/ (everything lands here first)
              │
              ├──> vault/daily/ — reflections and observations
              ├──> vault/research/ — external knowledge worth retaining
              ├──> vault/projects/ — project-specific notes
              └──> vault/agents/ — if the capture is agent-generated
```

## Pre-Flight Checklist

- [ ] Triage `inbox/` at end of each session — target zero items older than 24 hours
- [ ] Do not search `inbox/` for reference — items here have not been verified or structured
- [ ] No orphaned or stale artifacts
