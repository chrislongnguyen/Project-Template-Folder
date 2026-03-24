# Zone 1 — ALIGN: Standard Operating Procedure

> **Version:** 1.0 (Approved Design)
> **Date:** 2026-03-24
> **Status:** Approved — pending implementation
> **Branch:** APEI-Project-Repo
> **Scope:** Defines the internal ALIGN → PLAN → EXECUTE process for Zone 1 of the APEI operating system.

---

## 0. System Integration Contract

| Field | Value |
|-------|-------|
| **INPUT** | Raw trigger: idea, problem, directive, or hypothesis (unstructured) |
| **EO** | Effective Project Alignment — all conditions for success are fulfilled, all output artifacts are populated and approved |
| **OUTPUT** | Populated Charter, Stakeholders, Requirements, OKRs, ADRs + updated README summary → consumed by Zone 2 (PLAN) |

### Roles

| Role | Actor | Responsibilities |
|------|-------|-----------------|
| **R** (Responsible) | Agent | Drafts artifacts, analyzes stakeholders, decomposes requirements, proposes KR formulas, runs validation |
| **A** (Accountable) | Human Director | Provides raw trigger, judges correctness, makes decisions on ADR candidates, approves each artifact |
| **C** (Consulted) | Domain experts, key stakeholders, upstream/downstream system owners | Two-way input before decisions. Consulted during brainstorming (1.1), Charter scope validation (3.1), domain research (3.3), requirements validation (3.4). The Human Director decides WHO to consult per step. |
| **I** (Informed) | Zone 2 team, leadership, wider stakeholders | One-way notification after actions. Informed when Zone 1 completes (3.6), when major ADRs are decided (3.1-3.5), when scope changes occur. |

---

## 1. Conditions for Success

These are the conditions that must ALL be true for Zone 1 to be complete. Every step in this SOP exists to fulfill one or more of these conditions. The conditions are derived by reverse-engineering from the output artifacts — asking "what must be true before this artifact can be properly populated?"

| # | Condition | Output Artifact | Reference Framework | What Must Be True |
|---|-----------|----------------|--------------------|--------------------|
| C1 | Problem/opportunity understood (WHY) | Charter §Purpose | ESD §3.2 (EO) | Human can state the EO in one sentence: "[User] [desired state] without [constraint]" |
| C2 | System boundary defined (INPUT/EO/OUTPUT) | Charter §Scope | ESD §3.0 (Workstream Boundary) | INPUT (what triggers the system), EO (desired state), OUTPUT (what it produces for downstream) are all explicit. In-scope and out-of-scope stated. |
| C3 | Primary user + anti-persona defined | Stakeholders | ESD §3.1 (User Definition) | Primary user profile is specific enough to make design decisions against. Anti-persona states who this system is NOT for. |
| C4 | RACI assigned (R ≠ A) | Stakeholders | ESD §3.1 (RACI D23) | R and A are different actors. Every stakeholder has one RACI assignment. |
| C5 | UBS identified (role-aware: R + A perspectives) | Charter §Risks | ESD §3.4 (Blocking System) | At least 3 risks identified. Each analyzed from both R perspective (what blocks execution) and A perspective (what blocks quality assurance). Mitigations stated. |
| C6 | UDS identified (role-aware: R + A perspectives) | Charter §How | ESD §3.3 (Driving System) | Initial governing principles identified, S/E/Sc bucketed. NOTE: These are high-level approach principles only. Full system design (ESD Phase 2: detailed environment, tools, EOP) is Zone 2 scope. |
| C7 | Requirements VANA-decomposed with binary ACs | Requirements | ESD §5 (Phase 3) + UT#3 | Every requirement has: Verb (action), Adverb (quality), Noun (subject), Adjective (effectiveness). Every requirement has at least one binary acceptance criterion. MoSCoW tagged. |
| C8 | Success metrics with formulas, pillar-tagged | OKRs | Wiki §0.5 (Metrics) + §1.1 (Success Definition) | KRs have explicit formulas (not aspirations). Each KR tagged to S, E, or Sc pillar. At least one KR per pillar. Every Must Have requirement traces to at least one KR. |
| C9 | Domain understood well enough for C7 + C8 | Research outputs (if needed) | — | Human can answer: "Can you state the binary acceptance criteria for requirement X right now?" If yes for all requirements → C9 is met. If no → research needed. |
| C10 | Non-trivial decisions recorded with all options + rationale | ADRs | — | Every decision where multiple viable options existed AND the choice materially affects Zone 2 or Zone 3 has an ADR with: options considered, 3-pillar eval, UBS/UDS per option, bias check, chosen option + reasoning. |

### ADR Threshold

Not every decision needs an ADR. ADRs are required only when:

1. **Multiple viable options exist** — if there's only one reasonable approach, just do it
2. **The choice materially affects downstream zones** — if the decision is local to one artifact and doesn't constrain Zone 2 or Zone 3, it doesn't need formal documentation
3. **The rejected options might become relevant if conditions change** — ADRs exist so Zone 2 can revisit rejected options when trade-offs surface

Examples that need ADRs: technology approach, architecture style, scope boundary decisions, build-vs-buy.
Examples that don't: formatting choices, template field ordering, naming conventions already covered by UNG.

---

## 2. Folder Structure

Zone 1 artifacts live in `1-ALIGN/` following the existing scaffold structure:

```
1-ALIGN/
├── README.md                     # Zone purpose + conditions checklist + Zone 2 entry summary
├── charter/
│   ├── PROJECT_CHARTER.md        # WHY, WHAT, WHO, HOW, WHEN, RISKS (C1,C2,C5,C6)
│   ├── STAKEHOLDERS.md           # Stakeholder map + RACI + UBS/UDS (C3,C4)
│   └── REQUIREMENTS.md           # VANA requirements + binary ACs (C7)
├── okrs/
│   ├── OBJECTIVES.md             # Strategic objectives (C8)
│   └── KEY_RESULTS.md            # KRs with formulas, S/E/Sc tagged (C8)
├── decisions/
│   └── ADR-000_template.md       # Template for alignment decisions (C10)
└── research/                     # Only created if C9 = UNKNOWN
    ├── deep-research/            # /deep-research outputs (CODE template format)
    └── learning-output/          # Learn pipeline outputs (UEDS pages + VANA-SPEC)
```

