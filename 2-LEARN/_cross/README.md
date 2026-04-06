---
version: "2.2"
status: draft
last_updated: 2026-04-06
work_stream: 2-LEARN
sub_system: _cross
type: template
iteration: 2
---

# _cross — Cross-Cutting | LEARN Workstream

> "Without shared pipeline infrastructure — templates, reference sources, and shared scripts — each subsystem reinvents its own collection and formatting conventions, producing outputs that cannot be compared or merged."

`_cross` holds the shared scaffolding that all four LEARN subsystems (PD, DP, DA, IDM) draw from: reference libraries, reusable templates, shared scripts, and pipeline configuration. These are not owned by any one subsystem but must remain consistent across all of them.

## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the LEARN workstream. They cannot be owned by a single subsystem — they govern or support all of them.

In LEARN specifically, cross-cutting means shared pipeline infrastructure. A source format standard, a citation template, or a shared extraction script affects every subsystem equally — placing it in any single subsystem directory would make it invisible to the others or create drift between copies.

```
                        _cross
                     (shared infra)
                    ┌─────┴─────┐
                    │           │
              ┌─────┴──┐   ┌───┴────┐
            1-PD      2-DP  3-DA   4-IDM
         (all draw from _cross templates, scripts, references)
```

## Contents

| Directory | Purpose |
|-----------|---------|
| `references/` | Shared bibliography and source registry used across all four subsystems |
| `templates/` | Artifact templates (research spec, literature review, etc.) shared across subsystems |
| `scripts/` | Automation scripts for ingestion, formatting, or extraction used across the pipeline |
| `config/` | Configuration files governing pipeline behavior across all subsystems |

## Pre-Flight Checklist

- [ ] Shared templates in `templates/` are current — subsystem-specific templates derive from these, not diverge
- [ ] Pipeline scripts in `scripts/` are tested and documented before any subsystem depends on them
- [ ] Reference library in `references/` is consistent with sources cited in all four subsystems
- [ ] No subsystem has a local copy of a `_cross` artifact — single source of truth enforced
- [ ] Config changes are backward-compatible with all four subsystems before merging
