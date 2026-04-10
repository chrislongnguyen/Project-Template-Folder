---
version: "1.1"
status: draft
last_updated: 2026-04-10
type: template
---

# Template: Page 0 — Overview & Summary

_Page type: Overview & Summary (Phase C. Organise Information). Use for any Topic's Page 0._

---

## Naming (Learning Book)

Output files use the sub-system slug and topic number:

- **File name pattern:** `T{topic}.P0-overview-and-summary.md`
- **Output path:** `2-LEARN/{sub-system}/output/{system-slug}/T{topic}.P0-overview-and-summary.md`
- Sub-system = one of: `1-PD`, `2-DP`, `3-DA`, `4-IDM`
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 0 is the **entry point** for the Topic. It gives a single high-level view of the entire subject of that Topic before any deep-dive begins.

---

## Row Structure

### Topic 0 (Root Overview)

- **2 rows — one per RACI role** (see `engine/rules/phase-c-structure.md` §1)
  - `Effective {Subject Name}(R)` — all 16 columns from R (Responsible / Agent) perspective
  - `Effective {Subject Name}(A)` — all 16 columns from A (Accountable / Human Director) perspective
- All 16 columns filled at overview/surface depth. Do not go deep — deeper pages will cover that.
- Each row's col 10 produces a role-specific UBS seed for P1. Each row's col 4 produces a role-specific UDS seed for P2.

### Topics 1–5 (Deep-Dive Topics)

- **DUPLICATE the parent page — do not regenerate. Copy ALL rows (both R and A).**
  - Topic 1 Page 0 = copy of Topic 0 Page 1 (UBS rows)
  - Topic 2 Page 0 = copy of Topic 0 Page 2 (UDS rows)
  - Topic 3 Page 0 = copy of Topic 0 Page 3 (EP rows)
  - Topic 4 Page 0 = copy of Topic 0 Page 4 (UES rows)
  - Topic 5 Page 0 = copy of Topic 0 Page 5 (EOP rows)
- Rename the file only. No content generation needed. This saves tokens and ensures continuity.

---

## Derivation Rules

| Column        | Source                                                                                  |
| ------------- | --------------------------------------------------------------------------------------- |
| Col 10 · UBS  | Row R col 10 → P1 row `UBS(R)`. Row A col 10 → P1 row `UBS(A)`. Two seeds, two P1 rows. |
| Col 4 · UDS   | Row R col 4 → P2 row `UDS(R)`. Row A col 4 → P2 row `UDS(A)`. Two seeds, two P2 rows.   |
| Col 6 · EP    | Seeds the principles for Page 3 (from both R and A rows)                                |
| Col 7+8 · UES | Seeds the components/tools for Page 4 (from both R and A rows)                          |
| Col 3 · EOP   | Seeds the steps for Page 5 (from both R and A rows)                                     |

---

## Cell Address Grammar (CAG — mandatory)

**Every cell** in the table MUST begin with its content-address tag per `engine/rules/phase-c-structure.md` §2.

Format: `{RowCode}{ColSuffix}: {content}`

P0 uses `Effective(R)` and `Effective(A)` as row codes. Example cells for the R row:

| Col | Cell content starts with | Example                                                                 |
| --- | ------------------------ | ----------------------------------------------------------------------- |
| 1   | `Effective(R).REL:`      | `Effective(R).REL: The OE System enables the Agent to...`               |
| 4   | `Effective(R).UD:`       | `Effective(R).UD: UEDS Methodology — the 10-UT causal framework...`     |
| 6   | `Effective(R).UD.EP:`   | `Effective(R).UD.EP: P1(S)(R): Structured Framework Loading — ...`     |
| 10  | `Effective(R).UB:`       | `Effective(R).UB: Context Fragmentation — the inability to maintain...` |
| 12  | `Effective(R).UB.EP:`   | `Effective(R).UB.EP: P_F1(S)(R): Context-Dependency Trap — ...`        |

See the Column Suffix Codex in `engine/rules/phase-c-structure.md` §2 for all 16 suffixes.

---

## Format (STRICT — pure markdown only)

