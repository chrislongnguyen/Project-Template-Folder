---
version: "2.2"
status: draft
last_updated: 2026-04-06
work_stream: 2-LEARN
sub_system: 1-PD
type: template
iteration: 2
---

# 1-PD — Problem Diagnosis | LEARN Workstream

> "Without a scoped research question, the pipeline ingests everything and learns nothing — blocking forces and driving forces remain undifferentiated noise."

PD translates the chartered problem from 1-ALIGN into a bounded research question with explicit effective principles, UBS (blocking forces), and UDS (driving forces). It governs what the pipeline is allowed to search for and constrains 2-DP to in-scope sources only.

PD is the most consequential subsystem in LEARN — the S-Principles and E-Principles it derives govern the entire UES. Every downstream subsystem (DP, DA, IDM) inherits these principles and cannot contradict them.

## Cascade Position

```
[1-ALIGN output (chartered direction)]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
                                                   ↑
                          Effective Principles from here scope the entire pipeline
```

Receives from upstream: chartered problem definition, approved OKRs from `1-ALIGN/4-IDM/idm-charter.md`.
Produces for downstream: `pd-effective-principles.md`, `pd-research-spec.md`, `pd-ubs-analysis.md`, `pd-uds-analysis.md` — consumed by 2-DP as hard constraints defining what sources and topics are in scope.

## Contents

| Artifact | File Pattern | What it is |
|----------|-------------|------------|
| **Pipeline artifacts** | | |
| Effective Principles | `pd-effective-principles.md` | S-Principle + E-Principle derivations — govern the entire LEARN pipeline |
| Research spec | `pd-research-spec.md` | Scoped research questions, objectives, and methodology (S1 output) |
| UBS analysis | `pd-ubs-analysis.md` | Blocking forces — structured 1.0–1.6 analysis |
| UDS analysis | `pd-uds-analysis.md` | Driving forces — structured 2.0–2.6 analysis |
| Literature review | `pd-literature-review.md` | Evidence log supporting UBS/UDS findings |
| **Pipeline subdirs** | | |
| S1 — Scope inputs | `input/` | Research questions, source lists, raw captures |
| S2 — Research | `research/` | Evidence files, investigation working docs |
| S3 — Structured pages | `output/` | P0–P5 pages per topic — structured findings |
| S5 — Specifications | `specs/` | VANA-SPEC + derived Effective Principles |
| Archive | `archive/` | Superseded drafts, rejected hypotheses |
| **DSBV meta-artifacts** | | |
| Workstream design | `DESIGN.md` | DSBV Design spec for managing this subsystem's workstream |
| Workstream sequence | `SEQUENCE.md` | DSBV Sequence — ordered build plan |
| Workstream validate | `VALIDATE.md` | DSBV acceptance criteria for this subsystem |

## Pre-Flight Checklist

### S1 — Scope
- [ ] Research question is traceable to the chartered problem in `1-ALIGN/4-IDM/idm-charter.md`
- [ ] `input/learn-input-{slug}.md` exists with system slug and research questions
- [ ] Out-of-scope boundaries are explicitly stated

### S2 — Research
- [ ] Every claim in `research/` has a cited source
- [ ] UBS candidate forces and UDS candidate forces are both represented — not one-sided

### S3 — Structure
- [ ] P0–P5 pages complete in `output/`
- [ ] UBS analysis sections 1.0–1.6 all present
- [ ] UDS analysis sections 2.0–2.6 all present

### S4 — Review
- [ ] Human PM has reviewed and approved all P-pages — status set to `validated`

### S5 — Spec
- [ ] `specs/{slug}/vana-spec.md` exists
- [ ] Every EP in `pd-effective-principles.md` traces to a UBS or UDS finding
- [ ] S-Principles and E-Principles derivation formulas are both applied
- [ ] Ready for handoff to 2-DP
