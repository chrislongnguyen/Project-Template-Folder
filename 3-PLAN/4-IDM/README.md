---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: 4-IDM
---

# 3-PLAN / 4-IDM — Insights & Decision Making

> **You are here:** `3-PLAN/4-IDM/` — Select the architecture, commit mitigations, lock the roadmap. The approved package here is the build contract for 4-EXECUTE.

## What Goes Here

Planning artifacts scoped to Insights and Decision Making: `idm-architecture.md` (final selected architecture with decision rationale), `idm-risk-register.md` (approved UBS — committed mitigations with owners), `idm-driver-register.md` (locked UDS), and `idm-roadmap.md` (approved delivery sequence for 4-EXECUTE). Also DSBV process files.

## How to Create Artifacts

```
/dsbv design plan idm      # Step 1: Synthesize DA analysis into committed decisions
/dsbv sequence plan idm    # Step 2: Lock delivery sequence and milestones
/dsbv build plan idm       # Step 3: Produce final architecture, approved roadmap
/dsbv validate plan idm    # Step 4: Verify every risk has a mitigation and owner
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`3-PLAN/3-DA/` must have a validated architecture. IDM converts DA's analysis into committed decisions — it cannot commit without the analyzed options.

## Cascade Position

```
[3-DA analyzed options]  →  [4-IDM]  →  [4-EXECUTE]
                                   ↓
     Approved idm-roadmap.md is the build contract 4-EXECUTE works from
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Architecture | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| Risk entry (UBS) | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| Driver entry (UDS) | `driver-entry-template.md` | `../../_genesis/templates/driver-entry-template.md` |
| Roadmap | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[SEQUENCE]]
- [[architecture]]
- [[roadmap]]
- [[workstream]]
