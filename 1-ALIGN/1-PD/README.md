---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 1-ALIGN
sub_system: 1-PD
---

# 1-ALIGN / 1-PD — Problem Diagnosis

> **You are here:** `1-ALIGN/1-PD/` — Define the problem this project exists to solve. The Effective Principles produced here govern every downstream subsystem.

## What Goes Here

Alignment artifacts scoped to Problem Diagnosis: a charter (`pd-charter.md`) defining scope and success criteria, OKRs (`pd-okr.md`), Architecture Decision Records for PD-stage decisions, and DSBV process files (DESIGN.md, SEQUENCE.md, VALIDATE.md).

## How to Create Artifacts

```
/dsbv design align pd      # Step 1: Design the PD alignment scope
/dsbv sequence align pd    # Step 2: Sequence the build tasks
/dsbv build align pd       # Step 3: Agent produces charter, OKRs, decisions
/dsbv validate align pd    # Step 4: Review against acceptance criteria
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

PD is the first subsystem in ALIGN. No upstream subsystem dependency.

Input: project mandate, sponsor intent, or strategic context from your organization.

## Cascade Position

```
[project trigger]  →  [1-PD]  →  [2-DP]
                           ↓
             Effective Principles from PD govern DP, DA, and IDM
```

PD is the most important subsystem: the scope boundaries and principles it establishes constrain everything downstream. Complete and validate PD before starting 2-DP.

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
