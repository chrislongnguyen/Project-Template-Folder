---
date: "2026-04-09"
type: capture
source: conversation
tags: [naming, subsystem, architecture, decision]
---

# Subsystem Cascading Renumber Analysis

## Decision: REJECTED

Proposed changing subsystem numbering from flat (`1-ALIGN/1-PD`) to cascading (`1-ALIGN/1-1-PD`, `2-LEARN/2-1-PD`). Full blast radius analysis below.

## Blast Radius Summary

| Layer | Count | Detail |
|-------|-------|--------|
| Physical directories to rename | 20 | 4 subsystems × 5 workstreams |
| Files that change path | 132 | All files inside subsystem dirs |
| Unique files with text references | 186 | Across all file types |
| Total text occurrences | ~506 | Path refs, frontmatter, scripts, docs |
| Scripts requiring logic rewrites | 8 | 71 occurrences (not just find-replace — loop logic changes) |
| Obsidian Bases configs | 11 | 51 `sub_system` field references |
| Templater templates | 10 | Enum values in suggester prompts |
| Training deck TSX files | 8 | 15 compiled React slide references |
| Genesis structural docs | 28 | 93 occurrences (BLUEPRINT, filesystem-blueprint, cross-dep map) |
| Downstream repos affected | 8 | All ALPEI-structured LTC repos |

## Key Scripts Affected

| Script | Refs | Complexity |
|--------|------|-----------|
| `cleanup-wip.py` | 24 | Hardcoded arrays + path construction |
| `populate-blueprint.py` | 21 | Path generation logic |
| `generate-readmes.py` | 11 | Directory traversal patterns |
| `readiness-report.sh` | 4 | |
| `iteration-bump.sh` | 4 | |
| `bulk-validate.sh` | 3 | |
| `validate-blueprint.py` | 3 | |
| `generate-registry.sh` | 1 | |

## Semantic Explosion: 4 Names → 20

Current: `sub_system: 1-PD` (same everywhere, cross-workstream queryable).
After: 20 unique values (`1-1-PD`, `2-1-PD`, `3-1-PD`, `4-1-PD`, `5-1-PD` × 4 subsystems).

Obsidian Bases cross-workstream queries break — `sub_system = 1-PD` (all PD work) becomes a 5-value OR clause. Would likely require adding a `base_subsystem` field to recover current query power — meaning 2 subsystem fields per file.

## Effort Estimate

| Task | Agent | Human |
|------|-------|-------|
| Directory renames | 10 min | Review |
| File path updates (132 files) | Auto via git mv | Review |
| Text reference updates (506 occ, 186 files) | 60-90 min | Spot-check |
| Script logic rewrites (8 scripts) | 2-3 hours | Test each |
| Obsidian Bases reconfig (11 bases) | 1-2 hours | Test in Obsidian |
| Templater + training deck | 1 hour | Rebuild + visual check |
| Genesis structural docs | 1 hour | Review |
| Downstream repo migration (8 repos) | 4-8 hours | Coordinate |
| Testing + validation | 2 hours | Full smoke test |
| **Total** | **12-18h agent** | **4-6h human** |

## Cobra Check

🐍 **Reinforcing (bad):** Cascading numbers create compound naming tax — every new artifact/script/Base must encode workstream-subsystem pair.
**Cobra risk: YES** — fix breeds a new problem: `sub_system` field loses cross-workstream query power. Recovery requires a second field (`base_subsystem`), doubling maintenance.

## Why Current Scheme Is Sufficient

The parent directory already provides workstream context: `1-ALIGN/1-PD` is unambiguous. The `work_stream` frontmatter field (already present on all artifacts) handles the "which workstream?" query. Cascading numbers encode redundant information at massive cost.
