# Design Spec: LTC Effective System Rules for Project Template

**Date:** 2026-03-18
**Status:** Approved
**ClickUp:** OPS_-4216 — LTC Effective System
**Target repo:** OPS_OE.6.4.LTC-PROJECT-TEMPLATE

---

## 1. Problem Statement

The LTC project template (`OPS_OE.6.4.LTC-PROJECT-TEMPLATE`) provides every new LTC repo with canonical rules for branding, naming, and security. But it contains zero guidance on:

1. **How the AI agent works and fails** — members don't know the 8 structural limits of their agent or how the 7-Component System compensates for them.
2. **How to design and build any system** — members don't have the universal system model, force analysis framework, or ESD methodology available as a reference when building UE products or other systems.
3. **How to diagnose failures** — when the agent produces bad output, members blame the model instead of tracing to the responsible component.

These are canonical, durable truths — they don't change between projects or over time. They belong in every repo as foundational guidance.

---

## 2. Desired Outcome

LTC members at all levels have access to distilled, actionable reference docs that they load by choice when:

- **Configuring their AI agent** (CLAUDE.md, .cursorrules, GEMINI.md, skills, tools, environment)
- **Building any system or product** (UE systems, OE processes, workflows, agent teams)
- **Diagnosing agent failures** (tracing bad output to the responsible component)

---

## 3. Deliverables

### 3.1 `rules/agent-system.md` (~300 lines)

**Purpose:** Canonical reference for configuring an AI agent's 7-Component System.
**When loaded:** By choice, when configuring or understanding the agent.
**Primary sources:** Session 0 Training Doc (Notion, v2.4), Session 1 Wiki (Notion, v3), Doc-9 (research/amt).

**Structure:**

#### Section 1: Notation (~20 lines)
Placed first so all abbreviations are defined before use. Abbreviation table: 7-CS, EPS, EOP, UBS, UDS, LT-N, UT#N, RACI, VANA, A.C.

*Rationale: L2 practitioners encounter abbreviations throughout the doc. Defining them upfront prevents confusion on first read.*

#### Section 2: Purpose & Three Principles (~40 lines)
- What this doc is and when to load it
- Principle 1: Brake Before Gas [DERISK] — derisk first, drive output second
- Principle 2: Know the Physics [DERISK] — 8 LLM Truths are structural, not bugs
- Principle 3: Two Operators, One System [OUTPUT] — Human Director + Agent = complementary
- The system formula: `Effective Outcome = f(EPS, Input, EOP, Environment, Tools, Agent, Action)`
- For level-specific guidance on applying these principles, see Doc-9 §4.4 (SFIA progression L1-L5).

#### Section 3: The 8 LLM Fundamental Truths (~80 lines)
Per-truth entry: `# | Name | Bottleneck | Plain language | Mechanism | Compensated by`

| # | Name | Bottleneck |
|---|---|---|
| LT-1 | Hallucination is structural | Factual accuracy |
| LT-2 | Context compression is lossy | Volume of info loaded |
| LT-3 | Reasoning degrades on complex tasks | Number of logical steps |
| LT-4 | Retrieval is fragile under token limits | Precision in noisy context |
| LT-5 | Prediction optimises plausibility, not truth | Truth vs sounding right |
| LT-6 | No persistent memory across sessions | Memory between sessions |
| LT-7 | Cost scales with token count | Budget |
| LT-8 | Alignment is approximate | Rule compliance under pressure |

Keeps bottleneck labels (volume/steps/precision distinction for LT-2/3/4).
Includes mechanism column and "Compensated by" mapping to components.
Followed by quick-reference summary table.

**Dropped:** Strategy Brief examples (training context), citations (available in Doc-9).

#### Section 4: The Two Operators (~50 lines)
- **Human Director (Accountable):**
  - System 1 UBS: 6 biases (Availability, Representativeness, Anchoring, Affect, Confirmation, Self-Serving Attribution) with mechanisms and design threats
  - System 2 UDS: Domain expertise, strategic judgment, risk intuition, ethical oversight, creative direction
- **LLM Agent (Responsible):**
  - 8 LTs (back-reference to §3)
  - Architectural strengths: orchestrated parallelism, exhaustive analysis, no ego, high recall, programmatic enforcement, consistent instruction following
