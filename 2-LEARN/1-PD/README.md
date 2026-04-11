---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 2-LEARN
sub_system: 1-PD
type: template
iteration: 1
---

# 1-PD — Problem Diagnosis | LEARN Workstream

> "If PD research is shallow, the Effective Principles will be wrong — and wrong principles make every downstream architecture look right while solving the wrong problem."

PD-LEARN researches the problem space to produce Effective Principles: evidence-backed rules that constrain all downstream subsystems. It is the highest-leverage research task — a principle missed here will not be caught by DP, DA, or IDM research.

## Cascade Position

```
[1-ALIGN (chartered scope)]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
                          ↑
     Anchors on: pd-charter.md (problem statement, research constraints, initial scope)
```

Receives from upstream: `1-ALIGN/1-PD/` → pd-charter.md (problem statement, research constraints, initial scope) + project mandate.
Produces for downstream: vana-spec.md with ≥3 Effective Principles + DSBV-READY-pd.md — consumed by 2-LEARN/2-DP as research bounds, and by 3-PLAN/1-PD as the DSBV-READY package that unlocks planning.

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
| `learn-input-1-PD.md` | `_cross/input/` | Research scope definition for this subsystem |
| `T{n}-{topic}.md` | `_cross/research/1-PD/` | Deep research per topic (cited, structured) |
| `T0.P{m}-{slug}.md` | `output/` | P0–P5 structured learning pages |
| `vana-spec.md` | `specs/` | Extracted Effective Principles — primary output |
| `DSBV-READY-1-PD.md` | `specs/` | Readiness package confirming 3-PLAN can begin |

## Pre-Flight Checklist

- [ ] `learn-input-1-PD.md` exists and is validated (scope locked)
- [ ] Research domains confirmed: UBS analysis (blocking forces), UDS analysis (driving forces), stakeholder context, domain constraints, prior-art failures
- [ ] pd-charter.md received from 1-ALIGN/1-PD — research questions extracted
- [ ] All P0–P5 pages have `status: validated` (human-reviewed via `/learn:review`)
- [ ] `vana-spec.md` exists with ≥3 Effective Principles derived from evidence (not assumptions)
- [ ] `DSBV-READY-1-PD.md` confirms 3-PLAN/1-PD can begin

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
