---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 2-LEARN
sub_system: 2-DP
type: template
iteration: 1
---

# 2-DP — Data Pipeline | LEARN Workstream

> "If DP research skips source quality risks, the pipeline will be architected for the best-case data — and reality will break it."

DP-LEARN researches data source availability, quality risks, transformation constraints, and pipeline failure modes. It uses PD Effective Principles as a filter — only data paths that serve the PD-scoped problem are in scope.

## Cascade Position

```
[1-PD (Problem Diagnosis)]  ──►  [2-DP]  ──►  [3-DA (Data Analysis)]
                          ↑
     Anchors on: PD Effective Principles (vana-spec.md) — defines which data paths are in scope
```

Receives from upstream: `2-LEARN/1-PD/specs/vana-spec.md` (Effective Principles as research bounds) + `1-ALIGN/2-DP/dp-charter.md` (data pipeline charter).
Produces for downstream: vana-spec.md with pipeline constraints + validated data spec — consumed by 2-LEARN/3-DA as analytical method bounds, and by 3-PLAN/2-DP as the DSBV-READY package that unlocks planning.

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
| `learn-input-2-DP.md` | `_cross/input/` | Research scope definition for this subsystem |
| `T{n}-{topic}.md` | `_cross/research/2-DP/` | Deep research per topic (cited, structured) |
| `T0.P{m}-{slug}.md` | `output/` | P0–P5 structured learning pages |
| `vana-spec.md` | `specs/` | Extracted Effective Principles — primary output |
| `DSBV-READY-2-DP.md` | `specs/` | Readiness package confirming 3-PLAN can begin |

## Pre-Flight Checklist

- [ ] `learn-input-2-DP.md` exists and is validated (scope locked)
- [ ] Effective Principles from PD-LEARN received and understood — used as filter for data scope
- [ ] Research domains confirmed: data source availability, access rights, data quality (completeness, accuracy, timeliness), transformation complexity, pipeline failure modes, infrastructure constraints
- [ ] Data sources enumerated: available, restricted, unknown — quality risks identified per source (not assumed OK)
- [ ] All P0–P5 pages have `status: validated` (human-reviewed via `/learn:review`)
- [ ] `vana-spec.md` exists with pipeline constraints derived from evidence
- [ ] `DSBV-READY-2-DP.md` confirms 3-PLAN/2-DP can begin

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