- **Shared forces:**
  - Compute-Efficient Forces (Agent) ↔ Bio-Efficient Forces (Human) — both default to shortcuts under pressure
  - Orchestration System Belief (Agent) ↔ Support System Belief (Human) — both perform better in structured frameworks

#### Section 5: The 7-Component System (~100 lines)
- **Dependency graph** (ASCII art from Doc-9 §3.0)
- **Summary table:** `# | Component | One-liner | Concrete AI Examples | Priority`

| # | Component | Priority |
|---|---|---|
| 1 | EPS — Persistent rules, always active | #1 |
| 2 | Input — Task-specific context | #2 |
| 3 | EOP — Step-by-step procedures, on demand | #3 |
| 4 | Environment — Workspace config, permissions, limits | #4 |
| 5 | Tools — MCP servers, APIs, CLI, search | #5 |
| 6 | Agent — The AI model itself | #6 |
| 7 | Action — Observable execution (emergent, diagnose only) | #7 |

- **Per-component cards** (EPS → Input → EOP → Environment → Tools → Agent → Action):
  - Definition (1 line)
  - System role (1 line)
  - Compensates for: LT-N references
  - Guards against: Human bias references
  - Derisk (bullet list — what can go wrong)
  - Drive output (bullet list — how to maximize value)

- **EPS component card additional note:** When configuring EPS, use the Always/Ask/Never pattern to define behavioral boundaries: what the agent always does (safe actions, no approval needed), what requires Human Director approval (high-impact actions), and what is prohibited (hard stops, violation = immediate halt). See spec-gap-analysis G4 for the full pattern.

**What's dropped from sources:** Kitchen Analogy, SFIA Mastery Ladder (see Doc-9 §4.4 for level guidance), Strategy Brief examples, "Map Anything New" table (redundant — component definitions are sufficient), citations/citation index, research questions, research directives, loading protocol, epistemic tags, practice paths, changelog.

---

### 3.2 `rules/general-system.md` (~310 lines)

**Purpose:** Canonical reference for designing and building any system — UE products, OE processes, workflows, agent teams.
**When loaded:** By choice, when designing or building a system.
**Primary sources:** ESD Framework (templates/effective-system-design.md), 10 Ultimate Truths (BOOK-00), Whiteboard template (ClickUp), Spec-Gap-Analysis (LEARN-BUILD-ENGINE/research/).

**Structure:**

#### Section 1: Notation (~15 lines)
Placed first so all abbreviations are defined before use. Abbreviation table: UT#N, UDO, UBS, UDS, EPS, EOP, UES, ESD, ELF, VANA, RACI, A.C., MECE, OE, UE.

#### Section 2: Purpose & Foundation (~30 lines)
- What this doc is and when to load it
- UT#1: Every system has the same 6 components → Outcome
- The formula: `Outcome = f(Input, User, Action, Principles, Tools, Environment)`
- Derisk-first principle applied to systems
- Relationship to `agent-system.md` (see agent-system.md §5): the 7-CS is a specialization where User→Agent, Principles→EPS+EOP, Action separates from process design

#### Section 3: The Universal System Model (~40 lines)
- 6 components defined: Input, User/Doer, Action, Principles, Tools, Environment
- Each with: Definition | Role in system | What happens when missing
- Output vs Outcome distinction
- System vs Workstream (a workstream is a system running concurrently within a parent)

#### Section 4: RACI — Who Does What (~25 lines)
- Establish R (Responsible) and A (Accountable) BEFORE analyzing forces
- Same system has different blockers depending on who is R vs A
- When R = AI Agent: behavioral boundaries (Always/Ask/Never) become part of the RACI contract — what the Agent always does, what requires Human Director approval, what is prohibited
- Per-step RACI refines system-level RACI in EOP
- UBS/UDS analysis must cover both: UBS(R), UBS(A), UDS(R), UDS(A)

#### Section 5: Force Analysis — UBS then UDS (~50 lines)

*UBS is analyzed first because derisk always precedes driving output (Principle 1 from agent-system.md §2). This inverts the ESD framework's section ordering (ESD §3.3 UDS before §3.4 UBS) but aligns with the operating principle that governs all LTC system design.*

