# /ltc-execution-planner — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Generating .exec/ from an unapproved plan

**What happens:** Agent produces task files from a draft plan that hasn't passed the Stage 3 gate. When the plan changes during review, the .exec/ files are invalidated, causing full rework of deliverable and task files.

**How to detect:** Check whether plan.md has a Stage 3 approval marker (frontmatter `status: approved` or explicit human sign-off). If missing, the plan is still draft.

**Fix:** Before generating any .exec/ file, verify the plan has passed Stage 3. If the plan is still in review, stop and tell the user: "Plan must be frozen (Stage 3 approved) before I generate .exec/ files."

---

## 2. Empty placeholder sections in task files

**What happens:** Agent generates the task file structure but leaves Environment, Dependencies, or Scope Exclusions empty with "[TBD]", "TODO", or similar placeholder text. The task executor reads these literally and either skips setup or fails at runtime.

**How to detect:** After generation, grep all .exec/ task files for placeholder patterns: `[TBD]`, `TODO`, `TBA`, `PLACEHOLDER`, or empty sections with only a heading and no content.

**Fix:** Every section in a task file must be filled with concrete values. If a section genuinely has no content (e.g., no dependencies), write "None" with a brief justification (e.g., "None — this task has no external dependencies").

---

## 3. WMS sync before readiness checks

**What happens:** Agent eagerly syncs to WMS (creates tasks in Notion/Linear) before verifying .exec/ quality via the 10-point readiness checklist. When readiness checks then fail, the agent must delete or update WMS items that may have already been assigned to team members.

**How to detect:** Check the generation log — WMS sync should only appear AFTER all 10 readiness checks pass. If `wms-sync` appears before `readiness-check`, the ordering is wrong.

**Fix:** Never trigger WMS sync until all 10 readiness checks exit 0. If readiness checks fail after 3 retries, present the .exec/ files to the Human Director WITHOUT syncing to WMS.

## Links

- [[SKILL]]
- [[deliverable]]
- [[task]]
