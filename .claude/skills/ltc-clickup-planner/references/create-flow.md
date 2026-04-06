# CREATE Flow — ClickUp Work Planner

Detailed procedure for creating the full PJ hierarchy: PJ Project → PJ Workstream → PJ Deliverable → Task → PJ Increment / PJ Documentation. Loaded on demand by [SKILL.md](../SKILL.md) in CREATE mode.

---

## Hierarchy

```
PJ Project
  └─ PJ Workstream (I1 / I2 / I3 / I4)
      └─ PJ Deliverable
          └─ Task  (task_type: null — do NOT pass "Task")
              ├─ PJ Increment  (time_estimate set via update_task after creation)
              ├─ PJ Documentation  (1 per Task; no VANA/AC fields)
              └─ PJ Blocker  (reactive only — never created during planning)
```

---

## Step 0 — Load Context

Execute [SKILL.md Step 0](../SKILL.md) before proceeding. You must have:

- Active project state from MEMORY.md
- **Field map loaded** from [clickup-field-map.md](./clickup-field-map.md) — including FULL UUID field IDs
- **Implementation plan file loaded** — this is the source for VANA extraction (Step 2a)
- Workspace hierarchy confirmed (Space > Folder > List)
- Target List identified and task types verified
- Naming rules loaded (`rules/naming-rules.md`)
- **Assignee user ID resolved via `clickup_get_workspace_members`** — do NOT use `clickup_find_member_by_name` (requires exact display-name match; partial matches fail silently). Call `get_workspace_members`, then filter by name client-side.

---

## Step 1 — SCOPE

### 1a — Anti-Bloat Check

Before drafting anything, apply the VANA test to every planned item: if you cannot write the Desired Outcome in one sentence, decompose or merge. Search ClickUp first — if similar work already exists, update it instead of creating new.

### 1b — Classify Item Level

```
What is this work?
├─ Strategic goal with multiple verifiable outcomes            → PJ Project (top-level)
├─ Iteration-scoped cluster of deliverables                   → PJ Workstream (subtask of Project)
├─ User-facing outcome, demo-able, independently verifiable   → PJ Deliverable (subtask of Workstream)
├─ Coherent technical capability, reviewable as a unit        → Task (subtask of Deliverable)
├─ Smallest testable unit creating verifiable value           → PJ Increment (subtask of Task)
├─ Reference doc for a Task's subsystem                       → PJ Documentation (subtask of Task, sibling of Increments)
└─ Single-session, no lasting artefact                        → STOP: do not log
```

### 1c — Identify Workstream Membership

Assign each Deliverable to an Iteration: I1 (Concept/core functionality), I2 (Prototype/usability+efficiency), I3 (MVE/scale+integration), I4 (Leadership/hardening+production).

Classify each Deliverable into the correct Workstream (Iteration):

| Workstream | Iteration | Theme | Deliverable type |
|---|---|---|---|
| WS-I1 | I1 — Concept | Core functionality | Core functionality deliverables |
| WS-I2 | I2 — Prototype | Usability / efficiency | Usability and efficiency deliverables |
| WS-I3 | I3 — MVE | Scale / integration | Scale and integration deliverables |
| WS-I4 | I4 — Leadership | Hardening / production | Hardening and production deliverables |

### 1d — Determine SCOPE and List

1. Identify the SCOPE from UNG Table 3a (e.g., `OPS`, `INV`, `COE_TECH`)
2. Map to the correct ClickUp Space > Folder > List
3. If ambiguous — **ask, do not assume**

---

## Step 2 — DRAFT

### Step 2a — Extract Project VANA from the Implementation Plan

Read the implementation plan file and extract the following components:

**1. User(s):** Who benefits from this project (person or role that uses the output)

**2. Verb(s):** Core actions the system performs — derived from plan goals

**3. Adverbs:** How it performs them, bucketed by pillar:
- Sustainability: works reliably, no external dependencies, self-contained
- Efficiency: fast, token-efficient, minimal overhead
- Scalability: handles volume, multiple platforms, concurrent access

