---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 2-LEARN
sub_system: _cross
type: template
iteration: 1
---

# _cross — Cross-Cutting | LEARN Workstream

> "If the shared research infrastructure is missing or inconsistent, each subsystem reinvents its own conventions — producing research that cannot be compared, combined, or trusted as a coherent whole."

Cross-cutting LEARN artifacts support all 4 subsystem research pipelines. They cannot be owned by one subsystem — they provide shared infrastructure (learn-input files, research outputs, methodology) that all pipeline stages consume.

## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the LEARN pipeline.
These cannot be owned by a single subsystem — they govern or support all of them.

In the LEARN pipeline context, cross-cutting means: scope definitions (learn-input files) that each subsystem reads before starting S1, research files that multiple subsystems reference, and methodology standards that ensure all research meets the same citation and quality bar. Scripts that validate pipeline state across all subsystems also live here.

## What _cross Contains

`_cross/` is shared infrastructure for all LEARN subsystem pipelines. It does not run its own pipeline — it hosts artifacts consumed by PD, DP, DA, and IDM research cycles.

| Directory/Artifact | Purpose |
|-------------------|---------|
| `input/` | Staging area for all subsystem learn-input files (`learn-input-{slug}.md`) |
| `research/{slug}/` | Deep research output per system slug — one subdirectory per active subsystem |
| `research-methodology.md` | Shared methodology: citation rules, source evaluation, anti-hallucination standards |
| `scripts/` | Pipeline utility scripts shared across subsystems |

## Contents

| Artifact | Location | Purpose |
|----------|----------|---------|
| `learn-input-{slug}.md` | `_cross/input/` | Research scope definition per subsystem — input to `/learn:research` |
| `T{n}-{topic}.md` | `_cross/research/{slug}/` | Deep research files per topic (cited, structured, 6-section format) |
| `research-methodology.md` | `_cross/` | Shared research standards — citation rules, source evaluation, anti-hallucination |

## Pre-Flight Checklist

- [ ] `learn-input-*.md` files exist for each active subsystem (PD, DP, DA, IDM)
- [ ] Research methodology (`research-methodology.md`) exists and has been shared with all subsystem researchers
- [ ] Research files in `_cross/research/` have `status: completed` (not partial)
- [ ] No research file is empty or under 2000 characters
- [ ] Methodology applied consistently across all research topics — citation format and source evaluation uniform

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| learn-input-{slug}.md | `learn-input-template.md` | `../../_genesis/templates/learn-input-template.md` |
| T{n}-{topic}.md | `research-template.md` | `../../_genesis/templates/research-template.md` |

## Links

- [[SKILL]]
- [[methodology]]
- [[workstream]]
