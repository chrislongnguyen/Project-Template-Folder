# Template: Page 4 — UES (Ultimately Effective System)

_Page type: Components — the tools and environment of this Topic (Phase C. Organise Information)._

---

## Naming (Learning Book)

All learning-book items use the `BOOK-NN` prefix convention (e.g. `BOOK-00`, `BOOK-01`).

- **Prefix:** `BOOK-{NN} — ` (space-em-dash-space separator)
- **This page type** → file name: `BOOK-{NN} — T{topic}.P4 Components.md` (e.g. `BOOK-00 — T0.P4 Components.md`)
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 4 defines the **Ultimately Effective System (UES)** for this Topic: the concrete tools and environment conditions required to implement the Principles (Page 3).

EPS (Page 3) tells you WHAT to do. UES (Page 4) tells you WITH WHAT you execute it.

Each Topic is a system on its own. Mastering the UES for a Topic means: given the right tools and environment, the Principles become executable — the UBS is overcome and the UDS is enabled.

---

## UES = Environment + Tools, in 3 Causal Layers

Components must be:

- **Logical**: Each one has a clear purpose and rationale
- **Causal**: Each layer depends on and builds from the layer below it
- **Layered (stacked)**: The 3-layer stack creates a strong foundation — you cannot skip layers
- **MECE**: Within each layer, components are mutually exclusive and collectively exhaustive

### The Universal 3-Layer Structure

Every subject has 3 causally ordered layers. The layer **names** depend on the subject — you define them based on what makes sense. The **logic** is always the same:

```
Layer 1: [FOUNDATIONAL LAYER]
  Must exist before anything else can operate.
  Everything above depends on this.
  Define the name based on the subject (e.g., Infrastructure, Physical, Legal, Biological).

Layer 2: [OPERATIONAL LAYER]
  The working environment — requires Layer 1 to function.
  Where the actual work is done.
  Define the name based on the subject (e.g., Workspace, Digital, Process, Organisational).

Layer 3: [ENHANCEMENT LAYER]
  Amplifies and optimises — requires Layers 1+2 to be useful.
  Without the layers below it, this layer cannot add value.
  Define the name based on the subject (e.g., Intelligence, Cultural, Strategic, Cognitive).
```

**Why this order is always causal:**

- You cannot operate Layer 2 without Layer 1 running.
- Layer 3 amplifies nothing without Layer 2 to operate in.
- The structure is universal — only the names change per subject.

### Subject-Specific Layer Names (defined in CLAUDE.md per subject)

For the active subject (AI-Centric OE System Design), the 3 layers are:

- **Layer 1 = INFRASTRUCTURE** (Python, Agno, Anthropic API, compute)
- **Layer 2 = WORKSPACE** (Cursor, Git, ILE, ClickUp)
- **Layer 3 = INTELLIGENCE** (Claude LLM, YFinance, Exa, prompts, community)

For other subjects, define equivalent layer names before generating Page 4.

---

## Row Structure (all Topics)

- **N rows — one component per row**, ordered Layer 1 first, Layer 3 last
- Row labels: `[LAYER1_NAME].{n}(R)`, `[LAYER2_NAME].{n}(A)`, `[LAYER3_NAME].{n}(both)` — sequential within each layer, role-tagged per D29
- The role tag `(R)`, `(A)`, or `(both)` indicates which RACI actor primarily uses this component
- Components are specific to THIS Topic's requirements (derived from its Principles)
- Components in deeper Topics go deeper than Topic 0 (which is overview-level)

### Component count guide

- Topic 0: ~6–9 rows (2–3 per layer, overview depth)
- Topics 1–5: more specific, more detailed components for that Topic's system

---

## Causal Logic

For each component row, answer the 16 canonical questions AS IF that component is the subject:

- Col 1: Why does THIS component matter for this Topic's system?
- Col 3: How does it work (install, configure, connect)?
- Col 4: What drives this component to work well?
- Col 10: What ultimately blocks this component from working?
- Etc.

---

## Cell Address Grammar (CAG — mandatory)

**Every cell** MUST begin with its content-address tag per `engine/rules/phase-c-structure.md` §2.

Example for row `INFRA.1(R)`:

- Col 1: `INFRA.1(R).REL: Agent frameworks must exist before any workspace...`
- Col 4: `INFRA.1(R).UD: Framework Maturity — ...`
- Col 10: `INFRA.1(R).UB: Dependency Fragility — ...`

See the Column Suffix Codex in `engine/rules/phase-c-structure.md` §2 for all 16 suffixes.

---

## Format

