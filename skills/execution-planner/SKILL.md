---
name: ltc:execution-planner
description: "Stage 4 — Transforms a frozen plan.md into .exec/ files (task files, project.md, status.json). Runs readiness checks and triggers WMS sync."
trigger: "When a plan.md is approved (Stage 3 gate passed) and .exec/ files need to be generated."
---

# Execution Planner

> **L2 Re-Injection — read these meta-rules before generating any .exec/ file.**
> Do NOT rely on CLAUDE.md for these; context degrades under LT-2/LT-4 in long sessions.

## Meta-Rules

1. **MODEL AS SYSTEM:** For each task, identify all 7 components (EPS, Input, EOP,
   Environment, Tools, Agent, Action/Outcome). The task file IS the EOP contract.
   If you cannot identify a component, the task is under-specified — fix it before
   generating the .exec/ file.
   _(Derived from: agent-system.md Card 3 — 7-Component System)_

2. **UBS BEFORE UDS:** Before generating each task file, ask: "What blocks this task?"
   Populate the Dependencies and Environment sections FIRST. An unblocked task with
   missing prerequisites will fail at execution time — the most expensive failure mode.
   _(Derived from: agent-system.md Principle 1 — derisk first)_

3. **VANA DECOMPOSE:** Every task must trace to one or more VANA Acceptance Criteria
   from the spec. If a task exists that maps to no AC, it is orphaned work — remove it.
   If an AC maps to no task, it is uncovered — add a task.
   _(Derived from: general-system.md — VANA requirements)_

4. **DEFINE DONE:** Every Acceptance Criterion must be binary and deterministic.
   "Works correctly" is NOT an AC. "Returns exit code 0 when given valid input" IS.
   If an AC cannot be evaluated by a script, mark its Eval Type as "Manual" and
   document what the human reviewer checks.
   _(Derived from: general-system.md — VANA grammar)_

## References

Load these before generating .exec/ files:

| Reference | Path | Purpose |
|---|---|---|
| Exec File Format | `skills/execution-planner/references/exec-file-format.md` | Definitive .exec/ format specification |
| Readiness Checks | `skills/execution-planner/references/agent-readiness-checks.md` | 10-point quality gate checklist |
| WMS Sync Protocol | `skills/execution-planner/references/wms-sync-protocol.md` | Sync contract and conflict resolution |

## Templates

| Template | Path | Purpose |
|---|---|---|
| Task File | `skills/execution-planner/templates/task.md` | Individual task execution contract |
| Deliverable | `skills/execution-planner/templates/deliverable.md` | Deliverable contract with ACs and child tasks |
| Project | `skills/execution-planner/templates/project.md` | Execution topology and dependency graph |
| Status Schema | `skills/execution-planner/templates/status-schema.json` | JSON Schema for status.json validation |

## Generation Protocol

### Inputs

- Frozen plan.md (Stage 3 approved)
- Frozen VANA-SPEC (Stage 2 approved)
- Codebase state (for Environment prerequisites)

### Outputs

- `.exec/project.md` — execution topology
- `.exec/status.json` — machine-readable state
- `.exec/D{n}-{Name}/deliverable.md` — per-deliverable contract
- `.exec/D{n}-{Name}/T{m}-{Name}.md` — per-task execution files

### Steps

1. **Parse plan.md** — extract deliverables, tasks, AC mappings, agent architecture decisions, dependency graph
2. **Parse VANA-SPEC** — extract all AC IDs, VANA sentences, eval types
3. **Generate project.md** — fill execution topology from plan structure
4. **For each deliverable:** dispatch a sub-agent to generate:
   a. `deliverable.md` from the deliverable template
   b. Each `T{m}-{Name}.md` from the task template
   c. Fill ALL sections — no empty placeholders allowed
5. **Generate status.json** — initialize all tasks as "ready" (or "blocked" if dependencies exist)
6. **Run readiness checks** — execute `scripts/readiness-check.py .exec/`
   - If ALL 10 checks pass: proceed to WMS sync
   - If any check fails: fix the specific issue and re-validate (max 3 retries)
   - After 3 retries: present .exec/ with readiness report to Human Director for guidance
7. **Trigger WMS sync** — per `references/wms-sync-protocol.md`:
   - Create all tasks in WMS (parent-before-child order)
   - Map status fields per §2.5.1
   - Cache WMS IDs in `.wms-sync.json`

### Sub-Agent Dispatch

For deliverables with 3+ tasks or medium+ complexity, use sub-agents:

| Role | Model | Scope |
|---|---|---|
| Lead (you) | Opus | Parse plan, generate project.md, status.json, orchestrate |
| Worker | Sonnet | Generate one deliverable's .exec/ files (deliverable.md + task files) |

Each worker sub-agent receives:
- The deliverable section from plan.md
- The relevant VANA-SPEC ACs
- The task.md and deliverable.md templates
- This SKILL.md (for meta-rules re-injection)

## Failure Behavior

| Scenario | Action |
|---|---|
| Readiness check failure | Fix specific task files and re-validate (max 3 retries) |
| After 3 retries | Present .exec/ with readiness report to Human Director |
| WMS sync failure | Retry with backoff; partial .exec/ is valid without WMS sync |
| Plan ambiguity | Flag ambiguous sections; do NOT guess — escalate to Human Director |
| Missing AC mapping | Add task or remove orphan AC; re-run coverage check |

## Rework Path

Re-entering Stage 4 regenerates .exec/ files for specific deliverables only.
Unaffected tasks preserve their status. A new exec_version is created in status.json.

## Verification

After generation, run both validators:

```bash
python3 skills/execution-planner/scripts/readiness-check.py .exec/
python3 skills/execution-planner/scripts/coverage-check.py path/to/spec.md .exec/
```

Both must exit 0 before execution (Stage 5) can begin.
