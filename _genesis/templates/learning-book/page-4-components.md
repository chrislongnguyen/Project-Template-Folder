---
version: "1.1"
status: draft
last_updated: 2026-04-10
type: template
---

# Template: Page 4 — UES (Ultimately Effective System)

_Page type: Components — the tools and environment of this Topic (Phase C. Organise Information)._

---

## Naming (Learning Book)

Output files use the sub-system slug and topic number:

- **File name pattern:** `T{topic}.P4-components.md`
- **Output path:** `2-LEARN/{sub-system}/output/{system-slug}/T{topic}.P4-components.md`
- Sub-system = one of: `1-PD`, `2-DP`, `3-DA`, `4-IDM`
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Purpose

Page 4 defines the **Ultimately Effective System (UES)** for this Topic: the concrete tools and environment conditions required to implement the Principles (Page 3).

EP (Page 3) tells you WHAT to do. UES (Page 4) tells you WITH WHAT you execute it.

Each Topic is a system on its own. Mastering the UES for a Topic means: given the right tools and environment, the Principles become executable — the UBS is overcome and the UDS is enabled.

---

## UES = EOE + EOT, in Causally Ordered Layers

<!-- Layer names and count are discovered during LEARN research for this sub-system — not prescribed here. -->
<!-- Define EOE layer names and EOT layer names BEFORE generating this page (check learn-input file or subject notes). -->

Page 4 maps the **Ultimately Effective System (UES)** into its two separately designed components:

- **EOE (Effective Operating Environment):** The environmental conditions that must exist (col 8 Success, col 14 Failure). What surrounds and enables the work.
- **EOT (Effective Operating Tools):** The concrete tools required (col 7 Success, col 13 Failure). What the actor uses to do the work.

EOE and EOT must be designed independently — they are different design concerns even though both are part of UES.

Components must be:

- **Logical**: Each one has a clear purpose and rationale
- **Causal**: Each layer depends on and builds from the layer below it
- **Layered (stacked)**: Layers are causally ordered — you cannot skip layers
- **MECE**: Within each layer, components are mutually exclusive and collectively exhaustive

### Causal Layer Structure (sub-system-specific)

<!-- The number of layers is determined during LEARN research — it is not always exactly 3. -->
<!-- Each sub-system (PD, DP, DA, IDM) may have a different layer count and different layer names. -->

Layers are causally ordered: each layer depends on and builds from the layer(s) below. The **logic** is always the same:

```
Layer N (Lowest): [FOUNDATIONAL LAYER — name from research]
  Must exist before anything else can operate.
  Everything above depends on this.
  Examples by domain: Infrastructure, Physical, Legal, Biological.

Layer N+1: [OPERATIONAL LAYER — name from research]
  The working environment — requires the foundational layer to function.
  Where the actual work is done.
  Examples by domain: Workspace, Digital, Process, Organisational.

[Additional layers if research warrants — name from research]
  Each amplifies the layers below — only add if the sub-system requires it.
  Examples by domain: Intelligence, Cultural, Strategic, Cognitive.
```

**Why this order is always causal:**
- You cannot operate a higher layer without the layer(s) below running.
- The structure is universal — layer names and count are discovered per sub-system during LEARN.

### Defining Layer Names (done before generating this page)

Layer names come from LEARN research for this sub-system. Check the learn-input file or subject notes. Do NOT use INFRA/WORKSPACE/INTEL as defaults — those are example names for one specific subject only.

---

## Row Structure (all Topics)

- **N rows — one component per row**, ordered from foundational layer first to highest layer last
- Row labels: `[LAYER_NAME].{n}(role)` — use the actual layer name from research, sequential within each layer, role-tagged per D29
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

Example for row `{LAYER_NAME}.1(R)` (substitute actual layer name from LEARN research):

- Col 1: `{LAYER_NAME}.1(R).REL: [layer] must exist before any operational layer...`
- Col 4: `{LAYER_NAME}.1(R).UD: [Driver of this layer working well] — ...`
- Col 10: `{LAYER_NAME}.1(R).UB: [Root blocker for this layer] — ...`

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

