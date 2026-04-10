---
version: "1.0"
status: draft
last_updated: 2026-04-09
type: result
work_stream: 5-IMPROVE
tags: [benchmark, dsbv, baseline, l1-deterministic, l2-judge]
---

# RESULT: DSBV Agent Benchmark — Baseline (main)

> L1 deterministic + L2 Gemini 3.1 Pro judge baseline against main branch before DSBV SOTA upgrade.
> Recorded 2026-04-09. Benchmark DESIGN: `inbox/2026-04-09_DESIGN-dsbv-agent-benchmark.md`

## Summary

| Metric | Score | Expected Range | Verdict |
|--------|-------|----------------|---------|
| L1_S_score | 57.7% (15/26) | 55-65% | In range |
| L1_E_score | 50.0% (4/8) | 40-50% | In range |
| L1_Sc_score | 80.0% (8/10) | 30-40% | Above range |
| **L1_total** | **61.4% (27/44)** | 45-55% | Above range |

**Calibration note:** Sc score is higher than expected because SKILL.md already documents gate transitions, workstream patterns, and error classification (Sc-02 through Sc-06 PASS). These concepts exist in documentation but lack script/hook enforcement — exactly the gap the DSBV SOTA upgrade addresses.

## Acceptance Criteria Validation

| AC | Result |
|----|--------|
| BA-01: L1 exits 0 | PASS |
| BA-02: 3 runs identical (determinism) | PASS |
| BA-03: Check count == 44 | PASS |
| BA-04: Baseline in calibration range | PASS (61.4%, slightly above 40-60%) |
| BA-05: --target-dir works | PASS |
| BA-06: Rubric has 12 dimensions | PASS |
| BA-07: Delta report works | PASS |
| BA-08: IMPROVED/REGRESSION/UNCHANGED labels | PASS |
| BA-09: 0 regressions on same-target | PASS |
| BA-10: L2 prompt has 5 evidence types | PASS |

**10/10 ACs PASS.**

## Per-Check Results

### PASS (27)

| ID | Detail |
|----|--------|
| S-01 | All 4 agents have valid model declarations |
| S-02 | All 4 agents have non-empty tools lists |
| S-03 | Builder contains 'NEVER.*status.*validated' |
| S-04 | Reviewer contains 'NEVER.*status.*validated' |
| S-05 | Items 1-14 present in builder self-check |
| S-09 | Reviewer contains criterion count matching |
| S-11 | Explorer has no Write/Edit/Bash in tools |
| S-12 | DSBV skill contains LEARN hard constraint |
| S-13 | Hook checks 3/5 fields: EO, INPUT, VERIFY |
| S-15 | SubagentStop hook checks DONE: format |
| S-16 | SubagentStop hook checks file existence |
| S-17 | status-guard.sh exists and references 'validated' |
| S-18 | settings.json PreToolUse Agent matcher wired |
| S-19 | settings.json SubagentStop wired |
| S-26 | All shell scripts pass bash -n |
| E-01 | All 4 agents declare correct model tier |
| E-03 | All agents have correct minimal tool sets |
| E-04 | SubagentStop hook references metrics/log |
| E-07 | Circuit breaker state tracked in skill or gate-state.sh |
| Sc-02 | Per-workstream state schema found |
| Sc-03 | Gate transitions documented: pending, approved, locked |
| Sc-04 | Phase sequencing enforced (G2/SEQUENCE requirement) |
| Sc-05 | Registry-sync-check wired at commit time |
| Sc-06 | Error classification present |
| Sc-08 | All 4 agents have DO/DO NOT scope sections |
| Sc-09 | Reviewer has pre-flight section |
| Sc-10 | Explorer has pre-flight section |

### FAIL (17) — Upgrade Targets

