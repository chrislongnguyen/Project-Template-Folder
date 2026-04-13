---
version: "3.3"
status: draft
last_updated: 2026-04-13
---

> **PKB Directory Rename (post-v2.1.0 patch):** If you cloned before 2026-04-13, your PKB subdirectories have changed names.
> Run these in your repo root to align:
> ```
> mv PERSONAL-KNOWLEDGE-BASE/captured PERSONAL-KNOWLEDGE-BASE/1-captured 2>/dev/null; \
> mv PERSONAL-KNOWLEDGE-BASE/distilled PERSONAL-KNOWLEDGE-BASE/2-organised 2>/dev/null; \
> mv PERSONAL-KNOWLEDGE-BASE/expressed PERSONAL-KNOWLEDGE-BASE/3-distilled 2>/dev/null
> ```
> Then run `bash scripts/setup-vault.sh` to scaffold the new `4-expressed/` directory.

# Migration Guide — LTC Project Template

> One source of truth for syncing any LTC repo with the template.
> An AI agent can execute this guide end-to-end. Say:
> "Read `_genesis/guides/migration-guide.md` and execute Path C for my project."

---

## Quick Reference Card

**You're a PM (Dong, Khang, Cam Van, Dung, or similar). You're in YOUR repo in Claude Code. Long shipped template v2.1.0. You want to sync.**

---

### Step 0: Copy This Prompt to Your Claude Code Session

```
I want to sync my repo with LTC template v2.1.0.

GUIDE ME through this process — explain what you're doing and why before
each action. I want to understand the migration, not just have it done.

Follow these steps:

1. SAFETY FIRST
   - Confirm I'm in MY project repo (not the template repo itself)
   - Check my working tree is clean (if not, help me stash or commit)
   - Create a test branch: test/template-v2.1.0
   - Create a backup tag: backup/pre-v2.1.0
   - Explain: why branch + tag protects my work

2. CONNECT TO TEMPLATE
   - Add the template remote if not present:
     git remote add template https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git
   - Fetch the target version: git fetch template v2.1.0
   - Explain: what a git remote is and why we need it

3. DETECT MY PATH
   - Check my repo structure to determine Path A, B, or C:
     • PATH A: Fresh repo, no existing work
     • PATH B: Pre-ALPEI structure or severely diverged (>30%)
     • PATH C: Has 1-ALIGN/, .claude/rules/, _genesis/ — normal upgrade
   - Explain: why these 3 paths exist and which one applies to me

4. FETCH AND READ THE MIGRATION GUIDE
   - Run: git show template/v2.1.0:_genesis/guides/migration-guide.md
   - Follow the detailed steps for my detected path
   - Before each major action, explain what will happen and ask for my OK

5. VERIFY AND EXPLAIN RESULTS
   - Run verification after sync completes
   - Show me what changed (files added, merged, skipped)
   - Explain: the three lineages (template, shared, domain) and how my files were classified
   - Confirm: my domain content (charter, research, code) was NOT touched

6. FINAL CHECK
   - Summarize what was done
   - Show me how to verify the sync worked
   - Explain: how to roll back if anything is wrong
   - Tell me: what to do next (test, commit, merge to main, or discard)
```

---

### What Happens Next (Reference)

After you paste the prompt above, your Claude agent will guide you through:

| Phase | What Claude Does | What You Learn |
|-------|------------------|----------------|
| Safety | Creates branch + tag | Why isolation protects your work |
| Connect | Adds template remote | How git remotes work |
| Detect | Checks your repo structure | Which migration path applies to you |
| Migrate | Executes Path A, B, or C | How three-lineage classification works |
| Verify | Runs 6-check sweep | What "correct sync" looks like |
| Summarize | Shows changes + next steps | How to maintain sync going forward |

### Expected Outputs (You're on Track If You See These)

