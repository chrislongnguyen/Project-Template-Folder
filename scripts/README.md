---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: readme
---

# scripts/ — Script Directory

39 scripts. Authoritative lookup: `.claude/rules/script-registry.md`

This README is a navigation aid. For full descriptions, arguments, and cross-references to skills, see the registry.

## 7 Categories

| Category | What it covers |
|----------|---------------|
| **Automated** | Hook-invoked scripts — fire via `.claude/settings.json`. Never call manually in normal flow. |
| **Pre-Commit** | Run before staging to diagnose hook failures (status-guard, link-validator, registry-sync-check, skill-validator, dsbv-gate). |
| **Validation & Audit** | Proactive repo health checks — run before PRs or after major changes (pre-flight, template-check, validate-blueprint, validate-memory-structure). |
| **Governance & Lifecycle** | Version/status operations — generate-registry, iteration-bump, readiness-report, bulk-validate, frontmatter-extract. |
| **Obsidian & Knowledge Graph** | Wikilink and vault maintenance — obsidian-autolinker, alias-seeder, backlink-map, orphan-detect, rename-ripple, ripple-check, learn-path-lint. |
| **Setup & Scaffolding** | One-time or per-clone setup — setup-vault, setup-obsidian, setup-member, generate-readmes, template-sync, skill-sync-user. |
| **Learning Pipeline** | LEARN workstream tools — learn-benchmark, learn-benchmark-l1, learn-benchmark-l2. |

## Quick Reference

Before writing a new script: search `.claude/rules/script-registry.md` first — it may already exist.

## Links

- [[script-registry]]
- [[enforcement-layers]]
- [[SKILL]]