```markdown
# Topic {X}. {Topic Name} — Page 0: Overview & Summary

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 0. Overview & Summary_
_Subject: {Subject Name} | UDO: [as defined in A — Subject Roadmap]_

---

## Workstream Contract (D28)

_Agent and Learner must discuss and confirm these fields BEFORE filling the table._

| Field      | Value                                                                             |
| ---------- | --------------------------------------------------------------------------------- |
| Workstream | [WS-X: Name — from MCM Table 3]                                                   |
| INPUT      | [What triggers this workstream; what data it receives from upstream systems]      |
| UDO        | [Workstream-specific desired outcome — the STATE this workstream aims to achieve] |
| OUTPUT     | [What this workstream produces; which downstream systems consume it]              |

## RACI Assignment (D23)

_RACI anchors perspective for ALL subsequent pages (P1–P5). UBS/UDS analysis depends on who is R vs A._

| Role            | Actor                                         | Primary Responsibility                      |
| --------------- | --------------------------------------------- | ------------------------------------------- |
| R (Responsible) | [AI Agent role — from MCM Table 4b]           | [Executes the cognitive/computational work] |
| A (Accountable) | [Human Director focus — from MCM Table 4b]    | [Owns decision quality; approves outputs]   |
| C (Consulted)   | [Domain Expert / upstream WS output provider] | [Provides context before action]            |
| I (Informed)    | [Downstream WS consumers + Team/Logs]         | [Receives output after action]              |

## Perspective Rule

> _Each row is answered from its RACI role perspective: the `(R)` row from the Agent's perspective, the `(A)` row from the Human Director's perspective. Identify the row subject type (Effective System / UDS / UBS) before filling cols 4 and 10. The direction of 'works' and 'fails' inverts depending on type._

**CRITICAL: DO NOT rename column headers or Column Key question text. They are IDENTICAL across all Phase C pages. Page-type interpretation belongs ONLY in the Perspective Rule block. Every cell MUST begin with its CAG content-address tag (see above).**

## Column Key

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

| Row                             | 1 · Relevance     | 2 · Precise Definition | 3 · Success Actions | 4 · UDS          | 5 · Success Mechanism | 6 · Success EP      | 7 · Success EOT | 8 · Success EOE | 9 · Failure Actions | 10 · UBS         | 11 · Failure Mechanism | 12 · Failure EP     | 13 · Failure EOT | 14 · Failure EOE | 15 · What Else?    | 16 · Next Steps    |
| ------------------------------- | ----------------- | ---------------------- | ------------------- | ---------------- | --------------------- | -------------------- | ----------------------- | ----------------------------- | ------------------- | ---------------- | ---------------------- | -------------------- | ------------------------ | ------------------------------ | ------------------ | ------------------ |
| **Effective {Subject Name}(R)** | Effective(R).REL: | Effective(R).DEF:      | Effective(R).ACT:   | Effective(R).UD: | Effective(R).UD.MECH: | Effective(R).UD.EP: | Effective(R).UD.EOT:  | Effective(R).UD.EOE:        | Effective(R).FAIL:  | Effective(R).UB: | Effective(R).UB.MECH:  | Effective(R).UB.EP: | Effective(R).UB.EOT:   | Effective(R).UB.EOE:         | Effective(R).ELSE: | Effective(R).NEXT: |
| **Effective {Subject Name}(A)** | Effective(A).REL: | Effective(A).DEF:      | Effective(A).ACT:   | Effective(A).UD: | Effective(A).UD.MECH: | Effective(A).UD.EP: | Effective(A).UD.EOT:  | Effective(A).UD.EOE:        | Effective(A).FAIL:  | Effective(A).UB: | Effective(A).UB.MECH:  | Effective(A).UB.EP: | Effective(A).UB.EOT:   | Effective(A).UB.EOE:         | Effective(A).ELSE: | Effective(A).NEXT: |
```

---

## Rules

- **Workstream Contract and RACI Assignment must be completed BEFORE the table is filled (D28).** These fields anchor all subsequent analysis.
- **Exactly 2 rows: one `(R)`, one `(A)`.** Each row answers all 16 columns from its role's perspective. See `engine/rules/phase-c-structure.md` §1.
- **Do not generate for Topics 1–5 Page 0.** Copy ALL rows from the parent page instead (Workstream Contract and RACI carry over with the copy).
- Col 4 and Col 10 from EACH row become role-specific seeds for Pages 1 and 2.
- **Every cell begins with its CAG tag.** See `engine/rules/phase-c-structure.md` §2.

## Links

- [[blocker]]
- [[codex]]
- [[methodology]]
- [[roadmap]]
- [[workstream]]
