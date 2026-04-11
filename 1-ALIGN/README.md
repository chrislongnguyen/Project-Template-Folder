---
version: "1.3"
status: draft
last_updated: 2026-04-12
work_stream: 1-ALIGN
type: template
iteration: 1
---

# 1-ALIGN — Choose the Right Outcome

> "Are we solving the right problem? Is everyone aligned?"

## Purpose

Without locked alignment, every downstream workstream inherits a flawed premise — the project builds the wrong thing at scale. 1-ALIGN forces each subsystem to define scope, accountability, and desired outcomes before any research or execution begins. Its output — a validated alignment package per subsystem — is the gate that 2-LEARN cannot open without it.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Define boundaries — which problems, stakeholders, and constraints to investigate per subsystem | Validated scope document; stakeholder map (RACI); constraint register; initial risk register; Go/No-go decision |
| **Sequence** | Translate scope into a VANA-framed desired outcome and version roadmap | Desired outcome (VANA per version); master plan draft; version roadmap (Logic Scaffold → Concept → Prototype → MVE → Leadership); risk mitigation plan |
| **Build** | Produce and lock the alignment artifacts — charters, OKRs, key decisions | Approved charter (locked); signed-off OKRs per version; ADR log; baseline KPIs; stakeholder sign-off record |
| **Validate** | Verify alignment is complete and consistent — no gaps between subsystems | Alignment review report; corrective action log; validated alignment package → 2-LEARN |

## Subsystem Flow

```
PD-ALIGN  →  DP-ALIGN  →  DA-ALIGN  →  IDM-ALIGN
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Define the problem boundary — what this project exists to solve, and for whom | Project mandate; sponsor intent; user problem statement; prior lessons | pd-charter.md; pd-okr.md; Effective Principles → govern DP, DA, IDM |
| **DP** | Define the data pipeline boundary — which sources, types, and transformations are in scope | **Principles from PD** + data source inventory; infrastructure constraints | dp-charter.md; dp-okr.md; data quality SLAs → DP-Learn |
| **DA** | Define the analytical boundary — which questions, methods, and outputs are in scope | **Principles from PD** + pipeline SLAs from DP; analysis-ready data spec | da-charter.md; da-okr.md; insight quality SLAs → DA-Learn |
| **IDM** | Define the insight delivery boundary — which roles, decisions, and formats to support | **Principles from all upstream** + insight SLAs from DA; decision-maker context | idm-charter.md; idm-okr.md; delivery SLAs → IDM-Learn |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | PD charter, OKRs, ADRs, DESIGN/SEQUENCE/VALIDATE — Effective Principles that govern all downstream subsystems |
| `2-DP/` | DP charter, OKRs, ADRs, DESIGN/SEQUENCE/VALIDATE — data pipeline scope and constraints |
| `3-DA/` | DA charter, OKRs, ADRs, DESIGN/SEQUENCE/VALIDATE — analytical scope and quality criteria |
| `4-IDM/` | IDM charter, OKRs, ADRs, DESIGN/SEQUENCE/VALIDATE — final chartered direction and approved OKRs |
| `_cross/` | Stakeholder map, RACI, cross-cutting ADRs — shared governance artifacts for all subsystems |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](../_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](../_genesis/templates/dsbv-process.md) |
| Build (charter) | [`charter-template.md`](../_genesis/templates/charter-template.md) |
| Build (OKR) | [`okr-template.md`](../_genesis/templates/okr-template.md) |
| Build (decision) | [`adr-template.md`](../_genesis/templates/adr-template.md) |
| Validate | [`review-template.md`](../_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] Problem statement written with failure-risk framing (who, what, why it matters)
- [ ] Stakeholders identified and RACI assigned
- [ ] Constraints documented (time, resources, capability limits)
- [ ] Go/No-go decision recorded with rationale

### Sequence Stage
- [ ] Desired outcome expressed in VANA format per version
- [ ] Version roadmap covers all 5 iterations (Logic Scaffold → Leadership)
- [ ] Risk mitigation plan per identified constraint

### Build Stage
- [ ] Charter locked and signed off by sponsor
- [ ] OKRs approved and measurable
- [ ] Key decisions captured in ADR log
- [ ] Baseline KPIs established

### Validate Stage
- [ ] No scope gaps between PD, DP, DA, IDM
- [ ] Corrective actions assigned and tracked
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] Validated package ready for → 2-LEARN

## How ALIGN Connects

```
                              validated alignment package
(project mandate / 5-IMPROVE)  ──────────────────────────>  2-LEARN
          ▲                                                       │
          │ iteration retrospective                    Effective Principles
          │ + next-version scope                                  │
          │                                                       ▼
          └────── 5-IMPROVE  ◄── 4-EXECUTE  ◄── 3-PLAN  ◄────────┘
```

- **1-ALIGN → 2-LEARN:** Validated alignment package — chartered scope, approved OKRs, governing constraints
- **5-IMPROVE → 1-ALIGN:** Iteration retrospective closes the loop — next version re-enters here
- **Any WS → 1-ALIGN:** Scope change or misalignment discovered → re-align before proceeding

## DASHBOARDS

![[08-alignment-overview.base]]

## Links

- [[charter]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
- [[alpei-blueprint]]
- [[dsbv-process]]
