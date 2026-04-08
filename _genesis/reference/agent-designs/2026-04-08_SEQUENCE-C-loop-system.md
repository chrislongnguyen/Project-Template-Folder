---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: sequence
work_stream: 0-GOVERN
agents: [orchestrator, builder, reviewer]
parent:
  - inbox/2026-04-08_DESIGN-agent-0-orchestrator.md
  - inbox/2026-04-08_DESIGN-agent-3-builder.md
  - inbox/2026-04-08_DESIGN-agent-4-reviewer.md
scope: all-proposals
---

# SEQUENCE C: Agents 0+3+4 — Loop System + All Proposals

> **DESIGNs:** Agent 0 (11 proposals), Agent 3 (5 proposals), Agent 4 (7 proposals) = 23 proposals total.
> **Path:** CROSS-CUTTING — Generator/Critic loop spans all 3 agents. Hook mirroring spans all 4 sub-agents (2 here + 2 in SEQ-A/B). Orchestrator proposals are independent internally but the loop connects to builder+reviewer.
> **Deduplication:** 4 proposals are shared across agents (marked with ═ below). 23 proposals → 19 unique tasks + 4 deduped = 19 tasks.
> **Execution mode:** Main session Opus direct.
> **Effort:** ~6 hrs total.

---

## Cross-Cutting Map

```
═ Generator/Critic loop:  Orch P0-1 = Builder P0 = Reviewer P0    → T-C5 (1 task, 3 files)
═ Circuit breaker:        Orch P0-2 = Builder P2                   → T-C6 (1 task, 1 file)
═ Hook mirroring:         Orch P0-3 → Builder + Reviewer here      → T-C1, T-C4
                          (Explorer + Planner mirroring in SEQ-A/B)
═ Error classification:   Orch P1-4 = Builder P2                   → T-C6 (merged with circuit breaker)
```

---

## Dependency DAG

```
BUILDER TRACK:
T-C1 (Builder hook mirroring)     ──┬── T-C5 (Generator/Critic loop)
T-C2 (Builder EOP validation)     ──┤         │
T-C3 (Builder handoff.json)       ──┘         │
T-C9 (Builder add Glob)           ── independent

REVIEWER TRACK:
T-C4 (Reviewer hook mirroring)    ──┬── T-C5
T-C10 (Reviewer VALIDATE.md v2)   ──┤
T-C11 (Reviewer smoke test)       ──┘
T-C12 (Reviewer pre-flight input) ── independent

ORCHESTRATOR TRACK:
T-C5 (Generator/Critic loop)     ──→ T-C6 (Circuit breaker)
T-C7 (Pre-flight script)         ── depends on T-C1/C2 (agent files done)
T-C8 (Pipeline state persistence) ── independent
T-C13 (Auto-recall filtering)    ── independent
T-C14 (Structured gate reports)  ── independent
T-C15 (Tool call budgets)        ── independent
T-C16 (EP task-type filtering)   ── independent
T-C17 (Parallel dispatch protocol)── depends on T-C5 (loop must exist first)
```

---

## Tasks — Builder (Agent 3)

### T-C1: Builder Hook Constraint Mirroring [P0, 15 min]

**File (Write):** `.claude/agents/ltc-builder.md`
**DESIGN:** Agent 3 § EOE Layer 3, Agent 0 § P0-3

**Change:** Add `## Sub-Agent Safety` with 10 rules compensating for 14 lost hooks:
1. UNG naming (naming-lint.sh)
2. Frontmatter injection (inject-frontmatter.sh)
3. DSBV prerequisite check (dsbv-skill-guard.sh)
4. Chain-of-custody (dsbv-gate.sh)
5. No self-approve (status-guard.sh)
6. Version registry sync (registry-sync-check.sh)
7. Wikilink resolution (link-validator.sh)
8. Skill validation (skill-validator.sh)
9. Routing check (validate-blueprint.py)
10. Context awareness (strategic-compact.sh)

**ACs:**
1. `grep -c 'Sub-Agent Safety' .claude/agents/ltc-builder.md` = 1
2. `grep -c 'naming-lint\|status-guard\|validate-blueprint' .claude/agents/ltc-builder.md` ≥3

---

### T-C2: Builder EOP Explicit Validation Scripts [P0, 10 min]

