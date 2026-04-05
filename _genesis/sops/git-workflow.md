---
version: "1.2"
status: draft
last_updated: 2026-04-02
---

# Git Workflow — LTC Members

One command covers everything: `/git-save`

It classifies your changes, checks version metadata, writes commit messages,
and guides you through staging, committing, and optionally creating a PR.

---

## Branching Strategy

```
main (protected — always matches origin/main)
  │
  ├── I1/feat/obsidian-cli        ← feature work for Iteration 1
  ├── I1/fix/zone-to-workstream   ← bugfix for Iteration 1
  ├── hotfix/critical-rename      ← urgent fix, merged directly
  │
  └── (branch deleted after PR merge)
```

### Rules

| Rule | Why |
|------|-----|
| Branch FROM `main` | Ensures clean baseline, no orphaned history |
| Branch name: `I{N}/{type}/{name}` | Iteration-scoped, type-prefixed, human-readable |
| Squash merge via PR → delete branch | Clean main history, no merge commit noise |
| Never reuse a branch after squash merge | Squash creates new commit — old branch history is orphaned |
| One task per branch | Small PRs, fast review, easy revert |
| `hotfix/*` for urgent fixes | Can fast-forward merge directly if needed |

### Branch Naming

```
I{iteration}/{type}/{short-name}

Examples:
  I1/feat/obsidian-cli
  I1/fix/workstream-rename
  I2/feat/notion-sync
  hotfix/pr11-cleanup          ← no iteration prefix for hotfixes
  test/obsidian-ab             ← test branches for experiments
```

**Types:** `feat` | `fix` | `refactor` | `test` | `hotfix`

### Lifecycle

```
1. git checkout main && git pull origin main
2. git checkout -b I1/feat/my-feature
3. Work, commit, push
4. gh pr create --base main
5. Squash merge PR on GitHub
6. git checkout main && git pull
7. git branch -d I1/feat/my-feature     ← delete local
8. git push origin -d I1/feat/my-feature ← delete remote
```

### Do NOT

- Keep long-lived branches after squash-merging to main
- Merge main INTO a feature branch (rebase instead, or start fresh)
- Use git worktrees (see below)

### Worktrees — Not Recommended

Worktrees create isolated copies of the repo for parallel work. **Do not use them
for this project** because:

1. **Squash merge orphans worktree branches.** After squash-merge to main,
   the worktree's history diverges permanently — merging back causes 100+ conflicts.
2. **Obsidian CLI doesn't work in worktrees.** `.obsidian/` config is repo-root-relative.
3. **Complexity without payoff.** For a template repo, `git stash` + new branch
   achieves the same isolation without the footguns.

**Instead:** `git stash`, checkout a new branch, work, PR, delete branch.

---

## Commit Format

```
type(scope): short description
```

**Types:** `feat` | `fix` | `refactor` | `docs` | `chore` | `test` | `cleanup`

**Scopes — use workstream name only:**

```
┌──────────┬────────────────────────────────────────────────────┐
│ Scope    │ What it covers                                     │
├──────────┼────────────────────────────────────────────────────┤
│ govern   │ GOVERN workstream — rules, hooks, agent config, scripts       │
│ align    │ ALIGN workstream — charter, decisions, OKRs, stakeholders    │
│ learn    │ LEARN workstream — research, specs, learning pipeline        │
│ plan     │ PLAN workstream — architecture, risks, drivers, roadmap     │
│ execute  │ EXECUTE workstream — src, tests, config, docs                  │
│ improve  │ IMPROVE workstream — changelog, metrics, retros, reviews       │
│ genesis  │ _genesis/ — shared frameworks, brand, templates    │
│ skills   │ .claude/skills/ — skill files                      │
│ rules    │ .claude/rules/ — rule files                        │
└──────────┴────────────────────────────────────────────────────┘
```

**Examples:**
```
feat(align): add stakeholder analysis — input synthesis
fix(execute): correct API endpoint path in config
chore(govern): add git-conventions rule
docs(genesis): update ALPEI process map P3 view
```

---

## Before You Commit — 3 Checks

For every `.md` workstream artifact you edited:

1. **`version`** — bump it if the file was previously committed (e.g. `1.0` → `1.1`)
2. **`status`** — must be `Draft` or `Review`. Never set `Approved` yourself.
3. **`last_updated`** — today's date in `YYYY-MM-DD` format

---

## After You Commit — 2 Updates

1. `_genesis/version-registry.md` — update the row for every workstream artifact committed
2. `5-IMPROVE/changelog/CHANGELOG.md` — add an entry before creating any PR

---

## What NOT to stage

`.obsidian/` | `.env*` | `TEMP/` | `secrets/` | `*.tmp`

These are in `.gitignore`. If `/git-save` flags them, skip them.

---

## Full reference

Conventions: `.claude/rules/git-conventions.md` | Versioning: `.claude/rules/versioning.md` | Skill: `/git-save`

## Links

- [[CHANGELOG]]
- [[CLAUDE]]
- [[SKILL]]
- [[version-registry]]
- [[git-conventions]]
- [[iteration]]
- [[project]]
- [[task]]
- [[versioning]]
- [[workstream]]
