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

Use **exactly one** scope per commit. Scope = workstream of primary change.
NEVER use: `governance`, `workstream0`, `APEI`, `scaffold`, `infra`, `LEP` or other ad-hoc scopes.

| Scope | Workstream / Area |
|-------|-------------|
| `govern` | GOVERN workstream — rules, hooks, agent config, scripts, GOVERN/ |
| `align` | ALIGN workstream — charter, decisions, OKRs, stakeholders |
| `learn` | LEARN workstream — research, specs, learning pipeline, input/output |
| `plan` | PLAN workstream — architecture, risks, drivers, roadmap |
| `execute` | EXECUTE workstream — src, tests, config, docs |
| `improve` | IMPROVE workstream — changelog, metrics, retros, reviews |
| `genesis` | `_genesis/` — shared frameworks, brand, templates, reference |
| `skills` | `.claude/skills/` — skill files specifically |
| `rules` | `.claude/rules/` — rule files specifically |

Multi-workstream commits: use the **primary** workstream only. Truly cross-cutting → `genesis`.

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

## Pre-Commit Checks (workstream .md artifacts only)

Before staging any modified `.md` workstream artifact, verify:
1. `version` bumped (only if file was previously committed — see versioning.md)
2. `status` is `Draft` or `Review` — NEVER self-set `Approved`
3. `last_updated` = today's absolute date (YYYY-MM-DD)

## Post-Commit Requirements (workstream artifacts)

After every commit that includes a workstream artifact:
- Update `0-GOVERN/VERSION_REGISTRY.md` row (version, status, date)
- Update `5-IMPROVE/changelog/CHANGELOG.md` as part of every PR

## Branch Strategy

Never commit directly to main. Follow I0-I4 branching — see `_genesis/sops/GIT_WORKFLOW.md`.

## Staging Rule

**PREFER** explicit per-file staging over `git add .`
Classify first (type, scope) → stage by group → one commit per group.
Use `/git-save` for the full guided flow.

