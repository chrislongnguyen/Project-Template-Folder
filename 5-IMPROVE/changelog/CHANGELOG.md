---
version: "1.1"
status: draft
last_updated: 2026-04-03
---

# CHANGELOG

## [I2 — Prototype] 2026-04-03 — _genesis/ Cleanup + Blueprint Restructure

**Branch:** `I2/chore/genesis-blueprint-cleanup`

### Changed
- Blueprint relocated from `1-ALIGN/charter/BLUEPRINT.md` → `_genesis/BLUEPRINT.md` (bedrock, not iteration-scoped)
- Blueprint restructured: Part 3 Operating Model (new), Part 5 rewritten as VANA+ACs (71 lines, down from ~175), Decisions section removed
- 9 ALL_CAPS framework files renamed to kebab-case (content-free rename commits for merge-friendly history)
- 3 existing rules enhanced (+11 lines total): VANA gate in `dsbv.md`, sub-system sequence in `alpei-chain-of-custody.md`, version awareness in `versioning.md`
- `APEI` → `ALPEI` typo fixed in `dsbv.md` (line 9) and `CLAUDE.md` (line 17)

### Removed / Archived
- 6 ALL_CAPS framework duplicates archived to `_genesis/frameworks/archive/`
- `UES_VERSION_BEHAVIORS.md` deleted (exact duplicate of `ltc-ues-version-behaviors.md`)
- `sops/ALPEI_OPERATING_PROCEDURE.md` archived to `sops/archive/` (self-marked DEPRECATED)

---

## [I1 — Concept] 2026-04-01

**Theme: Sustainability** — human adoption first, agent efficiency second.

### Added
- [T1:REPLACE] 5 ALPEI workstreams (ALIGN → LEARN → PLAN → EXECUTE → IMPROVE) with folder scaffolding
- [T1:REPLACE] DSBV sub-process (Design → Sequence → Build → Validate) with skill, rules, and templates
- [T1:REPLACE] 4 MECE agents: ltc-planner (Opus), ltc-builder (Sonnet), ltc-reviewer (Opus), ltc-explorer (Haiku)
- [T1:REPLACE] Chain-of-custody rule — workstream N cannot build until workstream N-1 has validated artifacts
- [T1:REPLACE] Pre-flight protocol — 7 checks before any task
- [T3:ADD-ONLY] Learning pipeline: 6+1 skills (`/learn` → `/learn-input` → `/learn-research` → `/learn-structure` → `/learn-review` → `/learn-spec` → `/learn-visualize`)
- [T3:ADD-ONLY] ALPEI Navigator — interactive HTML system map (`_genesis/tools/alpei-navigator.html`)
- [T3:ADD-ONLY] Training slide deck — 47 slides in `_genesis/training/alpei-training-slides/`
- [T3:ADD-ONLY] Migration guide (I0 → I1) in `_genesis/guides/MIGRATION_GUIDE.md`
- [T3:ADD-ONLY] ALPEI-DSBV Process Map — 4 views (P1-P4) in `_genesis/frameworks/`
- [T3:ADD-ONLY] 18 templates for DSBV phases, VANA specs, ADRs, architecture, and more
- [T3:ADD-ONLY] Effective Agent Principles Registry (12 principles) in `_genesis/reference/`
- [T3:ADD-ONLY] Git workflow SOP with branching strategy in `_genesis/sops/GIT_WORKFLOW.md`
- [T3:ADD-ONLY] `.claude/hooks/` event-driven automation (5 hooks)
- [T3:ADD-ONLY] `rules/` full-spec docs (brand, naming, security, agent system, diagnostics, general system)

### Changed
- [T1:REPLACE] Terminology: "Zone" → "workstream" across all files (~1,400 occurrences)
- [T2:MERGE] `CLAUDE.md` — added workstream structure, DSBV process, pre-flight, version control sections
- [T2:MERGE] `.claude/rules/` — added 6 always-on rules (DSBV, versioning, git conventions, pre-flight, chain-of-custody, memory format)

### Removed
- `0-GOVERN/project-wip/` — leaked project-specific execution artifacts (142 files)
- `4-IMPROVE/` — legacy numbering (IMPROVE is workstream 5, not 4)
- `.github/ISSUE_TEMPLATE/` — feedback skill uses `gh` CLI, not web forms
- `tests/brand-identity/` — test fixtures, not generic template content
- `_genesis/tools/alpei-navigator/` — DSBV draft artifacts (11 files), shipped HTML retained

## [I0 — Scaffold] 2026-03-26

Initial release. Folder structure, CLAUDE.md, safety model, basic rules.

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[GIT_WORKFLOW]]
- [[MIGRATION_GUIDE]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[brand-identity]]
- [[dsbv]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[security]]
- [[task]]
- [[versioning]]
- [[workstream]]