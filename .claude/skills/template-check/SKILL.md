---
name: template-check
version: "2.0"
status: Draft
last_updated: 2026-04-05
description: "Dry-run template sync report. Use when user says: template check, check template, what's new in template, template diff, template status."
agents:
  executor: user-direct
---

# Template Check — Dry-Run Sync Report

Read-only operation. Runs `scripts/template-check.sh` to produce a categorized JSON diff
between the local project and the upstream LTC project template. Presents results to the user.
Does NOT modify any files.

## Workflow

### Step 1: Run the script

```bash
./scripts/template-check.sh [--remote <name>] [--branch <name>]
```

Defaults: `--remote template` `--branch main`. Script will add the remote if missing, fetch,
then compare file trees via `git ls-tree`. Output is JSON to stdout.

If the script exits non-zero (bucket mismatch), stop and report the error to the user.

### Step 2: Parse and present the report

Read the JSON output and render:

```
Template Sync Report (dry-run)
==============================
Remote: template/main

  Auto-addable:             NN files
  Flagged (security):        N files  ← .env*, secrets/**, *.pem, *.key
  Flagged (review-required): N files  ← .claude/**, _genesis/**, scripts/**, etc.
  Merge candidates:          N files
  Already in sync:          NN files

--- Auto-addable ---
  path/to/file1.md
  ...

--- Flagged: security-sensitive (never-auto-add) ---
  .env.example
  secrets/template.json
  ...

--- Flagged: review-required ---
  .claude/rules/new-rule.md
  scripts/dsbv-gate.sh
  ...

--- Merge Candidates ---
  CLAUDE.md (+45 -12 lines vs template)
  ...

Run /template-sync to apply changes.
```

For merge candidates: show a `git diff --stat HEAD template/main -- <file>` line so the
user knows scope before deciding.

### Step 3: Guard on failure

If `git fetch template` fails (auth, network, repo not found): report the error clearly and stop.

## Acceptance Criteria

- AC-1: Script exits 0 and outputs valid JSON with keys: stats, auto_add, flagged, merge, unchanged
- AC-2: Every template file appears in exactly one bucket (self-validated by script)
- AC-3: security-sensitive files (.env*, secrets/**, *.pem, *.key) appear in flagged.security_sensitive, never in auto_add

## Argument

$ARGUMENTS
