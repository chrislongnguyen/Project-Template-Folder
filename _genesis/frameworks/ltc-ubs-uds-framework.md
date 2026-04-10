---
type: framework
work_stream: _genesis
sub_system:
version: "1.0"
status: draft
last_updated: 2026-04-10
---

# Effective Risk Management — UBS & UDS Framework

## Core Principle

> Success = Efficient & Scalable Management of Failure Risks (Ultimate Truth #5)

Risk management is not a phase — it is **woven through every work stream and every stage**. The UBS/UDS framework is the analytical backbone of the LEARN work stream, producing the core of the Effective System Design.

## The UBS/UDS Framework as LEARN Output

The LEARN work stream must produce three deliverables that together form the Effective System Design:

```
LEARN produces:
├── 1. UBS Analysis (sections 1.0-1.6) → What blocks success?
├── 2. UDS Analysis (sections 2.0-2.6) → What drives success?
└── 3. EP Derivation (sections 3.0-3.5) → What principles govern the system?
    │
    └──> Feeds into PLAN as the foundation for execution decisions
```

## UBS — Ultimate Blocking System (Sections 1.0-1.6)

The UBS is the root-cause system that blocks success. Not the symptom — the mechanism.

### Section Structure

| Section | Name | Key Question | Output |
|---|---|---|---|
| **1.0** | UBS Overview | What is the blocking system? What are its outcomes and actions? | UBS definition, scope, and impact |
| **1.1** | UBS.UB | What blocks the blocker from being overcome? (meta-blockers) | Obstacles to mitigation |
| **1.2** | UBS.UD | What drives the blocker? What makes it persist? | Root causes to disable |
| **1.3** | UBS.Principles | What principles does the blocking system operate on? | Failure principles → feeds EP |
| **1.4** | UBS.Environment | What environmental conditions enable the blocker? | Environment factors to change |
| **1.5** | UBS.Tools | What tools does the blocker use or exploit? | Tool gaps to address |
| **1.6** | UBS.Procedure | What are the steps to overcome this blocking system? | Mitigation procedure |

### For Each UBS Section, Analyze Both Sides

Every section has its own drivers (UD) and blockers (UB):

```
UBS.UD (what makes the blocker persist)
├── UBS.UD.UD — what amplifies the persistence
├── UBS.UD.UB — what could weaken the persistence
└── UBS.UD.Principles — principles behind the persistence

UBS.UB (what blocks us from overcoming the blocker)
├── UBS.UB.UD — what enables us to overcome
├── UBS.UB.UB — what double-blocks us
└── UBS.UB.Principles — principles behind the meta-blocker
```

## UDS — Ultimate Driving System (Sections 2.0-2.6)

The UDS is the root-cause system that drives success. The flip side of UBS.

### Section Structure

| Section | Name | Key Question | Output |
|---|---|---|---|
| **2.0** | UDS Overview | What is the driving system? What are its outcomes and actions? | UDS definition, scope, and impact |
| **2.1** | UDS.UB | What blocks the driver from working? (what prevents success) | Obstacles to leverage → feeds EP |
| **2.2** | UDS.UD | What amplifies the driver? What makes it stronger? | Amplifiers to enable |
| **2.3** | UDS.Principles | What principles does the driving system operate on? | Success principles → feeds EP |
| **2.4** | UDS.Environment | What environmental conditions enable the driver? | Environment to create |
| **2.5** | UDS.Tools | What tools does the driver use or require? | Tools to acquire |
| **2.6** | UDS.Procedure | What are the steps to utilize this driving system? | Leverage procedure |

## EP — Effective Principles Derivation (Sections 3.0-3.5)

EP is the foundation of the Effective System Design. It is **derived** from UBS and UDS analysis — not invented independently.

### The EP Derivation Formula

**Sustainability — Minimize Failure Risks:**

```
EP(minimize risk) = UBS.UD.Principles + UBS.UD.UD.Principles + UBS.UB.UB.Principles
                  + UDS.UB.Principles + UDS.UB.UD.Principles + UBS.UD.UB.Principles
```

**Sustainability — Produce Desired Outcomes:**

```
EP(maximize output) = UDS.UD.Principles + UDS.UD.UD.Principles + UDS.UB.UB.Principles
                    + UBS.UB.Principles + UBS.UD.UB.Principles + UBS.UB.UD.Principles
```

### EP Then Feeds Into

| Component | Derived From | Purpose |
|---|---|---|
| **EOE** (Environment) | All environment-related findings from UBS + UDS analysis | Design the operating environment that follows EP |
| **EOT** (Tools) | All tool-related findings from UBS + UDS analysis | Select tools that follow EP |
| **EOP** (Procedure) | All procedure-related findings from UBS + UDS analysis | Design procedures that follow EP |

## Risk Management Across the 80-Cell Matrix

| Work Stream | Stage | How Risk Manifests |
|---|---|---|
| **ALIGN** | Design | Initial risk register — what could go wrong with scope? |
| **ALIGN** | Design | Risk mitigation plan in master plan |
| **ALIGN** | Validate | Cross-reference risks with LEARN findings |
| **LEARN** | Design | Learning risk register — what are the unknown unknowns? |
| **LEARN** | Build | **UBS/UDS/EP analysis — the core risk identification** |
| **LEARN** | Validate | Verify diagnosis is evidence-based |
| **PLAN** | Design | Planning risk register — can we deliver on time? |
| **PLAN** | Design | Derisk-first sequencing — sustainability before efficiency |
| **PLAN** | Validate | Verify plan is realistic and risk-managed |
| **EXECUTE** | Design | Blocker log — catch blockers before work begins |
| **EXECUTE** | Build | Quality gates check three pillars |
| **EXECUTE** | Validate | Defect log — what broke and why? |
| **IMPROVE** | Design | Feedback risk register — what could go wrong with feedback? |
| **IMPROVE** | Build | Risk events + near misses — what actually happened vs. predicted |
| **IMPROVE** | Validate | Were risk priorities fair and evidence-based? |

## Templates

- **[[TEMPLATES - Effective System Design (UES)]]** — Full UBS + UDS + EP → EOE + EOT + EOP template
- **[[TEMPLATES - UBS Risk Entry]]** — Individual blocker entry
- **[[TEMPLATES - UDS Driver Entry]]** — Individual driver entry

All in `0. REUSABLE RESOURCES/0.3. TEMPLATES/`

## Related

- [[COE EFF_EFFECTIVENESS - AREA TRAINING MATERIALS -2. Effective System Design]] — The full 8-component model
- [[COE EFF_EFFECTIVENESS - AREA TRAINING MATERIALS -1. Truths We Need to Master to Succeed]] — 10 Ultimate Truths
- [[EFFECTIVE LEARNING - Learning Hierarchy & CODE Template]] — How to learn effectively to produce quality UBS/UDS/EP
- [[ALPEI Framework by Sub-Systems]] — How risk management fits across all 80 cells

## Links

- [[DESIGN]]
- [[VALIDATE]]
- [[blocker]]
