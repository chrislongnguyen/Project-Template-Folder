---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# Effective Learning Framework (ELF)

The Effective Learning Framework is LTC's structured knowledge acquisition pipeline. It transforms a new subject or system into a standardized set of learning pages that capture the causal structure of success and failure — then extracts actionable specifications (VANA-SPEC) for the Build pipeline.

ELF is part of the Learn-Build Engine (LBE). This directory contains the skills, templates, and validation tools needed to run the full learning pipeline within any LTC project.

---

## Pipeline Flow

```
/learn             Orchestrator — derives state from file system, routes to correct sub-skill
     |
     v
/learn:input       Capture foundational inputs (EO, RACI, contracts, scope)
     |                 --> input/learn-input-{system}.md
     v
/learn:research    Deep research via parallel sub-agents (1 per topic)
     |                 --> research/{system}/T{n}-{topic}.md
     v
/learn:structure   Structure research into 6 P-pages per topic (1 topic at a time)
     |                 --> research/{system}/{topic}/P0.md through P5.md
     v
/learn:review      Per-topic human review (causal spine + active learning Qs)
     |                 --> status: approved on each page
     v
/learn:spec        Extract VANA-SPEC + generate DSBV Readiness Package
     |                 --> specs/{system}/vana-spec.md + DSBV-READY-{system}.md
     v
/learn:visualize   Interactive HTML system map (optional, I2)
                       --> learn-visual-{system}/ (React+Vite app)
```

---

## How ELF Output Maps to ALIGN Artifacts

ELF pages feed directly into project planning and design documents:

| ELF Page | Content | Feeds Into |
|----------|---------|------------|
| P0 (Overview & Summary) | System definition, EO, RACI, success/failure overview | `PROJECT_CHARTER.md` (purpose, scope, stakeholders) |
| P1 (Ultimate Blockers) | Root cause analysis of failure — causal chains | `2-PLAN/risks/UBS_REGISTER.md` (risk register, failure modes) |
| P2 (Ultimate Drivers) | Root cause analysis of success — causal chains | `2-PLAN/drivers/UDS_REGISTER.md` (success drivers, enablers) |
| P3 (Principles) | Governing principles bucketed by S/E/Sc pillars | `REQUIREMENTS.md` (quality criteria, adverb constraints) |
| P4 (Components) | 3-layer tool/environment stack (INFRA/WORKSPACE/INTEL) | `2-PLAN/architecture/SYSTEM_DESIGN.md` (component architecture) |
| P5 (Steps to Apply) | Sequential operating procedure (DERISK then OPTIMIZE) | `2-PLAN/roadmap/EXECUTION_PLAN.md` (phased implementation) |
| VANA-SPEC | Verb/Adverb/Noun/Adjective acceptance criteria | Both `REQUIREMENTS.md` (ACs) and `MASTER_PLAN.md` (iteration scope) |

---

## Learning PROCESS vs. ELF OUTPUT

The learning PROCESS varies per member:

- **Read/Write learners** — text-heavy research, written synthesis
- **Structured learners** — systematic decomposition, tables, frameworks
- **Visual learners** — diagrams, mind maps, spatial layouts
- **Audio/Kinesthetic learners** — discussion, hands-on experimentation

The ELF OUTPUT format is standard regardless of process. The 6-page structure (P0-P5) and the VANA-SPEC template are the canonical output format. Members reach ELF output through whichever learning process works for them.

---

## Could-Have, Not Must-Have

ELF is a could-have capability, not a must-have gate. Members can:

1. Use the full automated pipeline (`/learn` orchestrates `/learn:input` through `/learn:spec`)
2. Use only the templates manually (fill pages by hand)
3. Skip ELF entirely and produce ALIGN artifacts through their own process

The pipeline accelerates knowledge acquisition but does not block project execution.

---

## Directory Structure

```
learning/
  skills/                    Pipeline skill definitions
    learn/SKILL.md             Orchestrator — state-aware router (derives state from file system)
    learn-input/SKILL.md       Input capture — 9-question interview with EO validation gate
    learn-research/SKILL.md    Research — parallel sub-agents, shared methodology reference
    learn-structure/SKILL.md   Structure — per-topic P0-P5 generation, Opus fork
      references/                Structure rules, validation criteria, page dispatch
    learn-review/SKILL.md      Review — per-topic causal spine + active learning Qs
    learn-spec/SKILL.md        Spec — VANA extraction + DSBV Readiness Package
      references/                VANA extraction rules
    learn-visualize/SKILL.md   Visualize — interactive HTML system map (I2, deferred)
  templates/                 ELF output page templates
    learn-input-template.md    Input capture format
    page-0-overview-and-summary.md
    page-1-ultimate-blockers.md
    page-2-ultimate-drivers.md
    page-3-principles.md
    page-4-components.md
    page-5-steps-to-apply.md
    page-7-topic-distilled-understanding.md
    vana-spec-template.md      VANA specification template
  references/                Shared reference docs
    research-prompt-template.md  Research query template
  scripts/                   Validation tooling
    validate-learning-page.sh   CAG/row/column validation
  config/                    Engine constraints
    constraints.yaml            Hard rules (regex, row counts, terms)
```

---

## Source

Copied from the Learn Build Engine at `OPS_OE.6.1.LEARN-BUILD-ENGINE`. The LBE repo is the canonical source for these files. If the LBE is updated, re-copy to keep this template current.
