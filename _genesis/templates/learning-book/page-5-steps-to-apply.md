---
version: "1.1"
status: draft
last_updated: 2026-04-10
type: template
---

# Template: Page 5 — EOP (Effective Operating Procedure)

_Page type: Steps to Apply — the operating procedure for this Topic (Phase C. Organise Information)._

---

## Naming (Learning Book)

Output files use the sub-system slug and topic number:

- **File name pattern:** `T{topic}.P5-steps-to-apply.md`
- **Output path:** `2-LEARN/{sub-system}/output/{system-slug}/T{topic}.P5-steps-to-apply.md`
- Sub-system = one of: `1-PD`, `2-DP`, `3-DA`, `4-IDM`
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 5 defines the **Effective Operating Procedure (EOP)** for this Topic: the actionable steps that apply the Principles (Page 3), leverage the Environment & Tools (Page 4), to:

- **Overcome the UBS** (Page 1) — disable the blockers
- **Enable the UDS** (Page 2) — amplify the drivers

This page turns knowledge into action. It answers: _"Given everything we know about this Topic's system, how do we actually execute it?"_

---

## Row Structure (all Topics)

- **N rows — one step per row**, ordered sequentially (each step must be completed before the next)
- Row labels: `STEP.1(R)`, `STEP.2(A)`, `STEP.3(R)` ... (sequential, role-tagged per D29)
- The role tag `(R)` or `(A)` indicates who is Responsible for executing that step
- Each step must reference at least one element from Pages 1–4:
  - Which Principle (P3) it applies
  - Which Tool/Environment (P4) it uses
  - Which UBS element (P1) it overcomes OR which UDS element (P2) it enables

### Step count guide

- Topic 0: ~4–6 steps (overview-level, high-level phases)
- Topics 1–5: More detailed, more specific steps for that Topic's system

---

## Step Design Principles

1. **Sequential and dependent**: Step N+1 requires Step N to be complete. No steps in parallel unless explicitly designed as parallel.
2. **Linked to UBS/UDS/Principles**: Every step must have a clear purpose rooted in the blockers/drivers of this Topic.
3. **Includes a gate/checkpoint**: Each step ends with a verifiable output or decision point before proceeding.
4. **RACI per step (D29)**: Every step must specify who is R (Responsible) for executing it via the role tag in the row label. Steps where A (Accountable) is the primary actor (review gates, approval steps) use `(A)`.
5. **Stages DERISK before OPTIMIZE**: Steps that disable UBS elements come before steps that amplify UDS elements — matches EOP Decision Matrix ordering.

---

## Causal Logic

For each step row, answer the 16 canonical questions AS IF that step is the subject:

- Col 1: Why does this step exist? What blocker does it overcome or what driver does it enable?
- Col 2: What exactly is the step (action + output)?
- Col 3: How is it done successfully?
- Col 4: What drives this step to succeed?
- Col 10: What ultimately blocks this step?
- Col 15: What to do if this step fails?

---

## Cell Address Grammar (CAG — mandatory)

**Every cell** MUST begin with its content-address tag per `engine/rules/phase-c-structure.md` §2.

Example for row `STEP.1(R)`:

- Col 1: `STEP.1(R).REL: Load architectural context before execution...`
- Col 4: `STEP.1(R).UD: Startup Protocol Enforcement — ...`
- Col 10: `STEP.1(R).UB: Context Window Exhaustion — ...`

See the Column Suffix Codex in `engine/rules/phase-c-structure.md` §2 for all 16 suffixes.

---

## Format

