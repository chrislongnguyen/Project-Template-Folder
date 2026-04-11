---
version: "1.3"
status: draft
last_updated: 2026-04-12
work_stream: 3-PLAN
type: template
iteration: 1
---

# 3-PLAN — Minimize Failure Risks

> "What could go wrong? How do we sequence to derisk first?"

## Purpose

Without a rigorous planning workstream, execution teams inherit ambiguity instead of architecture — they make design decisions under time pressure that belong in PLAN. 3-PLAN translates the Effective Principles from 2-LEARN into a derisked system architecture, an ordered risk register, and a sequenced roadmap that minimizes failure before the first line of code. Its output — approved architecture + UBS/UDS registers + roadmap — is the contract that 4-EXECUTE builds against.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Translate Effective Principles into architectural decisions — what gets built, with what constraints | System architecture spec (what and why); key architectural decisions (ADRs); constraint map from Effective Principles |
| **Sequence** | Order work by failure risk — most dangerous unknowns first (S > E > Sc) | Risk-ordered workplan; dependency map; milestone sequence; resource allocation plan |
| **Build** | Produce the full planning artifact set — architecture, registers, roadmap | pd/dp/da/idm-architecture.md; UBS_REGISTER.md; UDS_REGISTER.md; roadmap.md; BLUEPRINT.md |
| **Validate** | Verify architecture is sound, risks have mitigations, roadmap is executable | Architecture review report; risk mitigation coverage check; validated plan → 4-EXECUTE |

## Subsystem Flow

```
PD-PLAN  →  DP-PLAN  →  DA-PLAN  →  IDM-PLAN
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Architect the problem-diagnosis system — translate PD Effective Principles into technical architecture | **PD Effective Principles from 2-LEARN**; pd-charter.md from 1-ALIGN | pd-architecture.md; UBS/UDS registers → cascade as constraints to DP, DA, IDM |
| **DP** | Architect the data pipeline — define source integration, transformation logic, quality gates | **PD architecture constraints**; DP Effective Principles from 2-LEARN | dp-architecture.md; dp-risk-register.md → feed DA architecture |
| **DA** | Architect the analysis layer — define methods, tooling, validation approach, output format | **PD + DP architectural constraints**; DA Effective Principles | da-architecture.md; da-risk-register.md → feed IDM architecture |
| **IDM** | Architect the insight delivery system — dashboards, APIs, alerts, decision-support tools | **Principles from all upstream**; IDM Effective Principles; DA output spec | idm-architecture.md; roadmap.md → approved plan for 4-EXECUTE |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | PD architecture spec, UBS/UDS registers, roadmap, DESIGN/SEQUENCE/VALIDATE |
| `2-DP/` | DP architecture spec, pipeline risk register, data source map, DESIGN/SEQUENCE/VALIDATE |
| `3-DA/` | DA architecture spec, analytical risk register, method selection rationale, DESIGN/SEQUENCE/VALIDATE |
| `4-IDM/` | IDM architecture spec, delivery roadmap, approved tool stack, DESIGN/SEQUENCE/VALIDATE |
| `_cross/` | Project-wide UBS_REGISTER.md, UDS_REGISTER.md, BLUEPRINT.md, cross-cutting ADRs |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](../_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](../_genesis/templates/dsbv-process.md) |
| Build (architecture) | [`architecture-template.md`](../_genesis/templates/architecture-template.md) |
| Build (risk entry) | [`risk-entry-template.md`](../_genesis/templates/risk-entry-template.md) |
| Build (driver entry) | [`driver-entry-template.md`](../_genesis/templates/driver-entry-template.md) |
| Build (roadmap) | [`roadmap-template.md`](../_genesis/templates/roadmap-template.md) |
| Build (force analysis) | [`force-analysis-template.md`](../_genesis/templates/force-analysis-template.md) |
| Validate | [`review-template.md`](../_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] Effective Principles from 2-LEARN received for each subsystem
- [ ] Architecture boundaries agreed (what is in scope vs. deferred)
- [ ] Architectural decisions documented in ADR log
- [ ] UBS structure agreed — failure categories defined

### Sequence Stage
- [ ] Work ordered by failure risk (S > E > Sc)
- [ ] Dependencies between subsystems mapped
- [ ] Resource allocation matched to roadmap milestones

### Build Stage
- [ ] pd/dp/da/idm-architecture.md complete and internally consistent
- [ ] UBS_REGISTER.md populated — each risk has a mitigation
- [ ] UDS_REGISTER.md populated — each driver has an activation strategy
- [ ] roadmap.md approved

### Validate Stage
- [ ] Architecture reviewed against all Effective Principles — no contradictions
- [ ] Every UBS risk has a mitigation strategy
- [ ] Roadmap is executable given available resources
- [ ] Validated plan package ready → 4-EXECUTE

## How PLAN Connects

```
                  Effective Principles + DSBV Readiness Package
2-LEARN  ──────────────────────────────────────────────────>  3-PLAN
                                                                  │
                                               approved architecture
                                               + UBS/UDS registers + roadmap
                                                                  │
                                                                  ▼
                                                             4-EXECUTE
```

- **2-LEARN → 3-PLAN:** Effective Principles as hard architectural constraints; DSBV-READY confirms research complete
- **3-PLAN → 4-EXECUTE:** Approved architecture, risk register, ordered roadmap as the build contract
- **3-PLAN → 2-LEARN:** Unknowns surface during planning → return to research

## DASHBOARDS

![[10-planning-overview.base]]

## Links

- [[architecture]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
- [[roadmap]]
- [[alpei-blueprint]]
