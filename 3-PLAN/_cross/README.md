---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 3-PLAN
sub_system: _cross
type: template
iteration: 1
---

# _cross — Cross-Cutting | PLAN Workstream

> "A risk that lives in one subsystem's register but affects all subsystems is not a subsystem risk — it is a project risk, and it belongs here."

Cross-cutting PLAN artifacts govern all 4 subsystems simultaneously. The project-wide UBS/UDS registers aggregate all subsystem risks into a single prioritized view. BLUEPRINT.md defines the filesystem and data architecture that all subsystems share. These cannot be owned by one subsystem.

## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the PLAN workstream.
These cannot be owned by a single subsystem — they govern or support all of them.

Cross-cutting means the artifact either aggregates information from all subsystems (UBS/UDS registers, BLUEPRINT.md) or records decisions that constrain multiple subsystems simultaneously (ADRs). Any conflict between a subsystem artifact and a cross-cutting artifact must be resolved at the _cross level.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| UBS_REGISTER.md | `UBS_REGISTER.md` | Project-wide blocking force register — aggregated from all subsystem risk registers |
| UDS_REGISTER.md | `UDS_REGISTER.md` | Project-wide driving force register — aggregated success enablers |
| BLUEPRINT.md | `BLUEPRINT.md` | Filesystem and data architecture blueprint — shared schema for all subsystems |
| ADR-NNN_*.md | `ADR-NNN_{slug}.md` | Cross-cutting architectural decisions affecting multiple subsystems |

## Pre-Flight Checklist

- [ ] All subsystem risk registers merged into UBS_REGISTER.md — no duplicate entries
- [ ] BLUEPRINT.md reflects agreed filesystem structure — no subsystem contradicts it
- [ ] No cross-cutting risk is owned by a single subsystem without explicit rationale
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| UBS_REGISTER.md | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| UDS_REGISTER.md | `driver-entry-template.md` | `../../_genesis/templates/driver-entry-template.md` |
| ADR-NNN_*.md | `adr-template.md` | `../../_genesis/templates/adr-template.md` |
| cross-dependency-map.md | `force-analysis-template.md` | `../../_genesis/templates/force-analysis-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
