---
version: "1.1"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-27
owner: Long Nguyen
---

# DSBV Process — Design, Sequence, Build, Validate

## Overview

DSBV is the **sub-process executed WITHIN each APEI zone** (ALIGN, PLAN, EXECUTE, IMPROVE). Every zone runs one DSBV cycle to produce its artifacts.

**Why DSBV exists:** APEI defines WHAT each zone does. DSBV defines HOW an AI agent + Human Director produce that zone's output. Separating the two eliminates the confusion of recursive APEI naming.

**When to use:** Every time a zone is activated. No zone artifact is produced outside DSBV.

```
APEI Zone (WHAT)          DSBV Phase (HOW)
─────────────────    ×    ─────────────────
ALIGN                     Design
PLAN                      Sequence
EXECUTE                   Build
IMPROVE                   Validate
```

Each zone runs all 4 DSBV phases internally. The zone determines the content; DSBV determines the workflow.

---

## How to Use

- Run `/dsbv` to start a guided DSBV cycle on any zone
- Run `/dsbv design align` to run just the Design phase on the ALIGN zone
- Run `/dsbv status` to see current progress across all zones
- Run `./scripts/dsbv-gate.sh` to manually check zone-boundary readiness
- Skill definition: `.claude/skills/dsbv/SKILL.md` | Rule: `.claude/rules/dsbv.md`
- Context template: `_shared/templates/DSBV_CONTEXT_TEMPLATE.md` | Evaluation template: `_shared/templates/DSBV_EVAL_TEMPLATE.md`

---

## Phase 1: DESIGN

**Purpose:** Define WHAT the zone must produce and WHY.

| Item | Detail |
|------|--------|
| **Input** | Zone scope, prior zone output (if any), reference materials |
| **Output** | `DESIGN.md` — structured spec for all zone artifacts |
| **Who** | Human Director writes high-level intent; Agent expands into structured spec with sections, acceptance criteria, and artifact list |
| **Activities** | 1. Human states intent (1-3 sentences) 2. Agent drafts DESIGN.md with unified artifact-condition table 3. Agent runs alignment check (see below) 4. Human reviews, challenges, refines |
| **Exit Gate** | Human approves DESIGN.md. Alignment check passes. No work proceeds until approved. |

**Key principle:** DESIGN.md is the contract. If it is not in DESIGN.md, it is not in scope.

**Alignment check (mandatory before G1):**
- Every completion condition maps to a named artifact (orphan conditions = 0)
- Every artifact has at least one condition (orphan artifacts = 0 or justified)
- Artifact count in DESIGN.md = deliverable count in context package Section 6
- Violated 3x in I1 ALIGN runs: OKR omission, ADR omission, DESIGN.md omission. Root cause: EP-09 (incomplete decomposition) + EP-10 (done not fully defined). Fix: unified table eliminates the gap between "what to produce" and "how to verify."

---

## Phase 2: SEQUENCE

**Purpose:** ORDER the work — dependencies, build sequence, task sizing.

| Item | Detail |
|------|--------|
| **Input** | Approved DESIGN.md |
| **Output** | `SEQUENCE.md` — ordered task list with dependencies and acceptance criteria per task |
| **Who** | Agent drafts; Human reviews ordering and sizing |
| **Activities** | 1. Identify artifact dependencies (what must exist before what) 2. Decompose into tasks using ADaPT-style adaptive decomposition: start coarse, decompose further only on failure 3. Size each task to ≤1 hour human-equivalent (METR 80% reliability horizon) 4. Assign acceptance criteria per task |
| **Exit Gate** | Human approves task ordering and sizing. |

**Task sizing rule:** If an agent cannot complete a task in one shot, the task is too large — decompose it, do not retry the same scope.

---

## Phase 3: BUILD

**Purpose:** EXECUTE the work following the approved sequence.

| Item | Detail |
|------|--------|
| **Input** | Approved SEQUENCE.md |
| **Output** | All zone artifacts specified in DESIGN.md |
| **Who** | Agent(s) build; pattern depends on zone type (see Multi-Agent Configuration below) |
| **Activities** | For each task in SEQUENCE.md: 1. Implement the artifact 2. Self-verify against task acceptance criteria 3. Checkpoint commit (`git commit`) 4. Proceed to next task |
| **Exit Gate** | All tasks complete. All acceptance criteria met. |