| Row                  | 1 · Relevance         | 2 · Precise Definition | 3 · Success Actions   | 4 · UDS              | 5 · Success Mechanism     | 6 · Success EP          | 7 · Success EOT            | 8 · Success EOE               | 9 · Failure Actions    | 10 · UBS             | 11 · Failure Mechanism    | 12 · Failure EP         | 13 · Failure EOT           | 14 · Failure EOE               | 15 · What Else?        | 16 · Next Steps        |
| -------------------- | --------------------- | ---------------------- | --------------------- | -------------------- | ------------------------- | ------------------------ | -------------------------- | ----------------------------- | ---------------------- | -------------------- | ------------------------- | ------------------------ | -------------------------- | ------------------------------ | ---------------------- | ---------------------- |
| **[LAYER1].1(R)**    | [LAYER1].1(R).REL:    | [LAYER1].1(R).DEF:     | [LAYER1].1(R).ACT:    | [LAYER1].1(R).UD:    | [LAYER1].1(R).UD.MECH:    | [LAYER1].1(R).UD.EP:    | [LAYER1].1(R).UD.EOT:    | [LAYER1].1(R).UD.EOE:       | [LAYER1].1(R).FAIL:    | [LAYER1].1(R).UB:    | [LAYER1].1(R).UB.MECH:    | [LAYER1].1(R).UB.EP:    | [LAYER1].1(R).UB.EOT:    | [LAYER1].1(R).UB.EOE:        | [LAYER1].1(R).ELSE:    | [LAYER1].1(R).NEXT:    |
| **[LAYER1].2(both)** | [LAYER1].2(both).REL: | [LAYER1].2(both).DEF:  | [LAYER1].2(both).ACT: | [LAYER1].2(both).UD: | [LAYER1].2(both).UD.MECH: | [LAYER1].2(both).UD.EP: | [LAYER1].2(both).UD.EOT: | [LAYER1].2(both).UD.EOE:    | [LAYER1].2(both).FAIL: | [LAYER1].2(both).UB: | [LAYER1].2(both).UB.MECH: | [LAYER1].2(both).UB.EP: | [LAYER1].2(both).UB.EOT: | [LAYER1].2(both).UB.EOE:     | [LAYER1].2(both).ELSE: | [LAYER1].2(both).NEXT: |
| **[LAYER2].1(A)**    | [LAYER2].1(A).REL:    | [LAYER2].1(A).DEF:     | [LAYER2].1(A).ACT:    | [LAYER2].1(A).UD:    | [LAYER2].1(A).UD.MECH:    | [LAYER2].1(A).UD.EP:    | [LAYER2].1(A).UD.EOT:    | [LAYER2].1(A).UD.EOE:       | [LAYER2].1(A).FAIL:    | [LAYER2].1(A).UB:    | [LAYER2].1(A).UB.MECH:    | [LAYER2].1(A).UB.EP:    | [LAYER2].1(A).UB.EOT:    | [LAYER2].1(A).UB.EOE:        | [LAYER2].1(A).ELSE:    | [LAYER2].1(A).NEXT:    |
| **[LAYER3].1(R)**    | [LAYER3].1(R).REL:    | [LAYER3].1(R).DEF:     | [LAYER3].1(R).ACT:    | [LAYER3].1(R).UD:    | [LAYER3].1(R).UD.MECH:    | [LAYER3].1(R).UD.EP:    | [LAYER3].1(R).UD.EOT:    | [LAYER3].1(R).UD.EOE:       | [LAYER3].1(R).FAIL:    | [LAYER3].1(R).UB:    | [LAYER3].1(R).UB.MECH:    | [LAYER3].1(R).UB.EP:    | [LAYER3].1(R).UB.EOT:    | [LAYER3].1(R).UB.EOE:        | [LAYER3].1(R).ELSE:    | [LAYER3].1(R).NEXT:    |
```

---

## Rules

- Always order: foundational layer rows first → higher layers last (causal order preserved).
- Define the layer names and count for your sub-system BEFORE generating this page (check the learn-input file or subject notes).
- Each component derives from the Principles in Page 3 — every component must be traceable to at least one principle.
- **Every component must carry a role tag: (R), (A), or (both) per D29** — indicating which RACI actor primarily uses it.
- Components within a layer are MECE — no overlap, no gaps.
- Do not include components not required by this Topic's Principles.
- Deeper Topics = more specific/granular components than Topic 0.
- **Every cell begins with its CAG tag.** See `engine/rules/phase-c-structure.md` §2.

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[blocker]]
- [[codex]]
- [[roadmap]]
