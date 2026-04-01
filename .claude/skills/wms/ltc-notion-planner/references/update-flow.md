# UPDATE Flow — Notion Work Planner

Detailed procedure for status transitions and property updates. Loaded on demand by [SKILL.md](../SKILL.md) in UPDATE mode.

---

## Step 1 — Find Target

Locate the entry via `notion-search` by Canonical Key or title. If multiple matches or no match — **ask the user**, do not guess.

---

## Step 2 — Apply Transition

### Status Transition Workflow

Agents follow a strict status progression. The key constraint: **only the user can authorize `Done`**.

```
To Do ──→ In Progress ──→ In Review ──→ Done
 │        (auto: agent      (agent draft    (user approved
 │         starts work)      complete)       only)
 │
 └──→ Blocked (if impediment discovered)
```

| Transition                | Trigger                                   | Agent behavior                                                                                     |
| ------------------------- | ----------------------------------------- | -------------------------------------------------------------------------------------------------- |
| `To Do` → `In Progress`  | Agent begins work on the item             | **Auto-transition.** Notify user: _"Starting work on {item} — moved to In Progress."_ Do not ask. |
| `In Progress` → Blocked  | Impediment discovered                     | Set Blocker + Blocker Solution + Blocked by. Notify user.                                          |
| `In Progress` → In Review | Agent finishes all work / ACs pass       | Keep `In Progress` and ask user for approval (no native In Review status in DB).                   |
| In Review → `Done`       | User says "approved", "yes", "looks good" | Set Status → `Done`, Completed Date = today, **Artifacts** = links to output, fill **"What Was Delivered"** in page body. **Only after explicit user confirmation.** |
| Any → `Canceled`         | User explicitly requests cancellation     | Set Blocker Solution = reason. **Only on user instruction.**                                       |

<aside>
Hard rule: An agent must NEVER mark an item Done without explicit user confirmation. Silence or ambiguity is NOT approval — ask.
</aside>

### Transition Side-Effects

Every transition must apply its mandatory side-effects:

| Transition      | Also set                                                                                                   |
| --------------- | ---------------------------------------------------------------------------------------------------------- |
| → `Blocked`     | **Blocker** (describe impediment) + **Blocker Solution** (proposed fix) + **Blocked by** (if another task) |
| → `Done`        | **Completed Date** = today + **Artifacts** = links to output + fill **"What Was Delivered"** in page body  |
| → `Canceled`    | **Blocker Solution** = reason for cancellation                                                             |
| → `In Progress` | Clear **Blocker** + **Blocker Solution** if previously Blocked                                             |

---

## Step 3 — Completion Cascade Check

Before marking any item `Done`, run the pre-completion checklist per [protocol §0.5](./notion-task-protocol.md):

- [ ] **Query children:** Fetch all direct children of the item from the Task Board.
- [ ] **Filter Must Have:** Identify every child tagged `Must Have`.
- [ ] **All resolved:** Confirm every `Must Have` child has Status = `Done` or `Canceled`.
- [ ] **No open blockers:** No `Must Have` child is in `Blocked` status.
- [ ] **ACs pass:** The item's own Acceptance Criteria all pass.
- [ ] **Artifacts linked:** Artifacts field populated with links to every produced output (Wiki page, git file, skill, etc.).
- [ ] **What Was Delivered filled:** Page body section is no longer the placeholder — it lists actual deliverables with links.
- [ ] **Completed Date set:** Set Completed Date = today.
- [ ] **User approval obtained:** User has explicitly confirmed completion.

<aside>
Hard rule: An agent MUST NOT mark a parent Done if any Must Have child is still in Ideas, To Do, In Progress, or Blocked. Doing so violates the cascade.
</aside>

Items tagged `Should Have` or `Could Have` do **not** block parent completion — they may remain open.

---

## Step 4 — Validate

After applying the update, verify:

- [ ] Status is a valid DB option (`Ideas` · `To Do` · `In Progress` · `Blocked` · `Done` · `Canceled`)
- [ ] All side-effect fields are set correctly
- [ ] Relations still resolve to real pages
- [ ] If Done → completion cascade passes (Step 3)
- [ ] Parent item still mirrors Parent Task

Report: `{item} updated → {new status}. Validation: PASS/FAIL`

## Links

- [[SKILL]]
- [[VALIDATE]]
- [[blocker]]
- [[task]]
