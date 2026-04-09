---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
> Protocol for creating, planning, and updating entries in the LTC ClickUp workspace via ClickUp MCP.

> Covers PJ Projects, PJ Workstreams, PJ Deliverables, Tasks, PJ Increments, PJ Documentation, and PJ Blockers. MECE against the ClickUp task type model.

---

## 0 — Hierarchy Model

The system enforces a strict 6-level hierarchy using ClickUp task types within a single List. Every entry must use the correct task type and sit at the correct level.

```
List (e.g., Process-related Execution):
  PJ Project                              ← task_type: PJ Project (top-level)
    └─ PJ Workstream                      ← task_type: PJ Workstream (iteration: Iteration 1/Iteration 2/Iteration 3/Iteration 4)
        └─ PJ Deliverable                 ← task_type: PJ Deliverable (parent = PJ Workstream)
            └─ Task                       ← task_type: null (built-in default, NOT "Task")
                ├─ PJ Increment           ← task_type: PJ Increment (parent = Task)
                ├─ PJ Documentation       ← task_type: PJ Documentation (parent = Task, 1 per Task)
                └─ PJ Blocker             ← task_type: PJ Blocker (parent = Task, created reactively)
```

### 0.1 — Level Definitions

| Level | Task Type | Definition | Answers | Litmus Test |
|---|---|---|---|---|
| **PJ Project** | `PJ Project` | A body of work toward a strategic or operational goal, composed of multiple Deliverables. | _"What are we building?"_ | Has a clear end-state; spans multiple work cycles. |
| **PJ Workstream** | `PJ Workstream` | An iteration phase that groups Deliverables by VANA pillar scope. Maps 1:1 to DELIVERY PHASE (Iteration 1=Concept, Iteration 2=Prototype, Iteration 3=MVE, Iteration 4=Leadership). Houses all Deliverables whose primary ACs belong to this iteration. | _"Which iteration does this belong to?"_ | Maps to exactly one Delivery Phase. Contains 1+ Deliverables. |
| **PJ Deliverable** | `PJ Deliverable` | A verifiable user-facing outcome. You can **demo** it. | _"What can the user do now that they couldn't before?"_ | Someone outside the team can recognize the outcome. Independently verifiable. |
| **Task** | `null` (built-in default, `custom_item_id: 0`) | A coherent unit of engineering work that advances one Deliverable. You can **review** it. Contains Increments (the work), optionally Blockers (impediments), and one Documentation (the reference). "Task" does not exist as a named custom type — use the built-in default. | _"What technical capability was built?"_ | Completing it alone doesn't produce standalone value — it matters in context of its parent Deliverable. |
| **PJ Increment** | `PJ Increment` | The smallest unit of work that creates verifiable value. You can **test** it. | _"What passes its acceptance criteria right now?"_ | All tests pass. One logical layer of work. |
| **PJ Documentation** | `PJ Documentation` | Reference doc for the parent Task's subsystem. One per Task. | _"How do I use/verify what was built?"_ | Reference doc, API doc, or runbook covering the Task's scope. |
| **PJ Blocker** | `PJ Blocker` | An impediment preventing progress. Created reactively by agent or user. | _"What is blocking us?"_ | Something external or discovered that must be resolved before work can continue. |

### 0.2 — MECE Sum Chain

```
Task children:  PJ Increment(s) + PJ Documentation (1) + PJ Blocker(s) (0..N, reactive)
                ├─ Increments ∑= the reviewable capability (the work)
                ├─ Documentation = the reference for this capability
                └─ Blockers = impediments (resolved or cancelled to unblock)

Task             ∑= PJ Deliverable (all capabilities = the demo-able outcome)
PJ Deliverable  ∑= PJ Workstream  (all outcomes in this iteration)
PJ Workstream   ∑= PJ Project     (all iterations = the shippable project)
```

Every level is MECE: Mutually Exclusive (no overlap) and Collectively Exhaustive (no gaps). If Increments don't sum to their parent Task, there's a gap. If Tasks don't sum to their parent Deliverable, decomposition is incomplete. Blockers are reactive (not planned upfront) and don't affect MECE completeness.

