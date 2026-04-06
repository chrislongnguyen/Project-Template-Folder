---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: hooks
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
---

# Hooks in Skills and Agents

> Skills and subagents can define their own hooks in YAML frontmatter — the hooks are active only while the component is active and cleaned up automatically when it finishes.

## L1 — Knowledge

### So What? (Relevance)

Settings-file hooks are always-on. Skill/agent hooks scope enforcement to a specific workflow without polluting global config. LTC's EOP-GOV pattern — where skills enforce their own pre/post conditions — maps directly to this. A security-review skill, for example, can attach a `Stop` hook that validates findings before the skill exits.

### What Is It?

Hooks defined in the `hooks:` frontmatter of a skill (SKILL.md) or subagent file. They use the identical configuration format as settings-based hooks but are registered for the component's lifetime only.

### What Else?

- All 26 hook events are supported in frontmatter
- For subagents: `Stop` hooks are automatically converted to `SubagentStop` (the event that fires when a subagent completes)
- `once: true` field: run the handler only once per session then remove it (skills only, not agents)
- Frontmatter hooks merge with user/project settings hooks during the component's active period
- Hooks are cleaned up automatically when the skill/agent finishes — no manual teardown

### How Does It Work?

Skill frontmatter example:
```yaml
---
name: secure-operations
description: Perform operations with security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
---
```

Agent frontmatter uses the same format. The `hooks:` key is a standard hooks block — identical to what you'd put in `settings.json`, just nested under the skill/agent's YAML frontmatter.

**`once: true` field:**
```yaml
hooks:
  SessionStart:
    - hooks:
        - type: command
          command: "echo 'Skill activated'"
          once: true
```
Fires the first time then self-removes for the session. Useful for one-time setup on skill invocation.

**Where hooks appear in `/hooks` menu:**
- Source label: `Session` (registered in memory for the current session)
- Distinguishable from `User`, `Project`, `Local`, `Plugin`, `Built-in` sources

## L2 — Understanding

### Why Does It Work?

Claude Code's hook system is session-scoped internally. Skills register hooks into the session's hook registry when activated and deregister them when done. This is the same mechanism that makes async hooks and `once: true` work — hooks are not static; they are managed dynamically per session.

### Why Not?

- `once: true` is skills-only — not supported in agent frontmatter
- Subagent `Stop` → `SubagentStop` conversion is automatic but can be confusing when debugging — the event that fires is `SubagentStop`, not `Stop`
- Skill hooks are visible in `/hooks` as `Session` source but cannot be edited there (read-only menu)
- Skill hook commands run in the session's working directory — ensure absolute paths or `$CLAUDE_PROJECT_DIR` references

## Sources

- captured/claude-code-docs-full.md (lines 12907-12944)

## Links

- [[hooks-lifecycle]]
- [[hook-input-output]]
- [[claude-md-files]]
