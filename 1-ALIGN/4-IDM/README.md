---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 1-ALIGN
stage: build
type: template
sub_system: 4-IDM
iteration: 2
---

# 4-IDM — Insights & Decision-Making | ALIGN Workstream

Alignment artifacts for the Insights and Decision-Making subsystem: charter, OKRs, and decisions that define what IDM must surface and enable. IDM is the terminal consumer in the chain — it translates DA analytical outputs into decision-ready formats for human stakeholders. Its scope is bounded by all three upstream subsystems.

## Cascade Position

```
[1-PD] ──► [2-DP] ──► [3-DA] ──► [4-IDM]
                                      ↑
                                      Terminal node. Consumes all upstream outputs. No downstream subsystem.
```

Receives from upstream: PD scope constraints, DP data guarantees, DA output specifications (all via `1-ALIGN/1-PD/`, `1-ALIGN/2-DP/`, `1-ALIGN/3-DA/`).
Produces for downstream: none within the subsystem chain. IDM outputs go to human stakeholders (reports, dashboards, decision memos).

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| IDM Charter | `idm-charter.md` | Purpose, audience, delivery format, success criteria for IDM |
| IDM OKR Register | `idm-okr.md` | Objectives and key results scoped to IDM |
| IDM Decisions | `ADR-{id}_{slug}.md` | Dashboard framework, insight format, delivery channel decisions |
| IDM Stakeholder Outputs | `idm-output-map.md` | Map of which stakeholder receives which IDM output |
