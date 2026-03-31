# /learn:structure — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Skipping the P0-P2 checkpoint

**What happens:** Agent generates all 6 pages in sequence without re-reading P0-P2 before P3-P5. P3/P4/P5 must be seeded from the actual written P0/P1/P2 files, not from the research output directly.

**How to detect:** Check whether the agent issues Read calls against its own P0/P1/P2 output files before generating P3. If it jumps straight from Step 4 (P2) to Step 5 (P3) without re-reading, the checkpoint was skipped.

**Fix:** The CHECKPOINT section between Step 4 and Step 5 is mandatory. After writing P2, re-read P0, P1, P2 files from disk. Extract principles (col 6, col 12), tools (col 7, col 13), and steps (col 3, col 9) as seeds for P3-P5.

---

## 2. Missing CAG tags

**What happens:** Agent writes cell content without the required prefix (e.g., `UBS(R).REL: ...`). Every cell must start with its row code + column suffix. The validation script catches this but agent should self-validate.

**How to detect:** Scan each cell in the generated markdown table. Every cell (except the row label column) must begin with a CAG tag matching the regex in `constraints.yaml`.

**Fix:** Before writing any page file, validate that every content cell starts with `{RowCode}{ColSuffix}:`. Run the validation script immediately after writing each page — do not batch validation to the end.

---

## 3. Direction inversion error on UBS rows

**What happens:** Agent uses P notation (enabling) in `.UD.EP` cells on UBS (blocker) rows. On UBS rows, `.UD.EP` uses P_F notation (failure principle) and `.UB.EP` uses P notation (enabling). This is inverted from UDS rows. Getting this wrong corrupts the causal spine.

**How to detect:** On any UBS row, check column 6 (`.UD.EP`). It should contain `P_F[n]` not `P[n]`. On UDS rows, the opposite applies: `.UD.EP` should contain `P[n]`.

**Fix:** Before filling EP columns, confirm the row type (UBS vs UDS). Apply the direction rule from Hard Rule 7 in SKILL.md: UBS `.UD.EP` = P_F, UBS `.UB.EP` = P; UDS `.UD.EP` = P, UDS `.UB.EP` = P_F.

---

## 4. Loading multiple topics in one invocation

**What happens:** Agent loads research for all topics instead of just the requested one. This wastes context budget and risks cross-contamination between topics.

**How to detect:** Check whether the agent reads research files beyond `T{topic-number}-*.md`. Any Read call to a different topic's research file is a violation.

**Fix:** The GATE in SKILL.md is explicit: "Load ONLY that topic's research file." The orchestrator (/learn) handles the loop. Each invocation is scoped to one topic.

---

## 5. Missing mermaid companion blocks

**What happens:** Agent generates the 17-column table but omits the mermaid diagram that should follow it. Each P-page requires a lightweight mermaid block visualizing key relationships.

**How to detect:** Search each output file for a ```` ```mermaid ```` block after the table. If absent, the companion is missing.

**Fix:** After writing the table for each page, append a mermaid block following the spec in SKILL.md (P0=relationship map, P1/P2=causal chain, P3=pillar map, P4=layer diagram, P5=flow). Keep under 15 nodes.

---

## 6. Infinite validation retry loop

**What happens:** Agent keeps re-generating a page that fails validation, burning context without converging. This typically happens when the research is thin for certain cells.

**How to detect:** If the same page fails validation twice in sequence with the same or similar errors.

**Fix:** Apply the escape hatch: after 2 validation failures, present partial output with `[NEEDS REVIEW]` flags on problematic cells. Report specific gaps to the user rather than retrying.
