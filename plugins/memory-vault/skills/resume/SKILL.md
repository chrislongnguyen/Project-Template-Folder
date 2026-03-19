---
name: resume
description: Load context from previous sessions saved in the Memory Vault. Use at the start of a new session when you want to pick up where you left off, or when the user says "resume" or "load context". Reads recent session logs from 07-Claude/sessions/ and summarises what was last worked on.
---

# /resume — Load Session Context

Read recent session logs from the Memory Vault to restore context.

## Sessions directory

Resolve vault path: `source ~/.config/memory-vault/config.sh` then use `$MEMORY_VAULT_PATH`.

`$MEMORY_VAULT_PATH/07-Claude/sessions/`

---

## Mode 1 — Standard Resume (standalone use)

When called directly by the user (`/resume` or "resume" or "load context"):

1. Get recent vault files: `obsidian recents --limit 20 2>/dev/null | grep -v FATAL`
   - Fallback if obsidian unavailable: list `sessions/` directory sorted by mtime
2. If user specifies a topic (e.g. `/resume obsidian`), filter using: `obsidian search query="{topic}" 2>/dev/null | grep -v FATAL`
   - Fallback: filter filenames for keyword
3. Read the most recent 1–3 session files (prioritise by recency + relevance to current task)
4. Output context brief:

```
## Resuming from {date}

**Last session:** {topic}
**What was done:** {2-3 bullets}
**Current state:** {1-2 sentences}
**Next action:** {what was queued}
**Active issues:** {Linear/Notion issue IDs and titles, if any}
```

5. Ask: "Ready to continue from here, or load a different session?"

---

## Mode 2 — [DEPRECATED] Vault Sweep

**Deprecated in v2.0.0.** session-start no longer delegates to resume. It queries the `sessions` qmd collection directly and outputs brief recall (≤10 lines). This mode is retained for reference only.

---

## Notes

- If no sessions exist: note "No prior sessions found" and proceed
- Session files use v2 schema — frontmatter fields (`date`, `project`, `topics`, `outcome`, `importance`) help with filtering; `type` is `session-log` (manual) or `auto-summary` (hook-generated)
- If sessions directory is inaccessible: note it and skip vault step without blocking the session