### 0.3 — Decomposition Rules

When breaking down work, apply this decision tree **top-down**:

1. **Does the work have a strategic goal with multiple independently verifiable outcomes?** → It's a **PJ Project**. Break into PJ Deliverables.
2. **Does the outcome pass the value test** (demo-able, user-facing) **and is independently verifiable?** → It's a **PJ Deliverable**. Break into Tasks.
3. **Is it a coherent technical capability that advances a Deliverable, reviewable as a unit?** → It's a **Task**. Break into PJ Increments. Add 1 PJ Documentation.
4. **Is it the smallest unit that creates verifiable value (testable)?** → It's a **PJ Increment**.
5. **Is something blocking progress?** → Create a **PJ Blocker** under the blocked Task.

| Signal | Problem | Action |
|---|---|---|
| Deliverable has only 1 Task | Task IS the Deliverable | Merge up — promote Task to Deliverable |
| Increment spans >1 logical layer | Increment is too large | Split by logical layer |
| Can't write Desired Outcome in one sentence | Item is too broad | Decompose to the next level down |
| Task has no PJ Documentation | Missing reference | Add one Documentation child |

**Grouping rule:** Group Increments by **logical layer**, not by file. Each Increment represents a coherent deliverable layer (e.g., "Storage Layer", not "storage.py").

### 0.4 — Parent Linking Rules

ClickUp uses native subtask nesting. Every item (except the top-level PJ Project) must have a parent.

| Item Level | Parent points to | How to set |
|---|---|---|
| **PJ Project** | _(no parent — top of hierarchy)_ | Created as root task in List |
| **PJ Workstream** | PJ Project | Created as subtask of PJ Project |
| **PJ Deliverable** | PJ Workstream | Created as subtask of PJ Workstream |
| **Task** | PJ Deliverable | Created as subtask of PJ Deliverable |
| **PJ Increment** | Task | Created as subtask of Task |
| **PJ Documentation** | Task | Created as subtask of Task (sibling of Increments) |
| **PJ Blocker** | Task | Created as subtask of Task (sibling of Increments, reactive) |

**Dependency ordering:** When Increments or Tasks have dependencies, set `Blocked by` / `Blocking` relations at creation time using `clickup_add_task_dependency`.

### 0.5 — Naming Convention by Level

UNG applies at PJ Project and PJ Deliverable levels. Task and below use free text.

| Level | UNG Form | Name Pattern | Example |
|---|---|---|---|
| **PJ Project** | 2-part | `[SCOPE]_FA.ID. PROJECT NAME` | `[OPS]_OE.6.4. LTC Project Template` |
| **PJ Deliverable** | 3-part | `[SCOPE]_FA.ID. PROJECT NAME_D{n}. DELIVERABLE NAME` | `[OPS]_OE.6.4. LTC Project Template_D3. Manager` |
| **Task** | Free text | Descriptive name of technical capability | `Core CRUD + Hybrid Search` |
| **PJ Increment** | Free text | Descriptive name of testable unit | `Embedder Interface + Local Backend` |
| **PJ Documentation** | Free text | `{Subsystem} Reference` | `Manager API Reference` |
| **PJ Blocker** | Free text | Short description of the impediment | `ClickUp MCP search limitations` |

**3-part naming for Deliverables:** The parent project's identity is embedded in the Deliverable name. This provides context when viewing Deliverables outside their parent hierarchy (e.g., in flat search results or reports).

### 0.6 — Completion Cascade

A parent item is Done **only** when all its `Must Have` children are resolved. This rule applies recursively up the hierarchy.

| Parent Level | Done when... |
|---|---|
| **PJ Increment** | Its acceptance criteria pass. |
| **Task** | ALL `Must Have` children (Increments + Blockers) are `done` or `cancelled`. PJ Documentation exists. |
| **PJ Deliverable** | ALL `Must Have` Tasks are `done` or `cancelled`. |
| **PJ Workstream** | ALL `Must Have` PJ Deliverables are `done` or `cancelled`. |
| **PJ Project** | ALL `Must Have` PJ Workstreams are `done` or `cancelled`. |