**File (Write):** `.claude/agents/ltc-builder.md`
**DESIGN:** Agent 3 § EA Gap G-EA-1

**Change:** Expand Quality Checkpoints to 7 steps: add routing check, compliance scripts (skill-validator, validate-blueprint, template-check), pre-commit checks.

**ACs:**
1. `grep -c 'validate-blueprint' .claude/agents/ltc-builder.md` ≥1
2. `grep -c 'template-check' .claude/agents/ltc-builder.md` ≥1
3. `grep -c 'Pre-commit' .claude/agents/ltc-builder.md` ≥1

---

### T-C3: Builder Handoff.json Proposal [P1, 20 min]

**File (Write):** `.claude/agents/ltc-builder.md`
**DESIGN:** Agent 3 § EO Proposed Output Contract

**Change:** Add to completion report format:
```
In addition to DONE: <path> | ACs: <pass>/<total> | Blockers:
Builder SHOULD also report (when applicable):
- assumptions: what upstream claims builder relied on
- uncertain_fields: what builder wasn't sure about
- confidence_score: 0.0-1.0
```

**ACs:**
1. `grep -c 'assumptions\|handoff' .claude/agents/ltc-builder.md` ≥1

---

### T-C9: Builder Add Glob [P2, 5 min]

**File (Write):** `.claude/agents/ltc-builder.md`
**DESIGN:** Agent 3 § EOT Proposed Addition

**Change:** Add Glob to tools line + Tool Guide row.

**ACs:**
1. `grep -c 'Glob' .claude/agents/ltc-builder.md` ≥2

---

## Tasks — Reviewer (Agent 4)

### T-C4: Reviewer Hook Constraint Mirroring [P0, 5 min]

**File (Write):** `.claude/agents/ltc-reviewer.md`

**Change:** Add `## Sub-Agent Safety`:
```
- NEVER set status: validated
- Verify criterion count matches DESIGN.md
- No context compaction warning fires — monitor on large workstreams
```

**AC:** `grep -c 'Sub-Agent Safety' .claude/agents/ltc-reviewer.md` = 1

---

### T-C10: Reviewer VALIDATE.md v2 Format [P0, 20 min]

**File (Write):** `.claude/agents/ltc-reviewer.md`
**DESIGN:** Agent 4 § EO Proposed VALIDATE.md v2

**Change:** Add `## Output Format (VALIDATE.md v2)`:
- Aggregate score line: `X/N PASS | Y FAIL | Z PARTIAL`
- Action column in verdict table
- FAIL items as structured builder EI: FAIL-{N}, file, expected, actual, fix, AC
- Severity ranking on FAIL items (blocker vs cosmetic)

**ACs:**
1. `grep -c 'Aggregate Score' .claude/agents/ltc-reviewer.md` ≥1
2. `grep -c 'FAIL-{N}\|FAIL-[0-9]' .claude/agents/ltc-reviewer.md` ≥1
3. `grep -c 'Builder Re-Dispatch\|builder.*EI\|re-dispatch' .claude/agents/ltc-reviewer.md` ≥1
4. `grep -c 'severity\|blocker\|cosmetic' .claude/agents/ltc-reviewer.md` ≥1

---

### T-C11: Reviewer Smoke Test Protocol [P1, 15 min]

**File (Write):** `.claude/agents/ltc-reviewer.md`
**DESIGN:** Agent 4 § EA Gap GAP-EA-2, LP-6

**Change:** Add `## Smoke Test Protocol (LP-6)`:
- Shell scripts: `bash -n script.sh`
- Python: `python3 -c "import module"`
- HTML: validate with tidy
- Skills: `./scripts/skill-validator.sh`
- Boundary: read-only smoke tests only

**AC:** `grep -c 'Smoke Test\|LP-6' .claude/agents/ltc-reviewer.md` ≥1

---

### T-C12: Reviewer Pre-Flight Input Validation [P1, 10 min]

**File (Write):** `.claude/agents/ltc-reviewer.md`
**DESIGN:** Agent 4 § EI Gap GAP-EI-1

**Change:** Add pre-flight check: verify DESIGN.md is present in context, criterion count > 0, all artifact paths accessible.

**AC:** `grep -c 'pre-flight\|Pre-Flight\|input validation' .claude/agents/ltc-reviewer.md` ≥1

