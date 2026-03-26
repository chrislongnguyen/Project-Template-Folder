---
name: spec-handoff
description: >
  Reviews a generated VANA-SPEC with the Human Director and generates
  GSD-STATE.md to activate the Build pipeline. Run after /spec:extract
  produces 1-ALIGN/learning/specs/{system-slug}/vana-spec.md. HARD STOP — waits for Human
  Director approval before creating GSD-STATE.md.
argument-hint: <system-slug>
model: opus
allowed-tools: Read, Glob, Write
---

# /spec:handoff — Learn → Build Gate

You are the **Human Director review gate** between the Learn Engine and the Build Engine.

Your role: present the VANA-SPEC for approval, then on sign-off, stamp the spec and generate `GSD-STATE.md` to activate the Build pipeline.

## Arguments

Parse `{system-slug}` from the invocation (e.g., `/spec:handoff data-foundation`).
If missing, check for a single `1-ALIGN/learning/specs/*/vana-spec.md` file. If exactly one exists, use it.

---

## Pre-Checks

1. Verify `1-ALIGN/learning/specs/{system-slug}/vana-spec.md` exists. If not, error: "No VANA-SPEC found. Run `/spec:extract {system-slug}` first."
2. Read the spec fully. Count any `[NEEDS REVIEW]` flags. If any exist, warn: "⚠️ Spec contains {n} [NEEDS REVIEW] items — these fields are incomplete. Resolve them first or reply 'Proceed anyway'."
3. Check the first line of the spec for `status: handoff-approved`. If found, warn: "This spec is already handoff-approved (handoff previously completed). Re-reviewing? Reply 'Yes' to continue."

---

## Review Presentation

Present the following structured review to the Human Director in a single output block:

---

### Header

```
/spec:handoff — {system_name} ({system_slug})
Spec file: 1-ALIGN/learning/specs/{system-slug}/vana-spec.md
```

---

### 1. System Identity

| Field | Value |
|-------|-------|
| System | {system_name} ({system_abbrev}) |
| EO | {eo — full text} |
| Responsible (R) | {raci_r} |
| Accountable (A) | {raci_a} |

---

### 2. I1 Build Scope — What Gets Built First

Source: §9 Master Scope Mapping, filtered to Iteration = I1

| AC ID | VANA Word | VANA Element | Criteria (short — ≤15 words) |
|-------|-----------|--------------|------------------------------|
{one row per I1 AC from §9}

**Total I1 ACs:** {n}

---

### 3. I1 Failure Modes — What Can Go Wrong

Source: §7 Iteration 1 Failure Modes

| Failure Mode | Detection | Recovery |
|-------------|-----------|----------|
{rows from §7 I1 table}

---

### 4. Agent Boundaries (I1)

Source: §8 Iteration 1 Boundaries

**Always (no approval needed):**
{§8 I1 Always list}

**Ask First (Human Director approval required):**
{§8 I1 Ask First list}

**Never (hard stops):**
{§8 I1 Never list}

---

### 5. Integration Contracts

Source: §10

**INPUT:** {source} → {schema} | SLA: {sla}
**OUTPUT:** {consumer} → {schema} | SLA: {sla}

(If multiple contracts: list each on its own line.)

---

### Review Questions for Human Director

Before approving, consider:

1. **EO:** Is the system scope complete? Anything in/out of scope that's wrong?
2. **I1 ACs:** Are these the right first things to build? Any AC obviously missing for a working concept?
3. **Failure modes:** Realistic? Any missing scenario that should be a hard stop?
4. **Never list:** Any additional action you want as a hard stop for the agent?
5. **Contracts:** Are the input/output schemas correct?

---

## HARD STOP

```
Review the spec summary above.

  "approved"       → stamp spec + generate GSD-STATE.md
  "defer"          → save spec as-is; no GSD-STATE.md created
  [describe change] → note the change needed; re-run /spec:extract to fix
```

**Do NOT proceed until the Human Director explicitly responds.**

---

## On "approved"

### Step 1: Stamp the VANA-SPEC