**4. Noun(s):** What artefacts the project produces — derived from the plan's file structure / deliverable list

**5. Adjectives:** Qualities of the noun, bucketed by pillar:
- Sustainability: database-backed, tested, documented
- Efficiency: vector-indexed, cached, incremental
- Scalability: multi-type, multi-platform, extensible

Then generate the full AC table with IDs:

```
Verb-AC1:       {criteria for core action 1}          | Eval: Deterministic
Verb-AC2:       {criteria for core action 2}          | Eval: Deterministic
SustainAdv-AC1: {sustainability behaviour criteria}   | Eval: Deterministic
EffAdv-AC1:     {efficiency behaviour criteria}       | Eval: Deterministic
ScalAdv-AC1:    {scalability behaviour criteria}      | Eval: Deterministic
Noun-AC1:       {artefact 1 exists and is correct}    | Eval: Deterministic
Noun-AC2:       {artefact 2 exists and is correct}    | Eval: Deterministic
SustainAdj-AC1: {sustainability quality criteria}     | Eval: Deterministic
EffAdj-AC1:     {efficiency quality criteria}         | Eval: Deterministic
ScalAdj-AC1:    {scalability quality criteria}        | Eval: Deterministic
```

All ACs must be deterministic (pass/fail verifiable — no subjective language).

### Step 2b — Assign ACs to Workstreams, then down the hierarchy

**Map ACs to Workstreams** following the VANA-SPEC model:

| Workstream | AC ownership |
|---|---|
| WS-I1 (Concept) | Verb-ACs + SustainAdv-ACs + Noun-ACs + SustainAdj-ACs |
| WS-I2 (Prototype) | EffAdv-ACs + EffAdj-ACs |
| WS-I3 (MVE) | ScalAdv-ACs + ScalAdj-ACs |
| WS-I4 (Leadership) | Spawned Verb-ACs (hardening) + Hardening Noun-ACs |

Then cascade down:
- Assign specific ACs from each Workstream → its Deliverables
- Assign specific ACs from each Deliverable → its Tasks
- Assign specific ACs from each Task → its Increments

Every AC at the Project level must appear in exactly one Workstream (MECE). Every Workstream AC must appear in at least one Deliverable.

### Step 2c — Generate Input / Output Contracts

For every item at every level, define:

- **Input:** What it receives and from whom (predecessor item or external source)
- **Output:** What it produces and for whom (successor items or end user)
- **Schema:** Data types, interfaces, file paths, or API contracts

When item A's Output equals item B's Input, mark a dependency: B `waiting_on` A.

Use these contracts to drive dependency setting in Step 4.

### Step 2d — Identity & Naming

| Item | Naming rule |
|---|---|
| PJ Project | 2-part UNG: `[SCOPE DISPLAY]_FA.ID. PROJECT NAME` |
| PJ Workstream | Free text: `I{n}. {Name} — {Pillar Scope}` (e.g., `I1. Concept — Core Storage & Retrieval`) |
| PJ Deliverable | 3-part UNG: `[SCOPE DISPLAY]_FA.ID. PROJECT NAME_D{n}. DELIVERABLE NAME` |
| Task | Free text — descriptive and clear |
| PJ Increment | Free text — grouped by logical layer (e.g., "Storage Layer", not "storage.py") |
| PJ Documentation | Free text — descriptive reference doc name |

### Step 2e — Set Custom Fields + Description

**Field ID rule:** Always use the FULL UUID field IDs from [clickup-field-map.md](./clickup-field-map.md). Never use short prefixes. Exception: `URL Link` field (`b76eb12c`) uses its short ID.

**Description parameter rule:** Use the `description` parameter (NOT `markdown_description`). ClickUp renders markdown from `description` natively. Using `markdown_description` causes literal `\n` rendering in the UI.

**Time estimate rule:** `time_estimate` is NOT available on `create_task`. After creating each PJ Increment, immediately call `update_task` with `time_estimate` as a string in milliseconds (e.g., `"2700000"` for 45 min). Formula: `minutes × 60 × 1000`.

