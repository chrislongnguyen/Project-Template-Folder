---
version: "1.3"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
consumes: "1-ALIGN/DESIGN.md v1.2"
produces: "Build task queue for ltc-builder"
---
# ALIGN Zone — SEQUENCE (Revision Pass)

## Context

DESIGN.md v1.2 defines 7 artifacts (A1-A7) and 10 completion conditions (C1-C10). Draft artifacts exist at `1-ALIGN/charter/drafts/` from 2026-03-26. Four new input sources (S1-S4) from 2026-03-30 require updates to all drafts. This is a REVISION pass, not blank-slate creation.

## Dependency Graph

```
T1: Charter (A1) + ADR-001, ADR-007
 ├── T2: Stakeholders (A2) + ADR-004
 │    ├── T4: UBS Register (A5)
 │    └── T5: UDS Register (A6)
 ├── T3: Requirements (A3) + ADR-005
 │    ├── T4: UBS Register (A5)
 │    └── T5: UDS Register (A6)
 ├── T6: OKRs (A4)  ← needs T3
 └── T7: ADR Finalization (A7 remainder)  ← needs T1-T6

Critical path: T1 → T3 → T4 → T7
Parallelism: T2‖T3 after T1. T4‖T5‖T6 after T2+T3. T7 last.

     T1 ──┬── T2 ──┬── T4 ──┐
           │        │        │
           └── T3 ──┼── T5 ──┼── T7
                    │        │
                    └── T6 ──┘
```

ADRs are produced CONTINUOUSLY during the task that needs them:
- T1 decides: ADR-001 (LEARN placement — Must), ADR-007 (multi-agent arch — Must)
- T2 decides: ADR-004 (subfolder descriptions — Must)
- T3 decides: ADR-005 (release flow — Must)
- T7 records: ADR-002 (Obsidian CLI — Should), ADR-003 (knowledge layer — Could), ADR-006 (synthesis step — Should) as deferred

---

## T1: Revise Charter (A1)

**Artifacts:** A1, ADR-001, ADR-007
**Duration:** 45 min
**Depends on:** — (entry point)

**Input files:**
- `1-ALIGN/DESIGN.md` — contract (A1 row, C1, C2)
- `1-ALIGN/charter/drafts/PROJECT_CHARTER.md` — baseline draft
- `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md` — delta table, LEARN zone specifics, design principles
- `2-LEARN/input/2026-03-30-vinh-direction.md` — 3 directives, 3-layer architecture

**Output files:**
- `1-ALIGN/charter/PROJECT_CHARTER.md`
- `1-ALIGN/decisions/ADR-001-learn-zone-placement.md`
- `1-ALIGN/decisions/ADR-007-multi-agent-architecture.md`

**Work:**
1. Apply the 5 delta items from synthesis (zone count, `_genesis/` naming, LEARN extraction, Obsidian scope, timeline)
2. Rewrite §2 scope to reflect ALPEI 5-zone flow with LEARN as separate zone
3. Replace `_shared/` with `_genesis/` throughout
4. Update §4 principles: remove Sc2 (LEARN-inside-ALIGN), add ALPEI-as-flow principle
5. Refresh §5 timeline with current dates
6. Add scope delta table (charter claim vs current reality) as appendix
7. Produce ADR-001: options for LEARN zone artifacts, decide placement + minimum artifact set
8. Produce ADR-007: formalize from S4 design spec (Approach D, 4 agents, eval gates)

**Acceptance Criteria:**
- [ ] EO is one testable sentence in format "[User] [desired state] without [constraint]"
- [ ] In/out scope table exists with LEARN zone explicitly scoped
- [ ] `_genesis/` used throughout (zero occurrences of `_shared/`)
- [ ] Scope delta table present showing what changed from draft
- [ ] ADR-001 has options, 3-pillar eval, chosen option with reasoning
- [ ] ADR-007 has options, references H1/H2/H5 evidence from S4

**Conditions fulfilled:** C1, C2

---

## T2: Revise Stakeholders (A2)

**Artifacts:** A2, ADR-004
**Duration:** 30 min
**Depends on:** T1

**Input files:**
- `1-ALIGN/DESIGN.md` — A2 row, C3, C4
- `1-ALIGN/charter/drafts/STAKEHOLDERS.md` — baseline draft
- `1-ALIGN/charter/PROJECT_CHARTER.md` — T1 output (EO, scope)
- `2-LEARN/input/2026-03-30-user-issues.md` — Dat and Khang feedback
- `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md` — R06, R08-R09, ADR-004 candidates

