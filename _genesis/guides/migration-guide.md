---
version: "2.1"
status: draft
last_updated: 2026-04-11
---

# Migration Guide — ALPEI Project Template

> Your AI agent can execute this guide. Say:
> "Read `_genesis/guides/migration-guide.md` and execute it for my project."

## Which Path?

```
START
  │
  ├─ No existing work? ──────────────────────────→ PATH A (Fresh Clone)
  │                                                  5 min, fully automated
  │
  ├─ Existing work, but NO workstream             PATH B (First Migration)
  │  folders (1-ALIGN/ etc)?  ────────────────────→  30-60 min, agent-guided
  │  (pre-ALPEI or early clone)                      Restructure + template sync
  │
  └─ Already on template (has 1-ALIGN/,           PATH C (Version Upgrade)
     .claude/rules/, _genesis/)?  ────────────────→  15-30 min, template-sync
                                                     Additive sync + merge
```

---

## 10 Migration Principles

These are derived from 4 real migrations (Khang/Assets, Dong/Inflation, Dung/Growth, CamVan/FinancialSystem). Every step in this guide follows them.

```
P1  THREE LINEAGES, NOT TWO
    Every file belongs to exactly one lineage:
      TEMPLATE — from template repo, should be synced
      DOMAIN   — user-created, sacred, never auto-modified
      INHERITED — from early setup / Vinh-seeded, may need cleanup
    Classify BEFORE you act.

P2  STRUCTURE FIRST, CONTENT SECOND
    Directory creation and renames complete BEFORE content merges.
    You cannot merge a file into a directory that doesn't exist yet.

P3  DOMAIN FILES ARE SACRED
    Never auto-modify, overwrite, or delete domain files.
    Move them to the correct location. Suggest updates. Always ask.
    Domain = charter, research, P-pages, code, decisions, OKRs.

P4  TEMPLATE FILES REPLACE, DOMAIN FILES MERGE
    Pure template file (unchanged since clone) → TAKE template version.
    File with domain customizations (CLAUDE.md, settings.json) → MERGE.

P5  INFRASTRUCTURE FIRST, THEN WORKSTREAMS
    Migrate GOVERN (infra: agents, rules, skills, hooks, scripts) first.
    Then workstream folders. In practice, infrastructure is one batch;
    workstream content is verified per-workstream after structure is set.

P6  BRANCH-BASED, CHECKPOINTED
    Always work on a migration branch.
    Tag before starting. Commit after each major step.
    This enables rollback and audit.

P7  VERIFY BEFORE MERGE TO MAIN
    After migration: template-check (structure) + smoke-test (hooks) +
    /dsbv status (agent system). ALL must pass before PR merge.

P8  MIGRATION IS ROUTINE, NOT HEROIC
    Small frequent syncs > big-bang catch-ups.
    If migration takes > 1 hour, you've waited too long between syncs.

P9  AGENT-EXECUTABLE
    Every step in this guide must be executable by an AI agent
    reading top-to-bottom. No ambiguous instructions.

P10 THE CHECKLIST IS THE GUIDE
    Create an i2-migration-checklist.md in _genesis/guides/ for
    your migration. Tick boxes as you go. This IS your audit trail.
```

---

## Path A — Fresh Clone (No Existing Work)

**When:** Starting a new project. No domain content created yet.

```bash
# 1. Create from template
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE

# 2. Clone and verify
git clone https://github.com/Long-Term-Capital-Partners/{YOUR_PROJECT}.git
cd {YOUR_PROJECT}

# 3. Verify template health
./scripts/template-check.sh --quiet

# 4. Open Claude Code
claude
# Then: /dsbv status → should show "no active DSBV cycle"
```

Done. Your repo has the full template. Start with /ltc-brainstorming or /dsbv design align pd

---

## Path B — First Migration (Pre-ALPEI → Current Template)

