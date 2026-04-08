---
version: "2.3"
status: draft
last_updated: 2026-04-06
work_stream: 2-LEARN
type: template
iteration: 2
---

# 2-LEARN — Understand Before You Act

> "What are the blockers? What are the drivers? What principles govern this system?"

## Purpose

Most frameworks collapse learning into alignment or planning. ALPEI separates it deliberately — because the failure risk is not that teams lack intent (ALIGN covers that), but that they plan from assumptions instead of evidence.

Teams that skip LEARN jump from a charter to an architecture. The architecture collapses against the first real constraint — because no one identified what actually blocks success (UBS) or what drives it (UDS). By the time the mistake surfaces, significant execution effort is already committed.

LEARN produces the **Effective System Design** — the 8-component blueprint that governs every decision in PLAN and EXECUTE. Without it, the Effective Principles that constrain your entire system do not exist. The downstream workstreams are building on unexamined assumptions.

---

## The Human PM as Primary Learner

**LEARN is the most important contribution of the human PM to the workspace.** It is the critical junction between human judgment and AI execution:

```
External Sources                         AI Agents
(stakeholders, books, courses,    →     (plan, execute, improve
 articles, videos, mentors,              based on what PM learned)
 lived experience, failure memory)
         │                                       ▲
         ▼                                       │
    1-ALIGN  ──→  2-LEARN  ──→  3-PLAN / 4-EXECUTE / 5-IMPROVE
```

The PM actively acquires knowledge from diverse sources. The AI agent assists with capture, synthesis, and retrieval — but cannot replace the PM's judgment, contextualization, and deep understanding of the domain.

**This is the one workstream where human involvement is not optional at any stage.**

### Learning Source Types

| Source Type | Examples | Capture Method |
|-------------|----------|---------------|
| **Books** | Business, investing, management, technical | Highlights + key insights via `/vault-capture` |
| **Online courses** | MOOCs, professional certifications | Lesson summaries + reflections |
| **Articles and papers** | Research, industry analysis, news | Key findings + implications |
| **Videos and podcasts** | YouTube, webinars, expert talks | Key takeaways + timestamps |
| **Conversations** | Mentors, colleagues, stakeholders | Action items + insights → daily note |
| **Lived experience** | Observations, experiments, failures | Reflections + lessons learned |
| **NotebookLM outputs** | Audio overviews, mind maps, study guides | Pull artifacts back into vault (derived, not primary) |

### Learning Tools

| Tool | What it does |
|------|-------------|
| **Obsidian vault** | Primary knowledge capture, organization, and linking across all subsystems |
| **`/vault-capture`** | Quick capture from any source, auto-routed to correct subsystem subfolder |
| **`/learn`** | State-aware orchestrator — detects pipeline state from file system, routes to correct sub-skill |
| **`/learn:input`** | S1 — Scopes what to research, defines research questions by risk |
| **`/learn:research`** | S2 — Deep research with sources and evidence |
| **`/learn:structure`** | S3 — Organizes findings into structured P-pages |
| **`/learn:review`** | S4 — Human review gate; you approve before synthesis continues |
| **`/learn:spec`** | S5 — Derives Effective Principles (VANA-SPEC) from validated findings |
| **Daily notes** | Daily learning log and reflections — the PM's running journal |

---

## The Learning Pipeline

LEARN uses a **6-state pipeline** with its own state-detection logic. The pipeline is state-driven — `/learn` detects what files exist and auto-routes to the next skill. No skips allowed.

```
S1 Scope  →  S2 Research  →  S3 Structure  →  S4 Review  →  S5 Spec  →  Complete
   │              │               │               │             │
/learn:input  /learn:research  /learn:structure  /learn:review  /learn:spec
   │              │               │               │             │
input/        research/         output/       (status)       specs/
```

| State | Skill | What Happens | Output Location |
|-------|-------|-------------|-----------------|
| **S1 — Scope** | `/learn:input` | Define what to learn, research questions, boundaries | `input/` |
| **S2 — Research** | `/learn:research` | Gather evidence, investigate sources, deep research | `research/` |
| **S3 — Structure** | `/learn:structure` | Analyze UBS/UDS, organize into structured pages (P0–P5) | `output/` |
| **S4 — Review** | `/learn:review` | Human reviews all pages, approves or sends back | status changes |
| **S5 — Spec** | `/learn:spec` | Derive Effective Principles from UBS/UDS findings | `specs/` |
| **Complete** | — | Validated learning package ready for → 3-PLAN | — |