NOTE: `REQUIREMENTS.md` stays in `charter/` to match the existing scaffold. It is produced AFTER Charter and Stakeholders (step 3.4), not during Charter production (step 3.1).

---

## 3. ESD Integration with Templates

The Effective System Design (ESD) framework is the design METHODOLOGY — it tells the agent HOW to think when filling each template field. The templates are the OUTPUT FORMAT — they tell the agent WHAT to write.

**Integration approach:** Each template section gets a one-line ESD reference comment. The agent loads the relevant ESD section on-demand when filling that field. Templates stay lean; ESD provides the rigor.

Example for Charter template:
```markdown
## 1. WHY — Purpose & Strategic Alignment
<!-- ESD §3.2: EO format — "[User] [desired state] without [constraint]" -->

## 2. WHAT — Scope & Success Definition
<!-- ESD §3.0: System boundary — define INPUT/EO/OUTPUT contract -->

## 4. HOW — Approach & Principles
<!-- ESD §3.3 (UDS) for initial drivers. S/E/Sc bucketed per ESD §4.1.
     NOTE: Initial governing principles only. Full Phase 2 system design
     (environment, tools, EOP) is Zone 2 scope. -->

## 6. RISKS — Initial UBS Scan
<!-- ESD §3.4: Role-aware — analyze from BOTH R perspective AND A perspective (D25) -->
```

**Reference docs available during Zone 1 (loaded on-demand, not all at once):**

| Doc | When to Load | Used For |
|-----|-------------|----------|
| `docs/reference/effective-system-design.md` | During 3.1 (Charter) and 3.4 (Requirements) | Design methodology — HOW to fill fields |
| `docs/reference/system-wiki-template.md` | During 3.2 (Stakeholders) and 3.5 (OKRs) | Output format reference — WHAT fields look like when filled |
| `docs/reference/effective-principles-registry.md` | During any step if EP compliance question arises | EP quick-reference — check design decisions against principles |
| `docs/reference/10-ultimate-truths.md` | During 3.1 (Charter §How, §Risks) | UT compliance — ensure principles trace to UTs |
| `docs/reference/human-centric-ueds.md` | During 3.3 (Research) if domain is a UEDS topic | Domain learning — feeds learn pipeline |
| `docs/reference/ai-centric-ueds.md` | During 3.3 (Research) if domain is AI-related | Domain learning — feeds learn pipeline |

**Rule (EP-04):** Never load more than 2-3 of these in a single step. Load the specific section needed, not the full doc.

---

## 4. The SOP — Three Stages

### STAGE 1: 1-ALIGN — "What do we need?"

**Purpose:** Discover intent, assess every condition for success, produce the checklist. This is pure discovery — no artifact production, no research execution. The output is a clear picture of what is KNOWN, what is UNKNOWN, and what decisions need to be made.

---

#### Step 1.1 — Explore + Assess Conditions

| Field | Specification |
|-------|--------------|
| **Input** | Raw trigger from Human (idea, problem, directive, or hypothesis — any format) |
| **Output** | Populated conditions checklist: each C1-C10 marked KNOWN or UNKNOWN. For each UNKNOWN: what specifically is missing and what's needed to fulfill it. ADR candidates identified (conditions with multiple viable approaches). |
| **R (Agent)** | Use `/ltc-brainstorming` with C1-C10 as the structured interview framework. Walk each condition: "Do we have this? If not, what's missing?" For conditions the Human claims as KNOWN, test with a specificity check: "Can you state the EO in one sentence?" / "Can you name the binary AC for this requirement?" If the answer is vague, mark UNKNOWN. Flag conditions where multiple approaches exist as ADR candidates. |
| **R DON'Ts** | Do NOT start proposing solutions or architecture. Do NOT load reference docs beyond what the brainstorming skill needs. Do NOT create any files. Do NOT mark conditions as KNOWN based on the Human's confidence alone — test with specificity checks. |
| **A (Human)** | Provide the trigger. Answer questions honestly. State what you know and don't know. For multi-option conditions: state your preference but acknowledge alternatives exist. Identify who should be **Consulted (C)** for specific conditions — e.g., C5 (UBS) might need a risk/compliance expert; C9 (domain) might need a subject matter expert; C2 (boundary) might need upstream/downstream system owners. |
| **A DON'Ts** | Do NOT over-specify the solution at this stage. Do NOT claim KNOWN for conditions you can't state specifically (aspiration ≠ knowledge). Do NOT skip this step — "let's just start building" is the #1 project failure mode. |
| **Tools/Skills** | `/ltc-brainstorming` (exploration mode, using C1-C10 as structured interview) |
| **Docs Loaded** | Skill loads its own references. Conditions table (this SOP). No artifact templates yet (EP-08). |
| **EP Applied** | EP-01 (understand before acting), EP-08 (lean context — no docs yet), EP-03 (Agent asks exhaustively, Human judges), EP-09 (C1-C10 decomposes alignment into assessable pieces) |
| **Typical Blocker** | Human provides a solution disguised as a problem ("build X" instead of "we need to solve Y"). **Fix:** Agent asks "What problem does X solve? Who suffers without it?" Also: Human marks everything KNOWN when most conditions are actually DESIRED. **Fix:** Agent tests specificity — "Can you state the binary AC right now?" |

---

### STAGE 2: 1-PLAN — "In what order do we fulfill everything?"

**Purpose:** Map dependencies between conditions, sequence the work into one executable plan. This plan IS the execution plan — Stage 3 follows it directly with no separate planning pass.

---

#### Step 2.1 — Map Dependencies + Sequence

