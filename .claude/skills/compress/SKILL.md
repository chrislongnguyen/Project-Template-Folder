---
version: "1.1"
status: draft
last_updated: 2026-04-07
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
2. Be concise — body ≤20 lines. Rich context goes in frontmatter fields.
3. Write the file using the Write tool
4. **Extract atomic facts** (mandatory — see Fact Extraction below)
5. **Log recall patterns** (mandatory if auto-injection was active — see Recall Logging below)
6. **Auto-update MEMORY.md Briefing Card** (mandatory — see below)
7. Confirm the file path to the user
8. If obsidian-git is configured, it will auto-commit within 10 minutes

**GATE — Verify:** Session file must have valid YAML frontmatter (date, project, topics, outcome fields present). Read the written file back and confirm all fields are populated. If any field is empty, fix before reporting done.

If file write fails (permission denied, vault path invalid, disk full): Do NOT silently skip. Report the error with the exact path attempted. Offer: (a) retry with corrected path, (b) output the session summary to terminal so user can save manually. Do NOT claim the session was saved.

## Fact Extraction

After writing the session file, extract 5-8 atomic facts and add them as a `facts:` YAML list in the session file's frontmatter.

**Rules:**
- Each fact is exactly 1 sentence, standalone (no pronouns like "this", "the above", "it")
- Each fact should be useful for future recall — decisions, discoveries, patterns, not status updates
- Include entity names (tool names, file paths, concept names) for keyword searchability
- Target: ≤800 tokens total (5-8 facts × ~100 tokens each)

**Why:** QMD indexes these facts as discrete searchable chunks. Without facts, QMD can only match against the session blob.

## Recall Logging

If this session received auto-injected memory context (look for `MEMORY RECALL` in system-reminder tags), log the recall patterns:

1. Read `~/.claude/projects/{project-dir}/memory/recall-patterns.md`
2. Append an entry under `## Entries`:

```yaml
- date: YYYY-MM-DD
  query_keywords: [keywords from prompts that triggered recall]
  injected: [doc titles/paths that QMD returned]
  used: [which injected docs you actually referenced in your responses]
  ignored: [injected minus used]
  session_topic: kebab-case-slug
```

3. If recall-patterns.md doesn't exist or no auto-injection happened, skip this step.

**Why:** This log feeds `/recall-tune` to improve injection precision over time.

## Auto-Update MEMORY.md Briefing Card

After writing the session file, update the active project's MEMORY.md Briefing Card:

1. Find the project's MEMORY.md: `~/.claude/projects/{project-dir}/memory/MEMORY.md`
2. Update the `**Current state ({date}):**` line with today's date and the `state:` value
3. Update `**Active work:**` with a brief summary of what's in progress
4. Do NOT change any other section (Agent Instructions, Topic Index)
5. If MEMORY.md doesn't exist, skip this step

**Why:** Without this, Briefing Cards go stale (measured: 5/6 projects frozen 15+ days).

## Gotchas

- **Vault path not resolved** — always run `source ~/.config/memory-vault/config.sh` first. Never hardcode or guess the path.
- **Topic slug too vague** — "session" or "work" are useless for search. Use 2-4 word kebab-case describing the actual focus.
- **LT-1 Session summary inflation:** Agent invents accomplishments not in the conversation. Verify every bullet against actual tool calls and file edits in this session.
- **open_items must be genuine** — only include items actually discussed and left unresolved. Don't invent speculative open items.

Full list: [gotchas.md](gotchas.md)

## Links

- [[gotchas]]
- [[project]]
- [[session-summary]]
