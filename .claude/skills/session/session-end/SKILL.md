---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: session-end
description: Execute the universal session close protocol when the user says "Session end". Also triggered when an ILE family page is approved ("Approved" or equivalent). Syncs WMS, auto-commits git, asks before push, then saves vault context. Use at the end of every work session in any repo.
---
# /session-end — Universal Session Close

**Trigger:**
- User says `"Session end"` (case-insensitive) — any repo, any family
- User approves a page (`"Approved"` or equivalent) — ILE family only

**Purpose:** Sync all three systems in order — WMS first, git second, vault last. No system left out of sync.

<HARD-GATE>
1. WMS sync (Step 3) MUST complete before git push (Step 5). Never reverse this order.
2. Do NOT push to remote without explicit user confirmation (Step 5). Git commit is automatic; push is NOT.
3. Do NOT mark WMS status as "Done" if user said "In Review" or "needs another look" — use In Review.
4. /compress (Step 7) ALWAYS runs last — even on checkpoint close, even if push declined.
</HARD-GATE>

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

Use templates from [templates/wms-comments.md](templates/wms-comments.md).

HARD-GATE: WMS sync (Step 3) must complete before git commit. If WMS sync was skipped due to failure, save payload per Gotchas #5 before proceeding.

### Step 4 — Git Commit (auto — no confirmation needed)

Stage all changed/new files. Commit immediately — no prompt required. Commit is local and reversible.

Use commit message formats from [templates/commit-messages.md](templates/commit-messages.md). SPRINT-STATE.md must be in the same commit as the primary deliverable — they are one atomic unit.

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

**If LEARN-BUILD-ENGINE active:** > Load references/learn-build-engine-close.md

**Skip** for all other repos.

### Step 7 — Save Vault Context (always last — mandatory)

Call `/compress` to write the session summary to the Memory Vault.

**Always runs** — even on checkpoint close, even if push was declined. The vault log is the permanent record of the session.

---

## Gotchas

1. **WMS sync before git push** — WMS is the operational record; git is the artifact archive. Update in that order. Reversing this means a push failure leaves WMS out of sync.
2. **Do not mark WMS Done** if the user said "In Review" or "needs another look" — use In Review state.
3. **Git commit is automatic** (Step 4). Push requires confirmation (Step 5). These are different actions. Do not conflate them.
4. **Step 7 (/compress) always runs last**, regardless of whether earlier steps were skipped or push was declined.
5. **WMS sync failure** — If Notion API is unreachable during session-end, do NOT block the session close. Save the sync payload to `_pending_sync.json` in the project root and warn the user. The next session-start should check for and retry pending syncs.
6. **LT-1 Phantom completion** — Agent claims WMS was updated and commit succeeded without actually running the commands. Every step must produce observable output (commit hash, WMS response, file path). If a step produces no output, it did not execute — re-run it.

**GATE — Verify:** After Step 7, confirm the session file was written by reading it back. Run `git status` and confirm no uncommitted changes remain. If uncommitted changes exist, warn user before completing.

If git commit fails (hook rejection, merge conflict, empty commit): Do NOT retry silently. Report the exact error. Offer: (a) fix the issue and re-commit, (b) skip commit and proceed to push check, (c) abort session-end. Do NOT force-commit or skip hooks.