```
# After path detection:
Your repo has 1-ALIGN/, .claude/rules/, and _genesis/.
→ PATH C: Version Upgrade (incremental sync, ~5 min)

# After sync completes:
[1/5] Reading checkpoint... last_sync_sha: abc123
[2/5] Fetching template remote... target: v2.1.0
[3/5] Computing pristine diff... 12 files changed
[4/5] Applying by lineage... 10 auto-take, 2 section-merge
[5/5] Verifying... RESULT: 6/6
✓ Checkpoint updated to v2.1.0

# After verification:
V1 PASS — structural checks: 8/8
V2 PASS — hook paths valid
V3 PASS — 0 broken links
V4 PASS — agents: 5, rules: 13, skills: 28
V5 PASS — manifest coverage: 100%
V6 PASS — sync complete
RESULT: 6/6
```

### Emergency Exit

| Problem | What to Tell Claude |
|---------|---------------------|
| Something went wrong | "Roll back to my backup tag and explain what happened" |
| I don't understand a step | "Pause and explain [X] in more detail before continuing" |
| I want to stop | "Abort the migration, keep my backup, stay on test branch" |
| I want to discard everything | "Delete test branch, go back to main, I'll try later" |

---

## 10 Migration Principles

These are derived from 4 real migrations (Khang/Assets, Dong/Inflation, Dung/Growth, CamVan/FinancialSystem) and formalized in the v3.0 architecture. Every step in this guide follows them.

```
P1  THREE LINEAGES, NOT TWO
    Every file belongs to exactly one lineage:
      TEMPLATE   — owned by template; template-manifest.yml is authoritative.
                   Auto-take when unmodified; conflict when user-edited.
      SHARED     — both template and user legitimately edit (CLAUDE.md, settings.json).
                   Uses section-merge or 3-way-merge per manifest entry.
      DOMAIN     — user-created or domain-seed content; sacred, never auto-modified.
    Classify via template-manifest.yml BEFORE you act.

P2  STRUCTURE FIRST, CONTENT SECOND
    Directory creation and renames complete BEFORE content merges.
    You cannot merge a file into a directory that doesn't exist yet.

P3  DOMAIN FILES ARE SACRED
    Never auto-modify, overwrite, or delete domain files.
    Move them to the correct location. Suggest updates. Always ask.
    Domain = charter, research, P-pages, code, decisions, OKRs.

P4  TEMPLATE FILES REPLACE, SHARED FILES MERGE
    Pure template file (lineage: template, user not modified) → TAKE.
    File with domain customizations (lineage: shared) → section-merge or 3-way-merge.
    The merge strategy per file is declared in template-manifest.yml — use it.

P5  INFRASTRUCTURE FIRST, THEN WORKSTREAMS
    Migrate .claude/ (agents, rules, skills, hooks), scripts/, _genesis/ first.
    Then workstream folders. Infrastructure is one batch; workstream content
    is verified per-workstream after structure is confirmed.

P6  BRANCH-BASED, CHECKPOINTED
    Always work on a migration branch. Tag before starting.
    Commit after each major step. .template-checkpoint.yml records the last
    successful sync SHA — this is your rollback anchor.

P7  VERIFY BEFORE MERGE TO MAIN
    After migration: template-verify.sh (6-check sweep) MUST pass.
    V1 structural + V2 hooks + V3 graph + V4 agent + V5 manifest + V6 sync
    completeness — ALL must pass before PR merge.

P8  MIGRATION IS ROUTINE, NOT HEROIC
    Small frequent syncs > big-bang catch-ups.
    The checkpoint + pristine diff engine is designed for incremental use.
    If migration takes > 1 hour, you've waited too long between syncs.

P9  AGENT-EXECUTABLE
    Every step in this guide is executable by an AI agent reading top-to-bottom.
    All commands are explicit. No "see other docs" deferral in Path C.

P10 THE CHECKLIST IS THE GUIDE
    Create a migration-checklist.md for your migration run.
    Tick boxes as you go. The checklist IS your audit trail.
```

---

## Path A — Fresh Clone

**When:** Starting a new project. No domain content created yet.

