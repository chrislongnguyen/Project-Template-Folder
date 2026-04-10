---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: benchmark-report
work_stream: 5-IMPROVE
---

# LEARN Skills Benchmark — Results Report

**Date:** 2026-04-08
**Design:** `inbox/2026-04-08_DESIGN-learn-benchmark.md`
**Scripts:** `scripts/learn-benchmark.sh`, `learn-benchmark-l1.py`, `learn-benchmark-l2.py`, `learn-benchmark-l3-rubric.md`
**Purpose:** Empirically determine whether LEARN skills need agent-level fixes (Item 2 from I2 gap list)

---

## Executive Summary

| Layer | Result | Score |
|-------|--------|-------|
| L1 (Static Contract) | **PASS** | 50/51 (98%) — 0 FAIL, 1 WARN |
| L2 (State Simulation) | **PASS** | 8/8 (100%) — 0 FAIL |
| L3 (LLM-as-Judge) | **PASS** | 0 FAIL (score ≤2), 7 WARN (score = 3) across 63 cells |

**Verdict: Item 2 (LEARN pipeline agent awareness) is NOT needed.** Skills handle all routing, enforcement, and DSBV isolation without agent-level changes.

---

## L1: Static Contract Validation

Script: `python3 scripts/learn-benchmark-l1.py`

### Results by Skill

| Skill | S-PATH | S-AGENT | S-GATE | S-NODSBV | S-FRONT | E-MODEL | E-TOOLS | E-NOOVER | SC-PRECK | SC-ERROR | SC-STATE | Total |
|-------|--------|---------|--------|----------|---------|---------|---------|----------|----------|----------|----------|-------|
| learn | - | - | - | PASS | - | - | PASS | PASS | PASS | - | PASS | 5/5 |
| learn-input | PASS | - | PASS | PASS | WARN | - | PASS | PASS | PASS | - | - | 6/7 |
| learn-research | PASS | PASS | - | PASS | PASS | - | PASS | - | PASS | PASS | - | 7/7 |
| learn-structure | PASS | - | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | - | 10/10 |
| learn-review | PASS | - | PASS | PASS | PASS | - | PASS | PASS | PASS | PASS | - | 9/9 |
| learn-spec | PASS | - | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | - | 10/10 |
| learn-visualize | - | - | PASS | PASS | - | - | PASS | PASS | PASS | PASS | - | 6/6 |

**1 WARN:** learn-input S-FRONT — no explicit frontmatter instructions for output files. The learn-input template handles this implicitly (template has frontmatter), but the SKILL.md doesn't instruct it.

---

## L2: State Simulation Fixtures

Script: `python3 scripts/learn-benchmark-l2.py`

| Fixture | Description | Expected Route | Actual Route | Result |
|---------|-------------|---------------|--------------|--------|
| F1-EMPTY | Empty _cross/ dir | /learn:input | /learn:input | PASS |
| F2-INPUT | Input exists, no research | /learn:research test-system | /learn:research test-system | PASS |
| F3-RSCH | Research exists, no P-pages | /learn:structure test-system 0 | /learn:structure test-system 0 | PASS |
| F4-STRUC | 6 P-pages, not validated | /learn:review test-system 0 | /learn:review test-system 0 | PASS |
| F5-VALID | All P-pages validated, no spec | /learn:spec test-system | /learn:spec test-system | PASS |
| F6-DONE | Pipeline complete | complete | complete | PASS |
| F7-PARTIAL | 3 topics, 2 done, 1 not | /learn:structure test-system 2 | /learn:structure test-system 2 | PASS |
| F8-MIXED | T0 validated, T1 draft | /learn:review test-system 1 | /learn:review test-system 1 | PASS |

**All 8 fixtures pass.** State detection logic correctly routes every pipeline state.

---

## L3: LLM-as-Judge (Opus)

5 Opus reviewers scored 7 skills across 9 dimensions (63 cells total).

### Full Scorecard

```
Skill            │ S1 │ S2 │ S3 │ E1 │ E2 │ E3 │Sc1 │Sc2 │Sc3 │ Total │ Warns
─────────────────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼───────┼──────
learn            │  4 │  5 │  4 │  3 │  4 │  5 │  5 │  5 │  5 │ 40/45 │ E1
learn-input      │  4 │  5 │  4 │  4 │  4 │  5 │  4 │  4 │  3 │ 37/45 │ Sc3
learn-research   │  4 │  3 │  4 │  5 │  3 │  5 │  5 │  4 │  4 │ 37/45 │ S2,E2
learn-structure  │  4 │  5 │  4 │  5 │  4 │  5 │  5 │  4 │  4 │ 40/45 │ —
learn-review     │  4 │  5 │  5 │  3 │  4 │  5 │  5 │  4 │  4 │ 39/45 │ E1
learn-spec       │  5 │  5 │  5 │  5 │  4 │  5 │  5 │  5 │  5 │ 44/45 │ —
learn-visualize  │  4 │  5 │  4 │  3 │  3 │  5 │  5 │  4 │  3 │ 36/45 │ E1,E2,Sc3
─────────────────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴───────┴──────
                                                      Avg: 39.0/45 (87%)
```

