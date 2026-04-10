---
version: "1.1"
status: draft
last_updated: 2026-04-10
type: template
---

# Template: Page 3 — EP (Effective Principles)

_Page type: Principles — the governing rules of this Topic (Phase C. Organise Information)._

---

## Naming (Learning Book)

Output files use the sub-system slug and topic number:

- **File name pattern:** `T{topic}.P3-principles.md`
- **Output path:** `2-LEARN/{sub-system}/output/{system-slug}/T{topic}.P3-principles.md`
- Sub-system = one of: `1-PD`, `2-DP`, `3-DA`, `4-IDM`
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 3 **consolidates all principles already embedded in Pages 0, 1, and 2** of this same Topic into one place. It does NOT generate new principles — it harvests them. Each principle either enables a UDS element or disables a UBS element from this Topic. State explicitly which.

---

## S/E/Sc Labeling (MANDATORY)

**Every principle must be labeled with its Effectiveness pillar.** This bucketing happens during ELF — not later during ESD. The label tells the agent which pillar this principle serves when translated into Adverb A.C.s.

- **P[n](S)** — Sustainability principle: governs correct, safe, risk-managed operation. Primarily disables UBS elements.
- **P[n](E)** — Efficiency principle: governs fast, lean, frugal operation. Primarily enables UDS elements via speed/resource optimization.
- **P[n](Sc)** — Scalability principle: governs repeatable, comparable, growth-capable operation. Primarily enables UDS elements at recursive depth.

**How to determine the pillar:**

- Ask: "Does this principle prevent failure/harm (S), reduce waste/time (E), or enable growth/repeatability (Sc)?"
- If a principle spans two pillars, assign it to the _higher-priority_ pillar (S > E > Sc) — Sustainability always wins.
- The pillar label goes in the row label: `P1(S)`, `P2(E)`, `P3(Sc)`, etc.

## Role Tag (D29 — MANDATORY)

**Every principle must also specify which role it primarily serves.** Append the role tag after the pillar tag:

- **P[n](S)(R)** — Sustainability principle serving the R (Responsible) actor
- **P[n](E)(A)** — Efficiency principle serving the A (Accountable) actor
- **P[n](Sc)(both)** — Scalability principle serving both R and A

The role tag `(R)`, `(A)`, or `(both)` is always the LAST parenthetical in the row label. This enables direct mapping to ESD: principles tagged `(R)` translate to Agent constraints; principles tagged `(A)` translate to Human Director constraints.

---

## Row Structure (all Topics)

- **N rows — one principle per row**
- Rows are collected from:
  - Page 0: col 6 (EP from success side) + col 12 (Risky Principles from failure side)
  - Page 1: col 6 + col 12 from each row
  - Page 2: col 6 + col 12 from each row
- Row labels: `P1(S)(R)`, `P2(E)(A)`, `P3(Sc)(both)` ... (sequential, with S/E/Sc pillar label + role tag per D29)
- Each principle must explicitly state: **"Enables [UDS element]"** OR **"Disables [UBS element]"**

### Principle count guide

- Topic 0: ~4–8 principles (dual-role P0/P1/P2 provides richer source material)
- Topics 1–5: ~4–8+ principles (deeper layers uncovered = more principles derivable)

### Pillar distribution guide

- At overview depth (Topic 0), expect mostly (S) principles — Sustainability is the foundation.
- Deeper Topics (1–5) will surface more (E) and (Sc) principles as recursive UDS layers are uncovered.
- There is no required ratio — the distribution is driven by the UBS/UDS content, not by quota.

---

## Causal Logic

Principles are NOT generic best practices. They are **the scientific or logical laws** that explain why the UDS works and why the UBS blocks. Derive them by asking:

- "Why does this driver work? What universal principle does it operate on?"
- "Why does this blocker form? What universal principle does it exploit?"

Respect the Hierarchy of Science when identifying which layer the principle operates at:
`Sociology → Psychology → Biology → Chemistry → Physics → Mathematics → Logic → Philosophy`

---

## Cell Address Grammar (CAG — mandatory)

**Every cell** MUST begin with its content-address tag per `engine/rules/phase-c-structure.md` §2.

Example for row `P1(S)(R)`:

- Col 1: `P1(S)(R).REL: Sustainability governs failure prevention...`
- Col 3: `P1(S)(R).ACT: When applied, ensures Agent loads all 10 UTs...`
- Col 4: `P1(S)(R).UD: Deep Internalization of UT Causal Chain — ...`
- Col 10: `P1(S)(R).UB: Principle-Implementation Gap — ...`

See the Column Suffix Codex in `engine/rules/phase-c-structure.md` §2 for all 16 suffixes.

---

## Format

