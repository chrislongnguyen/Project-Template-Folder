---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: 1-PD
---

# 3-PLAN / 1-PD — Problem Diagnosis

> **You are here:** `3-PLAN/1-PD/` — Architect the problem-diagnosis system. The architecture and principles here constrain everything in DP, DA, and IDM planning.

## What Goes Here

Planning artifacts scoped to Problem Diagnosis: an architecture spec (`pd-architecture.md`), a risk register (`pd-risk-register.md` — UBS: Ultimate Blocking System analysis), a driver register (`pd-driver-register.md` — UDS: Ultimate Driving System), and a roadmap (`pd-roadmap.md`). Also DSBV process files (DESIGN.md, SEQUENCE.md, VALIDATE.md).

## How to Create Artifacts

```
/dsbv design plan pd      # Step 1: Translate PD Effective Principles into architecture
/dsbv sequence plan pd    # Step 2: Order work by failure risk (sustainability first)
/dsbv build plan pd       # Step 3: Produce architecture, risk register, roadmap
/dsbv validate plan pd    # Step 4: Verify all risks have mitigations, ACs testable
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`2-LEARN/1-PD/` must have validated Effective Principles. These are the primary input: each Effective Principle becomes at least one architectural constraint in `pd-architecture.md`.

## Cascade Position

```
[PD Effective Principles from 2-LEARN]  →  [1-PD]  →  [2-DP]
                                                 ↓
         Architecture constraints and risk register cascade to DP, DA, IDM
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Architecture | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| Risk entry (UBS) | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| Driver entry (UDS) | `driver-entry-template.md` | `../../_genesis/templates/driver-entry-template.md` |
| Roadmap | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[architecture]]
- [[roadmap]]
- [[workstream]]
