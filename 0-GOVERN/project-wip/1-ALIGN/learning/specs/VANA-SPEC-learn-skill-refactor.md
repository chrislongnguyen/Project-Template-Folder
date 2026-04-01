---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# VANA-SPEC: Learn-Skill Refactor

<!-- Derived from approved brainstorming design (2026-03-29).
     Source: Q1-Q9 answers + legacy skill analysis + S>E>Sc audit.
     This spec covers the 6+1 skill architecture replacing 7 legacy skills. -->

---

## §0 Force Analysis

### §0.1 UBS — Blocking Forces (Derisk First)

#### UBS(R) — What blocks the Responsible party (Claude Agent)

| ID | Force | Mechanism | LT/Bias Root |
|---|---|---|---|
| UBS.R.1 | Context explosion during structure generation | 6 P-pages x 17 columns x N topics = token budget exceeded if loaded at once | LT-2 (context limits) |
| UBS.R.2 | State desync between orchestrator and file system | Stored state file diverges from actual files on disk after crash/partial run | LT-6 (stateless preference) |
| UBS.R.3 | Hallucinated research sources | Agent fabricates URLs/citations that don't exist | LT-1 (hallucination) |
| UBS.R.4 | Methodology drift between deep-research and learn-research | Two skills embed different research protocols, fixes in one don't propagate | EP-04 (single source) |
| UBS.R.5 | Tool failure (EXA/WebSearch unavailable) | Research skill hangs or produces empty output when external tools fail | EOP-08 (escape hatches) |

#### UBS(A) — What blocks the Accountable party (Long / Director)

| ID | Force | Mechanism | LT/Bias Root |
|---|---|---|---|
| UBS.A.1 | Passive rubber-stamping in review | Director approves P-pages without genuine comprehension | Human UBS (bio-efficient forces) |
| UBS.A.2 | Vague EO accepted at input phase | "Learn about X" passes without [User][desired state][constraint] structure | EP-10, LT-5 |
| UBS.A.3 | 36-page batch review overwhelm | All topics presented for review simultaneously → cognitive overload | Human UBS (bounded attention) |

#### Recursive Decomposition (minimum 1 level)

| Parent Force | Sub-Force | Direction | Mechanism |
|---|---|---|---|
| UBS.R.1 | UBS.R.1.UB | Weakens blocker | Per-topic invocation loads only 1 topic's research (EP-04) |
| UBS.R.1 | UBS.R.1.UD | Strengthens blocker | Mermaid companion blocks add visual tokens on top of table data |
| UBS.R.2 | UBS.R.2.UB | Weakens blocker | File system scan derives state at invocation time — no stored file to corrupt |
| UBS.R.2 | UBS.R.2.UD | Strengthens blocker | File system state ambiguous if partial writes occur mid-structure |
| UBS.R.3 | UBS.R.3.UB | Weakens blocker | Source count gate + URL spot-check post-research |
| UBS.R.3 | UBS.R.3.UD | Strengthens blocker | Plausible-looking fake URLs pass surface-level checks |
| UBS.A.1 | UBS.A.1.UB | Weakens blocker | Active learning (comprehension Q per page) forces engagement |
| UBS.A.1 | UBS.A.1.UD | Strengthens blocker | Fatigue after reviewing multiple topics serially |
| UBS.A.3 | UBS.A.3.UB | Weakens blocker | Per-topic review loop (structure → review per topic, not batch) |
| UBS.A.3 | UBS.A.3.UD | Strengthens blocker | Many topics = many sequential review sessions |

### §0.2 UDS — Driving Forces

#### UDS(R) — What drives the Responsible party (Claude Agent)

| ID | Force | Mechanism | Strength Source |
|---|---|---|---|
| UDS.R.1 | Parallel sub-agent architecture | Research dispatches N agents simultaneously — wall-clock scales sub-linearly | Architectural |
| UDS.R.2 | Shared research methodology | Single `_shared/templates/RESEARCH_METHODOLOGY.md` — both skills import same protocol | Architectural |
| UDS.R.3 | File system state derivation | No stored state to maintain — scan dirs, check frontmatter, route accordingly | Procedural |
| UDS.R.4 | Forked Opus for structure generation | Highest-capability model for the hardest cognitive task (17-col table generation) | Architectural |

#### UDS(A) — What drives the Accountable party (Long / Director)

| ID | Force | Mechanism | Strength Source |
|---|---|---|---|
| UDS.A.1 | Per-topic review loop | One topic reviewed and approved before next begins — manageable cognitive load | Procedural |
| UDS.A.2 | DSBV Readiness Package | /learn:spec produces C1-C6 mapping — direct handoff to DSBV without manual bridging | Architectural |
| UDS.A.3 | Interactive visualization | /learn:visualize renders P-page causal graph as navigable system map | Architectural |

#### Recursive Decomposition (minimum 1 level)

