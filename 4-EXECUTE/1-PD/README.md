---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 4-EXECUTE
sub_system: 1-PD
---

# 4-EXECUTE / 1-PD — Problem Diagnosis

> **You are here:** `4-EXECUTE/1-PD/` — Confirm build scope and establish execution principles. PD's DESIGN.md must be approved before any DP, DA, or IDM build work begins.

## What Goes Here

Execution artifacts scoped to Problem Diagnosis: DSBV process files (DESIGN.md, SEQUENCE.md, VALIDATE.md), `docs/` (subsystem reference documentation), and `config/` (PD-scoped configuration). The DESIGN.md here is the approved build contract that all downstream subsystems inherit.

## How to Create Artifacts

```
/dsbv design execute pd      # Step 1: Confirm sprint scope and prerequisites
/dsbv sequence execute pd    # Step 2: Technical design for each PD deliverable
/dsbv build execute pd       # Step 3: Produce the artifacts
/dsbv validate execute pd    # Step 4: Verify against VANA acceptance criteria
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`3-PLAN/4-IDM/` must have an approved roadmap (the build contract). Confirm prerequisites: inputs available, tools accessible, environment configured — before any build work begins.

## Cascade Position

```
[3-PLAN approved package]  →  [1-PD]  →  [2-DP]
                                   ↓
     PD's DESIGN.md is the scope boundary all downstream subsystems build within
```

**GATE:** No DP, DA, or IDM build work starts until PD's DESIGN.md is approved. This is enforced by the `dsbv-skill-guard.sh` hook.

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |
| Sequence plan | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| Test plan | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |
| Review | `review-template.md` | `../../_genesis/templates/review-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[deliverable]]
- [[workstream]]
