# .exec/ File Format Reference

> Definitive specification for the .exec/ execution file format.
> Source: LTC Execution Pipeline Design Spec §3.

## Design Decision: Task-Level, Not Increment-Level

Execution files are scoped to **tasks** (not increments) because:

1. Increments within a task are sequential and share context — splitting them into separate files wastes tokens (LT-7) and forces redundant context loading (LT-2)
2. A task is the atomic unit of agent assignment — one agent owns one task file
3. Increments are ordered steps within a task; they share the same I/O contract and dependencies

## Directory Layout

```
.exec/
├── project.md                     # Execution topology, agent arch decisions, dependency graph
├── status.json                    # Machine-readable state for all tasks
├── .wms-sync.json                 # WMS item ID cache (gitignored)
├── D1-{Name}/
│   ├── deliverable.md             # Deliverable contract (VANA, ACs, child task list)
│   ├── T1-{Name}.md              # Task execution file
│   └── T2-{Name}.md              # Task execution file
└── D2-{Name}/
    ├── deliverable.md
    └── T1-{Name}.md
```

## Task File Structure

Every task file MUST contain ALL of the following sections. No section may be omitted or left with unfilled `{...}` placeholders.

| Section | Purpose | Required Fields |
|---|---|---|
| **Identity** | Task metadata | Task ID, Deliverable, Spec Version, Plan Section, Agent Pattern, Agent Model, Status, Rework Count |
| **VANA Traceability** | AC mapping | AC ID, Criteria, Eval Type, Threshold |
| **Acceptance Criteria** | Checkboxes | Binary, deterministic criteria only |
| **Definition of Done** | Completion gate | All ACs pass, code reviewed, no regressions, status.json updated, WMS synced |
| **References** | Trace links | Plan Section, Spec ACs, Related Tasks |
| **I/O Contract** | Data flow | Inputs table (Source, Path, Schema, Validation), Outputs table (Consumer, Path, Schema, Validation) |
| **Dependencies** | Execution order | Direction (blocked_by/blocks), Task ID, Condition |
| **Environment** | Prerequisites | Prerequisite name, Verify Command |
| **Increments** | Step-by-step execution | INC-{n} with Input, Action, Output, Verify |
| **Verify** | Task-level test | Bash command that proves task is complete |
| **Scope Exclusions** | Boundaries | What this task does NOT do |

Template location: `skills/execution-planner/templates/task.md`

## status.json Schema

The `status.json` file is the machine-readable state of the entire project execution.

### Required Top-Level Fields

| Field | Type | Description |
|---|---|---|
| `project` | string | Project name |
| `spec_version` | string | Pattern: `v{N}` |
| `plan_version` | string | Pattern: `v{N}` |
| `exec_version` | string | Pattern: `v{N}` |
| `generated_at` | datetime | When .exec/ was first generated |
| `updated_at` | datetime | Last modification time |
| `pipeline_stage` | enum | `brainstorm`, `spec_review`, `plan`, `exec_plan`, `execute`, `test`, `review`, `done` |
| `deliverables` | object | Keyed by `D{N}` |
| `rework_log` | array | Project-level rework event log |

### Deliverable Object

```json
{
  "D1": {
    "name": "Data Foundation",
    "status": "in_progress",
    "tasks": { ... }
  }
}
```

### Task Object

```json
{
  "D1-T1": {
    "name": "Setup Database",
    "status": "done",
    "rework_count": 0,
    "agent_pattern": "single_agent",
    "agent_model": "sonnet",
    "started_at": "2026-03-22T10:05:00Z",
    "completed_at": "2026-03-22T10:45:00Z",
    "ac_results": {
      "Noun-AC1": "pass",
      "Noun-AC2": "pass"
    }
  }
}
```

### Supported Status Values

| Status | Meaning |
|---|---|
| `ready` | Task created, all dependencies met |
| `blocked` | Waiting on upstream dependency or missing prerequisite |
| `in_progress` | Agent is actively working |
| `done` | Agent completed, awaiting human review |
| `rework` | Human or test requested changes |
| `failed` | Unrecoverable error, escalated to human |

### Supported Status Transitions

```
ready -> in_progress -> done
ready -> blocked -> ready (dependency resolved)
in_progress -> failed -> ready (after fix)
done -> rework -> in_progress -> done (rework cycle)
```

### Rework Log Entry Format

```json
{
  "task_id": "D1-T2",
  "from_status": "done",
  "to_status": "rework",
  "reason": "Stage 7 human review: schema missing index",
  "triggered_by": "stage_7_review",
  "timestamp": "2026-03-22T15:00:00Z"
}
```

The `rework_log` in status.json is the **canonical, project-level** log of all rework events. Individual task files do NOT contain a separate rework_log — they reflect rework through their Status field and Rework Count.

## project.md Structure

The project.md file captures the execution topology and agent architecture decisions.

### Required Sections

| Section | Content |
|---|---|
| **Execution Topology** | Deliverable/task matrix with critical path and agent architecture |
| **Agent Architecture Decision** | Task Count x Max Complexity matrix per deliverable |
| **Dependency Graph** | ASCII or Mermaid diagram showing task execution order |
| **Version History** | Version, date, trigger, changes for each .exec/ generation |

Template location: `skills/execution-planner/templates/project.md`

## Deliverable Contract Structure

Each deliverable directory contains a `deliverable.md` with:

| Section | Content |
|---|---|
| **Identity** | Deliverable ID, Project, Spec Version, Plan Section, Agent Architecture, Status |
| **VANA Sentence** | The deliverable's desired outcome in VANA grammar |
| **Acceptance Criteria** | AC table with eval type and task coverage |
| **Child Tasks** | Task list with status and dependencies |
| **Scope** | In scope / Out of scope boundaries |

Template location: `skills/execution-planner/templates/deliverable.md`

## JSON Schema Validation

Use `skills/execution-planner/templates/status-schema.json` to validate status.json files programmatically. The schema enforces all required fields, enum values, and pattern constraints.
