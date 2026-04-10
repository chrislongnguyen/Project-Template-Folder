---
version: "1.0"
last_updated: 2026-03-29
owner: ""
---
> Skill for creating, planning, and updating entries in the LTC Notion Task Board and Master Plan via Notion MCP.

> Covers Projects, Iterations, Deliverables, Tasks, and Sub-tasks. MECE against the full DB schema.

---

## 0 — Hierarchy Model

The system enforces a strict 5-level hierarchy across two Notion databases. Every entry must sit at the correct level.

```
Master Plan DB:
  Project                           ← Item Level = Project (Master Plan entry)
    └─ Iteration                    ← Item Level = Iteration (Master Plan entry, parent = Project)

Task Board DB:
  Deliverable                       ← Item Level = Deliverable, Master Plan Item → Iteration URL
    └─ Task                         ← Item Level = Task, Parent Task → Deliverable URL
        └─ Sub-task                 ← Item Level = Sub-task, Parent Task → Task URL
```

### 0.1 — Level Definitions

| Level           | DB          | Definition                                                                                             | Answers                            | Litmus Test                                                                                                  |
| --------------- | ----------- | ------------------------------------------------------------------------------------------------------ | ---------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Project**     | Master Plan | A time-bound effort toward a strategic goal, composed of multiple Iterations.                          | _"What are we trying to achieve?"_ | Has a clear end-state; spans multiple work cycles.                                                           |
| **Iteration**   | Master Plan | A time-bound build cycle within a Project. Standard names: Iteration 1 Concept, Iteration 2 Prototype, Iteration 3 MVE, Iteration 4 Leadership. Parents its child Deliverables. Iteration's spec = sum of all Deliverable ACs (MECE). Each Iteration gates the next. | _"What does this build cycle deliver?"_ | All child Deliverables together cover the Iteration's scope completely. |
| **Deliverable** | Task Board  | The smallest unit of work that reduces a risk, produces a value, or enables another person.            | _"What did we ship?"_              | Someone outside the team can recognize the outcome. It is **demo-able or verifiable** independently.         |
| **Task**        | Task Board  | A discrete action that advances a single Deliverable. One verb, one owner, completable in one session. | _"What do I need to do next?"_     | Completing it alone doesn't produce standalone value — it only matters in context of its parent Deliverable. |
| **Sub-task**    | Task Board  | An atomic step within a Task — an increment, a blocker resolution, or a documentation update.          | _"What's the single next action?"_ | Cannot be decomposed further. Tagged as Increment, Blocker 🔴, or Documentation.                             |

### 0.2 — Decomposition Rules (for Planning Agents)

When breaking down work, apply this decision tree **top-down**:

1. **Does the work have a strategic goal with multiple independently verifiable outcomes?** → It's a **Project**. Break into Iterations.
2. **Does the work represent a time-bound build cycle with a coherent set of Deliverables?** → It's an **Iteration**. Break into Deliverables.
3. **Does the outcome pass the value test** (reduces a risk, produces a value, or enables another person) **and is independently verifiable?** → It's a **Deliverable**. Break into Tasks.
4. **Is it a single-verb activity that advances a Deliverable, completable in one session?** → It's a **Task**. Break into Sub-tasks only if needed.
5. **Is it an atomic, non-decomposable step?** → It's a **Sub-task**.

<aside>
⚠️

**Decomposition Signals**

</aside>

| Signal                                      | Problem                  | Action                                                  |
| ------------------------------------------- | ------------------------ | ------------------------------------------------------- |
| Deliverable has only 1 Task                 | Task IS the Deliverable  | Merge up — promote Task to Deliverable                  |
| Sub-task spans >1 session                   | Sub-task is too large    | Promote to Task                                         |
| Can't write Desired Outcome in one sentence | Item is too broad        | Decompose to the next level down                        |

<aside>
🔑

**Critical rule:** Deliverables are **planned upfront** as target outcomes, then marked Done when ACs pass. The planning agent creates Deliverables _before_ work starts, then decomposes into Tasks.

</aside>

<aside>
🔗

**Dependency-Driven Ordering:** When decomposing into Tasks (or Sub-tasks), the planning agent must:

