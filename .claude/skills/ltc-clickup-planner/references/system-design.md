# ClickUp Planner-Executor System Design

> Standalone design reference for the full plan-execute-complete pipeline.
> Three planes (Planner, Executor, Hooks), zero overlap.
> Grounded in LTC Systems Thinking (Nodes & Edges, Feedback Loops, Leverage Points) and Agent System (7-CS, 8 LTs).

---

## Architecture Overview

```
PHASE 1 — PLAN (clickup-planner skill)
  │
  ├─ Output: ① ClickUp Items  ② Agent Team Blueprint  ③ Hooks Configuration
  │
  ⛔ HUMAN GATE — user reviews plan, confirms List placement, says "execute"
  │
PHASE 2 — EXECUTE (clickup-executor agent team)
  │
  ├─ Lead Agent: reads Blueprint, creates shared task list, spawns teammates
  ├─ Domain Teammates (1 per parallel lane): self-claim Increments, write code
  ├─ Scoped Reviewers (1 per Deliverable): review completed work (LT-3 safe)
  ├─ Hooks Layer: TaskCompleted → ClickUp sync, TeammateIdle → review trigger, Blocker → auto-create
  │
PHASE 3 — COMPLETE + LEARN
  │
  ├─ Cascade completion: Increment → Task → Deliverable → Project
  ├─ Calibration report: est. vs actual, accuracy by category, recommendations
  └─ Cleanup: shut down teammates, final sync, session summary to vault
```

### Three Planes, Zero Overlap

| Plane | Owns | Never touches |
|---|---|---|
| **Planner** (skill) | ClickUp items, VANA, hierarchy, Blueprint | Code, files |
| **Teammates** (agent team) | Code, tests, files | ClickUp status |
| **Hooks** (shell scripts) | ClickUp status sync, timing, blocker creation | Code reasoning, planning decisions |

**Multiplicative function:** If any plane goes to zero, the system fails. But each plane lowers the threshold for the others. Strong hooks make teammate requirements more forgiving. Good Blueprints make lead orchestration simpler. Accurate calibration makes planning faster.

---

## Hierarchy Model

```
PJ Project
  └─ PJ Deliverable
      └─ Task
          ├─ PJ Increment     (the testable work, 1..N)
          ├─ PJ Blocker        (impediments, 0..N, reactive)
          └─ PJ Documentation  (reference doc, 1 per Task)
```

---

## Phase 1 — Plan (clickup-planner skill)

### Steps
0. Load context + field map
1. Scope + classify hierarchy
2. Draft VANA + AC + time estimates
3. **2f: Generate Agent Team Blueprint** (teammate assignments, file boundaries, parallel/sequential lanes, critical path)
4. Quality gate (12 checks)
5. **Preview on screen → Discuss List placement with user**
6. Parallel sub-agents create ClickUp items
7. **4d: Configure TaskCompleted hook**
8. Validate

### Three Output Artifacts

**① ClickUp Items:** PJ Project → PJ Deliverables → Tasks → Increments + Documentation. Each with: VANA (custom field), AC (custom field), MoSCoW (dropdown), time estimate, dependencies.

**② Agent Team Blueprint** (in PJ Project description):
```
Execution Topology:
  D1 → D2 → D3 ──┬──→ D4 (parallel)
                  ├──→ D5 (parallel)
                  └──→ D6 (parallel)
  D7 (after D5+D6) → D8

Teammate Assignments:
  "D4-Context"  → owns: context.py, manager.py | claims: Task 4.1, 4.2
  "D5-CLI"      → owns: cli.py               | claims: Task 5.1-5.3
  "D6-Import"   → owns: importers/, mirror.py | claims: Task 6.1-6.3
  File boundaries: no overlap between teammates

Reviewers: 1 per Deliverable (scoped, LT-3 safe)
Critical path: D1 → D2 → D3 → D6 → D7 → D8
```

**③ Hooks Configuration:** Shell scripts for TaskCompleted, TeammateIdle, Blocker Detection.

---

## Phase 2 — Execute (clickup-executor agent team)

### Agents

| Agent | Role | Tools | ClickUp Access |
|---|---|---|---|
| **Lead** | Reads Blueprint, creates shared task list, spawns teammates, monitors progress, cascades completion | Agent, Read, ClickUp MCP | Yes (read-only for state) |
| **Domain Teammate** (1 per parallel lane) | Self-claims Increments from task list, writes code, runs tests | Write, Edit, Bash, Read, Grep, Glob | **No** |
| **Scoped Reviewer** (1 per Deliverable) | Reviews completed Increments for spec compliance + code quality | Read, Grep, Glob | **No** |

### Execution Flow (per Task)

1. Teammate claims Increment from shared task list
2. Teammate writes code + tests
3. Teammate marks task complete in shared task list
4. **Hook fires:** TaskCompleted → ClickUp status `in progress` → `draft completed` + timing comment
5. Scoped Reviewer reviews the Increment
6. If review fails → teammate fixes → re-review
7. Next Increment (or blocker)
8. All Increments done → Lead cascades: Task → `draft completed`

### Why 1 Reviewer per Deliverable (not 1 for all)

Per LT-3: reasoning degrades on complex tasks. 0.9^N per step.

