# CREATE Flow — Notion Work Planner

Detailed procedure for creating Deliverables, Tasks, and Sub-tasks. Loaded on demand by [SKILL.md](../SKILL.md) in CREATE mode.

---

## Step 0 — Load Context

Execute [SKILL.md Step 0](../SKILL.md) before proceeding. You must have:

- Active project state from MEMORY.md
- 5 most recent items in the target Function (for ID sequence + duplicate check)
- Confirmed Function (asked user if ambiguous)

---

## Step 1 — SCOPE

### 1a — Anti-Bloat Check

Before drafting anything, apply the VANA test to every planned item: if you can't write the Desired Outcome in one sentence, decompose or merge. Search Notion first — if similar work exists, update it instead of creating new.

### 1b — Classify Item Level

```
What is this work?
├─ Time-bound build cycle with coherent Deliverables     → Iteration (Master Plan, parent = Project)
├─ Multi-session, verifiable ACs, user-facing outcome    → Deliverable (Task Board, parent = Iteration)
├─ Discrete action advancing a Deliverable               → Task (must have parent Deliverable)
├─ Single-verb sub-step of a Task                        → Sub-task (must have parent Task)
└─ Single-session, no lasting artefact                    → STOP: don't log
```

### 1c — Determine Function and Sub-scope

Valid Functions: `LTC` · `OPS` · `INV` · `INVTECH` · `COE_EFF` · `COE_TECH`
Valid OPS Sub-scopes: `(core)` · `OPS_PROCESS` · `OPS_HR` · `OPS_IT` · `OPS_INFRA`

If ambiguous — **ask, do not assume**.

---

## Step 2 — DRAFT

For each item, compose all required fields. Load [protocol](./notion-task-protocol.md) sections on demand.

### 2a — Identity

1. **Find next ID** — query Task Board DB for highest existing ID in the target Function. IDs are shared across ALL sub-scopes within a Function. New ID = max + 1.
   - Search: `notion-search` with Function name → extract numeric IDs from Canonical Key values
   - Check ALL sub-scopes (e.g., OPS + OPS_PROCESS + OPS_HR share one sequence)

2. **Canonical Key** — `{SCOPE}_{FA}.{ID}.{NAME-SLUG}` per [protocol §2](./notion-task-protocol.md)

3. **Page Title** — `[{DISPLAY}]_{FA}.{ID}. {Title}` per [protocol §2](./notion-task-protocol.md)

### 2b — VANA + AC

1. **Desired Outcomes** — VANA format per [protocol §4](./notion-task-protocol.md):

   ```
   {User} {Verb} {Adverb} {Noun} that is {Adjective}.
   → Verb: {action} · Adverb: {how} · Noun: {artefact} · Adjective: {quality}
   ```

   Scoped to Item Level: Deliverable = broad outcome, Task = one verb, Sub-task = narrowest.

2. **Acceptance Criteria** — derived from the VANA:
   - `AC-V:` verb verified · `AC-Adv:` quality met · `AC-N:` artefact exists · `AC-Adj:` qualities confirmed

### 2c — Linkage

Set parent relations and dependencies. Mandatory for all levels below Project.

| Item Level      | DB          | Parent Task           | Parent item             | Master Plan Item           |
| --------------- | ----------- | --------------------- | ----------------------- | -------------------------- |
| **Iteration**   | Master Plan | Parent **Project** URL | **Same as Parent Task** | _(empty)_                 |
| **Deliverable** | Task Board  | _(empty)_             | _(empty)_               | Parent **Iteration** URL   |
| **Task**        | Task Board  | Deliverable URL       | **Same as Parent Task** | Inherited from Deliverable |
| **Sub-task**    | Task Board  | Task URL              | **Same as Parent Task** | Inherited from Task        |

- `Parent item` must ALWAYS mirror `Parent Task` — powers Notion's native sub-item nesting
- If dependencies exist → set `Blocked by` / `Blocking` at creation time

### 2d — Body

Apply the page body template matching the Item Level:

- Iteration: [templates/iteration.md](../templates/iteration.md)
- Deliverable: [templates/deliverable.md](../templates/deliverable.md)
- Task: [templates/task.md](../templates/task.md)
- Sub-task: [templates/subtask.md](../templates/subtask.md)