**When:** Your repo was cloned before the ALPEI template, or cloned early and never adopted the workstream structure. You have domain content in flat directories (`docs/`, `research/`, `src/`) but NOT in `1-ALIGN/`, `2-LEARN/`, etc.

**Real example:** Dung's MACRO-GROWTH repo (cloned 2026-03-24, 12 commits, no workstream structure).

### Pre-Flight Assessment

Before starting, understand what you have:

```bash
# 1. What's in your repo?
git ls-files | head -50
cat VERSION 2>/dev/null || echo "No VERSION file"

# 2. What does the template have? (for comparison)
git remote add template \
  https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git 2>/dev/null
git fetch template main --quiet
comm -12 <(git ls-files | sort) \
         <(git ls-tree -r --name-only template/main | sort) > /tmp/shared-files.txt
comm -23 <(git ls-files | sort) \
         <(git ls-tree -r --name-only template/main | sort) > /tmp/local-only.txt

echo "Shared with template: $(wc -l < /tmp/shared-files.txt) files"
echo "Local-only (your content): $(wc -l < /tmp/local-only.txt) files"
```

**Agent: Classify every file in `/tmp/local-only.txt` as DOMAIN or INHERITED:**
- DOMAIN: files with real project content (research, designs, code, specs, findings, data)
- INHERITED: files from early setup that don't belong — identify by these patterns:
  - ALL_CAPS `.md` files in `_genesis/` or root (e.g., `RULES.md`, `EFFECTIVE_SYSTEM.md`)
  - Skills in `.claude/skills/` not matching template's skill list
  - Root-level `hooks/` directory (should be `.claude/hooks/`)
  - `plugins/memory-vault/` directory (now integrated into template)
  - `_shared/` directory (superseded by `_genesis/`)
  - `0-GOVERN/` directory (not a standard template directory)
  - `scripts/stage-validators/`, `scripts/wms-sync/` (old template layout)

### Step 1: Backup

```bash
git tag backup/pre-migration
git checkout -b feat/template-migration
git push origin backup/pre-migration
```

### Step 2: Add Template Remote

```bash
git remote add template \
  https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git
git fetch template main
```

### Step 3: Remove Old Template Infrastructure

**Before copying new infrastructure, remove stale old-template files that will cause duplicates:**

```bash
# Remove old-structure directories that are superseded in current template
# Only delete these if they exist AND are template artifacts (not domain content)
rm -rf plugins/memory-vault/ 2>/dev/null   # now integrated into .claude/hooks/
rm -rf _shared/ 2>/dev/null                 # superseded by _genesis/
rm -rf 0-GOVERN/ 2>/dev/null               # not a standard template directory
rm -rf hooks/ 2>/dev/null                   # moved to .claude/hooks/
rm -rf scripts/stage-validators/ 2>/dev/null # replaced by new scripts/
rm -rf scripts/wms-sync/ 2>/dev/null        # replaced by skill-based WMS adapters
rm -rf .claude/commands/ 2>/dev/null        # superseded by .claude/skills/

# Remove old skills that don't match current template (v0.3 had 5 skills, current has ~29)
# Agent: compare your .claude/skills/ to template/main's .claude/skills/ and remove non-matching dirs
```

### Step 4: Copy Template Infrastructure

Copy these from `template/main` — these are TEMPLATE lineage files:

```bash
# Agent: for each category below, checkout from template/main
# Use: git checkout template/main -- <path>
# Then unstage: git restore --staged <path>
```

