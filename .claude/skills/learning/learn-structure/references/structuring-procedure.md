# Structuring Procedure — Effective Learning Page Generation

This is the detailed step-by-step procedure for generating 6 Effective Learning pages from research output. The SKILL.md references this file. Follow steps in exact order.

---

## Step 1: Load Research

Read the research file:
```
2-LEARN/research/{system-slug}/T{topic-number}-*.md
```

Parse the YAML frontmatter to confirm: topic, EO, RACI roles, timestamp, status.

Scan the research body and identify sections that map to Effective Learning pages:
- **Root Blockers** sections → feeds P1
- **Root Drivers** sections → feeds P2
- **Governing Principles** sections → feeds P3
- **Tools and Environment** sections → feeds P4
- **Operating Procedures** sections → feeds P5
- **Overview / Executive Summary** → feeds P0

Keep the full research in context — you'll reference specific sections per page.

---

## Step 2: Generate P0 (Overview & Summary)

### Read
- `2-LEARN/templates/page-0-overview-and-summary.md`
- `2-LEARN/input/learn-input-{system-slug}.md` for Workstream Contract and RACI fields

### Structure

**Header:**
```markdown
# Topic {X}. {Topic Name} — Page 0: Overview & Summary

_Phase C. Organise Information | Topic: {X}. {Topic Name} | Page: 0. Overview & Summary_
_Subject: {Subject Name} | EO: {eo from learn-input}_

---
```

**Workstream Contract** — populate from learn-input:
- Workstream: derived from system_name
- INPUT: from input_contract.source
- EO: from eo field
- OUTPUT: from output_contract.consumer

**RACI Assignment** — populate from learn-input:
- R: from user_persona_r
- A: from user_persona_a

**Table** — exactly 2 rows:

| Row | Row Label (bold) | CAG Prefix in Cells | Source |
|-----|-----------------|---------------------|--------|
| 1 | `**Effective {Full Subject Name}(R)**` | `Eff.{ABBREV}(R).` e.g. `Eff.DF(R).REL:` | All 16 columns from Agent (R) perspective, using research |
| 2 | `**Effective {Full Subject Name}(A)**` | `Eff.{ABBREV}(A).` e.g. `Eff.DF(A).REL:` | All 16 columns from Human Director (A) perspective, using research |

`{ABBREV}` = `subject_abbreviation` from learn-input. `{Full Subject Name}` = `system_name` from learn-input.

### Column-by-column guidance for P0

| Col | Suffix | P0 guidance |
|-----|--------|-------------|
| 1 | `.REL` | Why this system matters to this role. 2-3 sentences. |
| 2 | `.DEF` | Precise definition: what it IS and what it is NOT. Include boundaries. |
| 3 | `.ACT` | How the system operates when functioning correctly. Key workflows. |
| 4 | `.UD` | The single root driver — what ultimately causes this system to succeed for this role. **This seeds P2.** |
| 5 | `.UD.MECH` | How the driver (col 4) mechanically causes success. |
| 6 | `.UD.EP` | The principle the driver is based on. Use `P[n](pillar)(role):` notation. **This seeds P3.** |
| 7 | `.UD.EOT` | Tools the driver requires. **Seeds P4.** |
| 8 | `.UD.EOE` | Environmental conditions the driver requires. |
| 9 | `.FAIL` | How the system fails — key failure modes for this role. |
| 10 | `.UB` | The single root blocker — what ultimately causes failure for this role. **This seeds P1.** |
| 11 | `.UB.MECH` | How the blocker (col 10) mechanically causes failure. |
| 12 | `.UB.EP` | The principle the blocker exploits. Use `P_F[n](pillar)(role):` notation. **Seeds P3.** |
| 13 | `.UB.EOT` | Tools related to the failure cause. |
| 14 | `.UB.EOE` | Environmental conditions related to failure. |
| 15 | `.ELSE` | What to do if the system fails. Contingency actions. |
| 16 | `.NEXT` | Immediate next steps for this role. |

### T1+ P0 Rule
For Topics 1-5, P0 is a COPY of the parent topic's corresponding page:
- T1.P0 = copy of T0.P1 (UBS rows)
- T2.P0 = copy of T0.P2 (UDS rows)
- T3.P0 = copy of T0.P3 (EP rows)
- T4.P0 = copy of T0.P4 (EOE/EOT rows)
- T5.P0 = copy of T0.P5 (EOP rows)

Do not regenerate — copy the file and rename.

### Validate P0
- Row count: exactly 2
- Column count: 17 per row
- CAG tags on all cells
- Col 4 and col 10 contain substantive content (they seed P1 and P2)

---

## Step 3: Generate P1 (Ultimate Blockers)

### Read
- `2-LEARN/templates/page-1-ultimate-blockers.md`
- The P0 file you just wrote (to extract col 10 seeds)

### Structure

**T0 depth — 2 rows:**
- `UBS(R)` — seeded from P0 `Effective(R).UB:` (col 10 of R row)
- `UBS(A)` — seeded from P0 `Effective(A).UB:` (col 10 of A row)

**T1+ depth — up to 6 rows (3 per role chain):**
- `UBS(R).UB` — from this topic's P0, col 10
- `UBS(R).UB.UB` — from row above, col 10
- `UBS(R).UB.UD` — from row above, col 4
- (repeat for A chain)

### Direction Inversion (CRITICAL for P1)
On UBS rows, the direction is INVERTED:
- Col 4 (`.UD`) = what DRIVES the blocker → bad for learner
- Col 6 (`.UD.EP`) = principle the blocker exploits → use **P_F notation**
- Col 10 (`.UB`) = what DISABLES the blocker → good for learner
- Col 12 (`.UB.EP`) = principle that helps disable blocker → use **P notation**

