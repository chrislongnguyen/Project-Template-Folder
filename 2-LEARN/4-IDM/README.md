---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 2-LEARN
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | LEARN Workstream

> "If IDM research skips adoption risks, insights will be delivered in formats that impress stakeholders but don't change decisions."

IDM-LEARN researches insight delivery formats, adoption barriers, decision-maker context, and feedback loop design. It closes the LEARN cascade — its Effective Principles govern how 4-EXECUTE builds the delivery layer.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [(LEARN complete → 3-PLAN)]
                          ↑
     Anchors on: all upstream Effective Principles (PD + DP + DA) — defines delivery
     constraints that are real, not aspirational
```

Receives from upstream: `2-LEARN/3-DA/specs/vana-spec.md` (analytical constraints) + all upstream Effective Principles from PD and DP.
Produces for downstream: vana-spec.md with delivery constraints + DSBV-READY-idm.md — consumed by 3-PLAN/4-IDM to begin planning; closes the 2-LEARN cascade and unlocks 3-PLAN for all subsystems.

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
| `learn-input-4-IDM.md` | `_cross/input/` | Research scope definition for this subsystem |
| `T{n}-{topic}.md` | `_cross/research/4-IDM/` | Deep research per topic (cited, structured) |
| `T0.P{m}-{slug}.md` | `output/` | P0–P5 structured learning pages |
| `vana-spec.md` | `specs/` | Extracted Effective Principles — primary output |
| `DSBV-READY-4-IDM.md` | `specs/` | Readiness package confirming 3-PLAN can begin |

## Pre-Flight Checklist

- [ ] `learn-input-4-IDM.md` exists and is validated (scope locked)
- [ ] All upstream Effective Principles received (PD, DP, DA) — delivery constraints grounded in upstream realities
- [ ] Research domains confirmed: delivery formats (dashboard, report, alert, API), adoption barriers, decision-maker cognitive load, feedback loop design, change management requirements
- [ ] Target decision-makers researched — their context and constraints understood; adoption barriers identified (not assumed away)
- [ ] All P0–P5 pages have `status: validated` (human-reviewed via `/learn:review`)
- [ ] `vana-spec.md` exists with delivery constraints derived from evidence
- [ ] `DSBV-READY-4-IDM.md` confirms 3-PLAN/4-IDM can begin; 2-LEARN cascade is closed

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