Set all remaining properties per [protocol §3](./notion-task-protocol.md):
- **Always set:** Name, Canonical Key, Item Level, Function, Status, Priority, Owner, Tags (MoSCoW)
- **Conditional:** OPS Sub-scope, Master Plan Item, Parent Task, Parent item, Target Date, Estimate, Blocker fields, **References** (if input docs exist)
- **Never set:** Linear ID, Last Edited Time
- **At completion only:** Artifacts, What Was Delivered (filled when Status → Done, not at creation)

---

## Step 2.5 — PRE-PREVIEW QUALITY GATE

Before showing the preview, verify every item passes these checks. Fix failures inline — do not proceed to Step 3 with known defects.

| #  | Check                          | How to verify                                                         |
| -- | ------------------------------ | --------------------------------------------------------------------- |
| 1  | VANA is one sentence           | Desired Outcome contains exactly one period-terminated sentence       |
| 2  | VANA scoped to Item Level      | Deliverable = broad outcome; Task = one verb; Sub-task = narrowest    |
| 3  | AC-V and AC-N are present      | Both acceptance criteria fields are non-empty                         |
| 4  | Parent linkage resolves         | For Tasks and Sub-tasks: `Parent Task` points to a real, existing page |
| 5  | Canonical Key is unique        | Query DB — no existing entry shares this key                          |
| 6  | Parent item mirrors Parent Task | Both relations contain the same URL                                   |
| 7  | MoSCoW tag set                 | Tags include one of `Must Have` · `Should Have` · `Could Have`        |

If any check fails → fix before proceeding to preview.

---

## Step 3 — PREVIEW (mandatory gate)

Show the full plan before ANY Notion write:

```
Plan Preview — {date}

  DELIVERABLE  [{DISPLAY}]_{FA}.{ID}. {Title} | {Priority} | {Status}
    VANA: {one-sentence desired outcome}
    AC: {AC-V} · {AC-Adv} · {AC-N} · {AC-Adj}
    TASK       [{DISPLAY}]_{FA}.{ID}. {Title} | {Priority}  ← parent: above
    TASK       [{DISPLAY}]_{FA}.{ID}. {Title} | {Priority}  ← parent: above
      SUB-TASK [{DISPLAY}]_{FA}.{ID}. {Title}               ← parent: above

  Linkage: Master Plan Item → {name or "none"}
  Owner: {name} | Function: {function} | IDs: {range}
  Total: {N} items

  Confirm? (yes / revise: <note> / cancel)
```

**Do NOT proceed without explicit "yes" or "approved".**

---

## Step 4 — LOG

Write to Notion via MCP in dependency order (parents first):

1. **Iterations first** (Master Plan DB — they become parents for Deliverables)
2. **Deliverables second** (Task Board DB — set `Master Plan Item` → Iteration URL from step 1)
3. **Tasks third** (set `Parent Task` + `Parent item` → Deliverable URL from step 2)
4. **Sub-tasks last** (set `Parent Task` + `Parent item` → Task URL from step 3)

Each entry uses the page body template for its Item Level.

---

## Step 5 — VALIDATE

After creating all entries, verify per [protocol §8](./notion-task-protocol.md):

- [ ] Canonical Key uniqueness (query DB)
- [ ] Key format: `{SCOPE}_{FA}.{ID}.{NAME-SLUG}`
- [ ] Name prefix matches SCOPE display
- [ ] All select/status values match existing DB options
- [ ] Relations (Parent Task, Parent item, Master Plan Item) point to real pages
- [ ] Parent item mirrors Parent Task (same URL on every Task and Sub-task)
- [ ] Hierarchy: Deliverables have no Parent Task; Tasks → Deliverable; Sub-tasks → Task
- [ ] VANA coherence: one sentence, scoped to Item Level
- [ ] **Completion cascade:** If any created item is `Done`, verify per [protocol §0.5](./notion-task-protocol.md) that all `Must Have` children are resolved

Report: `{N}/{N} items created. Validation: PASS/FAIL`

## Links

- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[blocker]]
- [[deliverable]]
- [[iteration]]
- [[project]]
- [[subtask]]
- [[task]]
