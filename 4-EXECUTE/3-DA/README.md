---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 4-EXECUTE
sub_system: 3-DA
---

# 4-EXECUTE / 3-DA — Data Analysis

> **You are here:** `4-EXECUTE/3-DA/` — Run analytical logic against pipeline outputs. All analysis must be reproducible, tested, and traceable to DP inputs.

## What Goes Here

Execution artifacts scoped to Data Analysis: `src/` (analytical modules — models, metrics, aggregations), `notebooks/` (reproducible analyses), `tests/` (result validation — expected output ranges, regression checks), `config/` (model parameters, threshold definitions), `docs/` (methodology docs, metric definitions). Also DSBV process files.

## How to Create Artifacts

```
/dsbv design execute da      # Step 1: Technical design for analytical components
/dsbv sequence execute da    # Step 2: Sequence analysis build (accuracy before scale)
/dsbv build execute da       # Step 3: Produce source code, notebooks, tests
/dsbv validate execute da    # Step 4: All results validated before handoff to IDM
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`4-EXECUTE/2-DP/` must have passing contract tests before DA build begins. All analytical inputs must originate from `4-EXECUTE/2-DP/src/` or `4-EXECUTE/2-DP/config/` — no direct data access from DA.

## Cascade Position

```
[2-DP validated pipeline outputs]  →  [3-DA]  →  [4-IDM]
                                            ↑
              Every metric in src/ must have a corresponding test in tests/
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |
| Test plan | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |
| Review | `review-template.md` | `../../_genesis/templates/review-template.md` |

## Links

- [[documentation]]
- [[methodology]]
- [[schema]]
- [[workstream]]
