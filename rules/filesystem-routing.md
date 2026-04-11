# Filesystem Routing — Always-On Rule

# version: 2.2 | status: draft | last_updated: 2026-04-11

Full spec: `_genesis/filesystem-blueprint.md`

## Structure: 3 Layers (Docs) / 4 Layers (Code)

```
L1: Workstream     1-ALIGN | 2-LEARN | 3-PLAN | 4-EXECUTE | 5-IMPROVE
L2: Subsystem      1-PD | 2-DP | 3-DA | 4-IDM | _cross
L3 (docs):         {sub}-{name}.md (files land here)
L3 (EXECUTE code): src | tests | config | notebooks | docs
L4 (EXECUTE code): actual files
```

## Before Creating Any File

1. Identify workstream (which ALPEI workstream?) → L1
2. Identify subsystem (which domain?) → L2. Use `_cross` if spans subsystems.
3. Build filename with subsystem prefix: `{sub}-{name}.md`
4. For EXECUTE code: add L3 type folder (src/tests/config/notebooks/docs)

## Routing Table

| Artifact | Workstream | Path | Name pattern |
|----------|-----------|------|-------------|
| Charter | ALIGN | `1-ALIGN/{N}-{SUB}/` | `{sub}-charter.md` |
| Decision / ADR | ALIGN | `1-ALIGN/{N}-{SUB}/` | `{sub}-decision-adr-{NNN}.md` |
| OKR | ALIGN | `1-ALIGN/{N}-{SUB}/` | `{sub}-okr-{period}.md` |
| Stakeholder map | ALIGN | `1-ALIGN/_cross/` | `cross-stakeholder-map.md` |
| RACI | ALIGN | `1-ALIGN/_cross/` | `cross-stakeholder-raci.md` |
| UBS analysis | LEARN | `2-LEARN/{N}-{SUB}/` | `{sub}-ubs-analysis.md` |
| UDS analysis | LEARN | `2-LEARN/{N}-{SUB}/` | `{sub}-uds-analysis.md` |
| Research spec | LEARN | `2-LEARN/{N}-{SUB}/` | `{sub}-research-spec.md` |
| Effective Principles | LEARN | `2-LEARN/{N}-{SUB}/` | `{sub}-effective-principles.md` |
| Literature review | LEARN | `2-LEARN/{N}-{SUB}/` | `{sub}-literature-review.md` |
| Architecture | PLAN | `3-PLAN/{N}-{SUB}/` | `{sub}-architecture.md` |
| Risk register | PLAN | `3-PLAN/{N}-{SUB}/` | `{sub}-risk-register.md` |
| Driver register | PLAN | `3-PLAN/{N}-{SUB}/` | `{sub}-driver-register.md` |
| Roadmap | PLAN | `3-PLAN/{N}-{SUB}/` | `{sub}-roadmap.md` |
| Dependency map | PLAN | `3-PLAN/_cross/` | `cross-dependency-map.md` |
| Blueprint / spec | PLAN | `3-PLAN/_cross/` | `{topic}-blueprint.md` |
| Source code | EXECUTE | `4-EXECUTE/{N}-{SUB}/src/` | `{name}.py` (snake_case) |
| SQL models | EXECUTE | `4-EXECUTE/{N}-{SUB}/src/` | `{name}.sql` |
| Tests | EXECUTE | `4-EXECUTE/{N}-{SUB}/tests/` | `test_{name}.py` |
| Config | EXECUTE | `4-EXECUTE/{N}-{SUB}/config/` | `{name}.yaml` or `{name}.json` |
| Notebooks | EXECUTE | `4-EXECUTE/{N}-{SUB}/notebooks/` | `{name}.ipynb` |
| Tech docs | EXECUTE | `4-EXECUTE/{N}-{SUB}/docs/` | `{name}.md` |
| Changelog | IMPROVE | `5-IMPROVE/{N}-{SUB}/` | `{sub}-changelog.md` |
| Retrospective | IMPROVE | `5-IMPROVE/{N}-{SUB}/` | `{sub}-retro-{id}.md` |
| Metrics | IMPROVE | `5-IMPROVE/{N}-{SUB}/` | `{sub}-metrics.md` |
| Feedback register | IMPROVE | `5-IMPROVE/_cross/` | `cross-feedback-register.md` |

## Substitution

- `{N}` = subsystem number (1-4)
- `{SUB}` = subsystem code, UPPERCASE in folder, lowercase in filename
- `{sub}` = lowercase subsystem code (pd, dp, da, idm, cross)
- `{name}` = descriptive kebab-case name
- `{NNN}` = zero-padded sequential number (001, 002, ...)
- `{period}` = time period (q1, q2, h1, fy2026)
- `{id}` = identifier (sprint-1, sprint-2, ...)

## Default Subsystems (UE / Investment)

| # | Code | Full name | Domain |
|---|------|-----------|--------|
| 1 | PD | Problem Diagnosis | Principles, alignment, problem framing |
| 2 | DP | Data Pipeline | Data ingestion, processing, storage |
| 3 | DA | Data Analysis | Analytics, ML models, insights extraction |
| 4 | IDM | Insights & Decision Making | Dashboards, decision support, governance |

Subsystems are swappable per functional area. After swapping, update this table.

## DSBV Stage File Locations (Mode A canonical rule)

DSBV control files are placed at different levels depending on their scope:

| File | Level | Path pattern | Rationale |
|------|-------|-------------|-----------|
| `DESIGN.md` | Subsystem | `{N}-{WS}/{N}-{SUB}/DESIGN.md` | Scopes design to one subsystem |
| `SEQUENCE.md` | Subsystem | `{N}-{WS}/{N}-{SUB}/SEQUENCE.md` | Scopes build tasks to one subsystem |
| `VALIDATE.md` | **Workstream root** | `{N}-{WS}/VALIDATE.md` | One per workstream — certifies the full workstream gate |

`VALIDATE.md` is intentionally at workstream root, not subsystem level. It is a workstream-level gate that certifies the entire workstream is ready to advance. There is exactly one `VALIDATE.md` per workstream (e.g., `1-ALIGN/VALIDATE.md`, `3-PLAN/VALIDATE.md`), not one per subsystem.

## Forbidden

- NEVER create files outside the routing table without human approval
- NEVER use dots or spaces in folder names
- NEVER create iteration or DSBV stage folders (use frontmatter)
- NEVER put documents in EXECUTE's src/tests/config/ (those are for code)
- NEVER put code in non-EXECUTE workstreams (1-ALIGN through 3-PLAN and 5-IMPROVE are documents only)

## Links

- [[BLUEPRINT]]
- [[CHANGELOG]]
- [[adr]]
- [[architecture]]
- [[charter]]
- [[cross-dependency-map]]
- [[cross-feedback-register]]
- [[cross-stakeholder-map]]
- [[cross-stakeholder-raci]]
- [[filesystem-blueprint]]
- [[iteration]]
- [[okr]]
- [[roadmap]]
- [[workstream]]
