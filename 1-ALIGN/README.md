---
version: "1.2"
status: draft
last_updated: 2026-04-11
work_stream: 1-ALIGN
sub_system: _root
---

# 1-ALIGN — Choose the Right Outcome

> **You are here:** `1-ALIGN/` — Lock problem scope, stakeholder accountability, and desired outcomes before any learning or execution begins.

## What Goes Here

Alignment artifacts: charters (what the project commits to deliver), OKRs (Objectives and Key Results — measurable success criteria), Architecture Decision Records (ADRs — the "why" behind decisions), and DSBV (Design, Sequence, Build, Validate) process files for each subsystem. Artifacts are produced in 4 subsystem directories plus `_cross/` for project-wide artifacts.

## How to Create Artifacts

This directory is empty by design. Run DSBV to generate content:

```
/dsbv design align pd      # Step 1: Design what you'll build for Problem Diagnosis
/dsbv sequence align pd    # Step 2: Plan the work order
/dsbv build align pd       # Step 3: Produce the artifacts (agent builds)
/dsbv validate align pd    # Step 4: Review against acceptance criteria
```

Repeat for each subsystem: `pd` → `dp` → `da` → `idm`. PD must be validated before starting DP.

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

ALIGN is the first workstream. No upstream dependency. Start here.

Input: project mandate, sponsor intent, or strategic context from your organization.

## Subsystem Sequence

```
1-PD  →  2-DP  →  3-DA  →  4-IDM
 ↓
PD produces Effective Principles that govern DP, DA, and IDM
```

| Directory | Subsystem | What it produces |
|-----------|-----------|-----------------|
| `1-PD/` | Problem Diagnosis | Scoped problem statement; Effective Principles for the whole project |
| `2-DP/` | Data Pipeline | Data scope and transformation charter |
| `3-DA/` | Data Analysis | Analytical scope charter |
| `4-IDM/` | Insights & Decision Making | Final chartered direction; approved OKRs |
| `_cross/` | Cross-cutting | Stakeholder map, RACI — shared across all subsystems |

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Charter | `charter-template.md` | `../_genesis/templates/charter-template.md` |
| Design spec | `design-template.md` | `../_genesis/templates/design-template.md` |
| OKRs | `okr-template.md` | `../_genesis/templates/okr-template.md` |
| Decisions (ADR) | `adr-template.md` | `../_genesis/templates/adr-template.md` |
| Review | `review-template.md` | `../_genesis/templates/review-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[charter]]
- [[dsbv-process]]
- [[workstream]]
