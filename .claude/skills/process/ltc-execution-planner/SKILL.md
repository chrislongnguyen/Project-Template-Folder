---
version: "1.2"
last_updated: 2026-03-30
owner: "Long Nguyen"
name: ltc-execution-planner
description: "DEPRECATED — Use `/dsbv build` instead. This skill is now a sub-skill of /dsbv Build phase. Kept for backward compatibility."
trigger: "When a plan.md is approved (Stage 3 gate passed) and .exec/ files need to be generated."
deprecated: true
redirect: "/dsbv build"
---
# Execution Planner

> **DEPRECATED:** This skill has been consolidated into `/dsbv build`. Use `/dsbv build` for all artifact production.
> This file is retained for backward compatibility — invoking `/ltc-execution-planner` will still work but follows the `/dsbv build` workflow.
> **Agent:** Artifact production is handled by `ltc-builder` (`.claude/agents/ltc-builder.md`).

> **L2 Re-Injection — read these meta-rules before generating any .exec/ file.**
> Do NOT rely on CLAUDE.md for these; context degrades under LT-2/LT-4 in long sessions.

## Meta-Rules

1. **MODEL AS SYSTEM:** For each task, identify all 7 components (EP, Input, EOP,
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

<HARD-GATE>
1. Do NOT generate .exec/ files without a frozen (Stage 3 approved) plan.md AND a frozen VANA-SPEC.
2. Do NOT present .exec/ files to the user without ALL 10 readiness checks passing (or explicit 3-retry escalation).
3. Do NOT sync to WMS until readiness checks pass — partial .exec/ with WMS IDs creates orphaned tasks.
4. Do NOT leave empty placeholder sections in task files — every section must be filled.
</HARD-GATE>

## References

Load these before generating .exec/ files:

| Reference | Path | Purpose |
|---|---|---|
| Exec File Format | `3-PLAN/skills/ltc-execution-planner/references/exec-file-format.md` | Definitive .exec/ format specification |
| Readiness Checks | `3-PLAN/skills/ltc-execution-planner/references/agent-readiness-checks.md` | 10-point quality gate checklist |
| WMS Sync Protocol | `3-PLAN/skills/ltc-execution-planner/references/wms-sync-protocol.md` | Sync contract and conflict resolution |

## Templates

| Template | Path | Purpose |
|---|---|---|
| Task File | `3-PLAN/skills/ltc-execution-planner/templates/task.md` | Individual task execution contract |
| Deliverable | `3-PLAN/skills/ltc-execution-planner/templates/deliverable.md` | Deliverable contract with ACs and child tasks |
| Project | `3-PLAN/skills/ltc-execution-planner/templates/project.md` | Execution topology and dependency graph |
| Status Schema | `3-PLAN/skills/ltc-execution-planner/templates/status-schema.json` | JSON Schema for status.json validation |

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

> **NOTE:** This skill is deprecated. Prefer `/dsbv build` which uses `ltc-builder` agent file with context-packaging template. The legacy dispatch below is retained for backward compatibility only.

For deliverables with 3+ tasks or medium+ complexity, use sub-agents:

| Role | Agent File | Model | Scope |
|---|---|---|---|
| Lead (you) | — | Opus | Parse plan, generate project.md, status.json, orchestrate |
| Worker | `.claude/agents/ltc-builder.md` | Sonnet | Generate one deliverable's .exec/ files (deliverable.md + task files) |

Each worker sub-agent dispatch must use the context packaging template (`.claude/skills/dsbv/references/context-packaging.md`):
- **EO:** "Deliverable {name} .exec/ files pass all readiness checks"
- **INPUT:** Context (project identity), Files (deliverable section + templates), Budget (~15K tokens)
- **EP:** EP-10 (Define Done), EP-09 (Decompose) + scope limited to one deliverable
- **OUTPUT:** .exec/ files (deliverable.md + task files) + ACs from readiness-check.py
- **VERIFY:** .exec/ files exist and `scripts/readiness-check.py` exits 0

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

## Gotchas

- **Generating from unapproved plan** — .exec/ files require a frozen Stage 3 plan AND VANA-SPEC. Draft plans produce throwaway work.
- **Empty placeholders** — every section in task files must be filled. "[TBD]" in Environment or Dependencies = execution failure.
- **WMS sync before readiness** — never sync to WMS until all 10 readiness checks pass. Orphaned WMS items are expensive to clean up.

Full list: [gotchas.md](gotchas.md)

## Verification

After generation, run both validators:

```bash
python3 3-PLAN/skills/ltc-execution-planner/scripts/readiness-check.py .exec/
python3 3-PLAN/skills/ltc-execution-planner/scripts/coverage-check.py path/to/spec.md .exec/
```

Both must exit 0 before execution (Stage 5) can begin.

**GATE — Verify:** Confirm `.exec/` directory contains: `project.md`, `status.json`, and at least 1 `D{n}-{Name}/` deliverable directory with task files. Read `status.json` and verify it parses as valid JSON. If any element is missing, generation is incomplete — do not proceed to Stage 5.

If sub-agent dispatch fails (agent returns empty, times out, or produces malformed output): Do NOT retry the same sub-agent more than once. Fall back to generating that deliverable's .exec/ files inline (lead agent does it directly). Report the fallback to the user.

## Gotchas

- **LT-1 Template placeholder residue:** Agent generates .exec/ files that still contain template placeholders like `{TASK_NAME}`, `{AC_ID}`, or `[FILL]` because it copied from the template without fully substituting. After generation, search all .exec/ files for curly-brace placeholders and bracket tags — any found means generation is incomplete.

## Links

- [[CLAUDE]]
- [[EP-09]]
- [[EP-10]]
- [[agent-readiness-checks]]
- [[agent-system]]
- [[context-packaging]]
- [[deliverable]]
- [[dsbv]]
- [[exec-file-format]]
- [[general-system]]
- [[gotchas]]
- [[ltc-builder]]
- [[project]]
- [[task]]
- [[wms-sync-protocol]]