| Category | Source (template/main) | Action |
|---|---|---|
| Agent config | `.claude/agents/` | Copy — replaces any old agents |
| Rules | `.claude/rules/` | Copy — replaces any old rules |
| Skills | `.claude/skills/` | Copy — replaces old skills entirely |
| Hooks | `.claude/hooks/` | Copy — new location (was `hooks/` in old template) |
| Settings | `.claude/settings.json` | Copy (or merge if you have custom permissions) |
| Genesis | `_genesis/` (frameworks, templates, brand, SOPs, guides, training) | Copy |
| Scripts | `scripts/` | Copy — replaces old scripts layout |
| Full-spec rules | `rules/` | Copy |
| Root files | `AGENTS.md`, `GEMINI.md`, `.gitignore`, `.gitleaks.toml` | Copy |
| VERSION | `VERSION` | Copy — then verify it matches the template version you're targeting |
| CLAUDE.md | `CLAUDE.md` | **MERGE** — take template structure, add your project-specific sections |

**CLAUDE.md merge rule:** The template CLAUDE.md has the full structure (Project, Build, Rules, Architecture, etc.). Your project needs project-specific values in the `## Project` section (name, stack, purpose, EO). Take the template version, then edit these fields to describe YOUR project: Name, Stack, Purpose, EO. All other sections should match the template.

### Step 4: Create Workstream Folders

```
1-ALIGN/
  1-PD/  2-DP/  3-DA/  4-IDM/  _cross/
  charter/  decisions/  okrs/
2-LEARN/
  1-PD/  2-DP/  3-DA/  4-IDM/  _cross/
  input/  research/  specs/  output/  archive/
3-PLAN/
  1-PD/  2-DP/  3-DA/  4-IDM/  _cross/
  architecture/  risks/  drivers/  roadmap/
4-EXECUTE/
  1-PD/  2-DP/  3-DA/  4-IDM/  _cross/
  src/  tests/  config/  docs/
5-IMPROVE/
  1-PD/  2-DP/  3-DA/  4-IDM/  _cross/
  changelog/  metrics/  retrospectives/  reviews/
```

Each directory needs a `README.md` (use `./scripts/generate-readmes.py` or copy from template).

### Step 5: Move Domain Content to Correct Workstreams

**This is the critical step.** For each DOMAIN file, determine its correct ALPEI location:

| Content type | Correct location |
|---|---|
| Problem discovery, principles, diagnosis | `2-LEARN/{N}-{SUB}/` or `1-ALIGN/1-PD/` |
| Design specs, architecture | `3-PLAN/{N}-{SUB}/` |
| Source code, scripts, config | `4-EXECUTE/{N}-{SUB}/src/` |
| Test files | `4-EXECUTE/{N}-{SUB}/tests/` |
| Research, findings, learning captures | `2-LEARN/{N}-{SUB}/research/` |
| Charter, OKRs, stakeholders | `1-ALIGN/_cross/` or `1-ALIGN/1-PD/` |
| Decisions, ADRs | `1-ALIGN/_cross/decisions/` |
| Changelog, metrics, retros | `5-IMPROVE/_cross/` |
| Vinh/inherited governance files | **DELETE** (not needed — template provides these) |

**Agent: For each move, use `git mv` to preserve history. Never `cp` + `rm`.**

### Step 6: Clean Up INHERITED Files

Files from Vinh or early setup that are NOT in the template and NOT domain content should be removed. Common inherited files to delete:

- Extra skills not in the template's 28 skill directories
- `RULES.md`, `AGENTS.md` at root if duplicating `.claude/rules/` and `AGENTS.md`
- ALL_CAPS framework files if kebab-case versions exist in `_genesis/frameworks/`
- Stale `.claude/commands/` files (superseded by `.claude/skills/`)
- Old `_shared/` directory (superseded by `_genesis/`)
- Old `0-GOVERN/` directory (not a standard template directory)

### Step 7: Add Frontmatter + Wikilinks

```bash
# Add frontmatter to domain files missing it
./scripts/obsidian-alias-seeder.py

# Add ## Links sections with wikilinks
./scripts/obsidian-autolinker.py
```

### Step 8: Verify and Commit

