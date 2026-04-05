---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 1-ALIGN
stage: build
type: template
sub_system: 2-DP
iteration: 2
---

# 2-DP — Data Pipeline | ALIGN Workstream

Alignment artifacts for the Data Pipeline subsystem: charter, OKRs, and decisions that define what data DP must acquire, move, and make available. DP scope is constrained by PD's effective principles — DP cannot collect data outside PD's defined problem boundary.

## Cascade Position

```
[1-PD] ──► [2-DP] ──► [3-DA] ──► [4-IDM]
              ↑
              Receives PD scope constraints. Produces data availability guarantees for DA.
```

Receives from upstream: PD effective principles, PD scope boundaries (`1-ALIGN/1-PD/`).
Produces for downstream: DP data availability commitments, pipeline SLAs, source decisions — consumed by DA as input assumptions.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DP Charter | `dp-charter.md` | Purpose, scope, data sources, success criteria for DP |
| DP OKR Register | `dp-okr.md` | Objectives and key results scoped to DP |
| DP Decisions | `ADR-{id}_{slug}.md` | Source selection, pipeline architecture decisions |
| DP Principles | `dp-principles.md` | Data quality, freshness, and access principles for DA/IDM |