State is derived from the file system on every `/learn` invocation — no stored state file.

> **Note on DESIGN.md / SEQUENCE.md / VALIDATE.md files in each subsystem dir:** These are workstream-management meta-artifacts — they govern how the LEARN workstream itself is designed and validated as a system. They are NOT the learning pipeline. The actual learning content flows through the 6-state pipeline above.

### Pipeline Directory Map

The learning pipeline stages content through `_cross/` subdirectories. Each state in the pipeline writes to a specific location:

```
2-LEARN/_cross/
├── input/       — S1: learning briefs, raw captures, learn-input-{slug}.md files
├── research/    — S2: structured research per topic, evidence files
├── output/      — S3+S4: structured P-pages (P0–P5 per topic), status set by review
├── specs/       — S5: VANA-SPEC + Readiness Packages per system slug
├── scripts/     — Pipeline validation scripts (validate-learning-page.sh, etc.)
├── config/      — Pipeline configuration files
├── visual/      — Interactive HTML system maps generated by /learn:visualize
├── references/  — Shared bibliography and source registry
└── templates/   — Shared artifact templates (subsystem-specific templates derive from these)
```

Skills route to these directories automatically — do not place pipeline content in subsystem dirs (1-PD/, 2-DP/, etc.) unless it is subsystem-specific and not shared.

---

## The Learning Hierarchy

Not all learning is equal. The depth required depends on the risk of getting it wrong.

| Level | Questions | Min Acceptable |
|-------|-----------|---------------|
| **1 — Knowledge** | What? How? Why is this important? | — |
| **2 — Understanding** | Why does it work? Why does it fail? | Minimum for any decision |
| **3 — Wisdom** | So what? Now what? What tradeoffs does this create? | Required for architecture |
| **4 — Expertise** | What is it NOT? What if the assumption breaks? | Critical areas only |

Building a system from Level 1 (knowledge only) produces architectures that look correct but break at edge cases the PM never understood. The pipeline gates at S4 (Review) exist to enforce Level 2 minimum before synthesis proceeds.

---

## The Critical Output: Effective System Design

LEARN produces 5 of the 8 components of the Effective System Design. PLAN designs the remaining 3.

```
┌──────────────────────────────────────────────────────────────┐
│                  EFFECTIVE SYSTEM DESIGN                      │
│                                                               │
│  LEARN produces:                  PLAN designs:              │
│  ┌─────────────────────────┐      ┌─────────────────────┐    │
│  │ EI  — Effective Inputs  │      │ EOE — Environment   │    │
│  │ EU  — Effective Users   │      │ EOT — Tools         │    │
│  │ EA  — Effective Actions │      │ EOP — Procedure     │    │
│  │ EO  — Effective Outputs │      └─────────────────────┘    │
│  │ EP  — Eff. Principles   │                                  │
│  └─────────────────────────┘                                  │
│                                                               │
│  DERIVED FROM:                                                │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────────┐     │
│  │   UBS    │   │   UDS    │   │   EP (S / E / Sc)    │     │
│  │ blockers │   │  drivers │   │ derived from          │     │
│  │ +drivers │   │ +blockers│   │ UBS + UDS analysis    │     │
│  └──────────┘   └──────────┘   └──────────────────────┘     │
└──────────────────────────────────────────────────────────────┘
```

---

## UBS Analysis — What Blocks Success

The **Ultimate Blocking System** is the organized set of forces that will prevent your system from succeeding if not addressed. It is not a list of risks — it is a structured diagnosis of the root-cause system that generates those risks.

**UBS Analysis Structure (sections 1.0–1.6):**

| Section | Question |
|---------|---------|
| **1.0 Overview** | What is the blocking system? What are its actions and outcomes? |
| **1.1 UBS.UB** | What are the ultimate blockers of the UBS — what prevents it from being overcome? |
| **1.2 UBS.UD** | What are the ultimate drivers of the UBS — what makes it persist? (These must be disabled.) |
| **1.3 UBS.Principles** | What principles does the blocking system operate on? |
| **1.4 UBS.Environment** | What environmental conditions do the blockers require to exist? |
| **1.5 UBS.Tools** | What tools do the blockers use? |
| **1.6 UBS.Procedure** | What are the steps to overcome the blocking system? |

