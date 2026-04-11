---
name: git-save
description: Classify, stage, commit, and optionally PR changes with LTC-aware workstream scopes, version bump checks, and changelog hygiene.
version: "1.0"
status: draft
last_updated: 2026-04-08
---
# /git-save — LTC Git Save Workflow

Classify, stage, commit, and optionally PR your current changes.
LTC-aware: enforces workstream scopes, version bump checks, and changelog hygiene.

Reference: `.claude/rules/git-conventions.md` (canonical scope list + commit format).

---

## Step 1: Assess

Run these in parallel and read all output before proceeding:

```bash
git status
git diff --stat HEAD
git log --oneline -5
git log --oneline main..HEAD   # commits ahead of main → PR readiness signal
```

---

## Step 2: Classify

Output a classification table for EVERY changed file before staging anything:

```
| File | Type | Scope | Note |
|------|------|-------|------|
| .claude/rules/git-conventions.md | chore | rules | new always-on rule |
| 1-ALIGN/1-PD/pd-charter.md       | feat  | align | v1.2, bump required |
```

**Types:** `feat` | `fix` | `refactor` | `docs` | `chore` | `test` | `cleanup`

**Scopes (canonical — no others):**
`govern` | `align` | `learn` | `plan` | `execute` | `improve` | `genesis` | `skills` | `rules`

Group files by `(type, scope)` → one commit per group.

Flag immediately:
- `.obsidian/`, `TEMP/`, `.env*` → **SKIP, do not stage**
- Binary / image files → list separately, ask user before staging
- Untracked files that look like accidental debris → flag for user decision

---

## Step 3: Size Check

| Metric | Threshold | Action |
|--------|-----------|--------|
| Total files | > 30 | WARN: consider splitting into multiple PRs |
| Single commit | > 15 files | Split by sub-scope |
| Single commit | > 500 lines | Require detailed body in commit message |
| Rename/move detected | any | Stage both old + new paths for git rename detection |

If total changeset to main > 50 files or > 2000 lines:
> "This is a large changeset. Want to commit what's ready and create a PR now?"

---

## Step 4: Version Bump Check

For every modified `.md` workstream artifact (Workstreams 0–5, `_genesis/`):

- [ ] `version` bumped if file was previously committed (see `rules/versioning.md`)
- [ ] `status` is `Draft` or `Review` — NEVER self-set `Approved`
- [ ] `last_updated` = today's absolute date (YYYY-MM-DD)

**If any check fails: fix metadata BEFORE staging. Do not skip.**

---

## Step 5: Write Commit Messages

Format: `type(scope): description`

```
feat(align): add stakeholder analysis — input synthesis

Captures S1-S4 stakeholder inputs into structured requirements.
- CHARTER.md: add 4 stakeholder perspectives
- REQUIREMENTS.md: derive 12 functional requirements from input
- DECISIONS.md: ADR-001 on subsystem optional layer
```

Rules:
- Header ≤ 72 chars, imperative mood, specific (not "fix bug")
- Body required if > 5 files or > 200 lines: WHY first, then WHAT bullets

---

## Step 6: Stage and Commit

Stage by group — explicit paths, not `git add .`:

```bash
git add .claude/rules/git-conventions.md .claude/skills/git-save/SKILL.md
git commit -m "chore(rules): add git-conventions rule and /git-save skill"
```

Create each commit sequentially. After all commits:
```bash
git log --oneline -N   # N = new commits + 1
```

---

## Step 7: Post-Commit Checklist

For every workstream artifact committed:
- [ ] Update `_genesis/version-registry.md` — version, status, date columns
- [ ] Update `5-IMPROVE/changelog/CHANGELOG.md` — add entry under current PR section

If this is a PR: changelog update is **required** before creating the PR.

---

## Step 8: PR Decision

| Signal | Weight | Action |
|--------|--------|--------|
| > 3 meaningful commits ahead of main | Strong | Suggest PR |
| Logical milestone reached | Strong | Suggest PR |
| > 50 files or > 2000 lines diff to main | Strong | PR now |
| User explicitly asked | Override | Always create PR |
| Work in progress | Blocker | No PR |

**PR size guide:** < 200 lines = easy | 200–500 = reviewable | > 500 = consider splitting | > 1000 = strongly split

When creating a PR, show preview first:
```
PR: "feat(align): stakeholder analysis + requirements"

## Summary
- Add stakeholder input synthesis (S1-S4)
- Derive 12 functional requirements
- ADR-001: optional subsystem layer decision

## Commits (3)
- feat(align): add stakeholder analysis
- docs(align): add ADR-001 subsystem layer decision
- chore(govern): bump VERSION_REGISTRY

## Test plan
- [ ] /dsbv validate align passes
- [ ] All workstream artifact versions consistent
```

Then:
```bash
git pull --rebase   # if behind remote
git push -u origin HEAD
gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"
```

Return the PR URL.

---

## Step 9: Summarize

Tell the user:
1. **Committed:** N commits, what each contained (type/scope/files)
2. **Skipped:** files left out and why
3. **PR:** created (URL) | recommended (why) | not needed (why)
4. **Branch health:** N commits ahead of main, N behind remote
5. **Next step:** one clear action

---

## Proactive Nudges

During any conversation, suggest `/git-save` when:

| Trigger | Message |
|---------|---------|
| 3+ files modified since last commit | "You have uncommitted changes across N files — run `/git-save`?" |
| About to switch tasks | "Before switching, let me `/git-save` your current work." |
| Feature/fix just completed | "That looks done — want to commit and maybe PR?" |
| Before risky operation (rebase, reset) | "Let me commit first so nothing is lost." |
| Branch > 10 commits ahead of main, no PR | "Your branch is N commits ahead with no PR. Create one?" |

## Links

- [[CHANGELOG]]
- [[CLAUDE]]
- [[VALIDATE]]
- [[blocker]]
- [[charter]]
- [[git-conventions]]
- [[version-registry]]
- [[versioning]]
- [[workstream]]