1. **Map the dependency chain** — Which items must complete before others can start?
2. **Set Blocked by / Blocking relations at creation time** — Dependencies are planned upfront, not discovered reactively.
3. **Order by dependency** — Independent items first → dependent items in sequence.

Items with no dependencies can be worked in parallel.

</aside>

### 0.3 — Parent Linking Rules

| Item Level      | DB          | Parent Task points to                   | Parent item points to   | Master Plan Item             |
| --------------- | ----------- | --------------------------------------- | ----------------------- | ---------------------------- |
| **Project**     | Master Plan | _(empty — top of hierarchy)_            | _(empty)_               | _(empty)_                    |
| **Iteration**   | Master Plan | Parent **Project** URL                  | **Same as Parent Task** | _(empty)_                    |
| **Deliverable** | Task Board  | _(empty — top of Task Board hierarchy)_ | _(empty)_               | Parent **Iteration** URL     |
| **Task**        | Task Board  | Parent **Deliverable** URL              | **Same as Parent Task** | Inherited from Deliverable   |
| **Sub-task**    | Task Board  | Parent **Task** URL                     | **Same as Parent Task** | Inherited from Task          |

<aside>
🚨

`Parent item` must **ALWAYS** mirror `Parent Task`. This powers Notion's native sub-item nesting. If only `Parent Task` is set, nesting will silently fail.

</aside>

<aside>
🔑

**Deliverable → Iteration link:** Deliverables connect to their parent Iteration through the **Master Plan Item** relation (not Parent Task or Parent item — those stay empty at the Deliverable level).

</aside>

<aside>
🔑

**Iteration → Project link:** Iterations nest under their parent Project via **Parent Task** + **Parent item** (same-DB nesting in Master Plan). Master Plan Item stays empty — it is only for cross-DB links (Task Board → Master Plan).

</aside>

### 0.4 — Naming Convention by Level

| Item Level      | Title pattern                                              | Example                                            |
| --------------- | ---------------------------------------------------------- | -------------------------------------------------- |
| **Project**     | `[SCOPE]_FA. {Code} — {Title}` _(Master Plan, no ID)_     | `[OPS]_OE. DFN — Data Foundation`                  |
| **Iteration**   | `[SCOPE]_FA. {Code} I{N} — {Name}` _(Master Plan, no ID)_ | `[OPS]_OE. DFN Iteration 1 — Concept`                      |
| **Deliverable** | `[SCOPE]_FA.ID. {Code} DEL-{N} · {Title}`                 | `[OPS]_OE.280. DFN DEL-1 · Schema Design`         |
| **Task**        | `[SCOPE]_FA.ID. {Code} D{N} · {Title}`                    | `[OPS]_OE.281. DFN D1 · Define source tables`     |
| **Sub-task**    | `[SCOPE]_FA.ID. {Title}`                                   | `[OPS]_OE.282. Add column constraints`             |

**Cascade:** All five levels share the same SCOPE (`OPS`), FA (`OE`), and project code (`DFN`). Project and Iteration live in Master Plan (no numeric ID). Deliverable, Task, and Sub-task share one sequential ID counter in the Task Board (`280, 281, 282, …`).

- If a title contains `DEL-` → Item Level **must** be `Deliverable`.
- If a title contains `I{N}` at the Project code level → Item Level **must** be `Iteration`.
- If an entry is a direct child of a Deliverable → Item Level **must** be `Task` (not Sub-task).

### 0.5 — Completion Cascade

A parent item is Done **only** when all its `Must Have` children are resolved. This rule applies recursively up the hierarchy.

| Parent Level    | Done when…                                                        |
| --------------- | ----------------------------------------------------------------- |
| **Sub-task**    | Its single Acceptance Criteria passes.                            |
| **Task**        | ALL `Must Have` Sub-tasks are `Done` or `Canceled`.               |
| **Deliverable** | ALL `Must Have` Tasks are `Done` or `Canceled`.                   |
| **Iteration**   | ALL `Must Have` Deliverables are `Done` or `Canceled`.            |
| **Project**     | ALL `Must Have` Iterations are `Done` or `Canceled`.              |

<aside>
🔑

