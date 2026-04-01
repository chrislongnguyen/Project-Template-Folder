---
version: "1.4"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---
# ALIGN Zone — DESIGN Specification (Revision 1.2)

## Intent

Revision pass incorporating 4 new input sources from 2026-03-30 stakeholder sessions. Updates scope to reflect ALPEI 5-zone flow (LEARN as separate zone), multi-agent orchestration, and team feedback. Primary framing: ALPEI zones are the flow the Human Director follows.

## Input Sources

| # | Source | Date | Reference |
|---|--------|------|-----------|
| S1 | Vinh whiteboard session | 2026-03-30 | `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md` §S1 |
| S2 | Team feedback session (Dat, Khang, Long, Vinh) | 2026-03-30 | Same file §S2 |
| S3 | Draft charter | 2026-03-26 | `1-ALIGN/charter/drafts/PROJECT_CHARTER.md` (partially stale) |
| S4 | Multi-agent orchestration design spec | 2026-03-30 | Worktree `feat/multi-agent-orchestration` (APPROVED) |

Full synthesis with 24 requirements and 7 ADR candidates: `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md`

## Required Artifacts (7)

| #   | Artifact         | File Path                                       | Key Content                                                                                                                   | Success Criteria                                                                             |
| --- | ---------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| A1  | **Charter**      | `1-ALIGN/charter/PROJECT_CHARTER.md`            | WHY (EO), WHAT (scope: 5-zone ALPEI flow with LEARN as separate zone), WHO (primary user), HOW (S/E/Sc principles), `_genesis/` naming throughout. Scope delta table vs draft charter (S3). | EO is one testable sentence. In/out scope table exists. LEARN zone explicitly scoped. `_genesis/` used (not `_shared/`). |
| A2  | **Stakeholders** | `1-ALIGN/charter/STAKEHOLDERS.md`               | Stakeholder map with RACI (R!=A). Named user personas: Dat (builder/dev — agents guess context), Khang (new adopter — version/release unclear). Per-stakeholder UBS/UDS. Anti-persona. | R and A are different actors. Dat and Khang named with specific needs from S2. Anti-persona specific enough to make design decisions against. |
| A3  | **Requirements** | `1-ALIGN/charter/REQUIREMENTS.md`               | VANA-decomposed requirements incorporating R01-R24 from synthesis. Binary ACs, MoSCoW tags, 3-pillar check, traceability to S1-S4. | Every REQ has Verb+Adverb+Noun+Adjective. Every AC returns PASS/FAIL. All 24 source requirements traceable. |
| A4  | **OKRs**         | `1-ALIGN/okrs/OBJECTIVES.md` + `KEY_RESULTS.md` | Objectives + Key Results with formulas, each KR tagged S/E/Sc, >=1 KR per pillar                                               | KRs have explicit measurement formulas. All 3 pillars represented.                           |
| A5  | **UBS Register** | `3-PLAN/risks/UBS_REGISTER.md`                  | Blocking forces from R and A perspectives. Must include team-reported risks: adoption friction [S2-consensus], agent guessing context [S2-Dat], version/release confusion [S2-Khang], skill scope leakage [S2-Dat]. Multi-agent risks: cascading hallucination (LT-1), reasoning degradation (LT-3), token waste (LT-7), agent drift (LT-8) [S4]. | 8+ risks. Dual-perspective (builder + director). Each has mitigation. Team-reported risks (friction, guessing, version) explicitly present. |
| A6  | **UDS Register** | `3-PLAN/drivers/UDS_REGISTER.md`                | Driving forces with leverage strategies, tagged S/E/Sc. Must include: multi-agent orchestration (4 agents, 3 EPs, eval gates) [S4], Obsidian CLI for MD interconnectedness [S1], ALPEI framework as primary flow [S1], three learning types as organizational model [S2-Vinh]. | 7+ drivers. Each has concrete leverage strategy. Multi-agent orchestration and ALPEI flow listed as drivers. |
| A7  | **ADRs**         | `1-ALIGN/decisions/ADR-*.md`                    | ADR-001 LEARN zone placement (Must — decide now), ADR-002 Obsidian CLI (Should — record options, Long explores first), ADR-003 Knowledge layer (Could — defer to I2), ADR-004 Subfolder descriptions (Must — decide now), ADR-005 Release flow (Must — decide now), ADR-006 Synthesis step (Should — decide after LEARN zone design), ADR-007 Multi-agent architecture (Must — already designed in S4). | Each ADR has options, 3-pillar eval, chosen option with reasoning. Must-tagged ADRs decided during Build; Should/Could recorded with options, decision deferred. |

## 10 Conditions for ALIGN Completion

| #   | Condition                      | Binary Test                                                              |
| --- | ------------------------------ | ------------------------------------------------------------------------ |
| C1  | Problem understood             | EO stated in one sentence: "[User] [desired state] without [constraint]" |
| C2  | System boundary defined        | In-scope/out-of-scope table present. System boundary explicitly accounts for LEARN as a separate zone between ALIGN and PLAN. |
| C3  | Primary user + anti-persona    | Dat (builder/dev), Khang (new adopter), and agents are named with specific needs from S2. Anti-persona with design implications. |
| C4  | RACI assigned                  | R != A. Every stakeholder has exactly one RACI role                       |
| C5  | UBS identified (role-aware)    | 8+ risks from both R and A perspectives. Includes team-reported risks: adoption friction, agent guessing, version confusion. |
| C6  | UDS identified (role-aware)    | 7+ drivers bucketed S/E/Sc. Multi-agent orchestration listed as a driving force. |
| C7  | Requirements VANA-decomposed   | Every REQ has binary AC returning PASS/FAIL. R01-R24 traceable.          |
| C8  | Success metrics with formulas  | KRs have explicit formulas referencing real data                         |
| C9  | Domain understood              | Every AC in A3 references at least one ALPEI zone, agent role, or template-specific noun (not generic software terms). |
| C10 | Non-trivial decisions recorded | ADRs exist for LEARN placement, Obsidian CLI, multi-agent arch, subfolder descriptions, release flow, synthesis step, knowledge layer. |

## Rubric (for Validate phase)

| Dimension            | Weight |
| -------------------- | ------ |
| EO Clarity           | 15%    |
| EU Coverage          | 10%    |
| UBS Depth            | 20%    |
| UDS Coverage         | 10%    |
| Requirements Quality | 15%    |
| Coherence            | 15%    |
| Actionability        | 15%    |

## Constraints

- LEARN zone extraction is I1 scope per Vinh's formal directive. Zone structure becomes ALPEI: ALIGN -> LEARN -> PLAN -> EXECUTE -> IMPROVE.
- Human-Human alignment (philosophy, frameworks on WMS) is OUT OF SCOPE for I1. ALIGN zone covers Human-Agent alignment only (project artifacts in repo).
- Do NOT produce architecture — that is Zone 2
- Sustainability > Efficiency > Scalability in all prioritization
- All requirements must use VANA grammar
- Every multi-option decision must have an ADR
