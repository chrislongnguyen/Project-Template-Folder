---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# ClickUp Field Map — What to Set and What to Skip

> Based on live ClickUp workspace analysis (2026-03-22). Maps plan content to exact ClickUp fields.

---

## Fields to SET (by Item Level)

### Tier 1 — Always Set (every item)

| Field | ClickUp Name | Type | Field ID | What Goes Here |
|---|---|---|---|---|
| **Name** | _(native)_ | title | — | UNG name (Project/Workstream/Deliverable) or free text (Task/below) |
| **Task Type** | _(native)_ | task_type | — | PJ Project, PJ Workstream, PJ Deliverable, `null` (Task), PJ Increment, PJ Documentation, PJ Blocker |
| **Status** | _(native)_ | status | — | See Status Workflow below |
| **Priority** | _(native)_ | priority | — | urgent, high, normal, low |
| **Assignee** | _(native)_ | assignees | — | ClickUp user ID |
| **Parent** | _(native)_ | parent | — | Parent task ID (for subtask nesting) |
| **Desired Outcomes** | 🌐 DESIRED OUTCOMES (Objectives) | text | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | VANA sentence + table. NOT in description. (Skip for PJ Documentation and PJ Blocker) |
| **Acceptance Criteria** | 🌐 ACCEPTANCE CRITERIA (Key Results) | text | `b74bfd0e-f112-4849-af6d-132e65e59b46` | AC checkboxes. NOT in description. (Skip for PJ Documentation and PJ Blocker) |
| **MoSCoW** | 🌐 RISK-BASED IMPORTANCE (MoSCoW) | dropdown | `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` | Must Have / Should Have / Could Have / Won't Have |

### Tier 2 — Set When Applicable

| Field | ClickUp Name | Type | Field ID | When to Set |
|---|---|---|---|---|
| **Description** | _(native)_ | description | — | Implementation details, links, "what was done" — NOT VANA/AC |
| **Definition of Done** | 🌐 DEFINITION OF DONE (DoD) | text | `5bde1429-9a92-47a8-8345-0dd0b3dc9035` | On PJ Deliverable and Task — completion criteria |
| **Strategic Focus Area** | 🌐 STRATEGIC FOCUS AREA(S) | labels | `c25d6dc4-85c0-4810-b945-42d65f72beb4` | Map to FA: OE, PD, UE, CI, FP, CR |
| **Delivery Phase** | 🌐 DELIVERY PHASE | dropdown | `4b625634-7006-4eec-8add-8c2b8c04ca3c` | Maps to VANA iterations: 0=Finding DO, 1=Concept, 2=Prototype, 3=MVE, 4=Leadership |
| **URL Link** | 🌐 URL Link | url | `b76eb12c` | Link to spec, plan, or reference doc |
| **Function in Charge** | 🌐 Function(s) in Charge | labels | `dbcd79fb-3c44-411f-9c88-c27473854592` | OPS, INV, COE_EFF, etc. |
| **ID / Short Name** | 🌐 ID / Short Name | text | `d640d685-262f-46bd-b166-c9c546796a61` | Short code (e.g., "MEM-SYS", "D1-FOUNDATION") |
| **Blocker(s)** | 🌐 BLOCKER(S) | text | `62738883-ccff-4b3b-a8be-e41e560f28e5` | On PJ Blocker items — describe what is blocked and why |
| **Solution for Blocker** | 🌐 SOLUTION FOR BLOCKER | text | `ce1cbe61-1849-4662-ae50-314649f4e442` | Resolution plan for the blocker |
| **Tags** | _(native)_ | tags | — | Audience tags (e.g., "user: all ltc all members") |
| **Time Estimate** | _(native)_ | time_estimate | — | In milliseconds. Set on PJ Increment. See Time Estimation Rule below. |
| **Dependencies** | _(native, via API)_ | dependency | — | Set via `clickup_add_task_dependency` |

### Tier 3 — Auto-Calculated (never set manually)

| Field | ClickUp Name | Type | Notes |
|---|---|---|---|
| % Completed | 🌐 % Completed | automatic_progress | Auto-calculated from subtask completion |

---

## Fields by Item Level

| Field | PJ Project | PJ Workstream | PJ Deliverable | Task | PJ Increment | PJ Documentation | PJ Blocker |
|---|---|---|---|---|---|---|---|
| DESIRED OUTCOMES | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | — | — |
| ACCEPTANCE CRITERIA | `b74bfd0e-f112-4849-af6d-132e65e59b46` | `b74bfd0e-f112-4849-af6d-132e65e59b46` | `b74bfd0e-f112-4849-af6d-132e65e59b46` | `b74bfd0e-f112-4849-af6d-132e65e59b46` | `b74bfd0e-f112-4849-af6d-132e65e59b46` | — | — |
| MoSCoW | `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` | `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` | `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` | `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` | `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` | — | Must Have |
| DoD | Optional | Optional | Required | Required | — | — | — |
| DELIVERY PHASE | Optional | Required | Required | — | — | — | — |

---

## MoSCoW Dropdown Option UUIDs

Field ID: `1da92ea7-e200-4d60-84d8-e8b6148ba7dd`

| Option | UUID |
|---|---|
| Must Have | `46d840bc-e7f4-4557-a7b1-37c92632c996` |
| Should Have | `670937b6-574c-4c8b-8aa8-2dc149694f06` |
| Could Have | `0191c41f-c612-4885-abd6-7829fd7d649b` |
| Won't Have | `1179a064-8586-47fe-89ca-1300db3f3da4` |

---

## DELIVERY PHASE Dropdown Option UUIDs

