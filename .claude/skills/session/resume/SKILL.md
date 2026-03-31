---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: resume
description: Load context from previous sessions saved in the Memory Vault. Use when starting a new session and you want to pick up where you left off, or when the user says "resume" or "load context". Reads recent session logs from 07-Claude/sessions/ and summarises what was last worked on.
---
# /resume — Load Session Context

Read recent session logs from the Memory Vault to restore context.

<HARD-GATE>
1. Resolve vault path BEFORE reading sessions — run `source ~/.config/memory-vault/config.sh` or use qmd. If neither works, use absolute path with proper expansion (no tilde in quotes).
2. Do NOT start work or execute tasks before presenting the recall summary and getting user acknowledgment.
</HARD-GATE>

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

**GATE — Verify:** Cross-check recalled context against at least 1 source file (session log or MEMORY.md). If any recalled fact cannot be traced to a source, flag it as unverified to the user.

If vault path resolution fails (config missing, directory not found): Do NOT guess a path or fabricate context. Output "Vault unavailable — no prior context loaded" and proceed. Do NOT synthesize plausible prior context from repo state alone.

## Gotchas

- **LT-1 False recall:** Agent synthesizes plausible but wrong prior context from filenames alone. Always read the actual session file content, never infer from titles. A file named `2026-03-28-auth-refactor.md` does not mean auth was refactored — read the file.
