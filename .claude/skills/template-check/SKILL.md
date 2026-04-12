---
name: template-check
version: "3.0"
status: draft
last_updated: 2026-04-12
description: "Dry-run template sync report. Use when user says: template check, check template, what's new in template, template diff, template status."
agents:
  executor: user-direct
---

# Template Check — Dry-Run Sync Report

v3.0. Read-only operation. Runs `scripts/template-check.sh` to produce a categorized JSON diff
between the local project and the upstream LTC project template. Presents results to the user.
Does NOT modify any files.

Each file entry in the JSON output now includes a `lineage` field classifying the file's
ownership. Lineage is sourced from `template-manifest.yml`.

## Workflow

### Step 1: Run the script

```bash
./scripts/template-check.sh [--remote <name>] [--branch <name>] [--quiet]
```

Defaults: `--remote template` `--branch main`. Script will add the remote if missing, fetch,
then compare file trees via `git ls-tree`. Output is JSON to stdout.

If the script exits non-zero (bucket mismatch or usage error), stop and report the error.

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
  path/to/file1.md  [lineage: template]
  ...

--- Flagged: security-sensitive (never-auto-add) ---
  .env.example  [lineage: domain-seed]
  secrets/template.json  [lineage: template]
  ...

--- Flagged: review-required ---
  .claude/rules/new-rule.md  [lineage: template]
  scripts/dsbv-gate.sh  [lineage: shared]
  ...

--- Merge Candidates ---
  CLAUDE.md (+45 -12 lines vs template)  [lineage: shared]
  ...

Run /template-sync to apply changes.
```

For merge candidates: show a `git diff --stat HEAD template/main -- <file>` line so the
user knows scope before deciding.

### Step 3: JSON output format (v3.0)

Each file in every bucket is an object with at minimum `path` and `lineage`:

```json
{
  "stats": {
    "auto_add": 3,
    "flagged_security": 1,
    "flagged_review": 5,
    "merge": 2,
    "unchanged": 47
  },
  "auto_add": [
    {"path": "scripts/new-tool.sh", "lineage": "template"},
    {"path": ".claude/rules/new-rule.md", "lineage": "template"}
  ],
  "flagged": {
    "security_sensitive": [
      {"path": ".env.example", "lineage": "domain-seed"}
    ],
    "review_required": [
      {"path": "scripts/dsbv-gate.sh", "lineage": "shared"}
    ]
  },
  "merge": [
    {"path": "CLAUDE.md", "lineage": "shared"}
  ],
  "unchanged": [
    {"path": "README.md", "lineage": "template"}
  ]
}
```

**Lineage values** (from `template-manifest.yml`):

| Value | Meaning |
|-------|---------|
| `template` | Owned by template — take updates freely |
| `shared` | Shared between template and project — merge carefully |
| `domain-seed` | Template scaffold, meant to be replaced by project content |
| `domain` | Project-owned — template never overwrites |
| `deprecated` | Removed from template — warn user |
| `unknown` | Not in manifest — treat as shared |

### Step 4: Guard on failure

If `git fetch template` fails (auth, network, repo not found): report the error clearly and stop.

Exit codes:
- `0` — success
- `1` — bucket mismatch (internal error)
- `2` — usage error or missing dependency

## Acceptance Criteria

- AC-1: Script exits 0 and outputs valid JSON with keys: stats, auto_add, flagged, merge, unchanged
- AC-2: Every template file appears in exactly one bucket (self-validated by script)
- AC-3: security-sensitive files (.env*, secrets/**, *.pem, *.key) appear in flagged.security_sensitive, never in auto_add
- AC-4: Each file entry in the JSON output includes a `lineage` field
- AC-5: Lineage values are sourced from `template-manifest.yml`

## Post-Sync Verification

After running `/template-sync`, confirm integrity with:

```bash
bash scripts/template-verify.sh
```

`template-verify.sh` is the authoritative post-sync gate. The `/template-check` skill is
pre-sync read-only; `template-verify.sh` is post-sync correctness check.

## Argument

$ARGUMENTS

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[project]]
- [[security]]
- [[template-manifest]]
- [[template-verify]]