**Task type rule:** For Task-level items, use `task_type: null` or omit the parameter entirely. Do NOT pass `task_type: "Task"` — it will error or silently default to "Request".

**Status rule:** All new items start at `ready/prioritized` (plan is already approved when clickup-planner runs).

#### Tier 1 — Always set (every item)

| Field | UUID | Notes |
|---|---|---|
| Name | _(native)_ | UNG for Project/Workstream/Deliverable; free text for Task and below |
| Task Type | _(native)_ | PJ Project, PJ Workstream, PJ Deliverable, `null` (Task), PJ Increment, PJ Documentation |
| Status | _(native)_ | `ready/prioritized` |
| Priority | _(native)_ | urgent / high / normal / low |
| Assignee | _(native)_ | Resolved ClickUp user ID (from `get_workspace_members`) |
| Parent | _(native)_ | Parent task ID for subtask nesting |
| DESIRED OUTCOMES | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | VANA sentence + AC-anchored table. Skip for PJ Documentation and PJ Blocker. |
| ACCEPTANCE CRITERIA | `b74bfd0e-f112-4849-af6d-132e65e59b46` | AC checkboxes with IDs. Skip for PJ Documentation and PJ Blocker. |
| MoSCoW | `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` | Dropdown UUID — see MoSCoW table in field map |

#### Tier 2 — Set when applicable

| Field | UUID | When |
|---|---|---|
| Description | _(native)_ | Implementation details, I/O contracts, links, scope — NOT VANA/AC |
| Definition of Done | `5bde1429-9a92-47a8-8345-0dd0b3dc9035` | Required on PJ Deliverable and Task |
| Strategic Focus Area | `c25d6dc4-85c0-4810-b945-42d65f72beb4` | Map to FA: OE, PD, UE, CI, FP, CR |
| Delivery Phase | `4b625634-7006-4eec-8add-8c2b8c04ca3c` | Required on PJ Workstream and PJ Deliverable (use dropdown UUID from field map) |
| URL Link | `b76eb12c` | Link to spec, plan, or reference doc |
| Function in Charge | `dbcd79fb-3c44-411f-9c88-c27473854592` | OPS, INV, COE_EFF, etc. |
| ID / Short Name | `d640d685-262f-46bd-b166-c9c546796a61` | Short code (e.g., "MEM-SYS", "D1-FOUNDATION") |
| Time Estimate | _(native, via update_task)_ | PJ Increment only — set in separate update_task call |
| Dependencies | _(native, via API)_ | Set via `clickup_add_task_dependency` after all IDs are known |
| Tags | _(native)_ | Audience tags (e.g., "user: all ltc all members") |

**Never set:** DoR, Effort, Complexity, Risk/Uncertainty, DIFFICULTY SCORE, RICE, and all HR/IT/admin fields.

**At completion only:** Check each AC box (set Status to Pass/Fail). Add a completion comment.

#### Hierarchy & Linkage Table

| Item Level | Created as | Parent |
|---|---|---|
| PJ Project | Root task in List | None |
| PJ Workstream | Subtask of PJ Project | PJ Project |
| PJ Deliverable | Subtask of PJ Workstream | PJ Workstream |
| Task | Subtask of PJ Deliverable | PJ Deliverable |
| PJ Increment | Subtask of Task | Task |
| PJ Documentation | Subtask of Task (sibling of Increments) | Task |
| PJ Blocker | Subtask of Task (sibling of Increments, reactive) | Task |

---

## Step 2.5 — PRE-PREVIEW QUALITY GATE

Before showing the preview, verify every item passes all checks. Fix failures inline — do not proceed to Step 3 with known defects.

