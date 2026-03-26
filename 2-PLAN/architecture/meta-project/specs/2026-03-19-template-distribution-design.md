# Design Spec: LTC Project Template Distribution System

> **Date:** 2026-03-19
> **Status:** Draft
> **Scope:** OPS_OE.6.4.LTC-PROJECT-TEMPLATE
> **Author:** Long Nguyen + Claude

---

## 1. Problem

The LTC Project Template is the gold standard for repo structuring. As we build out the 7-CS system (new rules, skills, hooks, agent definitions), child repos created from the template have no way to discover or apply updates. GitHub's "Use this template" creates a one-way fork with zero git link back.

**Current scale:** ~15-30 repos across multiple LTC members (2-3 repos per person), growing organically.

**Current workflow:** Long pastes the template repo URL into a child repo's Claude Code CLI and asks Claude to diff and recommend updates. This works but has gaps: no version tracking, no staleness visibility, other members don't know when the template changes.

---

## 2. Decision: Pull Model + Visibility

We keep the existing Claude-assisted pull model — human-driven, context-aware, no automation pushing changes. We add visibility tooling so repos can self-report staleness and humans know when to pull.

**Why not push:**
- Human judgment on every merge handles Tier 2 (mixed org/project files) naturally
- Zero infrastructure to build/maintain
- YAGNI — current scale doesn't justify CI/CD pipelines
- Notification layer (GitHub Actions → ClickUp/Slack) can be bolted on later if team friction emerges

---

## 3. Distribution Tiers

Every file in the template falls into one of three tiers that define how updates should be applied to child repos:

| Tier | Strategy | Description | Examples |
|------|----------|-------------|----------|
| **T1** | REPLACE | Org owns entirely. Overwrite child's copy. | `rules/*`, `.pre-commit-config.yaml`, `.gitleaks.toml`, `.cursor/rules/*`, `.agents/rules/*`, `scripts/template-check.sh` |
| **T2** | MERGE | Org owns sections, project owns the rest. Human judgment required. | `CLAUDE.md`, `GEMINI.md`, `README.md`, `.gitignore`, `.claude/settings.json` (security-sensitive — review deny/allow changes carefully before merging), `.mcp.json` |
| **T3** | ADD-ONLY | Org ships new files. Never overwrites existing project files. | `.claude/skills/*`, `.claude/hooks/*`, `.claude/agents/*`, `scripts/*` (except `template-check.sh` which is T1) |

**Never distributed:** `src/`, `tests/`, `docs/` (project-owned content), `docs/superpowers/` (template-internal design docs).

**T2 merge guidance by file type:**
- **Markdown files** (`CLAUDE.md`, `GEMINI.md`, `README.md`): Org-owned sections are identified by headings (e.g., `## Brand Identity`, `## Security`). Update those sections; leave project-owned sections untouched.
- **JSON files** (`.claude/settings.json`, `.mcp.json`): Merge at the key level — add new keys from template, update existing org-owned keys, preserve project-added keys. For `settings.json` deny/allow arrays: append new org entries, never remove project entries. Human must review security implications.
- **`.gitignore`**: Append new org patterns. Never remove project-added patterns.

---

## 4. Versioning Scheme

### 4.1 Semver

```
VERSION file (root):  "0.3.0"
                       │ │ │
                       │ │ └─ PATCH: Tier 1 fixes (typo in rules, color hex correction)
                       │ └─── MINOR: New content (new rule file, new skill, new hook)
                       └───── MAJOR: Breaking change (CLAUDE.md structure change,
                              renamed files, removed content)
```

**Starting version:** 0.3.0 — reflects pre-1.0 maturity and ~12 commits of real content.

### 4.2 Files

| File | Location | Purpose |
|------|----------|---------|
| `VERSION` | Template repo root | Current template version. Single line, no frontmatter. Authoritative source of truth. |
| `.template-version` | Child repos only | Records which template version the child repo last synced to. Single line, no frontmatter. |

On the template repo, only `VERSION` exists. `.template-version` does not ship in the template repo — it is gitignored.

**Bootstrapping child repos:** GitHub's "Use this template" does not run scripts, so `.template-version` does not appear automatically. The first time a member runs `./scripts/template-check.sh`, the script detects the missing file and prompts: `"No .template-version found. Run ./scripts/template-check.sh --init to set your baseline."` The `--init` flag fetches the template's current `VERSION` and writes it to `.template-version`. This is the **primary and only** bootstrap mechanism.

On child repos, `.template-version` stays at whatever version they last synced to. After applying updates, the member bumps `.template-version` to the new version.

---

