# Implementation Plan: {Project Name}

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** {One sentence describing what this plan builds}

**Architecture:** {2-3 sentences about overall approach and key design decisions}

**Tech Stack:** {Key technologies, languages, libraries}

**Spec:** `{path/to/spec.md}` ({line count}, v{n} {STATUS})

---

## Plan Identity

| Field | Value |
|---|---|
| Spec Version | v{n} |
| Plan Version | v{m} |
| Plan Date | {YYYY-MM-DD} |
| Critical Path | {Dx → Dy → Dz} |
| Estimated Duration | {~Nh total on critical path} |

---

## Scope Check

{1-2 sentences confirming this plan is for one coherent system, or explaining why it is appropriately scoped. If multiple subsystems were split into separate plans, note that here.}

---

## File Structure

### Files to Create

```
{dir/}
├── {file}          # {responsibility}
└── {dir/}
    └── {file}      # {responsibility}
```

### Files to Modify

```
{path/to/existing/file}     # {what changes and why}
```

### Files to Reuse / Copy

```
{source/path}  →  {dest/path}     # {adaptation needed}
```

---

## Deliverable Overview

| D# | Name | Tasks | Agent Arch | Dependencies | Spec §§ |
|---|---|---|---|---|---|
| D1 | {Name} | {count} | {Pattern} | {D# or None} | §{n.m} |
| D2 | {Name} | {count} | {Pattern} | {D#} | §{n.m} |

**Critical Path:** D{x} → D{y} → D{z}

**Parallel Paths:**
- D{a} can run parallel with D{b} ({reason})

---

## D1: {Deliverable Name}

**HOW:** {What the agent will build and how — 2-4 sentences describing the approach, key files created, and the outcome when done}

**HOW NOT:**
- Do NOT {specific alternative} — {specific reason why it is rejected}
- Do NOT {specific shortcut} — {specific consequence if taken}

**Agent Architecture:** {Pattern} — {count} {Complexity}-complexity tasks; {1-sentence rationale}

### Task 1.1: {Task Name}

**Files:**
- Create: `{exact/path/to/file}`
- Modify: `{exact/path/to/existing.file}:{line-range}`
- Test: `{tests/exact/path/to/test.file}`

- [ ] **Step 1: {Action}**

```{language}
{complete code, not pseudocode}
```

- [ ] **Step 2: Verify**

Run: `{exact command}`
Expected: `{exact expected output}`

- [ ] **Step 3: Commit**

```bash
git add {file1} {file2}
git commit -m "{type(scope): description}"
```

### Task 1.2: {Task Name}

**Files:**
- Create: `{exact/path/to/file}`

- [ ] **Step 1: {Action}**

{Complete step with exact commands, code, or content}

- [ ] **Step 2: Commit**

```bash
git add {files}
git commit -m "{type(scope): description}"
```

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T1.1 | {Noun-AC1, Verb-AC2} |
| T1.2 | {Noun-AC3} |

---

## D2: {Deliverable Name}

**HOW:** {Approach description}

**HOW NOT:**
- Do NOT {alternative} — {reason}
- Do NOT {shortcut} — {consequence}

**Agent Architecture:** {Pattern} — {rationale}

### Task 2.1: {Task Name}

**Files:**
- Create: `{exact/path/to/file}`

- [ ] **Step 1: {Action}**

{Complete step}

- [ ] **Step 2: Commit**

```bash
git add {files}
git commit -m "{type(scope): description}"
```

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T2.1 | {AC-IDs} |

---

<!-- Repeat D# sections for all deliverables -->

---

## Plan Validation Report

| Check | Result | Notes |
|---|---|---|
| 1. Critical path duration | {PASS/WARN/FAIL} | {estimated hours} |
| 2. Max tasks/deliverable | {PASS/FAIL} | {worst offender or "all ≤ 6"} |
| 3. Agent arch vs. matrix | {PASS/FAIL} | {mismatches or "all match"} |
| 4. File path plausibility | {PASS/FAIL} | {invalid paths or "all plausible"} |
| 5. AC → task coverage | {PASS/FAIL} | {unmapped ACs or "all covered"} |
| 6. Task → AC coverage | {PASS/FAIL} | {orphan tasks or "all mapped"} |
| 7. HOW NOT present | {PASS/FAIL} | {missing deliverables or "all present"} |

**Overall: {PASS / WARN / FAIL}**

{If WARN or FAIL: describe issues and resolution or escalation rationale}