```markdown
# Topic {X}. {Topic Name} — Page 5: Steps to Apply

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 5. Steps to Apply_
_Subject: {Subject Name} | UDO: [as defined in A — Subject Roadmap]_

---

## EOP Decision Matrix (D26)

_Before listing steps, declare which UBS elements are targeted for disabling (DERISK) and which UDS elements are targeted for amplifying (OPTIMIZE). This is the DECISION POINT — Topics 1–2 DISCOVERED the landscape; this page DECIDES what to act on. P1 and P2 now have separate (R) and (A) rows — list each targeted element with its role tag._

| Category                    | Targeted Elements                | Source Page          | Role                        |
| --------------------------- | -------------------------------- | -------------------- | --------------------------- |
| DERISK: UBS(R) to disable   | [Specific Agent blocker from P1] | T{X}.P1 `UBS(R)` row | R: [action]; A: [oversight] |
| DERISK: UBS(A) to disable   | [Specific Human blocker from P1] | T{X}.P1 `UBS(A)` row | R: [action]; A: [oversight] |
| OPTIMIZE: UDS(R) to amplify | [Specific Agent driver from P2]  | T{X}.P2 `UDS(R)` row | R: [action]; A: [oversight] |
| OPTIMIZE: UDS(A) to amplify | [Specific Human driver from P2]  | T{X}.P2 `UDS(A)` row | R: [action]; A: [oversight] |

---

## Column Key

**CRITICAL: DO NOT rename column headers or Column Key question text. They are IDENTICAL across all Phase C pages. Page-type interpretation belongs ONLY in the Perspective Rule block. Every cell MUST begin with its CAG content-address tag.**

| #   | Group          | Question                                                                                                                                                                                                   |
| --- | -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | INTRODUCTION   | What is the row subject for? Why does it matter to the Learner? (Relevance)                                                                                                                                |
| 2   | INTRODUCTION   | What is it precisely — and what is it NOT? (Precise Definition)                                                                                                                                            |
| 3   | SUCCESS        | How does the row subject operate when functioning as designed? _(UBS row: how does it block? UDS row: how does it drive?)_ (Success Actions)                                                               |
| 4   | SUCCESS        | What ultimately causes the row subject to function as designed? _(UBS row → UBS.UD: drives the blocker — works AGAINST Learner. UDS row → UDS.UD: drives the driver — works FOR Learner.)_ (UDS)           |
| 5   | SUCCESS        | How does col 4 (UDS) cause the row subject to function as designed? (Success Mechanism)                                                                                                                    |
| 6   | SUCCESS        | What principles is the UDS based on? (Success EP)                                                                                                                                                         |
| 7   | SUCCESS        | What tools do the ultimate drivers require? (Success EOT — Effective Operating Tools)                                                                                                                      |
| 8   | SUCCESS        | What environmental conditions do the ultimate drivers require? (Success EOE — Effective Operating Environment)                                                                                             |
| 9   | FAILURE        | How can the row subject fail to function as designed? _(UBS row: how does the blocker get disabled? UDS row: how does the driver get blocked?)_ (Failure Actions)                                          |
| 10  | FAILURE        | What ultimately causes the row subject to fail to function as designed? _(UBS row → UBS.UB: disables the blocker — works FOR Learner. UDS row → UDS.UB: blocks the driver — works AGAINST Learner.)_ (UBS) |
| 11  | FAILURE        | How does col 10 (UBS) cause the row subject to fail? (Failure Mechanism)                                                                                                                                   |
| 12  | FAILURE        | What principles are the failure causes based on? (Failure EP)                                                                                                                                             |
| 13  | FAILURE        | What tools do the failure causes require? (Failure EOT — Effective Operating Tools)                                                                                                                        |
| 14  | FAILURE        | What environmental conditions do the failure causes require? (Failure EOE — Effective Operating Environment)                                                                                               |
| 15  | LEARNER'S NOTE | If the row subject fails as designed, what should the Learner do? (What Else?)                                                                                                                             |
| 16  | LEARNER'S NOTE | Next Steps to Take (Now What? Now How?)                                                                                                                                                                    |

---

## Table

| Row           | 1 · Relevance  | 2 · Precise Definition | 3 · Success Actions | 4 · UDS       | 5 · Success Mechanism | 6 · Success EP   | 7 · Success EOT | 8 · Success EOE | 9 · Failure Actions | 10 · UBS      | 11 · Failure Mechanism | 12 · Failure EP  | 13 · Failure EOT | 14 · Failure EOE | 15 · What Else? | 16 · Next Steps |
| ------------- | -------------- | ---------------------- | ------------------- | ------------- | --------------------- | ----------------- | ----------------------- | ----------------------------- | ------------------- | ------------- | ---------------------- | ----------------- | ------------------------ | ------------------------------ | --------------- | --------------- |
| **STEP.1(R)** | STEP.1(R).REL: | STEP.1(R).DEF:         | STEP.1(R).ACT:      | STEP.1(R).UD: | STEP.1(R).UD.MECH:    | STEP.1(R).UD.EP: | STEP.1(R).UD.EOT:     | STEP.1(R).UD.EOE:           | STEP.1(R).FAIL:     | STEP.1(R).UB: | STEP.1(R).UB.MECH:     | STEP.1(R).UB.EP: | STEP.1(R).UB.EOT:      | STEP.1(R).UB.EOE:            | STEP.1(R).ELSE: | STEP.1(R).NEXT: |
| **STEP.2(A)** | STEP.2(A).REL: | STEP.2(A).DEF:         | STEP.2(A).ACT:      | STEP.2(A).UD: | STEP.2(A).UD.MECH:    | STEP.2(A).UD.EP: | STEP.2(A).UD.EOT:     | STEP.2(A).UD.EOE:           | STEP.2(A).FAIL:     | STEP.2(A).UB: | STEP.2(A).UB.MECH:     | STEP.2(A).UB.EP: | STEP.2(A).UB.EOT:      | STEP.2(A).UB.EOE:            | STEP.2(A).ELSE: | STEP.2(A).NEXT: |
| **STEP.3(R)** | STEP.3(R).REL: | STEP.3(R).DEF:         | STEP.3(R).ACT:      | STEP.3(R).UD: | STEP.3(R).UD.MECH:    | STEP.3(R).UD.EP: | STEP.3(R).UD.EOT:     | STEP.3(R).UD.EOE:           | STEP.3(R).FAIL:     | STEP.3(R).UB: | STEP.3(R).UB.MECH:     | STEP.3(R).UB.EP: | STEP.3(R).UB.EOT:      | STEP.3(R).UB.EOE:            | STEP.3(R).ELSE: | STEP.3(R).NEXT: |
```

---

## Rules

- **EOP Decision Matrix must be completed BEFORE the steps table (D26).** Steps implement the decisions, not discover them.
- Steps are sequential — order matters. DERISK steps before OPTIMIZE steps.
- Every step must trace back to at least one UBS, UDS, or Principle from this Topic's Pages 1–3.
- Every step must carry a role tag: `STEP.n(R)` or `STEP.n(A)` per D29.
- Each step should end with a verifiable output or gate.
- EOP for deeper Topics goes more granular than EOP for Topic 0.
- Do not restate principles as steps — steps are ACTIONS, not rules.
- **Every cell begins with its CAG tag.** See `engine/rules/phase-c-structure.md` §2.

## Links

- [[DESIGN]]
- [[blocker]]
- [[codex]]
- [[roadmap]]