| Parent Force | Sub-Force | Direction | Mechanism |
|---|---|---|---|
| UDS.R.1 | UDS.R.1.UD | Strengthens driver | Each sub-agent is independent — no cross-topic dependencies |
| UDS.R.1 | UDS.R.1.UB | Weakens driver | Token cost scales N× with topics (cost, not speed) |
| UDS.R.2 | UDS.R.2.UD | Strengthens driver | Fix once, propagates to all consumers automatically |
| UDS.R.2 | UDS.R.2.UB | Weakens driver | Shared template change could break both consumers if not backward-compatible |

### §0.3 Sigmoid Zone Classification

| Component | Current Zone | Signal | Action |
|---|---|---|---|
| EI (learn-input) | Leverage Zone | Legacy skill works; needs EO validation gate upgrade | Keep investing — add gate |
| EU (Claude Agent) | Leverage Zone | Opus handles structure generation; research uses sub-agents | Keep investing — fork model for structure |
| EA (skill invocation) | Below Threshold | 7 fragmented legacy skills with unclear orchestration | Invest — refactor to 6+1 with orchestrator |
| EP (design principles) | Leverage Zone | S>E>Sc audit complete, all 6 gaps addressed in design | Keep investing — encode in skill logic |
| EOE (file system + tools) | Leverage Zone | File paths, research tools, validation scripts exist | Keep investing — add escape hatches |
| EOT (EXA, WebSearch, QMD) | Leverage Zone | Tools available but no failure protocol | Keep investing — document escape hatches per tool |
| EOP (skill procedures) | Below Threshold | Legacy skills lack orchestration, state management, DSBV handoff | Invest — this is the refactor target |

### §0.4 Bottleneck Identification

**Current bottleneck:** EA (skill invocation) + EOP (skill procedures)
**Rationale:** 7 legacy skills lack an orchestrator, state derivation, per-topic loop, DSBV handoff, and shared methodology. The refactor targets both simultaneously.

### §0.5 Synergy Check

| Intervention | Target Component | Effect on Threshold | Synergy? |
|---|---|---|---|
| Build orchestrator (EA) | Lowers K for EOP | Orchestrator routes to correct procedure automatically | Yes |
| Extract shared methodology (EP) | Lowers K for EA | Skills reference instead of embed — simpler skill logic | Yes |
| Add escape hatches (EOE/EOT) | Lowers K for EOP | Procedures don't stall on tool failure | Yes |

**Highest-leverage intervention:** Build the orchestrator (/learn) first — it enables all other skills to be invoked correctly and state to be derived consistently.

---

## §1 System Identity

| Field | Value |
|-------|-------|
| System Name | Learn-Skill Refactor |
| Slug | learn-skill-refactor |
| Abbreviation | LSR |
| EO | Claude Agent [orchestrates structured learning pipelines] [producing approved P-pages and DSBV-ready specs] without [state corruption, context explosion, or passive rubber-stamping] |
| Scope | 6+1 skills replacing 7 legacy skills in `1-ALIGN/learning/skills/` |

### User Persona

| Attribute | Description |
|-----------|-------------|
| Who | Long Nguyen — LTC COE OPS Director, L1 agent progression, visual learner |
| Goal | Learn any domain subject systematically, producing DSBV-ready artifacts for ALIGN/PLAN zones |
| Context | Single-operator using Claude Code CLI; invokes `/learn` and follows interactive pipeline |

### Anti-Persona

| Attribute | Description |
|-----------|-------------|
| Who | Autonomous agent running learn pipeline without human review gates |
| Why Excluded | Active learning + comprehension questions require genuine human engagement; auto-approval defeats the learning purpose |

### RACI

| Role | Assignment |
|------|------------|
| Responsible (R) | Claude Agent (executes skills, generates artifacts) |
| Accountable (A) | Long Nguyen (approves EO, reviews P-pages, approves spec) |
| Consulted (C) | Deep-research skill (shared methodology reference) |
| Informed (I) | DSBV process (downstream consumer of readiness package) |

---

## §2 Verb Acceptance Criteria

<!-- Source: Approved architecture (2026-03-29 brainstorming Q1-Q9) -->

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| Verb-AC1 | orchestrate | `/learn` invoked with no args → scans file system → routes to correct sub-skill based on state (no input → input, input exists no research → research, etc.) | Design:orchestrator | Deterministic | 5/5 state transitions route correctly |
| Verb-AC2 | interview | `/learn:input` presents 9 questions ONE AT A TIME, outputs `learn-input-{slug}.md` | Design:input | Manual | All 9 questions asked; output file created with all answers |
| Verb-AC3 | validate-eo | `/learn:input` rejects EO that lacks [User] [desired state] [constraint] structure | Design:input:gate | Deterministic | Vague EO rejected 3/3 test cases |
| Verb-AC4 | research | `/learn:research` dispatches 1 sub-agent per topic in parallel, each producing 6-section research file | Design:research | Deterministic | N topics → N research files created simultaneously |
| Verb-AC5 | verify-sources | Post-research: source count gate (≥8 per topic) + URL spot-check on ≥2 URLs | Design:research:gate | Deterministic | Gate blocks progression if <8 sources or spot-check fails |
| Verb-AC6 | structure | `/learn:structure` generates 6 P-pages (P0-P5) for ONE topic, loading only that topic's research | Design:structure | Deterministic | 6 files created per invocation; only 1 topic's research in context |
| Verb-AC7 | review | `/learn:review` presents causal spine table + 1 comprehension Q per page for ONE topic | Design:review | Manual | Comprehension Q answered before approval accepted |
| Verb-AC8 | extract-spec | `/learn:spec` reads all approved T0 P-pages → outputs VANA-SPEC + DSBV Readiness Package | Design:spec | Deterministic | VANA-SPEC file + DSBV-READY file created; all P-page refs traceable |
| Verb-AC9 | map-to-zones | `/learn:spec` maps P0→system context, P1→UBS, P2→UDS, P3→EP candidates, P4→component map, P5→sequence hints | Design:spec:mapping | Deterministic | All 6 mappings present in DSBV Readiness Package |
| Verb-AC10 | visualize | `/learn:visualize` reads approved P-pages → generates React+Vite interactive system map | Design:visualize | Manual | HTML renders in browser; nodes from P-page entries; edges from causal references |

