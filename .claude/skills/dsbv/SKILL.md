---
name: dsbv
description: "Run the DSBV sub-process (Design → Sequence → Build → Validate) within any APEI zone. Guides L2-L4 users through structured artifact production with human gates, readiness checks, and multi-agent Build support."
---

# /dsbv — Design, Sequence, Build, Validate

Run the 4-phase DSBV process to produce a zone's artifacts. Every zone (ALIGN, PLAN, EXECUTE, IMPROVE) uses this same workflow. DSBV defines HOW you produce work; the zone defines WHAT you produce.

## Sub-Commands

| Command | What it does |
|---|---|
| `/dsbv` | Full guided flow — all 4 phases with human gates between each |
| `/dsbv design [zone]` | Design phase only — define what the zone must produce and why |
| `/dsbv sequence [zone]` | Sequence phase only — order the work, size tasks, map dependencies |
| `/dsbv build [zone]` | Build phase only — execute the approved sequence |
| `/dsbv validate [zone]` | Validate phase only — verify zone output enables the next zone |
| `/dsbv status` | Show current DSBV state: which zone, which phase, what is done |

If `[zone]` is omitted, ask the user which zone (ALIGN, PLAN, EXECUTE, IMPROVE).

<HARD-GATE>
1. Cannot start Sequence without an approved DESIGN.md.
2. Cannot start Build without an approved SEQUENCE.md.
3. Cannot mark a zone complete without Validate passing.
4. Multi-agent Build requires explicit human approval before launching (show cost estimate first).
5. Running a single-phase sub-command (e.g., `/dsbv build`) on a zone that lacks the prerequisite artifact is an error — tell the user what is missing and how to produce it.
</HARD-GATE>

## Meta-Rules (re-injected — compensates for LT-2 context degradation)

These are always in effect. They override any conflicting behavior:

1. **MODEL AS SYSTEM:** Before any phase, identify the 7-CS components in play (EP, Input, EOP, EOE, EOT, Agent, EA). If a component is missing or misconfigured, flag it.
   (Source: agent-system.md §5)

2. **UBS BEFORE UDS:** What blocks this zone? Answer BEFORE asking what drives it. Identify risks, dependencies, and constraints first.
   (Source: general-system.md §5 — Force Analysis)

3. **SUSTAINABILITY FIRST:** Risk-mitigated > efficient > scalable. A fragile fast artifact is worse than a slow reliable one.
   (Source: general-system.md §6 — S > E > Sc priority)

4. **VANA DECOMPOSE:** Every requirement = Verb + Adverb + Noun + Adjective. If you cannot decompose it, you do not understand it.
   (Source: general-system.md §8 — ESD Phase 3)

5. **DEFINE DONE:** Every acceptance criterion must be binary, deterministic, testable. "Good quality" is not an AC. "All DESIGN.md artifacts have a success rubric with ≥1 binary criterion" is.
   (Source: general-system.md §7 — Layer 3 Eval Spec)

## Readiness Check (C1-C6)

Before ANY phase, verify these conditions. If any is RED, tell the user what is missing and how to fix it. Do not proceed until all are GREEN.

| ID | Condition | How to check |
|----|-----------|--------------|
| C1 | **Clear scope** | Zone identified. In-scope and out-of-scope are written down. |
| C2 | **Input materials curated** | Reading list assembled — prior zone output, reference docs, research. No "go find it yourself." |
| C3 | **Success rubric defined** | Per-artifact criteria exist, not vibes. |
| C4 | **Process definition loaded** | `_shared/templates/DSBV_PROCESS.md` is in context. |
| C5 | **Prompt engineered** | Context fits within effective window. Irrelevant material removed. |
| C6 | **Evaluation protocol defined** | How outputs will be compared (multi-agent) or reviewed (single-agent). |

Report readiness as a table: `C1: GREEN | C2: RED — missing prior zone output | ...`

## Phase 1: DESIGN

**What this does:** Defines WHAT the zone must produce and WHY — before any work begins. This is the contract. If it is not in DESIGN.md, it is not in scope.

**Why it matters:** Skipping Design is the #1 cause of wasted work. An hour of Design saves days of rework (Principle 1: Brake Before Gas).

**Steps:**
1. Ask the user for their high-level intent (1-3 sentences about what this zone should accomplish)
2. Load `_shared/templates/DSBV_CONTEXT_TEMPLATE.md` as the Design template
3. Draft DESIGN.md: artifact inventory, per-artifact purpose, success rubric, acceptance criteria
4. **Alignment check (mandatory before presenting):**
   - For every completion condition: which artifact satisfies it? Write the mapping.
   - If any condition has no artifact → add the missing artifact to the list.
   - If any artifact has no condition → either add a condition or justify its exclusion.
   - Present the alignment table to the user as part of DESIGN.md.
5. Present DESIGN.md to the user for review

**Output:** `{zone-number}-{ZONE}/DESIGN.md` (e.g., `1-ALIGN/DESIGN.md`)

