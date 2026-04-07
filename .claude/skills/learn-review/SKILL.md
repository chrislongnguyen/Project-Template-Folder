---
version: "1.2"
status: draft
last_updated: 2026-04-07
name: learn-review
description: >
  Use when /learn calls this skill after structuring one topic. Reviews ONE topic
  at a time: presents causal spine table, asks 1 comprehension question per P-page
  (6 total), then writes validated/needs-revision to each page's frontmatter.
argument-hint: <system-slug> <topic-number>
allowed-tools: Read, Bash, Edit, Write
---
# /learn:review — Per-Topic Review Gate with Active Learning

This skill reviews ONE topic at a time. The orchestrator (/learn) calls this skill
after each topic is structured. Present the causal spine table for that topic only.

## Arguments

Parse `{system-slug}` and `{topic-number}` from the invocation.
If missing, check for a single `2-LEARN/_cross/input/learn-input-*.md` file and
a corresponding `2-LEARN/_cross/output/` directory. If ambiguous, list options.

---

## Injected Context

### Learn Input Metadata
!`cat 2-LEARN/_cross/input/learn-input-*.md 2>/dev/null | head -30`

---

## Pre-Checks

1. Verify `2-LEARN/_cross/output/{system-slug}/T{n}.P0-overview-and-summary.md` exists.
   If not, error: "Run /learn:structure first."
2. Collect all 6 page files for topic T{n}:
   ```
   T{n}.P0-overview-and-summary.md
   T{n}.P1-ultimate-blockers.md
   T{n}.P2-ultimate-drivers.md
   T{n}.P3-principles.md
   T{n}.P4-components.md
   T{n}.P5-steps-to-apply.md
   ```
3. Check each file for existing YAML frontmatter `status:` field.
   - `status: validated` → already validated, skip in review
   - `status: needs-revision` → include (re-review)
   - No frontmatter → include (first review)

<HARD-GATE>
1. Never auto-approve — all pending pages require explicit human response.
2. Learner MUST answer each comprehension question before approval is accepted.
3. Seed checks on P1 and P2 are mandatory even if structural validation passes.
4. Write approval status (validated / needs-revision only) to file frontmatter — not just displayed.
5. Only valid status values: `validated` or `needs-revision`. No other values.
</HARD-GATE>

---

## Phase 1: VALIDATE (automated — no interaction)

### Step 1: Structural validation

```bash
bash 2-LEARN/_cross/scripts/validate-learning-page.sh <file> <page-type> T{n}
```
Capture PASS/FAIL per page.

### Step 2: Seed checks

- **P1 seed:** P0 R row col 10 (`.UB:` cell) concept vs P1 row 1 (`UBS(R)`) label concept
- **P2 seed:** P0 R row col 4 (`.UD:` cell) concept vs P2 row 1 (`UDS(R)`) label concept
- Mark PASS if semantically consistent, FAIL if clearly mismatched.

### Step 3: Extract causal spines

For each page needing review, extract per row:
- **Row label** (bold text in column 1)
- **Col 4 concept** (`.UD:` cell — text after CAG prefix, up to first ` — ` or end)
- **Col 10 concept** (`.UB:` cell — text after CAG prefix, up to first ` — ` or end)

### Step 4: Present causal spine table

```
/learn:review — T{n} Review
System:  {system_name}
Topic:   T{n} — {topic_name}

## Validation Summary

| Page | Rows | Validation | Seed Check | Status           |
|------|------|------------|------------|------------------|
| P0   |  2   | PASS/FAIL  | N/A        | pending/validated |
| P1   |  N   | PASS/FAIL  | PASS/FAIL  | pending/validated |
| P2   |  N   | PASS/FAIL  | PASS/FAIL  | pending/validated |
| P3   |  N   | PASS/FAIL  | N/A        | pending/validated |
| P4   |  N   | PASS/FAIL  | N/A        | pending/validated |
| P5   |  N   | PASS/FAIL  | N/A        | pending/validated |

{If any FAIL: list specific errors here}

## Causal Spine — T{n} Pending Pages

| Page | Row             | Col 4 — UD (what drives it)  | Col 10 — UB (what blocks it) |
|------|-----------------|------------------------------|------------------------------|
| P0   | Eff.{ABBREV}(R) | {concept}                    | {concept}                    |
| P0   | Eff.{ABBREV}(A) | {concept}                    | {concept}                    |
| P1   | UBS(R)          | {concept}                    | {concept}                    |
| ...  | ...             | ...                          | ...                          |

Note: P1 direction is INVERTED — Col 4 drives the blocker (bad), Col 10 disables it (good).
Full cell content in: 2-LEARN/_cross/output/{system-slug}/
```

If all pages already validated, report:
```
All 6 pages already validated. No review needed.
Next: /spec:extract {system-slug} {topic-number}
```

---

## Phase 2: ACTIVE LEARNING (per P-page — sequential)

After presenting the causal spine table, ask 1 comprehension question per pending P-page.
The learner MUST answer before approval is accepted. This is a HARD-GATE.

Ask questions in P0→P5 order. For each page, ask the corresponding question:

- **P0:** "What is the system boundary — what's in scope vs out?"
- **P1:** "Which UBS entry is the root blocker? Why?"
- **P2:** "Which driver has the highest leverage? How?"
- **P3:** "Which principle compensates for the root blocker?"
- **P4:** "Which component implements the highest-leverage principle?"
- **P5:** "What's the first step, and why does it come first?"

### Escape hatch

If a question is unclear or the learner cannot answer after 2 attempts:
- Skip that question
- Note `comprehension_q: skipped` in the P-page's YAML frontmatter
- Proceed to the next question
- Review can still complete with skipped questions (noted in frontmatter)

---

## Phase 3: APPROVE

After all comprehension questions are answered (or skipped), ask:

```
Approve all {N} pending pages, or list pages to revise?
  Examples: "approve all" | "revise P3: missing principle" | "revise P1, P5: notes"
```

Write `status: validated` or `status: needs-revision` to each page's YAML frontmatter.
Only these two values are valid. No other status values.

---

## Completion Report

```
/learn:review complete.

System:   {system_name}
Topic:    T{n} — {topic_name}

Review Results:
  P0 Overview & Summary    — {validated / needs-revision}
  P1 Ultimate Blockers     — {validated / needs-revision}
  P2 Ultimate Drivers      — {validated / needs-revision}
  P3 Principles            — {validated / needs-revision}
  P4 Components            — {validated / needs-revision}
  P5 Steps to Apply        — {validated / needs-revision}

{X}/6 pages validated.

{If all 6 approved:}  Next: /spec:extract {system-slug} {topic-number}
{If any revision:}    Fix flagged pages, then re-run: /learn:review {system-slug} {topic-number}
```

---

## Gotchas

- **Per-topic scope** — this skill reviews ONE topic only. /learn orchestrates across topics.
- **Seed checks mandatory** — P1/P2 seed consistency runs even if structural validation passes.
- **Write to file** — approval = frontmatter update. Display-only approval doesn't satisfy the gate.
- **Binary status only** — `validated` or `needs-revision`. No other values.

Full list: [gotchas.md](gotchas.md)

## Links

- [[VALIDATE]]
- [[blocker]]
- [[gotchas]]