```bash
# Structural check
./scripts/template-check.sh --quiet

# Vault/hook check
./scripts/smoke-test.sh

# Stage per-category (NOT git add -A — explicit staging per git-conventions)
git add .claude/ _genesis/ scripts/ rules/ CLAUDE.md AGENTS.md GEMINI.md VERSION .gitignore
git add 1-ALIGN/ 2-LEARN/ 3-PLAN/ 4-EXECUTE/ 5-IMPROVE/
git commit -m "feat(all): migrate to ALPEI template structure"
git push -u origin feat/template-migration

# Create PR
gh pr create --base main --title "feat: ALPEI template migration"
```

### Step 9: Post-Merge — Start DSBV

```bash
claude
/dsbv status
```

---

## Path C — Version Upgrade (Already on Template → Newer Version)

**When:** Your repo already has the ALPEI structure (1-ALIGN/, .claude/rules/, _genesis/). You want to pull the latest template improvements.

**Real examples:**
- Khang's Assets repo (v2.0 → latest, incremental 10-day migration)
- Dong's Inflation repo (v2.0 → latest, branch-based 2-day migration)
- Cam Van's Financial System (v1.2 → v2.0, 27-step checklist, gold standard)

### Pre-Migration Audit (CRITICAL — do this FIRST)

This step is what makes the difference between a clean migration and content loss.

**Step C0: Classify your files by lineage**

```bash
# 1. What files exist in BOTH your repo and the template? (potential merge candidates)
git fetch template main
comm -12 <(git ls-files | sort) \
         <(git ls-tree -r --name-only template/main | sort) > /tmp/shared-files.txt

# 2. Of those, which have YOU modified since your last template sync?
#    (These are the danger zone — template changed AND you changed)
while read f; do
  if ! git diff --quiet template/main -- "$f" 2>/dev/null; then
    echo "$f"
  fi
done < /tmp/shared-files.txt > /tmp/merge-candidates.txt

# 3. Of the merge candidates, which did YOU actually edit (vs untouched template copy)?
#    Method: check if your version matches ANY prior template/main commit
#    If it matches a prior template version → you never edited → SAFE to TAKE
#    If it doesn't match any prior template version → you customized → needs MERGE

# Find the last template sync point (look for sync-related commits)
SYNC_SHA=$(git log --oneline --all --grep="template" --grep="sync" --all-match \
  --format="%H" -1 2>/dev/null || echo "")

if [[ -z "$SYNC_SHA" ]]; then
  # Fallback: use git merge-base to find common ancestor with template
  SYNC_SHA=$(git merge-base HEAD template/main 2>/dev/null || echo "")
fi

if [[ -n "$SYNC_SHA" ]]; then
  echo "Last sync point: $SYNC_SHA"
  # Files YOU changed since last sync (these need MERGE, not TAKE)
  git diff --name-only "$SYNC_SHA" HEAD -- $(cat /tmp/merge-candidates.txt) \
    > /tmp/user-customized.txt
  # Files you did NOT change since last sync (safe to TAKE)
  comm -23 /tmp/merge-candidates.txt /tmp/user-customized.txt \
    > /tmp/safe-to-take.txt
  echo "Safe to TAKE (untouched): $(wc -l < /tmp/safe-to-take.txt) files"
  echo "Needs MERGE (you edited): $(wc -l < /tmp/user-customized.txt) files"
else
  echo "WARNING: No sync baseline found. Treating ALL merge candidates as MERGE."
  cp /tmp/merge-candidates.txt /tmp/user-customized.txt
  touch /tmp/safe-to-take.txt
fi

# After migration, record this sync point for next time:
# git rev-parse template/main > .template-sync-version
```

**Agent: Use the classification above to decide per-file:**

