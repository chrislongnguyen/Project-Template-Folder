---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 4-EXECUTE
sub_system: 2-DP
---

# 4-EXECUTE / 2-DP — Data Pipeline

> **You are here:** `4-EXECUTE/2-DP/` — Build the ingestion and transformation layer. Source connectors, cleaning rules, and schema contracts that deliver validated inputs to DA.

## What Goes Here

Execution artifacts scoped to the Data Pipeline: `src/` (pipeline source code — connectors, loaders, transformations), `notebooks/` (exploratory work and schema discovery), `tests/` (contract tests verifying schema, completeness, freshness), `config/` (data source definitions), `docs/` (data dictionary, pipeline diagram). Also DSBV process files.

## How to Create Artifacts

```
/dsbv design execute dp      # Step 1: Technical design for pipeline components
/dsbv sequence execute dp    # Step 2: Sequence pipeline build (safety before throughput)
/dsbv build execute dp       # Step 3: Produce source code, tests, config
/dsbv validate execute dp    # Step 4: All contract tests pass before handoff to DA
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`4-EXECUTE/1-PD/DESIGN.md` must be approved before DP build work begins. All data sources in `config/` must be approved in PD's scope boundary.

## Cascade Position

```
[1-PD DESIGN.md scope boundary]  →  [2-DP]  →  [3-DA]
                                          ↑
              DA cannot run until DP outputs pass contract tests
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |
| Test plan | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |
| Review | `review-template.md` | `../../_genesis/templates/review-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[schema]]
- [[workstream]]