```bash
# 1. Create from template
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE

# 2. Clone locally
git clone https://github.com/Long-Term-Capital-Partners/{YOUR_PROJECT}.git
cd {YOUR_PROJECT}

# 3. Customize CLAUDE.md — edit ONLY the ## Project section:
#    Name, Stack, Purpose, EO — all other sections are template-owned
$EDITOR CLAUDE.md

# 4. Verify template health
bash scripts/template-check.sh --quiet

# 5. Open Claude Code and confirm agent system works
claude
# Then: /dsbv status → should show "no active DSBV cycle"
```

Done. Your repo has the full template structure. Start with `/ltc-brainstorming` or `/dsbv design align pd`.

---

## Path B — Reverse Clone

**When:** `bash scripts/template-sync.sh --detect-path` outputs `PATH B`, OR:
- Repo lacks `1-ALIGN/` or `.claude/rules/`
- Divergence > 30% (more than 30% of files are local-only vs template)
- Pre-ALPEI repo with flat directory structure (`docs/`, `research/`, `src/`)

**Engine:** `template-manifest.yml` lineage classification drives triage. Every file in your repo is classified as TEMPLATE, SHARED, DOMAIN-SEED, or DOMAIN before any action is taken.

### Step B1: Detect path and generate triage manifest

```bash
# Confirm you are on Path B
bash scripts/template-sync.sh --detect-path
# → Output: "PATH B: reverse clone required"

# Generate triage manifest — lists all your files with their recommended action
bash scripts/template-sync.sh --reverse-clone <source-repo-path>
# → Outputs: triage-manifest.txt (classify: DOMAIN | TEMPLATE | INHERITED)
# → DOMAIN files: your project content — must be ported
# → TEMPLATE files: skip (will come from fresh clone)
# → INHERITED files: old governance artifacts — delete
```

### Step B2: Backup your current repo

```bash
git tag backup/pre-migration
git push origin backup/pre-migration
```

### Step B3: Clone template fresh into a staging directory

```bash
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT}-migration \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
git clone https://github.com/Long-Term-Capital-Partners/{YOUR_PROJECT}-migration.git /tmp/migration-target
```

### Step B4: Port DOMAIN files from triage manifest

```bash
# For each DOMAIN file in triage-manifest.txt, determine correct ALPEI location:
```

| Content type | Correct location |
|---|---|
| Problem discovery, principles, diagnosis | `2-LEARN/{N}-{SUB}/research/` or `1-ALIGN/1-PD/` |
| Design specs, architecture | `3-PLAN/{N}-{SUB}/` |
| Source code, scripts, config | `4-EXECUTE/{N}-{SUB}/src/` |
| Test files | `4-EXECUTE/{N}-{SUB}/tests/` |
| Charter, OKRs, stakeholders | `1-ALIGN/_cross/` or `1-ALIGN/1-PD/` |
| Decisions, ADRs | `1-ALIGN/_cross/decisions/` |
| Changelog, metrics, retros | `5-IMPROVE/_cross/` |
| Vinh/inherited governance files | DELETE — not needed; template provides these |

```bash
# Use cp (not git mv — you are moving to a new repo)
cp <domain-file> /tmp/migration-target/<correct-alpei-path>/
```

### Step B5: Customize CLAUDE.md in the staging repo

```bash
# Edit only the ## Project section — Name, Stack, Purpose, EO
$EDITOR /tmp/migration-target/CLAUDE.md
```

### Step B6: Delete INHERITED files from staging repo

INHERITED = files from early setup that are not in the template and not domain content:
- `.claude/commands/` (superseded by `.claude/skills/`)
- `_shared/` (superseded by `_genesis/`)
- `0-GOVERN/` (not a standard template directory)
- `plugins/memory-vault/` (integrated into template)
- `scripts/stage-validators/`, `scripts/wms-sync/` (old layout)
- ALL_CAPS `.md` files in `_genesis/` if kebab-case versions exist

```bash
# Remove deprecated patterns listed in _genesis/template-manifest.yml §deprecated
bash scripts/template-manifest.sh --audit /tmp/migration-target
# → Follow recommendations for any deprecated files found
```

