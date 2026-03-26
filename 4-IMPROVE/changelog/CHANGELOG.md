---
version: "1.0"
status: Active
last_updated: 2026-03-26
owner: Long Nguyen
---

# CHANGELOG

---

## [Unreleased]
### Added
### Changed
### Fixed
### Removed

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