**Gate G1:** "I have completed the Design phase. Here is what I produced: [artifact list with summary]. Alignment check: [N conditions, N artifacts, 0 orphans]. Ready to proceed to Sequence?"
Wait for explicit human approval. If the user requests changes, revise and re-present.

## Phase 2: SEQUENCE

**What this does:** Orders the work — what depends on what, what gets built first, how large each task is. This prevents the agent from jumping around or attempting work whose inputs do not exist yet.

**Why it matters:** Without sequencing, agents attempt tasks in arbitrary order and fail on dependencies (LT-3: reasoning degrades on complex tasks). Explicit ordering compensates.

**Steps:**
1. Read the approved DESIGN.md
2. Identify artifact dependencies (what must exist before what)
3. Decompose into tasks — start coarse, decompose further only if a task exceeds ~1 hour human-equivalent effort
4. Size each task, assign acceptance criteria
5. Present SEQUENCE.md to the user

**Output:** `{zone-number}-{ZONE}/SEQUENCE.md`

**Gate G2:** "I have completed the Sequence phase. Here is the task order: [numbered list with sizes]. Ready to proceed to Build?"

## Phase 3: BUILD

**What this does:** Executes the work following the approved sequence. Each task is completed, self-verified against its acceptance criteria, and committed before moving to the next.

**Why it matters:** This is where artifacts are actually produced. The pattern varies by zone type to balance quality with cost.

**Zone-aware behavior:**

| Zone type | Default pattern | Why |
|---|---|---|
| Design-heavy (ALIGN, PLAN) | Competing Hypotheses + Synthesis: 3 Sonnet agents produce parallel drafts, 1 Opus synthesizes | Open-ended work benefits from diverse perspectives. Missing a risk in ALIGN has high blast radius. |
| Execution-heavy (EXECUTE, IMPROVE) | Single agent, sequential tasks | Output is more deterministic — diversity adds cost, not quality. |

**Model configuration (user-overridable):**
- Default teams: Sonnet for breadth, Opus for synthesis, current model for other phases
- Override: `/dsbv build align --model opus --teams 3`
- Cost guidance shown before multi-agent launch:
  ```
  Multi-agent Build: ~3 Sonnet runs ($5-8) + 1 Opus synthesis ($2-5) = ~$10-13
  Single-agent Build: ~1 Opus run ($3-5)
  Proceed with multi-agent? [y/n]
  ```

**Steps (single-agent):**
1. For each task in SEQUENCE.md in order:
   a. Implement the artifact
   b. Self-verify against task acceptance criteria
   c. Checkpoint commit
2. When all tasks complete, report status

**Steps (multi-agent):**
1. Show cost estimate. Wait for human approval.
2. Launch N agents in parallel, each producing a complete draft for the task set
3. Opus synthesizes: selects best elements from each draft, resolves conflicts
4. Present synthesis to the user
5. Checkpoint commit

**Gate G3:** "Build is complete. All tasks in SEQUENCE.md are done. Here is what was produced: [file list]. Ready to proceed to Validate?"

## Phase 4: VALIDATE

**What this does:** Verifies that the zone's output is complete, correct, coherent, and enables the next zone to start. This is the quality gate before a zone is marked done.

**Why it matters:** Without validation, errors compound across zones. A flawed ALIGN produces a flawed PLAN produces a flawed EXECUTE (LT-3: errors cascade through reasoning chains).

**Steps:**
1. Load `_shared/templates/DSBV_EVAL_TEMPLATE.md` as the evaluation template
2. Check **Completeness** — all artifacts listed in DESIGN.md are present
3. Check **Quality** — each artifact passes its success rubric
4. Check **Coherence** — artifacts do not contradict each other
5. Check **Downstream readiness** — the next zone can start with these outputs
6. Produce a validation report: pass/fail per criterion

**Output:** `{zone-number}-{ZONE}/VALIDATE.md` — validation report with pass/fail per criterion

**Gate G4:** "Validation complete. Results: [pass/fail summary]. [If all pass:] Ready to mark this zone as complete? [If any fail:] These items need attention: [list]. Want to fix them now?"

## Status Command

`/dsbv status` outputs a table:

```
DSBV Status — [Zone Name]
┌───────────┬────────────┬───────────────────────────┐
│ Phase     │ Status     │ Artifact                  │
├───────────┼────────────┼───────────────────────────┤
│ Design    │ Approved   │ 1-ALIGN/DESIGN.md         │
│ Sequence  │ Approved   │ 1-ALIGN/SEQUENCE.md       │
│ Build     │ In Progress│ 3/7 tasks complete        │
│ Validate  │ Not Started│ —                         │
└───────────┴────────────┴───────────────────────────┘
```

Status is derived from file existence and content — not stored separately.

## If the User Seems Lost

When the user expresses confusion or asks "what should I do next?":
1. Run `/dsbv status` to show where they are
2. Explain the current phase in 2-3 plain sentences
3. Suggest the specific next action: "You are in the Design phase for ALIGN. The next step is to tell me what you want ALIGN to accomplish in 1-3 sentences, and I will draft the DESIGN.md for your review."

## Process Reference

Full process specification: `_shared/templates/DSBV_PROCESS.md`
