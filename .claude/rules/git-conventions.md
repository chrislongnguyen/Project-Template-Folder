---
version: "1.0"
status: Draft
last_updated: 2026-03-31
---

# Git Conventions — Always-On Rule

Canonical commit format and staging rules for all LTC repositories.
Enforced by: PreToolUse hook (warn) + `/git-save` skill (guided workflow).

## Commit Format

```
type(scope): short description        ← ≤72 chars, imperative mood

[body — required if > 5 files or > 200 lines]
  Line 1: WHY in one sentence
  Bullets: WHAT changed per file/sub-concern

[footer — Refs #issue if applicable]
```

## Canonical Scope List

Use **exactly one** scope per commit. Scope = zone of primary change.
NEVER use: `governance`, `zone0`, `APEI`, `scaffold`, `infra`, `LEP` or other ad-hoc scopes.

| Scope | Zone / Area |
|-------|-------------|
| `govern` | Zone 0 — rules, hooks, agent config, scripts, GOVERN/ |
| `align` | Zone 1 — charter, decisions, OKRs, stakeholders |
| `learn` | Zone 2 — research, specs, learning pipeline, input/output |
| `plan` | Zone 3 — architecture, risks, drivers, roadmap |
| `execute` | Zone 4 — src, tests, config, docs |
| `improve` | Zone 5 — changelog, metrics, retros, reviews |
| `genesis` | `_genesis/` — shared frameworks, brand, templates, reference |
| `skills` | `.claude/skills/` — skill files specifically |
| `rules` | `.claude/rules/` — rule files specifically |

Multi-zone commits: use the **primary** zone only. Truly cross-cutting → `genesis`.

## Commit Types

| Type | When |
|------|------|
| `feat` | New capability, artifact, or module |
| `fix` | Bug fix or correctness improvement |
| `refactor` | Restructure without behavior change (rename, move) |
| `docs` | Documentation only |
| `chore` | Config, tooling, hooks, scripts |
| `test` | Test additions or changes |
| `cleanup` | Remove dead code, temp files, legacy artifacts |

## Skip List — NEVER commit these

`.obsidian/` | `.env` | `.env.*` | `secrets/` | `TEMP/` | `*.tmp` | `node_modules/`

## Pre-Commit Checks (zone .md artifacts only)

Before staging any modified `.md` zone artifact, verify:
1. `version` bumped (only if file was previously committed — see versioning.md)
2. `status` is `Draft` or `Review` — NEVER self-set `Approved`
3. `last_updated` = today's absolute date (YYYY-MM-DD)

## Post-Commit Requirements (zone artifacts)

After every commit that includes a zone artifact:
- Update `0-GOVERN/VERSION_REGISTRY.md` row (version, status, date)
- Update `5-IMPROVE/changelog/CHANGELOG.md` as part of every PR

## Staging Rule

**PREFER** explicit per-file staging over `git add .`
Classify first (type, scope) → stage by group → one commit per group.
Use `/git-save` for the full guided flow.