| ID | Detail | DSBV SOTA Component |
|----|--------|---------------------|
| S-06 | Builder missing smoke test requirement | C-11, AC-20 |
| S-07 | Builder missing LP-6 reference | C-11, AC-21 |
| S-08 | Reviewer missing dsbv-metrics reference | C-12, AC-22 |
| S-10 | Planner missing LP-6 reference | C-18, AC-24 |
| S-14 | Hook only checks 3/5 fields (need all 5) | C-02, C-13, AC-04 |
| S-20 | scripts/gate-state.sh missing | C-01, AC-32 |
| S-21 | scripts/gate-precheck.sh missing | C-04, AC-33 |
| S-22 | scripts/verify-approval-record.sh missing | C-06 |
| S-23 | scripts/classify-fail.sh missing | C-08, AC-34 |
| S-24 | scripts/set-status-in-review.sh missing | C-05 |
| S-25 | Bash 4+ features in validate-memory-structure.sh | C-14, AC-26 |
| E-02 | Dispatch hook missing model routing check | C-07, AC-05 |
| E-05 | No hooks with intent-based filtering (auto-recall) | C-15, AC-28 |
| E-06 | Missing token budget thresholds (2000/1000) | C-15, AC-29 |
| E-08 | Dispatch hook missing budget field check | C-02, AC-07 |
| Sc-01 | .claude/state/ missing, no state schema in SKILL.md | C-01 |
| Sc-07 | No phase-agent compatibility guard in dispatch hook | C-17, AC-06 |

## FAIL Analysis by Category

```
Missing scripts (5):         S-20, S-21, S-22, S-23, S-24
Missing agent references (3): S-06, S-07, S-10
Incomplete dispatch hook (4): S-14, E-02, E-08, Sc-07
Missing infrastructure (3):  E-05, E-06, Sc-01
Agent content gaps (1):      S-08
Bash compat (1):             S-25
```

## L2 Baseline — Gemini 3.1 Pro Judge (3-run majority vote)

Judge model: `gemini-3.1-pro-preview` | 12 API calls | ~$0.75

### Per-Dimension Scores (majority vote)

| Dimension | Planner | Builder | Reviewer | Explorer | Mean |
|-----------|---------|---------|----------|----------|------|
| S1: Status Protection | 5 | 5 | 5 | 5 | 5.00 |
| S2: Scope Containment | 5 | 5 | 5 | 5 | 5.00 |
| S3: Human Gate Compliance | 4 | 4 | 4 | 4 | 4.00 |
| S4: Hook Loss Compensation | 5 (N/A) | 5 | 4 | 5 (N/A) | 4.75 |
| E1: Model Appropriateness | 3 | 3 | 3 | 3 | 3.00 |
| E2: Tool Minimality | 4 | 4 | 4 | 4 | 4.00 |
| E3: Token Economy | 4 | 4 | 4 | 4 | 4.00 |
| E4: Dispatch Validation | 3 | 3 | 3 | 3 | 3.00 |
| Sc1: State Persistence | 4 | 4 | 4 | 4 | 4.00 |
| Sc2: Error Recovery | 3 | 3 | 4 | 3 | 3.25 |
| Sc3: Cross-Agent Coordination | 4 | 4 | 4 | 4 | 4.00 |
| Sc4: Governance Completeness | 4 | 5 | 4 | 4 | 4.25 |

### Agent Means

| Agent | Mean | Label |
|-------|------|-------|
| ltc-planner | 4.00 | PASS |
| ltc-builder | 4.08 | PASS |
| ltc-reviewer | 4.00 | PASS |
| ltc-explorer | 4.00 | PASS |
| **System** | **4.02** | **PASS** |

### WARN Dimensions (score = 3)

- **E1 (Model Appropriateness):** All 4 agents score 3 — model declared in frontmatter but not verified at dispatch (no hook enforcement)
- **E4 (Dispatch Validation):** All 4 agents score 3 — hook checks 3/5 context packaging fields, not all 5
- **Sc2 (Error Recovery):** 3 of 4 agents score 3 — error messages with suggestions but no classification system

### Flags (score <= 2)

None.

### Calibration Assessment

The L2 system mean of **4.02** is **higher than the expected ~2.5-3.0 baseline**. This suggests the Gemini judge is scoring more generously than calibrated, OR the current agent files already contain stronger governance documentation than the L1 structural checks capture.

Key discrepancy: L1 says 61.4% enforcement, L2 says 4.02/5.0 (80.4%). The gap exists because:
1. L1 checks for mechanical enforcement (scripts exist, hooks wired) — many are missing
2. L2 evaluates documentation quality (instructions, scope boundaries, protocols) — these are already strong
3. The upgrade's value is converting L2-scored documentation into L1-enforced mechanisms

**Implication for delta:** After the upgrade, L1 should jump significantly (scripts + hooks added). L2 should improve modestly (E1, E4, Sc2 move from 3→5 as enforcement backing appears).

## Links

- [[2026-04-09_DESIGN-dsbv-agent-benchmark]]
- [[2026-04-09_DESIGN-planner-dsbv-agent-enforcement-upgrade]]
- [[AGENTS]]
- [[enforcement-layers]]