**Output files:**
- `1-ALIGN/charter/STAKEHOLDERS.md`
- `1-ALIGN/decisions/ADR-004-subfolder-descriptions.md`

**Work:**
1. Update Dat's entry: subfolder descriptions needed, skill scope leakage, agent guessing
2. Update Khang's entry: release flow needed, version tracking unclear
3. Add per-stakeholder UBS/UDS columns if missing
4. Add anti-persona with specific design implications
5. Complete RACI: assign C/I for Dat, Khang, other members
6. Produce ADR-004: subfolder description mechanism (README vs YAML vs manifest vs CLAUDE.md)

**Acceptance Criteria:**
- [ ] R and A are different actors
- [ ] Dat named with specific needs from S2 (subfolder clarity, agent guessing)
- [ ] Khang named with specific needs from S2 (release flow, version tracking)
- [ ] Anti-persona defined, specific enough to make design decisions against
- [ ] Every stakeholder has exactly one RACI role
- [ ] Per-stakeholder UBS/UDS present
- [ ] ADR-004 has options, 3-pillar eval, chosen option

**Conditions fulfilled:** C3, C4

---

## T3: Revise Requirements (A3)

**Artifacts:** A3, ADR-005
**Duration:** 60 min
**Depends on:** T1

**Input files:**
- `1-ALIGN/DESIGN.md` — A3 row, C7, C9
- `1-ALIGN/charter/drafts/REQUIREMENTS.md` — baseline draft
- `1-ALIGN/charter/PROJECT_CHARTER.md` — T1 output (scope, principles)
- `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md` — R01-R24, pillar corrections

**Output files:**
- `1-ALIGN/charter/REQUIREMENTS.md`
- `1-ALIGN/decisions/ADR-005-release-flow.md`

**Work:**
1. VANA-decompose all 24 requirements (R01-R24) — Verb + Adverb + Noun + Adjective
2. Write binary AC (PASS/FAIL) for each requirement
3. Apply MoSCoW tags using synthesis pillar corrections
4. Add 3-pillar check column (S/E/Sc)
5. Add traceability column linking each REQ to source (S1/S2/S4)
6. Ensure every AC references at least one ALPEI zone, agent role, or template-specific noun (C9)
7. Produce ADR-005: release announcement flow options

**Acceptance Criteria:**
- [ ] Every REQ has Verb + Adverb + Noun + Adjective decomposition
- [ ] Every AC returns PASS/FAIL (binary)
- [ ] All 24 source requirements (R01-R24) traceable to S1/S2/S4
- [ ] MoSCoW tags present on every REQ
- [ ] Every AC references at least one ALPEI zone, agent role, or template-specific noun
- [ ] ADR-005 has options, 3-pillar eval, chosen option

**Conditions fulfilled:** C7, C9

---

## T4: Build UBS Register (A5)

**Artifacts:** A5
**Duration:** 30 min
**Depends on:** T2, T3

**Input files:**
- `1-ALIGN/DESIGN.md` — A5 row, C5
- `1-ALIGN/charter/PROJECT_CHARTER.md` — T1 output (§6 initial risks)
- `1-ALIGN/charter/STAKEHOLDERS.md` — T2 output (per-stakeholder UBS)
- `1-ALIGN/charter/REQUIREMENTS.md` — T3 output (requirements that can fail)
- `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md` — C5 evidence, LT-1/3/7/8 from S4

**Output file:** `3-PLAN/risks/UBS_REGISTER.md`

**Work:**
1. Consolidate risks from charter (3 initial), stakeholder UBS, and synthesis (team + multi-agent)
2. Tag each risk with perspective: R (builder) or A (director)
3. Add mitigation strategy per risk
4. Ensure team-reported risks present: adoption friction, agent guessing, version confusion, skill scope leakage
5. Ensure multi-agent risks present: LT-1 cascading hallucination, LT-3 reasoning degradation, LT-7 token waste, LT-8 agent drift

**Acceptance Criteria:**
- [ ] 8+ risks present
- [ ] Dual-perspective: both R (builder) and A (director) risks
- [ ] Each risk has mitigation strategy
- [ ] Team-reported risks explicitly present: adoption friction, agent guessing, version confusion
- [ ] Multi-agent risks present: LT-1, LT-3, LT-7, LT-8

**Conditions fulfilled:** C5

---

## T5: Build UDS Register (A6)

**Artifacts:** A6
**Duration:** 30 min
**Depends on:** T2, T3