---

## §3 Adverb Acceptance Criteria

### §3.1 Sustainability Adverbs (I1)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| SustainAdv-AC1 | statelessly | Orchestrator derives state from file system scan (check: input file? research dir? structured files? approved frontmatter? VANA-SPEC?) — no JSON state file stored | Design:Q3 | Deterministic | No state file created; state re-derived on each invocation |
| SustainAdv-AC2 | gate-protected | Every phase transition requires explicit human approval; no auto-advance from research→structure, structure→review, or review→spec | Design:gates | Manual | 3/3 gate transitions require human "approve" |
| SustainAdv-AC3 | source-verified | Research output includes source count; progression blocked if count <8 or URL spot-check fails on sampled URLs | Design:Q5 | Deterministic | Gate rejects under-sourced research |
| SustainAdv-AC4 | escape-hatched | Each skill documents what happens when its primary tool fails (EXA down → WebSearch fallback; WebSearch down → QMD-only + flag) | Design:S>E>Sc audit | Manual | Every skill SKILL.md has escape-hatch section |
| SustainAdv-AC5 | actively-learned | Review phase asks learner 1 comprehension question per P-page; learner must answer before approval is accepted | Design:Q6 | Manual | Comprehension Q present; answer required before gate passes |

### §3.2 Efficiency Adverbs (I2)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| EffAdv-AC1 | context-bounded | Each sub-skill loads ONLY its required inputs — structure loads 1 topic's research, not all; spec loads T0 pages only | Design:EP-04 | Deterministic | Grep skill files for file-loading instructions — no "load all" patterns |
| EffAdv-AC2 | single-maintained | Research methodology lives in `_shared/templates/RESEARCH_METHODOLOGY.md` — both deep-research and learn:research reference it, neither embeds it | Design:Q5:C | Deterministic | Exactly 1 methodology file; both skills reference (not copy) it |
| EffAdv-AC3 | minimally-interactive | Full pipeline requires: 1 `/learn` invocation + N review approvals + 1 spec approval = N+2 human interactions minimum | Design:efficiency | Deterministic | No additional human interaction beyond gates |

### §3.3 Scalability Adverbs (I3)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| ScalAdv-AC1 | per-topic-looped | Structure and review operate on 1 topic at a time; orchestrator loops through all topics sequentially | Design:scalability | Deterministic | 1 topic = 1 loop; 6 topics = 6 loops; same code path |
| ScalAdv-AC2 | parallel-researched | Research dispatches N sub-agents simultaneously (not sequentially) | Design:research | Deterministic | N topics → N concurrent Agent tool calls in single message |
| ScalAdv-AC3 | independently-visualized | `/learn:visualize` is invocable at any time after structure exists — not gated by spec or review completion | Design:Q8 | Deterministic | Invocation succeeds with structured files present, regardless of review/spec state |

---

## §4 Noun Acceptance Criteria

### §4.1 Skill Files (INFRA Layer)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| Noun-AC1 | orchestrator-skill | `1-ALIGN/learning/skills/learn/SKILL.md` exists with state-derivation logic, routing table, and flow diagram | Design:architecture | Deterministic | File exists; contains routing table for 5 states |
| Noun-AC2 | input-skill | `1-ALIGN/learning/skills/learn-input/SKILL.md` exists with 9-question interview, EO validation gate, escape hatch | Design:architecture | Deterministic | File exists; 9 questions listed; EO gate documented |
| Noun-AC3 | research-skill | `1-ALIGN/learning/skills/learn-research/SKILL.md` exists with parallel dispatch, source verification gate, escape hatches | Design:architecture | Deterministic | File exists; parallel dispatch instruction; source gate documented |
| Noun-AC4 | structure-skill | `1-ALIGN/learning/skills/learn-structure/SKILL.md` exists with per-topic P0-P5 generation, Opus fork, mermaid companions | Design:architecture | Deterministic | File exists; per-topic scope; model fork instruction |
| Noun-AC5 | review-skill | `1-ALIGN/learning/skills/learn-review/SKILL.md` exists with per-topic review, causal spine table, active learning Qs | Design:architecture | Deterministic | File exists; per-topic scope; comprehension Q instruction |
| Noun-AC6 | spec-skill | `1-ALIGN/learning/skills/learn-spec/SKILL.md` exists with VANA extraction, DSBV Readiness Package generation, P-page→zone mapping | Design:architecture | Deterministic | File exists; mapping table for P0-P5→zones |
| Noun-AC7 | visualize-skill | `1-ALIGN/learning/skills/learn-visualize/SKILL.md` exists with React+Vite generation, LTC brand, interactive system map | Design:architecture | Deterministic | File exists; brand requirements listed; interactivity spec |

