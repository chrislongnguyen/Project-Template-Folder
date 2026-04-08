---
type: framework
work_stream: 2-LEARN
sub_system: effective_learning
---

# Effective Learning — Learning Hierarchy & CODE Template

## Purpose of LEARN in the ALPEI Framework

The LEARN work stream exists to produce the **Effective System Design of the UES**. Learning is not an end in itself — it must produce three concrete outputs that feed into PLAN:

1. **UBS Analysis** (sections 1.0-1.6) — The Ultimate Blocking System, its drivers, its blockers, its principles, environment, tools, and procedure to overcome it
2. **UDS Analysis** (sections 2.0-2.6) — The Ultimate Driving System, its drivers, its blockers, its principles, environment, tools, and procedure to utilize it
3. **EP Derivation** (sections 3.0-3.5) — The Effective Principles derived from UBS and UDS analysis that govern the entire UES

These three outputs compose the core of the **8-component Effective System Design** (EI, EU, EA, EO, **EP**, EOE, EOT, EOP), which then defines the environment (EOE), tools (EOT), and procedures (EOP) needed for effective execution.

```
LEARN Output (Effective System Design)
│
├── 1. UBS Analysis ─── What blocks success?
│   ├── 1.0 UBS overview, outcomes, actions
│   ├── 1.1 UBS.UB — blockers of the blocker
│   ├── 1.2 UBS.UD — drivers of the blocker (to disable)
│   ├── 1.3 UBS.Principles
│   ├── 1.4 UBS.Environment
│   ├── 1.5 UBS.Tools
│   └── 1.6 UBS.Procedure (steps to overcome)
│
├── 2. UDS Analysis ─── What drives success?
│   ├── 2.0 UDS overview, outcomes, actions
│   ├── 2.1 UDS.UB — blockers of the driver (to remove)
│   ├── 2.2 UDS.UD — drivers of the driver (to amplify)
│   ├── 2.3 UDS.Principles
│   ├── 2.4 UDS.Environment
│   ├── 2.5 UDS.Tools
│   └── 2.6 UDS.Procedure (steps to utilize)
│
└── 3. EP Derivation ─── What principles govern the system?
    ├── 3.0 EP overview (derived from UBS + UDS)
    ├── 3.1 EP.UB — what blocks the principles
    ├── 3.2 EP.UD — what enables the principles
    ├── 3.3 EP.Principles
    ├── 3.4 EP.Environment
    └── 3.5 EP.Procedure
        │
        └──> Feeds into: EOE design, EOT design, EOP design
```

## The 4 Stages of LEARN

Each sub-system (PD, DP, DA, IDM) runs LEARN through 4 stages:

| Stage | Purpose | Output |
|---|---|---|
| **Design** | Define what to learn — root causes, failure mechanisms, success drivers, knowledge gaps | Learning scope; prioritized research questions; data collection plan |
| **Design** | Design research approach for UBS/UDS diagnosis; draft effective principles | UBS/UDS diagnosis design; draft EP; draft solution architecture |
| **Build** | Execute UBS/UDS analysis; validate findings; produce effective principles and solution design | **Completed UBS; Completed UDS; Finalized EP; Solution design** |
| **Validate** | Verify diagnosis is rigorous, evidence-based, complete, and actionable | Validated learning package → PLAN |

## The Learning Hierarchy

To produce quality UBS/UDS/EP analysis, learning must progress through four levels:

### Level 1: Knowledge — Build the factual foundation

| Question | Purpose | UBS/UDS Application |
|---|---|---|
| **So What?** | Why is this important? | Why does this blocker/driver matter to the UES? |
| **What is it?** | Definition and scope | What exactly is this UBS/UDS? |
| **What else?** | Related concepts | What other blockers/drivers are connected? |
| **How does it work?** | Mechanisms | How does this blocker block? How does this driver drive? |

### Level 2: Understanding — Discover the why

| Question | Purpose | UBS/UDS Application |
|---|---|---|
| **Why does it work?** | Underlying principles | What principles enable this UBS/UDS? (→ feeds EP) |
| **Why not?** | Failure conditions | When does this blocker/driver stop operating? |

### Level 3: Wisdom — Determine what to do

| Question | Purpose | UBS/UDS Application |
|---|---|---|
| **So What?** | Implications | How does this affect our system design? |
| **Now What?** | Next actions | What EP, EOE, EOT, EOP should we design? |

### Level 4: Expertise — Go deeper for critical areas

| Question | Purpose | UBS/UDS Application |
|---|---|---|
| **What is it NOT?** | Misconceptions | Common misdiagnoses of this blocker/driver |
| **How does it NOT work?** | Anti-patterns | Failed approaches to addressing this UBS/UDS |
| **What If?** | Contingencies | Alternatives if our mitigation/leverage plan fails |
| **Now What?** | Competitive edge | How can we address this better than others? |

## The CODE Template

Every learning artifact should follow the CODE structure:

1. **C**ategory — What part of the Effective System Design does this address? (UBS? UDS? EP? EOE? EOT? EOP?)
2. **O**verview — What is it and why does it matter for the UES?
3. **D**etails — Components and mechanisms (using the Learning Hierarchy above)
4. **E**xecution — How does this feed into the Effective System Design? What EP, EOE, EOT, EOP decisions result?

## How Each Sub-System Uses LEARN

| Sub-System | LEARN Produces | Feeds Into |
|---|---|---|
| **PD** | UBS/UDS of the **problem domain**; EP for the **entire UES**; design guidelines for all downstream sub-systems | PD-Plan + DP/DA/IDM (as foundational principles) |
| **DP** | UBS/UDS of the **data pipeline** (quality gaps, unreliable sources, automation potential); pipeline principles | DP-Plan |
| **DA** | UBS/UDS of the **analysis methods** (misleading correlations, bias, overfitting, robust methods); analysis principles | DA-Plan |
| **IDM** | UBS/UDS of **insight delivery** (info overload, misinterpretation, alert fatigue, clear hierarchy); IDM principles | IDM-Plan |

> **Critical:** PD-Learn produces the effective principles and design guidelines that govern the **entire UES**. All downstream sub-systems (DP, DA, IDM) inherit and specialize PD-Learn's output.

## Templates

Use these templates for structured learning:

- **[[TEMPLATES - Effective System Design (UES)]]** — The primary LEARN output template (UBS + UDS + EP → EOE + EOT + EOP)
- **[[TEMPLATES - Research (CODE Framework)]]** — For deep-dive research using the Learning Hierarchy
- **[[TEMPLATES - Spike Investigation]]** — For time-boxed investigations using the Critical Thinking model

All in `0. REUSABLE RESOURCES/0.3. TEMPLATES/`

## Related

- [[COE EFF_EFFECTIVENESS - AREA TRAINING MATERIALS -2. Effective System Design]] — The full 8-component model
- [[COE EFF_EFFECTIVENESS - AREA TRAINING MATERIALS -1. Truths We Need to Master to Succeed]] — 10 Ultimate Truths
- [[ALPEI Framework by Sub-Systems]] — How LEARN fits in the 80-cell matrix
- [[EFFECTIVE RISK MANAGEMENT - UBS & UDS Framework]] — Detailed UBS/UDS methodology

## Links

- [[DESIGN]]
- [[VALIDATE]]
- [[anti-patterns]]
- [[architecture]]
- [[blocker]]
- [[methodology]]
