---
version: "1.0"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-29
owner: Long Nguyen
---
# DSBV ALIGN Evaluation Protocol — Competing Hypotheses + Synthesis

> For Opus synthesizer agent. Follow mechanically. Ref: ADR-001.

---

## 1. Success Rubric (C3)

Score each dimension 0-10. Weighted average = final score.

| Dimension | Weight | 10/10 | 5/10 | 0/10 |
|-----------|--------|-------|------|------|
| **EO Clarity** | 15% | One sentence, testable, specific outcome with measurable condition | Vague but directional — you know the area, not the target | Missing or contradictory |
| **EU Coverage** | 10% | All personas identified with needs, UBS, UDS, and RACI role | Main personas listed, partial needs analysis | Missing or just names with no analysis |
| **UBS Depth** | 20% | Non-obvious risks found, grounded in LT-1..8 or domain knowledge, each with mitigation strategy | Common/obvious risks only, generic mitigations | Missing or superficial ("things might go wrong") |
| **UDS Coverage** | 10% | Driving forces identified with concrete leverage strategies tied to architecture | Forces listed but no strategy for leveraging them | Missing |
| **Requirements Quality** | 15% | VANA grammar (Verb+Adverbs+Noun+Adjectives), binary acceptance criteria, traces to OKR and risk | Some VANA structure, partial ACs, weak traceability | Prose requirements with no decomposition |
| **Coherence** | 15% | All artifacts cross-reference each other, no contradictions, charter risks match UBS register | Minor inconsistencies between artifacts | Contradictions between charter EO and requirements |
| **Actionability** | 15% | PLAN zone can start architecture and roadmap without asking ALIGN questions | Some gaps remain but workarounds are obvious | PLAN would need to redo ALIGN to proceed |

---

## 2. Evaluation Protocol — Step by Step

Execute these steps in order. Do not skip steps.

**Step 1 — Read all N team outputs.**
Load each team's complete ALIGN package (charter, stakeholders, requirements, force analysis). Note first impressions but do not score yet.

**Step 2 — Score each team on each rubric dimension (0-10).**
Use the rubric table above. Write one sentence justifying each score. No half-points.

**Step 3 — Create comparison matrix.**

```
         EO  EU  UBS  UDS  REQ  COH  ACT  Weighted
Team 1:  7   6   8    5    7    6    7    6.8
Team 2:  8   7   6    7    8    8    8    7.4
...
```

**Step 4 — For each dimension, identify the BEST team and WHY.**
One sentence per dimension: "Team N wins EO Clarity because [specific reason]."

**Step 5 — Divergence analysis.** (Use template in Section 3.)
For each artifact element: where do teams AGREE (high confidence) vs DIVERGE (needs attention)?

**Step 6 — Synthesize.**
Take the best element per dimension from the winning team. Combine into one coherent ALIGN package. Resolve any conflicts introduced by combining elements from different teams. The synthesis must be a complete, self-consistent package — not a cut-and-paste collage.

**Step 7 — Self-check.**
Score the synthesis against the same rubric. Every dimension must score >= 7.

**Step 8 — Flag for Human.**
Any dimension where synthesis scores < 7: list it with the reason and what specifically needs Human judgment. These are your "I cannot resolve this mechanically" items.

---

## 3. Divergence Analysis Template

Report using this exact structure:

```
AGREEMENT (majority of teams align):
- [finding] — HIGH confidence, include as-is
- [finding] — HIGH confidence, include as-is

DIVERGENCE (teams split):
- [finding] — Teams 1,3 say X; Teams 2,4 say Y
  Opus recommendation: [which and why]
  Flag for Human: [yes/no]

UNIQUE INSIGHTS (only 1 team found this):
- [finding] from Team N — [valuable / hallucination / edge case]
  If valuable: include in synthesis. If hallucination: discard with reason. If edge case: flag for Human.
```

**Rules for divergence resolution:**
- If 4+ teams agree → include as-is (high confidence)
- If teams split evenly → Opus picks the option grounded in more evidence, flags for Human
- If 1 team found something unique → validate against charter context; include if plausible, flag if uncertain
- When in doubt, flag for Human. Over-flagging is better than silent bad choices.

---

## 4. Human Review Checklist

After Opus synthesis, the Human Director checks:

- [ ] EO makes sense to me as the project owner
- [ ] No critical stakeholder is missing
- [ ] UBS list includes risks I have seen in practice
- [ ] UDS list includes real leverage points, not aspirational ones
- [ ] Requirements are achievable within our constraints (time, budget, team)
- [ ] I could hand this to a new team member and they would understand the project
- [ ] The PLAN zone can start from this without coming back to ask me questions
- [ ] Opus divergence flags have been reviewed and resolved

---

## 5. Scoring Thresholds

| Weighted Average | Decision | Action |
|------------------|----------|--------|
| >= 8.0 | **APPROVE** | Proceed to PLAN zone |
| 6.0 - 7.9 | **REVISE** | Address flagged dimensions, re-run synthesis on weak areas |
| < 6.0 | **REJECT** | Re-run DSBV with improved prompt, more context, or different N |

**On REVISE:** Opus lists exactly which dimensions need work and what "good" looks like for each. Human decides whether to re-prompt Sonnet teams or manually fix.

**On REJECT:** Before re-running, diagnose root cause using 7-CS blame order: EP → Input → EOP → EOE → EOT → Agent. Most REJECT cases trace to bad Input (insufficient context provided to Sonnet teams).

---

**Classification:** INTERNAL