### Step B7: Add frontmatter and wikilinks to domain files

```bash
cd /tmp/migration-target
python3 scripts/obsidian-alias-seeder.py
python3 scripts/obsidian-autolinker.py
```

### Step B8: Verify and commit

```bash
bash scripts/template-verify.sh
# Must exit 0 (all 6 checks: structural, hooks, graph, agent, manifest, sync)

git add .claude/ _genesis/ scripts/ rules/ CLAUDE.md AGENTS.md GEMINI.md VERSION .gitignore
git add 1-ALIGN/ 2-LEARN/ 3-PLAN/ 4-EXECUTE/ 5-IMPROVE/
git commit -m "feat(all): migrate to ALPEI template structure"
git push -u origin feat/template-migration

gh pr create --base main --title "feat: ALPEI template migration (Path B)"
```

---

## Path C — Version Upgrade

**When:** `bash scripts/template-sync.sh --detect-path` outputs `PATH C`. Repo has `1-ALIGN/`, `.claude/rules/`, `_genesis/`. You want to pull template improvements from a newer version.

**This path is agent-executable. All commands are explicit. No external docs required.**

**Key files:**
- `_genesis/template-manifest.yml` — controls what gets synced (three-lineage ownership)
- `.template-checkpoint.yml` — tracks sync state (last sync SHA, version, history)
- `scripts/template-diff.sh` — powers the pristine diff engine (computes template-only changes between two template SHAs)

---

### Step C1: Detect path

```bash
bash scripts/template-sync.sh --detect-path
# → Expected output: "PATH C: version upgrade"
# If output is PATH B: follow Path B instructions above.
# If output is PATH A: repo is a fresh clone — no sync needed.
```

---

### Step C2: Check for checkpoint — detect bootstrap mode

```bash
# Does a checkpoint file exist with a non-empty last_sync_sha?
if [[ -f .template-checkpoint.yml ]]; then
  last_sha=$(grep 'last_sync_sha' .template-checkpoint.yml | awk '{print $2}')
  if [[ -z "$last_sha" || "$last_sha" == '""' || "$last_sha" == "~" ]]; then
    echo "BOOTSTRAP MODE: checkpoint exists but last_sync_sha is empty"
  else
    echo "INCREMENTAL MODE: last sync SHA = $last_sha"
  fi
else
  echo "BOOTSTRAP MODE: no checkpoint file found"
fi
```

**If BOOTSTRAP MODE:** proceed to Step C3. **If INCREMENTAL MODE:** skip to Step C4.

---

### Step C3: Bootstrap (first-time checkpoint creation)

This step runs only when `.template-checkpoint.yml` is missing or `last_sync_sha` is empty.
The sync script will prompt you for the template version this repo was originally cloned from.

```bash
# Run sync — the script detects missing checkpoint and enters bootstrap mode automatically.
# It will prompt: "No checkpoint found. What template version was this repo originally
# cloned from? (e.g., v2.0.0)"
# Answer with the version tag closest to when you cloned (check git log for dates if unsure).
bash scripts/template-sync.sh --sync v2.0.0
# → Script writes initial .template-checkpoint.yml with your provided version SHA
# → Script re-enters incremental diff from that SHA as the baseline
# → Proceed to Step C4 after script creates the checkpoint
```

---

### Step C4: Create a migration branch and backup tag

```bash
VERSION_OLD=$(cat VERSION 2>/dev/null || echo "unknown")
git tag "backup/pre-${VERSION_OLD}-upgrade"
git checkout -b feat/template-upgrade
```

---

### Step C5: Check what changed since last sync

```bash
bash scripts/template-check.sh
```

This compares your repo against the template using the checkpoint SHA as the baseline.
Output is categorized into 5 buckets:

```
┌─────────────────────────┬────────────────────────────────────────────────────┐
│ Bucket                  │ What it means                                      │
├─────────────────────────┼────────────────────────────────────────────────────┤
│ auto_add                │ New template files not in your repo → safe to add  │
│ flagged.security        │ .env, secrets → NEVER auto-add                     │
│ flagged.review_required │ .claude/, _genesis/, scripts/ → review before take │
│ merge                   │ Both sides changed → needs decision per P4          │
│ unchanged               │ Identical content → nothing to do                  │
└─────────────────────────┴────────────────────────────────────────────────────┘
```

The pristine diff engine (`template-diff.sh`) computes the changeset between
`template@last_sync_sha` and `template@target_sha` — only template-side changes appear.
Your local edits do NOT create false positives in this diff.

---

### Step C6: Run the sync

```bash
# Replace v2.1.0 with the target template version tag you are upgrading to
bash scripts/template-sync.sh --sync v2.1.0
```

What this does internally:
1. Reads `.template-checkpoint.yml` for `last_sync_sha`
2. Calls `template-diff.sh` to compute pristine diff (template@old → template@new)
3. Loads `_genesis/template-manifest.yml` to classify each changed file
4. Applies merge strategy per file:
   - `lineage: template`, user not modified → **auto-take**
   - `lineage: template`, user modified → **CONFLICT** — flags for manual review
   - `lineage: shared`, strategy `section-merge` (e.g., CLAUDE.md) → **section-merge**
   - `lineage: shared`, strategy `3-way-merge` (e.g., settings.json) → **3-way-merge**
   - `lineage: domain-seed` or `domain` → **skip** (your files never touched)
5. Leaves ALL changes unstaged (you review before committing)
6. Logs every action to `.template-sync-log.json`

**Do NOT commit yet** — review in Step C7.

---

### Step C7: Review unstaged changes

```bash
# See everything the sync applied
git diff

# Review files flagged as CONFLICT (template lineage, but you edited them)
# These require manual merge — take template improvements, keep your customizations
git diff -- .claude/rules/    # rules should be pure template — safe to take
git diff -- CLAUDE.md         # section-merge handles this, but verify ## Project is intact
git diff -- .claude/settings.json   # 3-way-merge — verify custom hook paths are present

# Common files safe to take as-is (lineage: template, no project customization):
#   .claude/rules/*      .claude/agents/*      _genesis/frameworks/*
#   _genesis/templates/* scripts/*             rules/*

# Common files that NEED review (lineage: shared):
#   CLAUDE.md            — your ## Project section must be preserved
#   .claude/settings.json — your custom permissions/hook paths must be preserved
#   .gitignore           — your project-specific entries must be preserved
```

---

### Step C8: Run verification sweep

```bash
bash scripts/template-verify.sh
```

`template-verify.sh` runs 6 orthogonal checks:

```
V1  Structural   — validate-blueprint.py (dir existence, file presence, frontmatter)
V2  Hooks        — smoke-test.sh (hook paths resolve, settings.json valid)
V3  Graph        — link-validator.sh + orphan-detect.sh (no broken wikilinks)
V4  Agent        — /dsbv status equivalent check (agent system responds)
V5  Manifest     — template-manifest.sh --audit (ownership coverage 100%, overlaps 0)
V6  Sync         — template-sync.sh --verify (all decisions logged, no unstaged deletes)
```

Exit codes: `0` = all pass | `1` = failures | `2` = error. **Do not proceed if exit code is non-zero.**

If V2 fails: check `.claude/settings.json` for hook paths that went stale after renames.
If V3 fails: run `bash scripts/link-validator.sh` and fix broken `[[wikilinks]]`.
If V5 fails: a file is missing from `_genesis/template-manifest.yml` — add it or flag to template maintainer.

---

### Step C9: Stage and commit

```bash
# Explicit per-file staging (NOT git add -A) — per P6 and git-conventions.md
git add .claude/ _genesis/ scripts/ rules/ CLAUDE.md AGENTS.md GEMINI.md VERSION .gitignore
git commit -m "chore(govern): sync with template v2.1.0"
```

---

### Step C10: Update checkpoint and create PR

