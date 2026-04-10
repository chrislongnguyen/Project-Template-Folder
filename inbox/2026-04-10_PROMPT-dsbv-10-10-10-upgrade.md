/resume

Context: We are building the DSBV 10/10/10 upgrade for OPS_OE.6.4.LTC-PROJECT-TEMPLATE.

Prerequisites (must be done before this prompt):
- DSBV SOTA upgrade shipped (commit a8f2792, L1=100%, L2=4.72)
- Template alignment shipped (feat/dsbv-template-alignment merged)
- Baseline: S=8.5/10, E=7/10, Sc=6.5/10

State:
- S x E x Sc assessment done in session 2026-04-10-dsbv-sota-build-merge
- 15 fixes identified, all sized as one-DSBV-cycle work
- Benchmark scripts in scripts/dsbv-benchmark-*.py (L1 deterministic + L2 Gemini judge)
- GEMINI_API_KEY must be set before running L2

The 15 fixes to implement:

SUSTAINABILITY (S → 10, currently 8.5):
S-FIX-1: Builder self-check audit hook — SubagentStop greps builder output for all 14 checklist markers, blocks if any missing
S-FIX-2: fail_history as array — change gate-state.sh fail_count to JSON array, track actual FAIL text per iteration
S-FIX-3: Approval record tamper detection — hash approval record row, store hash in state file, verify on read
S-FIX-4: Crash recovery smoke test — script that kills builder mid-dispatch, verifies state file + metrics log consistency

EFFICIENCY (E → 10, currently 7):
E-FIX-1: Split builder/reviewer AC scope — builder validates structural (exists, syntax, frontmatter), reviewer validates semantic (content matches intent). Add explicit boundary to both agent files.
E-FIX-2: Inline gate-ceremony.sh — combine gate-precheck + set-status-in-review + verify-approval-record + gate-advance into single script
E-FIX-3: C1-C6 fast-fail ordering — check C1 first, abort immediately if RED
E-FIX-4: Warm context for retries — SKILL.md Generator/Critic loop sends only FAIL items + diff on iteration > 1, not full SEQUENCE.md
E-FIX-5: Explorer parallel sub-queries — protocol in explorer agent file for 3 concurrent Haiku sub-queries (Exa, QMD, Grep)

SCALABILITY (Sc → 10, currently 6.5):
Sc-FIX-1: Reviewer fan-out — if ACs > 15, split into 2 parallel reviewer dispatches by dimension, merge results
Sc-FIX-2: Subsystem chain-of-custody enforcement — activate subsystem field in gate-state.json, gate-precheck.sh validates version ordering (PD >= DP >= DA >= IDM)
Sc-FIX-3: Metrics rotation + dashboard — dsbv-metrics.jsonl rotation per iteration, scripts/metrics-report.sh for trend summary
Sc-FIX-4: Multi-workstream parallel protocol — SKILL.md section for running DSBV on 2 workstreams simultaneously
Sc-FIX-5: Cross-project metrics federation — shared JSONL schema + aggregation script across repos
Sc-FIX-6: Dynamic cost caps — add cost_cap field to state file, SKILL.md reads it (ALIGN/PLAN=5x, EXECUTE/IMPROVE=2x)

Steps to execute in order:

1. DESIGN PHASE
   Dispatch ltc-planner to produce DESIGN.md for the 10/10/10 upgrade.
   Input: this prompt + the S x E x Sc assessment from session 2026-04-10
   Output: inbox/2026-04-10_DESIGN-dsbv-10-10-10-upgrade.md
   Wait for human G1 approval.

2. SEQUENCE PHASE
   Dispatch ltc-planner to produce SEQUENCE.md.
   Use the new sequence-template.md (from template alignment).
   Output: inbox/2026-04-10_SEQUENCE-dsbv-10-10-10-upgrade.md
   Wait for human G2 approval.

3. WORKTREE
   git worktree add -b feat/dsbv-10-10-10 ../dsbv-10-10-10
   Run L1 baseline on worktree before any changes.

4. BUILD PHASE
   Dispatch ltc-builder per SEQUENCE.md task order.
   Build all 15 fixes into the worktree.
   Run BA-checks after each build wave per SEQUENCE.

5. DELTA BENCHMARK
   export GEMINI_API_KEY=...

   # L1+L2 on upgraded worktree
   ./scripts/dsbv-benchmark.sh --target-dir /path/to/worktree --l2 --yes \
     > inbox/2026-04-10_RESULT-dsbv-10-10-10-upgraded.md

   # Delta comparison
   ./scripts/dsbv-benchmark.sh --delta \
     --before . --after /path/to/worktree --l2 \
     > inbox/2026-04-10_RESULT-dsbv-10-10-10-delta.md

6. VALIDATE + MERGE
   Dispatch ltc-reviewer against DESIGN.md ACs.
   If PASS: merge worktree → main, clean up.

7. S x E x Sc RE-ASSESSMENT
   Re-run the full system assessment. Target: S>=9.5, E>=9, Sc>=8.5 (realistic) or 10/10/10 (aspirational).

Confidence estimate from prior session: ~77% to land at 9/9/8, true 10/10/10 requires production battle-testing.