| # | Check | How to verify |
|---|---|---|
| 1 | VANA is one sentence | `DESIRED OUTCOMES` field is one period-terminated sentence (skip for Doc/Blocker) |
| 2 | VANA scoped to Item Level | PJ Project = broadest; PJ Increment = narrowest |
| 3 | AC-V and AC-N present | `ACCEPTANCE CRITERIA` field has both (skip for Doc/Blocker) |
| 4 | Every Project AC assigned to exactly one Workstream | MECE — no AC appears in two Workstreams, no AC is unassigned |
| 5 | Every Workstream AC assigned to at least one Deliverable | No orphaned Workstream ACs |
| 6 | Parent is correct | Deliverable → Workstream; Task → Deliverable; Increment/Doc → Task |
| 7 | UNG naming correct | 2-part for PJ Project; `I{n}. Name — Scope` for Workstream; 3-part for PJ Deliverable; free text below |
| 8 | No duplicates | Search ClickUp — no existing item with same name |
| 9 | MoSCoW set | `RISK-BASED IMPORTANCE` dropdown is set (not tags) |
| 10 | Task type set | Correct ClickUp task type on every item; Task-level = null |
| 11 | Every item has Input/Output contracts | I/O contract defined for every item |
| 12 | Dependencies match I/O contract chains | When A outputs to B, B is `waiting_on` A |
| 13 | Workstream DELIVERY PHASE matches iteration number | WS-I1 → `1. CONCEPT`, WS-I2 → `2. PROTOTYPE`, etc. |
| 14 | All field IDs are full UUIDs | No short prefixes (except `b76eb12c` for URL Link) |
| 15 | Time estimates on Increments | Every PJ Increment has `time_estimate` queued for update_task |
| 16 | 1 Documentation per Task | Each Task has exactly 1 PJ Documentation child |
| 17 | MECE sum check | Increments ∑= Task; Tasks ∑= Deliverable; Deliverables ∑= Workstream; Workstreams ∑= Project |

If any check fails → fix before proceeding to preview.

---

## Step 3 — PREVIEW + DISCUSS (mandatory gate)

### 3a — Show the full plan on screen

Draft the complete plan in Claude Code BEFORE any ClickUp write. Show the full AC table first, then the hierarchy:

```
ClickUp Plan Preview — {date}
Assignee: {name} | Function: {function}

PROJECT VANA AC TABLE:
  Verb-AC1:       {criteria}
  Verb-AC2:       {criteria}
  SustainAdv-AC1: {criteria}
  EffAdv-AC1:     {criteria}
  ScalAdv-AC1:    {criteria}
  Noun-AC1:       {criteria}
  Noun-AC2:       {criteria}
  SustainAdj-AC1: {criteria}
  EffAdj-AC1:     {criteria}
  ScalAdj-AC1:    {criteria}

  PJ PROJECT  [SCOPE]_FA.ID. PROJECT NAME | {Priority} | {MoSCoW}
    VANA: {one-sentence desired outcome}
    Owns: ALL ACs

    PJ WORKSTREAM  I1. Concept — {Scope} | DELIVERY PHASE: 1. CONCEPT
      Owns: Verb-AC1, Verb-AC2, SustainAdv-AC1, Noun-AC1, Noun-AC2, SustainAdj-AC1

      PJ DELIVERABLE  [SCOPE]_FA.ID. PROJECT NAME_D1. NAME | {Priority}
        Owns: Noun-AC1, Noun-AC2
        Input: {source} | Output: {schema}

        TASK  Task Name | {Priority}
          Owns: Noun-AC1
          Input: {from} | Output: {to}
          INCREMENT  Inc Name | Est: {N}min | [Must Have]
            Owns: Noun-AC1
          DOC  Doc Name | [Must Have]

      PJ DELIVERABLE  [SCOPE]_FA.ID. PROJECT NAME_D2. NAME | {Priority}
        Owns: SustainAdj-AC1
        Input: {source} | Output: {schema}
        ...

    PJ WORKSTREAM  I2. Prototype — {Scope} | DELIVERY PHASE: 2. PROTOTYPE
      Owns: EffAdv-AC1, EffAdj-AC1
      ...

    PJ WORKSTREAM  I3. MVE — {Scope} | DELIVERY PHASE: 3. MINIMUM VIABLE ENABLEMENT
      Owns: ScalAdv-AC1, ScalAdj-AC1
      ...

    PJ WORKSTREAM  I4. Leadership — {Scope} | DELIVERY PHASE: 4. LEADERSHIP ENABLEMENT
      Owns: {hardening ACs}
      ...

Totals: {P} Projects, {W} Workstreams, {D} Deliverables, {T} Tasks, {I} Increments, {Doc} Docs
AC Coverage: {assigned}/{total} ACs assigned (must be 100%)
```

