/resume

Context: We are doing DSBV template alignment for OPS_OE.6.4.LTC-PROJECT-TEMPLATE.

State:
- DSBV SOTA upgrade SHIPPED (commit a8f2792). L1=100%, L2=4.72.
- SKILL.md is at v2.0 with 6-step gate protocol, circuit breaker, classify-fail.sh, gate-state.sh
- 4 templates in _genesis/templates/ are STALE (dated 2026-04-04, pre-SOTA):
  - dsbv-process.md (v1.4) — shows 4-gate model, no gate-state.sh, no gate-precheck.sh
  - design-template.md (v1.1) — no LP-6 live test AC requirement, no circuit breaker awareness
  - dsbv-eval-template.md (v1.1) — no dsbv-metrics.jsonl reference, no criterion count matching
  - dsbv-context-template.md (v1.1) — no Budget sub-section, no gate state context
- NO SEQUENCE.md template exists — planner invents format each time
- Routing table in alpei-dsbv-process-map.md has partial entries

Steps to execute in order:

1. WORKTREE
   git worktree add -b feat/dsbv-template-alignment ../dsbv-template-alignment

2. READ current state
   Read all 4 templates + SKILL.md v2.0 + alpei-dsbv-process-map.md routing table.
   Think like the world most professional Project Manager working in LTC (with their full philosophy, principles, frameworks) who applies ALPEI into their work daily to:
   Identify every gap between templates and SKILL.md v2.0. 
   Identify any and all improvement opportunities  (S x E x Sc) can be made to any of the templates that make all of them MECE. 
   Be reminded that: these DSBV templates are essential to build all the artefacts required in 1-ALIGN, 3-PLAN, 3-EXECUTE, 4-IMPROVE (except for 2-LEARN which uses learn skills and artefacts). Think very broad and careful and User-enablement mindset.

3. BUILD (no separate DESIGN/SEQUENCE needed — these are template updates, not workstream artifacts)
   For each template, make targeted edits to align with SKILL.md v2.0:

   a) dsbv-process.md:
      - Add gate-state.sh references (init/read/advance)
      - Add gate-precheck.sh before each gate
      - Add set-status-in-review.sh before gate presentation
      - Update to 6-step Gate Approval Protocol (match SKILL.md §Steps)
      - Add circuit breaker section referencing classify-fail.sh
      - Add auto-recall-filter.sh in hook references
      - Bump version

   b) design-template.md:
      - Add LP-6 live test AC requirement section
      - Add "at least 1 AC must include live invocation" guidance
      - Add Budget sub-section to context packaging example
      - Bump version

   c) dsbv-eval-template.md:
      - Add dsbv-metrics.jsonl historical FAIL data lookup
      - Add criterion count matching protocol
      - Add pre-flight blocking on missing DESIGN.md
      - Reference classify-fail.sh categories for FAIL classification
      - Bump version

   d) dsbv-context-template.md:
      - Add Budget sub-section (### Budget with max_tool_calls example)
      - Add gate state context (current phase, gate statuses from state file)
      - Add 5/5 CP field reminders (EP and OUTPUT were commonly missing)
      - Bump version

   e) CREATE new sequence-template.md:
      - Standard SEQUENCE.md format: Summary, Dependency Graph, Waves, BA Checks, Dispatch Order, Reviewer Points, Risk Register
      - Reference the SEQUENCE we produced for the SOTA upgrade as exemplar
      - Include L1 benchmark progression tracker pattern

   f) alpei-dsbv-process-map.md:
      - Fill in routing table entries for all 5 workstreams × 4 DSBV phases
      - Each cell: Template column = which template to use

4. VALIDATE
   - All templates reference gate-state.sh, gate-precheck.sh, classify-fail.sh
   - All templates have Budget sub-section in context packaging
   - SEQUENCE.md template exists
   - Routing table is complete (20 cells filled)
   - Run L1 benchmark — must still be 44/44 (no regressions)

5. COMMIT + MERGE
   git commit in worktree → merge to main → clean up worktree

This is a small cycle — expect 1-2 builder dispatches max, or direct edits.
