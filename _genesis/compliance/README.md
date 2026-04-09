---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# compliance

> "Are we meeting our regulatory and policy obligations?"

## Purpose

Compliance requirements and audit artifacts.

This directory is reserved for org-level regulatory and policy obligations that apply to all projects. It exists separately from `governance/` because compliance is externally imposed (regulations, audit standards), while governance is internally designed (decision rights, authority structures). This directory is an **Iteration 2 placeholder** — content will be populated in iteration 2 as compliance requirements are identified and ratified.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| _(Iteration 2 placeholder)_ | No artifacts yet — to be populated in iteration 2 |

## How It Connects

```
External regulations / LTC policy decisions
    │
    └──> _genesis/compliance/ (ratified compliance requirements)
              │
              ├──> 1-ALIGN/ — compliance constraints inform project charter scope
              ├──> 3-PLAN/ — compliance risks tracked in UBS register
              └──> 4-EXECUTE/ — implementation must satisfy compliance gates
```

## Pre-Flight Checklist

- [ ] Confirm applicable regulatory frameworks have been identified before adding artifacts here
- [ ] Ensure each compliance artifact cites its regulatory source
- [ ] No orphaned or stale artifacts

## Naming Convention

Compliance artifacts use: `{regulation-code}-{topic}.md`. Example: `gdpr-data-retention.md`.

## Links

- [[charter]]
- [[iteration]]
- [[project]]
