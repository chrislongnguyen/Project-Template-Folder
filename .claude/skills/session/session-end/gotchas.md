# /session-end — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Pushing without confirmation

**What happens:** Agent auto-pushes after commit without presenting the push confirmation prompt and waiting for explicit "Y". Git commit is automatic; push is NOT.

**How to detect:** Check whether Step 5's `[Y/n]` prompt was displayed AND the user responded with an affirmative before `git push` was called.

**Fix:** Always present the push confirmation block (Step 5) and wait for explicit `y` / `yes` / `Y`. On `n`, no response, or ambiguity: do NOT push. Proceed to Step 7.

---

## 2. Skipping /compress

**What happens:** Agent completes Steps 1-5 but forgets Step 7 (/compress). The vault log is the permanent record — without it, next session has no recall context.

**How to detect:** Check whether `/compress` was called after all other steps completed. It must run even on checkpoint close, even if push was declined.

**Fix:** Step 7 is unconditionally mandatory. Add it as a final checklist item. If the agent reaches the end of the skill without calling `/compress`, the session close is incomplete.

---

## 3. Marking Done when user said In Review

**What happens:** Agent closes the WMS item as "Done" even though the user indicated the work needs review. This falsely signals completion to team members watching the board.

**How to detect:** Check the user's language before updating WMS status. Phrases like "needs review", "needs another look", "not finished", "in review" all indicate the work is NOT done.

**Fix:** Default to "In Review" unless the user explicitly says the work is complete/done. When in doubt, ask. Never upgrade status beyond what the user stated.
