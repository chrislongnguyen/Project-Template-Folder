---
description: Enforcement layers — 4x3 matrix of documentation, automated checks, and human gates
globs: "**"
---

# Enforcement Layers

Full spec: `.claude/rules/enforcement-layers.md`

## 4×3 Matrix

```
                  | Documentation       | Automated Check         | Human Gate
------------------+---------------------+-------------------------+---------------------
Session Load      | .claude/rules/ files| SessionStart hooks      | —
Tool Use          | —                   | PreToolUse/PostToolUse  | DSBV stage gates G1-G4
Commit            | git-conventions.md  | Pre-commit hooks +      | —
                  |                     | template-check.sh       |
Review            | —                   | CI/CD (GitHub Actions)  | Code review + Validate
```

## Hook Types (29 total)

| Event | Count | Typical use |
|-------|-------|-------------|
| `SessionStart` | 3 | Load env context, warm cache, audit config |
| `PreToolUse` | 13 | Block forbidden patterns, enforce naming, DSBV guard |
| `PostToolUse` | 6 | Log, validate output, ripple-check |
| `SubagentStop` | 2 | Audit builder output, verify subsystem chain |
| `PreCompact` | 1 | Strategic compact warning |
| `Stop` | 3 | PKB lint, ingest reminder, state save |
| `UserPromptSubmit` | 1 | Auto-recall injection from QMD |

## Key Automated Checks

| Script | Fires when | Enforces |
|--------|-----------|----------|
| `dsbv-skill-guard.sh` | Write/Edit to workstream dir | No Build without DESIGN.md |
| `status-guard.sh` | Pre-commit | Block `status: validated` by agent |
| `link-validator.sh` | Pre-commit | No broken [[wikilinks]] |
| `registry-sync-check.sh` | Pre-commit | Version registry matches frontmatter |
| `dsbv-gate.sh` | Pre-commit | Chain-of-custody (N-1 validated) |

## Rule: Tier Priority

`hooks > scripts > rules > skills` — a hook ALWAYS overrides a rule or skill instruction.

## Links

- [[enforcement-layers]]
- [[DESIGN]]
- [[task]]
- [[versioning]]
