---
version: "1.0"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-27
owner: Long Nguyen
---

# DSBV ALIGN Retrospective — I1

## What Worked

- **Multi-agent diversity surfaced non-obvious risks.** Five Sonnet teams operating independently found different blind spots — no single agent would have caught all of them. The competing hypotheses pattern (ADR-001) delivered on its promise.
- **Opus synthesis captured the union of insights.** The synthesis agent identified the strongest elements from each team and merged them without losing minority perspectives. Quality was strictly better than any individual team.
- **Evaluation rubric produced objective scoring.** The structured rubric (completeness, coherence, quality, downstream readiness) removed subjectivity from the approval decision. Score of 8.85/10 against an 8.0 threshold made the call clear.
- **Parallel execution was cost-effective.** All 5 teams ran simultaneously — wall clock time was bounded by the slowest team, not 5x sequential. Total cost (~$10-15) was reasonable for the quality uplift.

## What Didn't Work

- **OKR deliverable omission (7-CS: Input).** OKRs were listed in Section 3 (Required Artifacts) of the context package but NOT in Section 6 (Agent Deliverables). Agents correctly produced only what was specified in their deliverables list. The mismatch was an input error by the Human Director — not an agent failure.
- **DESIGN.md not produced by any team (7-CS: Input).** The DSBV process implies DESIGN.md is created during the Design phase, but it was never explicitly assigned as a deliverable. Agents do not infer implicit work — if it is not in the spec, it does not get built. Same root cause as the OKR issue: Input quality ceiling.
- **Worktree output collection was manual (7-CS: EOE).** Each team ran in a separate git worktree. Collecting and comparing outputs required manual directory navigation. The synthesis agent had to be pointed to each worktree explicitly. This friction slowed the synthesis step.
- **Agent skipped /dsbv skill invocation during re-run (7-CS: Agent + EOP).** When asked to "re-run DSBV for ALIGN," the agent operated from degraded memory of SKILL.md instead of invoking the Skill tool to load live instructions. Hard Gate #4 (multi-agent cost prompt) was skipped — user was not offered the single/multi-agent choice. Root cause: LT-2 (context degradation) + LT-8 (agent rationalized past invocation when user said "autonomous"). Rules are probabilistic (~80%). Only hooks enforce deterministically.
- **Hook edge case: operational files blocked (7-CS: EOE).** The initial dsbv-skill-guard.sh hook blocked writes to 4-IMPROVE/retrospectives/ because no 4-IMPROVE/DESIGN.md existed. Fix: allowlist for operational files (retros, changelogs, ADRs, metrics, learning) that are updated incrementally outside DSBV cycles.

## Lessons for Future Zones

1. **Enforce 1:1 artifact-to-deliverable mapping.** Every artifact listed in Section 3 (Required Artifacts) must appear as a named deliverable in Section 6 (Agent Deliverables). Add a readiness check that diffs the two lists before launch — if they diverge, BLOCK the run.
2. **Readiness conditions must verify prompt completeness.** C5 (Prompt Engineered) is currently a qualitative check. Add a mechanical check: parse the context package for Section 3 vs Section 6 alignment. This prevents the most common failure mode observed.
3. **Automate worktree output collection.** Build a script that gathers all team outputs into a single comparison directory before synthesis begins. The synthesis agent should receive a flat folder of `team-N/` outputs, not worktree paths.
4. **DESIGN.md should be the first Build deliverable.** Even if the Human Director wrote the initial Design spec, the Build phase should produce a canonical DESIGN.md that matches what was actually built. This closes the loop between intent and execution.
5. **Enforce DESIGN.md prerequisite via hook, not rule.** Agent compliance with "invoke /dsbv first" is ~80% via rules (LT-8). The dsbv-skill-guard.sh hook enforces the OUTCOME (DESIGN.md exists before zone artifacts are written) rather than the PROCESS (skill was invoked). This is deterministic and immune to agent rationalization. Enforcement hierarchy: hooks > rules > skills (D6).
6. **Operational files need an allowlist in zone hooks.** Not all zone files are DSBV artifacts. Retrospectives, changelogs, ADRs, metrics, and learning outputs are updated incrementally outside DSBV cycles. The hook must exempt these or it blocks legitimate work.

## Metrics

| Metric | Value |
|--------|-------|
| Build teams | 5 Sonnet agents (parallel) |
| Synthesis | 1 Opus agent |
| Estimated cost | ~$10-15 total |
| Wall clock (Build) | ~20 minutes (parallel agents) |
| Wall clock (Synthesis) | ~15 minutes |
| Evaluation score | 8.85/10 (APPROVE threshold: 8.0) |
| Human review | Approved with minor edits (RACI correction) |
| Root cause distribution | 2x Input, 2x EOE, 1x Agent+EOP |
| DSBV re-run (single-agent) | Score 8.4/10, ~15 min, all 6 artifacts + OKRs |
| Hook enforcement test | dsbv-skill-guard.sh caught ad-hoc write to 4-IMPROVE/ within 30 seconds of deployment |
