---
version: "1.0"
status: Draft
last_updated: 2026-03-31
---

# Git Workflow — LTC Members

One command covers everything: `/git-save`

It classifies your changes, checks version metadata, writes commit messages,
and guides you through staging, committing, and optionally creating a PR.

---

## Commit Format

```
type(scope): short description
```

**Types:** `feat` | `fix` | `refactor` | `docs` | `chore` | `test` | `cleanup`

**Scopes — use zone name only:**

```
┌──────────┬────────────────────────────────────────────────────┐
│ Scope    │ What it covers                                     │
├──────────┼────────────────────────────────────────────────────┤
│ govern   │ Zone 0 — rules, hooks, agent config, scripts       │
│ align    │ Zone 1 — charter, decisions, OKRs, stakeholders    │
│ learn    │ Zone 2 — research, specs, learning pipeline        │
│ plan     │ Zone 3 — architecture, risks, drivers, roadmap     │
│ execute  │ Zone 4 — src, tests, config, docs                  │
│ improve  │ Zone 5 — changelog, metrics, retros, reviews       │
│ genesis  │ _genesis/ — shared frameworks, brand, templates    │
│ skills   │ .claude/skills/ — skill files                      │
│ rules    │ .claude/rules/ — rule files                        │
└──────────┴────────────────────────────────────────────────────┘
```

**Examples:**
```
feat(align): add stakeholder analysis — Vinh input synthesis
fix(execute): correct API endpoint path in config
chore(govern): add git-conventions rule
docs(genesis): update ALPEI process map P3 view
```

---

## Before You Commit — 3 Checks

For every `.md` zone artifact you edited:

1. **`version`** — bump it if the file was previously committed (e.g. `1.0` → `1.1`)
2. **`status`** — must be `Draft` or `Review`. Never set `Approved` yourself.
3. **`last_updated`** — today's date in `YYYY-MM-DD` format

---

## After You Commit — 2 Updates

1. `0-GOVERN/VERSION_REGISTRY.md` — update the row for every zone artifact committed
2. `5-IMPROVE/changelog/CHANGELOG.md` — add an entry before creating any PR

---

## What NOT to stage

`.obsidian/` | `.env*` | `TEMP/` | `secrets/` | `*.tmp`

These are in `.gitignore`. If `/git-save` flags them, skip them.

---

## Full reference

Conventions: `.claude/rules/git-conventions.md` | Versioning: `.claude/rules/versioning.md` | Skill: `/git-save`