- UT#2: Every system has forces blocking it (UBS) and driving it (UDS)
- **UBS first (derisk):**
  - Role-aware: UBS(R), UBS(A)
  - Recursive notation: UBS.UB (what strengthens the blocker), UBS.UD (what weakens the blocker)
- **UDS second (drive output):**
  - Role-aware: UDS(R), UDS(A)
  - Recursive notation: UDS.UD (what strengthens the driver), UDS.UB (what weakens the driver)
- Why both sides have internal contradictions
- Derisk first: disable UBS before amplifying UDS

#### Section 6: Effective Principles & Standards (~30 lines)
- Principles exist to disable specific UBS or enable specific UDS
- Every principle must trace to a force — if it can't be traced, it's noise
- Role-tagged: P[n](S)(R) constrains the doer, P[n](S)(A) constrains the owner
- Three pillars: Sustainability (S) — correct/safe operation; Efficiency (E) — fast/lean operation; Scalability (Sc) — repeatable/growth-capable operation
- Priority hierarchy when principles conflict

#### Section 7: System Boundaries — Input & Output (~60 lines)
Progressive disclosure — 4 layers, one section:

**Minimum Viable Boundary (design time):**

Layer 1 — What Flows: 5 categories that flow through ANY system:
1. Acceptance Criteria (Sustainability, Efficiency, Scalability)
2. Signal / Data / Information
3. Physical Resources
4. Human Resources
5. Financial Resources

Layer 2 — How It Flows Reliably: 6 contract fields per boundary:
| Field | Purpose |
|---|---|
| Source / Consumer | Who sends / who receives |
| Schema | Data shape both sides agree on |
| Validation | Rules the payload must satisfy |
| Error | Behavior when contract is violated |
| SLA | Availability and latency expectations |
| Version | Breaking changes require notification |

Integration chain: `SYS-A OUTPUT → SYS-B INPUT → SYS-B OUTPUT → SYS-C INPUT`

**Pre-Build Boundary (prerequisites complete before build starts):**

Layer 3 — How You Verify: Eval Spec per A.C.
- Every Acceptance Criterion must have an Eval Spec before building starts
- Three eval types:
  - **Deterministic** — script that returns pass/fail (schema validation, data format checks)
  - **Manual** — Human Director reviews with rubric (subjective quality, strategic judgment)
  - **AI-Graded** — second LLM evaluates against rubric (natural language quality at scale)
- Each AC requires: Type + Dataset + Grader + Threshold
- Critical sequence: Write AC → Write Eval Spec → Build Dataset → Implement Grader → Wire CI → THEN build
- MECE: one test per AC, no gaps, no overlaps

**Production-Ready Boundary (before scaling):**

Layer 4 — How It Fails Gracefully: per EOP step
- Recovery: what happens on failure
- Escalation: who gets notified, when
- Degradation: partial output acceptable? How marked?
- Timeout: max retries, max wall-clock time

#### Section 8: The ESD Methodology (~40 lines)
- Phase 1 — Problem Discovery: Who is the User? What's their UDO? What blocks them (UBS)? What drives them (UDS)?
- Phase 2 — System Design: Principles (S/E/Sc), Environment, Tools, Desirable Wrapper (early iterations, tests desirability), Effective Core (maturity, tests effectiveness), EOP with per-step RACI
- Phase 3 — User Requirements: VANA grammar (Verb-Adverb-Noun-Adjective) with binary Acceptance Criteria
- The flow: `Learn (ELF) → Design (ESD Phase 1+2) → Requirements (Phase 3) → Build → Test`
- ESD is a design methodology, not a document template. Output documentation uses the System Wiki Template.

#### Section 9: The Value Chain (~20 lines)
- 6-layer corporate structure:
  - L0: Strategic Alignment — direction and priorities
  - L1: People Development — capability to execute
  - L2: Operational Excellence — the systems that build systems (OE)
  - L3: User Enablement — the systems that serve users (UE)
  - L4: Customer Intimacy — retain and grow relationships
  - L5: Financial Performance — measurable outcomes
- OE (L2) builds systems. UE (L3) serves users. Know where your system sits.

**What's dropped from sources:** Full ELF layer details (learning engine's domain), complete ESD glossary (68KB distilled), worked examples (SYS-E1 Scope Management), document control metadata, ESD gap bridging tables, Phase 3 detailed templates.

---

### 3.3 `rules/agent-diagnostic.md` (~150 lines)

