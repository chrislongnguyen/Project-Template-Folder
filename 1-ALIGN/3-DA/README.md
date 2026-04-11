---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 1-ALIGN
sub_system: 3-DA
---

# 1-ALIGN / 3-DA — Data Analysis

> **You are here:** `1-ALIGN/3-DA/` — Define the analytical scope: which questions to answer, which methods are approved, which conclusions count as success.

## What Goes Here

Alignment artifacts scoped to the Data Analysis subsystem: a charter (`da-charter.md`) defining analytical scope and quality criteria, OKRs, Architecture Decision Records for DA-stage decisions, and DSBV process files (DESIGN.md, SEQUENCE.md, VALIDATE.md).

## How to Create Artifacts

```
/dsbv design align da      # Step 1: Design the DA alignment scope
/dsbv sequence align da    # Step 2: Sequence the build tasks
/dsbv build align da       # Step 3: Agent produces charter, OKRs, decisions
/dsbv validate align da    # Step 4: Review against acceptance criteria
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`1-ALIGN/2-DP/` must have a validated artifact before starting DA. The DP charter establishes what analysis-ready inputs will be available, bounding the analytical scope here.

## Cascade Position

```
[2-DP]  →  [3-DA]  →  [4-IDM]
                ↑
  DP charter constrains what analysis inputs are available
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Charter | `charter-template.md` | `../../_genesis/templates/charter-template.md` |
| OKRs | `okr-template.md` | `../../_genesis/templates/okr-template.md` |
| Decision (ADR) | `adr-template.md` | `../../_genesis/templates/adr-template.md` |
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[charter]]
- [[okr]]
- [[workstream]]