**MoSCoW and completion:** Only items with MoSCoW dropdown = `Must Have` block parent completion. `Should Have` and `Could Have` items may remain open when the parent is marked Done.

**Blockers and completion:** An unresolved PJ Blocker (status not `done` or `cancelled`) under a Task blocks that Task from being marked Done, regardless of MoSCoW.

**Hard rule:** An agent MUST NOT mark a parent Done if **any** `Must Have` child is still in `draft`, `draft completed`, `ready/prioritized`, `in progress`, `review`, `blocked`, or `do again (review failed)`.

**Pre-Completion Verification Checklist:**

Before marking any item Done, the agent must:
1. Query all children of the item
2. Filter for `Must Have` MoSCoW dropdown value + all PJ Blockers
3. Verify each is `done` or `cancelled`
4. If ANY is unresolved → **HALT**, do not mark parent Done
5. Add a completion comment summarizing what was delivered

---

## 1 — ClickUp Workspace Location & Discuss-Before-Write Rule

| Level | Where |
|---|---|
| Workspace | LTC ALL |
| Space | LTC EXEC OPS (or relevant Space per Function) |
| Folder | OPS PROCESS > PROCESS MATTERS (or relevant Folder) |
| List | Process-related Execution (or relevant List) |

**Discuss-Before-Write Rule (mandatory):**

Before writing ANYTHING to ClickUp, the agent MUST:
1. **Draft the full plan on screen** in Claude Code (preview format from create-flow Step 3)
2. **Ask the user** which List to append to. The user may provide:
   - A List name (e.g., "Process-related Execution")
   - A parent task name (e.g., "put it under OE.6 MAINTAIN EFFECTIVE OPERATIONAL PROCESSES")
   - A screenshot of the ClickUp hierarchy
   - Or say "create a new List under [Folder]"
3. **Confirm the exact placement** before any `clickup_create_task` call

**Never assume the List.** Even if context suggests a likely List, confirm with the user. The cost of asking is low; the cost of creating items in the wrong List is high (items must be manually moved, custom fields may differ).

---

## 2 — Identity & Naming

### 2.1 — UNG Canonical Key

Every PJ Project and PJ Deliverable has a Canonical Key per `rules/naming-rules.md`:

**PJ Project (2-part):** `{SCOPE}_{FA}.{ID}.{NAME}`
**PJ Deliverable (3-part):** `{SCOPE}_{FA}.{PARENT_ID}.{PARENT_NAME}_{ITEM_ID}.{ITEM_NAME}`

### 2.2 — ClickUp Display Name

Render the Canonical Key to ClickUp format per naming rules Section 3:

**PJ Project:** `[SCOPE DISPLAY]_FA.ID. Project Name`
**PJ Deliverable:** `[SCOPE DISPLAY]_FA.ID. Project Name_D{n}. Deliverable Name`

### 2.3 — Task and Below

Free text. No UNG prefix required. Use clear, descriptive names.

---

## 3 — Required Fields

### 3.1 — Fields by Level

| Field | PJ Project | PJ Workstream | PJ Deliverable | Task | PJ Increment | PJ Documentation | PJ Blocker |
|---|---|---|---|---|---|---|---|
| Name | UNG 2-part | Free text (I{n} format) | UNG 3-part | Free text | Free text | Free text | Free text |
| Task Type | PJ Project | PJ Workstream | PJ Deliverable | Task | PJ Increment | PJ Documentation | PJ Blocker |
| Status | Required | Required | Required | Required | Required | Required | `blocked` |
| Priority | Required | Required | Required | Required | Required | Optional | Match parent |
| Assignee | Required | Required | Required | Required | Required | Optional | Required |
| DESIRED OUTCOMES | VANA | VANA (scoped to iteration pillar) | VANA | VANA | VANA | — | — |
| ACCEPTANCE CRITERIA | ACs | ACs owned by this iteration | ACs | ACs | ACs | — | — |
| MoSCoW (dropdown) | Required | Required | Required | Required | Required | — | Must Have |
| DoD (custom field) | Optional | Optional | Required | Required | — | — | — |
| DELIVERY PHASE | — | Required (Iteration 1→1.CONCEPT, Iteration 2→2.PROTOTYPE, Iteration 3→3.MVE, Iteration 4→4.LEADERSHIP) | — | — | — | — | — |
| Description | Overview + scope | Deliverables table + owned AC IDs + I/O contracts | Tasks + deps | Increments + files | Steps | Content/link | Context + evidence |
| BLOCKER(S) | — | — | — | — | — | — | What + why |
| SOLUTION FOR BLOCKER | — | — | — | — | — | — | Resolution plan |
| Time Estimate | — | — | — | — | Required | — | — |
| Parent | — | PJ Project | PJ Workstream | PJ Deliverable | Task | Task | Task |

