---
version: "1.2"
iteration: 1
iteration_name: concept
status: draft
last_updated: 2026-04-10
owner: ""
type: template
work_stream: 0-GOVERN
stage: design
sub_system: 
---
# DSBV Context Package — [WORKSTREAM NAME]

> **WORKSTREAM-LEVEL context package** — fill this ONCE per DSBV cycle to ground all agents working on
> Workstream [N]. It captures project identity, settled decisions, and the artifact contract.
>
> **This is NOT the per-dispatch Agent() context.** For each individual Agent() call, use the
> per-dispatch template at `.claude/skills/dsbv/references/context-packaging.md`. That template
> covers EO, INPUT (Context + Files + Budget), EP, OUTPUT, and VERIFY for a single task invocation.
> This file feeds the "Context" sub-section of that template.
>
> Budget: ~4000 words. Every token costs signal-to-noise ratio.
> Bookend pattern (LT-2): most critical content at start and end, least critical in middle.

---

## Section 1: Project Identity

> WHO, WHAT, WHY — copy from charter. Agents need project grounding to avoid hallucinating scope (LT-1).

### What

[1-2 paragraphs: what the project IS and IS NOT. Include system boundary — in scope vs out of scope.]

### Who

| Role | Person | RACI | Function |
|------|--------|------|----------|
| [Director] | [Name] | **A** | Owns outcome, approves designs |
| [Builder] | [Name] | **R** | Designs and builds artifacts |
| [Stakeholders] | [Names] | **I/C** | [Their relationship to the project] |

### Purpose

[WHY this project exists. EO in one sentence: "[User] achieves [desired state] without [constraint]."]

---

## Section 2: Key Decisions Already Made

> Settled constraints — agents MUST respect these, do not re-litigate.

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | [Decision statement] | [Why this was chosen] |
| D2 | [Decision statement] | [Why this was chosen] |

### Reference Materials

[Key excerpts from documents, research, specs. Do not paste full documents — respect context budget.]

### Budget

> Token/scope boundary for agents working this workstream. Copy to the `### Budget` sub-section of
> each per-dispatch context package. Adjust token estimate per task; adjust max_tool_calls per agent.

~4000 words (~8K tokens) for this workstream context package. Agents load only what THIS task needs.

**Default max_tool_calls by agent** — override per dispatch when task is known tool-heavy or tool-light:

| Agent | Default max_tool_calls | Rationale |
|-------|----------------------|-----------|
| ltc-builder | 50 | Read + Write + Edit + Grep + Bash for artifact production |
| ltc-reviewer | 30 | Read + Glob + Grep + Bash for evidence gathering |
| ltc-explorer | 20 | Read-only exploration; should be focused and fast |
| ltc-planner | 40 | Read + design synthesis; moderate tool usage |

Enforcement: agent self-tracks tool call count. At 80% of budget, prioritize remaining work and report
partial completion rather than exceeding budget silently.

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
| A1 | [Name] | [path] | [Content] | C1: [What must be true] | [PASS/FAIL test] |
| A2 | [Name] | [path] | [Content] | C2: [What must be true] | [PASS/FAIL test] |
| A2 | | | | C3: [Second condition for same artifact] | [PASS/FAIL test] |

[Workstream examples — ALIGN: Charter→EO+scope+RACI, Stakeholders→personas+anti-persona, Requirements→VANA+ACs, OKRs→formulas+pillars, Force Analysis→UBS+UDS, ADRs→D1-D10 decisions | PLAN: Architecture→components+interfaces, Roadmap→milestones, Registers→risks+drivers | EXECUTE: Source→code, Tests→coverage, Config→deploy, Docs→API | IMPROVE: Changelog→versions, Retro→lessons, Metrics→KRs]

**Alignment check (do this BEFORE presenting DESIGN.md):**
- Count conditions with no artifact → must be 0
- Count artifacts with no condition → must be 0 or justified
- Count conditions → count deliverables in Section 6 → must match

---

## Section 4: Domain Context

> Include ONLY what agents need for THIS workstream. Every irrelevant paragraph degrades signal (LT-7).
> Design-heavy workstreams: team quotes, strategic reasoning, debate resolutions.
> Execution-heavy workstreams: architecture decisions, API specs, test strategies.

