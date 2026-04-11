---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 1-ALIGN
sub_system: 2-DP
---

# 1-ALIGN / 2-DP — Data Pipeline

> **You are here:** `1-ALIGN/2-DP/` — Define what data sources and inputs are in scope for this project. Bounded by PD's Effective Principles.

## What Goes Here

Alignment artifacts scoped to the Data Pipeline subsystem: a charter (`dp-charter.md`) defining data scope and transformation boundaries, OKRs, Architecture Decision Records for DP-stage decisions, and DSBV process files (DESIGN.md, SEQUENCE.md, VALIDATE.md).

## How to Create Artifacts

```
/dsbv design align dp      # Step 1: Design the DP alignment scope
/dsbv sequence align dp    # Step 2: Sequence the build tasks
/dsbv build align dp       # Step 3: Agent produces charter, OKRs, decisions
/dsbv validate align dp    # Step 4: Review against acceptance criteria
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`1-ALIGN/1-PD/` must have a validated artifact before starting DP. The PD charter and Effective Principles constrain what data sources and inputs are in scope here.

## Cascade Position

```
[1-PD]  →  [2-DP]  →  [3-DA]
                ↑
  Effective Principles from 1-PD bound what data is in scope
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