---

## Tasks — Orchestrator (Agent 0) / /dsbv Skill

### T-C5: Generator/Critic Loop [P0, 1 hr] ═ CROSS-CUTTING

**File (Write):** `.claude/skills/dsbv/SKILL.md`
**DESIGN:** Agent 0 § P0-1, Agent 3 § Proposal 1, Agent 4 § Generator/Critic Loop Design

**Change:** Add loop to Phase 3 BUILD (both single-agent and multi-agent):
- Dispatch reviewer after build
- If FAIL + iter < max: format FAIL items as builder EI, re-dispatch, re-validate
- If FAIL + iter = max: escalate to Human Director with diagnostic
- Parameters: max_iterations=3, exit=all PASS, cost cap ~$0.06

**ACs:**
1. `grep -c 'Generator/Critic\|generator.*critic' .claude/skills/dsbv/SKILL.md` ≥1
2. `grep -c 'max_iterations' .claude/skills/dsbv/SKILL.md` ≥1
3. `grep -c 'FAIL items\|FAIL-' .claude/skills/dsbv/SKILL.md` ≥1
4. `grep -c 'ESCALATE\|escalat' .claude/skills/dsbv/SKILL.md` ≥1

---

### T-C6: Circuit Breaker + Error Classification [P0, 30 min] ═ CROSS-CUTTING

**Depends on:** T-C5
**File (Write):** `.claude/skills/dsbv/SKILL.md`
**DESIGN:** Agent 0 § P0-2 + P1-4

**Change:** Add after loop:
- Error types: SYNTACTIC (retry), SEMANTIC (escalate), ENVIRONMENTAL (fix+retry), SCOPE (escalate)
- Hard stops: same FAIL persists 2 iterations → escalate; 2 consecutive agent failures → stop pipeline
- Diagnostic order: EP→Input→EOP→EOE→EOT→Agent

**ACs:**
1. `grep -c 'SYNTACTIC\|SEMANTIC\|ENVIRONMENTAL' .claude/skills/dsbv/SKILL.md` ≥1
2. `grep -c 'Circuit [Bb]reaker\|circuit.break' .claude/skills/dsbv/SKILL.md` ≥1

---

### T-C7: Pre-Flight Automation Script [P0, 45 min]

**Depends on:** T-C1, T-C2 (agent files finalized)
**File (Write — new):** `scripts/pre-flight.sh`
**DESIGN:** Agent 0 § P0-4

**Change:** Create script implementing 9 CLAUDE.md pre-flight checks. Outputs PASS/FAIL/WARN per check.

**ACs:**
1. `test -f scripts/pre-flight.sh` exits 0
2. `bash -n scripts/pre-flight.sh` exits 0
3. `./scripts/pre-flight.sh 1-ALIGN` runs without crash

---

### T-C8: Pipeline State Persistence [P1, 30 min]

**File (Write — new):** schema for `.claude/state/pipeline.json`
**DESIGN:** Agent 0 § P1-1

**Change:** Define schema + update state-saver.sh and session-reconstruct.sh to read/write:
```json
{
  "workstream": "4-EXECUTE",
  "phase": "build",
  "task_id": "T3.2",
  "completed_tasks": ["T1.1", "T1.2"],
  "last_sub_agent": "ltc-builder",
  "last_result": "PASS",
  "updated": "2026-04-08T14:30:00Z"
}
```

**ACs:**
1. Schema documented (in /dsbv references or inline)
2. state-saver.sh updated to write pipeline state
3. session-reconstruct.sh updated to read pipeline state

---

### T-C13: Auto-Recall Relevance Filtering [P1, 20 min]

**File (Write):** UserPromptSubmit hook script (thinking-modes.sh or separate)
**DESIGN:** Agent 0 § P1-2

**Change:** Extract task type from user message, pass as `intent` to QMD query. Reduce injection from 2000 to 1000 tokens when confidence < 0.5.

**ACs:**
1. QMD query includes `intent` parameter derived from user message
2. Token budget adjusts based on relevance score

---

### T-C14: Structured Gate Reports [P1, 15 min]

**File (Write):** `.claude/skills/dsbv/SKILL.md`
**DESIGN:** Agent 0 § P1-3