### FAIL count: 0 (no dimension scored ≤ 2)

### WARN patterns (score = 3)

| Pattern | Affected Skills | Root Cause | Severity |
|---------|----------------|------------|----------|
| E1: No model declaration | learn, learn-review, learn-visualize | Runs at caller model — may overspend on Opus when Sonnet suffices | Low — cosmetic |
| E2: Over-provisioned tools | learn-research (Bash), learn-visualize (Grep) | 1-2 tools unnecessary but not harmful | Low — cosmetic |
| S2: No explicit DSBV prohibition | learn-research | Implicitly safe (only produces research files), but no guard statement | Low — defense-in-depth gap |
| Sc3: No downstream handoff | learn-input, learn-visualize | Terminal/near-terminal skills don't name next step explicitly | Low — /learn orchestrator handles routing |

### Per-Skill Highlights

**Strongest: learn-spec (44/45)** — Explicit model, context:fork, comprehensive pre-checks, DSBV prohibition in prose, full downstream handoff via DSBV-READY package.

**Weakest: learn-visualize (36/45)** — Missing model declaration, Grep unnecessary, no downstream handoff. Terminal skill in pipeline so Sc3 is partially expected.

---

## Dimension Averages (cross-skill)

| Dimension | Avg Score | Assessment |
|-----------|-----------|------------|
| S1: Output path safety | 4.1 | Strong — paths hardcoded + pre-checks |
| S2: DSBV contamination | 4.7 | Very strong — explicit guards in most skills |
| S3: Human gates | 4.3 | Strong — HARD-GATE blocks in all applicable skills |
| E1: Model appropriateness | 4.0 | Adequate — 3 skills missing declarations |
| E2: Tool minimality | 3.7 | Adequate — minor over-provisioning |
| E3: Agent dispatch efficiency | 5.0 | Perfect — no unnecessary agent overhead |
| Sc1: Prerequisite diagnosis | 4.9 | Near-perfect — all skills name upstream skill on error |
| Sc2: Filesystem-derived state | 4.3 | Strong — no conversation-state reliance |
| Sc3: Cross-skill handoffs | 4.0 | Adequate — 2 terminal skills lack downstream naming |

**Strongest dimension: E3 (5.0)** — Zero agent overhead across all skills.
**Weakest dimension: E2 (3.7)** — Minor tool over-provisioning.

---

## Conclusions

### Item 2 Decision: CLOSED — Not Needed

Evidence:
1. **L1 (98%):** All skills reference correct paths, use correct agents, have HARD-GATEs, no DSBV contamination
2. **L2 (100%):** Pipeline routing logic handles all 8 state combinations correctly
3. **L3 (0 FAILs):** No dimension scored ≤ 2. Skills are semantically sound across S × E × Sc

The ltc-builder already has a LEARN routing guard at line 67: "NEVER write DSBV files to 2-LEARN/." Skills own LEARN orchestration completely. Agents don't need LEARN-specific awareness.

### Optional Improvements (non-blocking)

These are quality-of-life fixes, not architectural gaps:

| Fix | Effort | Impact |
|-----|--------|--------|
| Add `model: sonnet` to learn, learn-review, learn-visualize frontmatter | 5 min | Prevents model overspend |
| Remove Bash from learn-research allowed-tools | 2 min | Tighter tool boundary |
| Remove Grep from learn-visualize allowed-tools | 2 min | Tighter tool boundary |
| Add explicit DSBV prohibition to learn-research | 5 min | Defense-in-depth |
| Add frontmatter instructions to learn-input | 5 min | Closes L1 WARN |

---

## Related

- **T-E6 (Agent Rules Loading):** Confirmed named agents (ltc-builder etc.) receive full .claude/rules/ — LP-8 RESOLVED
- **Agent Benchmark:** 55/55 (100%) — `scripts/agent-benchmark.sh`
- **I2 Gap List:** Items 2, 4, 5 dropped. Item 1 (sub-system layer) remains. Item 3 (cross-project) pending Item 1. Item 6 (/dsbv split) separate.

## Links

- [[2026-04-08_DESIGN-learn-benchmark]]
- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SKILL]]
- [[learn-benchmark-l3-rubric]]
- [[ltc-builder]]
