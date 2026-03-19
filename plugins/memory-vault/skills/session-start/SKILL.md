---
name: session-start
version: 2.0.0
description: Brief recall at session start. Queries the vault sessions collection for recent context on this repo and outputs a ≤10 line summary. Use at the start of every work session — in any repo — before touching anything.
---

# /session-start — Brief Recall

**Trigger:** User says `"Start session"` (case-insensitive).

**Purpose:** Recall yesterday's context in ≤10 lines. No work begins until recall completes.

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

## Rules

- Output MUST be ≤10 lines total (including ILE appendix if applicable)
- NO standup sections (DONE, BLOCKED, DOING, IN REVIEW, PROPOSED, DISCUSSION)
- NO WMS queries — do not call Notion MCP or Linear API
- NO SPRINT-STATE.md reads
- Do NOT dump raw qmd results — synthesize into the brief format only
- **Formatting:** Plain spaces only for indentation (2 per level). Never use HTML entities.

---

## What NOT To Do

- Do NOT generate a full standup report
- Do NOT query Notion MCP (notion-search, notion-fetch, notion-query-*) during session-start
- Do NOT read SPRINT-STATE.md
- Do NOT output more than 10 lines
- Do NOT start work or execute tasks before recall completes