**Design-heavy zones (ALIGN, PLAN):** Use Competing Hypotheses + Synthesis per ADR-001. 3-5 Sonnet agents produce complete packages in parallel; Opus synthesizes best elements; Human approves.

**Execution-heavy zones (EXECUTE, IMPROVE):** Single agent, sequential task completion. Output is more deterministic — diversity of approach adds less value.

---

## Phase 4: VALIDATE

**Purpose:** VERIFY the zone output enables the next zone to start.

| Item | Detail |
|------|--------|
| **Input** | All zone artifacts from BUILD |
| **Output** | Validation report — pass/fail per criterion |
| **Who** | Agent runs checks; Human Director makes final call |
| **Activities** | 1. **Completeness** — all artifacts listed in DESIGN.md are present 2. **Quality** — each artifact passes its success rubric 3. **Coherence** — artifacts do not contradict each other 4. **Downstream readiness** — the next zone can start with these outputs |
| **Exit Gate** | Human Director approves. Artifact status changes from Draft to Approved. |

**Enforcement levels:**
- L2 (current): CLAUDE.md rules — agents follow instructions but can drift
- L5 (target): Deterministic hooks — pre-commit/CI gates enforce validation automatically

---

## Multi-Agent Configuration

| Zone Type | Pattern | Agents | Rationale |
|-----------|---------|--------|-----------|
| Design-heavy (ALIGN, PLAN) | Competing Hypotheses + Synthesis | 3-5 Sonnet (explore) + 1 Opus (synthesize) + Human (approve) | Open-ended work benefits from diverse perspectives. Missing a risk in ALIGN has high blast radius. |
| Execution-heavy (EXECUTE, IMPROVE) | Single Agent | 1 Opus or Sonnet + Human (review) | Deterministic output. Diversity adds cost, not quality. |
| Fallback (any zone) | Single Agent (Opus) | 1 Opus + Human (review) | Use when multi-agent infra is unavailable or N=3 outputs converge (diversity is redundant). |

**Cost model:** 5 Sonnet runs (~$5-8) + 1 Opus synthesis (~$2-5) = ~$10-13 per design-heavy zone. Single Opus = ~$3-5.

---

## Model Configuration

| Model | Cost/Run | When to Use | Example |
|-------|----------|-------------|---------|
| **Sonnet** | $0.50-1.50 | Breadth/exploration — diverse perspectives, parallel hypothesis generation | Build teams (3-5 competing agents) |
| **Opus** | $2-5 | Synthesis/judgment — combining outputs, evaluating quality, final decisions | Build synthesis + Validate phase |
| **Haiku** | $0.05-0.15 | Simple checks — status queries, readiness verification, formatting | Status checks, gate readiness |

**Default configuration:**
- **Design:** Current model (whatever the session is running)
- **Sequence:** Current model
- **Build teams:** Sonnet (cost-effective breadth)
- **Build synthesis:** Opus (quality judgment)
- **Validate:** Opus (rigorous evaluation)

**Override syntax:** `--model opus --teams 3` (overrides Build team model and count)

---

## DSBV Readiness Conditions (C1-C6)

All conditions must be GREEN before starting a DSBV cycle.

| ID | Condition | Check |
|----|-----------|-------|
| C1 | **Clear scope** | Zone identified. What is in scope and out of scope is written down. |
| C2 | **Input materials curated** | Agent reading list assembled — prior zone output, reference docs, research. No "go find it yourself." |
| C3 | **Success rubric defined** | How to judge output quality. Per-artifact criteria, not vibes. |
| C4 | **Process definition loaded** | This document (DSBV_PROCESS.md) is in agent context. |
| C5 | **Prompt engineered** | Context package fits within effective window. Irrelevant material removed. |
| C6 | **Evaluation protocol defined** | How Opus compares competing outputs (for design-heavy). How Human reviews final output. |

**If any condition is RED:** Fix it before starting. Running DSBV without readiness produces waste.

---

## Quick Reference

