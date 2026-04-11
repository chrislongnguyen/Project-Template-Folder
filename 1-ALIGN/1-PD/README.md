---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 1-ALIGN
sub_system: 1-PD
type: template
iteration: 1
---

# 1-PD — Problem Diagnosis | ALIGN Workstream

> "If PD misdiagnoses the problem, every downstream subsystem optimizes the wrong thing."

PD defines the problem this project exists to solve and produces the Effective Principles that constrain every downstream subsystem. It is the highest-leverage subsystem in the cascade — a flawed PD scope means DP collects wrong data, DA asks wrong questions, and IDM delivers wrong conclusions.

## Cascade Position

```
[(workstream-level inputs)]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
```

Receives from upstream: project mandate, sponsor intent, or strategic context (first subsystem — no ALPEI predecessor).
Produces for downstream: pd-charter.md, pd-okr.md, Effective Principles — consumed by 2-DP as hard constraints on data scope; shared with 3-DA and 4-IDM.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| pd-charter.md | `pd-charter.md` | Scoped problem statement, success criteria, constraints, Effective Principles |
| pd-okr.md | `pd-okr.md` | Measurable success criteria (Objectives + Key Results) per version |
| ADR-NNN_*.md | `ADR-NNN_{slug}.md` | Architecture Decision Records — the "why" behind PD scoping decisions |
| DESIGN.md | `DESIGN.md` | DSBV Design stage — acceptance criteria, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence — ordered work plan for PD alignment |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |

## Pre-Flight Checklist

- [ ] Project mandate received and understood — sponsor intent documented
- [ ] Problem statement written: who experiences it, what the impact is, why now
- [ ] Effective Principles drafted — at least 3 S-Principles constraining scope
- [ ] pd-charter.md signed off by sponsor or project lead
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| pd-charter.md | `charter-template.md` | `../../_genesis/templates/charter-template.md` |
| pd-okr.md | `okr-template.md` | `../../_genesis/templates/okr-template.md` |
| ADR-NNN_*.md | `adr-template.md` | `../../_genesis/templates/adr-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
