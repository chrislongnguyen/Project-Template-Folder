---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 3-PLAN
type: template
iteration: 1
---

# 3-PLAN — Minimize Failure Risks

> "What could go wrong? How do we sequence to derisk first?"

## Purpose

Without PLAN, execution proceeds without a derisked sequence — teams build the hardest thing first, discover blockers mid-sprint, and accumulate rework debt that compounds with every iteration. This workstream translates the Effective System Design from LEARN into a concrete architecture, risk register, and ordered roadmap. Its output is the execution mandate: a locked plan that sequences work by failure risk (sustainability first) so that 4-EXECUTE encounters no structural surprises.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Translate effective principles into system architecture; identify all structural risks before committing to a build sequence | Architecture design document; component breakdown (EOE, EOT, EOP); architecture risk register |
| **Sequence** | Order execution by failure risk (sustainability first); define version milestones and sprint boundaries; assign owners | Derisked execution sequence; sprint plan per version; resource allocation; dependency map |
| **Build** | Finalize the execution plan with detailed specs, acceptance criteria, and rollback conditions for each deliverable | Locked execution plan; VANA acceptance criteria per deliverable; rollback playbook; driver register (UDS) |
| **Validate** | Verify the plan is complete, internally consistent, and executable — all risks have mitigations; all acceptance criteria are testable | Plan review report; corrective actions (back to Design/Sequence if needed); validated plan → 4-EXECUTE |

## Subsystem Flow

```
PD-PLAN  →  DP-PLAN  →  DA-PLAN  →  IDM-PLAN
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Architect the problem-diagnosis system; sequence diagnosis activities by risk; define what "done" looks like for PD | Validated EP + solution design from PD-LEARN; PD alignment package | PD architecture; PD execution sequence; PD acceptance criteria; **design constraints → DP, DA, IDM-PLAN** |
| **DP** | Architect the transformation system; derisk data quality and source reliability first; sequence pipeline build | **Principles from PD** + PD plan constraints; DP-LEARN transformation principles; DP alignment package | DP architecture; pipeline build sequence (safety before throughput); DP acceptance criteria → DP-EXECUTE |
| **DA** | Architect the analysis and logic system; validate analytical approach before committing to full build | **Principles from PD** + DP architecture outputs; DA-LEARN analysis principles; DA alignment package | DA architecture; analysis build sequence (accuracy before scale); DA acceptance criteria → DA-EXECUTE |
| **IDM** | Architect the insight delivery system; sequence delivery so manual review precedes automation | **Principles from all upstream** + DA architecture outputs; IDM-LEARN delivery principles; IDM alignment package | IDM architecture; delivery build sequence (safe presentation before automation); IDM acceptance criteria → IDM-EXECUTE |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | PLAN artifacts for problem diagnosis — architecture, risk register, execution sequence, acceptance criteria |
| `2-DP/` | PLAN artifacts for transformation — pipeline architecture, source risk register, build sequence, data quality SLAs |
| `3-DA/` | PLAN artifacts for analysis and logic — analytical architecture, methodology risk register, build sequence, accuracy criteria |
| `4-IDM/` | PLAN artifacts for insight delivery — delivery architecture, adoption risk register, rollout sequence, usability criteria |
| `_cross/` | Cross-cutting plan artifacts — project-level UBS register, UDS register, version roadmap, shared dependency map |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](_genesis/templates/dsbv-process.md) |
| Build | [`ubs-register-template.md`](_genesis/templates/ubs-register-template.md) — risk and driver registers |
| Validate | [`review-template.md`](_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] Confirm EP from 2-LEARN is finalized before designing architecture
- [ ] Translate each effective principle into at least one architectural constraint
- [ ] Identify all structural risks — components with no fallback, single points of failure, external dependencies
- [ ] Produce component breakdown (EOE, EOT, EOP) for each subsystem

### Sequence Stage
- [ ] Order work by failure risk — sustainability blockers before efficiency gains
- [ ] Define sprint boundaries and version milestones with explicit exit criteria
- [ ] Map all cross-subsystem dependencies and flag sequencing conflicts
- [ ] Assign owners for every milestone

### Build Stage
- [ ] Finalize UBS register — all known blockers with severity and mitigation
- [ ] Finalize UDS register — all known drivers with activation conditions
- [ ] Write VANA acceptance criteria for every deliverable
- [ ] Define rollback conditions for high-risk build steps

### Validate Stage
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] Every risk in the register has an assigned mitigation
- [ ] Validated package ready for → 4-EXECUTE

## How PLAN Connects

```
                  effective system design (UBS + UDS + EP)
2-LEARN  ─────────────────────────────────────────────>  3-PLAN
                                                             │
                                             locked execution plan + risk register
                                                             │
                                                             ▼
                                                         4-EXECUTE

3-PLAN ──"unresolved unknown"──> 2-LEARN  (close knowledge gap first)
3-PLAN ──"scope conflict"──────> 1-ALIGN  (re-align before locking plan)
```

## DASHBOARDS

![[10-planning-overview.base]]

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[architecture]]
- [[deliverable]]
- [[design-template]]
- [[dsbv-process]]
- [[iteration]]
- [[methodology]]
- [[review-template]]
- [[roadmap]]
- [[workstream]]
