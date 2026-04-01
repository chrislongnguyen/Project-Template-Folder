---
version: "1.1"
status: Draft
last_updated: 2026-03-30
---
# ALPEI Pre-Flight Protocol — Always-On Rule

Before ANY task, verify these 7 conditions. If any is RED, fix it before proceeding.

## 7-Step Pre-Flight

1. **CHECK ZONE:** Which ALPEI zone is this task in? Run `/dsbv status` to see current progress. If ambiguous, ask the user.

2. **CHECK ALIGNMENT:** Read `1-ALIGN/charter/` — understand EO, stakeholders, success criteria. Every task must trace to a stated objective.

3. **CHECK RISKS:** Read `3-PLAN/risks/UBS_REGISTER.md` — what can go wrong with this task? Human adoption risks (UBS) take priority over agent-facing risks (S > E > Sc).

4. **CHECK DRIVERS:** Read `3-PLAN/drivers/UDS_REGISTER.md` — what forces can you leverage?

5. **CHECK TEMPLATES:** Identify which templates apply to this zone × phase.
   Lookup: grep `## Routing: {zone}` in
   `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md`, find the row matching the
   current DSBV phase, read the Template column. Load those templates before proceeding.

6. **CHECK LEARNING:** Scan `2-LEARN/` — prior research, specs, training materials, and reference content. Do not reinvent what already exists.

7. **CHECK VERSION CONSISTENCY:** Verify that the zone you are about to modify has version metadata consistent with its DSBV phase. Cross-zone versions must not regress (e.g., a PLAN artifact should not reference an outdated ALIGN version).

## Failure Protocol

If any check fails:
1. State which check failed and why
2. Propose the minimum fix to unblock
3. Wait for human approval before proceeding
