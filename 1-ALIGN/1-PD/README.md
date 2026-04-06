---
version: "2.1"
status: draft
last_updated: 2026-04-06
work_stream: 1-ALIGN
sub_system: 1-PD
type: template
iteration: 2
---

# 1-PD — Problem Diagnosis | ALIGN Workstream

> "If the problem is never clearly diagnosed, every downstream alignment artifact answers the wrong question — charter, OKRs, and decisions are all built on a false premise."

PD defines what problem this project exists to solve and encodes the principles that govern all downstream alignment work. It receives the project trigger from the workstream entry point and passes a scoped problem statement and effective principles to 2-DP as the hard foundation for all subsequent data gathering and design.

## Cascade Position

```
[(project trigger / sponsor intent)]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
                                                ↑
                         Effective principles from here govern DP, DA, and IDM
```

Receives from upstream: project mandate, sponsor intent, or strategic context (typically verbal or in `_cross/`).
Produces for downstream: `pd-effective-principles.md`, scoped problem statement in `pd-charter.md` — consumed by 2-DP as the governing constraint for what data and stakeholders are in scope.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Charter | `pd-charter.md` | Defines scope, objectives, and success criteria for this subsystem |
| OKR register | `pd-okr.md` | Objectives and key results anchored to the problem diagnosis |
| OKR register (full) | `pd-okr-register.md` | Expanded tracking register for OKRs across iterations |
| Decision log template | `pd-decision-adr-template.md` | ADR template for decisions made during problem diagnosis |
| DSBV Design | `DESIGN.md` | Design spec for how PD work is structured in this project |
| DSBV Sequence | `SEQUENCE.md` | Ordered build plan for PD artifacts |
| DSBV Validate | `VALIDATE.md` | Acceptance criteria and validation evidence for PD |

## Pre-Flight Checklist

- [ ] Define the problem statement — one sentence, falsifiable, free of solution bias
- [ ] Confirm effective principles are written and do not contradict sponsor intent
- [ ] Verify charter scope excludes what is explicitly out of scope
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to 2-DP