**Change:** Add gate presentation template:
```
GATE: G{N} ({phase}) | Workstream: {name}
ACs: {pass}/{total} | Risk flags: {count}
Action: APPROVE / REVISE / ESCALATE
```

**AC:** `grep -c 'GATE: G' .claude/skills/dsbv/SKILL.md` ≥1

---

### T-C15: Sub-Agent Tool Call Budgets [P2, 15 min]

**File (Write):** `.claude/skills/dsbv/references/context-packaging.md`
**DESIGN:** Agent 0 § P2-1

**Change:** Add `budget: {max_tool_calls: N}` to context packaging template. Builder default: 50. Explorer default: 20.

**AC:** `grep -c 'max_tool_calls' .claude/skills/dsbv/references/context-packaging.md` ≥1

---

### T-C16: EP Task-Type Filtering [P2, 15 min]

**File (Write):** `.claude/skills/dsbv/references/context-packaging.md` or new reference
**DESIGN:** Agent 0 § P2-2

**Change:** Map task types to applicable EPs:
- Research: EP-01, EP-04, EP-08
- Design: EP-01, EP-05, EP-09, EP-10
- Build: EP-01, EP-05, EP-10, EP-14
- Validate: EP-01, EP-10, EP-12

**AC:** EP-to-task-type mapping documented.

---

### T-C17: Parallel Dispatch Protocol [P2, 20 min]

**Depends on:** T-C5 (loop must exist)
**File (Write):** `.claude/skills/dsbv/SKILL.md` or reference
**DESIGN:** Agent 0 § P2-3

**Change:** When tasks in SEQUENCE.md are marked independent, dispatch simultaneously. Add independence declaration to SEQUENCE.md format.

**AC:** `grep -c 'parallel\|simultaneous\|independent' .claude/skills/dsbv/SKILL.md` ≥1 (in new section)

---

## Execution Order

```
Round 1 — Agent file foundations (parallel):
  T-C1   Builder hook mirroring          [15m]   P0
  T-C2   Builder EOP validation          [10m]   P0
  T-C4   Reviewer hook mirroring         [5m]    P0
  T-C10  Reviewer VALIDATE.md v2         [20m]   P0
  T-C9   Builder add Glob               [5m]    P2
  T-C12  Reviewer pre-flight input       [10m]   P1

Round 2 — Improvements + loop prereqs (parallel):
  T-C3   Builder handoff.json            [20m]   P1
  T-C11  Reviewer smoke test             [15m]   P1
  T-C8   Pipeline state persistence      [30m]   P1
  T-C13  Auto-recall filtering           [20m]   P1

Round 3 — Core loop (sequential):
  T-C5   Generator/Critic loop           [1hr]   P0  ═ CROSS-CUTTING
  T-C6   Circuit breaker                 [30m]   P0  ═ CROSS-CUTTING

Round 4 — Loop dependents + scripts (parallel):
  T-C7   Pre-flight script               [45m]   P0
  T-C14  Structured gate reports         [15m]   P1
  T-C17  Parallel dispatch protocol      [20m]   P2

Round 5 — Context packaging refinements (parallel):
  T-C15  Tool call budgets               [15m]   P2
  T-C16  EP task-type filtering          [15m]   P2

Total: ~6 hrs
```

## Version Bumps

| File | Current | New |
|------|---------|-----|
| `.claude/agents/ltc-builder.md` | 1.4 | 1.5 |
| `.claude/agents/ltc-reviewer.md` | 1.3 | 1.4 |
| `.claude/skills/dsbv/SKILL.md` | 1.4 | 1.5 |
| `.claude/skills/dsbv/references/context-packaging.md` | 1.5 | 1.6 |
| `scripts/pre-flight.sh` | new | 1.0 |

## Links

- [[2026-04-08_DESIGN-agent-0-orchestrator]]
- [[2026-04-08_DESIGN-agent-3-builder]]
- [[2026-04-08_DESIGN-agent-4-reviewer]]
- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-01]]
- [[EP-04]]
- [[EP-05]]
- [[EP-08]]
- [[EP-09]]
- [[EP-10]]
- [[EP-12]]
- [[EP-14]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[blocker]]
- [[context-packaging]]
- [[ltc-builder]]
- [[ltc-reviewer]]
- [[schema]]
- [[task]]
- [[workstream]]