- File in `/tmp/safe-to-take.txt` → **TAKE** (untouched template copy, safe)
- File in `/tmp/user-customized.txt` → **MERGE** (user edited, manual review)
- File NOT in `/tmp/merge-candidates.txt` → **SKIP** (domain-only, don't touch)

### Step C1: Backup and Branch

```bash
git tag backup/pre-v$(cat VERSION)-upgrade
git checkout -b feat/template-upgrade
```

### Step C2: Run Template Check

```bash
./scripts/template-check.sh
```

This produces a JSON report with 5 buckets:

```
┌─────────────────────────┬────────────────────────────────────────┐
│ Bucket                  │ What it means                          │
├─────────────────────────┼────────────────────────────────────────┤
│ auto_add                │ New files, safe dirs → auto-add        │
│ flagged.security        │ .env, secrets, keys → NEVER auto-add   │
│ flagged.review_required │ .claude/, _genesis/, scripts/ → review │
│ merge                   │ Both sides changed → needs decision    │
│ unchanged               │ Same content → nothing to do           │
└─────────────────────────┴────────────────────────────────────────┘
```

### Step C3: Auto-Add Safe Files

```bash
./scripts/template-check.sh | jq '.auto_add' | ./scripts/template-sync.sh --auto-add --input -
```

These are new files that don't exist in your repo. Safe to add.

### Step C4: Handle Flagged Files (Review Required)

For `.claude/`, `_genesis/`, `scripts/` — these are TEMPLATE lineage files. Apply the Three-Lineage rule:

**If you never customized the file** (it's identical to the old template version):
```bash
./scripts/template-sync.sh --file <path> --action take
```

**If you customized the file** (added project-specific content):
```bash
# Show the diff first
git diff HEAD template/main -- <path>
# Then manually merge — keep your customizations, take template improvements
```

**Common files that need MERGE (not TAKE):**
- `CLAUDE.md` — has your project-specific `## Project` section
- `.claude/settings.json` — may have custom permissions or hook paths
- `.gitignore` — may have project-specific entries

**Common files safe to TAKE:**
- `.claude/rules/*` — no project-specific content
- `.claude/agents/*` — no project-specific content
- `_genesis/frameworks/*` — template-owned knowledge
- `_genesis/templates/*` — template-owned templates
- `scripts/*` — template-owned tools

### Step C5: Handle Merge Candidates

For each file in the `merge` bucket:

```
(K) Keep local — your version wins
(T) Take template — template version wins
(D) Show diff — see what changed before deciding
(M) Manual merge — take specific sections from each
```

**Decision rule:**
```
Is this file TEMPLATE lineage AND you never edited it?  → T (take)
Is this file TEMPLATE lineage AND you edited it?         → M (merge)
Is this file DOMAIN lineage?                             → K (keep)
```

**Bulk-safe patterns** (if the only diff is `## Links` addition or vocab rename):
```bash
# If the diff is ONLY adding ## Links sections or renaming I0→Iteration 0,
# and you never customized the file — bulk TAKE is safe:
for f in $(cat /tmp/bulk-safe.txt); do
  ./scripts/template-sync.sh --file "$f" --action take
done
```

### Step C6: Post-Sync Cleanup

After template-sync, check for common migration debris:

```bash
# 1. Stale .claude/commands/ (superseded by skills)
find .claude/commands/ -name "*.md" 2>/dev/null

# 2. ALL_CAPS duplicates of kebab-case files in _genesis/
find _genesis/frameworks/ -name "[A-Z_]*.md" 2>/dev/null

# 3. Old structural vestiges (from prior template versions)
#    These are local-only files template-sync can't see
ls -d _shared/ 0-GOVERN/ plugins/memory-vault/ hooks/ \
      scripts/stage-validators/ scripts/wms-sync/ 2>/dev/null

# 4. Nested skill dirs (should be flat under .claude/skills/)
find .claude/skills/ -mindepth 2 -name "SKILL.md" -not -path "*/references/*" 2>/dev/null

# 5. Scripts in wrong location (_genesis/scripts/ should be scripts/)
ls _genesis/scripts/*.sh 2>/dev/null

# 6. Broken wikilinks
./scripts/link-validator.sh

# 7. Orphaned files
./scripts/orphan-detect.sh

# 8. Hook path validation — ensure settings.json paths still resolve
jq -r '.. | .command? // empty' .claude/settings.json 2>/dev/null | \
  while read cmd; do
    script=$(echo "$cmd" | grep -oE '\./[^ ]+\.sh' | head -1)
    [[ -n "$script" && ! -f "$script" ]] && echo "BROKEN HOOK: $script"
  done
```

**Delete any vestiges found above.** These are old template artifacts, not domain content.

### Step C7: Verify

```bash
# 1. Sync completeness (all decisions logged, no deletes, files unstaged)
./scripts/template-sync.sh --verify

# 2. Template alignment
./scripts/template-check.sh --quiet
# Should show: 0 auto_add, 0 flagged, small or 0 merge, high unchanged

# 3. Hook/vault health
./scripts/smoke-test.sh

# 4. Agent system — open Claude Code and test
claude
/dsbv status
```

### Step C7.5: Record Sync Point (for next migration)

```bash
# Save the template commit SHA so the next migration knows the baseline
git rev-parse template/main > .template-sync-version
echo ".template-sync-version" >> .gitignore  # local-only tracking file
```

### Step C8: Commit and PR

```bash
# Stage per-file (NOT git add -A)
git add .claude/ _genesis/ scripts/ rules/ CLAUDE.md VERSION
git commit -m "chore(govern): sync with project template vX.Y"

git push -u origin feat/template-upgrade
gh pr create --base main --title "chore(govern): template upgrade to vX.Y"
```

---

## Optional — Obsidian Workspace + Personal Directories

If using Obsidian as your PKM tool, also create these directories:

```bash
# Personal workspace areas (git-tracked but user-specific content)
mkdir -p PERSONAL-KNOWLEDGE-BASE/{captured,distilled,expressed}
mkdir -p DAILY-NOTES/ MISC-TASKS/ PEOPLE/ inbox/

# Copy Obsidian configuration from template
git checkout template/main -- _genesis/obsidian/ 2>/dev/null
git restore --staged _genesis/obsidian/ 2>/dev/null
```

Skip this if you don't use Obsidian — the core ALPEI structure works without it.

---

## Migration Checklist Template

Copy this to `_genesis/guides/migration-checklist.md` in your project and tick boxes as you go. This is your audit trail.

```markdown
# Migration Checklist — Template vOLD → vNEW

**Branch:** `feat/template-upgrade`
**Backup tag:** `backup/pre-vOLD-upgrade`
**Date started:** YYYY-MM-DD

## Pre-Flight
- [ ] Backup tag created
- [ ] Migration branch created
- [ ] Template remote added and fetched
- [ ] Pre-migration audit completed (three-lineage classification)

## Infrastructure (TEMPLATE lineage)
- [ ] .claude/agents/ updated (see script-registry.md for current count)
- [ ] .claude/rules/ updated
- [ ] .claude/skills/ updated
- [ ] .claude/hooks/ updated
- [ ] .claude/settings.json MERGED (kept custom permissions, added new hook registrations)
- [ ] _genesis/ updated (frameworks, templates, brand, SOPs, guides)
- [ ] scripts/ updated
- [ ] rules/ (full specs) updated
- [ ] CLAUDE.md MERGED (kept ## Project section, took template for all other sections)
- [ ] VERSION bumped
- [ ] .template-sync-version recorded (git rev-parse template/main)

## Structural (if needed)
- [ ] Subsystem folders exist: 1-PD/ 2-DP/ 3-DA/ 4-IDM/ in each workstream
- [ ] _cross/ folders exist where needed
- [ ] No ALL_CAPS duplicates of kebab-case files
- [ ] No stale .claude/commands/ files

## Domain Content
- [ ] All domain files verified untouched (not overwritten by template)
- [ ] Any moved files used git mv (preserves history)
- [ ] Frontmatter valid on all .md files

## Cleanup
- [ ] Inherited/Vinh files removed (if any)
- [ ] Broken wikilinks fixed (link-validator.sh)
- [ ] No orphaned files (orphan-detect.sh)

## Verification
- [ ] template-sync.sh --verify passes 4/4
- [ ] template-check.sh exits 0
- [ ] smoke-test.sh passes 5/5
- [ ] /dsbv status works
- [ ] PR created and reviewed

## Post-Merge
- [ ] Merged to main
- [ ] Backup tag retained for rollback reference
```

---

## Rollback

If something goes wrong at any point:

```bash
# Option 1: Restore a single file
git checkout HEAD -- <file>

# Option 2: Restore everything (discard all migration changes)
git checkout main
git branch -D feat/template-upgrade

# Option 3: Return to pre-migration state
git checkout backup/pre-vX-upgrade
git checkout -b recovery/from-failed-migration

# The .template-sync-log.json records every action — use it to trace
cat .template-sync-log.json | jq '.[] | select(.action != "skip")'
```

---

## Troubleshooting

**"template-check.sh fails to fetch"**
→ Check remote URL: `git remote get-url template`. Should be the LTC-PROJECT-TEMPLATE GitHub URL. Network/auth issues → `gh auth status`.

**"merge bucket is huge (100+ files)"**
→ This means you've fallen far behind. First check: how many are just `## Links` additions? Those are safe to bulk-TAKE if you haven't edited the files. Use the pre-migration audit (Step C0) to identify the safe batch.

**"My CLAUDE.md conflicts with template"**
→ Your `## Project` section wins. Take template's structural sections (Architecture, Rules, DSBV Process, etc.). Your project-specific content is sacred (P3).

**"settings.json merge lost my custom hooks"**
→ Check `git diff HEAD~1 .claude/settings.json`. Your custom hooks should be appended, not replaced. Restore from backup tag if needed.

**"Agent doesn't recognize new skills after migration"**
→ Check `.claude/skills/` directory. Each skill needs a `SKILL.md` file. Run `ls .claude/skills/*/SKILL.md | wc -l` — should match the template count.

**"Vocabulary mismatch (I0 vs Iteration 0 in my files)"**
→ The template standardized to "Iteration 0-4". Your domain files may still say "I0-I4". This is cosmetic for now — update when you next edit those files. Do NOT batch-rename domain content during migration.

**"I have files the template doesn't have"**
→ Those are DOMAIN lineage files. Leave them where they are. template-check doesn't surface them because they're local-only. That's correct behavior.

---

## What Changed — Version History

### v2.0.0 (2026-04-05)
- 5 ALPEI workstreams with subsystem folders (1-PD, 2-DP, 3-DA, 4-IDM)
- 4 MECE agents, 12 always-on rules, 28 skills, 53 scripts
- DSBV workflow with human gates
- Obsidian knowledge graph with wikilinks
- Memory vault + QMD semantic search
- template-check + template-sync tools

### Pre-v2.0 → v2.0 (major changes)
- ALL_CAPS framework files → kebab-case
- `_shared/` → `_genesis/`
- S0/S1/S2/S3 → 1-PD/2-DP/3-DA/4-IDM
- I0-I4 → Iteration 0-4
- `0-GOVERN/` removed (not a standard directory)
- 174 Vinh-seeded governance files → not in template (clean up if present)
- 32 non-standard skills → not in template (clean up if present)
- Blueprint relocated: `1-ALIGN/charter/BLUEPRINT.md` → `_genesis/alpei-blueprint.md`

---

## Links

- [[AGENTS]]
- [[alpei-blueprint]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[agent-system]]
- [[alpei-dsbv-process-map]]
- [[architecture]]
- [[brand-identity]]
- [[charter]]
- [[history-version-control]]
- [[naming-rules]]
- [[project]]
- [[roadmap]]
- [[security]]
- [[versioning]]
- [[workstream]]
