---
version: "1.1"
last_updated: 2026-04-11
owner: ""
workstream: "{{WORKSTREAM}}"
iteration: "{{ITERATION}}"
status: draft
type: template
work_stream: 0-GOVERN
stage: sequence
sub_system: "{{SUBSYSTEM}}"
---
# SEQUENCE.md — {{WORKSTREAM}} × {{SUBSYSTEM}}, {{ITERATION}}

> DSBV stage 2 artifact. Prerequisite: DESIGN.md approved at G1.
> This document orders the work. Every task in DESIGN.md Artifact Inventory must appear here.
> Produced by ltc-planner. Consumed by ltc-builder during Build stage.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Is DESIGN.md approved (G1 gate passed)? | YES / NO |
| Q2: How many artifacts are in the DESIGN.md Artifact Inventory? | _count_ |
| Q3: Does every artifact below map to ≥1 task here? | YES / NO |
| Q4: Are there circular dependencies? | YES / NO |

> If any answer is NO or YES (for Q4) → stop. Resolve before sequencing.

---

## Dependency Map

_Ordered list of tasks with their upstream dependencies. Build stage executes in this order._
_Ref: workstream-typical chains in `.claude/skills/dsbv/references/stage-execution-guide.md` § Sequence stage._

| ID | Task | Depends-on | Input | Output |
|----|------|------------|-------|--------|
| T-01 | _task name_ | — | _input artifact(s)_ | _output artifact(s)_ |
| T-02 | _task name_ | T-01 | _input artifact(s)_ | _output artifact(s)_ |
| T-03 | _task name_ | T-01, T-02 | _input artifact(s)_ | _output artifact(s)_ |
| T-04 | _task name_ | — | _input artifact(s)_ | _output artifact(s)_ |

> Workstream dependency patterns (from stage-execution-guide.md):
> - ALIGN: Charter → Stakeholders → Requirements → OKRs → Decisions
> - PLAN: Architecture → Risks (UBS) → Drivers (UDS) → Roadmap
> - EXECUTE: Config → Core modules → Integration → Tests → Docs
> - IMPROVE: Metrics collection → Analysis → Retro → Changelog

---

## Task Table

_Full task specification for ltc-builder. Each row is a dispatched unit of work._
_Size heuristic: S = <15 min | M = 15–60 min | L = >60 min (decompose L tasks further)._

| ID | Name | Depends-on | Input | Output | AC | Size | Agent |
|----|------|------------|-------|--------|----|------|-------|
| T-01 | _task name_ | — | _file path(s)_ | _file path(s)_ | AC-01: _binary criterion_ | S/M/L | ltc-builder |
| T-02 | _task name_ | T-01 | _file path(s)_ | _file path(s)_ | AC-02: _binary criterion_ | S/M/L | ltc-builder |
| T-03 | _task name_ | T-01, T-02 | _file path(s)_ | _file path(s)_ | AC-03: _binary criterion_ | S/M/L | ltc-builder |
| T-04 | _task name_ | — | _file path(s)_ | _file path(s)_ | AC-04: _binary criterion_ | S/M/L | ltc-builder |

> AC format: binary and deterministic. "File exists at path X" not "looks good".
> Agent column: ltc-builder (default) | ltc-planner (sequence/design sub-tasks) | ltc-reviewer (validate sub-tasks).

---

## Parallel Dispatch

_Tasks with no shared Write targets and no data dependency may be dispatched simultaneously._
_Mark independent tasks explicitly so Build stage can optimise wall-clock time._
_Source: `.claude/skills/dsbv/SKILL.md` § Parallel Dispatch Protocol._

```
## Round 1 — _description_ (sequential)
- T-01: _task_ [sequential — first in chain]

## Round 2 — _description_ (parallel)
- T-02: _task_ [independent]
- T-04: _task_ [independent]

## Round 3 — _description_ (sequential)
- T-03: _task_ [depends on T-01, T-02]
```

**Rules:**
- Only tasks marked `[independent]` are eligible for parallel dispatch
- Each parallel task gets its own ltc-builder dispatch with full context package
- Generator/Critic loop runs after ALL tasks in a round complete, not per-task
- If N > 3 independent tasks in one round, show cost estimate and wait for human approval

---

## Critical Path

_The longest dependency chain from start to finish. Determines minimum calendar time._

```
T-{X} → T-{Y} → T-{Z}   (length: {N} tasks, est. {H}h)
```

_Tasks off the critical path are candidates for parallel dispatch (see above)._

| ID | Is on critical path? | Reason |
|----|---------------------|--------|
| T-01 | YES | _no upstream blocker, all downstream tasks depend on it_ |
| T-02 | NO | _can run in parallel with T-01_ |
| T-03 | YES | _depends on T-01 and T-02; last task_ |
| T-04 | NO | _independent, no downstream dependency_ |

---

## Git Strategy

_Branch, worktree, and merge plan for this workstream's Build stage._

| Field | Value |
|-------|-------|
| Base branch | `main` |
| Feature branch | `feat/{{WORKSTREAM-LOWER}}-{{ITERATION-LOWER}}` |
| Worktree path | `.claude/worktrees/{{WORKSTREAM-LOWER}}-{{ITERATION-LOWER}}/` |
| Commit cadence | Checkpoint commit after each task completes (T-01, T-02, …) |
| Merge strategy | Squash-merge to main after G3 approval |
| Conflict risk | _note shared files at risk of parallel-edit conflict_ |

> If parallel builders write to the same file, this is a SEQUENCE.md dependency error — escalate to ltc-planner.

---

## Approval Log

_Record of human gates passed. Agent fills Date, Gate, Signal. Human fills Decision._

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| _YYYY-MM-DD_ | G1 — Design approved | APPROVE / REVISE | _human comment_ | Human |
| _YYYY-MM-DD_ | G2 — Sequence approved | APPROVE / REVISE | _human comment_ | Human |
| _YYYY-MM-DD_ | G3 — Build complete | APPROVE / REVISE | _human comment_ | Human |
| _YYYY-MM-DD_ | G4 — Validate complete | APPROVE / REVISE | _human comment_ | Human |

> Decision values: APPROVE (proceed) | REVISE (agent revises and re-presents) | ESCALATE (human intervenes directly).
> Agent NEVER self-approves. Only the Human Director sets Decision.

---

## Alignment Check

_Verify SEQUENCE.md is complete before submitting for G2._

- [ ] Every artifact in DESIGN.md Artifact Inventory has ≥1 task in Task Table
- [ ] Every task has a binary, deterministic AC
- [ ] No circular dependencies in Dependency Map
- [ ] Critical path identified and length plausible
- [ ] Parallel dispatch rounds use `[independent]` markers correctly
- [ ] Git strategy branch name follows naming convention (`feat/` prefix, kebab-case)
- [ ] Approval Log has G1 entry (G1 must be approved before sequencing begins)

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[dsbv-process]]
- [[iteration]]
- [[stage-execution-guide]]
- [[task]]
- [[workstream]]