### §4.2 Shared Assets (WORKSPACE Layer)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| Noun-AC8 | research-methodology | `_shared/templates/RESEARCH_METHODOLOGY.md` exists, extracted from deep-research, containing multi-angle search + source verification + anti-hallucination protocol | Design:Q5:Q7 | Deterministic | File exists; contains all 3 protocol sections |
| Noun-AC9 | advanced-el-reference | Advanced EL System doc imported to `_shared/reference/` with glossary aligned to this repo (EO not UDO, EP not EPS) — no content drift from original | Design:Q9 | AI-Graded | Aligned doc exists; term audit shows 0 legacy terms; content-similarity ≥95% vs original (excluding term changes) |

### §4.3 Legacy Cleanup (INTEL Layer)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| Noun-AC10 | legacy-removed | All 7 legacy skill directories replaced by 6+1 new skill directories; no orphan references to old skill names in SKILL.md files | Design:cleanup | Deterministic | 0 references to legacy skill names in new skills; old directories removed |

---

## §5 Adjective Acceptance Criteria

### §5.1 Sustainability Adjectives (I1)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| SustainAdj-AC1 | EOP-compliant | Every new skill passes `./scripts/skill-validator.sh` (23/23 checks) | EOP-GOV | Deterministic | 23/23 pass per skill; 7 skills × 23 = 161/161 total |
| SustainAdj-AC2 | drift-free | Advanced EL doc rewrite audited objectively: every section present, no content omitted, only glossary terms changed | Design:Q9 | AI-Graded | Section-by-section comparison shows 0 dropped sections, 0 altered meaning |
| SustainAdj-AC3 | binary-gated | Every human gate in the pipeline produces a binary outcome (approved/needs-revision) written to file frontmatter — no ambiguous states | Design:gates | Deterministic | Frontmatter `status:` field is either `approved` or `needs-revision`; no other values |

### §5.2 Efficiency Adjectives (I2)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| EffAdj-AC1 | concise | Every SKILL.md file is under 200 lines (skill body, excluding references/) | EOP-GOV:EOP-07 | Deterministic | `wc -l` on each SKILL.md ≤ 200 |
| EffAdj-AC2 | single-concern | Each skill handles exactly 1 cognitive mode — no skill merges research+structure or structure+review | Design:EP-09 | Manual | Review each SKILL.md — single purpose statement; no dual-phase instructions |

### §5.3 Scalability Adjectives (I3)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold |
|---------|-----------|----------|--------|-----------|-----------|
| ScalAdj-AC1 | topology-invariant | Architecture handles T0 (1 topic, 6 pages) identically to T0-T5 (6 topics, 36 pages) — same code path, different loop count | Design:scalability | Deterministic | Run with 1 topic: works. Describe 6-topic run: same orchestrator logic, just N=6 |
| ScalAdj-AC2 | independently-invocable | Each sub-skill can be invoked directly (`/learn:structure topic-name`) without going through orchestrator — orchestrator is convenience, not requirement | Design:architecture | Deterministic | Direct invocation of each sub-skill works when prerequisites met |

---

## §6 System Boundaries

### §6.1 Layer 1 — What Flows

| Category | Inbound | Outbound |
|---|---|---|
| Acceptance Criteria | Learning Brief with validated EO | Approved P-pages + VANA-SPEC + DSBV Readiness Package |
| Signal / Data / Information | User answers to 9 questions; web research results; approved frontmatter | Structured P0-P5 pages; causal spine tables; zone-mapped spec |
| Physical Resources | File system (1-ALIGN/learning/); network (EXA, WebSearch) | Markdown files; optional React+Vite HTML app |
| Human Resources | Director time: 1 input session + N review sessions + 1 spec approval | Director has structured domain understanding; DSBV can begin |
| Financial Resources | API tokens (Opus for structure, Sonnet for research, EXA credits) | Reduced manual research/structuring time |

### §6.2 Layer 2 — How It Flows Reliably

#### Input Contracts

| Field | Contract 1: Learning Brief | Contract 2: Web Research |
|---|---|---|
| Source | /learn:input (human interview) | EXA, WebSearch, QMD |
| Schema | Markdown with 9 named sections + EO in [User][desired][constraint] format | 6-section research file per topic (Overview, Blockers, Drivers, Principles, Tools, Procedure) |
| Validation | EO structure gate; all 9 sections non-empty | Source count ≥8; URL spot-check on 2+ URLs |
| Error | Reject and re-prompt for EO; flag missing sections | Block progression; offer escape hatch (QMD-only + flag) |
| SLA | Interactive — completes in 1 session | Research: <10min per topic (parallel); may take longer if tools slow |
| Version | v1.0 | v1.0 |