---

## UDS Analysis — What Drives Success

The **Ultimate Driving System** is the organized set of forces that, when activated and sustained, produce the desired outcome. It mirrors the UBS structure so the two analyses can be directly compared during EP derivation.

**UDS Analysis Structure (sections 2.0–2.6):**

| Section | Question |
|---------|---------|
| **2.0 Overview** | What is the driving system? What are its actions and outcomes? |
| **2.1 UDS.UB** | What are the ultimate blockers of the UDS — what prevents the driver from working? |
| **2.2 UDS.UD** | What are the ultimate drivers of the UDS — what amplifies success? |
| **2.3 UDS.Principles** | What principles does the driving system operate on? |
| **2.4 UDS.Environment** | What environmental conditions do the drivers require? |
| **2.5 UDS.Tools** | What tools do the drivers use? |
| **2.6 UDS.Procedure** | What are the steps to activate and sustain the driving system? |

---

## EP Derivation — Three Types of Effective Principles

Effective Principles are not invented. They are derived from UBS and UDS findings using specific derivation formulas. There are three types, each answering a different strategic question.

**S-Principle (Sustainability) — Minimize Failure Risks:**
```
EP_S = UBS.UD.Principles + UBS.UD.UD.Principles + UBS.UB.UB.Principles
     + UDS.UB.Principles + UDS.UB.UD.Principles + UBS.UD.UB.Principles
```
Question: What principles prevent the system from breaking?

**E-Principle (Efficiency) — Maximize Desired Outcomes:**
```
EP_E = UDS.UD.Principles + UDS.UD.UD.Principles + UDS.UB.UB.Principles
     + UBS.UB.Principles + UBS.UD.UB.Principles + UBS.UB.UD.Principles
```
Question: What principles maximize output while keeping the system safe?

**Sc-Principle (Scalability) — Future-Proof:**
Built on S + E at I4 (Leadership iteration). Governs self-improvement and disproportionate growth.
Question: What principles allow the system to grow and self-optimize?

EP feeds into EOE, EOT, and EOP design in 3-PLAN. Any principle that cannot be traced to a UBS or UDS finding is an unvalidated assumption — reject it.

---

## Subsystem Flow

```
1-PD  ──►  2-DP  ──►  3-DA  ──►  4-IDM
 │
 └─► Effective Principles from PD govern ALL downstream subsystems
```

| Subsystem | LEARN Focus | Key Inputs | Key Outputs |
|-----------|------------|-----------|------------|
| **1-PD** | Diagnose the problem — identify UBS/UDS for the problem space; produce effective principles and design guidelines for the **entire UES** | Validated alignment from PD-ALIGN; known unknowns; existing domain knowledge | Completed UBS+UDS; finalized EP; solution design; **design guidelines → DP, DA, IDM** |
| **2-DP** | Research transformation methods, input formats, processing requirements — identify transformation-specific UBS/UDS | **Principles from PD** + validated DP-ALIGN; input source requirements; toolchain constraints | Transformation UBS (quality gaps, unreliable sources, format drift); transformation UDS (automation, standardization); transformation principles → DP-PLAN |
| **3-DA** | Test analytical methods and logic patterns; validate assumptions — identify analysis-specific UBS/UDS | **Principles from PD** + validated DA-ALIGN; transformation standards from DP; sample inputs | Analysis UBS (misleading patterns, bias, brittle logic); analysis UDS (robust methods, validation); analysis principles → DA-PLAN |
| **4-IDM** | Research output presentation, decision workflows, feedback channels — identify delivery-specific UBS/UDS | **Principles from all upstream** + validated IDM-ALIGN; consumer decision-making context | Delivery UBS (info overload, misinterpretation, adoption failure); delivery UDS (clarity, actionability); delivery principles → IDM-PLAN |

> **Critical:** PD produces the effective principles that govern the entire UES. DP, DA, and IDM inherit and build on them — they do not produce independent principles that contradict PD.

---

## Folder Structure

