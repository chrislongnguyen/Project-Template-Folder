---
version: "1.1"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-29
owner: Long Nguyen
---
# ALIGN Zone — DESIGN Specification

## Intent

Define the complete alignment package for the LTC Project Template so that Zone 2 (PLAN) can begin architecture and roadmap without asking ALIGN questions.

## Required Artifacts (6)


| #   | Artifact         | File Path                                       | Key Content                                                                                                                   | Success Criteria                                                                             |
| --- | ---------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| A1  | **Charter**      | `1-ALIGN/charter/PROJECT_CHARTER.md`            | WHY (EO), WHAT (scope boundary), WHO (primary user), HOW (governing principles S/E/Sc), WHEN (timeline), RISKS (initial scan) | EO is one testable sentence. In/out scope table exists. Primary user named.                  |
| A2  | **Stakeholders** | `1-ALIGN/charter/STAKEHOLDERS.md`               | Stakeholder map with RACI (R≠A), per-stakeholder UBS/UDS, engagement level, anti-persona                                      | R and A are different actors. Anti-persona specific enough to make design decisions against. |
| A3  | **Requirements** | `1-ALIGN/charter/REQUIREMENTS.md`               | VANA-decomposed requirements, binary ACs, MoSCoW tags, 3-pillar check, traceability                                           | Every REQ has Verb+Adverb+Noun+Adjective. Every AC returns PASS/FAIL.                        |
| A4  | **OKRs**         | `1-ALIGN/okrs/OBJECTIVES.md` + `KEY_RESULTS.md` | Objectives + Key Results with formulas, each KR tagged S/E/Sc, ≥1 KR per pillar                                               | KRs have explicit measurement formulas. All 3 pillars represented.                           |
| A5  | **UBS Register** | `2-PLAN/risks/UBS_REGISTER.md`                  | Blocking forces from both R and A perspectives, with mitigations                                                              | 8+ risks. Dual-perspective (builder + director). Each has mitigation.                        |
| A6  | **UDS Register** | `2-PLAN/drivers/UDS_REGISTER.md`                | Driving forces with leverage strategies, tagged S/E/Sc                                                                        | 7+ drivers. Each has concrete leverage strategy.                                             |


## 10 Conditions for ALIGN Completion


| #   | Condition                      | Binary Test                                                              |
| --- | ------------------------------ | ------------------------------------------------------------------------ |
| C1  | Problem understood             | EO stated in one sentence: "[User] [desired state] without [constraint]" |
| C2  | System boundary defined        | In-scope/out-of-scope table present in charter                           |
| C3  | Primary user + anti-persona    | Named user profile + anti-persona with design implications               |
| C4  | RACI assigned                  | R ≠ A. Every stakeholder has exactly one RACI role                       |
| C5  | UBS identified (role-aware)    | 8+ risks from both R and A perspectives                                  |
| C6  | UDS identified (role-aware)    | 7+ drivers bucketed S/E/Sc                                               |
| C7  | Requirements VANA-decomposed   | Every REQ has binary AC returning PASS/FAIL                              |
| C8  | Success metrics with formulas  | KRs have explicit formulas referencing real data                         |
| C9  | Domain understood              | Binary ACs are specific, not generic                                     |
| C10 | Non-trivial decisions recorded | ADRs exist for multi-option choices                                      |


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

- Do NOT invent new zones or rename existing ones
- Do NOT produce architecture — that is Zone 2
- Sustainability > Efficiency > Scalability in all prioritization
- All requirements must use VANA grammar
- Every multi-option decision must have an ADR

