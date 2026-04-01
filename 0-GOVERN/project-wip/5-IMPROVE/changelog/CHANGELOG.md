---
version: "1.3"
status: Active
last_updated: 2026-03-30
owner: Long Nguyen
---

# CHANGELOG

---

## [Unreleased]

### Multi-Agent Orchestration (feat/multi-agent-orchestration → PR #7)

#### Added
- [T4:ADD] 4 MECE agent files: ltc-planner (Opus), ltc-builder (Sonnet), ltc-reviewer (Opus), ltc-explorer (Haiku) in `.claude/agents/`
- [T4:ADD] 3 governance hooks: SubagentStop (`verify-deliverables.sh`), PreCompact (`save-context-state.sh`), SessionStart (`resume-check.sh`)
- [T4:ADD] Context packaging v2.0 template (`.claude/skills/dsbv/references/context-packaging.md`) — 5-field ESD-grounded sub-agent dispatch
- [T4:ADD] Multi-agent build reference (`.claude/skills/dsbv/references/multi-agent-build.md`) — competing hypotheses pattern
- [T4:ADD] Tool routing rule (`rules/tool-routing.md`) — task→tool mapping with H2 measured data
- [T4:ADD] 3 new Effective Principles: EP-11 (Agent Role Separation), EP-12 (Verified Handoff), EP-13 (Orchestrator Authority)
- [T4:ADD] EP-03 extended: Multi-Agent Extension — 3-layer RACI (Human/Orchestrator/Sub-agent)
- [T4:ADD] ADR-002: Multi-Agent Architecture — evidence-based (H1/H2/H5 test data)
- [T4:ADD] Zone 0 (`0-GOVERN/`) with DSBV artifacts (DESIGN.md, SEQUENCE.md)
- [T4:ADD] Interactive 7-CS visualization (`4-EXECUTE/docs/multi-agent-orchestration-map.html`)
- [T4:ADD] H-test results + eval summary (`5-IMPROVE/metrics/multi-agent-eval/`)

#### Changed
- [T4:ENHANCE] `/dsbv` skill: agent dispatch (ltc-builder for Build, ltc-reviewer for Validate) + context packaging refs
- [T4:ENHANCE] `/ltc-brainstorming`: ltc-explorer for search, ltc-planner for synthesis
- [T4:ENHANCE] `/deep-research`: Exa+WebSearch as peers (per H2), ltc-explorer referenced
- [T4:ENHANCE] `/learn-research`: Exa+WebSearch as peers, ltc-explorer referenced
- [T4:ENHANCE] `agent-system.md`: Card 1 multi-agent scope note, Card 6 agent roster table
- [T4:ENHANCE] `CLAUDE.md`: Zone 0 reference + agent roster line
- [T4:ENHANCE] `.claude/settings.json`: 3 hook event registrations added

#### Deprecated
- [T4:DEPRECATE] `/ltc-execution-planner` → redirect to `/dsbv build`
- [T4:DEPRECATE] `/ltc-writing-plans` → redirect to `/dsbv sequence`

#### Migration Notes
- Agent files in `.claude/agents/` are CLI-only (`claude --agent ltc-builder`). Cannot invoke via `subagent_type` in Agent tool — use `superpowers:code-reviewer` or direct Opus for gate reviews.
- Exa MCP is no longer "preferred" — Exa and WebSearch are peers. Exa for speed, WebSearch for source quality.
- Old skill names still work as aliases but show a deprecation notice.

### Added
- [T1:REPLACE] `_genesis/` knowledge base hierarchy (13 MECE categories, renamed from `_shared/`)
- [T1:REPLACE] `.claude/skills/` consolidated skill system (26 skills in 11 groupings)
- [T3:ADD-ONLY] Learning pipeline: 6+1 skills (`/learn` → `/learn-input` → `/learn-research` → `/learn-structure` → `/learn-review` → `/learn-spec` → `/learn-visualize`)
- [T3:ADD-ONLY] `.claude/hooks/` event-driven automation (7 scripts)
- [T3:ADD-ONLY] `_genesis/reference/ltc-ai-agent-system-project-template-guide.md` v2.0 user guide
- [T3:ADD-ONLY] `.claude/rules/versioning.md` always-loaded versioning rule
- [T3:ADD-ONLY] `.claude/hooks/validate-frontmatter.sh` pre-commit versioning gate
- [T3:ADD-ONLY] `2-LEARN/` zone with full DSBV artifacts (extracted from `1-ALIGN/learning/`)
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
### Removed
- [T1:REPLACE] `docs/` directory dissolved (content moved to `1-ALIGN/learning/research/` and `_genesis/reference/`)
- [T1:REPLACE] `plugins/` directory dissolved (hooks → `.claude/hooks/`, scripts → `scripts/`)
- [T1:REPLACE] Zone-level `learning/` folders in zones 2-4 (consolidated to zone 1 only)
- [T1:REPLACE] 91 stale files from old structure
- [T1:REPLACE] `archive/archive/` nesting flattened

---

## [1.0.0] — 2026-03-26 — I0 Scaffold
### Added
- [T1:REPLACE] 5×4 APEI zone structure (`1-ALIGN/`, `3-PLAN/`, `4-EXECUTE/`, `5-IMPROVE/`, `_shared/`)
- [T1:REPLACE] Agent governance: `CLAUDE.md`, `GEMINI.md`, 6 canonical rules in `rules/`
- [T1:REPLACE] `.claude/` config: hooks (post-exec-write, pre-spec-write, session-start-comments), skills symlinks
- [T3:ADD-ONLY] 6 skills zone-scoped: ltc-brainstorming (Z1), ltc-execution-planner + ltc-writing-plans (Z2), ltc-task-executor (Z3), ltc-clickup-planner + ltc-notion-planner (_shared)
- [T3:ADD-ONLY] 11 templates in `_shared/templates/` (ADR, Research, Retro, Review, Risk, SOP, Spike, Standup, Wiki, VANA-Spec, Review-Package)
- [T3:ADD-ONLY] 10 framework pointers in `_shared/frameworks/` (SSOT thin wrappers)
- [T3:ADD-ONLY] Learning pipeline in `1-ALIGN/learning/` (9 sub-dirs: config, input, output, references, research, scripts, skills, specs, templates)
- [T3:ADD-ONLY] Charter templates: `PROJECT_CHARTER.md`, `STAKEHOLDERS.md`, `REQUIREMENTS.md`
- [T3:ADD-ONLY] Risk/driver registers: `UBS_REGISTER.md`, `UDS_REGISTER.md`, `ASSUMPTIONS.md`, `MITIGATIONS.md`, `LEVERAGE_PLAN.md`
- [T3:ADD-ONLY] Roadmap scaffolding: `MASTER_PLAN.md`, `EXECUTION_PLAN.md`, `DEPENDENCIES.md`
- [T3:ADD-ONLY] Quality gates: 6 stage validators in `4-EXECUTE/tests/quality-gates/`
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
1. Identify the improvement in a retrospective (`5-IMPROVE/retrospectives/`)
2. Document the rationale (which pillar does it improve? which UBS does it mitigate?)
3. Implement via Grounding → Sustaining pattern (O-17)
4. Update this CHANGELOG
