---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 4-EXECUTE
stage: build
type: template
sub_system: 4-IDM
iteration: 2
---

# 4-EXECUTE / 4-IDM — Insights & Decision-Making Execution

Dashboard code, reporting generators, alert systems, and decision support tools that surface analytical outputs to decision-makers. Operationalizes the IDM design in 3-PLAN/4-IDM.

## Cascade Position

Depends on:
- `3-PLAN/4-IDM/` — reporting requirements, decision workflows, alert thresholds
- `4-EXECUTE/3-DA/` — analysis outputs as inputs

Feeds into:
- `5-IMPROVE/` — usage metrics, decision outcomes, and feedback loops

## Contents

| Directory | Contains | Examples |
|-----------|----------|---------|
| `src/` | Source code | Dashboard components, report generators, alert dispatchers, decision support logic |
| `tests/` | Test files | UI unit tests, report output validators, alert trigger tests |
| `config/` | Configuration | Dashboard layout configs, alert threshold definitions, distribution lists |
| `docs/` | Technical docs | Dashboard user guide, report schema, alert runbook |