**Critical: VANA and ACs go in dedicated custom fields, NOT in the description.** See [field-map.md](./clickup-field-map.md) for exact field IDs.

### 3.2 — Status Workflow

| Status (exact ClickUp value) | Meaning | Who transitions |
|---|---|---|
| `draft` | Created but not yet scoped | Agent or user |
| `draft completed` | Fully scoped, ready for review | Agent |
| `ready/prioritized` | Approved, ready to pick up | User |
| `in progress` | Actively being worked on | Agent or user |
| `review` | Work complete, awaiting review | Agent |
| `do again (review failed)` | Review found issues, needs rework | User/reviewer |
| `done` | All ACs pass, verified | User approval required |
| `blocked` | Cannot proceed, dependency unmet | Agent or user |
| `cancelled` | No longer needed | User |

**Agent auto-transitions:** `draft` -> `draft completed`, `ready/prioritized` -> `in progress`, `in progress` -> `review`.
**User-only transitions:** -> `done` (requires explicit approval), -> `cancelled`.

**Important:** Use exact status strings above when calling `clickup_update_task`. ClickUp is case-sensitive on status values.

### 3.3 — Priority

| Priority | Meaning |
|---|---|
| Urgent | Drop everything. Must complete ASAP. |
| High | Complete before Normal items in the same sprint. |
| Normal | Standard execution order. |
| Low | Nice to have. Complete when capacity allows. |

### 3.4 — MoSCoW Classification (Custom Field Dropdown)

MoSCoW is a **dropdown custom field** (`🌐 RISK-BASED IMPORTANCE (MoSCoW)`, field ID `1da92ea7`), NOT a ClickUp tag.

| Option | Meaning | Blocks parent completion? |
|---|---|---|
| Must Have | Required for the parent to be Done | **Yes** |
| Should Have | Important but not blocking | No |
| Could Have | Nice to have, lowest priority | No |
| Won't Have | Explicitly excluded from scope | No |

---

## 4 — VANA Integration

### 4.1 — Desired Outcomes (Custom Field)

Every item (except PJ Documentation) must have a Desired Outcome in VANA format in the **custom field `🌐 DESIRED OUTCOMES (Objectives)`** (field ID `a382a103`). **NOT in the description.**

Format for the custom field value:
```
{User} {Verb} {Adverb} {Noun} that is {Adjective}.

→ Verb: {action}
→ Adverb: {how} (S: {sustainability} · E: {efficiency} · Sc: {scalability})
→ Noun: {artefact}
→ Adjective: (S: {sustainability} · E: {efficiency} · Sc: {scalability})
```

### 4.2 — VANA Cascade Model

| Level | VANA Scope | AC Ownership |
|---|---|---|
| **PJ Project** | Full VANA — all ACs across all pillars | Owns ALL ACs |
| **PJ Workstream** | Iteration-scoped VANA | Iteration 1: Verb + Noun + Sustainability(Adv+Adj). Iteration 2: Efficiency(Adv+Adj). Iteration 3+Iteration 4: Scalability(Adv+Adj) + Spawned + Hardening |
| **PJ Deliverable** | Subset of parent Workstream's ACs | Lists specific AC IDs from parent |
| **Task** | Subset of parent Deliverable's ACs | Lists specific AC IDs |
| **PJ Increment** | Individual AC(s) from parent Task | Owns 1-3 specific ACs — the testable unit |