Field ID: `4b625634-7006-4eec-8add-8c2b8c04ca3c`

| Option | UUID |
|---|---|
| 0. FINDING DESIRED OUTCOMES | `5c4a8e04-dd66-4c34-8d0b-111e1c6af2a8` |
| 1. CONCEPT | `76913bd0-be6e-41eb-8ef8-0e0cbc42acc8` |
| 2. PROTOTYPE | `7b5a810b-c0de-49e1-b342-263c9c77cef7` |
| 3. MINIMUM VIABLE ENABLEMENT | `1b9788ad-7190-43c8-bcd4-bed9a167a706` |
| 4. LEADERSHIP ENABLEMENT | `d81c313c-e764-444d-83a0-731e2a758fb3` |

---

## Fields to SKIP

These fields are either domain-specific or replaced by simpler alternatives. Never set them from the planning agent:

**Replaced by Time Estimate (native):**
- Effort (# man-day), Complexity (1-5), Risk/Uncertainty (0-100%), DIFFICULTY SCORE (formula), EXECUTION PRIORITY SCORE / RICE (formula)

**Not needed:**
- DEFINITION OF READY (DoR)

**Domain-specific (~40 fields):**
- All `[OPS HR]_*` fields (address, mobile, birthday)
- All `[OPS IT]_*` fields (computers, licenses, ChatGPT)
- All `Data Access - Shared *` fields (Google Drive, OneDrive, File Server)
- All `Google - *` and `Clickup - *` admin fields
- Meeting Purpose, Meeting Type, Time Frequency
- Reflection Category, Improvement Area, Improvement Action Type
- LEARNING/ACTION PLAN, DRIVER(S), Key Metrics/KPI(s)
- Reach, Impact, Confidence, Probability, # Ranking

---

## Status Workflow (from live ClickUp)

| Status | Color | When |
|---|---|---|
| `draft` | — | Just created, not yet scoped |
| `draft completed` | #244091 | Fully scoped, ready for review |
| `ready/prioritized` | #5cf26a | Approved, ready to pick up |
| `in progress` | #004851 | Actively being worked on |
| `review` | — | Work complete, awaiting review |
| `do again (review failed)` | — | Review found issues |
| `done` | — | All ACs pass, verified |
| `blocked` | — | Cannot proceed |
| `cancelled` | — | No longer needed |

---

## Time Estimation Rule

Every PJ Increment MUST have a time estimate. Tasks and Deliverables get the sum of their children.

| Field | How to Set | Example |
|---|---|---|
| **Time Estimate** (native) | In milliseconds. Formula: `estimated_minutes × 60 × 1000`. Example: 45 min = `2700000` | 45 min → `2700000` |

Time estimates include agent execution + overhead + user review time (all-in).

**Note:** The `time_estimate` parameter is NOT available on `create_task` — must be set via a separate `update_task` call after creation.

---

## PJ Blocker — Auto-Created by Agent

When the agent encounters a blocker during execution (or user reports one), auto-create a **PJ Blocker** task:

| Field | Value |
|---|---|
| Task Type | `PJ Blocker` |
| Parent | The blocked Task (sibling of Increments) |
| Name | Short description of the blocker |
| Status | `blocked` |
| Priority | Match or exceed parent priority |
| `🌐 BLOCKER(S)` | What is blocked and why |
| `🌐 SOLUTION FOR BLOCKER` | Proposed resolution (if known) |
| Description | Context, evidence, links |

When the blocker is resolved: status → `done`, add resolution comment.

---

## Critical Rule: Where Content Lives

```
VANA sentence + table     → Custom field: DESIRED OUTCOMES (Objectives)
Acceptance criteria       → Custom field: ACCEPTANCE CRITERIA (Key Results)
Completion criteria       → Custom field: DEFINITION OF DONE (DoD)
MoSCoW importance         → Custom field: RISK-BASED IMPORTANCE (MoSCoW) [DROPDOWN]

Implementation details    → Description (native field)
Links to specs/docs       → Description + URL Link custom field
What was delivered        → Description (filled at completion)
Blocker details           → Custom fields: BLOCKER(S) + SOLUTION FOR BLOCKER
```

**NEVER put VANA or ACs in the description.** They have dedicated custom fields.

---

## Known ClickUp MCP Gotchas

These are confirmed quirks that will cause silent failures or errors if not handled:

1. **`task_type: "Task"` does NOT exist as a named type.** Use `task_type: null` (or omit the parameter entirely) for Task-level items. The built-in default type has `custom_item_id: 0`.

2. **`markdown_description` does NOT render markdown.** Use `description` (plain text) instead — ClickUp auto-renders markdown from the description field.

3. **`find_member_by_name` requires EXACT display name match.** Partial matches will fail silently. Prefer `get_workspace_members` + filter by name client-side.

4. **`create_task` does NOT support `time_estimate`.** Create the task first, then call `update_task` to set the time estimate in a separate call.

5. **Field IDs must be FULL UUIDs, not short prefixes.** Using a short prefix (e.g., `a382a103`) instead of the full UUID (e.g., `a382a103-456b-41a8-9b2a-8fa15a657ce4`) will cause field updates to silently fail or error. Exception: `URL Link` field (`b76eb12c`) is not a workspace-level field and uses its short ID.

6. **502 Bad Gateway errors occur under parallel load.** If a ClickUp MCP call returns 502, retry once. If it fails again, back off and alert the user.

## Links

- [[blocker]]
- [[deliverable]]
- [[documentation]]
- [[gotchas]]
- [[increment]]
- [[project]]
- [[subtask]]
- [[task]]
- [[workstream]]