```bash
# The sync script updates .template-checkpoint.yml ONLY after verify passes (UBS-07 guard)
# Confirm checkpoint was updated:
grep 'last_sync_sha\|template_version' .template-checkpoint.yml

git push -u origin feat/template-upgrade
gh pr create --base main \
  --title "chore(govern): template upgrade to v2.1.0" \
  --body "Synced with OPS_OE.6.4.LTC-PROJECT-TEMPLATE v2.1.0. template-verify.sh: 6/6 pass."
```

---

## Troubleshooting

**Bootstrap prompt appears unexpectedly**
→ `.template-checkpoint.yml` is missing or `last_sync_sha` is empty. This is expected on first sync after adopting v3.0. Provide the version tag closest to your last manual sync (check `git log --grep="template"` for hints). The script creates the checkpoint and re-enters the diff automatically.

**"merge bucket is large (50+ files)"**
→ Too long since last sync. First pass: check how many are in `lineage: template` with no user modification — those are safe to auto-take. Run `bash scripts/template-check.sh | jq '.merge | length'` to count. Use bootstrap mode to establish checkpoint, then re-run. Incremental syncs going forward will be small.

**"CLAUDE.md section-merge dropped my ## Project section"**
→ Section-merge preserves `user_owned` headings from `template-manifest.yml`. If your heading differs (e.g., `## Project Details` vs `## Project`), the matcher uses `startswith()`. Check manifest entry for CLAUDE.md and confirm your heading matches the `user_owned` list. Restore from backup tag: `git checkout backup/pre-v{X}-upgrade -- CLAUDE.md` and merge manually.

**"settings.json merge lost my custom hooks"**
→ 3-way-merge is used for settings.json. If it produced conflicts, check `git diff HEAD~1 .claude/settings.json`. Your custom hooks should be in the merged output. If lost: restore with `git checkout backup/pre-v{X}-upgrade -- .claude/settings.json`, then manually add the new template hook entries.

**"template-verify.sh V2 fails — broken hook paths"**
→ A template rename moved a hook script. Run:
```bash
jq -r '.. | .command? // empty' .claude/settings.json 2>/dev/null | \
  grep -oE '\./[^ ]+\.sh' | while read s; do
    [[ ! -f "$s" ]] && echo "BROKEN: $s"
  done
```
Update each broken path in `.claude/settings.json` to its new location.

**"Agent doesn't recognize new skills after upgrade"**
→ Each skill needs a `SKILL.md`. Run `ls .claude/skills/*/SKILL.md | wc -l` and compare to template count. If count differs, checkout missing skill dirs from template.

**"I have files the template doesn't have"**
→ Those are DOMAIN lineage files — local-only. `template-check.sh` does not surface them; they are invisible to the diff engine. That is correct behavior (P3).

**"Deprecated file warnings from template-manifest.sh --audit"**
→ Your repo has files listed in `_genesis/template-manifest.yml` §deprecated. These are old template artifacts (e.g., `.claude/commands/`, `_shared/`, `0-GOVERN/`). Delete them — they are not domain content.

---

## Rollback

```bash
# Option 1: Restore a single file
git checkout backup/pre-v{X}-upgrade -- <file>

# Option 2: Discard all migration changes and return to main
git checkout main
git branch -D feat/template-upgrade

# Option 3: Return to pre-migration state
git checkout backup/pre-v{X}-upgrade
git checkout -b recovery/from-failed-migration
```

The `.template-sync-log.json` records every action taken during sync. Use it to trace what changed:

```bash
cat .template-sync-log.json | jq '.[] | select(.action != "skip")'
```

The checkpoint is only updated after `template-verify.sh` exits 0 (UBS-07 guard), so a failed sync leaves the checkpoint pointing to the last known-good SHA.

---

## Links

- [[template-sync]]
- [[template-check]]
- [[template-manifest]]
- [[CLAUDE]]
- [[CHANGELOG]]
- [[alpei-blueprint]]
- [[filesystem-routing]]
- [[versioning]]
- [[workstream]]