### 3b — Confirm with user

After showing the preview, ask:

```
Please confirm:
1. Plan content correct? (VANA, ACs, hierarchy, names)
2. AC assignments correct? (right ACs in right Workstreams/Deliverables/Tasks)
3. Where should this go in ClickUp?
   - List name (e.g., "Process-related Execution")
   - Parent task name (e.g., "under OE.6 MAINTAIN EFFECTIVE OPERATIONAL PROCESSES")
   - Or "create a new List under [Folder]"

Confirm? (yes + location / revise: <note> / cancel)
```

**Do NOT proceed without:**
1. Explicit "yes" or "approved" on the plan content
2. Confirmed List or parent task placement

Only after BOTH are confirmed → proceed to Step 4.

---

## Step 4 — LOG (Parallel Sub-Agent Creation)

### Why parallel is mandatory (not optional)

Per LT-3 (agent-system.md): "Reasoning degrades on complex tasks. At 90% per-step, 0.9^7 ≈ 48% end-to-end." Creating 28+ items sequentially in one agent context is exactly the multi-step chain that degrades quality. Each sub-agent handling one Workstream's Deliverables + children stays within reliable reasoning range.

**Parallel creation is the LT-3 compensation. It is mandatory when the plan has more than 1 Workstream.**

### 4a — Create PJ Project (main agent)

The main agent creates ONLY the root PJ Project in the confirmed List:
- Set: name, task_type (`PJ Project`), status (`ready/prioritized`), priority, assignee, description (use `description` not `markdown_description`), custom_fields (DESIRED OUTCOMES, ACCEPTANCE CRITERIA, MoSCoW, Strategic Focus Area, Delivery Phase, Function in Charge, ID/Short Name, URL Link)
- Capture the returned **Project task ID** — needed as parent for Workstreams

### 4b — Create PJ Workstreams (main agent, sequential)

The main agent creates all 4 Workstream tasks as subtasks of the Project:
- task_type: `PJ Workstream`
- Name: `I{n}. {Name} — {Pillar Scope}`
- Set DELIVERY PHASE using the correct dropdown UUID from the field map
- Set DESIRED OUTCOMES and ACCEPTANCE CRITERIA for each Workstream's owned ACs
- Set MoSCoW on each
- Capture all 4 **Workstream task IDs** — needed as parents for sub-agents

### 4c — Dispatch parallel sub-agents (one per Workstream)

Dispatch one Sonnet sub-agent per PJ Workstream. Each sub-agent receives:

```
Context for sub-agent:
- Parent Workstream task ID: {id}
- Field map: [full content of clickup-field-map.md — not just a path]
- All items for this Workstream: Deliverables → Tasks → Increments/Docs
  including VANA, ACs, I/O contracts, and dependencies
- Assignee user ID: {id}
- List ID: {id}

Job: Create all Deliverables, Tasks, Increments, and Documentation for
Workstream {n}. Return all created task IDs with their item names.
```

Each sub-agent creates top-down:
1. PJ Deliverable (subtask of Workstream)
2. Tasks (subtask of Deliverable — omit task_type or set null)
3. PJ Increments + PJ Documentation (subtasks of each Task)
4. Call `update_task` on each PJ Increment to set `time_estimate` in milliseconds

**All sub-agents run in parallel.** Return all created task IDs to main agent.

### 4d — Set cross-branch dependencies (main agent)

