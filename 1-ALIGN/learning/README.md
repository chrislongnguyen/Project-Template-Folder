# Effective Learning Framework (ELF)

The Effective Learning Framework is LTC's structured knowledge acquisition pipeline. It transforms a new subject or system into a standardized set of learning pages that capture the causal structure of success and failure — then extracts actionable specifications (VANA-SPEC) for the Build pipeline.

ELF is part of the Learn-Build Engine (LBE). This directory contains the skills, templates, and validation tools needed to run the full learning pipeline within any LTC project.

---

## Pipeline Flow

```
/learn:input       Capture foundational inputs (EO, RACI, contracts, scope)
     |                 --> learn-input-{system}.md
     v
/learn:research    Deep research via parallel sub-agents (1 per topic)
     |                 --> research/{system}/T{n}-{topic}.md
     v
/learn:structure   Structure research into 6 UEDS pages per topic
     |                 --> learning-output/{system}/T{n}.P0-P5.md
     v
/learn:review      Human review gate (validate + approve all pages)
     |                 --> status: approved on each page
     v
/spec:extract      Extract VANA grammar from approved T0 pages
     |                 --> specs/{system}/vana-spec.md
     v
/spec:handoff      Human Director review + Build pipeline activation
                       --> specs/{system}/GSD-STATE.md
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

1. Use the full automated pipeline (`/learn:input` through `/spec:handoff`)
2. Use only the templates manually (fill pages by hand)
3. Skip ELF entirely and produce ALIGN artifacts through their own process

The pipeline accelerates knowledge acquisition but does not block project execution.

---

## Directory Structure

```
learning/
  skills/                    Pipeline skill definitions
    learn-input/SKILL.md       Phase 0: interview + input capture
    learn-research/SKILL.md    Phase 1: parallel deep research
    learn-structure/SKILL.md   Phase 2: structure into UEDS pages
      references/                Structuring procedure, validation rules, dispatch table
    learn-review/SKILL.md      Phase 3: human review gate
    spec-extract/SKILL.md      Phase 4: VANA-SPEC extraction
    spec-handoff/SKILL.md      Phase 5: Human Director handoff
    learn-pipeline/SKILL.md    Master pipeline orchestrator
      references/                Research prompt template
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