**Purpose:** Structured diagnostic framework for tracing agent failures to root components. Designed for both human use and future autonomous diagnostic agents/hooks.
**When loaded:** By choice, when debugging agent failures. Future: loaded automatically by diagnostic hooks.
**Primary sources:** Doc-9 §3.7, Session 0 §4 + §6, Spec-Gap-Analysis G3 + G6.

**Structure:**

#### Section 1: Notation (~10 lines)
Placed first. Subset of agent-system.md notation: 7-CS, EPS, EOP, LT-N, UBS, UDS.

#### Section 2: Purpose (~10 lines)
- What this doc is and when to load it
- Core principle: "When Action fails, the cause is in one of the other 6 components"
- This doc is structured for both human practitioners and automated diagnostic agents

#### Section 3: The Blame Diagnostic (~20 lines)
- Sequential walkthrough — check in this order:
  1. EPS — Did the rules cover this case?
  2. Input — Was context complete and unambiguous?
  3. EOP — Was the procedure appropriate and well-scoped?
  4. Environment — Was context window sufficient? Permissions correct?
  5. Tools — Were right tools available and returning good data?
  6. Agent — Only after 1-5: is the model genuinely underpowered?
- Platform-specific trace points:
  - Claude Code: tool call log, file reads (Input), rules applied (EPS), skill triggered (EOP)
  - Cursor: .cursorrules loading, @ mention context
  - Gemini: workspace rules, session context

#### Section 4: Symptom → Root Component Table (~30 lines)
Machine-parseable diagnostic table:

| Symptom | Likely Root Component | Check First |
|---|---|---|
| Agent states incorrect facts confidently | EPS (missing validation rules) or Tools (no fact-checking) or Input (no source material) | Does EPS require citations? Are verification tools available? |
| Agent loses track of instructions mid-task | EPS (too verbose, consumes context) or Environment (insufficient context budget) | Count EPS token footprint. Check context utilization. |
| Agent completes the wrong task | Input (ambiguous requirements) or EOP (wrong procedure loaded) | Was scope explicit? Was the right skill triggered? |
| Agent reasoning is shallow or circular | EOP (steps too large) or Agent (underpowered) or Environment (insufficient compute) | Are steps decomposed? Is extended thinking enabled? |
| Agent uses wrong tool or misinterprets output | Tools (too many, unclear purpose) or EOP (no tool selection guidance) | How many tools loaded? Does EOP specify which to use? |
| Output is correct but Director rejects it | Human UBS — Director's biases overriding evaluation | Run Force Map (§6). Is System 1 dominant? |
| Rushed delegation, compound errors | Derisk step skipped | Run Derisk Checklist (§5) before re-delegating |
| Inconsistent behavior across sessions | EPS missing or too thin; LT-6 (no memory) | Is CLAUDE.md loaded? Does it cover this case? |

*Future iteration may convert this table to a structured data format (YAML/JSON) for automated consumption. The Markdown table serves as the human-readable v1.*

#### Section 5: The Derisk Checklist (~15 lines)
Pre-delegation gate (30 seconds):
- List what can go wrong with this task
- Format: `Risk → Which LT → Which component should compensate → Is it configured?`
- If any component is unconfigured for a known risk → configure before delegating

