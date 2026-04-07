---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 1-ALIGN
type: template
iteration: 1
---

# 1-ALIGN — Choose the Right Outcome

> "Are we solving the right problem? Is everyone aligned?"

## Purpose

Without ALIGN, every downstream workstream optimizes for the wrong outcome. Teams build efficiently toward a goal no stakeholder approved, with roles no one agreed on, and constraints no one documented. This workstream forces the project to lock problem scope, decision authority, and desired outcomes (VANA) before any learning or execution begins. Its output — a validated alignment package — is the single input that authorizes 2-LEARN to proceed.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Define problem boundaries — which questions to answer, who is accountable (RACI), and what constraints are non-negotiable | Validated scope (in/out); stakeholder map with RACI; constraint register; initial risk register; go/no-go decision |
| **Sequence** | Draft desired outcomes using VANA; sequence version milestones and resource allocations | Desired outcome statement (VANA per version); master plan draft; version roadmap; risk mitigation plan |
| **Build** | Finalize and lock the master plan; obtain stakeholder sign-off; communicate objectives and baselines | Approved master plan (locked); signed-off outcomes per version; baseline KPIs; alignment brief distributed |
| **Validate** | Verify alignment is complete and coherent — no gaps, no conflicting scope, no unapproved assumptions | Alignment review report; corrective actions (back to Design/Sequence if needed); validated alignment package → 2-LEARN |

## Subsystem Flow

```
PD-ALIGN  →  DP-ALIGN  →  DA-ALIGN  →  IDM-ALIGN
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Define the boundaries of the problem diagnosis effort — which problems, stakeholders, and constraints to investigate | Project mandate; user problem statement; available resources; prior lessons learned | Approved PD master plan; signed-off problem scope per version; validated alignment → PD-LEARN |
| **DP** | Define the boundaries of the transformation effort — which inputs, processes, and outputs are in scope | **Principles from PD** + data source requirements; infrastructure constraints; PD scope boundaries | Approved DP master plan; transformation SLAs per version; validated alignment → DP-LEARN |
| **DA** | Define the boundaries of the analysis and logic effort — which analytical questions, methods, and outputs are in scope | **Principles from PD** + DP scope boundaries; analysis-ready artifact spec; downstream consumer requirements | Approved DA master plan; insight quality SLAs per version; validated alignment → DA-LEARN |
| **IDM** | Define the boundaries of insight delivery — which roles need outputs, what decisions must be supported, and at what cadence | **Principles from all upstream** + analyzed output spec; decision-maker context; organizational change capacity | Approved IDM master plan; delivery and decision-support SLAs; validated alignment → IDM-LEARN |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | ALIGN artifacts scoped to problem diagnosis — charter, decisions, OKRs for the PD subsystem |
| `2-DP/` | ALIGN artifacts scoped to transformation — charter, decisions, OKRs for the DP subsystem |
| `3-DA/` | ALIGN artifacts scoped to analysis and logic — charter, decisions, OKRs for the DA subsystem |
| `4-IDM/` | ALIGN artifacts scoped to insight delivery — charter, decisions, OKRs for the IDM subsystem |
| `_cross/` | Cross-cutting alignment artifacts that span all subsystems — project-level charter, shared OKRs, organization-wide RACI, version roadmap |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](_genesis/templates/dsbv-process.md) |
| Build | [`charter-template.md`](_genesis/templates/charter-template.md) — master plan and sign-off |
| Validate | [`review-template.md`](_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] Define problem statement — who is affected, what is broken, what is out of scope
- [ ] Identify all stakeholders and assign RACI roles
- [ ] Document constraints (time, budget, technical, organizational)
- [ ] Record initial risks in the risk register
- [ ] Obtain go/no-go decision before proceeding

### Sequence Stage
- [ ] Write desired outcomes using VANA format (Verb Adverb Noun Adjective) per version
- [ ] Draft master plan with version milestones (I0 → I1 → I2 → I3 → I4)
- [ ] Sequence resource allocations against version roadmap
- [ ] Define risk mitigations for top-3 blocking forces

### Build Stage
- [ ] Finalize master plan — no open scope questions
- [ ] Obtain written sign-off from all RACI Accountable parties
- [ ] Communicate objectives and baseline KPIs to all Responsible and Consulted parties
- [ ] Confirm the alignment brief has been distributed

### Validate Stage
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] No contradictions between subsystem charters
- [ ] Validated package ready for → 2-LEARN

## How ALIGN Connects

```
                  project mandate + stakeholder input
(project trigger)  ─────────────────────────────────>  1-ALIGN
                                                           │
                                              validated alignment package
                                                           │
                                                           ▼
                                                        2-LEARN

1-ALIGN ──"scope gap found"──> 1-ALIGN  (iterate within workstream)
1-ALIGN ──"new constraint"──>  1-ALIGN  (re-run Design stage)
5-IMPROVE ──"feedback loop"──> 1-ALIGN  (close the ALPEI loop)
```

## DASHBOARDS

![[ALIGN Overview.base]]
