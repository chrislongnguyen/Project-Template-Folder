---
name: legacy-workflow
version: "1.0"
status: draft
last_updated: 2026-04-12
description: "Manual per-file sync workflow for template-sync. Use when fine-grained control is needed instead of full --sync orchestration."
---

# Legacy Workflow — Manual Per-File Sync

Use when you need fine-grained control instead of full `--sync` orchestration, or when
`--sync` cannot be used (e.g., no checkpoint, Path B repo).

## Step 0: Detect stale command files (migration cleanup)

Before syncing, check for `.claude/commands/` files that collide with `.claude/skills/`:

```bash
for cmd in .claude/commands/**/*.md .claude/commands/*.md; do
  [[ -f "$cmd" ]] || continue
  name=$(basename "$cmd" .md)
  if [[ -d ".claude/skills/$name" ]] || find .claude/skills -name "$name" -type d 2>/dev/null | grep -q .; then
    echo "STALE: $cmd → superseded by .claude/skills/$name/"
  fi
done
```

If stale files found: present list, ask user to confirm removal. This is the ONE exception to
the "never delete" rule — these are template artifacts superseded by migration, not user files.

## Step 1: Run template-check first

```bash
./scripts/template-check.sh
```

Present the JSON report (see `/template-check` for display format). Confirm the 4 buckets:
`auto_add`, `flagged.security_sensitive`, `flagged.review_required`, `merge`.

Ask: "Ready to proceed with the sync?" Wait for confirmation before proceeding.

## Step 2: Auto-add safe files

```bash
./scripts/template-check.sh | jq '[.auto_add[].path]' | ./scripts/template-sync.sh --auto-add --input -
```

Script pre-checks each file: if it already exists locally it is reclassified to merge. All added
files are left **unstaged**.

## Step 3: Flagged files (user approval required)

**security-sensitive** (`flagged.security_sensitive`) — permanently blocked from auto-add.
Offer: "Skip all / Handle individually".

**review-required** (`flagged.review_required`) — group by path prefix (`.claude/`, `_genesis/`,
`scripts/`). For each group ask: "Add all / Add individually / Skip all".

```bash
./scripts/template-sync.sh --file <path> --action take
./scripts/template-sync.sh --file <path> --action skip
```

## Step 4: Merge candidates (collaboration required)

For each file in `merge`:

1. Show diff stat: `git diff --stat HEAD template/main -- <file>`
2. Ask: `(K) Keep local   (T) Take template   (D) Show full diff   (M) Manual merge`
3. Execute:
   - K → `./scripts/template-sync.sh --file <path> --action skip`
   - T → `./scripts/template-sync.sh --file <path> --action take`
   - D → `git diff HEAD template/main -- <file>` then re-ask
   - M → show diff, use Edit tool to apply agreed sections

## Step 5: Verify and commit guidance

```bash
./scripts/template-sync.sh --verify
bash scripts/template-verify.sh
```

Both must pass before commit. Print commit guidance on pass:

```
All changes are unstaged. Stage per-file before committing:

  git add <file1> <file2> ...
  git commit -m "chore(govern): sync with project template vX.Y"

Or use /git-save for guided classification.
```

Do NOT use `git add -A` — stage explicitly by filename.
