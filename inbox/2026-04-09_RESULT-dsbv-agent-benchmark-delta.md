DSBV Agent Benchmark -- L1 Delta Report
========================================

Date:   2026-04-10
Before: .
After:  /Users/longnguyen/LTC/LongHNguyen/dsbv-sota-upgrade

+----------+----------+----------+----------+
| Dimension |   Before |    After |    Delta |
+----------+----------+----------+----------+
| S (26)   |    16/26 |    26/26 |      +10 |
| E (8)    |     4/8  |     8/8  |       +4 |
| Sc (10)  |     8/10 |    10/10 |       +2 |
+----------+----------+----------+----------+
| TOTAL    |    28/44 |    44/44 |      +16 |
| PERCENT  |    63.6% |   100.0% |  +36.4pp |
+----------+----------+----------+----------+

Per-Check Delta:
  ID       | Before | After  | Status
  --------+--------+--------+-------
  E-01     | PASS   | PASS   | UNCHANGED
  E-02     | FAIL   | PASS   | IMPROVED <-
  E-03     | PASS   | PASS   | UNCHANGED
  E-04     | PASS   | PASS   | UNCHANGED
  E-05     | FAIL   | PASS   | IMPROVED <-
  E-06     | FAIL   | PASS   | IMPROVED <-
  E-07     | PASS   | PASS   | UNCHANGED
  E-08     | FAIL   | PASS   | IMPROVED <-
  S-01     | PASS   | PASS   | UNCHANGED
  S-02     | PASS   | PASS   | UNCHANGED
  S-03     | PASS   | PASS   | UNCHANGED
  S-04     | PASS   | PASS   | UNCHANGED
  S-05     | PASS   | PASS   | UNCHANGED
  S-06     | FAIL   | PASS   | IMPROVED <-
  S-07     | FAIL   | PASS   | IMPROVED <-
  S-08     | FAIL   | PASS   | IMPROVED <-
  S-09     | PASS   | PASS   | UNCHANGED
  S-10     | FAIL   | PASS   | IMPROVED <-
  S-11     | PASS   | PASS   | UNCHANGED
  S-12     | PASS   | PASS   | UNCHANGED
  S-13     | PASS   | PASS   | UNCHANGED
  S-14     | FAIL   | PASS   | IMPROVED <-
  S-15     | PASS   | PASS   | UNCHANGED
  S-16     | PASS   | PASS   | UNCHANGED
  S-17     | PASS   | PASS   | UNCHANGED
  S-18     | PASS   | PASS   | UNCHANGED
  S-19     | PASS   | PASS   | UNCHANGED
  S-20     | FAIL   | PASS   | IMPROVED <-
  S-21     | FAIL   | PASS   | IMPROVED <-
  S-22     | FAIL   | PASS   | IMPROVED <-
  S-23     | FAIL   | PASS   | IMPROVED <-
  S-24     | FAIL   | PASS   | IMPROVED <-
  S-25     | PASS   | PASS   | UNCHANGED
  S-26     | PASS   | PASS   | UNCHANGED
  Sc-01    | FAIL   | PASS   | IMPROVED <-
  Sc-02    | PASS   | PASS   | UNCHANGED
  Sc-03    | PASS   | PASS   | UNCHANGED
  Sc-04    | PASS   | PASS   | UNCHANGED
  Sc-05    | PASS   | PASS   | UNCHANGED
  Sc-06    | PASS   | PASS   | UNCHANGED
  Sc-07    | FAIL   | PASS   | IMPROVED <-
  Sc-08    | PASS   | PASS   | UNCHANGED
  Sc-09    | PASS   | PASS   | UNCHANGED
  Sc-10    | PASS   | PASS   | UNCHANGED

REGRESSIONS: 0
IMPROVEMENTS: 16
UNCHANGED: 28

L1 Verdict (after): PASS  (100.0%,  regressions=0)

=========================================
DSBV AGENT BENCHMARK -- COMBINED VERDICT
=========================================

Q1: "Did we build what we said we'd build?"
  L1 enforcement: 63.6% -> 100.0% (+36.4pp)
  Verdict: PASS (PASS if after >= 90%)

Q2: L2 not run (omit --l2 to skip)

Combined: N/A (L2 required for combined verdict)
=========================================
