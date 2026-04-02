---
version: "2.0"
last_updated: 2026-04-02
owner: "Long Nguyen"
name: resume
description: Load context from previous sessions saved in the Memory Vault. Use at the start of a new session when you want to pick up where you left off, or when the user says "resume" or "load context". Reads recent session logs from 07-Claude/sessions/ and summarises what was last worked on.
---
# /resume — Load Session Context

Read recent session logs from the Memory Vault to restore context.

**Token budget:** Total /resume output MUST stay ≤5K tokens. This is a hard cap — the old approach (30-40K) burned 15-20% of a 200K Sonnet window on recall alone.

<HARD-GATE>
1. Resolve vault path BEFORE reading sessions — run `source ~/.config/memory-vault/config.sh` or use qmd. If neither works, use absolute path with proper expansion (no tilde in quotes).
2. Do NOT start work or execute tasks before presenting the recall summary and getting user acknowledgment.
</HARD-GATE>

## Sessions directory

Resolve vault path: `source ~/.config/memory-vault/config.sh` then use `$MEMORY_VAULT_PATH`.

`$MEMORY_VAULT_PATH/07-Claude/sessions/`

---

## 2-Pass Resume Protocol

### Pass 1 — Frontmatter Scan (~500 tokens)

Scan frontmatter of the last 3 session files for the current repo. Do NOT read body content.

1. List sessions directory sorted by mtime: `ls -lt "$SESSIONS_DIR" | head -20`
2. Filter for current repo name in filename
3. For the top 3 matches, read ONLY the YAML frontmatter block (from `---` to `---`, typically lines 1-12)
4. Extract from each: `date`, `project`, `goal`, `state`, `open_items`, `next_action`, `outcome`
5. If session files lack rich frontmatter (pre-refactor files), fall back to reading the first 15 lines

**Why frontmatter-first:** Structured metadata + selective loading = 10x cheaper context. Table views (~500 tokens) beat full files (~5K each).

### Pass 2 — Selective Body Load (~2K tokens)

Read the body of the SINGLE most relevant session file (most recent for this repo).

1. Pick the most recent file from Pass 1 that matches the current repo
2. Read the full file (frontmatter + body)
3. This gives the detailed "What was accomplished" and "Key decisions" context

**Total:** ~500 (Pass 1) + ~2K (Pass 2) = ~2.5K tokens typical, ≤5K max.

### Output Format

```
## Resuming from {date}

**Last session:** {goal from frontmatter}
**What was done:** {2-3 bullets from body}
**Current state:** {state from frontmatter}
**Next action:** {next_action from frontmatter}

**Open from last session:**
- {open_item_1}
- {open_item_2}
```

If `open_items` is empty or missing, omit the "Open from last session" section entirely.

Ask: "Ready to continue from here, or load a different session?"

---

## Fallback: Pre-Refactor Session Files

Session files written before 2026-04-02 lack `goal`, `state`, `open_items`, `next_action` frontmatter. For these files:

1. Pass 1: read first 15 lines (frontmatter + start of body) instead of frontmatter-only
2. Pass 2: read full file of most recent match
3. Extract context from body sections ("Current state", "Next action", "Active issues")
4. Output in the same format, best-effort

This fallback ensures backward compatibility while new /compress writes rich frontmatter going forward.

---

## Topic Filtering

If user specifies a topic (e.g. `/resume obsidian`):
1. Filter session filenames for the keyword
2. If no filename matches, scan frontmatter `topics:` field of recent files
3. Apply the same 2-pass protocol to filtered results

---

## Staleness Warning

After presenting the resume output, check the current project's MEMORY.md Briefing Card date. If >7 days old, append:

```
Warning: Memory briefing card is stale — last updated {date} ({N} days ago). Consider running /compress to refresh.
```

---

## Notes

- If no sessions exist: note "No prior sessions found" and proceed
- Session files use v2 schema — frontmatter fields help with filtering; `type` is `session-log` (manual) or `auto-summary` (hook-generated)
- If sessions directory is inaccessible: note it and skip vault step without blocking the session
- `auto-summary` files (from Stop hook) have minimal frontmatter — treat same as pre-refactor fallback

## Gotchas

- **LT-1 False recall:** Agent synthesizes plausible but wrong prior context from filenames alone. Always read the actual session file content, never infer from titles. A file named `2026-03-28-auth-refactor.md` does not mean auth was refactored — read the file.

**GATE — Verify:** Cross-check recalled context against at least 1 source file (session log or MEMORY.md). If any recalled fact cannot be traced to a source, flag it as unverified to the user.

If vault path resolution fails (config missing, directory not found): Do NOT guess a path or fabricate context. Output "Vault unavailable — no prior context loaded" and proceed. Do NOT synthesize plausible prior context from repo state alone.

## Links

- [[gotchas]]
- [[project]]
- [[standard]]
- [[task]]
