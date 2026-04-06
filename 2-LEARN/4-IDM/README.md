---
version: "2.2"
status: draft
last_updated: 2026-04-06
work_stream: 2-LEARN
sub_system: 4-IDM
type: template
iteration: 2
---

# 4-IDM — Insights & Decision Making | LEARN Workstream

> "If IDM produces no recommendations, the research loop never closes — 3-PLAN inherits raw findings it cannot act on, and the learning workstream adds cost without changing any decision."

IDM converts analytical findings from 3-DA into actionable insights and formal recommendations that 3-PLAN can consume directly. It is the final gate of the LEARN workstream: the point where research becomes direction. No insight leaves here without a clear recommendation and an identified next workstream owner.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [3-PLAN / feedback to 1-ALIGN]
                                    ↑
            Evidence from 3-DA + Effective Principles from 1-PD bound all recommendations
```

Receives from upstream: synthesized findings and force analysis from `3-DA/output/`, `da-effective-principles.md`, `da-literature-review.md`.
Produces for downstream: `idm-effective-principles.md`, insight report and recommendations in `output/` — consumed by 3-PLAN as the evidence-backed input for architecture, risk, and roadmap work.

## Contents

| Artifact | File Pattern | What it is |
|----------|-------------|------------|
| **Pipeline artifacts** | | |
| Effective Principles | `idm-effective-principles.md` | IDM-level constraints governing how insights become recommendations |
| Research spec | `idm-research-spec.md` | Criteria for what constitutes an actionable insight (S1 output) |
| UBS analysis | `idm-ubs-analysis.md` | Blocking forces — 1.0–1.6 analysis (info overload, misinterpretation, adoption failure) |
| UDS analysis | `idm-uds-analysis.md` | Driving forces — 2.0–2.6 analysis (clarity, actionability, decision-maker alignment) |
| Literature review | `idm-literature-review.md` | Final synthesis supporting each recommendation |
| **Pipeline subdirs** | | |
| S1 — Scope inputs | `input/` | Analytical findings received from 3-DA |
| S2 — Research | `research/` | Working documents produced during insight synthesis |
| S3 — Structured pages | `output/` | Final insight reports and recommendations — P0–P5 pages per topic |
| S5 — Specifications | `specs/` | Formal specs for recommendation structure and evidence standards |
| Archive | `archive/` | Superseded or exploratory insight drafts |
| **DSBV meta-artifacts** | | |
| Workstream design | `DESIGN.md` | DSBV Design spec for managing this subsystem's workstream |
| Workstream sequence | `SEQUENCE.md` | DSBV Sequence — ordered build plan |
| Workstream validate | `VALIDATE.md` | DSBV acceptance criteria for this subsystem |

## Pre-Flight Checklist

### S1 — Scope
- [ ] Insight criteria are explicit — what counts as actionable in this project context?
- [ ] `input/learn-input-{slug}.md` exists with IDM-specific questions

### S2 — Research
- [ ] Every source in `research/` originated from `3-DA/output/` — no unvetted findings admitted
- [ ] Each insight maps to a decision that 3-PLAN must make

### S3 — Structure
- [ ] P0–P5 pages complete in `output/`
- [ ] UBS analysis 1.0–1.6 present — covers info overload, misinterpretation, alert fatigue, adoption failure
- [ ] UDS analysis 2.0–2.6 present — covers clarity, actionable framing, decision-maker alignment
- [ ] Every recommendation traceable to a finding in `3-DA/output/`

### S4 — Review
- [ ] Human PM has reviewed and approved all P-pages — status set to `approved`
- [ ] If research revealed scope gaps, flag them for 1-ALIGN before proceeding

### S5 — Spec
- [ ] `specs/{slug}/vana-spec.md` exists
- [ ] Every EP in `idm-effective-principles.md` traces to a UBS or UDS finding
- [ ] Each insight names an owner — a workstream or role that will act on it
- [ ] Validated learning package ready for → 3-PLAN