```markdown
# Topic {X}. {Topic Name} — Page 4: Components

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 4. Components_
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

## Table

| Row                  | 1 · Relevance         | 2 · Precise Definition | 3 · Success Actions   | 4 · UDS              | 5 · Success Mechanism     | 6 · Success EPS          | 7 · Success Tools (UES)    | 8 · Success Environment (UES) | 9 · Failure Actions    | 10 · UBS             | 11 · Failure Mechanism    | 12 · Failure EPS         | 13 · Failure Tools (UES)   | 14 · Failure Environment (UES) | 15 · What Else?        | 16 · Next Steps        |
| -------------------- | --------------------- | ---------------------- | --------------------- | -------------------- | ------------------------- | ------------------------ | -------------------------- | ----------------------------- | ---------------------- | -------------------- | ------------------------- | ------------------------ | -------------------------- | ------------------------------ | ---------------------- | ---------------------- |
| **[LAYER1].1(R)**    | [LAYER1].1(R).REL:    | [LAYER1].1(R).DEF:     | [LAYER1].1(R).ACT:    | [LAYER1].1(R).UD:    | [LAYER1].1(R).UD.MECH:    | [LAYER1].1(R).UD.EPS:    | [LAYER1].1(R).UD.UES.T:    | [LAYER1].1(R).UD.UES.E:       | [LAYER1].1(R).FAIL:    | [LAYER1].1(R).UB:    | [LAYER1].1(R).UB.MECH:    | [LAYER1].1(R).UB.EPS:    | [LAYER1].1(R).UB.UES.T:    | [LAYER1].1(R).UB.UES.E:        | [LAYER1].1(R).ELSE:    | [LAYER1].1(R).NEXT:    |
| **[LAYER1].2(both)** | [LAYER1].2(both).REL: | [LAYER1].2(both).DEF:  | [LAYER1].2(both).ACT: | [LAYER1].2(both).UD: | [LAYER1].2(both).UD.MECH: | [LAYER1].2(both).UD.EPS: | [LAYER1].2(both).UD.UES.T: | [LAYER1].2(both).UD.UES.E:    | [LAYER1].2(both).FAIL: | [LAYER1].2(both).UB: | [LAYER1].2(both).UB.MECH: | [LAYER1].2(both).UB.EPS: | [LAYER1].2(both).UB.UES.T: | [LAYER1].2(both).UB.UES.E:     | [LAYER1].2(both).ELSE: | [LAYER1].2(both).NEXT: |
| **[LAYER2].1(A)**    | [LAYER2].1(A).REL:    | [LAYER2].1(A).DEF:     | [LAYER2].1(A).ACT:    | [LAYER2].1(A).UD:    | [LAYER2].1(A).UD.MECH:    | [LAYER2].1(A).UD.EPS:    | [LAYER2].1(A).UD.UES.T:    | [LAYER2].1(A).UD.UES.E:       | [LAYER2].1(A).FAIL:    | [LAYER2].1(A).UB:    | [LAYER2].1(A).UB.MECH:    | [LAYER2].1(A).UB.EPS:    | [LAYER2].1(A).UB.UES.T:    | [LAYER2].1(A).UB.UES.E:        | [LAYER2].1(A).ELSE:    | [LAYER2].1(A).NEXT:    |
| **[LAYER3].1(R)**    | [LAYER3].1(R).REL:    | [LAYER3].1(R).DEF:     | [LAYER3].1(R).ACT:    | [LAYER3].1(R).UD:    | [LAYER3].1(R).UD.MECH:    | [LAYER3].1(R).UD.EPS:    | [LAYER3].1(R).UD.UES.T:    | [LAYER3].1(R).UD.UES.E:       | [LAYER3].1(R).FAIL:    | [LAYER3].1(R).UB:    | [LAYER3].1(R).UB.MECH:    | [LAYER3].1(R).UB.EPS:    | [LAYER3].1(R).UB.UES.T:    | [LAYER3].1(R).UB.UES.E:        | [LAYER3].1(R).ELSE:    | [LAYER3].1(R).NEXT:    |
```

---

## Rules

- Always order: Layer 1 rows first → Layer 2 rows → Layer 3 rows.
- Define the 3 layer names for your subject BEFORE generating this page (check CLAUDE.md or subject notes).
- Each component derives from the Principles in Page 3 — every component must be traceable to at least one principle.
- **Every component must carry a role tag: (R), (A), or (both) per D29** — indicating which RACI actor primarily uses it.
- Components within a layer are MECE — no overlap, no gaps.
- Do not include components not required by this Topic's Principles.
- Deeper Topics = more specific/granular components than Topic 0.
- **Every cell begins with its CAG tag.** See `engine/rules/phase-c-structure.md` §2.