#### Output Contracts

| Field | Contract 1: DSBV Readiness Package | Contract 2: P-pages |
|---|---|---|
| Consumer | DSBV process (`/dsbv design`) | /learn:review (intermediate); /learn:spec (final); /learn:visualize (optional) |
| Schema | C1-C6 checklist with P-page→zone mapping table | P0-P5 markdown with CAG-prefixed cells, 17 columns, frontmatter with `status:` |
| Validation | All C1-C6 satisfied; every mapping has source reference | Validation script checks format, CAG tags, column count, row bounds |
| Error | Fail with gap report — list which C conditions unmet | Structure validation failure → present partial + report gaps (2x escape) |
| SLA | Generated after all T0 pages approved | Per-topic: ~5min structure + review time |
| Version | v1.0 | v1.0 |

### §6.3 Layer 3 — How You Verify

| A.C. ID | Eval Type | Dataset | Grader | Threshold |
|---|---|---|---|---|
| Verb-AC1 | Deterministic | 5 mock file-system states | Script checks routing output | 5/5 correct |
| Verb-AC2-AC3 | Manual | 1 real input session | Director confirms all 9 Qs asked + EO validated | Pass/Fail |
| Verb-AC4-AC5 | Deterministic | 1 topic with known sources | Check parallel dispatch + source count | Files created; ≥8 sources |
| Verb-AC6 | Deterministic | 1 topic with research file | Check 6 P-page files created | 6 files exist |
| Verb-AC7 | Manual | 1 topic review session | Director confirms comprehension Q asked | Q present; answer required |
| Verb-AC8-AC9 | Deterministic | Approved T0 P-pages (mock) | Check VANA-SPEC + DSBV-READY files + mapping table | Both files exist; 6 mappings present |
| Verb-AC10 | Manual | 1 set of approved P-pages | Director confirms HTML renders, interactive | Renders in browser |
| Noun-AC1-AC7 | Deterministic | Skill directories | `./scripts/skill-validator.sh` per skill | 23/23 per skill |
| Noun-AC8 | Deterministic | `_shared/templates/RESEARCH_METHODOLOGY.md` | File exists; contains 3 protocol sections | PASS |
| Noun-AC9 | AI-Graded | Original vs rewritten Advanced EL doc | Section-by-section comparison; term audit | ≥95% content similarity; 0 legacy terms |

### §6.4 Layer 4 — How It Fails Gracefully

| Component / Step | Recovery | Escalation | Degradation | Timeout |
|---|---|---|---|---|
| /learn orchestrator | Re-scan file system; re-route | Flag ambiguous state to user | N/A — routing is binary | N/A |
| /learn:input | Re-prompt for missing/vague answers | Offer 3 EO examples if user can't articulate | Accept partial input with warnings | N/A (interactive) |
| /learn:research (EXA) | Fallback to WebSearch | If both fail → QMD-only + flag "limited sources" | Partial research accepted if flagged | 5 min per topic |
| /learn:research (WebSearch) | Fallback to QMD | Flag to user | QMD-only research with explicit limitation notice | 5 min per topic |
| /learn:structure (validation) | Re-generate failed page | If fails 2x → present partial + report gaps | Partial P-pages with gap report | 10 min per topic |
| /learn:review (comprehension) | Re-ask question if answer unclear | Skip Q after 2 attempts (note skipped) | Review proceeds with skip noted in frontmatter | N/A (interactive) |
| /learn:spec | Report which P-pages missing/unapproved | Block until prerequisites met | N/A — prerequisites are hard gate | N/A |
| /learn:visualize | Degrade to static mermaid if React build fails | Flag build error to user | Static diagram instead of interactive app | 5 min build |

### §6.5 Integration Chain

```
User knowledge gap ──[Learning Brief]──► LEARN PIPELINE ──[VANA-SPEC + DSBV-READY]──► DSBV Process
                                              │
                                              └──[Approved P-pages]──► /learn:visualize (optional)
```

### §6.6 Feedback Loops

| Loop ID | Type | Components | Delay | Effect |
|---|---|---|---|---|
| FL-1 | Balancing | Review rejection → structure re-generation | Short (same session) | Quality improvement per topic before advancing |
| FL-2 | Reinforcing | Successful review → orchestrator advances → next topic | Short | Pipeline momentum — each approval unlocks next topic |
| FL-3 | Balancing | Spec gap report → review re-examination | Medium (may require re-research) | Catches systemic issues across all topics |

---

## §7 AC-TEST-MAP