```markdown
# Topic {X}. {Topic Name} — Page 3: Principles

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 3. Principles_
_Subject: {Subject Name} | UDO: [as defined in A — Subject Roadmap]_

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
| 6   | SUCCESS        | What principles is the UDS based on? (Success EP)                                                                                                                                                          |
| 7   | SUCCESS        | What tools do the ultimate drivers require? (Success EOT — Effective Operating Tools)                                                                                                                      |
| 8   | SUCCESS        | What environmental conditions do the ultimate drivers require? (Success EOE — Effective Operating Environment)                                                                                             |
| 9   | FAILURE        | How can the row subject fail to function as designed? _(UBS row: how does the blocker get disabled? UDS row: how does the driver get blocked?)_ (Failure Actions)                                          |
| 10  | FAILURE        | What ultimately causes the row subject to fail to function as designed? _(UBS row → UBS.UB: disables the blocker — works FOR Learner. UDS row → UDS.UB: blocks the driver — works AGAINST Learner.)_ (UBS) |
| 11  | FAILURE        | How does col 10 (UBS) cause the row subject to fail? (Failure Mechanism)                                                                                                                                   |
| 12  | FAILURE        | What principles are the failure causes based on? (Failure EP)                                                                                                                                              |
| 13  | FAILURE        | What tools do the failure causes require? (Failure EOT — Effective Operating Tools)                                                                                                                        |
| 14  | FAILURE        | What environmental conditions do the failure causes require? (Failure EOE — Effective Operating Environment)                                                                                               |
| 15  | LEARNER'S NOTE | If the row subject fails as designed, what should the Learner do? (What Else?)                                                                                                                             |
| 16  | LEARNER'S NOTE | Next Steps to Take (Now What? Now How?)                                                                                                                                                                    |

---

## Table

| Row              | 1 · Relevance     | 2 · Precise Definition | 3 · Success Actions | 4 · UDS          | 5 · Success Mechanism | 6 · Success EP      | 7 · Success EOT | 8 · Success EOE | 9 · Failure Actions | 10 · UBS         | 11 · Failure Mechanism | 12 · Failure EP     | 13 · Failure EOT | 14 · Failure EOE | 15 · What Else?    | 16 · Next Steps    |
| ---------------- | ----------------- | ---------------------- | ------------------- | ---------------- | --------------------- | -------------------- | ----------------------- | ----------------------------- | ------------------- | ---------------- | ---------------------- | -------------------- | ------------------------ | ------------------------------ | ------------------ | ------------------ |
| **P1(S)(R)**     | P1(S)(R).REL:     | P1(S)(R).DEF:          | P1(S)(R).ACT:       | P1(S)(R).UD:     | P1(S)(R).UD.MECH:     | P1(S)(R).UD.EP:     | P1(S)(R).UD.EOT:      | P1(S)(R).UD.EOE:            | P1(S)(R).FAIL:      | P1(S)(R).UB:     | P1(S)(R).UB.MECH:      | P1(S)(R).UB.EP:     | P1(S)(R).UB.EOT:       | P1(S)(R).UB.EOE:             | P1(S)(R).ELSE:     | P1(S)(R).NEXT:     |
| **P2(S)(A)**     | P2(S)(A).REL:     | P2(S)(A).DEF:          | P2(S)(A).ACT:       | P2(S)(A).UD:     | P2(S)(A).UD.MECH:     | P2(S)(A).UD.EP:     | P2(S)(A).UD.EOT:      | P2(S)(A).UD.EOE:            | P2(S)(A).FAIL:      | P2(S)(A).UB:     | P2(S)(A).UB.MECH:      | P2(S)(A).UB.EP:     | P2(S)(A).UB.EOT:       | P2(S)(A).UB.EOE:             | P2(S)(A).ELSE:     | P2(S)(A).NEXT:     |
| **P3(E)(R)**     | P3(E)(R).REL:     | P3(E)(R).DEF:          | P3(E)(R).ACT:       | P3(E)(R).UD:     | P3(E)(R).UD.MECH:     | P3(E)(R).UD.EP:     | P3(E)(R).UD.EOT:      | P3(E)(R).UD.EOE:            | P3(E)(R).FAIL:      | P3(E)(R).UB:     | P3(E)(R).UB.MECH:      | P3(E)(R).UB.EP:     | P3(E)(R).UB.EOT:       | P3(E)(R).UB.EOE:             | P3(E)(R).ELSE:     | P3(E)(R).NEXT:     |
| **P4(Sc)(both)** | P4(Sc)(both).REL: | P4(Sc)(both).DEF:      | P4(Sc)(both).ACT:   | P4(Sc)(both).UD: | P4(Sc)(both).UD.MECH: | P4(Sc)(both).UD.EP: | P4(Sc)(both).UD.EOT:  | P4(Sc)(both).UD.EOE:        | P4(Sc)(both).FAIL:  | P4(Sc)(both).UB: | P4(Sc)(both).UB.MECH:  | P4(Sc)(both).UB.EP: | P4(Sc)(both).UB.EOT:   | P4(Sc)(both).UB.EOE:         | P4(Sc)(both).ELSE: | P4(Sc)(both).NEXT: |
```

---

## Rules

- Do NOT invent principles not derivable from Pages 0–2 of this Topic.
- Each principle row must explicitly name which UDS or UBS element it links to in col 1 (Relevance).
- **Every principle must carry a pillar label: (S), (E), or (Sc) AND a role tag: (R), (A), or (both).** Both are required for ESD translation.
- Principles accumulate across Topics — Topic 1 principles build on Topic 0 principles; later Topics add more.
- Do not be greedy — fewer precise principles > many vague ones.
- If a principle from a prior Topic is now better understood, it may be refined in a deeper Topic — but the pillar label must remain consistent (or be explicitly corrected with a note in A's Decisions log, in the Phase C Organise — state section).
- **Every cell begins with its CAG tag.** See `engine/rules/phase-c-structure.md` §2.

## Links

- [[blocker]]
- [[codex]]
- [[roadmap]]
