---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 1-ALIGN
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | ALIGN Workstream

> "If IDM alignment is not locked, insight delivery will be built for what's easy to present, not what drives decisions."

IDM-Align scopes the insight delivery effort — which roles receive which insights, in what format, and what constitutes a good decision outcome. It is the final subsystem in the ALIGN cascade, inheriting principles from all upstream.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [(workstream output)]
```

Receives from upstream: da-charter.md + insight quality SLAs from 3-DA; Effective Principles from 1-PD; data quality SLAs from 2-DP.
Produces for downstream: idm-charter.md + delivery SLAs — feeds 2-LEARN/4-IDM as research scope; closes the ALIGN cascade.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| idm-charter.md | `idm-charter.md` | Delivery scope: target roles, formats, decision support criteria |
| idm-okr.md | `idm-okr.md` | Delivery success criteria per version |
| ADR-NNN_*.md | `ADR-NNN_{slug}.md` | Delivery tooling and format decisions |
| DESIGN.md | `DESIGN.md` | DSBV Design stage for IDM alignment |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence for IDM alignment work order |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |

## Pre-Flight Checklist

- [ ] All upstream charters received (pd-charter.md, dp-charter.md, da-charter.md)
- [ ] Target decision-makers identified with their decision context
- [ ] Delivery format agreed — dashboard, report, alert, or hybrid
- [ ] idm-charter.md reviewed against all upstream Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| idm-charter.md | `charter-template.md` | `../../_genesis/templates/charter-template.md` |
| idm-okr.md | `okr-template.md` | `../../_genesis/templates/okr-template.md` |
| ADR-NNN_*.md | `adr-template.md` | `../../_genesis/templates/adr-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
