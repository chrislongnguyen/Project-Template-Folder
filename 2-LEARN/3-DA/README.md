---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 2-LEARN
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | LEARN Workstream

> "If DA research picks methods that fit the available data, the analysis will answer questions the data can answer — not questions the problem requires."

DA-LEARN researches analytical methods, bias risks, validation approaches, and the gap between available data and required insights. It is bounded by PD Effective Principles and the pipeline constraints from DP-LEARN.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
                          ↑
     Anchors on: PD Effective Principles + DP pipeline constraints — defines which analytical
     methods are valid given data reality
```

Receives from upstream: `2-LEARN/2-DP/specs/vana-spec.md` (pipeline constraints + validated data spec) + PD Effective Principles from `2-LEARN/1-PD/specs/vana-spec.md`.
Produces for downstream: vana-spec.md with analytical method constraints — consumed by 2-LEARN/4-IDM as delivery design bounds, and by 3-PLAN/3-DA as the DSBV-READY package that unlocks planning.

## Pipeline Stages

**HARD CONSTRAINT:** No DESIGN.md, SEQUENCE.md, or VALIDATE.md in this directory.
LEARN uses the 6-state pipeline (S1–S5), not DSBV.

| Stage | Location | What happens here |
|-------|----------|------------------|
| **S1 — Scope** | `_cross/input/` | learn-input-{slug}.md — research scope definition |
| **S2 — Research** | `_cross/research/{slug}/` | Deep research per topic (cited, 6-section format) |
| **S3 — Structure** | `output/` | P0–P5 structured learning pages (`/learn:structure`) |
| **S4 — Review** | status on P-pages in `output/` | Human review gate — approve or reject each P-page |
| **S5 — Spec** | `specs/` | Effective Principles extracted from validated findings |

## Contents

| Artifact | Location | Purpose |
|----------|----------|---------|
| `learn-input-3-DA.md` | `_cross/input/` | Research scope definition for this subsystem |
| `T{n}-{topic}.md` | `_cross/research/3-DA/` | Deep research per topic (cited, structured) |
| `T0.P{m}-{slug}.md` | `output/` | P0–P5 structured learning pages |
| `vana-spec.md` | `specs/` | Extracted Effective Principles — primary output |
| `DSBV-READY-3-DA.md` | `specs/` | Readiness package confirming 3-PLAN can begin |

## Pre-Flight Checklist

- [ ] `learn-input-3-DA.md` exists and is validated (scope locked)
- [ ] Pipeline constraints from DP-LEARN received — analytical questions mapped to the problem (not the available data)
- [ ] Research domains confirmed: analytical methods (descriptive/predictive/prescriptive), bias risks, statistical validation approaches, insight quality criteria, method-to-question mapping, tooling capabilities
- [ ] Bias risks identified per method — mitigation approaches researched and documented
- [ ] All P0–P5 pages have `status: validated` (human-reviewed via `/learn:review`)
- [ ] `vana-spec.md` exists with analytical constraints derived from evidence
- [ ] `DSBV-READY-3-DA.md` confirms 3-PLAN/3-DA can begin

## Templates

| Pipeline Stage | Template | Location |
|---------------|----------|----------|
| S1 — Scope | `learn-input-template.md` | `../../_genesis/templates/learn-input-template.md` |
| S2 — Research | `research-template.md` | `../../_genesis/templates/research-template.md` |
| S5 — Spec | `vana-spec-template.md` | `../../_genesis/templates/vana-spec-template.md` |

## Links

- [[SKILL]]
- [[methodology]]
- [[workstream]]
