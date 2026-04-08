---
date: "2026-04-08"
type: capture
source: agent-benchmark.sh v1.2
tags: [benchmark, after-build, layer-1, layer-2, comparison]
---

# Agent Benchmark — AFTER BUILD (2026-04-08)

> Post-BUILD snapshot after executing all 33 tasks across 3 SEQUENCEs (A, B, C).
> Run: `./scripts/agent-benchmark.sh validate --judge`
> Compares against baseline captured pre-BUILD.

## Comparison

```
                        BEFORE     AFTER      DELTA
Safety:                 6/23       23/23      +17
Output Quality:         2/14       14/14      +12
Efficiency:             1/8        8/8        +7
Layer 1 TOTAL:          9/45       45/45      +36
Layer 2 (Opus Judge):   0/10       10/10      +10
COMBINED:               9/55       55/55      +46
                        (16%)      (100%)     
```

---

## Layer 1 — Deterministic Checks (45/45 PASS)

### Safety & Correctness (23/23)

| ID | Before | After | Check |
|----|--------|-------|-------|
| S-01 | FAIL | PASS | Explorer: zero WebSearch false refs |
| S-02 | FAIL | PASS | Planner: no false orchestrator/dispatch |
| S-03 | FAIL | PASS | Planner EP-13: NEVER call Agent() |
| S-04 | FAIL | PASS | ltc-explorer: Safety section exists |
| S-05 | FAIL | PASS | ltc-planner: Safety section exists |
| S-06 | FAIL | PASS | ltc-builder: Safety section exists |
| S-07 | FAIL | PASS | ltc-reviewer: Safety section exists |
| S-08 | FAIL | PASS | Builder: >=6 safety constraints |
| S-09 | FAIL | PASS | Builder: references validate-blueprint |
| S-10 | PASS | PASS | Builder: references skill-validator |
| S-11 | PASS | PASS | Builder: references template-check |
| S-12 | PASS | PASS | ltc-explorer: no self-approval |
| S-13 | PASS | PASS | ltc-planner: no self-approval |
| S-14 | PASS | PASS | ltc-builder: no self-approval |
| S-15 | PASS | PASS | ltc-reviewer: no self-approval |
| S-16 | FAIL | PASS | Explorer: Output Contract section |
| S-17 | FAIL | PASS | Explorer: Pre-Flight section |
| S-18 | FAIL | PASS | Explorer: Post-Flight section |
| S-19 | FAIL | PASS | Planner: Glob in tools |
| S-20 | FAIL | PASS | Planner: Output Contract + BEGIN DESIGN |
| S-21 | FAIL | PASS | Planner: Pre-Design Checklist |
| S-22 | FAIL | PASS | Builder: Glob in tools |
| S-23 | FAIL | PASS | Builder: assumptions/handoff ref |

### Output Quality (14/14)

| ID | Before | After | Check |
|----|--------|-------|-------|
| Q-01 | FAIL | PASS | Reviewer: aggregate score format |
| Q-02 | FAIL | PASS | Reviewer: FAIL-N identifier format |
| Q-03 | PASS | PASS | Reviewer: builder re-dispatch protocol |
| Q-04 | FAIL | PASS | DSBV: Generator/Critic loop |
| Q-05 | FAIL | PASS | DSBV: max_iterations defined |
| Q-06 | FAIL | PASS | DSBV: exit condition defined |
| Q-07 | FAIL | PASS | DSBV: escalation path defined |
| Q-08 | FAIL | PASS | DSBV: circuit breaker + error types |
| Q-09 | FAIL | PASS | DSBV: both Build modes have loop |
| Q-10 | FAIL | PASS | DSBV: structured gate report format |
| Q-11 | FAIL | PASS | Reviewer: Smoke Test / LP-6 ref |
| Q-12 | FAIL | PASS | Reviewer: input pre-flight validation |
| Q-13 | FAIL | PASS | Context-packaging: max_tool_calls |
| Q-14 | PASS | PASS | DSBV: parallel dispatch protocol |

### Operational Efficiency (8/8)

| ID | Before | After | Check |
|----|--------|-------|-------|
| E-01 | FAIL | PASS | Pre-flight script exists |
| E-02 | FAIL | PASS | Pre-flight: valid bash syntax |
| E-03 | FAIL | PASS | Pre-flight: 9 CLAUDE.md checks |
| E-04 | FAIL | PASS | Planner: BLOCKED protocol |
| E-05 | FAIL | PASS | Explorer: honest fallback (QMD only) |
| E-06 | FAIL | PASS | alignment-check.sh exists + valid |
| E-07 | FAIL | PASS | Pipeline state schema documented |
| E-08 | PASS | PASS | Auto-recall: intent-based filtering |

---

## Layer 2 — LLM-as-Judge (10/10 PASS)

