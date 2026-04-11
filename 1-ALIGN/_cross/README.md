---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 1-ALIGN
sub_system: _cross
type: template
iteration: 1
---

# _cross — Cross-Cutting | ALIGN Workstream

> "Without a shared stakeholder map and RACI, every subsystem invents its own accountability model — contradictions emerge at integration."

Cross-cutting ALIGN artifacts span all 4 subsystems (PD, DP, DA, IDM). They define who is accountable (RACI), which stakeholders govern decisions (stakeholder map), and which decisions apply project-wide (cross-cutting ADRs). These cannot be owned by a single subsystem.

## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the ALIGN workstream.
These cannot be owned by a single subsystem — they govern or support all of them.

Cross-cutting means the artifact applies horizontally: a stakeholder map lists every sponsor and reviewer regardless of which subsystem they engage; a cross-cutting ADR records a decision that constrains multiple subsystems simultaneously. Any decision affecting more than one subsystem belongs here, not in a subsystem-level ADR.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| stakeholder-map.md | `stakeholder-map.md` | All project stakeholders, roles, and influence levels |
| RACI.md | `RACI.md` | Responsibility matrix: who is Responsible, Accountable, Consulted, Informed per artifact |
| ADR-NNN_*.md | `ADR-NNN_{slug}.md` | Project-wide decisions affecting multiple subsystems |
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |

## Pre-Flight Checklist

- [ ] All key stakeholders identified and mapped
- [ ] RACI matrix reviewed by sponsor
- [ ] No cross-cutting decisions left undocumented (if a decision affects >1 subsystem, it belongs here)
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| ADR-NNN_*.md | `adr-template.md` | `../../_genesis/templates/adr-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
