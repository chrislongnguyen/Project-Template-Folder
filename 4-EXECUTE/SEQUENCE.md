---
version: "1.0"
status: Draft
last_updated: 2026-04-02
workstream: EXECUTE
iteration: "{{ITERATION}}"
owner: "{{OWNER}}"
---

# DSBV Context Package — EXECUTE Workstream

> Input context for agents running DSBV Build phase on Workstream EXECUTE.
> Budget: ~4000 words. Every token costs signal-to-noise ratio.
> Bookend pattern (LT-2): most critical content at start and end, least critical in middle.
> Source template: `_genesis/templates/DSBV_CONTEXT_TEMPLATE.md`

---

## Section 1: Project Identity

> WHO, WHAT, WHY — copy from charter. Agents need project grounding to avoid hallucinating scope (LT-1).

### What

<!-- Fill in project-specific content -->
<!-- TODO: 1-2 paragraphs — what the project IS and IS NOT. Include system boundary — in scope vs out of scope. -->

### Who

| Role | Person | RACI | Function |
|------|--------|------|----------|
| Director | <!-- name --> | **A** | Owns outcome, approves designs |
| Builder | <!-- name --> | **R** | Designs and builds artifacts |
| Stakeholders | <!-- names --> | **I/C** | <!-- their relationship to the project --> |

### Purpose

<!-- Fill in project-specific content -->
<!-- TODO: WHY this project exists. EO in one sentence: "[User] achieves [desired state] without [constraint]." -->

---

## Section 2: Key Decisions Already Made

> Settled constraints — agents MUST respect these, do not re-litigate.

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | <!-- TODO: Decision statement --> | <!-- TODO: Why this was chosen --> |
| D2 | <!-- TODO: Decision statement --> | <!-- TODO: Why this was chosen --> |

---

## Section 3: What This Workstream Must Produce

> The CONTRACT. CRITICAL: every artifact here MUST appear as a deliverable in Section 6.
> If Section 3 lists 6 artifacts and Section 6 lists 5 deliverables, agents will skip one.

### Required Artifacts + Completion Conditions (unified)

> STRUCTURAL RULE: Every condition MUST map to an artifact. Every artifact MUST
> have at least one condition. If a condition has no artifact, ADD the artifact.
> If an artifact has no condition, ADD a condition or justify removal.
> This table IS the contract. Separate lists = gap = missed deliverables.

| # | Artifact | File Path | Key Content | Condition | Binary Test |
|---|----------|-----------|-------------|-----------|-------------|
| A1 | <!-- TODO: Name --> | <!-- TODO: path --> | <!-- TODO: Content --> | C1: <!-- TODO: What must be true --> | <!-- TODO: PASS/FAIL test --> |
| A2 | <!-- TODO: Name --> | <!-- TODO: path --> | <!-- TODO: Content --> | C2: <!-- TODO: What must be true --> | <!-- TODO: PASS/FAIL test --> |

<!-- EXECUTE examples: Source→code, Tests→coverage, Config→deploy, Docs→API -->

**Alignment check (do this BEFORE presenting DESIGN.md):**
- Count conditions with no artifact → must be 0
- Count artifacts with no condition → must be 0 or justified
- Count conditions → count deliverables in Section 6 → must match

---

## Section 4: Domain Context

> Include ONLY what agents need for THIS workstream. Every irrelevant paragraph degrades signal (LT-7).
> Execution-heavy workstreams: architecture decisions, API specs, test strategies.

### Prior Workstream Output

<!-- Fill in project-specific content -->
<!-- TODO: Key outputs from PLAN workstream that constrain or inform this workstream's work. -->

### Team Context

<!-- Fill in project-specific content -->
<!-- TODO: Relevant quotes, debate resolutions, strategic direction. Include reasoning, not just conclusions. -->

### Reference Materials

<!-- Fill in project-specific content -->
<!-- TODO: Key excerpts from documents, research, specs. Do not paste full documents — respect context budget. -->

---

## Section 5: Agent System Constraints

> Standardized section — same for every context package. Grounds agents in LLM structural limits.

### The 8 LLM Truths

| # | Truth | Summary |
|---|-------|---------|
| LT-1 | Hallucination is structural | P(hallucination) > 0 for any model. Plausible is not true. |
| LT-2 | Context compression is lossy | Effective window << nominal. Middle content gets lost. |
| LT-3 | Reasoning degrades on complex tasks | 3-step works; 12-step breaks. 0.9^7 = 48%. |
| LT-4 | Retrieval is fragile under noise | Model grabs "close enough" instead of exact fact. |
| LT-5 | Prediction optimizes plausibility | Trained for "sounds right," not "is right." |
| LT-6 | No persistent memory | Every session starts blank. |
| LT-7 | Cost scales with tokens | More words = more money, worse LT-2. |
| LT-8 | Alignment is approximate | Can drift, game criteria, find loopholes. |

### 7-CS and Two Operators

`EO = f(EP, Input, EOP, EOE, EOT, Agent, EA)` — Human Director = Accountable (not a component).
**Human** fails via System 1 (anchoring, confirmation bias). **Agent** fails via 8 LTs (hallucination, context loss). Each compensates for the other's blind spots.

---

## Section 6: Agent Instructions

> Bookend closer (LT-2) — agents recall start and end best.
> CRITICAL: deliverables MUST be 1:1 with Section 3 artifacts. Count them. No exceptions.

### Your Role

<!-- Fill in project-specific content -->
<!-- TODO: Single-agent or multi-agent role description. For EXECUTE (execution-heavy), typically single-agent: "You are the sole agent producing the EXECUTE artifacts. Output will be validated against the rubric by the Human Director." -->

### Your Deliverables

<!-- Fill in project-specific content — must match Section 3 artifact count exactly -->
1. **<!-- TODO: Artifact A1 -->** — <!-- TODO: What to produce and key quality criteria -->
2. **<!-- TODO: Artifact A2 -->** — <!-- TODO: What to produce and key quality criteria -->

### What to Optimize For

- <!-- TODO: Primary — what makes EXECUTE workstream output valuable, e.g. correctness, test coverage -->
- <!-- TODO: Secondary — e.g., "minimize coupling", "maximize test coverage" -->
- <!-- TODO: Specificity — "vague outputs will be discarded during synthesis" -->

### Constraints

- <!-- TODO: Hard constraints — what agents must NOT do -->
- <!-- TODO: Scope boundaries — what belongs to other workstreams -->
- Sustainability > Efficiency > Scalability in all prioritization
- Do NOT propose changes to the 7-CS or 8 LLM Truths
- All outputs must use the formats specified in Section 3

---

**Classification:** INTERNAL
