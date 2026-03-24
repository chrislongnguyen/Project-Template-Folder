---
name: ltc-writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code. LTC fork with HOW NOT sections, agent architecture decisions, and mandatory plan validation checklist (Fix 4).
---

# Writing Plans (LTC OE.6.4 Fork)

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

---

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

---

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure — but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

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
- Reference the scope-exclusions guide: `skills/ltc-writing-plans/references/scope-exclusions-guide.md`

### Agent Architecture Decision (mandatory)

Every deliverable MUST have an **Agent Architecture** section that states the chosen pattern from the 2D decision matrix and the rationale.

```markdown
**Agent Architecture:** {Pattern} — {Count} {Complexity}-complexity tasks; {1-sentence rationale}
```

Use the decision tree: `skills/ltc-writing-plans/references/agent-arch-decision-tree.md`

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

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
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

## Plan Validation Checklist (Fix 4 — Mandatory Inner Derisk)

**Run ALL 7 checks BEFORE presenting plan for human review.** This is not optional. Failure behavior: fix and re-check (max 2 retries), then surface with warnings.

Full reference: `skills/ltc-writing-plans/references/plan-validation-checklist.md`

| # | Check | Flag Threshold | Rationale |
|---|---|---|---|
| 1 | Total critical path duration | > 8 hours | Risk of session context loss (LT-6) |
| 2 | Max tasks per deliverable | > 6 tasks | Risk of reasoning degradation (LT-3) |
| 3 | Agent architecture matches 2D decision tree | Any mismatch | Inconsistency = downstream failure |
| 4 | All referenced file paths are plausible | Any non-existent parent dir | Prevents agent confusion during execution |
| 5 | Every VANA-SPEC AC maps to at least one task | Any unmapped AC | Coverage gap = untested requirement |
| 6 | Every task maps to at least one VANA-SPEC AC | Any orphan task | Scope creep = wasted effort |
| 7 | HOW NOT sections present for every deliverable | Any missing | Drift prevention |

**How to run:**

1. List all deliverables and count tasks per deliverable — flag any > 6
2. Sum the critical path (longest chain of dependent tasks) — flag if > 8h estimated
3. For each deliverable, look up Count × Complexity in the decision matrix — flag mismatches
4. For each file path in the plan, verify the parent directory is either existing or created in an earlier task
5. For each VANA-SPEC AC, find at least one task that covers it — list unmapped ACs
6. For each task, verify it maps to at least one AC — list orphan tasks
7. Confirm every deliverable section has a **HOW NOT** heading with ≥1 entry

**Validation Report Format:**

```
## Plan Validation Report

| Check | Result | Notes |
|---|---|---|
| 1. Critical path duration | PASS / WARN | {estimated hours} |
| 2. Max tasks/deliverable | PASS / FAIL | {worst offender} |
| 3. Agent arch vs. matrix | PASS / FAIL | {mismatches} |
| 4. File path plausibility | PASS / FAIL | {invalid paths} |
| 5. AC → task coverage | PASS / FAIL | {unmapped ACs} |
| 6. Task → AC coverage | PASS / FAIL | {orphan tasks} |
| 7. HOW NOT present | PASS / FAIL | {missing deliverables} |

Overall: PASS / WARN / FAIL
```

If any check is FAIL: fix the plan, re-run validation. After 2 retries, present plan with WARN to Human Director.

---

## Plan Review Loop

After writing the complete plan and passing the validation checklist:

1. Dispatch a single plan-document-reviewer subagent (see plan-document-reviewer-prompt.md) with precisely crafted review context — never your session history. This keeps the reviewer focused on the plan, not your thought process.
   - Provide: path to the plan document, path to spec document
2. If Issues Found: fix the issues, re-dispatch reviewer for the whole plan
3. If Approved: proceed to execution handoff

**Review loop guidance:**
- Same agent that wrote the plan fixes it (preserves context)
- If loop exceeds 3 iterations, surface to human for guidance
- Reviewers are advisory — explain disagreements if you believe feedback is incorrect

---

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