**MoSCoW and completion:** Only items tagged `Must Have` block parent completion. Items tagged `Should Have` or `Could Have` do **not** block — they may remain open when the parent is marked Done.

</aside>

<aside>
🚨

**Hard rule:** An agent MUST NOT mark a parent Done if **any** `Must Have` child is still in `Ideas`, `To Do`, `In Progress`, or `Blocked`. Doing so violates the cascade.

</aside>

**Pre-Completion Verification Checklist**

Before marking any item `Done`, the agent must run this checklist:

- [ ] **Query children:** Fetch all direct children of the item from the Task Board.
- [ ] **Filter Must Have:** Identify every child tagged `Must Have`.
- [ ] **All resolved:** Confirm every `Must Have` child has Status = `Done` or `Canceled`.
- [ ] **No open blockers:** No `Must Have` child is in `Blocked` status.
- [ ] **ACs pass:** The item's own Acceptance Criteria all pass.
- [ ] **Completed Date set:** Set Completed Date = today (per §5 side-effects).
- [ ] **User approval obtained:** User has explicitly confirmed completion (see §5 Agent Transition Workflow).

---

## 1 — When to Act

### CREATE

| Scenario                                                                                            | Item Level                                  |
| --------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| Planning a time-bound build cycle with a coherent set of Deliverables                               | **Iteration**                               |
| Planning a new outcome that passes the value test (reduces risk / produces value / enables someone) | **Deliverable**                             |
| Breaking a Deliverable into discrete action items (one verb, one session)                           | **Task**                                    |
| Decomposing a Task into atomic steps (increment, blocker, or docs)                                  | **Sub-task**                                |
| Single-session batch work with no lasting artefact                                                  | **Don't log** — stays in session transcript |

### UPDATE

| Scenario                                          | Action                                                                                    |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Status changes (started, blocked, done, canceled) | Update **Status** • relevant fields (see §5)                                              |
| Task becomes blocked                              | Set Status → `Blocked`, fill **Blocker** • **Blocker Solution** • **Blocked by** relation |
| Task completed                                    | Set Status → `Done`, set **Completed Date** to today                                      |
| New dependency discovered                         | Set **Blocked by** / **Blocking** relations                                               |
| Scope or priority changes                         | Update **Priority**, **Tags**, or **Desired Outcomes** as needed                          |

---

## 2 — Identity: ID, Canonical Key & Page Title

### 2.1 — Find Next Available ID

Use Notion MCP to search the Task Board for existing entries in the target Function. Extract the numeric ID segment from Canonical Key values. New ID = highest existing ID + 1.

<aside>
⚠️

**IDs are shared across all sub-scopes within a Function.** Check ALL sub-scopes before assigning (e.g., OPS + OPS_PROCESS + OPS_HR share one sequence).

</aside>

### 2.2 — Compose Canonical Key

**Format:** `{SCOPE}_{FA}.{ID}.{NAME-SLUG}`

**SCOPE** — Determined by Function + Sub-scope:

| Function | Sub-scope       | SCOPE code    |
| -------- | --------------- | ------------- |
| OPS      | (core) or blank | `OPS`         |
| OPS      | OPS_PROCESS     | `OPS_PROCESS` |
| OPS      | OPS_HR          | `OPS_HR`      |
| OPS      | OPS_IT          | `OPS_IT`      |
| OPS      | OPS_INFRA       | `OPS_INFRA`   |
| INV      | —               | `INV`         |
| INVTECH  | —               | `INVTECH`     |
| LTC      | —               | `LTC`         |
| COE_EFF  | —               | `COE_EFF`     |
| COE_TECH | —               | `COE_TECH`    |

Full mapping: LTC Naming Convention (Notion Wiki) → Table 3a. Compound scopes (e.g., `COE_EFF`) contain `_` — always match the longest code first.

**FA (Focus Area):** `OE` Operational Excellence · `SA` Strategic Alignment · `PD` People Development · `UE` User Enablement · `CI` Customer Intimacy · `FP` Financial Performance · `CR` Corporate Responsibility · `OTH` Others

**NAME-SLUG rules:**

- ALL CAPS, hyphen-joined
- Keep only `A-Z`, `0-9`, `-`
- Concise but descriptive
- Example: "Vault Auto-Ingestion Pipeline" → `VAULT-AUTO-INGESTION-PIPELINE`

