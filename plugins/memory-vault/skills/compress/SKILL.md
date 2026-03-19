---
name: compress
description: Save current session context to the Memory Vault to prevent context rot. Use at the end of any working session, or when the conversation is getting long and you want to preserve state before starting fresh. Writes a compact session summary to 07-Claude/sessions/ in the vault.
---

# /compress — Save Session Context

Resolve vault path: `source ~/.config/memory-vault/config.sh` then use `$MEMORY_VAULT_PATH`.

Write a compact session summary to the Memory Vault at:
`$MEMORY_VAULT_PATH/07-Claude/sessions/YYYY-MM-DD-{topic}.md`

Where `{topic}` is a 2-4 word kebab-case slug describing the session's main focus.

## Summary format

```markdown
---
type: session-log
date: YYYY-MM-DD
project: {canonical-UNG-key}
topics: [{topic-taxonomy-keys}]
outcome: shipped
importance: 3
---

# Session: {topic} — YYYY-MM-DD

## What was accomplished
- [bullet list of completed tasks/decisions]

## Current state
[1-3 sentences describing where things stand right now]

## Active issues
- [Notion issue IDs and titles if relevant]

## Next action
[The single most important next step]

## Key decisions
- [Any architectural or strategic decisions made]

## Files changed
- [Paths to files created or modified]

## Links
- Project: [[{canonical-UNG-key}]]
- Related: [[]]
```

**Field guide:**
- `project`: canonical UNG key of the active repo (e.g. `OPS_OE.6.3.LTC-EXTENSION-REGISTRY`)
- `topics`: 1-3 keys from `topic_taxonomy.json` (e.g. `ai-agent-architecture`, `memory-recall`, `operating-system-design`)
- `outcome`: `shipped` | `progressed` | `blocked` | `explored`
- `importance`: 1-5 (1 = routine, 3 = meaningful, 5 = critical decision)

## Instructions

1. Review the full conversation to extract the above information
2. Be concise — the goal is a 1-page summary an agent can read in seconds
3. Write the file using the Write tool
4. Confirm the file path to the user
5. If obsidian-git is configured, it will auto-commit within 10 minutes
