---
date: "2026-04-08"
type: capture
source: agent-benchmark.sh v1.2
tags: [benchmark, baseline, pre-build, layer-1, layer-2]
---

# Agent Benchmark Baseline — Pre-BUILD (2026-04-08)

> Snapshot of all 5 agent files BEFORE any P0/P1/P2 fixes are applied.
> Run: `./scripts/agent-benchmark.sh baseline --judge`
> Covers ALL 33 tasks across 3 SEQUENCEs (A, B, C).

## Scores

```
LAYER 1 (Deterministic):      9/45  (20%)
LAYER 2 (Opus Judge):         0/10  (0%)
COMBINED:                     9/55  (16%)
```

| Category | Score | Percent | What it measures |
|----------|-------|---------|-----------------|
| Safety & Correctness | 6/23 | 26% | False claims, missing safety sections, tool refs |
| Output Quality | 2/14 | 14% | Structured formats, loop, circuit breaker, protocols |
| Operational Efficiency | 1/8 | 13% | Scripts, protocols, state management |
| Opus Content Judge | 0/10 | 0% | Are the existing sections *correct and complete*? |

---

## Layer 1 — Deterministic Checks (9/45 PASS)

### Safety & Correctness (6/23)

| ID | Result | Check | Evidence |
|----|--------|-------|----------|
| S-01 | FAIL | Explorer: zero WebSearch false refs | Found 2 refs |
| S-02 | FAIL | Planner: no false orchestrator/dispatch | Found 1 claim |
| S-03 | FAIL | Planner EP-13: NEVER call Agent() | Missing constraint |
| S-04 | FAIL | ltc-explorer: Safety section exists | Not found |
| S-05 | FAIL | ltc-planner: Safety section exists | Not found |
| S-06 | FAIL | ltc-builder: Safety section exists | Not found |
| S-07 | FAIL | ltc-reviewer: Safety section exists | Not found |
| S-08 | FAIL | Builder: >=6 safety constraints | Found 5 (need >=6) |
| S-09 | FAIL | Builder: references validate-blueprint | Missing |
| S-10 | PASS | Builder: references skill-validator | — |
| S-11 | PASS | Builder: references template-check | — |
| S-12 | PASS | ltc-explorer: no self-approval | — |
| S-13 | PASS | ltc-planner: no self-approval | — |
| S-14 | PASS | ltc-builder: no self-approval | — |
| S-15 | PASS | ltc-reviewer: no self-approval | — |
| S-16 | FAIL | Explorer: Output Contract section | Not found |
| S-17 | FAIL | Explorer: Pre-Flight section | Not found |
| S-18 | FAIL | Explorer: Post-Flight section | Not found |
| S-19 | FAIL | Planner: Glob in tools | Not found |
| S-20 | FAIL | Planner: Output Contract + BEGIN DESIGN | Not found |
| S-21 | FAIL | Planner: Pre-Design Checklist | Not found |
| S-22 | FAIL | Builder: Glob in tools | Not found |
| S-23 | FAIL | Builder: assumptions/handoff ref | Not found |

### Output Quality (2/14)

| ID | Result | Check | Evidence |
|----|--------|-------|----------|
| Q-01 | FAIL | Reviewer: aggregate score format | Not found |
| Q-02 | FAIL | Reviewer: FAIL-N identifier format | Not found |
| Q-03 | PASS | Reviewer: builder re-dispatch protocol | — |
| Q-04 | FAIL | DSBV: Generator/Critic loop | Not found |
| Q-05 | FAIL | DSBV: max_iterations defined | Not found |
| Q-06 | FAIL | DSBV: exit condition defined | Not found |
| Q-07 | FAIL | DSBV: escalation path defined | Not found |
| Q-08 | FAIL | DSBV: circuit breaker + error types | No circuit breaker |
| Q-09 | FAIL | DSBV: both Build modes have loop | No loops |
| Q-10 | FAIL | DSBV: structured gate report format | Not found |
| Q-11 | FAIL | Reviewer: Smoke Test / LP-6 ref | Not found |
| Q-12 | FAIL | Reviewer: input pre-flight validation | Not found |
| Q-13 | FAIL | Context-packaging: max_tool_calls | Not found |
| Q-14 | PASS | DSBV: parallel dispatch protocol | — |

