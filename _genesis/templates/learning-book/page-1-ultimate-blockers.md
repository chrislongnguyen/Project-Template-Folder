---
version: "1.1"
status: draft
last_updated: 2026-04-10
type: template
---

# Template: Page 1 — UBS / UB Layer

_Page type: Ultimate Blockers — the blocking side of this Topic (Phase C. Organise Information)._

---

## Naming (Learning Book)

Output files use the sub-system slug and topic number:

- **File name pattern:** `T{topic}.P1-ultimate-blockers.md`
- **Output path:** `2-LEARN/{sub-system}/output/{system-slug}/T{topic}.P1-ultimate-blockers.md`
- Sub-system = one of: `1-PD`, `2-DP`, `3-DA`, `4-IDM`
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 1 explores the **blocking layer** of this Topic. It answers: what ultimately causes this system/element to fail? Then it goes one layer deeper: what disables that blocker (UB), and what drives that blocker harder (UD)?

---

## Row Structure

See `engine/rules/phase-c-structure.md` §1 for the full role-tag cascade.

### Topic 0 (Root)

- **2 rows — one per RACI role**
  - `UBS(R): {Agent's root blocker}` — from P0 row `Effective(R)`, col 10
  - `UBS(A): {Human Director's root blocker}` — from P0 row `Effective(A)`, col 10
- Do not go deeper than the root UBS here — deeper layers belong in Topic 1.

### Topics 1–5 (Deep-Dive)

- **3 rows per P0 source element = up to 6 rows** (if P0 has 2 rows R + A)
- Per source row, the 3-row causal chain is:
  - Row label: `{parent}.UB: {Description}` — derived from **this Topic's Page 0, col 10 · UBS**
  - Row label: `{parent}.UB.UB: {Description}` — derived from **Row above, col 10 · UBS**
  - Row label: `{parent}.UB.UD: {Description}` — derived from **Row above, col 4 · UDS**
- If R and A share the same element, use `(both)` tag → 3 rows instead of 6. Agent must justify.

### Notation guide for this page

```
Topic 0 (T0, 2 rows):
  UBS(R) (row1), UBS(A) (row2)

Topics 1–5 (up to 6 rows — 3 per role chain):
  R chain: UBS(R).UB (row1), UBS(R).UB.UB (row2), UBS(R).UB.UD (row3)
  A chain: UBS(A).UB (row4), UBS(A).UB.UB (row5), UBS(A).UB.UD (row6)

General pattern per Topic:
  Topic 1 → UBS(role).UB, UBS(role).UB.UB, UBS(role).UB.UD
  Topic 2 → UDS(role).UB, UDS(role).UB.UB, UDS(role).UB.UD
  Topic 3 → P[n](pillar)(role).UB, ...
  Topic 4 → LAYER.n(role).UB, ...
  Topic 5 → STEP.n(role).UB, ...
```

---

## Causal Logic

- **Row 1 (.UB)**: The single most critical blocker of the parent element. Works IN User's favour (disables the parent blocker or blocks the parent driver).
- **Row 2 (.UB.UB)**: What disables Row 1. If Row 1 gets blocked, its disabling effect disappears — works AGAINST User.
- **Row 3 (.UB.UD)**: What drives Row 1 harder. Makes Row 1 even more effective — works further IN User's favour.

Each row builds causally on the previous. **One blocker or driver per row. Never list multiples.**

### Role Decomposition (structural — not analytical)

Role decomposition is **structural**: P0 provides separate `(R)` and `(A)` seeds, so P1 has separate `UBS(R)` and `UBS(A)` rows. The agent does NOT need to invent role splits — they cascade from P0.

- **UBS(R)**: The Agent's root blocker (e.g., hallucination, context loss, tool failures)
- **UBS(A)**: The Human Director's root blocker (e.g., cognitive bias, scope attachment, review fatigue)

All UBS elements discovered here become **candidates for the EOP Decision Matrix (P5)** — Topic 5 decides which to DERISK.

---

## Principles embedded in this page

Each row's col 6 (EP) and col 12 (Risky Principles) generate principles. These are harvested into Page 3. Do not skip those cells.

---

## Cell Address Grammar (CAG — mandatory)

**Every cell** MUST begin with its content-address tag per `engine/rules/phase-c-structure.md` §2.

