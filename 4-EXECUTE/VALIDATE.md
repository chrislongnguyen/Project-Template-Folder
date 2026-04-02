---
version: "1.0"
status: Draft
last_updated: 2026-04-02
workstream: EXECUTE
iteration: "{{ITERATION}}"
owner: "{{OWNER}}"
---

# DSBV Evaluation Protocol — EXECUTE Workstream

> Source template: `_genesis/templates/DSBV_EVAL_TEMPLATE.md`

> For Validate phase. Covers multi-agent synthesis and single-agent validation.
> Follow mechanically. Do not skip steps.

---

## 1. Success Rubric

Score each dimension 0-10. Weighted average = final score. No half-points.

### Universal Dimensions (all workstreams)

| Dimension | Weight | 10/10 | 5/10 | 0/10 |
|-----------|--------|-------|------|------|
| **EO Clarity** | <!-- TODO: % --> | One sentence, testable, measurable condition | Vague but directional | Missing or contradictory |
| **Coherence** | <!-- TODO: % --> | All artifacts cross-reference, no contradictions | Minor inconsistencies | Contradictions between core artifacts |
| **Actionability** | <!-- TODO: % --> | Next workstream starts without questions | Gaps remain, workarounds obvious | Next workstream must redo this workstream |

### Workstream-Specific Dimensions (EXECUTE)

<!-- EXECUTE examples: Code Quality, Test Coverage, Doc Completeness, Performance -->

| Dimension | Weight | 10/10 | 5/10 | 0/10 |
|-----------|--------|-------|------|------|
| **Code Quality** | <!-- TODO: % --> | <!-- TODO: Excellent --> | <!-- TODO: Mediocre --> | <!-- TODO: Failure --> |
| **Test Coverage** | <!-- TODO: % --> | <!-- TODO: Excellent --> | <!-- TODO: Mediocre --> | <!-- TODO: Failure --> |
| **Doc Completeness** | <!-- TODO: % --> | <!-- TODO: Excellent --> | <!-- TODO: Mediocre --> | <!-- TODO: Failure --> |
| **<!-- TODO: Dimension 4 -->** | <!-- TODO: % --> | <!-- TODO: Excellent --> | <!-- TODO: Mediocre --> | <!-- TODO: Failure --> |

**Weights must sum to 100%.** Typical: 30-40% universal + 60-70% workstream-specific.

---

## 2. Multi-Agent Protocol (Design-Heavy Workstreams: ALIGN, PLAN)

> EXECUTE is an execution-heavy workstream. Skip to Section 3.

---

## 3. Single-Agent Protocol (Execution-Heavy Workstreams: EXECUTE, IMPROVE)

**Step 1 — Score output on each dimension (0-10).** One sentence justifying each score.

**Step 2 — Identify weak dimensions.** Any < 7: state what is wrong and what "good" looks like.

**Step 3 — Human Review Checklist.** Complete Section 5. Every item must be checked.

**Step 4 — Decision.** Apply thresholds from Section 6.

---

## 4. Divergence Analysis Template

> Used in multi-agent Step 5. Retained for reference; not applicable for single-agent EXECUTE.

```
AGREEMENT (majority align):
- [finding] — HIGH confidence, include as-is

DIVERGENCE (teams split):
- [finding] — Teams X,Y say A; Teams W,Z say B
  Recommendation: [which and why]
  Flag for Human: [yes/no]

UNIQUE INSIGHTS (1 team only):
- [finding] from Team N — [valuable / hallucination / edge case]
  Valuable: include. Hallucination: discard with reason. Edge case: flag for Human.
```

### Resolution Rules

| Condition | Action |
|-----------|--------|
| Majority agree (>= N/2 + 1) | Include as-is |
| Even split | Pick option with more evidence, flag for Human |
| 1 team unique finding | Validate against context; include if plausible, flag if uncertain |
| Uncertain | Flag for Human. Over-flagging > silent bad choices. |

---

## 5. Human Review Checklist

<!-- Adapt items to EXECUTE workstream specifics -->

- [ ] EO still makes sense to me as the project owner
- [ ] No critical [component/module/artifact] is missing
- [ ] <!-- TODO: Quality check 1 — e.g., "Tests cover acceptance criteria from requirements" -->
- [ ] <!-- TODO: Quality check 2 — e.g., "Code handles known edge cases" -->
- [ ] <!-- TODO: Quality check 3 — e.g., "Docs are sufficient for a new team member to onboard" -->
- [ ] Outputs achievable within constraints (time, budget, team)
- [ ] A new team member could understand this workstream's output
- [ ] Next workstream (IMPROVE) can start without asking me questions
- [ ] All divergence flags reviewed and resolved (if multi-agent)

---

## 6. Scoring Thresholds

| Weighted Average | Decision | Action |
|------------------|----------|--------|
| >= 8.0 | **APPROVE** | Proceed to next workstream |
| 6.0 - 7.9 | **REVISE** | Address flagged dimensions, re-run on weak areas |
| < 6.0 | **REJECT** | Re-run DSBV with improved context or approach |

**On REVISE:** List which dimensions need work and what "good" looks like. Human decides: re-prompt agents or manual fix.

**On REJECT:** Diagnose via 7-CS blame order: EP > Input > EOP > EOE > EOT > Agent. Most REJECTs trace to bad Input.

---

**Classification:** INTERNAL