**Rules:**
- "Adverbs are aggregated — one set of S/E/Sc Adverbs applies to ALL Verbs (not per-verb)."
- "Adjectives are qualities OF the Noun — one set of S/E/Sc Adjectives shared."
- "When summing child ACs upward, they must MECE back to the parent's AC set."
- "Agent extracts Project VANA from the implementation plan. Human reviews at Project + Workstream + Deliverable level. Task/Increment cascade mechanically."

**VANA test:** If you can't write the Desired Outcome in one sentence, the item is too broad — decompose it.

### 4.3 — Acceptance Criteria (Custom Field)

Derived from the VANA sentence, placed in the **custom field `🌐 ACCEPTANCE CRITERIA (Key Results)`** (field ID `b74bfd0e`). **NOT in the description.**

Format at Project level:
```
Verb ACs:
- [ ] Verb-AC1: {criteria}
Sustainability Adverb ACs (Iteration 1):
- [ ] SAdv-AC1: {criteria}
Efficiency Adverb ACs (Iteration 2):
- [ ] EAdv-AC1: {criteria}
Scalability Adverb ACs (Iteration 3):
- [ ] ScAdv-AC1: {criteria}
Noun ACs:
- [ ] Noun-AC1: {criteria}
Sustainability Adjective ACs (Iteration 1):
- [ ] SAdj-AC1: {criteria}
Efficiency Adjective ACs (Iteration 2):
- [ ] EAdj-AC1: {criteria}
Scalability Adjective ACs (Iteration 3):
- [ ] ScAdj-AC1: {criteria}
```

At child levels, show ownership trace:
```
Owns (from {parent_name}):
- [ ] Noun-AC3: {specific criteria at this level}
```

When marking Done, each AC box must be explicitly checked (Pass/Fail).

---

## 5 — Description Templates

**Important:** VANA and ACs go in their dedicated custom fields (§4), NOT in the description. The description (native field) contains only implementation details, links, and scope information.

See detailed templates at [templates/](../templates/). Summary:

### 5.1 — PJ Project Description

Overview, scope (in/out), deliverables table (name, tasks, est., MoSCoW), key decisions, references, resource summary.

```
## Input Contract
| From | Schema |
|---|---|
| Spec/Plan | {spec documents, implementation plan files received} |

## Output Contract
| To | Schema |
|---|---|
| End users / dependent systems | {finished system interfaces, deliverables produced} |
```

### 5.2 — PJ Workstream Description

Deliverables table (name, tasks, est., MoSCoW), owned AC IDs for this iteration, notes.

```
## Input Contract
| From | Schema |
|---|---|
| {predecessor Workstream or "External/Plan"} | {data types, interfaces, files received} |

## Output Contract
| To | Schema |
|---|---|
| {successor Workstream(s) or consumer} | {data types, interfaces, files produced} |
```

### 5.3 — PJ Deliverable Description

Tasks table (name, increments, est., MoSCoW), dependencies, notes.

```
## Input Contract
| From | Schema |
|---|---|
| {predecessor Deliverable or "External/Plan"} | {data types, interfaces, files received} |

## Output Contract
| To | Schema |
|---|---|
| {successor Deliverable(s) or consumer} | {data types, interfaces, files produced} |
```

### 5.4 — Task Description

Increments table (name, est., MoSCoW), files to create/modify.

```
## Input Contract
| From | Schema |
|---|---|
| {predecessor Task or parent Deliverable} | {data types, interfaces, files received} |

## Output Contract
| To | Schema |
|---|---|
| {successor Task(s) or parent Deliverable} | {data types, interfaces, files produced} |
```

### 5.5 — PJ Increment Description

Numbered implementation steps, time estimate.

```
## Input Contract
| From | Schema |
|---|---|
| {predecessor Increment or parent Task} | {data types, interfaces, files received} |

## Output Contract
| To | Schema |
|---|---|
| {successor Increment(s) or parent Task} | {data types, interfaces, files produced} |
```

### 5.6 — PJ Documentation Description

What it covers, file location/URL, contents outline.

### I/O Contract Rules

