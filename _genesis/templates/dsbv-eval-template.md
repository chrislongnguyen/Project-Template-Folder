---
version: "1.0"
iteration: "I1: Concept"
status: draft
last_updated: 2026-03-29
owner: Long Nguyen
type: template
work_stream: govern
stage: validate
sub_system: 
---
# DSBV Evaluation Protocol — [WORKSTREAM NAME]

> For Validate phase. Covers multi-agent synthesis and single-agent validation.
> Follow mechanically. Do not skip steps.

---

## 1. Success Rubric

Score each dimension 0-10. Weighted average = final score. No half-points.

### Universal Dimensions (all workstreams)

| Dimension | Weight | 10/10 | 5/10 | 0/10 |
|-----------|--------|-------|------|------|
| **EO Clarity** | [%] | One sentence, testable, measurable condition | Vague but directional | Missing or contradictory |
| **Coherence** | [%] | All artifacts cross-reference, no contradictions | Minor inconsistencies | Contradictions between core artifacts |
| **Actionability** | [%] | Next workstream starts without questions | Gaps remain, workarounds obvious | Next workstream must redo this workstream |

### Workstream-Specific Dimensions (fill 3-4 per workstream)

| Dimension | Weight | 10/10 | 5/10 | 0/10 |
|-----------|--------|-------|------|------|
| **[Dimension 1]** | [%] | [Excellent] | [Mediocre] | [Failure] |
| **[Dimension 2]** | [%] | [Excellent] | [Mediocre] | [Failure] |
| **[Dimension 3]** | [%] | [Excellent] | [Mediocre] | [Failure] |
| **[Dimension 4]** | [%] | [Excellent] | [Mediocre] | [Failure] |

[ALIGN: EU Coverage, UBS Depth, UDS Coverage, Requirements Quality | PLAN: Architecture Completeness, Risk Mitigation, Task Decomposition, Dependency Accuracy | EXECUTE: Code Quality, Test Coverage, Doc Completeness, Performance | IMPROVE: Insight Depth, Action Specificity, Metric Accuracy, Feedback Closure]

**Weights must sum to 100%.** Typical: 30-40% universal + 60-70% workstream-specific.

---

## 2. Multi-Agent Protocol (Design-Heavy Workstreams: ALIGN, PLAN)

> For single-agent workstreams (EXECUTE, IMPROVE), skip to Section 3.

**Step 1 — Read all N team outputs.** Load each team's complete workstream package. Note impressions, do not score yet.

**Step 2 — Score each team on each dimension (0-10).** One sentence justifying each score.

**Step 3 — Comparison matrix.**

```
           Dim1  Dim2  Dim3  ...  Weighted
Team 1:    7     6     8         6.8
Team 2:    8     7     6         7.4
```

**Step 4 — Best team per dimension.** One sentence each: "Team N wins [Dim] because [reason]."

**Step 5 — Divergence analysis.** Use template in Section 4. Where do teams AGREE vs DIVERGE?

**Step 6 — Synthesize.** Best element per dimension from winning team. Resolve conflicts. Must be a self-consistent package, not cut-and-paste.

**Step 7 — Self-check.** Score synthesis on same rubric. Every dimension must score >= 7.

**Step 8 — Flag for Human.** Any dimension < 7: list reason and what needs Human judgment.

---

## 3. Single-Agent Protocol (Execution-Heavy Workstreams: EXECUTE, IMPROVE)

**Step 1 — Score output on each dimension (0-10).** One sentence justifying each score.

**Step 2 — Identify weak dimensions.** Any < 7: state what is wrong and what "good" looks like.

**Step 3 — Human Review Checklist.** Complete Section 5. Every item must be checked.

**Step 4 — Decision.** Apply thresholds from Section 6.

---

## 4. Divergence Analysis Template

> Used in multi-agent Step 5. Report using this exact structure.

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

> Adapt items to workstream. Replace bracketed text with workstream-specific checks.

- [ ] EO still makes sense to me as the project owner
- [ ] No critical [stakeholder/component/artifact] is missing
- [ ] [Quality check 1 — e.g., "UBS includes risks I've seen in practice"]
- [ ] [Quality check 2 — e.g., "Architecture handles known scale requirements"]
- [ ] [Quality check 3 — e.g., "Tests cover acceptance criteria from requirements"]
- [ ] Outputs achievable within constraints (time, budget, team)
- [ ] A new team member could understand this workstream's output
- [ ] Next workstream can start without asking me questions
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

## Links

- [[VALIDATE]]
- [[dsbv]]
- [[iteration]]
- [[project]]
- [[task]]
- [[workstream]]
