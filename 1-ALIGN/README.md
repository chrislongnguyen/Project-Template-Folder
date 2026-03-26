# ZONE 1 — ALIGN (Choose the Right Outcome + Learn)

> "Are we solving the right problem? Is everyone aligned? Do we know enough?"

**Workstreams:** ALIGN (Self/Team Alignment) + LEARN (Effective Learning)
**Derived From:** Ultimate Truth #7 (Work Stream 1 & 3); Agile SOP 2.1 Alignment Meeting; SOP 2.2 OKR Planning

---

## Purpose

Before anything in this project moves forward, every item here must be green.
This zone prevents the #1 risk in any project: **building the wrong thing**.

LEARN is embedded inside ALIGN because **learning is how you resolve unknowns before committing to a plan**. The learning pipeline identifies unknowns, targets research, and produces structured knowledge (ELF pages, VANA specs, GSD states) that directly transform into alignment artifacts.

```
                    ┌────────────────────────────────────────┐
                    │            1-ALIGN                      │
                    │                                         │
                    │  charter/   okrs/   decisions/          │
                    │      ▲        ▲        ▲               │
                    │      │        │        │               │
                    │  ┌───┴────────┴────────┴───┐           │
                    │  │       learning/          │           │
                    │  │                          │           │
                    │  │  input/ → research/ →    │           │
                    │  │    output/ → specs/       │           │
                    │  └──────────────────────────┘           │
                    └────────────────────────────────────────┘
                         │                          ▲
                         ▼                          │
                      2-PLAN                    4-IMPROVE
```

## Contents

| Subfolder | Contains | Key Question |
|-----------|----------|--------------|
| `charter/` | Project Charter, Stakeholders, Requirements | Why does this project exist? Who does it serve? |
| `okrs/` | Objectives & Key Results | What outcomes define success? How do we measure them? |
| `decisions/` | Architecture Decision Records | What non-trivial choices have we made and why? |
| `learning/` | Learning pipeline (input, research, output, specs) | What do we not know? How do we resolve unknowns? |

### Learning Sub-Pipeline

| Subfolder | Purpose | Flow |
|-----------|---------|------|
| `learning/input/` | Learn-input files land here — raw questions, topics, unknowns | Entry point |
| `learning/research/` | Raw research output — CODE template investigations | Processing |
| `learning/output/` | Structured ELF pages — validated knowledge artifacts | Structured output |
| `learning/specs/` | VANA-SPEC + GSD-STATE — formal system specifications | Handoff to PLAN |

## Alignment Checklist
- [ ] PROJECT_CHARTER.md is complete — purpose, scope, and success criteria defined
- [ ] STAKEHOLDERS.md identifies all stakeholders and their UBS/UDS
- [ ] REQUIREMENTS.md decomposes needs as Verb + Adverbs + Noun + Adjectives (UT#3)
- [ ] OBJECTIVES.md defines what outcomes look like
- [ ] KEY_RESULTS.md has measurable results with formulas, each tagged to a Pillar
- [ ] Learning pipeline has been run for all identified unknowns
- [ ] ELF pages in `learning/output/` are validated and complete
- [ ] VANA specs in `learning/specs/` are ready for handoff to 2-PLAN

## Pre-Flight — 3 Pillars Check

### Sustainability — Does our alignment manage failure risks?
- [ ] Stakeholder conflicts identified and addressed
- [ ] Requirements are unambiguous (no room for misinterpretation)
- [ ] Success criteria are measurable (not aspirational)
- [ ] All critical unknowns have been researched (no blind spots)

### Efficiency — Is our alignment lean?
- [ ] No redundant or conflicting requirements
- [ ] Scope is appropriate (not gold-plated)
- [ ] Alignment artifacts are concise and actionable
- [ ] Learning is time-boxed (no analysis paralysis)

### Scalability — Does our alignment handle growth?
- [ ] Requirements accommodate future feature expansion
- [ ] OKRs can be cascaded to sub-teams
- [ ] Decision records support onboarding new contributors
- [ ] Learning output is reusable across related projects
