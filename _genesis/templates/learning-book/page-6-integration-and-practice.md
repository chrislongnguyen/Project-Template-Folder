---
version: "1.0"
status: draft
last_updated: 2026-04-11
type: template
---

# Template: Page 6 — Integration & Practice

_Page type: Integration & Practice (Phase C. Organise Information). Use for any Topic's Page 6._

---

## Naming (Learning Book)

Output files use the sub-system slug and topic number:

- **File name pattern:** `T{topic}.P6-integration-and-practice.md`
- **Output path:** `2-LEARN/{sub-system}/output/{system-slug}/T{topic}.P6-integration-and-practice.md`
- Sub-system = one of: `1-PD`, `2-DP`, `3-DA`, `4-IDM`
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 6 is the **integration bridge** between execution (Page 5: Steps to Apply) and synthesis (Page 7: Distilled Understanding). It answers: _"How does this Topic's knowledge connect to what I already know, and can I actually apply it in realistic conditions?"_

This page serves two functions:
1. **Integration** — explicitly linking new knowledge to prior knowledge (prevents isolated memorization)
2. **Practice** — applying the EOP (Page 5) in realistic scenarios before the learner attempts a real task

Page 6 is the last active learning step before the learner distills the Topic into the compact P7 format.

---

## Sequence Position

```
P5 (Steps to Apply) ──► P6 (Integration & Practice) ──► P7 (Distilled Understanding)
                              ↑
           Connects EOP back to existing mental models before distillation
```

---

## Format

```markdown
# Topic {X}. {Topic Name} — Page 6: Integration & Practice

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 6. Integration & Practice_
_Subject: {Subject Name} | UDO: [as defined in A — Subject Roadmap]_

---

## Integration Questions

_How does this Topic's knowledge connect to what you already know?_
_Answer these before attempting the Practice Scenarios. Unanswered questions signal a gap in Pages 1–5._

| # | Integration Question | Your Answer | Source (Page / prior knowledge) |
|---|---------------------|-------------|----------------------------------|
| 1 | How does [this Topic] reinforce or contradict [prior concept]? | | |
| 2 | Which Principle (P3) in this Topic maps to a principle I already apply elsewhere? | | |
| 3 | Which UBS (P1) in this Topic have I encountered in a different context? How was it handled? | | |
| 4 | How does the EOP (P5) for this Topic relate to an EOP I already know? | | |

---

## Practice Scenarios

_Apply the EOP (Page 5) in 2–3 realistic contexts. For each scenario: state the context, walk through the steps, note what worked and what broke._

### Scenario 1 — [Context Name]

**Context:** _[Describe a realistic situation where this Topic applies]_

**Steps applied:** _[Walk through P5 steps in this context — which steps were triggered, in what order]_

**Outcome:** _[What happened — did the EOP produce the expected result?]_

**Friction points:** _[Which steps were harder than expected? Which UBS (P1) appeared?]_

---

### Scenario 2 — [Context Name]

**Context:** _[Describe a second realistic situation, ideally from a different domain or role]_

**Steps applied:** _[Walk through P5 steps]_

**Outcome:** _[Result]_

**Friction points:** _[UBS encountered, gaps discovered]_

---

### Scenario 3 (optional) — [Context Name]

**Context:** _[A harder or edge-case scenario that tests the limits of the EOP]_

**Steps applied:** _[Walk through P5 steps]_

**Outcome:** _[Result]_

**Friction points:** _[What the EOP does NOT cover — candidate for P7 "What Else?" column]_

---

## Common Mistakes

_What goes wrong when applying this Topic in practice? Drawn from friction points above and from P1 UBS._

| Mistake | Root Cause (UBS from P1) | Correct Pattern (EP from P3) |
|---------|--------------------------|------------------------------|
| _[What the learner does wrong]_ | _[Which blocker causes it]_ | _[Which principle corrects it]_ |
| | | |
| | | |

---

## Checkpoints

_Self-assessment before advancing to P7 Distilled Understanding. All checkpoints must pass._

- [ ] I can explain how this Topic connects to at least one thing I already knew
- [ ] I completed at least 2 Practice Scenarios without skipping steps
- [ ] I identified at least 1 UBS from P1 that appeared in practice
- [ ] I know which P3 Principle corrects the most common mistake in this Topic
- [ ] I am ready to distill this Topic into the P7 compact format without re-reading P0–P6
```

---

## Rules

- **Integration Questions come first** — they surface gaps before practice exposes them as failures.
- **Scenarios must be realistic** — not hypothetical or abstract. A scenario with no named context is not a scenario.
- **Common Mistakes must trace to a P1 UBS** — if you cannot name the root-cause blocker, the mistake is not understood.
- **All Checkpoints must pass** — if any checkpoint fails, the learner must revisit the relevant page before P7.
- **Scenario 3 is optional** — include only when the EOP has a meaningful edge case. Do not manufacture difficulty.

## Links

- [[DESIGN]]
- [[blocker]]
- [[codex]]
- [[roadmap]]