## 5. CHANGELOG Format

File: `CHANGELOG.md` (template repo root).

Follows [Keep a Changelog](https://keepachangelog.com) conventions with LTC-specific tier tags.

```markdown
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

### Changed
- [T1:REPLACE] `rules/brand-identity.md` — Tenorite → Inter, 20-color palette, Google Fonts CDN URLs
- [T2:MERGE] `CLAUDE.md` — Brand Identity section strengthened with explicit NEVER list
- [T2:MERGE] `GEMINI.md` — Typography: Tenorite → Inter
- [T1:REPLACE] `.cursor/rules/brand-identity.md` — Tenorite → Inter
- [T1:REPLACE] `.agents/rules/brand-identity.md` — Tenorite → Inter
```

**Design choices:**
- Tier tags on every entry — so Claude (or human) knows the update strategy per file
- File paths explicit — no ambiguity about what changed
- ClickUp IDs where applicable — traceability to WMS

---

## 6. Check Script

### 6.1 Overview

File: `scripts/template-check.sh`

A Bash script that compares the child repo's `.template-version` against the template's current `VERSION` on GitHub. Dependencies: `curl`, `bash` — no npm/pip, no install step.

**Private repo access:** If the template repo is private, `raw.githubusercontent.com` requires authentication. The script checks for a `GITHUB_TOKEN` environment variable and includes it as a Bearer token in `curl` requests. If the repo is public, no token is needed. If private and no token is set, the script falls back to offline mode with a hint: `"Set GITHUB_TOKEN to access private repos."`

### 6.2 Behavior

**Default mode:**

```
$ ./scripts/template-check.sh

LTC Project Template — Update Check
  Local version:    0.3.0
  Template version: 0.5.0
  Status:           ⚠ Outdated (local 0.3.0 → latest 0.5.0)

  Changes since 0.3.0:
    [0.4.0] 2026-03-25 — Added shared TDD skill
    [0.5.0] 2026-03-30 — Updated security-rules.md

  Run: ./scripts/template-check.sh --diff
  to see file-level changes.
```

**Diff mode (`--diff`):**

```
$ ./scripts/template-check.sh --diff

  Changed files (0.3.0 → 0.5.0):
    [T1:REPLACE]  rules/security-rules.md
    [T3:ADD-ONLY] .claude/skills/tdd.md
```

**Quiet mode (`--quiet`):**

```
$ ./scripts/template-check.sh --quiet
⚠ Template v0.5.0 available (you're on v0.3.0). Run ./scripts/template-check.sh for details.
```

Returns exit code 0 if current, 1 if behind. Silent when up to date.

**Offline mode:** If `curl` fails (no network), the script reports the local version only and exits gracefully:

```
$ ./scripts/template-check.sh
LTC Project Template — Update Check
  Local version:    0.3.0
  Template version: (offline — could not reach GitHub)
  Status:           Unknown. Check manually or retry with network.
```

### 6.3 How It Works

1. Read local `.template-version` (if missing, report "no sync version found — run with `--init` to set one" and exit)
2. Fetch template's `VERSION` from GitHub raw URL (`https://raw.githubusercontent.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/main/VERSION`)
3. Compare semver by splitting on `.` and comparing each numeric segment (no pre-release label support)
4. If behind: fetch `CHANGELOG.md` from same GitHub raw URL, parse entries between local and latest versions
5. `--diff` flag: parse CHANGELOG entries for file paths and tier tags (no git tag dependency)
6. `--quiet` flag: one-line summary, non-zero exit code if behind
7. `--init` flag: create `.template-version` from template's current `VERSION` (for bootstrapping existing child repos)

### 6.4 Non-Goals

- Does NOT auto-apply updates — visibility only
- Does NOT require git remote setup in child repos
- Does NOT phone home or write analytics
- Does NOT modify project files in the child repo (exception: `--init` creates `.template-version` once, with explicit user invocation)

---

## 7. Session-Start Integration

### 7.1 Approach

EPS instruction added to each IDE's config file — no hooks infrastructure required.

The same instruction must appear in all three IDE configs since each IDE reads its own file:

| IDE | Config file | Reads CLAUDE.md? |
|-----|-------------|-----------------|
| Claude Code | `CLAUDE.md` | Yes |
| AntiGravity | `GEMINI.md` | No — needs its own instruction |
| Cursor | `.cursor/rules/` | No — needs its own instruction |

### 7.2 EPS Additions

**`CLAUDE.md`:**
```markdown
## Template Version

If `./scripts/template-check.sh` exists, run `./scripts/template-check.sh --quiet` at session start.
If behind, warn the user before proceeding. If the script is missing, skip silently.
```

**`GEMINI.md`:** Same instruction, adapted to GEMINI.md conventions.

**`.cursor/rules/template-version.md`:** Same instruction as a path-scoped rule.

### 7.3 Behavior

- At session start, the IDE agent runs the script in quiet mode
- If behind: surfaces a one-line warning to the user
- If current or offline: silent, no disruption
- Human decides whether to update now, later, or skip

---

## 8. README Documentation

The following sections are added to the existing README under a new `## Keeping Your Repo Updated` heading:

```markdown
## Keeping Your Repo Updated

This template uses semver versioning. The `VERSION` file tracks the current template version.

### Distribution Tiers

Every file falls into one of three update tiers:

| Tier | Strategy | What it means |
|------|----------|---------------|
| T1:REPLACE | Overwrite | Org-owned. Copy the template's version directly. |
| T2:MERGE | Merge | Mixed ownership. Update org sections, keep your project sections. |
| T3:ADD-ONLY | Add new | New files only. Never overwrites your existing files. |

See CHANGELOG.md for tier tags on every change.

### Checking for Updates

Run the staleness checker:

    ./scripts/template-check.sh           # full report
    ./scripts/template-check.sh --diff    # show changed files with tier tags
    ./scripts/template-check.sh --quiet   # one-line summary (used by session-start)

First time? Bootstrap your sync version:

    ./scripts/template-check.sh --init

### Applying Updates

1. Open your repo in Claude Code (or your IDE of choice)
2. Paste the template repo URL and ask:
   "Check this template and see if there is any update I need to make to my repo"
3. Claude diffs the template against your repo and recommends changes per tier
4. Review and approve each change
5. Update `.template-version` to the new version

### Releasing a Template Update (maintainers)

1. Make changes to the template repo
2. Bump `VERSION` (semver: patch/minor/major)
3. Add CHANGELOG.md entry with tier tags per file
4. Commit, push, and optionally tag: `git tag v{VERSION}`
```

---

## 9. File Layout

### New Files

| File | Purpose |
|------|---------|
| `VERSION` | Current template version (`0.3.0`) |
| `CHANGELOG.md` | Tier-tagged changelog |
| `scripts/template-check.sh` | Staleness checker (T1:REPLACE — org-owned infrastructure) |

**Child-repo-only file (not in template repo):**

| File | Purpose |
|------|---------|
| `.template-version` | Records last synced version. Created via `--init` flag or seeded on "Use this template". |

### Updated Files

| File | Change |
|------|--------|
| `README.md` | Add "Keeping Your Repo Updated" section |
| `CLAUDE.md` | Add Template Version section (session-start check instruction) |
| `GEMINI.md` | Add Template Version section (same instruction, GEMINI.md conventions) |
| `.gitignore` | Add `.template-version` |

### New Files

| File | Purpose |
|------|---------|
| `.cursor/rules/template-version.md` | Session-start check instruction for Cursor |

---

## 10. Update Workflow

### For template maintainers (releasing an update):

```
1. Make changes to template repo
2. Bump VERSION (follow semver: patch/minor/major)
3. Add CHANGELOG entry with tier tags per file
4. Commit + push
5. Tag the commit: git tag v{VERSION} (e.g., git tag v0.4.0)
6. Push tag: git push origin v{VERSION}
7. Done — child repos discover on next session-start
```

Note: git tags are optional but recommended for traceability. The check script does not depend on tags — it reads `VERSION` and `CHANGELOG.md` directly.

### For LTC members (applying an update):

```
1. Open child repo in Claude Code
2. Session starts → Claude runs template-check.sh --quiet
3. If behind:
     "⚠ Template v0.5.0 available (you're on v0.3.0).
      Run ./scripts/template-check.sh for details."
4. To update: paste template repo URL into Claude Code
5. Ask: "Check this template and see if there is any update I need to make to my repo"
6. Claude diffs, recommends changes per tier:
     T1:REPLACE  → overwrite file
     T2:MERGE    → merge org sections, preserve project sections
     T3:ADD-ONLY → add new files, skip existing
7. Human reviews and approves each change
8. Update .template-version to new version
```

---

## 11. Future Enhancements (Out of Scope)

- **Approach C: Automated notification** — GitHub Action → ClickUp/Slack on version tag. Add when team friction shows up.
- **Auto-apply for Tier 1** — Script could auto-replace T1 files with `--apply-t1` flag. Design later if manual becomes tedious.
- **Template registry** — If LTC has multiple templates (not just project), a registry of template → child mappings. Not needed at current scale.