### 2.3 — Compose Page Title

**Format:** `[{SCOPE DISPLAY}]_{FA}.{ID}. {Human-Readable Title}`

**SCOPE → Display Name:**

| SCOPE code    | Display in title |
| ------------- | ---------------- |
| `OPS`         | `[OPS]`          |
| `OPS_PROCESS` | `[OPS PROCESS]`  |
| `OPS_HR`      | `[OPS HR]`       |
| `OPS_IT`      | `[OPS IT]`       |
| `OPS_INFRA`   | `[OPS INFRA]`    |
| `INV`         | `[INV]`          |
| `INVTECH`     | `[INV TECH]`     |
| `COE_EFF`     | `[COE EFF]`      |
| `COE_TECH`    | `[COE TECH]`     |

For SCOPEs not listed: see UNG Table 3a, ClickUp Display column.

**Examples:**

| Canonical Key                     | Name (title)                                     |
| --------------------------------- | ------------------------------------------------ |
| `OPS_OE.165.VAULT-AUTO-INGESTION` | `[OPS]_OE.165. Vault Auto-Ingestion`             |
| `OPS_PROCESS_OE.166.CCU-DEL3-CTX` | `[OPS PROCESS]_OE.166. CCU DEL-3 · Context Mgmt` |
| `INVTECH_UE.5.SECURITY-WATCHLIST` | `[INV TECH]_UE.5. Security Watchlist`            |

---

## 3 — Properties (Full MECE Matrix)

Every property in the Task Board schema is listed below. Nothing is omitted.

### A — Always Set (on CREATE)

| Property          | Type         | Value                                                                                                                                                                    |
| ----------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Name**          | title        | `[{DISPLAY}]_{FA}.{ID}. {Title}`                                                                                                                                         |
| **Canonical Key** | text         | `{SCOPE}_{FA}.{ID}.{NAME-SLUG}`                                                                                                                                          |
| **Item Level**    | select       | `Iteration` · `Deliverable` · `Task` · `Sub-task`                                                                                                                        |
| **Function**      | multi_select | `LTC` · `OPS` · `INV` · `INVTECH` (match existing options)                                                                                                               |
| **Status**        | status       | Set current state (see §5 for valid values)                                                                                                                              |
| **Priority**      | select       | `URGENT` · `HIGH` · `NORMAL` · `LOW` (see §3.1 for execution semantics)                                                                                                  |
| **Owner**         | person       | Notion user ID of the responsible person                                                                                                                                 |
| **Tags**          | multi_select | MoSCoW priority — **Deliverables:** default `Must Have`. **Tasks & Sub-tasks:** always set one of `Must Have` · `Should Have` · `Could Have`. Existing tag options ONLY. |

### B — Conditional (set when the condition is true)

| Property             | Type     | Condition                                     | Value                                                        |
| -------------------- | -------- | --------------------------------------------- | ------------------------------------------------------------ |
| **OPS Sub-scope**    | select   | Function contains OPS                         | `(core)` · `OPS_PROCESS` · `OPS_HR` · `OPS_IT` · `OPS_INFRA` |
| **Master Plan Item** | relation | Known parent project exists                   | Notion page URL of the project                               |
| **Parent Task**      | relation | Item Level = Task                             | URL of parent **Deliverable**                                |
| **Parent Task**      | relation | Item Level = Sub-task                         | URL of parent **Task**                                       |
| **Parent item**      | relation | Item Level = Task or Sub-task                 | **Same URL as Parent Task** — see §0.3                       |
| **Completed Date**   | date     | Status = Done                                 | ISO date (today)                                             |
| **Target Date**      | date     | Deadline is known                             | ISO date                                                     |
| **Estimate**         | number   | Effort is known                               | Hours as number                                              |
| **Sub-task Type**    | select   | Item Level = Sub-task                         | `Increment` · `Blocker 🔴` · `Documentation`                 |
| **Blocker**          | text     | Status = Blocked                              | Description of the impediment                                |
| **Blocker Solution** | text     | Blocker is set                                | Proposed resolution                                          |
| **Blocked by**       | relation | Dependency on another task                    | URL(s) of blocking task(s)                                   |
| **Blocking**         | relation | This task blocks another                      | URL(s) of dependent task(s)                                  |
| **Action Plan**      | text     | Steps are known (especially for Deliverables) | Numbered steps or brief plan                                 |
| **References**       | text     | Input docs exist for this work                | File paths, Notion page URLs, or web links the agent must read before starting. Curated input context — not "everything that might be relevant." |
| **Artifacts**        | text     | Status = Done                                 | Links to what was produced — Wiki/SOP/Guide pages, git file paths, Extension Registry skills. Evidence of completion. |

