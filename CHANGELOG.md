# Changelog

All notable changes to the LTC Project Template.
Format: [semver] — YYYY-MM-DD — summary.
Tier tags: [T1:REPLACE] [T2:MERGE] [T3:ADD-ONLY]

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
