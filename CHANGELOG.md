# Changelog

All notable changes to the LTC Project Template.
Format: [semver] — YYYY-MM-DD — summary.
Tier tags: [T1:REPLACE] [T2:MERGE] [T3:ADD-ONLY]

## [2.0.0] — 2026-04-06

I2 Prototype release. 71 commits since v1.0.0. Major: Obsidian Bases vault system,
S2 status lifecycle enforcement, 4-mode filesystem routing, LEARN pipeline (Option X),
multi-agent governance harness, PKB system, 47-slide training deck.

### Added — Obsidian Bases Vault System (I2 core feature)
- [T1:REPLACE] 14 Obsidian Bases dashboards — Vinh → LTC template adaptation
- [T1:REPLACE] 6 Templater templates — auto-fill frontmatter on artifact creation
- [T1:REPLACE] `scripts/setup-vault.sh` — vault folder scaffold + Git-aware setup
- [T1:REPLACE] `scripts/setup-obsidian.sh` — one-command Obsidian installer
- [T1:REPLACE] `_genesis/reference/frontmatter-schema.md` — canonical schema spec
- [T1:REPLACE] `scripts/migrate-status.sh` — S2 vocabulary migration across workstream artifacts
- [T1:REPLACE] LTC dark CSS theme for Bases dashboards + color pill selectors
- [T1:REPLACE] Kanban views + Bases dashboard grouping for DSBV phases

### Added — S2 Status Lifecycle Enforcement
- [T1:REPLACE] `scripts/dsbv-gate.sh` v2.1 — ALPEI chain-of-custody gate (5 workstreams, S2 vocab, multi-file-type support, `--pretool` real-time mode)
- [T1:REPLACE] `scripts/status-guard.sh` v2.2 — blocks agent self-setting `validated` across .md/.sh/.py/.html
- [T2:MERGE] `.claude/settings.json` — PreToolUse `Write|Edit` hook for real-time chain-of-custody
- [T1:REPLACE] Status vocabulary: `draft → in-progress → in-review → validated → archived` (S2 canonical)

### Added — LEARN Pipeline (Option X Cross-First)
- [T1:REPLACE] 7 learning skills rewritten: `/learn`, `/learn:input`, `/learn:research`, `/learn:structure`, `/learn:review`, `/learn:spec`, `/learn:visualize`
- [T1:REPLACE] 7 P-page templates (P0–P5, P7) in `_genesis/templates/learning-book/`
- [T1:REPLACE] `_genesis/templates/learn-input-template.md` — Learning Brief template
- [T1:REPLACE] `2-LEARN/_cross/scripts/validate-learning-page.sh` — 17-column CAG table validation
- [T1:REPLACE] `2-LEARN/_cross/config/constraints.yaml` — pipeline limits (12 topics, depth 3)
- [T1:REPLACE] `scripts/learn-path-lint.sh` — detects stale flat paths in skills
- [T1:REPLACE] Cross-first routing: all pipeline stages in `_cross/` until `/learn:spec` classifies to subsystems

### Added — Filesystem & Routing
- [T1:REPLACE] `.claude/rules/filesystem-routing.md` — 4-mode routing (DSBV / LEARN / PKB / Genesis)
- [T1:REPLACE] `_genesis/filesystem-blueprint.md` — canonical directory tree + routing modes
- [T1:REPLACE] `scripts/populate-blueprint.py` — generates directory tree from filesystem
- [T1:REPLACE] `scripts/generate-readmes.py` — 48 README population via manifest
- [T1:REPLACE] `scripts/dsbv-skill-guard.sh` v1.2 — LEARN pipeline exclusion from DSBV enforcement
- [T1:REPLACE] 48 README.md files populated across all workstreams + subsystems

### Added — Multi-Agent Governance
- [T1:REPLACE] 4 MECE agents: `ltc-planner`, `ltc-builder`, `ltc-reviewer`, `ltc-explorer`
- [T1:REPLACE] `.claude/rules/agent-dispatch.md` — 5-field context packaging (EO→INPUT→EP→OUTPUT→VERIFY)
- [T1:REPLACE] D0–D5 script harness: 6 enforcement scripts (ripple, links, orphans, rename, registry, status)
- [T1:REPLACE] EP-12 Script-First Delegation + EP-13 nesting depth guard
- [T1:REPLACE] `scripts/skill-validator.sh` — 8-check EOP governance for skill directories
- [T1:REPLACE] Hook chain: 7 PreToolUse hooks, 3 PostToolUse hooks, 3 SessionStart hooks

### Added — Personal Knowledge Base (PKB)
- [T1:REPLACE] `PERSONAL-KNOWLEDGE-BASE/` scaffold — distilled wiki for PM learning output
- [T1:REPLACE] `scripts/pkb-lint.sh` — 8-check structural validator
- [T1:REPLACE] `scripts/pkb-ingest-reminder.sh` — session-end nudge for uningested captures
- [T1:REPLACE] `/ingest` skill — CODE pipeline for personal knowledge base
- [T1:REPLACE] `/vault-capture` skill — quick capture to inbox/ staging