| A.C. ID | VANA Word | VANA Source | Eval Type | Dataset | Grader | Threshold |
|---------|-----------|-------------|-----------|---------|--------|-----------|
| Verb-AC1 | orchestrate | §2 | Deterministic | 5 mock FS states | Route-check script | 5/5 |
| Verb-AC2 | interview | §2 | Manual | Real session | Director review | 9/9 Qs |
| Verb-AC3 | validate-eo | §2 | Deterministic | 3 vague + 3 valid EOs | EO regex/structure check | 6/6 correct |
| Verb-AC4 | research | §2 | Deterministic | 1 topic | File creation check | N files exist |
| Verb-AC5 | verify-sources | §2 | Deterministic | Research output | Source count + URL check | ≥8 sources; 2+ URLs valid |
| Verb-AC6 | structure | §2 | Deterministic | 1 topic + research | File creation check | 6 P-page files |
| Verb-AC7 | review | §2 | Manual | 1 topic review | Director confirms Q asked | Q present + answer required |
| Verb-AC8 | extract-spec | §2 | Deterministic | Mock approved pages | File creation check | VANA-SPEC + DSBV-READY exist |
| Verb-AC9 | map-to-zones | §2 | Deterministic | DSBV-READY file | Mapping table check | 6/6 mappings present |
| Verb-AC10 | visualize | §2 | Manual | Approved P-pages | Browser render test | Renders + interactive |
| SustainAdv-AC1 | statelessly | §3.1 | Deterministic | Worktree grep | No state file; state derived | 0 JSON state files |
| SustainAdv-AC2 | gate-protected | §3.1 | Manual | Pipeline walkthrough | 3 gate transitions checked | 3/3 require approval |
| SustainAdv-AC3 | source-verified | §3.1 | Deterministic | Research output | Source count gate | Blocks if <8 |
| SustainAdv-AC4 | escape-hatched | §3.1 | Deterministic | Skill file grep | Escape hatch section present | 7/7 skills documented |
| SustainAdv-AC5 | actively-learned | §3.1 | Manual | Review session | Q asked + answer required | PASS |
| EffAdv-AC1 | context-bounded | §3.2 | Deterministic | Skill file grep | No "load all" instructions | 0 violations |
| EffAdv-AC2 | single-maintained | §3.2 | Deterministic | Grep for methodology | 1 source; 2 references | Exactly 1 file |
| EffAdv-AC3 | minimally-interactive | §3.2 | Deterministic | Pipeline flow analysis | Count human interactions | N+2 (N topics + input + spec) |
| ScalAdv-AC1 | per-topic-looped | §3.3 | Deterministic | Orchestrator logic | Loop structure check | Same code path for 1 or N |
| ScalAdv-AC2 | parallel-researched | §3.3 | Deterministic | Research skill | Agent dispatch check | N concurrent calls |
| ScalAdv-AC3 | independently-visualized | §3.3 | Deterministic | Invocation test | Works without spec/review | PASS |
| Noun-AC1-AC7 | skill files | §4.1 | Deterministic | Skill directories | skill-validator.sh | 23/23 per skill |
| Noun-AC8 | research-methodology | §4.2 | Deterministic | File check | Exists + 3 sections | PASS |
| Noun-AC9 | advanced-el-reference | §4.2 | AI-Graded | Original vs rewrite | Section comparison | ≥95% similarity; 0 legacy terms |
| Noun-AC10 | legacy-removed | §4.3 | Deterministic | Directory listing + grep | No orphan refs | 0 orphan references |
| SustainAdj-AC1 | EOP-compliant | §5.1 | Deterministic | skill-validator.sh | 23/23 per skill | 161/161 total |
| SustainAdj-AC2 | drift-free | §5.1 | AI-Graded | Doc comparison | Section-by-section diff | 0 drops; 0 altered meaning |
| SustainAdj-AC3 | binary-gated | §5.1 | Deterministic | Frontmatter grep | status: approved OR needs-revision only | 0 other values |
| EffAdj-AC1 | concise | §5.2 | Deterministic | wc -l per SKILL.md | Line count check | ≤200 per file |
| EffAdj-AC2 | single-concern | §5.2 | Manual | SKILL.md review | Single purpose per skill | 7/7 single-concern |
| ScalAdj-AC1 | topology-invariant | §5.3 | Deterministic | Orchestrator code review | Same logic for N=1 and N=6 | PASS |
| ScalAdj-AC2 | independently-invocable | §5.3 | Deterministic | Direct sub-skill invocation | Works without orchestrator | 6/6 sub-skills work directly |

---

## §8 Failure Modes & Recovery

### Build Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| Methodology extraction incomplete | deep-research methodology has undocumented sections | Diff original vs extracted | Manual review + add missing sections | Flag to Director before proceeding | N/A — prerequisite, must complete | N/A |
| Advanced EL content drift | Term alignment changes meaning, not just vocabulary | AI-graded section comparison drops below 95% | Revert to original; re-align specific section | Director reviews flagged sections | N/A — quality gate, must pass | N/A |
| EOP validator rejects skill | SKILL.md structure doesn't pass 23/23 | skill-validator.sh output | Fix reported violations; re-run | If structural (not cosmetic): review design decision | N/A | N/A |
| Legacy skill orphan reference | New skill references old skill name | Grep for legacy names | Update reference to new name | N/A | N/A | N/A |
| Context budget exceeded in structure | P-page generation overflows token limit | Model returns truncated output | Reduce scope: fewer mermaid blocks, shorter examples | Switch to summary mode (table only, no prose) | Partial P-pages with quality flag | 15 min |

---

## §9 Agent Behavioral Boundaries

### Build Phase Boundaries

