---
last_updated: 2026-03-29
owner: "Long Nguyen"
name: session-start
version: 2.0.0
description: "[DEPRECATED] Use /resume instead. This skill is retained for reference only. Session startup context is now handled by the SessionStart hook (resume-check.sh) + /resume skill."
---
# /session-start — Brief Recall

**Trigger:** User says `"Start session"` (case-insensitive).

**Purpose:** Recall yesterday's context in ≤10 lines. Do NOT proceed with any work until recall completes.

<HARD-GATE>
1. Do NOT start work or execute any tasks before recall completes and is presented.
2. Do NOT query Notion MCP, Linear API, or read SPRINT-STATE.md during session-start.
3. Output MUST be ≤10 lines. No standup sections (DONE, BLOCKED, DOING, etc.).
4. Do NOT dump raw qmd results — synthesize into the brief recall format only.
</HARD-GATE>

---

## Protocol Flags (from CLAUDE.md)

- `protocol_family`: `ops` | `ile` | `registry` (default: `ops`)

---

## Steps

### Step 1 — Find recent session for this repo

Query the `sessions` collection for the current repo:
- Tool: qmd MCP or Bash — `qmd query -c sessions "{repo-name}" -n 3`
- Pick the most recent result matching the current repo (by filename or `project` frontmatter)
- Read that session file. Extract: what was accomplished, current state, next action, active issues.

**Fallback** (if qmd unavailable or returns no results): list the vault sessions directory (resolve via: `source ~/.config/memory-vault/config.sh` → `$MEMORY_VAULT_PATH/07-Claude/sessions/`) by mtime, grep for repo name, read most recent match. If inaccessible, proceed without vault context.

### Step 2 — [ILE only] Load ILE context

**Skip if `protocol_family: ops` or `registry`.**

- Read Subject Roadmap (A file) — path in CLAUDE.md §2
- Read last approved page (from A file "Last approved page")
- Read `engine/rules/cross-book-integrity.md` (once per session)

Extract: last approved page ID, next page title, branch name, sprint info.

### Step 3 — Output brief recall

Output this format (≤10 lines total, plain text, plain spaces for indentation):

```
RECALL — {repo-name}
  Last ({date}): {1-line summary of what was accomplished}
  State: {1-line current state}
  Next: {next action}
  Issues: {active issue IDs + titles, or "none"}
```

**ILE only** — append (still within ≤10 lines):
```
  Last approved: {T{n}.P{m}} — {Page Name} [{date}]
  Next up: {OPS-NN} — {next page title}
  Branch: {branch name}
```

If no prior session found:
```
RECALL — {repo-name}
  No prior sessions found. Ready to work.
```

---

## Gotchas

- qmd may be unavailable — always implement the Bash fallback path
- ILE context step is skipped for `ops` and `registry` protocols — do not load ILE files for those
- Output must stay at or under 10 lines — truncate rather than overflow

## Formatting

- Plain spaces only for indentation (2 per level). Never use HTML entities.

Do NOT proceed until recall output is presented to the user.

---

## Post-Output Verification

**GATE — Verify:** Check that MEMORY.md Briefing Card "Current state" date is within 14 days. If stale (>14 days), warn user: "Memory briefing card is stale — last updated [date]. Update after this session."

If qmd query returns results that don't match the current repo (wrong project name, different context): Do NOT use them. Discard and fall back to directory listing. Do NOT blend context from a different project into the recall output.

- **LT-1 Cross-project contamination:** Agent loads a session log from a different project with a similar name and presents it as this project's context. Always verify the `project` frontmatter field matches the current repo's UNG key before using any session file.

## Links

- [[CLAUDE]]
- [[gotchas]]
- [[project]]
