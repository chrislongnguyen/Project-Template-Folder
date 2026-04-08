---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 3-PLAN
sub_system: 1-PD
type: template
iteration: 1
---

# 1-PD — Problem Diagnosis | PLAN Workstream

> "Without PD, the PLAN workstream optimizes for the wrong risks — architecture and roadmap are built on an unexamined problem."

PD-PLAN establishes the foundational principles for this workstream: it names the problem being planned for, identifies blocking forces, and defines the drivers that constrain all planning choices. Every architecture decision, risk register, and roadmap in DP, DA, and IDM inherits these principles.

## Cascade Position

```
[3-PLAN inputs from 2-LEARN + 1-ALIGN]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
```

Receives from upstream: validated research outputs (`2-LEARN/4-IDM/`), approved charter and OKRs (`1-ALIGN/`).
Produces for downstream: `pd-architecture.md`, `pd-risk-register.md`, `pd-driver-register.md`, `pd-roadmap.md` — consumed by 2-DP as hard constraints on what data and inputs are in scope.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Architecture spec | `pd-architecture.md` | Defines the PD subsystem design and component boundaries |
| Risk register | `pd-risk-register.md` | UBS register — blocking forces specific to problem diagnosis |
| Driver register | `pd-driver-register.md` | UDS register — goals and constraints that shape PD decisions |
| Roadmap | `pd-roadmap.md` | Sequenced plan for PD deliverables across the iteration |

## Pre-Flight Checklist

- [ ] Confirm the problem statement is traceable to a validated 1-ALIGN charter objective
- [ ] Verify all identified risks have a subsystem owner (PD, DP, DA, or IDM)
- [ ] Confirm drivers are grounded in 2-LEARN research — not assumptions
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream

## Links

- [[DESIGN]]
- [[architecture]]
- [[charter]]
- [[iteration]]
- [[pd-architecture]]
- [[pd-driver-register]]
- [[pd-risk-register]]
- [[pd-roadmap]]
- [[roadmap]]
- [[workstream]]
