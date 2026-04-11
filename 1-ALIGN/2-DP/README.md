---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 1-ALIGN
sub_system: 2-DP
type: template
iteration: 1
---

# 2-DP — Data Pipeline | ALIGN Workstream

> "Without a scoped data pipeline alignment, DP will build what's technically feasible rather than what the problem requires."

DP-Align defines the boundary of the data pipeline effort — which data sources, types, transformations, and quality standards are in scope. It inherits the Effective Principles from PD-Align as non-negotiable constraints.

## Cascade Position

```
[1-PD (Problem Diagnosis)]  ──►  [2-DP]  ──►  [3-DA (Data Analysis)]
```

Receives from upstream: pd-charter.md + Effective Principles from 1-PD (hard constraints on data scope).
Produces for downstream: dp-charter.md + data quality SLAs — consumed by 3-DA as pipeline boundary constraints; also feeds 2-LEARN/2-DP as research scope.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| dp-charter.md | `dp-charter.md` | Data pipeline scope: sources, formats, transformations in/out of scope |
| dp-okr.md | `dp-okr.md` | Data pipeline success criteria per version |
| ADR-NNN_*.md | `ADR-NNN_{slug}.md` | Pipeline architecture decisions |
| DESIGN.md | `DESIGN.md` | DSBV Design stage for DP alignment |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence for DP alignment work order |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |

## Pre-Flight Checklist

- [ ] pd-charter.md received and Effective Principles understood
- [ ] Data source inventory documented (available, inaccessible, unknown)
- [ ] Data quality SLAs defined per source
- [ ] dp-charter.md reviewed against PD Effective Principles — no contradictions
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| dp-charter.md | `charter-template.md` | `../../_genesis/templates/charter-template.md` |
| dp-okr.md | `okr-template.md` | `../../_genesis/templates/okr-template.md` |
| ADR-NNN_*.md | `adr-template.md` | `../../_genesis/templates/adr-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
