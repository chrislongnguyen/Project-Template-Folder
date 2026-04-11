---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 4-EXECUTE
sub_system: 4-IDM
---

# 4-EXECUTE / 4-IDM — Insights & Decision Making

> **You are here:** `4-EXECUTE/4-IDM/` — Package DA results into user-facing outputs: dashboards, reports, APIs, decision tools. The delivery surface of the EXECUTE workstream.

## What Goes Here

Execution artifacts scoped to Insights and Decision Making: `src/` (delivery layer — dashboards, report generators, API endpoints), `tests/` (acceptance tests verifying output correctness and user-facing behavior), `config/` (presentation config, routing, access controls), `docs/` (user guide, interpretation notes, known limitations). Also DSBV process files.

## How to Create Artifacts

```
/dsbv design execute idm      # Step 1: Design delivery layer against PD acceptance criteria
/dsbv sequence execute idm    # Step 2: Sequence delivery (manual review before automation)
/dsbv build execute idm       # Step 3: Produce dashboards, reports, user docs
/dsbv validate execute idm    # Step 4: All acceptance criteria met, handoff to 5-IMPROVE
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`4-EXECUTE/3-DA/` must have validated result sets before IDM build begins. IDM consumes DA outputs only — no direct data access from IDM.

## Cascade Position

```
[3-DA validated result sets]  →  [4-IDM]  →  [5-IMPROVE]
                                        ↓
     Deployed artifacts are what 5-IMPROVE evaluates against metrics
```

Every acceptance criterion from `4-EXECUTE/1-PD/DESIGN.md` must have a corresponding test in `tests/`.

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |
| Test plan | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |
| Review | `review-template.md` | `../../_genesis/templates/review-template.md` |

## Links

- [[DESIGN]]
- [[documentation]]
- [[workstream]]
