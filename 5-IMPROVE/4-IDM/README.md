---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 5-IMPROVE
sub_system: 4-IDM
---

# 5-IMPROVE / 4-IDM — Insights & Decision Making

> **You are here:** `5-IMPROVE/4-IDM/` — Convert analyzed findings into committed improvement actions. Route each action to the correct subsystem's 1-ALIGN. This closes the ALPEI loop.

## What Goes Here

Improvement artifacts scoped to Insights and Decision Making: `idm-changelog.md` (approved change decisions and version narrative), `idm-metrics.md` (updated metrics baseline — targets reset for the next iteration), and retrospective data on delivery usability and decision quality. Also DSBV process files.

## How to Create Artifacts

```
/dsbv design improve idm      # Step 1: Define criteria for actionable improvement
/dsbv sequence improve idm    # Step 2: Prioritize by S > E > Sc (sustainability first)
/dsbv build improve idm       # Step 3: Produce improvement actions, updated baseline
/dsbv validate improve idm    # Step 4: Verify each action has an owner and target iteration
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`5-IMPROVE/3-DA/da-metrics.md` and cross-workstream metrics from `5-IMPROVE/_cross/` must exist. IDM commits decisions — it cannot commit without the analyzed findings.

## Cascade Position

```
[3-DA analyzed findings]  →  [4-IDM]  →  [1-ALIGN (next iteration)]
                                    ↓
     Each improvement action is routed to the correct subsystem's ALIGN
     IDM routes to ALL subsystems — it sees the full UES
```

This is where the ALPEI loop closes. A committed IDM improvement action feeds directly into the next iteration's 1-ALIGN, ensuring every future iteration starts with evidence rather than assumption.

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Retrospective | `retro-template.md` | `../../_genesis/templates/retro-template.md` |
| Metrics baseline | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |

## Links

- [[CHANGELOG]]
- [[architecture]]
- [[iteration]]
- [[workstream]]
