---
version: "1.2"
last_updated: 2026-03-30
owner: "Long Nguyen"
name: ltc-writing-plans
description: "DEPRECATED — Use `/dsbv sequence` instead. This skill is now a sub-skill of /dsbv Sequence phase. Kept for backward compatibility."
deprecated: true
redirect: "/dsbv sequence"
---
# Writing Plans (LTC OE.6.4 Fork)

> **DEPRECATED:** This skill has been consolidated into `/dsbv sequence`. Use `/dsbv sequence` for implementation planning.
> This file is retained for backward compatibility — invoking `/ltc-writing-plans` will still work but follows the `/dsbv sequence` workflow.
> **Agent:** Planning is handled by `ltc-planner` (`.claude/agents/ltc-planner.md`).

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `3-PLAN/architecture/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

<HARD-GATE>
1. Do NOT start writing a plan without a spec or clear requirements to plan against.
2. Do NOT present a plan to the user without running the Plan Validation Checklist (all 7 checks).
3. Do NOT skip HOW NOT sections — every deliverable MUST have one with ≥2 entries.
4. Do NOT invoke implementation skills (executing-plans, subagent-driven-development) until the user has approved the plan.
</HARD-GATE>

---

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

---

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns.

---

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" — step
- "Run it to make sure it fails" — step
- "Implement the minimal code to make the test pass" — step
- "Run the tests and make sure they pass" — step
- "Commit" — step

---

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

---

## Deliverable Structure (LTC Extension)

Each deliverable in the plan MUST include three additional sections beyond the base task structure:

### HOW NOT Section (mandatory)

Every deliverable MUST have a **HOW NOT** section that explicitly states rejected alternatives and WHY. This prevents agent drift during execution.

```markdown
**HOW NOT:**
- Do NOT [alternative approach] — [specific reason why it fails or is rejected]
- Do NOT [shortcut] — [consequence if taken]
- Do NOT [scope expansion] — [why it is out of bounds]
```

Rules for HOW NOT sections:
- At least 2 entries per deliverable (minimum viable drift guard)
- Each entry must state BOTH what not to do AND why
- "Why" must be specific, not generic ("breaks X" not "bad idea")
- Reference the scope-exclusions guide: `references/scope-exclusions-guide.md`

### Agent Architecture Decision (mandatory)

Every deliverable MUST have an **Agent Architecture** section that states the chosen pattern from the 2D decision matrix and the rationale.

```markdown
**Agent Architecture:** {Pattern} — {Count} {Complexity}-complexity tasks; {1-sentence rationale}
```

Use the decision tree: `references/agent-arch-decision-tree.md`

Valid patterns: `Single Agent`, `Sub-Agents`, `Agent Team`, `Agent Team + Scoped Reviewers`

### AC Coverage Table (mandatory)

Every deliverable MUST include an AC Coverage table mapping each task to the VANA-SPEC ACs it satisfies.

```markdown
#### AC Coverage
| Task | Covers ACs |
|---|---|
| T1 | AC-ID-1, AC-ID-2 |
| T2 | AC-ID-3 |
```

---

## Task Structure

````markdown
### Task N: [Component Name]
**Files:** Create: `path/file.py` | Modify: `path/existing.py:123-145` | Test: `tests/path/test.py`

- [ ] **Step 1: Write the failing test**
```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```
- [ ] **Step 2: Run test to verify it fails**
  Run: `pytest tests/path/test.py::test_name -v` → Expected: FAIL
- [ ] **Step 3: Write minimal implementation**
```python
def function(input):
    return expected
```
- [ ] **Step 4: Run test to verify it passes**
  Run: `pytest tests/path/test.py::test_name -v` → Expected: PASS
- [ ] **Step 5: Commit**
  `git add <files> && git commit -m "feat: add specific feature"`
````

---

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits
- HOW NOT section required per deliverable (see scope-exclusions-guide.md)
- Agent Architecture decision required per deliverable (see agent-arch-decision-tree.md)

---

## Plan Validation Checklist (Fix 4 — Mandatory)

**Run ALL 7 checks BEFORE presenting plan for human review.** Not optional.

Full reference: [references/plan-validation-checklist.md](references/plan-validation-checklist.md)

| # | Check | Flag |
|---|---|---|
| 1 | Critical path duration | > 8h |
| 2 | Max tasks/deliverable | > 6 |
| 3 | Agent arch vs matrix | Mismatch |
| 4 | File paths plausible | Bad parent |
| 5 | Every AC → ≥1 task | Unmapped |
| 6 | Every task → ≥1 AC | Orphan |
| 7 | HOW NOT present | Missing |

Fix failures, re-check (max 2 retries). After 2, present with WARN to human.

---

## Review & Handoff

After plan passes validation, run the review loop and offer execution options.

**Read `references/review-and-handoff.md`** for:
- Plan-document-reviewer dispatch protocol (max 3 iterations)
- Execution choice: Subagent-Driven (recommended) vs Inline
- Required sub-skills for each execution path

---

## Gotchas

- **Missing HOW NOT sections** — agent writes deliverables without them, removing the primary drift guard. Sub-agents then take rejected approaches during execution. ≥2 entries per deliverable, each with specific reason.
- **Skipping plan validation checklist** — agent presents plan to human without running the 7 checks. Unmapped ACs, scope creep, and bad file paths slip through. Run BEFORE presenting, not after.
- **Orphan tasks / unmapped ACs** — tasks that map to no AC = scope creep. ACs with no task = coverage gap. Build the AC Coverage table and verify bidirectional mapping.

Full list (5 patterns): [gotchas.md](gotchas.md)

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[agent-arch-decision-tree]]
- [[deliverable]]
- [[dsbv]]
- [[gotchas]]
- [[idea]]
- [[ltc-planner]]
- [[plan-validation-checklist]]
- [[review-and-handoff]]
- [[scope-exclusions-guide]]
- [[task]]
