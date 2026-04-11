---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 1-ALIGN
sub_system: 4-IDM
---

# 1-ALIGN / 4-IDM — Insights & Decision Making

> **You are here:** `1-ALIGN/4-IDM/` — Convert analysis into explicit decisions: final chartered direction, approved OKRs, and the package that unlocks 2-LEARN.

## What Goes Here

Alignment artifacts scoped to Insights and Decision Making: a charter (`idm-charter.md`) capturing the final chartered scope, approved OKRs, Architecture Decision Records for key project decisions, and DSBV process files (DESIGN.md, SEQUENCE.md, VALIDATE.md). IDM is the final gate before 2-LEARN begins.

## How to Create Artifacts

```
/dsbv design align idm      # Step 1: Design the IDM alignment scope
/dsbv sequence align idm    # Step 2: Sequence the build tasks
/dsbv build align idm       # Step 3: Agent produces charter, OKRs, decisions
/dsbv validate align idm    # Step 4: Review against acceptance criteria
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`1-ALIGN/3-DA/` must have a validated artifact before starting IDM. All analytical findings from DA must be addressed — no open questions at this stage.

## Cascade Position

```
[3-DA]  →  [4-IDM]  →  [2-LEARN / 3-PLAN]
                  ↓
     Validated IDM charter unlocks 2-LEARN
```

IDM is the output gate for the ALIGN workstream. The validated IDM package (charter + OKRs + decisions) is what 2-LEARN consumes as its problem definition input.

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