**Input files:**
- `1-ALIGN/DESIGN.md` — A6 row, C6
- `1-ALIGN/charter/STAKEHOLDERS.md` — T2 output (per-stakeholder UDS)
- `1-ALIGN/charter/REQUIREMENTS.md` — T3 output (requirements to leverage)
- `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md` — C6 evidence, driver list

**Output file:** `3-PLAN/drivers/UDS_REGISTER.md`

**Work:**
1. Consolidate drivers from stakeholder UDS and synthesis
2. Tag each driver S/E/Sc
3. Add concrete leverage strategy per driver
4. Ensure required drivers present: multi-agent orchestration, Obsidian CLI, ALPEI framework, three learning types

**Acceptance Criteria:**
- [ ] 7+ drivers present
- [ ] Each driver tagged S/E/Sc
- [ ] Each driver has concrete leverage strategy
- [ ] Multi-agent orchestration listed as driver
- [ ] ALPEI flow listed as driver
- [ ] Three learning types listed as organizational model driver

**Conditions fulfilled:** C6

---

## T6: Build OKRs (A4)

**Artifacts:** A4
**Duration:** 30 min
**Depends on:** T3

**Input files:**
- `1-ALIGN/DESIGN.md` — A4 row, C8
- `1-ALIGN/charter/PROJECT_CHARTER.md` — T1 output (EO, success definition)
- `1-ALIGN/charter/REQUIREMENTS.md` — T3 output (MoSCoW reqs as KR source)
- `2-LEARN/input/2026-03-30-user-issues.md` — Vinh: "success metrics = adoption"

**Output files:**
- `1-ALIGN/okrs/OBJECTIVES.md`
- `1-ALIGN/okrs/KEY_RESULTS.md`

**Work:**
1. Define objectives aligned to EO and I1 sustainability focus
2. Write key results with explicit measurement formulas
3. Tag each KR with S/E/Sc pillar
4. Ensure at least 1 KR per pillar
5. Include adoption-focused KR per Vinh's directive

**Acceptance Criteria:**
- [ ] Objectives align to charter EO
- [ ] Every KR has explicit measurement formula referencing real data
- [ ] All 3 pillars represented (>=1 KR per pillar)
- [ ] At least one adoption-focused KR

**Conditions fulfilled:** C8

---

## T7: Finalize Deferred ADRs (A7 remainder)

**Artifacts:** ADR-002, ADR-003, ADR-006
**Duration:** 20 min
**Depends on:** T1, T2, T3 (Must ADRs already produced)

**Input files:**
- `1-ALIGN/DESIGN.md` — A7 row, C10
- `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md` — ADR candidates section
- Verify existence: `1-ALIGN/decisions/ADR-001-*`, `ADR-004-*`, `ADR-005-*`, `ADR-007-*`

**Output files:**
- `1-ALIGN/decisions/ADR-002-obsidian-cli.md`
- `1-ALIGN/decisions/ADR-003-knowledge-layer.md`
- `1-ALIGN/decisions/ADR-006-synthesis-step.md`

**Work:**
1. ADR-002 (Obsidian CLI — Should): record options, note "Long explores first," defer decision
2. ADR-003 (Knowledge layer — Could): record 3-layer model options, defer to I2
3. ADR-006 (Synthesis step — Should): record options, defer to LEARN zone design
4. Each ADR: options list, 3-pillar eval, explicit "deferred" status with rationale

**Acceptance Criteria:**
- [ ] ADR-002, ADR-003, ADR-006 exist with options and 3-pillar eval
- [ ] Deferred ADRs explicitly marked deferred with rationale
- [ ] All 7 ADRs (001-007) exist across T1/T2/T3/T7 outputs
- [ ] Must ADRs (001, 004, 005, 007) have chosen options
- [ ] Should/Could ADRs (002, 003, 006) have options recorded, decision deferred

**Conditions fulfilled:** C10

---

## Execution Summary

| Task | Artifact(s) | Depends On | Est. | Conditions |
|------|-------------|------------|------|------------|
| T1   | A1, ADR-001, ADR-007 | — | 45m | C1, C2 |
| T2   | A2, ADR-004 | T1 | 30m | C3, C4 |
| T3   | A3, ADR-005 | T1 | 60m | C7, C9 |
| T4   | A5 | T2, T3 | 30m | C5 |
| T5   | A6 | T2, T3 | 30m | C6 |
| T6   | A4 | T3 | 30m | C8 |
| T7   | ADR-002/003/006 | T1-T3 | 20m | C10 |

**Total:** ~4 hours sequential / ~2.5 hours with parallelism
**Tasks:** 7 (within 5-12 range)
**All 10 conditions (C1-C10) covered across T1-T7**