### Added — Training
- [T1:REPLACE] 47-slide Vite training deck (`_genesis/training/obsidian-bases-training/`)
- [T1:REPLACE] `_genesis/training/I2-training-deck.md` — authoritative content source
- [T1:REPLACE] Status lifecycle slide with enforcement hook callout

### Added — Skills & Tools
- [T1:REPLACE] `/ltc-brainstorming` — Discovery Protocol + companion framing
- [T1:REPLACE] `/template-check` + `/template-sync` — EP-compliant template migration
- [T1:REPLACE] `/setup` skill + `scripts/smoke-test.sh` — vault harness onboarding
- [T1:REPLACE] `_genesis/tools/alpei-navigator.html` — interactive ALPEI process navigator
- [T1:REPLACE] `_genesis/reference/ltc-eop-gov.md` — EOP governance codex (14 principles)

### Changed
- [T2:MERGE] `CLAUDE.md` — 5×4×4 matrix structure, DSBV process, filesystem routing, brand identity, pre-flight protocol
- [T2:MERGE] `.claude/rules/versioning.md` — S2 status lifecycle, MAJOR=iteration convention, frontmatter casing rules
- [T2:MERGE] `.claude/rules/git-conventions.md` — canonical commit format, scope list, staging rules
- [T2:MERGE] `.claude/rules/naming-rules.md` — skill prefix registry, folder format rejection
- [T2:MERGE] `_genesis/version-registry.md` — 22-row workstream×phase matrix, S2 vocab
- [T2:MERGE] `_genesis/BLUEPRINT.md` — I2 prototype scope, LEARN as Zone 2, UES versioning
- [T2:MERGE] All ALPEI process map partitions (P1–P4) — S2 vocabulary alignment
- [T2:MERGE] `.gitignore` — tsconfig.tsbuildinfo exclusion

### Removed
- `scripts/retrofit-versioning.sh` — one-time I1 migration tool (merged, no longer needed)
- `scripts/release-pr.sh` — replaced by `/git-save` skill + gh CLI
- 30 DSBV WIP artifacts from `_genesis/` — ship-ready template cleanup

### Fixed
- 0-GOVERN/ forbidden directory reference in `save-context-state.sh`
- S1→S2 status vocabulary across all frameworks, skills, and enforcement scripts
- LEARN workstream omitted from chain-of-custody gate (now enforced)
- `work_stream` frontmatter: SCREAMING format (4-EXECUTE not 4-execute)
- Broken self-reference in `filesystem-blueprint.md` (was in 3-PLAN/_cross/, moved to _genesis/)

## [1.0.0] — 2026-03-30

I1 Concept release. ALPEI workstream scaffold, initial rules, charter, decisions.

## [0.3.0] — 2026-03-19

### Added
- [T1:REPLACE] `rules/agent-system.md` — 7-CS, 8 LLM Truths, two operators (OPS_-4216)
- [T1:REPLACE] `rules/agent-diagnostic.md` — symptom→component diagnostics (OPS_-4216)
- [T1:REPLACE] `rules/general-system.md` — system design methodology (OPS_-4216)
- [T1:REPLACE] `rules/security-rules.md` — 3-layer defense-in-depth (OPS_-4215)
- [T1:REPLACE] `rules/naming-rules.md` — UNG with 75 SCOPE codes
- [T1:REPLACE] `VERSION` — Template version tracking (semver, starting at 0.3.0)
- [T1:REPLACE] `CHANGELOG.md` — Tier-tagged changelog for template distribution
- [T1:REPLACE] `scripts/template-check.sh` — Staleness checker (compares .template-version against remote VERSION)
- [T1:REPLACE] `.cursor/rules/template-version.md` — Session-start template version check for Cursor

### Changed
- [T1:REPLACE] `rules/brand-identity.md` — Tenorite → Inter, 20-color palette, Google Fonts CDN URLs
- [T2:MERGE] `CLAUDE.md` — Brand Identity NEVER list, Template Version session-start check
- [T2:MERGE] `GEMINI.md` — Typography: Tenorite → Inter, Template Version session-start check
- [T1:REPLACE] `.cursor/rules/brand-identity.md` — Tenorite → Inter
- [T1:REPLACE] `.agents/rules/brand-identity.md` — Tenorite → Inter
- [T2:MERGE] `README.md` — Added "Keeping Your Repo Updated" section, Inter/Work Sans in rules table
- [T2:MERGE] `.gitignore` — Added .template-version exclusion

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[GEMINI]]
- [[README]]
- [[agent-diagnostic]]
- [[agent-system]]
- [[brand-identity]]
- [[general-system]]
- [[methodology]]
- [[naming-rules]]
- [[project]]
- [[security-rules]]
- [[template-version]]
