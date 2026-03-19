---
name: session-end
description: Execute the universal session close protocol when the user says "Session end". Also triggered when an ILE family page is approved ("Approved" or equivalent). Syncs WMS, auto-commits git, asks before push, then saves vault context. Use at the end of every work session in any repo.
---

# /session-end — Universal Session Close

**Trigger:**
- User says `"Session end"` (case-insensitive) — any repo, any family
- User approves a page (`"Approved"` or equivalent) — ILE family only

**Purpose:** Sync all three systems in order — WMS first, git second, vault last. No system left out of sync.

---

## Read Protocol Flags

From the auto-loaded CLAUDE.md:
- `protocol_family`: `ops` | `ile` | `registry` (default: `ops` if absent)
- `wms`: `linear` | `notion` (default: `linear` if absent)
- Detect close type: **page-approved** (ILE + page was approved) or **checkpoint** (no deliverable approved)

---

## Steps (execute in order)

### Step 1 — [ILE, page-approved only] Update A file

Add to the Subject Roadmap (A file):
- **Approved Pages:** `{T{n}.P{m}} — {Page Name} — {YYYY-MM-DD}`
- **Decisions Log:** any D-series decisions made this session
- **Session Log:** session number, date, what was approved, decisions made

**Skip** if: `protocol_family: ops` or `registry`, OR no page was approved this session.

### Step 2 — Update SPRINT-STATE.md

**If `wms: linear`:** Edit SPRINT-STATE.md:
- `Last Session` → what was done this session (date + 1-line summary)
- `Next Action` → next task/issue title

**If `wms: notion`:** Skip — Notion Task Board is the state. No file to update.

**Checkpoint close:** Update `Next Action` only. Do not record completion.

### Step 3 — Sync WMS

**If `wms: linear`:**
- `save_issue`: update status → Done (or In Review if human QA pending)
- `save_comment`: add session comment on the issue

**If `wms: notion`:**
- Update Task Board item status
- Add comment to Task Board item

**Checkpoint close (no deliverable):** Skip status change. No comment needed unless there's something to note.

**WMS comment template — standard close:**
```
**Session closed** — {YYYY-MM-DD}

**Completed:** {task titles, or "none"}
**Decisions:** {D-series IDs + 1-line summary, or "none"}
**Next:** {next task or issue title}
**Blockers:** {description, or "none"}
```

**WMS comment template — ILE page-approved:**
```
**Page Approved** — {YYYY-MM-DD}

**Page:** {T{n}.P{m}} — {Page Name}
**Session:** {n}
**Key decisions:** {D-IDs + 1-line summary, or "none"}
**Next:** {OPS-NN+1} — {next page title}
```

### Step 4 — Git Commit (auto — no confirmation needed)

Stage all changed/new files. Commit immediately — no prompt required. Commit is local and reversible.

**Commit message format:**

OPS family:
```
{type}({scope}): {what was done}

{1-sentence summary}
```

ILE page-approved:
```
feat(phase-c): approve {T{n}.P{m}} {Page Name}

{1-sentence summary of what this page covers}
```

Checkpoint (no deliverable):
```
chore: session checkpoint — {brief description}
```

**SPRINT-STATE.md must be in the same commit as the primary deliverable** — they are one atomic unit.

### Step 5 — Ask Before Push

Present push confirmation and wait for explicit approval:

```
Push {N} file(s) to origin/{branch}?

  {short-hash} {commit message}
  Files: {file1}, {file2}, ...

[Y/n]
```

Wait for `y` / `yes` / `Y`. On `n` or no response: do NOT push. Proceed to Step 7.

### Step 6 — [LEARN-BUILD-ENGINE only] Publish to EFFECTIVENESS

Run `push-engine.md` command to sync build artifacts to the shared engine host (EFFECTIVENESS repo).

**Skip** for all other repos.

### Step 7 — Save Vault Context (always last — mandatory)

Call `/compress` to write the session summary to the Memory Vault.

**Always runs** — even on checkpoint close, even if push was declined. The vault log is the permanent record of the session.

---

## Rules

1. All steps that apply to the current protocol family are mandatory. No partial closes.
2. **WMS sync before git push** — WMS is the operational record; git is the artifact archive. Update in that order.
3. **Do not mark WMS Done** if the user said "In Review" or "needs another look" — use In Review state.
4. **Git commit is automatic** (Step 4). Push requires confirmation (Step 5). These are different actions.
5. **Step 7 (/compress) always runs last**, regardless of whether earlier steps were skipped or push was declined.