#### Section 6: The Force Map (~15 lines)
Which operator's UBS is active right now?
- Human under time pressure / fatigue / emotional investment → System 1 dominant → delegate analysis to Agent (it doesn't get tired or defensive)
- Decision requires values, ethics, strategic judgment, domain expertise → System 2 needed → don't delegate, use Agent for data gathering only

#### Section 7: Automated Diagnostic Integration Points (~30 lines)

> **FUTURE — not yet implemented.** This section defines the architecture for autonomous diagnostic automation. It serves as a design reference for future implementation.

Where future diagnostic automation can hook in:

**Post-action hooks:**
- Validate output against AC eval spec (see general-system.md §7, Layer 3)
- Check output schema against contract fields (see general-system.md §7, Layer 2)
- Log: action type, component trace, pass/fail, tokens consumed

**Per-step monitoring:**
- Check failure mode triggers (see general-system.md §7, Layer 4)
- Track step duration against SLA
- Flag when context utilization exceeds threshold

**Per-session aggregation:**
- Symptom frequency by component
- Most common failure patterns
- Component health score (% of actions traced to this component as root cause)

**Cross-session intelligence:**
- Trend: is a component degrading over time?
- Correlation: which component combinations produce failures?
- Recommendation: "EPS has been root cause in 40% of failures this week — review rules"

**Future architecture:**
- Autonomous diagnostic agent: hooks into Action observation → traces to component → proposes fix → optionally auto-remediates (with Human Director approval gate)
- Review agent (like Cursor Review): runs post-session, scores component health, flags drift

---

### 3.4 CLAUDE.md Updates (~18 lines added)

Three new sections added to the template CLAUDE.md. Ordering: Agent System → System Design → Agent Diagnostics (foundational references adjacent, diagnostic support tool last).

```markdown
## Agent System (full spec: `rules/agent-system.md`)

Your AI agent has 8 structural limits (LLM Truths) that cannot be patched away.
The 7-Component System compensates: EPS → Input → EOP → Environment → Tools → Agent → Action → Outcome.
Three principles: (1) Derisk before driving output, (2) Know the agent's physics, (3) Human Director + Agent = complementary operators.
When output is wrong: load the diagnostic framework before blaming the model.

## System Design (full spec: `rules/general-system.md`)

Every system has 6 components: Input, User, Action, Principles, Tools, Environment → Outcome.
Establish RACI (R and A) before analyzing forces. UBS/UDS analyzed from both R and A perspectives.
System boundaries have 4 progressive layers: (1) What flows, (2) Contract fields, (3) Eval spec per AC, (4) Failure modes.
Design methodology: Problem Discovery → System Design → VANA Requirements (Verb-Adverb-Noun-Adjective with binary ACs).

## Agent Diagnostics (full spec: `rules/agent-diagnostic.md`)

When agent output is wrong: trace through 6 configurable components (EPS → Input → EOP → Environment → Tools → Agent) before blaming the model.
Derisk checklist: list what can go wrong, map each risk to an LT and component, verify it is configured.
Symptom-to-component lookup table and Force Map available for quick diagnosis.
```

---

## 4. What's NOT in Scope

- **Modifying the source documents** (Doc-9, ESD framework, Session 0/1 wiki pages) — these remain canonical in their repos
- **Building the diagnostic agent/hook** — §7 of agent-diagnostic.md lays the foundation; implementation is a separate task
- **Updating the GEMINI.md template** — follows same pattern as CLAUDE.md but is a separate deliverable
- **Closing spec-gap G1-G6 in the ESD framework** — those are engine-level changes, not template-level
- **"Map Anything New" table** — removed from agent-system.md; the per-component definitions with concrete AI examples are sufficient for classification. The table is a training aid (Session 1), not a canonical truth.

---

## 5. Implementation Approach

**Approach B: Reframe for the Practitioner.** Content is restructured around how a practitioner uses it, not how a researcher investigates it. The universal truths don't change — only the presentation.

**File header convention:** Each new rule file must use the blockquote header format (matching `brand-identity.md` and `naming-rules.md`):

```markdown
# LTC {Title}

> Source of truth: {canonical source location}
> Distilled for agent and practitioner use. Load when {trigger condition}.
> Last synced: {YYYY-MM-DD}

---
```

This standardizes the header across all rule files. (Note: `security-rules.md` uses a different header style with bold metadata — this deviation should be corrected separately to align all existing files.)

**File naming convention:** New files use `agent-system.md`, `general-system.md`, `agent-diagnostic.md` — without the `-rules` suffix used by some existing files (`naming-rules.md`, `security-rules.md`). Rationale: these are reference documents describing truths and models, not prescriptive rules. `brand-identity.md` also omits the `-rules` suffix. Future standardization of existing file names is out of scope for this task.

**Notation placement:** Notation sections are placed FIRST in each doc (before content sections) so that all abbreviations are defined before first use. This is a deliberate deviation from typical reference doc structure (where glossaries appear at the end) to support L2 practitioners encountering the notation system for the first time.

**UBS/UDS ordering:** UBS is analyzed before UDS in all docs. This inverts the ESD framework's section ordering (ESD §3.3 UDS before §3.4 UBS) but aligns with the operating principle that derisk always precedes driving output. The ESD framework's ordering is an artifact of its original ELF-based discovery flow; the practitioner reference follows the operational principle.

**Line count tolerance:** Estimates are +/-15%. Clarity and completeness take priority over hitting exact line targets.

**Cross-reference convention:** Use `(see agent-system.md §N)` format for section references across the three docs, so practitioners and future agents can follow links consistently.

**Source verification warning:** Session 0 Training Doc and Session 1 Wiki are Notion pages that may have been updated since Doc-9 was written. When conflicts arise during implementation, follow the source priority order below. The implementer should have both Notion pages and Doc-9 open simultaneously to catch discrepancies.

**Primary sources (in priority order for conflicts):**
1. Session 0 Training Doc (Notion, v2.4, Mar 16) — most current LLM Truths, principles, patterns
2. Session 1 Wiki (Notion, v3, Mar 12) — most current 7-Component System
3. Doc-9 Agent System Ultimate Truths (research/amt, v1.2) — canonical reference, dependency graph, component cards
4. ESD Framework (templates/effective-system-design.md, v2.0) — methodology, contracts, RACI
5. Spec-Gap-Analysis (research/spec-gap-analysis.md, v0.1) — eval framework (G1), failure modes (G3)
6. Whiteboard template (ClickUp) — Input/Output 5-category taxonomy
7. 10 Ultimate Truths (BOOK-00) — UT#1, UT#2, value chain

---

## 6. File Summary

| File | Location | Lines | Purpose |
|---|---|---|---|
| `rules/agent-system.md` | NEW | ~300 | Agent 7-CS: 3 principles, 8 LLM Truths, two operators, 7 components |
| `rules/general-system.md` | NEW | ~310 | Universal system: 6 components, RACI, UBS/UDS, principles, 4-layer boundaries, ESD, value chain |
| `rules/agent-diagnostic.md` | NEW | ~150 | Diagnostic: Blame Diagnostic, symptom table, derisk checklist, force map, automation integration |
| `CLAUDE.md` | EDIT | +18 lines | Summary sections pointing to the three rule files |

**Total new content:** ~775 lines across 3 new files + 18-line CLAUDE.md edit.

---

## 7. Audit Trail

### Review 1 (spec-document-reviewer subagent)
**Verdict:** APPROVED with 3 Important items, 4 Suggestions.
**Resolved:** I-1 (CLAUDE.md diagnostic heading), I-2 (file header convention), I-3 (layer naming "Pre-Build"). All suggestions incorporated.

### Review 2 (independent Opus auditor)
**Verdict:** APPROVED WITH CONDITIONS — 2 HIGH, 5 MEDIUM, 3 LOW.
**All items resolved in this revision:**

| # | Severity | Issue | Resolution |
|---|---|---|---|
| 1 | HIGH | File header convention undefined | Defined exact blockquote template in §5 (matches brand-identity.md and naming-rules.md) |
| 2 | HIGH | File naming deviates from `-rules` suffix | Justified in §5: these are reference truths, not prescriptive rules; `brand-identity.md` also omits suffix |
| 3 | MEDIUM | CLAUDE.md section ordering | Reordered: Agent System → System Design → Agent Diagnostics (foundational first, support last) |
| 4 | MEDIUM | UBS/UDS ordering inverts ESD | UBS first, documented rationale in §5: derisk precedes output, ESD ordering was discovery-flow artifact |
| 5 | MEDIUM | Notation at end of docs, L2 inaccessible | Moved notation to Section 1 in all three docs |
| 6 | MEDIUM | SFIA dropped without pointer | Added one-line reference to Doc-9 §4.4 in agent-system.md §2 |
| 7 | MEDIUM | Always/Ask/Never not surfaced in EPS card | Added explicit note in EPS component card (agent-system.md §5) |
| 8 | LOW | Future architecture section unlabeled | Added "FUTURE — not yet implemented" blockquote in agent-diagnostic.md §7 |
| 9 | LOW | UDO unused in agent-system.md notation | Removed UDO from agent-system.md notation table |
| 10 | LOW | Notion source accessibility warning | Added source verification warning in §5 |

### User-requested changes
- Removed "Map Anything New" table from agent-system.md (redundant with component definitions)
- Confirmed UBS-first ordering (derisk always goes first)
- Confirmed file naming: `agent-system.md`, `general-system.md`, `agent-diagnostic.md`