**Always (safe actions — no approval needed):**
- Read any file in the worktree
- Run skill-validator.sh on any skill directory
- Create/edit skill files in `1-ALIGN/learning/skills/`
- Create `_shared/templates/RESEARCH_METHODOLOGY.md`
- Run grep/glob to check for orphan references

**Ask First (needs Director approval):**
- Delete legacy skill directories (confirm which ones, list them)
- Modify deep-research SKILL.md (shared methodology extraction may touch it)
- Rewrite Advanced EL doc (content drift risk — present diff for review)
- Commit to `feat/learn-skill-refactor` branch

**Never (hard stops):**
- Modify files outside the worktree
- Push to remote without explicit instruction
- Auto-approve any human gate in the learn pipeline design
- Skip EOP validation before committing skill changes
- Create a stored state file for the orchestrator (state must be derived)

### Model Selection Guidance

| Task Type | Model Tier | Rationale |
|-----------|-----------|-----------|
| Skill file writing (SKILL.md) | Opus | Precision required for EOP compliance + gate logic |
| Research methodology extraction | Opus | Must preserve exact protocol without drift |
| Advanced EL term alignment | Opus | Content preservation is critical |
| Legacy cleanup (grep, delete) | Sonnet/Haiku | Mechanical task, speed over reasoning |
| Validation script runs | Any | Deterministic — model doesn't matter |

---

## §10 Iteration Plan

### Master Scope Mapping

| A.C. ID | VANA Word | Criteria (short) | VANA Element | Iteration | Status |
|---------|-----------|------------------|--------------|-----------|--------|
| Verb-AC1 | orchestrate | State-aware routing | Verb | I1 | To Do |
| Verb-AC2 | interview | 9-question Learning Brief | Verb | I1 | To Do |
| Verb-AC3 | validate-eo | EO structure gate | Verb | I1 | To Do |
| Verb-AC4 | research | Parallel sub-agent dispatch | Verb | I1 | To Do |
| Verb-AC5 | verify-sources | Source count + URL check | Verb | I1 | To Do |
| Verb-AC6 | structure | Per-topic P0-P5 generation | Verb | I1 | To Do |
| Verb-AC7 | review | Per-topic causal spine + Q | Verb | I1 | To Do |
| Verb-AC8 | extract-spec | VANA-SPEC generation | Verb | I1 | To Do |
| Verb-AC9 | map-to-zones | P-page→zone mapping | Verb | I1 | To Do |
| Verb-AC10 | visualize | Interactive HTML system map | Verb | I2 | To Do |
| SustainAdv-AC1 | statelessly | Derived state, no stored file | Adverb (S) | I1 | To Do |
| SustainAdv-AC2 | gate-protected | Human approval at transitions | Adverb (S) | I1 | To Do |
| SustainAdv-AC3 | source-verified | Research source gates | Adverb (S) | I1 | To Do |
| SustainAdv-AC4 | escape-hatched | Tool failure documentation | Adverb (S) | I1 | To Do |
| SustainAdv-AC5 | actively-learned | Comprehension Qs in review | Adverb (S) | I1 | To Do |
| EffAdv-AC1 | context-bounded | Per-skill input loading | Adverb (E) | I1 | To Do |
| EffAdv-AC2 | single-maintained | Shared methodology file | Adverb (E) | I1 | To Do |
| EffAdv-AC3 | minimally-interactive | N+2 interactions minimum | Adverb (E) | I1 | To Do |
| ScalAdv-AC1 | per-topic-looped | Sequential topic processing | Adverb (Sc) | I1 | To Do |
| ScalAdv-AC2 | parallel-researched | Concurrent research dispatch | Adverb (Sc) | I1 | To Do |
| ScalAdv-AC3 | independently-visualized | Visualize decoupled from pipeline | Adverb (Sc) | I2 | To Do |
| Noun-AC1-AC7 | skill files | 7 skill SKILL.md files | Noun | I1 | To Do |
| Noun-AC8 | research-methodology | Shared methodology extracted | Noun | I1 | To Do |
| Noun-AC9 | advanced-el-reference | EL doc rewritten + aligned | Noun | I1 | To Do |
| Noun-AC10 | legacy-removed | Old skills cleaned up | Noun | I1 | To Do |
| SustainAdj-AC1 | EOP-compliant | 23/23 per skill | Adjective (S) | I1 | To Do |
| SustainAdj-AC2 | drift-free | EL doc content preserved | Adjective (S) | I1 | To Do |
| SustainAdj-AC3 | binary-gated | Approved/needs-revision only | Adjective (S) | I1 | To Do |
| EffAdj-AC1 | concise | SKILL.md ≤200 lines | Adjective (E) | I1 | To Do |
| EffAdj-AC2 | single-concern | 1 cognitive mode per skill | Adjective (E) | I1 | To Do |
| ScalAdj-AC1 | topology-invariant | Same path for 1 or N topics | Adjective (Sc) | I1 | To Do |
| ScalAdj-AC2 | independently-invocable | Sub-skills work without orchestrator | Adjective (Sc) | I1 | To Do |

### Iteration Sequencing