```
2-LEARN/
├── 1-PD/                   # Problem Diagnosis LEARN
│   ├── input/              # S1: scoping docs, research questions, raw captures
│   ├── research/           # S2: structured UBS/UDS research, evidence files
│   ├── output/             # S3: structured P-pages (P0–P5 per topic)
│   ├── specs/              # S5: VANA-SPEC and derived Effective Principles
│   └── archive/            # Rejected hypotheses, superseded drafts
├── 2-DP/                   # Data Pipeline LEARN
│   ├── input/
│   ├── research/
│   ├── output/
│   ├── specs/
│   └── archive/
├── 3-DA/                   # Data Analytics LEARN
│   ├── input/
│   ├── research/
│   ├── output/
│   ├── specs/
│   └── archive/
├── 4-IDM/                  # Insight Delivery & Management LEARN
│   ├── input/
│   ├── research/
│   ├── output/
│   ├── specs/
│   └── archive/
└── _cross/                 # Cross-cutting: shared frameworks, reusable UBS/UDS patterns
    ├── config/
    ├── references/
    ├── scripts/
    └── templates/
```

---

## Templates

| Pipeline State | Template |
|---------------|---------|
| S1 — Scope | [`research-methodology.md`](_genesis/templates/research-methodology.md) — research methodology design |
| S2 — Research | [`research-template.md`](_genesis/templates/research-template.md) — CODE framework research |
| S2 — Spike | [`spike-template.md`](_genesis/templates/spike-template.md) — spike/investigation template |
| S5 — Spec | [`vana-spec-template.md`](_genesis/templates/vana-spec-template.md) — VANA specification extraction |

---

## Pre-Flight Checklist

### S1 — Scope
- [ ] System slug identified and named
- [ ] Research questions defined — prioritized by blocking risk
- [ ] Boundaries explicit — what is explicitly out of scope?
- [ ] `input/learn-input-{slug}.md` exists in the target subsystem

### S2 — Research
- [ ] Every claim has a cited source
- [ ] `research/{slug}/` directory created with topic files
- [ ] Blocking forces (UBS) and driving forces (UDS) both present — not one-sided

### S3 — Structure
- [ ] P0–P5 pages exist for each topic in the research dir
- [ ] UBS Analysis (1.0–1.6) complete
- [ ] UDS Analysis (2.0–2.6) complete
- [ ] Each page is coherent — can stand alone as a structured document

### S4 — Review
- [ ] Human PM has reviewed every P-page
- [ ] Status set to `validated` on reviewed pages — by human, not agent
- [ ] Rejected pages returned to S3 with specific correction notes

### S5 — Spec
- [ ] `specs/{slug}/vana-spec.md` exists
- [ ] Every EP traces to a UBS or UDS finding — no unsupported principles
- [ ] S-Principles, E-Principles derivation formulas applied
- [ ] Validated learning package ready for → 3-PLAN

---

## How LEARN Connects

```
                        validated alignment package
1-ALIGN  ───────────────────────────────────────>  2-LEARN
                                                       │
                                        UBS + UDS + EP
                                        (Effective System Design: EI EU EA EO EP)
                                                       │
                                                       ▼
                                                    3-PLAN
                                              (designs EOE EOT EOP)

2-LEARN ──"new blocker found"──────> 2-LEARN   (deepen within workstream)
2-LEARN ──"scope gap found"────────> 1-ALIGN   (re-align before continuing)
3-PLAN  ──"assumption challenged"──> 2-LEARN   (loop back before committing)
4-EXECUTE ──"hit unknown"──────────> 2-LEARN   (loop back mid-execution)
5-IMPROVE ──"lessons learned"──────> 2-LEARN   (institutionalize findings)
```

Every other workstream can loop back into LEARN when unknowns are hit. The learning pipeline is not a one-time event — it is a living resource the entire project relies on.

---

## DASHBOARDS

![[09-learning-overview.base]]

## Links

- [[AGENTS]]
- [[BLUEPRINT]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[architecture]]
- [[blocker]]
- [[charter]]
- [[iteration]]
- [[methodology]]
- [[project]]
- [[research-methodology]]
- [[research-template]]
- [[spike-template]]
- [[vana-spec-template]]
- [[workstream]]