### C — Recommended (set when information exists)

| Property                | Type | Format                                                                                                    |
| ----------------------- | ---- | --------------------------------------------------------------------------------------------------------- |
| **Desired Outcomes**    | text | See §4 — level-specific VANA format                                                                       |
| **Acceptance Criteria** | text | `AC-V: {verb verified} · AC-Adv: {quality met} · AC-N: {artefact exists} · AC-Adj: {qualities confirmed}` |

### D — Never Set Manually

| Property             | Reason                                           |
| -------------------- | ------------------------------------------------ |
| **Linear ID**        | Only on items migrated from Linear. Leave blank. |
| **Last Edited Time** | Auto-managed by Notion.                          |

### 3.1 — Priority Execution Semantics

Priority determines execution order when multiple items are equally ready (no dependency blockers). This is the agent-driven execution protocol:

| Priority     | Execution Semantics |
| ------------ | ------------------- |
| **URGENT**   | Preempts current work. Engine pauses, switches to this item. Blocker-class. |
| **HIGH**     | Execute first within Iteration. Goes in Wave 1 among equally-ready items. |
| **NORMAL**   | Execute in dependency order. Default. |
| **LOW**      | Execute last or defer. Only if all `Must Have` work complete. |

<aside>
🔑

**Interaction rule:** Dependencies determine WHAT CAN run in parallel. Priority determines WHAT RUNS FIRST among ready items. MoSCoW (Tags) determines WHAT CAN BE SKIPPED.

</aside>

---

## 4 — Desired Outcomes (Level-Specific VANA)

### Format

```
{User/Beneficiary} {Verb} {Adverb} {Noun} that is {Adjective}.
→ Verb: {action} · Adverb: {how/constraint} · Noun: {artefact} · Adjective: {quality}
```

**Line 1** = one plain-English sentence describing the end-state.

**Line 2** = structured VANA decomposition.

### Scoping by Item Level

| Level           | VANA Scope                                                       | Example                                                                          |
| --------------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| **Iteration**   | Build-cycle scope — what this iteration delivers as a whole. Broadest after Project. | `Long has reliably a data acquisition pipeline that is complete and tested.` |
| **Deliverable** | User-facing outcome for the whole deliverable. Broad.            | `Long has reliably an auto-ingestion pipeline that is idempotent and auditable.` |
| **Task**        | One verb — what this task accomplishes toward the Deliverable.   | `Long configures correctly the cron scheduler that is timeworkstream-aware.`           |
| **Sub-task**    | One verb inherited from the parent Task's VANA. Narrowest scope. | `Long validates thoroughly the cron trigger that is deterministic.`              |

<aside>
🔑

**Rule:** If you can't write the Desired Outcome in one sentence, the item is too broad — decompose it.

</aside>

---

## 5 — Status Transitions

Exactly 6 statuses. No others exist in the DB.

| Status        | Group       | Gate / When to set                                                     |
| ------------- | ----------- | ---------------------------------------------------------------------- |
| `Ideas`       | Todo        | Captured but not yet scoped. No VANA required.                         |
| `To Do`       | Todo        | Has VANA+AC. Priority set. Ready to pick up.                           |
| `In Progress` | In Progress | Actively being worked on.                                              |
| `Blocked`     | In Progress | Cannot proceed — **must** set Blocker + Blocker Solution + Blocked by. |
| `Done`        | Complete    | All ACs pass — **must** set Completed Date.                            |
| `Canceled`    | Complete    | Explicitly abandoned — **must** add reason in Blocker Solution.        |

### Transition Side-Effects