Prepend YAML frontmatter to `1-ALIGN/learning/specs/{system-slug}/vana-spec.md`:

```yaml
---
status: handoff-approved
handoff_approved_by: Human Director
handoff_date: {today}
---
```

Insert this block as the very first lines of the file (before the `> ⚠️ CANONICAL SOURCE` line).

If the file already begins with a `---` frontmatter block, add the three fields into the existing block instead of creating a second one.

### Step 2: Write GSD-STATE.md

Write `1-ALIGN/learning/specs/{system-slug}/GSD-STATE.md` with the following content:

```
> Build state tracker for {system_name}. Updated by /session-end; read by /status.
> Source spec: 1-ALIGN/learning/specs/{system-slug}/vana-spec.md  [handoff-approved: {today}]

# GSD-STATE — {system_name}

## Active Build

| Field | Value |
|-------|-------|
| System | {system_name} ({system_abbrev}) |
| Slug | {system_slug} |
| Current Iteration | I1 — Concept |
| Handoff Date | {today} |
| Last Session | — |
| Last Completed AC | — |

## I1 Scope — Active ACs

| AC ID | VANA Word | VANA Element | Criteria (short) | Status | Evidence |
|-------|-----------|--------------|-----------------|--------|----------|
{one row per I1 AC from §9, Status = "To Do", Evidence = "—"}

## Agent Boundaries (I1)

**Always (no approval needed):**
{§8 I1 Always list}

**Ask First (Human Director approval required):**
{§8 I1 Ask First list}

**Never (hard stops — violation = immediate halt):**
{§8 I1 Never list}

## I1 Failure Modes

| Failure Mode | Detection | Recovery |
|-------------|-----------|----------|
{rows from §7 Iteration 1}

## Integration Contracts

### INPUT
{§10 INPUT CONTRACT table — source, schema, validation, error, sla, version}

### OUTPUT
{§10 OUTPUT CONTRACT table — consumer, schema, validation, error, sla, version}

## Next Action

Run `/learn-build-cycle` → State B
First task: {first I1 AC ID} — {VANA Word} — {criteria short form}
```

### Step 3: Report completion

---

## Completion Report

```
/spec:handoff complete.

System:        {system_name} ({system_slug})
Spec:          1-ALIGN/learning/specs/{system-slug}/vana-spec.md  [handoff-approved: {today}]
GSD-STATE:     1-ALIGN/learning/specs/{system-slug}/GSD-STATE.md  [created]

I1 Scope ({n} ACs):
  Verb ACs:         {n} — {comma-separated VANA Words}
  SustainAdv ACs:   {n} — {comma-separated VANA Words}
  Noun ACs:         {n} — {comma-separated VANA Words}
  SustainAdj ACs:   {n} — {comma-separated VANA Words}
  Total I1:         {n}

  Deferred to I2+:  {n} ACs (EffAdv, EffAdj, ScalAdv, ScalAdj, SPAWNED, Hardening)

Build pipeline is now ACTIVE.

Next: /learn-build-cycle → State B
  Start with: {first I1 AC ID} ({VANA Word}) — {criteria ≤10 words}
```

---

## Hard Rules

1. **Interactive gate.** Do not proceed past the HARD STOP without explicit "approved" or "defer".
2. **No spec content modification.** Only add the three frontmatter fields — do not edit any section.
3. **No hallucination.** GSD-STATE.md derives entirely from the VANA-SPEC — no invented tasks or ACs.
4. **I1 scope only in GSD-STATE.** I2–I4 ACs stay in the VANA-SPEC; only I1 ACs go in the active task list.
5. **MECE I1 coverage.** Every AC in §9 with Iteration = I1 must appear in GSD-STATE.md exactly once.
6. **Short criteria.** In GSD-STATE.md, truncate criteria to ≤15 words for readability. Full criteria remain in the VANA-SPEC.
7. **On "defer".** Write a one-line note to the Human Director: "Spec saved. GSD-STATE.md not created. Re-run /spec:handoff when ready to build." Do not modify the spec file.
