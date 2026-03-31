---
version: "1.0"
status: Active
last_updated: 2026-03-30
owner: Long Nguyen
---

# CHANGELOG

---

## [Unreleased]
### Added
- [T1:REPLACE] `_genesis/` knowledge base hierarchy (13 MECE categories, renamed from `_shared/`)
- [T1:REPLACE] `.claude/skills/` consolidated skill system (26 skills in 11 groupings)
- [T3:ADD-ONLY] Learning pipeline: 6+1 skills (`/learn` → `/learn-input` → `/learn-research` → `/learn-structure` → `/learn-review` → `/learn-spec` → `/learn-visualize`)
- [T3:ADD-ONLY] `.claude/hooks/` event-driven automation (7 scripts)
- [T3:ADD-ONLY] `_genesis/reference/ltc-ai-agent-system-project-template-guide.md` v2.0 user guide
- [T3:ADD-ONLY] `.claude/rules/versioning.md` always-loaded versioning rule
- [T3:ADD-ONLY] `.claude/hooks/validate-frontmatter.sh` pre-commit versioning gate
- [T3:ADD-ONLY] `1-ALIGN/learning/` zone with full DSBV artifacts
- [T3:ADD-ONLY] `_genesis/templates/DESIGN_TEMPLATE.md` standard design template
- [T3:ADD-ONLY] `_genesis/templates/DSBV_PROCESS.md` enhanced with scope check, execution strategy, agent catalog
### Changed
- [T1:REPLACE] `_shared/` → `_genesis/` (renamed for clarity)
- [T1:REPLACE] All `_genesis/reference/` files renamed to `ltc-{kebab-case}` convention
- [T1:REPLACE] `CLAUDE.md` updated: all `_shared/` refs → `_genesis/`, skill paths, EOP-GOV path
- [T1:REPLACE] `README.md` updated: file tree, safety model, learning pipeline docs
- [T2:ENHANCE] `_genesis/templates/DSBV_PROCESS.md` enhanced with agent catalog and git lifecycle
- [T2:ENHANCE] All 24 skill/rule files updated with `_genesis/` references
### Fixed
- [T4:FIX] 21 active files: stale `_shared/` path references → `_genesis/` (PR #6 review Issue 1)
- [T4:FIX] Python 3.9 compat: `X | None` → `Optional[X]` in `run-deterministic-evals.py` and `test_validate_ac_results.py`
- [T4:FIX] `test_wms_sync.py` SCRIPTS_DIR path updated from `_shared/` to `_genesis/scripts/wms-sync/`
### Removed
- [T1:REPLACE] `docs/` directory dissolved (content moved to `1-ALIGN/learning/research/` and `_genesis/reference/`)
- [T1:REPLACE] `plugins/` directory dissolved (hooks → `.claude/hooks/`, scripts → `scripts/`)
- [T1:REPLACE] Zone-level `learning/` folders in zones 2-4 (consolidated to zone 1 only)
- [T1:REPLACE] 91 stale files from old structure
- [T1:REPLACE] `archive/archive/` nesting flattened

---

## [1.0.0] — 2026-03-26 — I0 Scaffold
### Added
- [T1:REPLACE] 5×4 APEI zone structure (`1-ALIGN/`, `2-PLAN/`, `3-EXECUTE/`, `4-IMPROVE/`, `_shared/`)
- [T1:REPLACE] Agent governance: `CLAUDE.md`, `GEMINI.md`, 6 canonical rules in `rules/`
- [T1:REPLACE] `.claude/` config: hooks (post-exec-write, pre-spec-write, session-start-comments), skills symlinks
- [T3:ADD-ONLY] 6 skills zone-scoped: ltc-brainstorming (Z1), ltc-execution-planner + ltc-writing-plans (Z2), ltc-task-executor (Z3), ltc-clickup-planner + ltc-notion-planner (_shared)
- [T3:ADD-ONLY] 11 templates in `_shared/templates/` (ADR, Research, Retro, Review, Risk, SOP, Spike, Standup, Wiki, VANA-Spec, Review-Package)
- [T3:ADD-ONLY] 10 framework pointers in `_shared/frameworks/` (SSOT thin wrappers)
- [T3:ADD-ONLY] Learning pipeline in `1-ALIGN/learning/` (9 sub-dirs: config, input, output, references, research, scripts, skills, specs, templates)
- [T3:ADD-ONLY] Charter templates: `PROJECT_CHARTER.md`, `STAKEHOLDERS.md`, `REQUIREMENTS.md`
- [T3:ADD-ONLY] Risk/driver registers: `UBS_REGISTER.md`, `UDS_REGISTER.md`, `ASSUMPTIONS.md`, `MITIGATIONS.md`, `LEVERAGE_PLAN.md`
- [T3:ADD-ONLY] Roadmap scaffolding: `MASTER_PLAN.md`, `EXECUTION_PLAN.md`, `DEPENDENCIES.md`
- [T3:ADD-ONLY] Quality gates: 6 stage validators in `3-EXECUTE/tests/quality-gates/`
- [T3:ADD-ONLY] Distribution system: `VERSION`, `scripts/template-check.sh`, `scripts/release-pr.sh`, `.templateignore`
- [T3:ADD-ONLY] Brand assets: `_shared/brand/` (5 sub-dirs), `rules/brand-identity.md`
- [T3:ADD-ONLY] Security framework: `_shared/security/` (5 sub-dirs), `rules/security-rules.md`
- [T3:ADD-ONLY] WMS sync scripts: `_shared/scripts/wms-sync/` (pull-comments, sync-to-clickup, sync-to-notion)

---

## Versioning Convention
- **Major (X.0.0):** Breaking changes, structural reorganization
- **Minor (0.X.0):** New features, templates, or capabilities
- **Patch (0.0.X):** Bug fixes, documentation updates

## How to Propose Changes
1. Identify the improvement in a retrospective (`4-IMPROVE/retrospectives/`)
2. Document the rationale (which pillar does it improve? which UBS does it mitigate?)
3. Implement via Grounding → Sustaining pattern (O-17)
4. Update this CHANGELOG
