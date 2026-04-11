---
version: "1.2"
status: draft
last_updated: 2026-04-11
work_stream: 5-IMPROVE
sub_system: _root
---

# 5-IMPROVE — Learn, Reflect, Institutionalize

> **You are here:** `5-IMPROVE/` — Collect evidence from what was delivered, prioritize what to fix, and route improvements back to ALIGN.

## What Goes Here

Improvement artifacts: changelogs (version history), metrics (health measurements against baselines), retrospective reports (structured postmortems), and feedback registers. These feed back into the next iteration's 1-ALIGN, closing the ALPEI loop.

## How to Create Artifacts

This directory is empty by design. Run DSBV (Design, Sequence, Build, Validate) to generate content:

```
/dsbv design improve pd      # Step 1: Define what feedback to collect
/dsbv sequence improve pd    # Step 2: Design analysis methodology
/dsbv build improve pd       # Step 3: Process feedback and produce reports
/dsbv validate improve pd    # Step 4: Review improvement decisions
```

Repeat for each subsystem: `pd` → `dp` → `da` → `idm`. IDM-IMPROVE is last — it routes improvements to each subsystem's 1-ALIGN for the next iteration.

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

4-EXECUTE must have at least one validated deliverable before IMPROVE begins. Deployed artifacts and their VALIDATE results are the primary inputs.

## Subsystem Sequence

```
1-PD  →  2-DP  →  3-DA  →  4-IDM  →  1-ALIGN (next iteration)
```

| Directory | Subsystem | What it produces |
|-----------|-----------|-----------------|
| `1-PD/` | Problem Diagnosis | Improvement baseline and criteria for the full cycle |
| `2-DP/` | Data Pipeline | Pipeline health metrics, changelog, retrospective |
| `3-DA/` | Data Analysis | Trend analysis, root cause findings |
| `4-IDM/` | Insights & Decision Making | Committed improvement actions routed to each subsystem's ALIGN |
| `_cross/` | Cross-cutting | Aggregated metrics baseline, cross-subsystem feedback register |

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Retrospective | `retro-template.md` | `../_genesis/templates/retro-template.md` |
| Metrics baseline | `metrics-baseline-template.md` | `../_genesis/templates/metrics-baseline-template.md` |
| Feedback | `feedback-template.md` | `../_genesis/templates/feedback-template.md` |
| Design spec | `design-template.md` | `../_genesis/templates/design-template.md` |
| Review | `review-template.md` | `../_genesis/templates/review-template.md` |

## Links

- [[CHANGELOG]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[dsbv-process]]
- [[iteration]]
- [[workstream]]