| Iteration | Name | Scope | Gate Criteria |
|-----------|------|-------|---------------|
| I1 | Core Pipeline | All Verb (except visualize) + all Adverb (S/E) + all Noun + all Adjective (S/E) + ScalAdv 1-2 + ScalAdj 1-2 | All I1 ACs pass eval; skill-validator 23/23 per skill |
| I2 | Visualization | Verb-AC10 (visualize) + ScalAdv-AC3 (independently-visualized) | React+Vite app renders; interactive; LTC brand |

**Rationale:** Nearly all ACs are I1 because this is a refactor of existing functionality — sustainability, efficiency, and scalability are not phased, they're table stakes. Visualization is I2 because it's a separate, on-demand companion (not blocking the core pipeline).

---

## §11 Integration Contracts

### INPUT CONTRACT — Learning Brief

| Field | Value |
|-------|-------|
| Source | Human Director via /learn:input interactive interview |
| Schema | Markdown file `learn-input-{slug}.md` with 9 named sections |
| Field Types | system_name (string), eo (structured string), raci_r/a (role strings), topics (list), depth (enum: overview/working/expert), domains (list) |
| Validation | EO must match `[User] [desired state] without [constraint]`; all 9 sections non-empty |
| Error | Re-prompt for invalid EO; flag empty sections |
| SLA | Completes in 1 interactive session |
| Version | v1.0 |

### INPUT CONTRACT — Research Methodology

| Field | Value |
|-------|-------|
| Source | `_shared/templates/RESEARCH_METHODOLOGY.md` (shared, read-only at runtime) |
| Schema | Markdown with 3 sections: Multi-Angle Search Protocol, Source Verification Protocol, Anti-Hallucination Protocol |
| Validation | File exists; 3 sections present |
| Error | If missing: block research skill; alert user to extract methodology first |
| SLA | Static file — always available |
| Version | v1.0 |

### OUTPUT CONTRACT — DSBV Readiness Package

| Field | Value |
|-------|-------|
| Consumer | DSBV process (`/dsbv design {zone}`) |
| Schema | Markdown file `DSBV-READY-{slug}.md` with C1-C6 checklist + P-page→zone mapping table |
| Field Types | C1-C6 (boolean + evidence string), mapping (P-page ID → zone artifact → specific section) |
| Validation | All C1-C6 = true; all 6 P-page types mapped |
| Error | Fail with gap report listing unmet conditions |
| SLA | Generated after all T0 pages approved — single invocation |
| Version | v1.0 |

### OUTPUT CONTRACT — VANA-SPEC (for learned subject)

| Field | Value |
|-------|-------|
| Consumer | DSBV DESIGN.md (zone-specific design spec) |
| Schema | VANA-SPEC following `_shared/templates/VANA_SPEC_TEMPLATE.md` structure |
| Validation | All §1-§11 sections present; every AC has binary threshold; traceability chain complete |
| Error | Missing sections flagged; broken traceability chains listed |
| SLA | Generated after all T0 pages approved — single invocation |
| Version | v1.0 |

---

## Traceability Chain

| A.C. ID | VANA Element | Design Decision | Brainstorming Source | EO Link |
|---------|-------------|----------------|---------------------|----------|
| Verb-AC1 | Verb | Orchestrator with derived state | Q3: option C | Orchestrates structured learning |
| Verb-AC2-AC3 | Verb | 9-Q interview + EO gate | Q1 + design:gates | Without vague EO |
| Verb-AC4-AC5 | Verb | Parallel research + source verification | Q5 + design:research | Producing approved P-pages |
| Verb-AC6 | Verb | Per-topic structure generation | Q1: separate skills | Producing approved P-pages |
| Verb-AC7 | Verb | Per-topic review + active learning | Q6 + design:review | Without passive rubber-stamping |
| Verb-AC8-AC9 | Verb | VANA extraction + zone mapping | Q4 + design:spec | DSBV-ready specs |
| Verb-AC10 | Verb | Interactive HTML visualization | Q6 + Q8: option A | Without passive rubber-stamping |
| SustainAdv-AC1 | Adverb (S) | Derived state, not stored | Q3: option C | Without state corruption |
| SustainAdv-AC2-AC5 | Adverb (S) | Gates + verification + escape hatches + active learning | S>E>Sc audit | Without context explosion or passive rubber-stamping |
| EffAdv-AC1-AC3 | Adverb (E) | Context bounding + shared methodology + minimal interaction | S>E>Sc audit | Orchestrates (efficiently) |
| ScalAdv-AC1-AC3 | Adverb (Sc) | Per-topic loop + parallel research + decoupled visualize | S>E>Sc audit | Structured learning pipelines (at any scale) |
| Noun-AC1-AC10 | Noun | 6+1 skills + shared assets + cleanup | Architecture diagram | All — these ARE the system |
| SustainAdj-AC1-AC3 | Adjective (S) | EOP compliance + drift-free + binary gates | EOP-GOV + Q9 | Without state corruption |
| EffAdj-AC1-AC2 | Adjective (E) | Concise + single-concern | EOP-07 + EP-09 | Orchestrates (efficiently) |
| ScalAdj-AC1-AC2 | Adjective (Sc) | Topology-invariant + independently-invocable | Scalability audit | Structured learning pipelines (at any scale) |
