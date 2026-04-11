---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 5-IMPROVE
sub_system: 1-PD
---

# 5-IMPROVE / 1-PD — Problem Diagnosis

> **You are here:** `5-IMPROVE/1-PD/` — Assess diagnosis accuracy and establish the improvement baseline. The metrics baseline here sets criteria for DP, DA, and IDM improvement work.

## What Goes Here

Improvement artifacts scoped to Problem Diagnosis: `pd-changelog.md` (version history and change narrative), `pd-metrics.md` (baseline measurements and improvement targets), and retrospective data. Also DSBV process files (DESIGN.md, SEQUENCE.md, VALIDATE.md).

## How to Create Artifacts

```
/dsbv design improve pd      # Step 1: Define what feedback to collect for PD
/dsbv sequence improve pd    # Step 2: Design feedback analysis methodology
/dsbv build improve pd       # Step 3: Produce changelog, metrics, retro report
/dsbv validate improve pd    # Step 4: Verify process was rigorous, no cherry-picking
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`4-EXECUTE/1-PD/` must have at least one validated deliverable. Deployed PD artifacts and their VALIDATE results are the primary inputs.

## Cascade Position

```
[4-EXECUTE/1-PD validated outputs]  →  [1-PD]  →  [2-DP]
                                              ↓
          pd-metrics.md sets the baseline that DP, DA, IDM improvement measures against
```

Assess accuracy of the problem diagnosis itself: were the Effective Principles correct? Did design guidelines passed to downstream subsystems hold up in execution?

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Retrospective | `retro-template.md` | `../../_genesis/templates/retro-template.md` |
| Metrics baseline | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |

## Links

- [[CHANGELOG]]
- [[DESIGN]]
- [[VALIDATE]]
- [[iteration]]
- [[workstream]]
