---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: benchmark-result
---

# DSBV Agent Benchmark — Full Delta Report (L1 + L2)

Date: 2026-04-10
Before: main (commit 72c1340)
After: feat/dsbv-sota-upgrade (commit f6038cc, merged as a8f2792)

## L1 Delta (Deterministic Enforcement)

| Dimension | Before | After | Delta |
|-----------|--------|-------|-------|
| S (26) | 16/26 | 26/26 | +10 |
| E (8) | 4/8 | 8/8 | +4 |
| Sc (10) | 8/10 | 10/10 | +2 |
| **TOTAL** | **28/44 (63.6%)** | **44/44 (100.0%)** | **+16 / +36.4pp** |

Regressions: 0
Improvements: 16

### Per-Check Improvements

| Check | What it verifies |
|-------|-----------------|
| S-06 | Builder smoke test requirement |
| S-07 | Builder LP-6 reference |
| S-08 | Reviewer dsbv-metrics reference |
| S-10 | Planner LP-6 reference |
| S-14 | Dispatch hook checks all 5 CP fields |
| S-20 | scripts/gate-state.sh exists |
| S-21 | scripts/gate-precheck.sh exists |
| S-22 | scripts/verify-approval-record.sh exists |
| S-23 | scripts/classify-fail.sh exists |
| S-24 | scripts/set-status-in-review.sh exists |
| E-02 | Dispatch hook model routing check |
| E-05 | Intent-based auto-recall filtering |
| E-06 | Token budget thresholds (2000/1000) |
| E-08 | Dispatch hook budget field check |
| Sc-01 | .claude/state/ directory exists |
| Sc-07 | Phase-agent compatibility guard |

## L2 Delta (Gemini 3.1 Pro Judge, 3-run majority vote)

| Agent | Baseline | After | Delta |
|-------|----------|-------|-------|
| ltc-planner | ~4.02 (system) | 4.58 | +0.56 |
| ltc-builder | ~4.02 (system) | 4.89 | +0.87 |
| ltc-reviewer | ~4.02 (system) | 4.75 | +0.73 |
| ltc-explorer | ~4.02 (system) | 4.64 | +0.62 |
| **System mean** | **4.02** | **4.72** | **+0.70** |

Baseline verdict: PASS (4.02/5.0)
After verdict: EXCELLENT (4.72/5.0)

### L2 Notes
- Baseline used Gemini 3.1 Pro (model: gemini-3.1-pro-preview)
- ltc-explorer required retry logic (Gemini response truncation on initial attempts)
- L2 improvement is a side effect of enforcement documentation: adding scripts/hooks required documenting them in agent files and SKILL.md, which the judge scores as higher quality governance

## Combined Verdict

| Layer | Criterion | Before | After | Result |
|-------|-----------|--------|-------|--------|
| L1 | Enforcement >= 90% | 63.6% | 100.0% | **PASS** |
| L2 | Quality >= 3.5 | 4.02 | 4.72 | **PASS** |
| Combined | Both PASS | — | — | **PASS** |

## Links

- [[2026-04-09_DESIGN-planner-dsbv-agent-enforcement-upgrade]]
- [[2026-04-09_SEQUENCE-dsbv-agent-enforcement-upgrade]]
- [[2026-04-09_RESULT-dsbv-agent-benchmark-baseline]]
