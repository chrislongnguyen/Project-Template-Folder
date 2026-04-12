---
name: template-sync
version: "3.1"
status: draft
last_updated: 2026-04-12
description: "Sync new files from LTC project template. Use when user says: template sync, sync template, pull template, update from template, template update."
agents:
  executor: user-direct
---

# Template Sync — Additive Sync from Project Template

v3.1. Additive-only — adds new files from template, never deletes local files, never silently
overwrites. Merge candidates require explicit user collaboration. All decisions logged to
`.template-sync-log.json`. File ownership sourced from `template-manifest.yml`.

## Migration Paths

Three paths govern how a repo syncs with the template:

| Path | Condition | Primary mode |
|------|-----------|--------------|
| A | Fresh clone (0-1 commits, trivial) | Just commit — no sync needed |
| B | Pre-ALPEI repo (missing `1-ALIGN/` or `.claude/rules/`) | `--reverse-clone` triage first |
| C | Version upgrade (has `.template-checkpoint.yml`) | `--sync <version>` full orchestration |

Detect which path applies before choosing a workflow:

```bash
bash scripts/template-sync.sh --detect-path
```

## Primary Workflow (Path C — Version Upgrade)

This is the standard workflow for repos that were previously cloned from the template.

```bash
# 1. Verify which path applies
bash scripts/template-sync.sh --detect-path

# 2. Run full orchestration sync
bash scripts/template-sync.sh --sync v2.1.0

# 3. Verify post-sync integrity
bash scripts/template-verify.sh
```

**GATE — verify path before proceeding:** Run `--detect-path` and confirm PATH C before
running `--sync`. Do NOT proceed with `--sync` on a PATH B repo — use `--reverse-clone` first.

### `--sync <version>` — Full Orchestration Mode

Implements DESIGN §1.4 steps 1-9 automatically:

1. Reads `.template-checkpoint.yml`. If missing or empty SHA, enters **Bootstrap Mode** (see below).
2. Fetches template remote; resolves target tag SHA.
3. Runs `template-diff.sh --from-sha <last> --to-sha <target>` to compute delta.
4-6. Applies strategy per file:
   - `auto-take` — safe new template files, added directly
   - `section-merge` — structured merge for known sections
   - `3-way-merge` — git merge-style for modified shared files
   - `skip` — files user has customised beyond template baseline
   - `conflict` — flagged for manual resolution
   - `flag-deprecated` — template removed this file; user warned
   All actions logged to `.template-sync-log.json`.
7. Runs `scripts/template-verify.sh` if it exists. If verify FAILS, prints failures and does NOT update the checkpoint.
8. Updates `.template-checkpoint.yml` only after verify passes.
9. Prints commit guidance.

NEVER deletes local files.

### Bootstrap Mode (triggered automatically by `--sync`)

When `--sync` detects no `.template-checkpoint.yml` (or an empty SHA):

1. Prompts: "What version of the template was this repo originally cloned from?"
2. Resolves that version's git tag SHA from the template remote.
3. Writes an initial `.template-checkpoint.yml` with that SHA.
4. Continues with the normal `--sync` steps 2-9.

Bootstrap mode is transparent — it fires inside `--sync` when needed; never invoke separately.

## Path B Workflow — Pre-ALPEI Triage

For repos with severe divergence from the template (missing ALPEI structure):

```bash
# READ-ONLY: classify every tracked file in the old repo
bash scripts/template-sync.sh --reverse-clone /path/to/old-repo > triage.yml
```

Emits a YAML triage manifest. NEVER modifies the source repo. Each file is classified:

| Action | Meaning |
|--------|---------|
| `keep` | Domain file — port to new template clone |
| `manual-merge` | Shared or unknown file — re-apply customisations |
| `replace` | Domain-seed scaffold — replace with your content |
| `skip` | Template file — fresh clone provides this |
| `delete` | Deprecated file — do not port |

After triage: clone a fresh template, then port `keep` + `manual-merge` files into the new clone.

## Legacy Workflow (manual per-file, still supported)

Use when you need fine-grained control instead of full `--sync` orchestration.
Full steps: `references/legacy-workflow.md`

Quick reference:

```bash
# 1. template-check — confirm buckets, wait for user approval before proceeding
./scripts/template-check.sh

# 2. Auto-add safe files
./scripts/template-check.sh | jq '[.auto_add[].path]' | ./scripts/template-sync.sh --auto-add --input -

# 3. Per-file decisions (user approval required for each)
./scripts/template-sync.sh --file <path> --action take
./scripts/template-sync.sh --file <path> --action skip

# 4. Verify — must pass before commit
./scripts/template-sync.sh --verify
bash scripts/template-verify.sh
```

## Acceptance Criteria

- AC-1: No local file is deleted at any point — abort guard enforced in script
- AC-2: auto-add pre-checks for local existence — reclassifies to merge if file exists
- AC-3: All decisions (take/skip/auto_add/reclassify) written to `.template-sync-log.json`
- AC-4: `--verify` exits 0 only when: log exists, has entries, no deletes logged, added files unstaged
- AC-5: `--sync` updates `.template-checkpoint.yml` only after `template-verify.sh` passes
- AC-6: `--detect-path` returns PATH A / PATH B / PATH C and exits 0
- AC-7: `--reverse-clone` is read-only — never modifies the source repo

## Rules

- NEVER delete local files
- NEVER overwrite without explicit approval (even merge candidates)
- NEVER auto-merge — all merge candidates require user decision
- NEVER modify the template remote URL — tell the user to fix manually
- Preserve local .gitignore entries — append template entries, do not replace
- If git fetch fails — report clearly and stop
- `template-manifest.yml` is the authoritative source of file ownership (lineage) — never
  classify files ad-hoc

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

The `.template-sync-log.json` records every action — use it to identify which files to roll back.

## Argument

$ARGUMENTS

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[project]]
- [[template-manifest]]
- [[template-verify]]