This is the #1 most common error. Double-check every P1 cell.

### Validate P1
- Row count: 2 (T0) or 2-6 (T1+)
- Direction: col 6 uses P_F, col 12 uses P
- Seeds match P0 col 10

---

## Step 4: Generate P2 (Ultimate Drivers)

### Read
- `2-LEARN/templates/page-2-ultimate-drivers.md`
- The P0 file you wrote (to extract col 4 seeds)

### Structure

**T0 depth — 2 rows:**
- `UDS(R)` — seeded from P0 `Effective(R).UD:` (col 4 of R row)
- `UDS(A)` — seeded from P0 `Effective(A).UD:` (col 4 of A row)

**T1+ depth — up to 6 rows (3 per role chain):**
- `UDS(R).UD` — from this topic's P0, col 4
- `UDS(R).UD.UB` — from row above, col 10
- `UDS(R).UD.UD` — from row above, col 4
- (repeat for A chain)

### Direction (standard for P2)
On UDS rows, direction is STANDARD:
- Col 4 (`.UD`) = what drives the driver → good for learner
- Col 6 (`.UD.EP`) = enabling principle → use **P notation**
- Col 10 (`.UB`) = what blocks the driver → bad for learner
- Col 12 (`.UB.EP`) = exploited principle → use **P_F notation**

### Validate P2
- Row count: 2 (T0) or 2-6 (T1+)
- Direction: col 6 uses P, col 12 uses P_F
- Seeds match P0 col 4

---

## CHECKPOINT: Re-read P0, P1, P2

**This step is mandatory. Do not skip it.**

Read back the three files you just wrote:
1. `2-LEARN/output/{system-slug}/T{n}.P0-overview-and-summary.md`
2. `2-LEARN/output/{system-slug}/T{n}.P1-ultimate-blockers.md`
3. `2-LEARN/output/{system-slug}/T{n}.P2-ultimate-drivers.md`

Extract into a working list:
- **All P principles** (from col 6 cells across all pages): `P[n](pillar)(role): description`
- **All P_F principles** (from col 12 cells across all pages): `P_F[n](pillar)(role): description`
- **All tools** (from col 7 and col 13 cells)
- **All actions/steps** (from col 3 and col 9 cells)

This list becomes the seed for P3, P4, P5. Do not invent new content — only organize what's already in P0-P2.

---

## Step 5: Generate P3 (Principles)

### Read
- `2-LEARN/templates/page-3-principles.md`
- Your extracted principles list from the checkpoint

### Structure

**Harvest — do not generate.** P3 consolidates principles already embedded in P0+P1+P2 col 6 and col 12.

Each row: `P[n](pillar)(role)` for enabling principles, `P_F[n](pillar)(role)` for failure principles.

**Pillar assignment:**
- Ask: "Does this principle prevent failure (S), reduce waste (E), or enable growth (Sc)?"
- If ambiguous: S > E > Sc (Sustainability wins)

**Role tag:** `(R)`, `(A)`, or `(both)` — last parenthetical in row label.

**Each principle row must state:** "Enables [UDS element from P0/P2]" OR "Disables [UBS element from P0/P1]"

### Typical count: 4-8 rows

### Validate P3
- All principles trace to P0/P1/P2 col 6 or col 12
- Every row has pillar tag (S/E/Sc) AND role tag (R/A/both)
- No orphan principles

---

## Step 6: Generate P4 (Components)

### Read
- `2-LEARN/templates/page-4-components.md`
- P3 output (to derive components that enable the principles)

### Structure

3-layer causal stack:
1. **Foundational** (`INFRA.n(role)`) — core infrastructure, frameworks, data stores
2. **Operational** (`WORKSPACE.n(role)`) — daily tools, environments, workflows
3. **Enabling** (`INTEL.n(role)`) — intelligence/analysis tools that amplify capability

Each component must explicitly state which P3 principle(s) it enables.

### Typical count: 4-8 rows

### Validate P4
- Each component references at least one P3 principle
- 3 layers represented (INFRA, WORKSPACE, INTEL)

---

## Step 7: Generate P5 (Steps to Apply)

### Read
- `2-LEARN/templates/page-5-steps-to-apply.md`
- P1-P4 outputs (P5 references elements from all prior pages)

### Structure

Sequential steps: `STEP.n(role)` — numbered sequentially.

**Order: DERISK then OPTIMIZE**
1. Steps 1-N: DERISK — address UBS elements from P1 (failure prevention first)
2. Steps N+1-M: OPTIMIZE — leverage UDS elements from P2 (success acceleration second)

Each step must reference specific P1-P4 elements it acts on. Example:
`STEP.1(R).ACT: Load architectural context [INFRA.1(R)] before execution to prevent UBS(R) — Context Fragmentation`

### Typical count: 4-6 rows

### Validate P5
- DERISK steps before OPTIMIZE steps
- Each step references P1-P4 elements
- Role tags present on all rows

---

## Step 8: Batch Validation

Run the validation script on all 6 pages:

```bash
for page in P0 P1 P2 P3 P4 P5; do
  file=$(ls 2-LEARN/output/{system-slug}/T{n}.${page}-*.md 2>/dev/null)
  if [ -n "$file" ]; then
    bash 2-LEARN/scripts/validate-learning-page.sh "$file" "$page" "T{n}"
  fi
done
```

If any page fails, attempt to fix the specific errors (usually CAG tag formatting). Re-validate after fixes.

Report results per the SKILL.md completion report format.

## Links

- [[SKILL]]
- [[VALIDATE]]
- [[blocker]]
- [[standard]]
- [[workstream]]