- For PJ Project: Input = spec/plan. Output = finished system.
- For dependent items: Output of predecessor = Input of successor.
- When an Output→Input chain exists between items, a `waiting_on` dependency MUST be set.

### Other Task Types

**PJ Blocker** and **PJ Bug** are utility task types that exist in the workspace but are not part of the planning hierarchy. The planner does not create them — they are created reactively when blockers or bugs are discovered during execution. If encountered during queries, treat them as peer items alongside PJ Increments.

---

## 6 — Dependency Management

### 6.1 — Setting Dependencies

Use `clickup_add_task_dependency` at creation time when:
- An Increment cannot start until another Increment completes
- A Task cannot start until another Task completes
- A Deliverable cannot start until another Deliverable completes
- A Workstream cannot start until another Workstream completes

Set dependencies at **ALL levels** — Workstream, Deliverable, Task, AND Increment — wherever an Input/Output contract chain exists.

### 6.2 — Dependency Rules

- Dependencies are **planned upfront**, not discovered reactively
- Independent items can be worked in parallel
- Dependent items are ordered: blocker first, then blocked item
- When a blocking item is Done, the blocked item auto-transitions from Blocked -> To Do (if configured)
- When item A's Output Contract feeds item B's Input Contract, set B `waiting_on` A.
- The previous version only set Deliverable-level dependencies. This was insufficient and caused execution ordering issues. Dependencies must now be set at every level where an I/O contract chain exists.

---

## 7 — Edge Cases

| Situation | Resolution |
|---|---|
| Task type not available in List | Ask user to configure List task types, or use a different List |
| UNG name collision | Ask user to disambiguate (adjust NAME or append -NN suffix) |
| Item needs to move between Lists | Use `clickup_move_task` — warn about lost custom field data |
| Multiple assignees needed | Set primary assignee; mention others in description |
| Custom fields not available | Use description fields instead; note the gap |
| ClickUp API rate limit | Back off, retry with exponential delay |
| Parent task not found | **HALT** — resolve parent first, then create child |
| Circular dependency | **HALT** — flag to user, never create circular deps |

---

## 8 — Post-Creation Validation

After creating all entries, verify:

- [ ] Every item has the correct task type (PJ Project, PJ Workstream, PJ Deliverable, Task, PJ Increment, PJ Documentation, PJ Blocker)
- [ ] UNG naming correct at Project level (2-part) and Deliverable level (3-part)
- [ ] No duplicate names in the same List
- [ ] VANA present in `DESIRED OUTCOMES` custom field on all items (except PJ Documentation and PJ Blocker)
- [ ] ACs present in `ACCEPTANCE CRITERIA` custom field on all items (except PJ Documentation and PJ Blocker)
- [ ] Parent-child: Workstream → Project, Deliverable → Workstream, Task → Deliverable, Increment/Documentation/Blocker → Task
- [ ] Dependencies set where needed via `clickup_add_task_dependency` at ALL levels (Workstream, Deliverable, Task, Increment)
- [ ] MoSCoW dropdown set on all items except PJ Documentation (custom field, NOT tag)
- [ ] Status is `draft completed` for newly planned items
- [ ] Assignees are real ClickUp members
- [ ] Time estimates (native, milliseconds) on PJ Increments
- [ ] 1 PJ Documentation per Task (sibling of Increments, not child of Increment)
- [ ] PJ Blockers have BLOCKER(S) and SOLUTION FOR BLOCKER custom fields populated
- [ ] MECE: Increments ∑= Task ∑= Deliverable ∑= Workstream ∑= Project
- [ ] I/O contracts in Description for all items with dependencies; `waiting_on` set where Output→Input chain exists

Report: `{N}/{N} items created. Validation: PASS/FAIL`

## Links

- [[CLAUDE]]
- [[blocker]]
- [[clickup-field-map]]
- [[create-flow]]
- [[deliverable]]
- [[documentation]]
- [[field-map]]
- [[increment]]
- [[iteration]]
- [[naming-rules]]
- [[project]]
- [[schema]]
- [[standard]]
- [[subtask]]
- [[task]]
- [[workstream]]
