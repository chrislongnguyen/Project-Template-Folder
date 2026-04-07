---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: compress
description: "Save current session context to the Memory Vault to prevent context rot.
  Use when the conversation is getting long, at the end of any working session, or
  when you want to preserve state before starting fresh. Writes a compact session
  summary to 07-Claude/sessions/ in the vault."
---
# /compress — Save Session Context

Resolve vault path: `source ~/.config/memory-vault/config.sh` then use `$MEMORY_VAULT_PATH`.

Write a compact session summary to the Memory Vault at:
`$MEMORY_VAULT_PATH/07-Claude/sessions/YYYY-MM-DD-{topic}.md`

Where `{topic}` is a 2-4 word kebab-case slug describing the session's main focus.

<HARD-GATE>
1. Resolve vault path BEFORE writing — run `source ~/.config/memory-vault/config.sh` and verify `$MEMORY_VAULT_PATH` is set. If not, tell user to run `/setup`.
2. Do NOT overwrite an existing session file for the same date+topic without asking the user.
3. Do NOT skip frontmatter fields — all fields (type, date, project, topics, outcome, importance) are mandatory.
</HARD-GATE>

## Summary format

Use the template at [templates/session-summary.md](templates/session-summary.md).

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

**GATE — Verify:** Session file must have valid YAML frontmatter (date, project, topics, outcome fields present). Read the written file back and confirm all fields are populated. If any field is empty, fix before reporting done.

If file write fails (permission denied, vault path invalid, disk full): Do NOT silently skip. Report the error with the exact path attempted. Offer: (a) retry with corrected path, (b) output the session summary to terminal so user can save manually. Do NOT claim the session was saved.

## Gotchas

- **Vault path not resolved** — always run `source ~/.config/memory-vault/config.sh` first. Never hardcode or guess the path.
- **Topic slug too vague** — "session" or "work" are useless for search. Use 2-4 word kebab-case describing the actual focus.
- **LT-1 Session summary inflation:** Agent invents accomplishments not in the conversation. Verify every bullet against actual tool calls and file edits in this session.

Full list: [gotchas.md](gotchas.md)

## Links

- [[gotchas]]
- [[project]]
- [[session-summary]]
