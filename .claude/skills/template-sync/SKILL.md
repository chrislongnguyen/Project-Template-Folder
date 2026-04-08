---
name: template-sync
version: "2.1"
status: draft
last_updated: 2026-04-06
description: "Sync new files from LTC project template. Use when user says: template sync, sync template, pull template, update from template, template update."
agents:
  executor: user-direct
---

# Template Sync — Additive Sync from Project Template

Additive-only — adds new files from template, never deletes local files, never silently overwrites.
Merge candidates require explicit user collaboration. All decisions logged to `.template-sync-log.json`.

## Workflow

### Step 0: Detect stale command files (migration cleanup)

Before syncing, check for `.claude/commands/` files that collide with `.claude/skills/`:

```bash
# Find command files that have a matching skill (stale duplicates from pre-I2 migration)
for cmd in .claude/commands/**/*.md .claude/commands/*.md; do
  [[ -f "$cmd" ]] || continue
  name=$(basename "$cmd" .md)
  if [[ -d ".claude/skills/$name" ]] || find .claude/skills -name "$name" -type d 2>/dev/null | grep -q .; then
    echo "STALE: $cmd → superseded by .claude/skills/$name/"
  fi
done
```

If stale files found, present the list and ask:
> "These command files are duplicates of skills that were migrated in I2. The duplicate can cause autocomplete issues. Remove them? (Y/n)"

On yes: `rm` each stale file. On no: skip with warning that autocomplete may behave unexpectedly.

This is the ONE exception to the "never delete" rule — these are not user files, they are template artifacts from a prior version that were superseded, not modified.

### Step 1: Run template-check first

```bash
./scripts/template-check.sh
```

Present the JSON report to the user (see `/template-check` for display format). Confirm the
4 buckets: auto_add, flagged.security_sensitive, flagged.review_required, merge.

Ask: "Ready to proceed with the sync?" Wait for confirmation.

### Step 2: Auto-add safe files

Pipe the `auto_add` array from the JSON into the sync script:

```bash
./scripts/template-check.sh | jq '.auto_add' | ./scripts/template-sync.sh --auto-add --input -
```

Script pre-checks each file: if it already exists locally it is reclassified to merge (Fix #4).
All added files are left **unstaged**. Print the summary from script stdout.

### Step 3: Flagged files (user approval required)

**security-sensitive** (`flagged.security_sensitive`) — present each file, explain it is
permanently blocked from auto-add (contains or resembles secrets). Offer: "Skip all / Handle individually".

**review-required** (`flagged.review_required`) — group by path prefix (.claude/, _genesis/, scripts/).
For each group ask: "Add all / Add individually / Skip all".

For individual approval:
```bash
./scripts/template-sync.sh --file <path> --action take
./scripts/template-sync.sh --file <path> --action skip
```

### Step 4: Merge candidates (collaboration required)

For each file in `merge`:

1. Show diff stat: `git diff --stat HEAD template/main -- <file>`
2. Ask:
   ```
   (K) Keep local   (T) Take template   (D) Show full diff   (M) Manual merge
   ```
3. Execute:
   - K → `./scripts/template-sync.sh --file <path> --action skip`
   - T → `./scripts/template-sync.sh --file <path> --action take`
   - D → `git diff HEAD template/main -- <file>` then re-ask
   - M → show diff, use Edit tool to apply agreed sections

### Step 5: Verify and commit guidance

```bash
./scripts/template-sync.sh --verify
```

On 4/4 pass, print commit guidance:

```
All changes are unstaged. Stage per-file before committing:

  git add <file1> <file2> ...
  git commit -m "chore(govern): sync with project template vX.Y"

Or use /git-save for guided classification.
```

Do NOT use `git add -A` — stage explicitly by filename to avoid accidentally including
unrelated changes or sensitive files.

## Acceptance Criteria

- AC-1: No local file is deleted at any point — abort guard enforced in script
- AC-2: auto-add pre-checks for local existence — reclassifies to merge if file exists
- AC-3: All decisions (take/skip/auto_add/reclassify) written to `.template-sync-log.json`
- AC-4: --verify exits 0 only when: log exists, has entries, no deletes logged, added files unstaged

## Rules

- NEVER delete local files
- NEVER overwrite without explicit approval (even merge candidates)
- NEVER auto-merge — all merge candidates require user decision
- NEVER modify the template remote URL — tell the user to fix manually
- Preserve local .gitignore entries — append template entries, do not replace
- If git fetch fails — report clearly and stop

## Rollback

If a file was incorrectly added or overwritten:

```bash
# Restore a single file to HEAD
git checkout HEAD -- <file>

# Restore multiple files to HEAD
git checkout HEAD -- <file1> <file2>

# Stash all unstaged changes (safe — does not delete)
git stash push -u -m "rollback template-sync"
# To recover: git stash pop
```

The `.template-sync-log.json` records every action taken — use it to identify which files to roll back.

## Argument

$ARGUMENTS

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[project]]