### Prior Workstream Output

[Key outputs from preceding workstream(s) that constrain or inform this workstream's work.]

### Team Context

[Relevant quotes, debate resolutions, strategic direction. Include reasoning, not just conclusions.]

---

## Section 5: Agent System Constraints

> Standardized section — same for every context package. Grounds agents in LLM structural limits.
> Load the full 8 LLM Truths and 7-CS framework from `rules/agent-system.md`.

Key truths for this workstream:

| # | Truth | Impact here |
|---|-------|-------------|
| LT-1 | Hallucination is structural | Require file-path evidence for every claim; no assertion without source |
| LT-2 | Context compression is lossy | Place critical content at start and end of this package (bookend pattern) |
| LT-7 | Cost scales with tokens | Every irrelevant paragraph degrades signal — load only what THIS task needs |

All other LT apply; see `rules/agent-system.md` for the full table before designing any system component.

### 7-CS and Two Operators

`EO = f(EP, Input, EOP, EOE, EOT, Agent, EA)` — Human Director = Accountable (not a component).
**Human** fails via System 1 (anchoring, confirmation bias). **Agent** fails via 8 LTs (hallucination, context loss). Each compensates for the other's blind spots.

### EP Task-Type Filtering

Not all EPs apply to every task. Listing all 10+ EPs wastes tokens and dilutes focus. Use this table
to select the 2-3 most relevant EPs per Agent() dispatch. Include at most 4 EPs per context package —
if more are needed, the task is too broad and should be decomposed (EP-09).

| Task Type | Applicable EPs | Why These |
|-----------|---------------|-----------|
| Research | EP-01 (Brake Before Gas), EP-04 (Signal Over Volume), EP-08 (Economy) | Caution (EP-01), focused scope (EP-04), token efficiency (EP-08) |
| Design | EP-01 (Brake Before Gas), EP-05 (Gates Before Guides), EP-09 (Decompose), EP-10 (Define Done) | Caution (EP-01), deterministic gates (EP-05), decomposition (EP-09), testable criteria (EP-10) |
| Build | EP-01 (Brake Before Gas), EP-05 (Gates Before Guides), EP-10 (Define Done), EP-14 (Script-First) | Stop-on-block (EP-01), routing boundaries (EP-05), AC verification (EP-10), script validation (EP-14) |
| Validate | EP-01 (Brake Before Gas), EP-10 (Define Done), EP-12 (Evidence-Based) | Caution (EP-01), criterion matching (EP-10), file-path evidence (EP-12) |

Full EP registry: `_genesis/reference/ltc-effective-agent-principles-registry.md`

---

## Section 6: Agent Instructions

> Bookend closer (LT-2) — agents recall start and end best.
> CRITICAL: deliverables MUST be 1:1 with Section 3 artifacts. Count them. No exceptions.

### Your Role

[Multi-agent: "You are one of N agents, each independently producing a complete [WORKSTREAM] package. Outputs will be synthesized by an Opus agent using Competing Hypotheses."]

[Single-agent: "You are the sole agent producing the [WORKSTREAM] artifacts. Output will be validated against the rubric by the Human Director."]

### Your Deliverables

1. **[Artifact A1]** — [What to produce and key quality criteria]
2. **[Artifact A2]** — [What to produce and key quality criteria]

### What to Optimize For

- [Primary: what makes THIS workstream's output valuable]
- [Secondary: e.g., "find non-obvious risks" for ALIGN, "minimize coupling" for PLAN]
- [Specificity: "vague outputs will be discarded during synthesis"]

### Constraints

- [Hard constraints — what agents must NOT do]
- [Scope boundaries — what belongs to other workstreams]
- Sustainability > Efficiency > Scalability in all prioritization
- Do NOT propose changes to the 7-CS or 8 LLM Truths
- All outputs must use the formats specified in Section 3

---

**Classification:** INTERNAL

## Links

- [[AGENTS]]
- [[CHANGELOG]]
- [[DESIGN]]
- [[agent-system]]
- [[architecture]]
- [[charter]]
- [[context-packaging]]
- [[deliverable]]
- [[iteration]]
- [[project]]
- [[roadmap]]
- [[workstream]]
