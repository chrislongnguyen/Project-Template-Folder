# UPDATE Flow — ClickUp Work Planner

Detailed procedure for status transitions, completion cascade checks, and field updates. Loaded on demand by [SKILL.md](../SKILL.md) in UPDATE mode.

---

## Step 1 — FIND

Locate the item(s) to update:

1. **Search by name** — `clickup_search` with the item name or partial match
2. **Search by ID** — `clickup_get_task` with the ClickUp task ID
3. **Browse hierarchy** — `clickup_filter_tasks` within the target List

If multiple matches found -> show them to the user and ask which one.
If no match found -> **HALT**, ask user to clarify.

---

## Step 2 — TRANSITION

### 2a — Status Transitions

| From (exact ClickUp value) | To (exact ClickUp value) | Who | Conditions |
|---|---|---|---|
| `draft` | `draft completed` | Agent | VANA + AC custom fields + parent linkage all set |
| `draft completed` | `ready/prioritized` | User | User approves the scope |
| `ready/prioritized` | `in progress` | Agent/User | Work has started |
| `in progress` | `review` | Agent | Work complete, ready for review |
| `review` | `done` | User | All ACs pass, user approves |
| `review` | `do again (review failed)` | User/Reviewer | Review found issues |
| `do again (review failed)` | `in progress` | Agent | Rework started |
| `in progress` | `blocked` | Agent/User | Dependency unmet |
| `blocked` | `in progress` | Agent/User | Blocker resolved |
| Any | `cancelled` | User | No longer needed |

**Agent guardrails:**
- Agent can auto-transition: `draft` → `draft completed`, `ready/prioritized` → `in progress`, `in progress` → `review`, `in progress` → `blocked`
- Agent MUST NOT transition to `done` or `cancelled` without explicit user approval
- When transitioning to `review`: add a comment summarizing what was done
- Use exact status strings above — ClickUp is case-sensitive

### 2b — Field Updates

When updating fields:
- **Name changes** at Project/Deliverable level must maintain UNG compliance
- **Priority changes** should be announced to the user
- **Assignee changes** must resolve to real ClickUp members
- **Time estimate updates** are expected as work progresses

---

## Step 3 — CASCADE CHECK

Before marking any item Done, run the completion cascade per [protocol §0.6](./clickup-task-protocol.md):

### 3a — Query Children

```
1. Get all subtasks of the item being marked Done
2. Filter for items with MoSCoW dropdown = "Must Have"
3. Check each Must Have child's status
```

### 3b — Verify Resolution

| Child Status | Blocks parent Done? |
|---|---|
| `done` | No (resolved) |
| `cancelled` | No (resolved) |
| `draft` / `draft completed` / `ready/prioritized` / `in progress` / `review` / `blocked` / `do again (review failed)` | **YES — blocks** |

### 3c — Decision

- **All Must Have children resolved** -> proceed to mark parent Done
- **Any Must Have child unresolved** -> **HALT**. Report which children block completion:

```
Cannot mark "{Parent Name}" as Done.

Unresolved Must Have children:
  - {Child Name} — Status: {status}
  - {Child Name} — Status: {status}

Action needed: Complete or cancel these items first.
```

### 3d — Completion Actions

When marking an item Done:
1. Check all AC boxes in the description (set Status to Pass/Fail)
2. Add a completion comment: "Completed on {date}. {brief summary of what was delivered}."
3. If the item is a PJ Increment: verify PJ Documentation child exists

---

## Step 4 — VALIDATE

After the transition, verify:

- [ ] Status is correct on the updated item
- [ ] If Done: all Must Have children are resolved
- [ ] If Done: AC checkboxes are checked in description
- [ ] If Done: completion comment added
- [ ] If Blocked: blocker reason noted in comment
- [ ] Parent-child relationships still intact
- [ ] No orphaned items

Report: `Updated {item name} -> {new status}. Validation: PASS/FAIL`

## Links

- [[SKILL]]
- [[VALIDATE]]
- [[blocker]]
- [[clickup-task-protocol]]
- [[deliverable]]
- [[documentation]]
- [[increment]]
- [[project]]
- [[task]]