| Transition      | Also set                                                                                                   |
| --------------- | ---------------------------------------------------------------------------------------------------------- |
| → `Blocked`     | **Blocker** (describe impediment) + **Blocker Solution** (proposed fix) + **Blocked by** (if another task) |
| → `Done`        | **Completed Date** = today + **Artifacts** = links to produced output + **"What Was Delivered"** section filled in page body |
| → `Canceled`    | **Blocker Solution** = reason for cancellation                                                             |
| → `In Progress` | Clear **Blocker** • **Blocker Solution** if previously Blocked                                             |

### Agent Transition Workflow

Agents follow a strict status progression. The key constraint: **only the user can authorize `Done`**.

```
To Do ──→ In Progress ──→ In Review ──→ Done
 │        (auto: agent      (agent draft    (user approved
 │         starts work)      complete)       only)
 │
 └──→ Blocked (if impediment discovered)
```

| Transition                | Trigger                                      | Agent behavior                                                                                       |
| ------------------------- | -------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `To Do` → `In Progress`  | Agent begins work on the item                | **Auto-transition.** Notify user: _"Starting work on {item} — moved to In Progress."_ Do not ask.   |
| `In Progress` → Blocked  | Impediment discovered                        | Set Blocker + Blocker Solution + Blocked by. Notify user.                                            |
| `In Progress` → In Review | Agent finishes all work / ACs pass           | Transition to `In Review` if status exists. Otherwise keep `In Progress` and ask user for approval.  |
| In Review → `Done`       | User says "approved", "yes", "looks good"    | Set Status → `Done`, Completed Date = today, **Artifacts** = links to output, fill **"What Was Delivered"** in page body. **Only after explicit user confirmation.** |
| Any → `Canceled`         | User explicitly requests cancellation        | Set Blocker Solution = reason. **Only on user instruction.**                                         |

<aside>
🚨

**Hard rule:** An agent must **NEVER** mark an item `Done` without explicit user confirmation. Acceptable confirmations: "approved", "yes", "looks good", "mark it done", or equivalent. Silence or ambiguity is NOT approval — ask.

</aside>

<aside>
⚠️

**In Review note:** The Task Board has 6 statuses (see above) and does not include a native `In Review` status. When the agent completes work, keep the item `In Progress` and message the user: _"Work complete on {item} — all ACs pass. Ready for your review. Approve to mark Done?"_

</aside>

---

## 6 — Page Content Templates

### Iteration — full body required

Set page body using the 🗂️ TEMPLATE — Iteration (VANA+AC) structure.

At minimum: parent Project link, Context, VANA table, AC verification table, child Deliverables list, Dependencies, Action Plan, What Was Delivered.

### Deliverable — full body required

```
## Context
{1-2 sentences: why this deliverable exists and what triggered it}

## Desired Outcomes (VANA)

| Element   | Statement       |
|-----------|-----------------|
| **Verb**      | {action}        |
| **Adverb**    | {how/quality}   |
| **Noun**      | {artefact}      |
| **Adjective** | {qualities}     |

**Full VANA:** {User} {Verb} {Adverb} {Noun} that is {Adjective}.

## Acceptance Criteria Verification

| AC     | Description          | Status      |
|--------|----------------------|-------------|
| AC-V   | {verb criterion}     | PASS / FAIL |
| AC-Adv | {quality criterion}  | PASS / FAIL |
| AC-N   | {artefact exists}    | PASS / FAIL |
| AC-Adj | {quality properties} | PASS / FAIL |

## What Was Delivered
- {Outcome 1}
- {Outcome 2}

## Action Plan
1. {step}
2. {step}
```

### Task — use VANA+AC template

Set page body using the 🗂️ TEMPLATE — Task (VANA+AC) structure.

At minimum: VANA table + AC checklist + Action Plan.

### Sub-task — use Sub-task template

Set page body using the 🗂️ TEMPLATE — Sub-task (VANA+AC) structure.

Must specify Sub-task Type: `Increment`, `Blocker 🔴`, or `Documentation`.

---

## 7 — Edge Cases & Guardrails

### 7.1 — HALT Conditions (never proceed — ask the user)

