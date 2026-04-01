---
version: "1.0"
last_updated: 2026-03-31
status: PENDING_DIRECTOR_APPROVAL
director: Manh N.
zone: 1-ALIGN
project: LTC Company Navigator
---

# ALIGN: LTC Company Navigator

## 1. Problem Statement

### Who
**Director Manh N.** — newly appointed human Director of the LTC AI-agent company, inherited from a previous Director (not Vinh N.).

### Situation
- The company template is **mature (Level 4 — MVE)**, but the Director is **new**
- Director has NOT yet created any projects or run the skill system
- Director is in an **onboarding/learning phase** — understanding from documentation

### What the Director Already Understands
- Vision, mission, and values of LTC
- The 4-Zone model (ALIGN -> PLAN -> EXECUTE -> IMPROVE) — conceptual
- DSBV process (Design -> Sequence -> Build -> Validate) — conceptual
- Three Pillars: Sustainability > Efficiency > Scalability
- Success Equation: Success = Efficient & Scalable Management of Failure Risks

### What the Director Needs to Learn
- How all 26 skills connect to each other and when to use each
- Where every resource (template, framework, SOP) lives and when to use it
- The full operational flow end-to-end (which skills activate at which stage)
- Session management (how sessions start, compress, resume)
- How resources cross-cut multiple subsystems (especially Director's own role at gates)

### Pain Points (All Four Identified)
1. **Navigation & orientation** — Hard to find things, structure feels overwhelming
2. **Agent effectiveness** — Unclear how agents follow frameworks (hasn't tested yet)
3. **Scaling & onboarding** — Unclear how to spin up new projects
4. **Governance overhead** — System feels heavy from the documentation side

### Root Cause
There is no single interactive map that lets the Director see the entire company and drill into any part of it.

---

## 2. Desired Outcome

A **comprehensive, interactive HTML file** that serves as the Director's primary navigation tool for the entire company — covering all skills, resources, workflows, and their interconnections.

### The Product Must:
1. Be **anchored to LTC constitutional frameworks** (ALPEI x DSBV x 7CS), NOT just current inventory
2. Be **maintainable**: when resources change, only mappings update, not the structure
3. Provide **one single place** to identify ALL resources
4. **Clearly show** when a resource (human, AI, tool) appears across multiple subsystems
5. Support **multi-layer drill-down** navigation
6. Follow **LTC brand identity** (colors, fonts, layout matching existing HTML artifacts)

### File Location
```
/Users/nvdmm/Desktop/[MANH N.]_Repo Template for LTC Project/LTC-COMPANY-NAVIGATOR.html
```

---

## 3. Interview Record — Key Decisions

| # | Question | Director's Decision | Rationale |
|---|----------|-------------------|-----------|
| 1 | Biggest pain points | All four: navigation, effectiveness, scaling, governance | New Director needs complete orientation |
| 2 | Session frustrations | Haven't tested yet — need to understand from docs first | Onboarding phase, not operational phase |
| 3 | Primary goal | Document & teach | Must understand system before improving it |
| 4 | Template maturity | Level 4 (MVE) | System is mature, Director is new |
| 5 | Focus areas | All: skills + resources + workflows + interconnections | Complete company map needed |
| 6 | Output format | Interactive HTML (like i1-artifact-flow-map.html) | Visual, interactive learning style |
| 7 | Output location | Desktop working copy repo | Working documents stay in working repo |
| 8 | Navigation model | Multi-layer drill-down | Overview -> departments -> individual items |
| 9 | Visual metaphor | Building/floor plan + Matrix (both, toggleable) | Intuitive overview + systematic detail |
| 10 | Resource registry | Heatmap overlay on 5x4 matrix | Select resource -> see where it's active |
| 11 | Structural anchor | ALPEI x DSBV x 7CS (constitutional, not inventory) | Maintainability over snapshot accuracy |

---

## 4. The Anchor Framework

The map is structured around three constitutional elements that DO NOT change:

### Element 1: ALPEI (5 Workstreams)
| Workstream | Purpose | Zone Folder |
|-----------|---------|-------------|
| ALIGN | Define the right outcome | 1-ALIGN/ |
| LEARN | Acquire knowledge | 1-ALIGN/learning/ |
| PLAN | Minimize risks via design | 2-PLAN/ |
| EXECUTE | Build and deliver | 3-EXECUTE/ |
| IMPROVE | Learn and grow | 4-IMPROVE/ |

### Element 2: DSBV (4 Phases per Workstream)
| Phase | Purpose | Human Gate |
|-------|---------|------------|
| Design (D) | Define what this workstream must produce | — |
| Sequence (S) | Order work and establish dependencies | — |
| Build (B) | Execute and create artifacts | — |
| Validate (V) | Verify quality, human approval | YES |

### Element 3: 7CS (7 Components per Subsystem)
| # | Component | Abbrev | What It Answers | Config Priority |
|---|-----------|--------|-----------------|-----------------|
| 1 | Effective Principles | EP | What rules govern this subsystem? | Highest |
| 2 | Input | Input | What feeds in? | 2nd |
| 3 | Effective Operating Procedures | EOP | What step-by-step process runs? | 3rd |
| 4 | Effective Operating Environment | EOE | Where does work happen? | 4th |
| 5 | Effective Operating Tools | EOT | What instruments are available? | 5th |
| 6 | Agent (LLM Model) | Agent | Which LLM executes? (uncontrollable) | 6th |
| 7 | Effective Action | EA | What observable execution happens? (emergent) | 7th |
| -> | Effective Outcome | EO | What does this subsystem produce? | Result |

### Combined: 5 x 4 = 20 Subsystems, Each with 7CS

```
              |  DESIGN (D)  |  SEQUENCE (S) |  BUILD (B)  |  VALIDATE (V) |
    ----------+--------------+---------------+-------------+---------------+
    ALIGN     |    A-D       |     A-S       |    A-B      |     A-V       |
    LEARN     |    L-D       |     L-S       |    L-B      |     L-V       |
    PLAN      |    P-D       |     P-S       |    P-B      |     P-V       |
    EXECUTE   |    E-D       |     E-S       |    E-B      |     E-V       |
    IMPROVE   |    I-D       |     I-S       |    I-B      |     I-V       |
```

### Iterative Flow (Agile, Not Linear)
- **Ideal:** A-V -> L-D -> L-V -> P-D -> P-V -> E-D -> E-V -> I-D -> I-V -> A-D (next iteration)
- **Real:** Any subsystem can loop back if gates reveal issues
- **Gates:** Director approval required at every V column before next workstream
- **Feedback loop:** I-V -> A-D (starts next iteration)

---

## 5. Stakeholders

| Role | Person/Entity | Responsibility |
|------|---------------|----------------|
| Director (Human) | Manh N. | Sole decision-maker, gate approver, product owner |
| Previous Director | Unknown (not Vinh N.) | Handed over the company |
| Framework Architect | Vinh N. | Created ALPEI framework (not active Director) |
| AI Agents | Claude Code, Cursor, AntiGravity | Execute tasks under Director's governance |
