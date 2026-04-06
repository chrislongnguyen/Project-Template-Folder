---
version: "1.0"
status: draft
last_updated: 2026-04-06
type: template
---

# Template: Page 2 — UDS / UD Layer

_Page type: Ultimate Drivers — the driving side of this Topic (Phase C. Organise Information)._

---

## Naming (Learning Book)

All learning-book items use the `BOOK-NN` prefix convention (e.g. `BOOK-00`, `BOOK-01`).

- **Prefix:** `BOOK-{NN} — ` (space-em-dash-space separator)
- **This page type** → file name: `BOOK-{NN} — T{topic}.P2 Ultimate Drivers.md` (e.g. `BOOK-00 — T0.P2 Ultimate Drivers.md`)
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 2 explores the **driving layer** of this Topic. It answers: what ultimately causes this system/element to succeed? Then it goes one layer deeper: what blocks that driver (UB), and what drives that driver further (UD)?

---

## Row Structure

See `engine/rules/phase-c-structure.md` §1 for the full role-tag cascade.

### Topic 0 (Root)

- **2 rows — one per RACI role**
  - `UDS(R): {Agent's root driver}` — from P0 row `Effective(R)`, col 4
  - `UDS(A): {Human Director's root driver}` — from P0 row `Effective(A)`, col 4
- Do not go deeper than the root UDS here — deeper layers belong in Topic 2.

### Topics 1–5 (Deep-Dive)

- **3 rows per P0 source element = up to 6 rows** (if P0 has 2 rows R + A)
- Per source row, the 3-row causal chain is:
  - Row label: `{parent}.UD: {Description}` — derived from **this Topic's Page 0, col 4 · UDS**
  - Row label: `{parent}.UD.UB: {Description}` — derived from **Row above, col 10 · UBS**
  - Row label: `{parent}.UD.UD: {Description}` — derived from **Row above, col 4 · UDS**
- If R and A share the same element, use `(both)` tag → 3 rows instead of 6. Agent must justify.

### Notation guide for this page

```
Topic 0 (T0, 2 rows):
  UDS(R) (row1), UDS(A) (row2)

Topics 1–5 (up to 6 rows — 3 per role chain):
  R chain: UDS(R).UD (row1), UDS(R).UD.UB (row2), UDS(R).UD.UD (row3)
  A chain: UDS(A).UD (row4), UDS(A).UD.UB (row5), UDS(A).UD.UD (row6)

General pattern per Topic:
  Topic 1 → UBS(role).UD, UBS(role).UD.UB, UBS(role).UD.UD
  Topic 2 → UDS(role).UD, UDS(role).UD.UB, UDS(role).UD.UD
  Topic 3 → P[n](pillar)(role).UD, ...
  Topic 4 → LAYER.n(role).UD, ...
  Topic 5 → STEP.n(role).UD, ...
```

---

## Causal Logic

- **Row 1 (.UD)**: The single most critical driver of the parent element. Works IN User's favour.
- **Row 2 (.UD.UB)**: What blocks Row 1 — its driving effect is diminished. Works AGAINST User.
- **Row 3 (.UD.UD)**: What drives Row 1 further — it becomes even stronger. Works further IN User's favour.

Each row builds causally on the previous. **One driver or blocker per row. Never list multiples.**

### Role Decomposition (structural — not analytical)

Role decomposition is **structural**: P0 provides separate `(R)` and `(A)` seeds, so P2 has separate `UDS(R)` and `UDS(A)` rows. The agent does NOT need to invent role splits — they cascade from P0.

- **UDS(R)**: The Agent's root driver (e.g., structured algorithms, MECE decomposition, fast iteration)
- **UDS(A)**: The Human Director's root driver (e.g., domain expertise, strategic judgment, priority clarity)

All UDS elements discovered here become **candidates for the EOP Decision Matrix (P5)** — Topic 5 decides which to OPTIMIZE.

---

## Principles embedded in this page

Each row's col 6 (EPS) and col 12 (Risky Principles) generate principles. These are harvested into Page 3. Do not skip those cells.

---

## Cell Address Grammar (CAG — mandatory)

**Every cell** MUST begin with its content-address tag per `engine/rules/phase-c-structure.md` §2.

On UDS rows: "Success" = driver succeeds (GOOD for tagged role), "Failure" = driver gets blocked (BAD for tagged role).

| Col | Cell starts with | Direction on UDS rows                       |
| --- | ---------------- | ------------------------------------------- |
| 4   | `UDS(R).UD:`     | FOR tagged role (drives the driver further) |
| 6   | `UDS(R).UD.EPS:` | FOR tagged role — use `P` notation          |
| 10  | `UDS(R).UB:`     | AGAINST tagged role (blocks the driver)     |
| 12  | `UDS(R).UB.EPS:` | AGAINST tagged role — use `P_F` notation    |

Example for row `UDS(R)`:

