---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 1-ALIGN
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | ALIGN Workstream

> "If DA alignment is skipped, analysts will choose methods that fit the data rather than methods that answer the problem."

DA-Align scopes the analytical effort — which questions to answer, which methods are approved, and what insight quality looks like. It receives pipeline constraints from DP-Align and Effective Principles from PD-Align.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
```

Receives from upstream: dp-charter.md + data quality SLAs from 2-DP; Effective Principles from 1-PD.
Produces for downstream: da-charter.md + insight quality SLAs — consumed by 4-IDM as delivery boundary constraints; also feeds 2-LEARN/3-DA as research scope.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| da-charter.md | `da-charter.md` | Analytical scope: approved questions, methods, and insight quality criteria |
| da-okr.md | `da-okr.md` | Analysis success criteria per version |
| ADR-NNN_*.md | `ADR-NNN_{slug}.md` | Methodology and tooling decisions |
| DESIGN.md | `DESIGN.md` | DSBV Design stage for DA alignment |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence for DA alignment work order |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |

## Pre-Flight Checklist

- [ ] dp-charter.md received — data quality SLAs understood
- [ ] Analytical questions scoped to the problem (not the available data)
- [ ] Approved analytical methods listed — bias risks identified
- [ ] da-charter.md reviewed against PD Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| da-charter.md | `charter-template.md` | `../../_genesis/templates/charter-template.md` |
| da-okr.md | `okr-template.md` | `../../_genesis/templates/okr-template.md` |
| ADR-NNN_*.md | `adr-template.md` | `../../_genesis/templates/adr-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
