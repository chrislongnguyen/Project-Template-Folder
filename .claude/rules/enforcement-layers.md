---
version: "1.0"
status: draft
last_updated: 2026-04-03
type: always-on rule
---
# Enforcement Layers — Where Rules Live and How They Fire

> 7-CS component definitions: `rules/agent-system.md`
> A rule stated only as documentation is the weakest form. Pair every rule with at least one automated or human-gate layer.

## 4×3 Matrix — Enforcement Coverage

```
                  | Documentation           | Automated Check          | Human Gate
                  | (agent reads)           | (machine runs)           | (human approves)
------------------+-------------------------+--------------------------+------------------------------
Session Load      | .claude/rules/ files    | SessionStart hooks       | —
                  | (EP — always-on rules)  | (.claude/settings.json)  |
------------------+-------------------------+--------------------------+------------------------------
Tool Use          | —                       | PreToolUse / PostToolUse | DSBV phase gates (G1–G4)
                  |                         | hooks + permission modes |
                  |                         | (settings.json)          |
------------------+-------------------------+--------------------------+------------------------------
Commit            | git-conventions.md rule | Pre-commit hooks +       | —
                  | (agent reads on stage)  | template-check.sh,       |
                  |                         | skill-validator.sh       |
------------------+-------------------------+--------------------------+------------------------------
Review            | —                       | CI/CD                    | Code review +
                  |                         | (GitHub Actions)         | DSBV Validate phase
                  |                         |                          | (ltc-reviewer agent)
```

## 7-CS Mapping

| 7-CS Component | Enforcement layer(s) it governs |
|---|---|
| EP  — Effective Principles | Session Load × Documentation (.claude/rules/) |
| EOE — Effective Operating Environment | Session Load × Automated (hooks, permission modes) |
| EOT — Effective Operating Tools | Tool Use × Automated (PreToolUse/PostToolUse) + Commit × Automated (scripts, CI) |
| EOP — Effective Operating Procedures | Tool Use × Human Gate (DSBV G1–G4) + Review × Human Gate (ltc-reviewer) |

## When to Use — "I just created a new rule"

1. Add the rule file to `.claude/rules/` — covers Session Load × Documentation.
2. If the rule guards a tool action (Bash, Write, Edit): add a PreToolUse hook entry in `.claude/settings.json`.
3. If the rule governs file content (versioning, brand): add a check to `scripts/template-check.sh` or a pre-commit hook.
4. If the rule requires human judgment before advancing a DSBV phase: register it as a G1–G4 gate criterion in the relevant DESIGN.md.
5. If the rule should block a PR merge: add a GitHub Actions step under `.github/workflows/`.

## Hook Event Quick-Ref

| Event | Fires when | Typical use | Status |
|---|---|---|---|
| `SessionStart` | Claude Code session opens | Load env context, warm cache, audit config | **Active** (3 hooks) |
| `PreToolUse` | Before any tool call | Block forbidden patterns, enforce naming | **Active** (13 hooks) |
| `PostToolUse` | After any tool call | Log, validate output, trigger follow-on check | **Active** (6 hooks) |
| `SubagentStop` | Sub-agent completes | Audit output, verify chain-of-custody | **Active** (2 hooks) |
| `PreCompact` | Before context compaction | Save state to vault | **Active** (1 hook) |
| `Stop` | Session ends | Summary, PKB ingest reminder, state save | **Active** (3 hooks) |
| `UserPromptSubmit` | User sends a message | Auto-recall injection from QMD | **Active** (1 hook) |

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[VALIDATE]]
- [[agent-system]]
- [[context-packaging]]
- [[documentation]]
- [[git-conventions]]
- [[ltc-reviewer]]
- [[task]]
- [[versioning]]