- Col 1: `UDS(R).REL: UEDS Methodology is the pre-validated causal framework...`
- Col 4: `UDS(R).UD: 10 Ultimate Truths Activation — ...`
- Col 6: `UDS(R).UD.EPS: P1(S)(R): Structural Completeness — ...`
- Col 10: `UDS(R).UB: Context Fragmentation — ...`
- Col 12: `UDS(R).UB.EPS: P_F1(S)(R): Context-Dependency Trap — ...`

See the Column Suffix Codex in `engine/rules/phase-c-structure.md` §2 for all 16 suffixes.

---

## Format

```markdown
# Topic {X}. {Topic Name} — Page 2: Ultimate Drivers

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 2. Ultimate Drivers_
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
| 6   | SUCCESS        | What principles is the UDS based on? (Success EPS)                                                                                                                                                         |
| 7   | SUCCESS        | What tools do the ultimate drivers require? (Success Tools — UES)                                                                                                                                          |
| 8   | SUCCESS        | What environmental conditions do the ultimate drivers require? (Success Environment — UES)                                                                                                                 |
| 9   | FAILURE        | How can the row subject fail to function as designed? _(UBS row: how does the blocker get disabled? UDS row: how does the driver get blocked?)_ (Failure Actions)                                          |
| 10  | FAILURE        | What ultimately causes the row subject to fail to function as designed? _(UBS row → UBS.UB: disables the blocker — works FOR Learner. UDS row → UDS.UB: blocks the driver — works AGAINST Learner.)_ (UBS) |
| 11  | FAILURE        | How does col 10 (UBS) cause the row subject to fail? (Failure Mechanism)                                                                                                                                   |
| 12  | FAILURE        | What principles are the failure causes based on? (Failure EPS)                                                                                                                                             |
| 13  | FAILURE        | What tools do the failure causes require? (Failure Tools — UES)                                                                                                                                            |
| 14  | FAILURE        | What environmental conditions do the failure causes require? (Failure Environment — UES)                                                                                                                   |
| 15  | LEARNER'S NOTE | If the row subject fails as designed, what should the Learner do? (What Else?)                                                                                                                             |
| 16  | LEARNER'S NOTE | Next Steps to Take (Now What? Now How?)                                                                                                                                                                    |

---

## Table (T0 — 2 rows)

| Row                             | 1 · Relevance | 2 · Precise Definition | 3 · Success Actions | 4 · UDS    | 5 · Success Mechanism | 6 · Success EPS | 7 · Success Tools (UES) | 8 · Success Environment (UES) | 9 · Failure Actions | 10 · UBS   | 11 · Failure Mechanism | 12 · Failure EPS | 13 · Failure Tools (UES) | 14 · Failure Environment (UES) | 15 · What Else? | 16 · Next Steps |
| ------------------------------- | ------------- | ---------------------- | ------------------- | ---------- | --------------------- | --------------- | ----------------------- | ----------------------------- | ------------------- | ---------- | ---------------------- | ---------------- | ------------------------ | ------------------------------ | --------------- | --------------- |
| **UDS(R): {Agent root driver}** | UDS(R).REL:   | UDS(R).DEF:            | UDS(R).ACT:         | UDS(R).UD: | UDS(R).UD.MECH:       | UDS(R).UD.EPS:  | UDS(R).UD.UES.T:        | UDS(R).UD.UES.E:              | UDS(R).FAIL:        | UDS(R).UB: | UDS(R).UB.MECH:        | UDS(R).UB.EPS:   | UDS(R).UB.UES.T:         | UDS(R).UB.UES.E:               | UDS(R).ELSE:    | UDS(R).NEXT:    |
| **UDS(A): {Human root driver}** | UDS(A).REL:   | UDS(A).DEF:            | UDS(A).ACT:         | UDS(A).UD: | UDS(A).UD.MECH:       | UDS(A).UD.EPS:  | UDS(A).UD.UES.T:        | UDS(A).UD.UES.E:              | UDS(A).FAIL:        | UDS(A).UB: | UDS(A).UB.MECH:        | UDS(A).UB.EPS:   | UDS(A).UB.UES.T:         | UDS(A).UB.UES.E:               | UDS(A).ELSE:    | UDS(A).NEXT:    |

For T1+ (up to 6 rows), add 3-row causal chain per role: `{parent}.UD`, `{parent}.UD.UB`, `{parent}.UD.UD`. Each cell uses the same CAG format with the row's full address as prefix.
```

---

## Rules

- **Topic 0: 2 rows** — `UDS(R)` and `UDS(A)`, each from P0's corresponding role row col 4. See `engine/rules/phase-c-structure.md` §1.
- **Topics 1–5: up to 6 rows** — 3-row causal chain per P0 source element (3 per role).
- Rows derive from this Topic's P0, col 4. Deeper rows derive from the row above.
- Principles in col 6 and col 12 of each row feed into Page 3.
- **Every cell begins with its CAG tag.** See `engine/rules/phase-c-structure.md` §2.