```
                         DSBV FLOW
                         =========

  ┌─────────┐    G1     ┌──────────┐    G2     ┌─────────┐    G3     ┌──────────┐    G4
  │ DESIGN  │──────────▶│ SEQUENCE │──────────▶│  BUILD  │──────────▶│ VALIDATE │──────▶ DONE
  │         │  Human    │          │  Human    │         │  All AC   │          │ Human
  │ Spec    │  approves │ Task     │  approves │ Produce │  met      │ Complete │ approves
  │ WHAT    │  DESIGN   │ ORDER    │  ordering │ HOW     │           │ CHECK    │ zone
  └─────────┘  .md      └──────────┘  + sizing └─────────┘           └──────────┘ output

  G = Gate (human approval required)

  Design-heavy zones:  BUILD uses Competing Hypotheses + Synthesis (ADR-001)
  Execution-heavy:     BUILD uses single agent, sequential tasks
```

---

## Lessons Learned

Captured from real DSBV runs. Each lesson traces to a 7-CS root cause component.

| # | Lesson | Root Cause (7-CS) | Mitigation |
|---|--------|-------------------|------------|
| 1 | Context package Section 3 (Required Artifacts) and Section 6 (Agent Deliverables) must be 1:1. In the ALIGN run, OKRs were listed as required but not included in deliverables — agents correctly produced only what was specified. | **Input** — incomplete deliverable list in prompt | Add readiness check: diff artifact list vs deliverable list before launch. If mismatch, BLOCK. |
| 2 | DESIGN.md was not produced by any Build team because it was not in the deliverables list, only implied by the process. | **Input** — assumed artifact not explicitly assigned | Every artifact in DESIGN.md must appear as a named deliverable in the context package. Implicit = missing. |
| 3 | Agents running in worktrees complicated output collection — synthesis agent had to locate and compare files across multiple directories. | **EOE** — worktree isolation created collection overhead | Automate worktree output collection: script that gathers all team outputs into a single comparison directory before synthesis. |
| 4 | Agent skipped /dsbv skill invocation and operated from degraded memory of SKILL.md. Hard Gate #4 (multi-agent prompt) was missed. User not offered single/multi-agent choice. | **Agent + EOP** — LT-2 context degradation + LT-8 rationalization. Rules are probabilistic (~80%). | Deploy `dsbv-skill-guard.sh` hook: blocks zone artifact writes if DESIGN.md doesn't exist. Enforces OUTCOME (Design phase completed) not PROCESS (skill invoked). |
| 5 | Hook blocked legitimate writes to operational files (retros, changelogs) because no DESIGN.md existed for that zone. | **EOE** — hook enforcement too broad | Add allowlist in hook for operational files: retrospectives, changelogs, ADRs, metrics, learning outputs, reviews. These are updated incrementally outside DSBV. |
| 6 | Lessons 1, 2, and the ADR gap in the single-agent run all share the same structural cause: DESIGN.md separates artifacts and conditions into two lists with no mapping. Conditions reference artifacts that don't exist in the deliverable list. | **EOP** — EP-09 (incomplete decomposition) + EP-10 (done not fully defined). The template structure itself caused the gap. | Unified artifact-condition table in DESIGN.md and context template. Mandatory alignment check at Gate G1: orphan conditions = 0, orphan artifacts = 0, deliverable count matches. Process fix, not outcome fix. |

> **Patterns:** Lessons 1-2 trace to Input (prompt quality). Lesson 3 traces to EOE (tooling). Lesson 4 traces to Agent+EOP (skill compliance). Lesson 5 traces to EOE (hook design). **Lesson 6 is the structural root cause of 1-2:** the template separated artifacts from conditions, violating EP-09 (decompose completely) and EP-10 (define done fully). Fix: unified table + mandatory alignment check.

---

## References

| Artifact | Path |
|----------|------|
| DSBV Skill | `.claude/skills/dsbv/SKILL.md` |
| DSBV Rule | `.claude/rules/dsbv.md` |
| Context Template | `_shared/templates/DSBV_CONTEXT_TEMPLATE.md` |
| Evaluation Template | `_shared/templates/DSBV_EVAL_TEMPLATE.md` |
| Zone-Boundary Gate | `scripts/dsbv-gate.sh` |
| Design-Phase Guard | `scripts/dsbv-skill-guard.sh` |
| ALIGN Retrospective | `4-IMPROVE/retrospectives/DSBV_ALIGN_RETRO.md` |

---

**Source:** ADR-001 (Competing Hypotheses + Synthesis), DSBV Best Practices Report (2026-03-26, 42 sources)
**Governed by:** 7-CS Agent System, 8 LLM Truths, EP-01 through EP-10