| ID | Before | After | What Opus Verified | Evidence |
|----|--------|-------|--------------------|----------|
| J-01 | FAIL | PASS | Builder 14 hook-compensating rules | 14 rules, each with script ref, 1:1 mapping to LP-7 hooks |
| J-02 | FAIL | PASS | Planner EP-13 leaf-node + BLOCKED | "NEVER call Agent()" + explicit BLOCKED protocol |
| J-03 | FAIL | PASS | Reviewer VALIDATE.md v2 complete | Aggregate score, verdict table with Action column, FAIL-{N} with 7 fields |
| J-04 | FAIL | PASS | Generator/Critic loop sound | max_iterations:3, exit:all PASS, structured FAIL→builder handoff, escalation |
| J-05 | FAIL | PASS | Circuit breaker with error types | 4 types (SYNTACTIC/SEMANTIC/ENVIRONMENTAL/SCOPE) + 3 hard stops |
| J-06 | FAIL | PASS | Explorer output contract complete | Required sections, size bounds per tier, citation cross-reference rule |
| J-07 | FAIL | PASS | Planner output contract parseable | BEGIN/END markers typed per output, STATUS/BLOCKERS/ALIGNMENT_CHECK |
| J-08 | FAIL | PASS | Planner blocked protocol coherent | STOP → report → recommend explorer → return partial with % complete |
| J-09 | FAIL | PASS | Builder handoff.json actionable | assumptions[], uncertain_fields[], confidence_score with examples |
| J-10 | FAIL | PASS | Reviewer smoke test safe | Read-only boundary explicit, 5 artifact types with specific commands |

---

## PM Impact: What Changed

| # | Before | After | Benefit to PM |
|---|--------|-------|---------------|
| 1 | Explorer claims WebSearch | Honest fallback: Exa → QMD → STOP | No more silent failures when Exa is down |
| 2 | Planner thinks it's orchestrator | Leaf node with BLOCKED protocol | No silent dispatch failures; planner asks for what it needs |
| 3 | Builder: 0 hook-loss rules | 14 written safety rules | Files created with correct names, frontmatter, routing |
| 4 | No output contracts | Explorer + Planner have typed contracts | Orchestrator can parse output reliably |
| 5 | No pre-flight checks | Explorer + Planner + Reviewer have pre-flights | Bad inputs caught before burning tokens |
| 6 | No Generator/Critic loop | Auto-retry up to 3x with structured feedback | You stop being the retry mechanism |
| 7 | No circuit breaker | 4 error types with intelligent retry/escalate | No more infinite retries on unfixable errors |
| 8 | No aggregate score | VALIDATE.md v2 shows "14/16 PASS" in 1 line | 5-second readiness check vs 5-minute parse |
| 9 | No FAIL-N format | Structured fix instructions for builder | Auto re-dispatch without manual reformatting |
| 10 | No pre-flight script | 9-check deterministic script | Readiness verified by script, not agent memory |
| 11 | No alignment check script | Orphan condition detection automated | Designs can't have untracked criteria |
| 12 | No pipeline state | JSON schema for crash recovery | Session death doesn't lose pipeline progress |
| 13 | No smoke tests | Per-artifact-type verification commands | Broken scripts caught at review, not production |
| 14 | No tool call budgets | max_tool_calls per sub-agent | Token spend is bounded, no runaway builders |

---

## Files Changed

| File | Version | Tasks |
|------|---------|-------|
| `.claude/agents/ltc-explorer.md` | 1.4 → 1.5 | T-E1, T-E2, T-E3, T-E4, T-E5, T-ES, T-E6 |
| `.claude/agents/ltc-planner.md` | 1.4 → 1.5 | T-P1, T-P2, T-P3, T-P4, T-P6, T-PS |
| `.claude/agents/ltc-builder.md` | 1.4 → 1.5 | T-C1, T-C2, T-C3, T-C9 |
| `.claude/agents/ltc-reviewer.md` | 1.3 → 1.4 | T-C4, T-C10, T-C11, T-C12 |
| `.claude/skills/dsbv/SKILL.md` | 1.4 → 1.5 | T-C5, T-C6, T-C8, T-C13, T-C14, T-C17 |
| `.claude/skills/dsbv/references/context-packaging.md` | 1.5 → 1.6 | T-C15, T-C16 |
| `.claude/skills/deep-research/SKILL.md` | bumped | T-E1 |
| `.claude/skills/learn-research/SKILL.md` | bumped | T-E1 |
| `scripts/pre-flight.sh` | new (1.0) | T-C7 |
| `scripts/alignment-check.sh` | new (1.0) | T-P7 |
| `scripts/agent-benchmark.sh` | 1.0 → 1.2 | Test infrastructure |

---

## Execution Stats

| Sequence | Agent | Tasks | ACs | Duration | Model |
|----------|-------|-------|-----|----------|-------|
| SEQ-A (Explorer) | Opus sub-agent | 7/7 | 15/15 | ~4.5 min | claude-opus-4-6 |
| SEQ-B (Planner) | Opus sub-agent | 9/9 | 16/16 | ~4 min | claude-opus-4-6 |
| SEQ-C (Loop System) | Opus sub-agent | 17/17 | 33/33 | ~6.7 min | claude-opus-4-6 |
| **Total** | **3 parallel** | **33/33** | **64/64** | **~6.7 min wall** | |