On UBS rows, the perspective inverts: "Success" = blocker succeeds (BAD for tagged role), "Failure" = blocker fails (GOOD for tagged role).

| Col | Cell starts with | Direction on UBS rows                           |
| --- | ---------------- | ----------------------------------------------- |
| 4   | `UBS(R).UD:`     | AGAINST tagged role (drives the blocker harder) |
| 6   | `UBS(R).UD.EP:` | AGAINST tagged role — use `P_F` notation        |
| 10  | `UBS(R).UB:`     | FOR tagged role (disables the blocker)          |
| 12  | `UBS(R).UB.EP:` | FOR tagged role — use `P` notation              |

Example for row `UBS(R)`:

- Col 1: `UBS(R).REL: This is the highest-risk failure mode for the Agent...`
- Col 4: `UBS(R).UD: Cognitive Default Reinforcement — ...`
- Col 6: `UBS(R).UD.EP: P_F1(S)(R): Bio-Efficiency Exploitation — ...`
- Col 10: `UBS(R).UB: Concurrent Architecture Enforcement — ...`
- Col 12: `UBS(R).UB.EP: P1(S)(R): Architecture-Over-Willpower — ...`

See the Column Suffix Codex in `engine/rules/phase-c-structure.md` §2 for all 16 suffixes.

---

## Format

```markdown
# Topic {X}. {Topic Name} — Page 1: Ultimate Blockers

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 1. Ultimate Blockers_
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

## Table (T0 — 2 rows)

| Row                              | 1 · Relevance | 2 · Precise Definition | 3 · Success Actions | 4 · UDS    | 5 · Success Mechanism | 6 · Success EP | 7 · Success EOT | 8 · Success EOE | 9 · Failure Actions | 10 · UBS   | 11 · Failure Mechanism | 12 · Failure EP | 13 · Failure EOT | 14 · Failure EOE | 15 · What Else? | 16 · Next Steps |
| -------------------------------- | ------------- | ---------------------- | ------------------- | ---------- | --------------------- | --------------- | ----------------------- | ----------------------------- | ------------------- | ---------- | ---------------------- | ---------------- | ------------------------ | ------------------------------ | --------------- | --------------- |
| **UBS(R): {Agent root blocker}** | UBS(R).REL:   | UBS(R).DEF:            | UBS(R).ACT:         | UBS(R).UD: | UBS(R).UD.MECH:       | UBS(R).UD.EP:  | UBS(R).UD.EOT:        | UBS(R).UD.EOE:              | UBS(R).FAIL:        | UBS(R).UB: | UBS(R).UB.MECH:        | UBS(R).UB.EP:   | UBS(R).UB.EOT:         | UBS(R).UB.EOE:               | UBS(R).ELSE:    | UBS(R).NEXT:    |
| **UBS(A): {Human root blocker}** | UBS(A).REL:   | UBS(A).DEF:            | UBS(A).ACT:         | UBS(A).UD: | UBS(A).UD.MECH:       | UBS(A).UD.EP:  | UBS(A).UD.EOT:        | UBS(A).UD.EOE:              | UBS(A).FAIL:        | UBS(A).UB: | UBS(A).UB.MECH:        | UBS(A).UB.EP:   | UBS(A).UB.EOT:         | UBS(A).UB.EOE:               | UBS(A).ELSE:    | UBS(A).NEXT:    |

For T1+ (up to 6 rows), add 3-row causal chain per role: `{parent}.UB`, `{parent}.UB.UB`, `{parent}.UB.UD`. Each cell uses the same CAG format with the row's full address as prefix.
```

---

## Rules

- **Topic 0: 2 rows** — `UBS(R)` and `UBS(A)`, each from P0's corresponding role row col 10. See `engine/rules/phase-c-structure.md` §1.
- **Topics 1–5: up to 6 rows** — 3-row causal chain per P0 source element (3 per role).
- Rows derive from this Topic's P0, col 10. Deeper rows derive from the row above.
- Principles in col 6 and col 12 of each row feed into Page 3.
- **Every cell begins with its CAG tag.** See `engine/rules/phase-c-structure.md` §2.

## Links

- [[architecture]]
- [[blocker]]
- [[codex]]
- [[roadmap]]