| Situation                                              | Action                                                 |
| ------------------------------------------------------ | ------------------------------------------------------ |
| Canonical Key already exists in the DB                 | **HALT.** Ask the user.                                |
| Function value not in existing DB options              | **HALT.** New option must be added to DB schema first. |
| SCOPE not found in UNG Table 3a                        | **HALT.** New SCOPE must be added to UNG first.        |
| Agent is unsure about any select/status/relation value | **HALT.** Never guess — ask the user.                  |

### 7.2 — Auto-Correct Rules

| Signal                                           | Action                                                                                   |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------- |
| Entry named `I{N}` at Project code level has Item Level ≠ Iteration | **Reclassify** Item Level → `Iteration`.                                |
| Entry named `DEL-X` has Item Level ≠ Deliverable | **Reclassify** Item Level → `Deliverable`. Reclassify its children from Sub-task → Task. |
| Children of a Deliverable are tagged Sub-task    | **Reclassify** them to `Task`. Sub-tasks can only be children of Tasks.                  |
| Sub-task has no clear type                       | Default to `Increment`.                                                                  |
| OPS entry with no clear sub-scope                | Default to `(core)`.                                                                     |

### 7.3 — Defaults & Limits

| Situation                                            | Action                                                                      |     |
| ---------------------------------------------------- | --------------------------------------------------------------------------- | --- |
| No Master Plan Item exists for this work             | Leave blank — do not create placeholders.                                   |     |
| Name would exceed ~80 characters                     | Abbreviate NAME-SLUG; never abbreviate SCOPE, FA, or ID.                    |     |
| Multiple Deliverables from one session               | Create separate entries, each with unique sequential ID.                    |     |
| Task was done in a previous session but never logged | Set Status = Done, Completed Date = actual date (not today).                |     |
| Deliverable spans multiple Functions                 | Set primary Function; add others via multi_select.                          |     |
| Linking a Task to its parent Deliverable             | Set **both** `Parent Task` AND `Parent item` to the Deliverable's page URL. |     |
| Linking a Sub-task to its parent Task                | Set **both** `Parent Task` AND `Parent item` to the Task's page URL.        |     |

---

## 8 — Post-Creation Validation

After creating any entry, verify **all** of the following:

- [ ] **Uniqueness:** Canonical Key does not duplicate any existing entry (query DB to confirm)
- [ ] **Format:** Key matches `{SCOPE}_{FA}.{ID}.{NAME-SLUG}` exactly
- [ ] **SCOPE valid:** Exists in UNG Table 3a
- [ ] **FA valid:** One of `OE · SA · PD · UE · CI · FP · CR · OTH`
- [ ] **ID sequential:** No gap or collision across all sub-scopes in the Function
- [ ] **Name prefix:** Display prefix in Name matches the SCOPE code
- [ ] **Select/Status values:** All match existing DB options exactly (no typos)
- [ ] **Owner:** Valid Notion user ID
- [ ] **Relations:** Parent Task / Parent item / Master Plan Item / Blocked by / Blocking point to real pages
- [ ] **Parent item mirrors Parent Task:** If Parent Task is set, Parent item must contain the same URL
- [ ] **Hierarchy correct:** Iterations have Parent Task + Parent item → Project (same-DB nesting); Deliverables have Master Plan Item → Iteration (cross-DB, no Parent Task); Tasks point to a Deliverable; Sub-tasks point to a Task
- [ ] **Level definitions respected:** Iteration is a build cycle; Deliverable passes value test; Task is single-verb/single-session; Sub-task is atomic
- [ ] **Dependencies set:** All known Blocked by / Blocking relations populated at creation time (see §0.2)
- [ ] **MoSCoW tag set:** Tags include MoSCoW priority — `Must Have` for Deliverables, explicit choice for Tasks & Sub-tasks
- [ ] **VANA coherence:** Desired Outcomes sentence is grammatically valid and scoped to the Item Level
- [ ] **Template used:** Page body matches the correct template for the Item Level

## Links

- [[AGENTS]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[blocker]]
- [[deliverable]]
- [[documentation]]
- [[increment]]
- [[iteration]]
- [[project]]
- [[schema]]
- [[security]]
- [[standard]]
- [[task]]