After all sub-agents complete and return their task IDs:
- Set all `waiting_on` / `blocking` relationships via `clickup_add_task_dependency` — including cross-Workstream dependencies derived from the I/O contracts
- Add relationship links via `clickup_add_task_link` where items reference each other across branches
- Verify each item's task type was correctly set

### 4e — Set time estimates on all Increments (main agent)

Although sub-agents set time estimates for their own Increments, the main agent does a final pass:
- Call `update_task` with `time_estimate` (string, milliseconds) on any Increment that sub-agents flagged as needing a retry
- Formula: `minutes × 60 × 1000` → e.g., 45 min = `"2700000"`

### 4f — PJ Blockers

NOT created during planning. Created reactively when blockers are discovered during execution.

### Custom fields format (use FULL UUIDs)

```json
{
  "custom_fields": [
    {"id": "a382a103-456b-41a8-9b2a-8fa15a657ce4", "value": "VANA sentence here"},
    {"id": "b74bfd0e-f112-4849-af6d-132e65e59b46", "value": "Verb-AC1: criteria\nNoun-AC1: criteria"},
    {"id": "1da92ea7-e200-4d60-84d8-e8b6148ba7dd", "value": "46d840bc-e7f4-4557-a7b1-37c92632c996"}
  ]
}
```

---

## Step 5 — VALIDATE

After creating all entries, run validation. Report every failure — do not mark PASS if any item has an unresolved defect.

| # | Check | How to verify |
|---|---|---|
| 1 | Correct task types | `get_task` on 3 random items — confirm task_type matches plan |
| 2 | Task-level items have task_type null / 0 | Spot-check 2 Tasks — `custom_item_id` should be `0`, not `"Request"` |
| 3 | UNG naming correct | 2-part for PJ Project; 3-part for PJ Deliverable; Workstreams follow `I{n}. Name — Scope` |
| 4 | No duplicate names | Search ClickUp for each Project and Deliverable name |
| 5 | VANA in DESIRED OUTCOMES | `get_task` on 2 items per Workstream — field `a382a103-456b-41a8-9b2a-8fa15a657ce4` is populated |
| 6 | All field IDs are full UUIDs | Spot-check 3 items — no short prefixes in custom_fields |
| 7 | Parent-child nesting correct | Workstream → Project; Deliverable → Workstream; Task → Deliverable; Increment/Doc → Task |
| 8 | Dependencies set | Verify `waiting_on` chains match I/O contracts |
| 9 | MoSCoW present | `RISK-BASED IMPORTANCE` dropdown is set (not a tag) on all items |
| 10 | Status = ready/prioritized | All items at correct status |
| 11 | Time estimates persist | `get_task` on 2 Increments — `time_estimate` field is non-zero |
| 12 | Descriptions render properly | Open 1 item in ClickUp — no literal `\n` characters visible |
| 13 | 1 PJ Documentation per Task | Each Task has exactly 1 Doc child |
| 14 | AC coverage | Every Project AC appears in exactly one child chain — no orphaned ACs |
| 15 | I/O contracts chain correctly | Each dependency pair has matching Output → Input |
| 16 | Workstream DELIVERY PHASE | WS-I1 → `1. CONCEPT`, WS-I2 → `2. PROTOTYPE`, WS-I3 → `3. MINIMUM VIABLE ENABLEMENT`, WS-I4 → `4. LEADERSHIP ENABLEMENT` |
| 17 | MECE sum check | Increments ∑= Task; Tasks ∑= Deliverable; Deliverables ∑= Workstream; Workstreams ∑= Project |

Report: `{N}/{N} items created. Validation: PASS / FAIL — {list any failures}`

## Links

- [[CLAUDE]]
- [[SKILL]]
- [[VALIDATE]]
- [[agent-system]]
- [[blocker]]
- [[deliverable]]
- [[documentation]]
- [[increment]]
- [[iteration]]
- [[naming-rules]]
- [[project]]
- [[subtask]]
- [[task]]
- [[workstream]]