| Setup | Items reviewed | Quality per item |
|---|---|---|
| 1 reviewer, 28 Increments | 28 | 0.9^28 ≈ 5% |
| 1 reviewer per Deliverable (~5 items) | ~5 | 0.9^5 ≈ 59% |

**12x improvement** in review quality by scoping reviewers to their Deliverable.

---

## Governance Layer — Deterministic Hooks

Hooks are shell scripts, not agents. They fire on events, not on agent memory. Zero LT-8 risk.

### TaskCompleted Hook
- **Fires:** when a teammate marks a task complete in the shared task list
- **Does:** ClickUp API call: status → `draft completed` + timing comment (start → end) + calibration data
- **Determinism:** 100% — shell script, not agent decision

### TeammateIdle Hook
- **Fires:** when a teammate finishes all claimed tasks
- **Does:** check unclaimed tasks in shared list → if yes: exit code 2 (keep working) → if no: trigger scoped reviewer
- **Determinism:** 100%

### Blocker Detection Hook
- **Fires:** when a teammate reports blocked
- **Does:** auto-create PJ Blocker on ClickUp + notify lead + set dependency link
- **Determinism:** 100%

---

## Phase 3 — Complete + Learn

### Cascade Completion
Lead checks Must Have children at each level:
- All Increments + Blockers resolved → Task → `draft completed`
- All Tasks resolved → Deliverable → `draft completed`
- All Deliverables resolved → Project → `draft completed`
- User approves → `done`

### Calibration Report (auto-generated from hook data)
```
Project Calibration — {Project Name}
Increments: {N} | Avg ratio: {X}x
Worst: {Deliverable} ({ratio}x) | Best: {Deliverable} ({ratio}x)
Pattern: {systematic bias description}
Recommendation: {adjustment for next project}
```

### Cleanup
1. Lead shuts down all teammates
2. Cleans up team resources
3. Final ClickUp status sync
4. Session summary → Memory Vault

---

## Feedback Loops

### Balancing Loops (self-correcting → stability)

| ID | Loop | Nodes → Edges | Prevents |
|---|---|---|---|
| B1 | Quality Gate | Agent output → Scoped reviewer → Issues? → Fix → Re-review | Quality drift compounding |
| B2 | Completion Cascade | Parent status → Check Must Have children → Unresolved? → HALT | False "done" propagating upward |
| B3 | Blocker Detection | Teammate blocked → Hook auto-creates PJ Blocker → Lead notified | Silent stalls |
| B4 | Discuss-Before-Write | Draft plan → Human reviews → Wrong scope/List? → Revise | Items in wrong location |

### Reinforcing Loops (amplifying → compound growth)

| ID | Loop | Nodes → Edges | Compounds |
|---|---|---|---|
| R1 | Calibration Compound | Execution data → Calibration report → Better estimates → Better execution → More data | Each project makes the next faster |
| R2 | Parallel Throughput | Independent lanes → N teammates → More output/hr → More data for R1 | Parallelism feeds calibration |
| R3 | Blueprint Refinement | Execution patterns → Optimal team structures → Better Blueprints → More effective teams | Team design improves |
| R4 | Risk Registry Learning | Resolved blockers → Pattern detection → Pre-blockers in future plans → Fewer surprises | Past blockers become future mitigation |

---

## Leverage Points

| Point | Intervention Size | Loops Activated | Why Disproportionate |
|---|---|---|---|
| **Hooks** | 3 scripts, ~150 lines | B2, B3, feeds R1 | Eliminates 100% of LT-8 governance risk |
| **Agent Team Blueprint** | 1 section in PJ Project | R2, R3 | Any agent in any context self-organizes correctly |
| **Scoped Reviewers** | N reviewers instead of 1 | B1 | 12x review quality improvement |
| **Calibration Data** | 1 comment per Increment (auto) | R1, R4 | Compounds: 60% → 85% estimation accuracy over 3 projects |

---

## 7-CS Component Mapping

| 7-CS | Planner (Skill) | Executor (Agent Team) | Hooks (Shell) |
|---|---|---|---|
| **EP (C1)** | VANA rules, UNG naming, field map | CLAUDE.md per teammate | Status transition rules |
| **Input (C2)** | Spec, plan, user context | Blueprint + ClickUp task details | Task completion event |
| **EOP (C3)** | create-flow, update-flow | Lead orchestration + shared task list | Hook scripts |
| **Env (C4)** | Claude Code + ClickUp MCP | Worktrees + tmux | Shell environment |
| **Tools (C5)** | ClickUp MCP only | Write, Edit, Bash (no ClickUp) | ClickUp API (curl) |
| **Agent (C6)** | Sonnet | Lead: Sonnet · Coders: Sonnet · Reviewers: Opus | N/A (code) |
| **Action (C7)** | ClickUp items created | Code written + tested + reviewed | ClickUp synced + calibration |

## Links

- [[AGENTS]]
- [[alpei-blueprint]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SKILL]]
- [[VALIDATE]]
- [[architecture]]
- [[blocker]]
- [[create-flow]]
- [[deliverable]]
- [[documentation]]
- [[increment]]
- [[project]]
- [[task]]
- [[update-flow]]
