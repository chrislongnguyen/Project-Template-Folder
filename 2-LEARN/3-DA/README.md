---
version: "2.2"
status: draft
last_updated: 2026-04-06
work_stream: 2-LEARN
sub_system: 3-DA
type: template
iteration: 2
---

# 3-DA — Data Analysis | LEARN Workstream

> "Without systematic analysis, the pipeline produces a pile of sources but no learning — IDM has no synthesized findings to act on, and the project must either guess or repeat the research."

DA synthesizes the validated inputs from 2-DP into structured findings: literature synthesis, force analysis, pattern identification, and gap assessment. These become the evidence basis that 4-IDM converts into actionable insights and recommendations for 3-PLAN.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
                                   ↑
           Effective Principles from 1-PD govern what conclusions are in scope
```

Receives from upstream: filtered source set from `2-DP/output/`, `dp-effective-principles.md`, `dp-literature-review.md`.
Produces for downstream: `da-effective-principles.md`, synthesized literature review, force analysis outputs — consumed by 4-IDM as the evidence base for insight generation and recommendation drafting.

## Contents

| Artifact | File Pattern | What it is |
|----------|-------------|------------|
| **Pipeline artifacts** | | |
| Effective Principles | `da-effective-principles.md` | DA-level constraints governing analytical methods and scope |
| Research spec | `da-research-spec.md` | Analytical methodology and synthesis approach (S1 output) |
| UBS analysis | `da-ubs-analysis.md` | Blocking forces — 1.0–1.6 analysis of analytical obstacles (bias, brittle methods) |
| UDS analysis | `da-uds-analysis.md` | Driving forces — 2.0–2.6 analysis of what enables rigorous analysis |
| Literature review | `da-literature-review.md` | Synthesized findings across all validated sources |
| **Pipeline subdirs** | | |
| S1 — Scope inputs | `input/` | Validated inputs received from 2-DP |
| S2 — Research | `research/` | Working documents produced during synthesis |
| S3 — Structured pages | `output/` | Finalized analytical findings — P0–P5 pages per topic |
| S5 — Specifications | `specs/` | Formal analytical specs and methodologies |
| Archive | `archive/` | Superseded analyses or exploratory drafts |
| **DSBV meta-artifacts** | | |
| Workstream design | `DESIGN.md` | DSBV Design spec for managing this subsystem's workstream |
| Workstream sequence | `SEQUENCE.md` | DSBV Sequence — ordered build plan |
| Workstream validate | `VALIDATE.md` | DSBV acceptance criteria for this subsystem |

## Pre-Flight Checklist

### S1 — Scope
- [ ] Analytical methodology is traceable to `1-PD/pd-research-spec.md` research questions
- [ ] `input/learn-input-{slug}.md` exists with analysis-specific questions

### S2 — Research
- [ ] Every source in `research/` originated from `2-DP/output/` — no unvetted sources admitted
- [ ] Analysis methods explicitly stated and justified

### S3 — Structure
- [ ] P0–P5 pages complete in `output/`
- [ ] UBS analysis sections 1.0–1.6 present — covers misleading patterns, bias, brittle methods
- [ ] UDS analysis sections 2.0–2.6 present — covers robust methods, validation approaches
- [ ] Every conclusion traceable to a source in `2-DP/output/` — no unsupported claims

### S4 — Review
- [ ] Human PM has reviewed and approved all P-pages — status set to `validated`

### S5 — Spec
- [ ] `specs/{slug}/vana-spec.md` exists
- [ ] Every EP in `da-effective-principles.md` traces to a UBS or UDS finding
- [ ] Literature review synthesis covers all research questions from `1-PD/pd-research-spec.md`
- [ ] Ready for handoff to 4-IDM
