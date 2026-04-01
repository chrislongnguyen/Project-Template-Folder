---
version: "1.1"
last_updated: 2026-03-30
owner: "Long Nguyen"
feature: "multi-agent-orchestration"
branch: "feat/multi-agent-orchestration"
---

# Eval Summary — Multi-Agent Orchestration

> Aggregates build metrics and H-test results for `feat/multi-agent-orchestration`.
> Source data: `h-test-results.md` (same directory). Branch closes with Finalize Batch 2.

---

## 1. Feature Overview

Multi-agent orchestration adds 4 MECE specialist agents (ltc-planner, ltc-builder, ltc-reviewer, ltc-explorer) with explicit scope declarations enforced via agent files. Context packaging v2.0 (5-field EO/INPUT/EP/OUTPUT/VERIFY template) standardizes sub-agent dispatch to reduce token overhead and eliminate exploratory tool calls. Three hooks enforce agent governance at the harness level. Tool routing rules direct research tasks by source-quality vs. speed trade-off. The feature adds 3 new EPs (EP-11, EP-12, EP-13), extends EP-03, and delivers 13 total entry points across the agent system.

---

## 2. Build Metrics

| Phase | Tasks | Sub-Agents | Model | Total Tokens | Duration |
|---|---|---|---|---|---|
| Foundation (T0.1–T0.4) | 4 | 0 (lead only) | Opus | — | Session 1 |
| Slice 1 (T1.1–T1.5) | 5 | 0 (lead only) | Opus | — | Session 1 |
| Slice 2 (T2.1–T2.5) | 5 | 0 (lead only) | Opus | — | Session 1 |
| Slice 3 (T3.1–T3.2) | 2 | 0 (lead only) | Opus | — | Session 1 |
| Slice 4 (T4.1–T4.2) | 2 | 2 Sonnet | Sonnet | — | Session 1 |
| H-Tests (H1+H2+H5) | 6 | 4 Sonnet + 2 Haiku | Mixed | 175,482 | Session 2 |
| Slice 5 (T5.1–T5.6) | 6 | 3 Sonnet | Sonnet | 93,253 | Session 2 |
| Finalize Batch 1 | 3 | 3 Sonnet | Sonnet | TBD (in progress) | Session 2 |
| Finalize Batch 2 | 4 | 2 Sonnet | Sonnet | TBD (pending) | Session 2 |

**Note:** Foundation through Slice 3 built by lead Opus agent directly — no sub-agent dispatch, token counts not captured. Slice 4+ used sub-agents with captured metrics.

---

## 3. Hypothesis Test Summary

| Hypothesis | Gate | Result | Token Delta | Key Insight |
|---|---|---|---|---|
| H1: Agent scope | B >= A on 3/4 | PASS | -1% | Scope enforcement, not cost savings |
| H2: Exa vs WebSearch | >= 30% token reduction | FAIL | -2% | Exa faster but WebSearch higher quality |
| H5: Context packaging | B >= A on 4/5 | PASS | -37% | Fewer tokens, zero tool calls, less hallucination |

H-test totals: 175,482 tokens across 6 sub-agent dispatches (4x Sonnet, 2x Haiku).

---

## 4. Design Decisions Informed by H-Tests

- **Agent files with scope declarations:** KEEP — H1 validates behavioral constraint value (scope enforcement, not token savings)
- **Exa as mandatory primary:** REVISED to peer alongside WebSearch — H2 shows Exa yields 0 academic papers vs. 3 for WebSearch on equivalent queries
- **Context packaging v2.0:** KEEP and STRENGTHEN — H5 validates 37% token reduction and elimination of exploratory tool calls
- **VERIFY field in context packaging:** highest-leverage single addition — embeds EP-10 (Define Done) at the sub-agent level, eliminated 4 tool calls in H5 treatment

---

## 5. Artifacts Produced

| Type | Count | Location |
|---|---|---|
| Agent files | 4 | `.claude/agents/` |
| Hooks | 3 | `.claude/hooks/` |
| Skills modified | 5 | `.claude/skills/` |
| Rules created | 1 | `rules/tool-routing.md` |
| Rules modified | 1 | `rules/agent-system.md` |
| References created | 2 | `_genesis/reference/` (multi-agent-build.md, context-packaging.md) |
| EPs added | 3 | EP-11, EP-12, EP-13 |
| EPs extended | 1 | EP-03 |
| ADRs | 1 | ADR-002 |
| Eval artifacts | 2 | `5-IMPROVE/metrics/multi-agent-eval/` (h-test-results.md, this file) |
| **Total** | **~23** | |

---

## 6. Open Items

- **T0.5 baseline capture:** deferred — requires live `/deep-research` run in a dedicated session
- **H2 re-test:** recommended after Exa index updates; current result may be index-state dependent
- **Context packaging 37% reduction:** validate across diverse task types in I2 — H5 tested one EP-creation task; generalizability not yet confirmed