| Field | Specification |
|-------|--------------|
| **Input** | Populated conditions checklist from 1.1 (with KNOWN/UNKNOWN markings and ADR candidates) |
| **Output** | Execution plan containing: (1) Ordered sequence of work items, each linked to the conditions it fulfills. (2) Dependencies made explicit. (3) For UNKNOWN conditions requiring research: research scoped as a predecessor step within the sequence. (4) Session grouping with context loads specified per session. (5) Per step: what to load, what Human prepares, done criteria. |
| **R (Agent)** | Reverse-engineer from outputs. (1) Map condition dependencies — default order: Charter (C1,C2,C5,C6) → Stakeholders (C3,C4) → Research if C9=UNKNOWN → Requirements (C7) → OKRs (C8) → ADRs + Exit (C10). (2) Validate default order against project specifics: could C9 need to precede C3? (e.g., "we don't understand this domain well enough to know who the stakeholders are"). Adjust sequence if needed. (3) For each UNKNOWN requiring research: define the specific question, research depth (surface: `/deep-research` lite/mid, or deep: learn pipeline), and scope bound ("answers question X — does not map entire domain"). (4) Group into sessions: Charter is always its own session. Small artifacts can combine. Requirements always gets its own session (heaviest). (5) For multi-session plans: specify what each session loads at start (prior step's approved artifacts + current template + relevant ESD section). |
| **R DON'Ts** | Do NOT propose parallel production of dependent artifacts (Charter MUST exist before Requirements). Do NOT leave research scope unbounded — every research item needs a specific question and depth. Do NOT plan to produce all artifacts in one session for non-trivial projects (LT-3: reasoning degrades). |
| **A (Human)** | Validate dependency order — override if project-specific reasons exist. Confirm what you'll prepare per artifact (domain knowledge, stakeholder names, strategic direction, timeline). Approve session plan. Flag if you can't prepare something — that's a missed unknown from 1.1 (loop back). |
| **A DON'Ts** | Do NOT accept a random order. Dependencies are structural, not preferences. Do NOT insist on one mega-session if the plan calls for multiple — EP-09 exists for a reason. |
| **Tools/Skills** | None — structured planning conversation |
| **Docs Loaded** | Conditions checklist from 1.1. Skim artifact templates for structure (not full content). |
| **EP Applied** | EP-09 (decompose into dependency order), EP-04 (plan context loads per session), EP-07 (for multi-session: specify what loads at each session start) |
| **Typical Blocker** | Plan is too abstract. **Fix:** Be specific per step — "For Charter: load charter template + brainstorming outputs. You provide: strategic alignment, timeline, top 3 risks. Done when: all Charter sections filled, C1+C2+C5+C6 PASS." |

**Default dependency map (adjustable per project in this step):**

```
C1,C2,C5,C6 ──► [3.1 Charter] ──┐
                                  │
                    C3,C4 ──► [3.2 Stakeholders] ──┐
                                                    │
              C9 (if UNKNOWN) ──► [3.3 Research] ───┤
                                                    │
                           C7 ──► [3.4 Requirements]│
                                        │           │
                           C8 ──► [3.5 OKRs] ──────┤
                                                    │
                          C10 ──► [3.6 ADRs + Exit] ┘

ADRs: recorded continuously during 3.1-3.5 whenever
a condition has multiple viable approaches
```

**Session handoff protocol (EP-07):**

When the execution plan spans multiple sessions:

| Session | Loads at Start | Produces |
|---------|---------------|----------|
| Session A: Charter | Brainstorming outputs + charter template + ESD §3.0-3.4 | Approved Charter |
| Session B: Stakeholders | Approved Charter + stakeholders template + Wiki §2.1 | Approved Stakeholders |
| Session C: Research (if needed) | Unknowns list + Charter + Stakeholders + relevant sources | Research outputs + VANA-SPEC (if deep) |
| Session D: Requirements | Charter + Stakeholders + research outputs + requirements template + ESD §5 + VANA-SPEC (if exists) | Approved Requirements |
| Session E: OKRs + Exit | Charter + Requirements + OKR templates + Wiki §0.5, §1.1 | Approved OKRs + finalized ADRs + updated README |

Each session starts by loading ONLY the approved artifacts from prior sessions + the template for the current step. No unnecessary context (EP-04). If using `/session-start` and `/session-end` skills, the session handoff is automatic.

---

### STAGE 3: 1-EXECUTE — "Do it all"

**Purpose:** Follow the execution plan from Stage 2. Produce all artifacts — including research if C9 was UNKNOWN — in one ordered pass. Human approves each artifact before proceeding to the next.

---

#### Step 3.1 — Produce Charter (fulfills C1, C2, C5, C6)

| Field | Specification |
|-------|--------------|
| **Input** | Brainstorming outputs from 1.1 + KNOWN conditions |
| **Output** | Populated `1-ALIGN/charter/PROJECT_CHARTER.md` with ALL sections filled (no TBDs). Any multi-option decisions during this step → ADR drafted. |
| **R (Agent)** | Fill every Charter section using ESD Phase 1 as methodology: **§Purpose (C1):** State the EO per ESD §3.2 format: "[User] [desired state] without [constraint]." Explain problem/opportunity and strategic alignment. **§Scope (C2):** Define system boundary per ESD §3.0: INPUT (what triggers), EO (desired state), OUTPUT (what it produces for downstream). Explicitly state what is IN scope and OUT of scope. **§Who:** Identify primary user. Detailed stakeholder analysis in step 3.2. **§How (C6):** Identify initial governing principles, bucketed by S/E/Sc. These are high-level approach principles derived from ESD §3.3 (UDS drivers). NOTE: Full system design (detailed environment, tools, EOP per ESD Phase 2) is Zone 2 scope — Charter §How captures the APPROACH, not the ARCHITECTURE. **§When:** Timeline and milestones. **§Risks (C5):** Initial UBS scan per ESD §3.4 — role-aware analysis from BOTH R perspective (what blocks execution) AND A perspective (what blocks quality oversight). At least 3 risks with mitigations. For any section where multiple viable approaches exist: draft ADR with options (3-pillar eval, UBS/UDS per option). Only the chosen option goes into the Charter. |
| **R DON'Ts** | Do NOT leave any section as TBD. Do NOT write aspirational scope — be specific. Do NOT skip the RISKS section. Do NOT include detailed system design in §How — that's Zone 2. Do NOT load Requirements or OKR templates (not needed for this step). |
| **A (Human)** | Provide: WHY this project exists, strategic alignment, timeline constraints, known risks, scope boundaries. Validate: is the EO correct? Are risks real? Is OUT OF SCOPE complete? Make decisions on any ADR candidates. **Approve before proceeding to 3.2.** |
| **A DON'Ts** | Do NOT approve a Charter with TBD sections. Do NOT approve without reviewing the OUT OF SCOPE section (missing exclusions cause scope creep in Zone 2). |
| **C (Consulted)** | Consult upstream system owners for INPUT definition and downstream consumers for OUTPUT definition (ESD §3.0 boundary). Consult domain experts for §Risks if Human Director lacks risk visibility. The Human Director decides who to bring in and when. |
| **I (Informed)** | — (no notifications needed at this step; Charter is internal to Zone 1) |
| **Tools/Skills** | Charter template (existing scaffold) |
| **Docs Loaded** | Charter template + brainstorming outputs. ESD §3.0-3.4 loaded on-demand for methodology guidance. 2-3 docs max (EP-04). |
| **EP Applied** | EP-06 (RISKS section = brake before gas — derisk before output), EP-10 (conditions C1,C2,C5,C6 define done for this step), EP-08 (Charter is concise — not a 20-page document) |
| **Typical Blocker** | Human can't articulate WHY clearly. **Fix:** Agent asks "If this project didn't exist, what would go wrong?" or "Who suffers and how?" Also: Human wants to include detailed technical design in §How. **Fix:** Agent redirects — "That's Zone 2 (PLAN) scope. Charter §How captures your high-level approach and governing principles only." |

---

#### Step 3.2 — Produce Stakeholders (fulfills C3, C4)

| Field | Specification |
|-------|--------------|
| **Input** | Approved Charter from 3.1 + stakeholders template |
| **Output** | Populated `1-ALIGN/charter/STAKEHOLDERS.md` with: stakeholder map (who, role, needs, UBS per stakeholder, UDS per stakeholder, engagement level), RACI assignments (R ≠ A per UT#9), key stakeholder risks with mitigations. |
| **R (Agent)** | Analyze Charter §Who + §Scope. Propose comprehensive stakeholder list using ESD §3.1 (User Definition): **Primary user persona** — specific enough that a designer can make decisions by referencing this profile. Include: role/title, operating context, capability level, primary job-to-be-done, key constraints. **Anti-persona** — who is explicitly NOT the user and why designing for them would harm the primary user. **Indirect stakeholders** — anyone affected by the system's outputs, even if they don't use it directly. For EACH stakeholder: identify UBS (what blocks them) and UDS (what drives them). Assign RACI ensuring R ≠ A (UT#9, ESD §3.1 D23). Identify key stakeholder risks. |
| **R DON'Ts** | Do NOT list only the obvious stakeholders. Do NOT assign R and A to the same person. Do NOT skip the UBS/UDS analysis per stakeholder — this feeds directly into Zone 2's risk register. |
| **A (Human)** | Validate: are all stakeholders listed? Add stakeholders the Agent can't know about (political, informal power structures, silent blockers). Confirm RACI assignments. Check: "Is there anyone who could block this project who isn't listed?" **Approve before proceeding.** |
| **A DON'Ts** | Do NOT approve a shallow list (only the project owner and one user). |
| **C (Consulted)** | Consult existing stakeholders to validate needs and RACI assignments. Consult organizational chart owners if RACI conflicts with existing reporting lines. Human Director decides who to bring in. |
| **I (Informed)** | — (no notifications needed at this step; stakeholder analysis is internal to Zone 1) |
| **Tools/Skills** | Stakeholders template (existing scaffold) |
| **Docs Loaded** | Stakeholders template + approved Charter from 3.1. Wiki §2.1 (Role Assignments) on-demand for format reference. 2-3 docs only (EP-04). |
| **EP Applied** | EP-03 (Agent analyzes exhaustively — all possible stakeholders; Human validates with organizational/political knowledge the Agent can't have), EP-07 (if new session: Charter must be explicitly loaded — Agent can't infer stakeholders without scope context) |
| **Typical Blocker** | Stakeholder list is too shallow. **Fix:** Agent prompts: "Who uses the output? Who funds it? Who is affected if it fails? Who could veto? Who provides inputs? Who is downstream?" |

---

#### Step 3.3 — Resolve Domain Unknowns (fulfills C9 — ONLY if C9 = UNKNOWN)

**Skip this step entirely if all domain conditions were marked KNOWN in step 1.1.**

| Field | Specification |
|-------|--------------|
| **Input** | Scoped unknowns list from execution plan (2.1) — each with: specific question, research depth, scope bound. Charter + Stakeholders for context. |
| **Output** | All unknowns resolved. Domain understood well enough for VANA decomposition (C7) and KR formulas (C8). Research outputs stored in `1-ALIGN/research/`. If learn pipeline produced a VANA-SPEC → C7 is partially pre-populated. |
| **R (Agent)** | Execute research per the scoping from 2.1. **Surface unknowns** (specific questions needing cited answers): Run `/deep-research` (lite = 5min, mid = 15min) per question. Output in CODE template format (12-question structure from `_TEMPLATE.md`). Store in `1-ALIGN/research/deep-research/`. **Deep unknowns** (domain too unfamiliar for VANA requirements): Run learn pipeline: `/learn:input` → `/learn:research` → `/learn:structure` → `/learn:review` → `/spec:extract` → `/spec:handoff`. Store in `1-ALIGN/research/learning-output/`. The VANA-SPEC output maps directly to Requirements: Verb ACs → requirements, Adverb ACs → quality criteria, Noun ACs → subject requirements. After all research completes: summarize what was learned. Map research outputs to the remaining artifacts: "This research answers X for Requirements, this VANA-SPEC pre-populates C7." |
| **R DON'Ts** | Do NOT research beyond the scoped question (research scope creep is a real risk). Do NOT dump all research outputs into a single context for later steps — distill the relevant findings per artifact (EP-08). Do NOT skip learn:review in the learn pipeline — Human must approve pages before spec-extract. |
| **A (Human)** | Review research outputs for each unknown. For learn pipeline: approve each learning page at learn:review. Approve VANA-SPEC at spec:handoff. Confirm: "I can now write VANA requirements with binary ACs for this domain." If still unsure → identify what's still unknown and scope additional targeted research. |
| **A DON'Ts** | Do NOT accept research that doesn't answer the original scoped question. Do NOT let research expand beyond the bound set in 2.1 without explicitly re-scoping. |
| **C (Consulted)** | Subject matter experts consulted to scope research questions, validate research outputs, or provide primary sources. For learn pipeline: domain experts may review learning pages alongside the Human Director. The Human Director decides who to bring in per unknown. |
| **I (Informed)** | — (research is internal to Zone 1) |
| **Tools/Skills** | `/deep-research` (for surface unknowns) and/or Learn pipeline: `/learn:input`, `/learn:research`, `/learn:structure`, `/learn:review`, `/spec:extract`, `/spec:handoff` (for deep unknowns) |
| **Docs Loaded** | Per unknown: only sources relevant to that specific question. Fresh sub-agent session per research question (EP-07). Charter + Stakeholders loaded for context scoping only. |
| **EP Applied** | EP-07 (fresh context per research question), EP-08 (one question, one output — don't research broadly), EP-09 (one unknown per research invocation), EP-10 (research must answer the scoped question — that's the done criteria) |
| **Typical Blocker** | Research scope creep — "while we're at it, let's also research Y and Z." **Fix:** Return to the scoped question from 2.1. "Does answering Y help us write a binary AC for a specific requirement? If not, it's out of scope for Zone 1." Also: All unknowns classified as "deep" (learn pipeline) when most are surface-level (deep-research). **Fix:** Agent tests — "Would a 15-minute cited report let you write the AC? Then it's surface." |

---

#### Step 3.4 — Produce Requirements (fulfills C7)

| Field | Specification |
|-------|--------------|
| **Input** | Approved Charter + Stakeholders + research outputs from 3.3 (if any) + VANA-SPEC from learn pipeline (if any) + requirements template |
| **Output** | Populated `1-ALIGN/charter/REQUIREMENTS.md` with: VANA-decomposed requirements, binary acceptance criteria per requirement, traceability to future OKRs and risks, 3-Pillar check per requirement, MoSCoW tags (Must/Should/Could/Won't). |
| **R (Agent)** | **If VANA-SPEC exists from 3.3:** Map spec sections directly into requirements. Verb ACs → requirement actions. Adverb ACs → quality criteria. Noun ACs → subject/tool requirements. Adjective ACs → effectiveness criteria. Failure Modes → risk traces. **If no VANA-SPEC:** Decompose each Charter scope item into VANA requirements per ESD §5 and UT#3 grammar: Verb (what to do), Adverb (how well), Noun (the system/subject), Adjective (what quality). For EACH requirement: (1) Write at least one binary AC — a test that returns PASS or FAIL with no subjective judgment. (2) Trace to a future OKR (which KR will this requirement contribute to?). (3) Check against all 3 pillars: does this requirement address S, E, or Sc? (4) Tag MoSCoW: Must Have, Should Have, Could Have, Won't Have (this iteration). For any requirement where multiple implementation approaches exist → draft ADR. |
| **R DON'Ts** | Do NOT write requirements as task lists ("do X, do Y"). Requirements describe a STATE to achieve, not actions to take. Do NOT write vague ACs ("works well", "is fast", "is secure"). ACs must be binary and deterministic — the Agent or a script can evaluate them without subjective judgment. Do NOT load architecture docs — this is requirements, not design. Do NOT combine multiple VANA atoms into one compound requirement. |
| **A (Human)** | Validate every VANA decomposition: "Is this what I mean?" Validate every AC: "Would I accept this as proof of completion? Could I test this?" Flag any requirement that feels too large — it needs further decomposition. Flag any AC that requires subjective judgment — it needs to be more specific. **Approve before proceeding to 3.5.** |
| **A DON'Ts** | Do NOT approve requirements you can't verify. If you can't imagine testing an AC, it's not binary enough. Do NOT add "nice to have" requirements without explicitly tagging them as Could/Won't (MoSCoW). |
| **C (Consulted)** | Consult key stakeholders (identified in 3.2) to validate requirements that directly affect them — especially Must Have requirements. The people who will USE the output should confirm the ACs make sense from their perspective. Consult technical experts for feasibility of ACs if requirements touch unfamiliar technology. |
| **I (Informed)** | — (requirements are internal to Zone 1 until exit gate) |
| **Tools/Skills** | Requirements template (existing scaffold). VANA-SPEC from learn pipeline if available. |
| **Docs Loaded** | Requirements template + Charter + Stakeholders + VANA-SPEC (if exists). ESD §5 on-demand for VANA rules. 3-4 docs max (EP-04). |
| **EP Applied** | EP-10 (every requirement has binary AC — this IS Define Done applied to requirements), EP-09 (each requirement is one VANA atom — decompose before you delegate), EP-08 (VANA grammar enforces conciseness — requirements are minimal by design) |
| **Typical Blocker** | Requirements too vague for binary ACs. **Fix:** Agent tests: "How would I verify this? What's the command, script, or manual check that returns PASS/FAIL?" If untestable, decompose further or make more specific. Also: compound requirements. **Fix:** Agent splits — "This requirement has two verbs. Split into two requirements, each with its own AC." |

---

#### Step 3.5 — Produce OKRs (fulfills C8)

| Field | Specification |
|-------|--------------|
| **Input** | Approved Charter + Requirements + OKR templates |
| **Output** | Populated `1-ALIGN/okrs/OBJECTIVES.md` (objectives with strategic alignment + time horizon) and `1-ALIGN/okrs/KEY_RESULTS.md` (KRs with explicit formulas, each tagged to S/E/Sc pillar). |
| **R (Agent)** | Derive objectives from Charter §What (scope + EO). For each objective, propose KRs using the Wiki §1.1 three-pillar success definition structure: **Sustainability KRs** — risk metrics. "How do we know the system isn't failing?" **Efficiency KRs** — input/output metrics. "How do we know the system is producing value?" **Scalability KRs** — growth metrics. "How do we know the system handles growth?" Every KR must have an explicit formula: `[metric] = [calculation] from [data source]`. At least one KR per pillar. Cross-check: every Must Have requirement (from 3.4) traces to at least one KR. If a Must Have requirement has no corresponding KR → add one. If a KR references a data source that doesn't exist → that's a new requirement (flag for loop to 3.4). |
| **R DON'Ts** | Do NOT write KRs without formulas. "Improve user satisfaction" is not a KR. "NPS > 50 measured via quarterly survey" is a KR. Do NOT skip the pillar tag — Zone 2 uses this to prioritize risk work (S→E→Sc per UT#5). Do NOT create KRs that duplicate requirements — KRs measure outcomes, requirements specify capabilities. |
| **A (Human)** | Validate: are KR formulas measurable with available data? Are pillar assignments correct? Is the Sustainability-before-Efficiency ordering reflected in the priority of KRs? If a data source doesn't exist and building it is non-trivial → add it as a requirement (loop to 3.4). **Approve before proceeding to 3.6.** |
| **A DON'Ts** | Do NOT approve KRs you can't actually measure. "We'll figure out how to measure it later" is a Zone 2 risk that should be caught here. |
| **C (Consulted)** | Consult data owners to validate that KR data sources exist and formulas are calculable. Consult leadership if OKRs need to cascade to/from organizational objectives. |
| **I (Informed)** | — (OKRs are internal to Zone 1 until exit gate) |
| **Tools/Skills** | OKR templates (existing scaffold) |
| **Docs Loaded** | OKR templates + Charter + Requirements. Wiki §0.5 (Metrics for Success) and §1.1 (Success Definition table) on-demand for format reference. 3-4 docs (EP-04). |
| **EP Applied** | EP-06 (Sustainability KRs before Efficiency KRs — derisk-first ordering), EP-10 (KR formulas ARE the Define Done criteria for the project — this is what Zone 3 verifies against) |
| **Typical Blocker** | KRs are aspirational ("be the best", "achieve excellence"). **Fix:** Agent enforces formula requirement: "What number, measured how, from what data source, compared to what baseline?" Also: circular dependency — OKR creation reveals a missing requirement. **Fix:** This is expected and handled — loop back to 3.4, add the requirement, return to 3.5. |

---

#### Step 3.6 — Finalize ADRs + Exit Gate (fulfills C10, validates all)

| Field | Specification |
|-------|--------------|
| **Input** | All approved artifacts from 3.1-3.5 + any ADR drafts from those steps + alignment checklist |
| **Output** | (1) All ADRs finalized with: context, options considered (each with 3-pillar eval + UBS/UDS), decision + reasoning, consequences, bias check. (2) Conditions checklist: C1-C10 all PASS with evidence. (3) Updated `1-ALIGN/README.md` with Zone 2 entry summary. (4) Zone 1 declared complete. |
| **R (Agent)** | **Finalize ADRs:** For each ADR drafted during 3.1-3.5, ensure all fields are complete: options, 3-pillar evaluation, UBS mitigated, UDS leveraged, bias check (confirmation bias? anchoring? sunk cost?), chosen option with reasoning, consequences. Verify: only the chosen option's implications are baked into the artifacts; all options stay in the ADR for Zone 2 reference. **Run exit gate:** Walk C1-C10 one by one. For each, verify with evidence: C1 PASS — Charter §Purpose filled, EO stated. C2 PASS — Charter §Scope has INPUT/EO/OUTPUT, in/out of scope stated. C3 PASS — Stakeholders has primary user persona + anti-persona. C4 PASS — RACI assigned, R ≠ A. C5 PASS — Charter §Risks has ≥3 risks with mitigations, role-aware. C6 PASS — Charter §How has initial principles, S/E/Sc bucketed. C7 PASS — Requirements all VANA-decomposed with binary ACs. C8 PASS — KRs all have formulas, pillar-tagged, ≥1 per pillar. C9 PASS — Domain understood (or N/A if was KNOWN from start). C10 PASS — All non-trivial decisions have ADRs. Cross-check: requirement → OKR traceability, stakeholder → RACI coverage, decision → ADR coverage. **Update README:** Add Zone 2 entry summary section to `1-ALIGN/README.md` with: project name, EO (one sentence), scope boundary (in/out), top 3 risks, pointer to each artifact. This summary is Zone 2's cold-start entry point (EP-07). |
| **R DON'Ts** | Do NOT mark conditions as PASS without evidence. Do NOT skip the bias check on ADRs. Do NOT declare Zone 1 complete without Human's explicit approval. |
| **A (Human)** | Review the conditions checklist. For any FAIL items: decide to fix now (loop back to the relevant step 3.1-3.5) or accept with documented reasoning as an ADR (rare — only if the gap is genuinely acceptable). Review the README summary — is it accurate enough for a fresh Zone 2 agent to understand the project? **Explicitly declare: "Zone 1 is complete. Zone 2 can begin."** |
| **A DON'Ts** | Do NOT approve if critical conditions (C1, C2, C5, C7) are FAIL. These are structural — Zone 2 cannot compensate for missing scope, missing risks, or missing requirements. Do NOT proceed to Zone 2 with known gaps that will compound. |
| **C (Consulted)** | — (exit gate is an internal R+A validation; no external consultation needed) |
| **I (Informed)** | Inform Zone 2 team that alignment is complete and artifacts are ready for planning. Inform leadership of key ADRs if the project has organizational visibility. Inform wider stakeholders (identified in 3.2 as RACI "I") that the project is moving from alignment to planning. |
| **Tools/Skills** | Alignment checklist (conditions table). Could become a validation script in future. |
| **Docs Loaded** | All artifacts — read headers and structure only, not full content (EP-04). ADR template for any remaining ADRs. |
| **EP Applied** | EP-05 (this checklist IS the deterministic gate — Zone 2 cannot begin until it passes), EP-10 (all C1-C10 = PASS is the Define Done for Zone 1), EP-07 (README summary enables Zone 2 cold start — a fresh agent session can read one file and know where to look) |
| **Typical Blocker** | Checklist reveals gaps in an artifact that was already approved. **Fix:** Loop back to the specific step. The approval in earlier steps was per-artifact; the exit gate validates the SYSTEM of artifacts working together (traceability, coverage, consistency). Gaps found here are usually cross-reference issues, not content issues. |

---

## 5. Flow Diagram

```
╔═══════════════════════════════════════════════════════════════════╗
║                      ZONE 1 — ALIGN                               ║
║                "Choose the Right Outcome"                          ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  RAW TRIGGER (idea / problem / directive / hypothesis)             ║
║       │                                                            ║
║  ═══ STAGE 1: 1-ALIGN ("What do we need?") ═══════════════════   ║
║                                                                    ║
║  ┌───────────────────────────────────────────────────────────┐    ║
║  │ 1.1 Explore + Assess Conditions                           │    ║
║  │                                                           │    ║
║  │ SKILL: /ltc-brainstorming                                 │    ║
║  │ (using C1-C10 as structured interview framework)          │    ║
║  │                                                           │    ║
║  │ OUTPUT: CONDITIONS CHECKLIST                              │    ║
║  │ ┌───────────────────────────────────────────────────┐     │    ║
║  │ │ C1  WHY understood          [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C2  Boundary defined        [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C3  User defined            [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C4  RACI assigned           [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C5  UBS identified          [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C6  UDS identified          [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C7  VANA requirements       [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C8  KR formulas             [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C9  Domain understood       [KNOWN / UNKNOWN]     │     │    ║
║  │ │ C10 ADR candidates          [list of decisions]   │     │    ║
║  │ └───────────────────────────────────────────────────┘     │    ║
║  └───────────────────────────────────────────────────────────┘    ║
║       │                                                            ║
║       ▼                                                            ║
║  ═══ STAGE 2: 1-PLAN ("In what order?") ═══════════════════════  ║
║                                                                    ║
║  ┌───────────────────────────────────────────────────────────┐    ║
║  │ 2.1 Map Dependencies + Sequence                           │    ║
║  │                                                           │    ║
║  │ DEFAULT DEPENDENCY ORDER (adjustable per project):        │    ║
║  │                                                           │    ║
║  │ C1,C2,C5,C6 ──► [3.1 Charter]                            │    ║
║  │                       │                                   │    ║
║  │          C3,C4 ──► [3.2 Stakeholders]                     │    ║
║  │                       │                                   │    ║
║  │  C9 (if UNKNOWN) ──► [3.3 Research]                       │    ║
║  │                       │                                   │    ║
║  │             C7 ──► [3.4 Requirements]                     │    ║
║  │                       │                                   │    ║
║  │             C8 ──► [3.5 OKRs]                             │    ║
║  │                       │                                   │    ║
║  │            C10 ──► [3.6 ADRs + Exit Gate]                 │    ║
║  │                                                           │    ║
║  │ + Session grouping + context loads + research scoping     │    ║
║  └───────────────────────────────────────────────────────────┘    ║
║       │                                                            ║
║       ▼                                                            ║
║  ═══ STAGE 3: 1-EXECUTE ("Do it all") ═════════════════════════  ║
║                                                                    ║
║  ┌──────────┐   ┌──────────────┐   ┌──────────────────────┐      ║
║  │ 3.1      │   │ 3.2          │   │ 3.3 (if C9=UNKNOWN)  │      ║
║  │ CHARTER  │──►│ STAKEHOLDERS │──►│ RESEARCH             │      ║
║  │          │   │              │   │                      │      ║
║  │ C1,C2,   │   │ C3, C4       │   │ C9                   │      ║
║  │ C5, C6   │   │              │   │                      │      ║
║  │          │   │ ESD §3.1     │   │ Surface:             │      ║
║  │ ESD §3.0 │   │ Wiki §2.1    │   │  /deep-research      │      ║
║  │ to §3.4  │   │              │   │ Deep:                │      ║
║  │          │   │ ✓ Human      │   │  Learn pipeline      │      ║
║  │ ✓ Human  │   │   approves   │   │  → VANA-SPEC?        │      ║
║  │  approves│   │              │   │                      │      ║
║  └──────────┘   └──────────────┘   └──────────┬───────────┘      ║
║                                                │                   ║
║       ┌────────────────────────────────────────┘                   ║
║       ▼                                                            ║
║  ┌──────────────┐   ┌──────────┐   ┌──────────────────────────┐  ║
║  │ 3.4          │   │ 3.5      │   │ 3.6 EXIT GATE            │  ║
║  │ REQUIREMENTS │──►│ OKRs     │──►│                          │  ║
║  │              │   │          │   │ Finalize ADRs (C10)      │  ║
║  │ C7           │   │ C8       │   │                          │  ║
║  │              │   │          │   │ Run C1-C10 checklist:    │  ║
║  │ ESD §5       │   │ Wiki     │   │ ALL PASS? ──► Zone 2 GO │  ║
║  │ UT#3 (VANA)  │   │ §0.5,    │   │ ANY FAIL? ──► loop back │  ║
║  │              │   │ §1.1     │   │                          │  ║
║  │ ✓ Human      │   │ ✓ Human  │   │ Update README with      │  ║
║  │   approves   │   │  approves│   │ Zone 2 entry summary    │  ║
║  └──────────────┘   └──────────┘   │                          │  ║
║                                     │ ✓ Human declares:       │  ║
║  ADRs: recorded continuously        │   "Zone 1 complete.     │  ║
║  during 3.1-3.5 when conditions     │    Zone 2 can begin."   │  ║
║  have multiple viable options        └──────────────────────────┘  ║
║                                                                    ║
║  ┌───────────────────────────────────────────────────────────┐    ║
║  │ ADR FLOW (continuous during 3.1-3.5):                      │    ║
║  │                                                           │    ║
║  │ Condition has multiple viable options?                     │    ║
║  │    YES + materially affects Zone 2/3 → draft ADR          │    ║
║  │    YES + local/obvious → just decide, no ADR              │    ║
║  │    NO  → no decision needed                               │    ║
║  │                                                           │    ║
║  │ ADR contains: all options + chosen option + reasoning     │    ║
║  │ Chosen option → baked into artifact                       │    ║
║  │ All options → stay in ADR for Zone 2 reference            │    ║
║  └───────────────────────────────────────────────────────────┘    ║
║                                                                    ║
╠═══════════════════════════════════════════════════════════════════╣
║  ZONE 1 OUTPUT → ZONE 2 INPUT:                                    ║
║                                                                    ║
║  1-ALIGN/README.md                    (Zone 2 entry summary)      ║
║  1-ALIGN/charter/PROJECT_CHARTER.md   (C1, C2, C5, C6)           ║
║  1-ALIGN/charter/STAKEHOLDERS.md      (C3, C4)                   ║
║  1-ALIGN/charter/REQUIREMENTS.md      (C7 — VANA + binary ACs)   ║
║  1-ALIGN/okrs/OBJECTIVES.md           (C8)                       ║
║  1-ALIGN/okrs/KEY_RESULTS.md          (C8 — formulas, S/E/Sc)    ║
║  1-ALIGN/decisions/ADR-xxx.md         (C10 — all options + chosen)║
║  1-ALIGN/research/ (if C9 was UNK)    (research + VANA-SPEC)     ║
║                                                                    ║
║  GATE: Zone 2 begins ONLY when 3.6 checklist = ALL PASS          ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## 6. Audit Fixes Applied

| Fix # | Issue | Resolution | Where Applied |
|-------|-------|-----------|---------------|
| Fix 1 | EP-07: Multi-session handoff not specified | Added session handoff protocol table in Step 2.1 — each session specifies exactly what to load at start | §4 Stage 2, Step 2.1 |
| Fix 2 | ESD §4.1 (Phase 2) referenced in Charter §How | Clarified: Charter §How = initial governing principles only (high-level approach). Full Phase 2 system design is Zone 2 scope. Added NOTE in C6 and Step 3.1. | §1 Conditions (C6), §4 Step 3.1 |
| Fix 3 | Zone 2 cold start — no single entry point | Step 3.6 updates `1-ALIGN/README.md` with Zone 2 entry summary (project name, EO, scope boundary, top 3 risks, artifact pointers). Serves as cold-start entry point for Zone 2 agent. | §4 Step 3.6 |
| Fix 4 | Folder mismatch — `requirements/` vs `charter/` | `REQUIREMENTS.md` stays in `charter/` to match existing scaffold. Noted explicitly in §2 Folder Structure and all step references. | §2 Folder Structure, Steps 3.4 |
| Fix 5 | Research scope creep — no bounds on 3.3 | Step 2.1 now requires per-unknown scoping: specific question, depth (surface/deep), scope bound. Step 3.3 enforces these bounds. | §4 Step 2.1, Step 3.3 |
| Fix 6 | ADR overhead — every small decision becomes ADR | Added ADR Threshold criteria in §1: only when (a) multiple viable options AND (b) materially affects downstream zones. Examples of what needs/doesn't need ADRs. | §1 ADR Threshold, §5 Diagram ADR Flow box |

---

## 7. Design Decisions Log

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | Internal APEI is a PROCESS (align-plan-execute), not folder structure | Folders hold artifacts; the process transforms inputs to outputs. Folders don't need to mirror the process stages. |
| D2 | Conditions for Success drive the entire SOP | Reverse-engineering from outputs ensures every step exists to fulfill a specific condition. No step exists "because it's best practice." |
| D3 | Research happens during EXECUTE (3.3), not during ALIGN (1.1) | ALIGN discovers what's unknown. EXECUTE resolves unknowns. This eliminates redundancy and keeps ALIGN lightweight. |
| D4 | VANA-SPEC from learn pipeline maps directly to REQUIREMENTS.md | The learn pipeline's spec-extract output IS the requirements specification — no transformation needed, just mapping. |
| D5 | ADRs are the decision funnel — all options in, only chosen option flows forward | Zone 2 receives both the artifact (chosen option baked in) and the ADR (all options + reasoning). Rejected options are documentation, not waste. |
| D6 | ESD stays reference-only; templates get one-line field references | Templates stay lean. ESD comments tell the agent which methodology section to load when filling a field. EP-04 applied to reference docs themselves. |
| D7 | Zone 2 entry point = updated README.md summary, not a new artifact | Avoids artifact bloat. README already exists in the scaffold. Summary section enables EP-07 cold start for Zone 2. |
| D8 | 8 total steps (1.1 → 2.1 → 3.1-3.6), 3.3 conditional | Streamlined from 17 steps in v1. Execution happens once (Stage 3 only). No "plan the plan" redundancy. |

---

*Design by: Long Nguyen + Claude (Research & Governance Agent)*
*Source: APEI brainstorming sessions on branch `APEI-Project-Repo`, 2026-03-24*
*Next: Zone 2 (PLAN), Zone 3 (EXECUTE), Zone 4 (IMPROVE) designs*