### Operational Efficiency (1/8)

| ID | Result | Check | Evidence |
|----|--------|-------|----------|
| E-01 | FAIL | Pre-flight script exists | Not found |
| E-02 | FAIL | Pre-flight: valid bash syntax | Script missing |
| E-03 | FAIL | Pre-flight: 9 CLAUDE.md checks | Script missing |
| E-04 | FAIL | Planner: BLOCKED protocol | Not found |
| E-05 | FAIL | Explorer: honest fallback (QMD only) | WebSearch refs=2 |
| E-06 | FAIL | alignment-check.sh exists + valid | Not found |
| E-07 | FAIL | Pipeline state schema documented | Not found |
| E-08 | PASS | Auto-recall: intent-based filtering | — |

---

## Layer 2 — LLM-as-Judge (0/10 PASS)

| ID | Result | What Opus Evaluated | Opus Evidence |
|----|--------|---------------------|---------------|
| J-01 | FAIL | Builder Sub-Agent Safety maps to 14 hooks | No section exists — 0 hook-mapping rules |
| J-02 | FAIL | Planner EP-13 coherent leaf-node + BLOCKED | Says "MAY dispatch" — no BLOCKED protocol |
| J-03 | FAIL | Reviewer VALIDATE.md v2 complete | Only v1 format — no aggregate, no FAIL-{N}, no builder re-dispatch fields |
| J-04 | FAIL | Generator/Critic loop with cap+exit+handoff | "Do NOT retry more than once" — no loop exists |
| J-05 | FAIL | Circuit breaker with error types + hard stop | No classification, no differentiated strategies |
| J-06 | FAIL | Explorer output contract complete | Protocol mentions sections informally — no formal contract, no size_bounds, no citation rule |
| J-07 | FAIL | Planner output contract parseable | No BEGIN/END markers, no metadata fields |
| J-08 | FAIL | Planner blocked protocol coherent | No structured STOP→report→partial-output flow |
| J-09 | FAIL | Builder handoff.json fields meaningful | No assumptions[], uncertain_fields[], confidence_score |
| J-10 | FAIL | Reviewer smoke test protocol safe | No dedicated section, no per-artifact-type commands, no read-only boundary |

---

## PM Impact Summary

| # | Problem | Impact on PM |
|---|---------|-------------|
| 1 | Explorer claims WebSearch | Silent failures when Exa down |
| 2 | Planner thinks it's orchestrator | Silent dispatch failures |
| 3 | Builder has no hook-loss guardrails | Bad filenames, missing frontmatter, wrong dirs |
| 4 | Explorer no Output Contract | Unstructured research returns — orchestrator can't parse |
| 5 | Explorer no Pre-Flight | Accepts vague inputs, wastes tokens on bad questions |
| 6 | Planner no BEGIN DESIGN markers | Orchestrator can't extract DESIGN.md from planner output |
| 7 | Planner no Pre-Design Checklist | Skips alignment, produces designs against incomplete inputs |
| 8 | Builder no handoff contract | Silent assumption drift between builder→reviewer |
| 9 | No Generator/Critic loop | Every FAIL = manual re-dispatch by you |
| 10 | No circuit breaker | Infinite retries on unfixable errors |
| 11 | No FAIL-N format | Builder can't identify specific fixes |
| 12 | No structured gate report | Human gates lack actionable data |
| 13 | Reviewer no smoke test | Broken scripts pass review |
| 14 | Reviewer no input validation | Reviews run on incomplete data |
| 15 | No pre-flight script | 9-check protocol unreliable from agent memory |
| 16 | No BLOCKED protocol | Planner hallucinates on missing deps |
| 17 | WebSearch phantom tool | Wasted fallback attempts |
| 18 | No alignment-check.sh | Orphan conditions undetected |
| 19 | No pipeline state schema | Can't resume after crash |

---

## Target After BUILD

```
LAYER 1:   45/45  (100%)
LAYER 2:   10/10  (100%)
COMBINED:  55/55  (100%)

Delta:     +46 checks passing (from 9 to 55)
```
