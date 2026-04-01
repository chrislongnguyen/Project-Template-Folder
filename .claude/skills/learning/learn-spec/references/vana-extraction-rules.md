# VANA Extraction Rules — /learn:spec

> Detailed per-step extraction procedures. Referenced by SKILL.md. Do not modify section numbering.

---

## Step 1: Load System Identity (§1)

From `2-LEARN/input/learn-input-{system-slug}.md`:
- `system_name`, `system_slug`, `system_abbrev`, `eo`, `topic_list`
- `input_contract`, `output_contract` (§3 and §4 tables)
- `user_persona_r`, `user_persona_a`, `anti_persona`

From `T0.P0-overview-and-summary.md`:
- RACI table (Workstream Contract) for roles C and I
- Learning Book number (infer from directory name if not explicit)

---

## Step 2: Verb ACs from T0.P5 (§2)

Read `T0.P5-steps-to-apply.md`. Find all `STEP.n(R)` rows.

For each row:
- **VANA Word**: dominant verb from col 3 (ACT) — one word (`Initialize`, `Acquire`, `Validate`)
- **Criteria**: "The agent {verb} {object}, producing {measurable output}." — 1 sentence
- **Source**: `T0.P5:{row_label}:Col3`
- **Eval type**: Deterministic (file/code/artifact) | Manual (quality judgment) | AI-Graded (NL quality)
- **Threshold**: Deterministic → 100% | Manual → PM approval | AI-Graded → 95% agreement
- **Iteration**: I1

IDs: Verb-AC1, Verb-AC2, …

**SPAWNED ACs (I4):** Scan `STEP.n(A)` col 16 (NEXT) for scope expansions. Create SPAWNED-AC rows continuing the Verb-ACn sequence. Set VANA Element = `Verb (SPAWNED)` in §9.

---

## Step 3: Adverb ACs from T0.P3 (§3)

Read `T0.P3-principles.md`. Find all `P[n](pillar)(role)` rows (enabling principles only — not `P_F`).

Bucket by pillar: S → §3.1 SustainAdv (I1) | E → §3.2 EffAdv (I2) | Sc → §3.3 ScalAdv (I3)

For each row:
- **VANA Word**: single adverb from principle name (e.g., `Traceably`, `Atomically`)
- **Criteria**: "The system demonstrates {principle} by {observable behavior from col 1 REL}."
- **Source**: `T0.P3:{row_label}:Col1`
- **Eval type**: Manual | AI-Graded — threshold 90% agreement
- **Iteration**: per pillar bucket

IDs: SustainAdv-AC1, EffAdv-AC1, ScalAdv-AC1, …

---

## Step 4: Noun ACs from T0.P4 (§4)

Read `T0.P4-components.md`. Bucket by layer prefix (`INFRA.n`, `PIPELINE.n`, `QUALITY.n`, or system-specific).

For each component row:
- **VANA Word**: single noun from component name (`Repository`, `Pipeline`, `Schema`)
- **Criteria**: "The {component} is installed, configured, and operational: {key functionality from col 3 ACT}."
- **Source**: `T0.P4:{row_label}:Col3`
- **Eval type**: Deterministic — threshold 100% installed and functional
- **Iteration**: I1

IDs: Noun-AC1, Noun-AC2, … (continuous across layers)

**Hardening ACs (I4):** Read T0.P0 RACI(I) role. Create 2-3 Noun (Hardening) rows (e.g., `Audit-Trail`, `Recovery`, `Trust-Gate`) continuing the Noun-ACn sequence. Set VANA Element = `Noun (Hardening)` in §9.

---

## Step 5: Adjective ACs — P3 × P4 Cross-Reference (§5)

For each P4 component row, read col 6 (UD.EP) to find referenced P3 principles.

For each component × principle pair:
- **VANA Word**: single adjective capturing quality (`Provenance-embedded`, `Tidy`, `Idempotent`)
- **Criteria**: "{component} satisfies {principle}: {quality attribute from P3 ACT + P4 ACT}."
- **Source**: `T0.P3+P4:{principle_row}+{component_row}`
- **Eval type**: Manual | AI-Graded — threshold 90% agreement

IDs by pillar: SustainAdj-AC1, EffAdj-AC1, ScalAdj-AC1, …

---

## Step 6: AC-TEST-MAP (§6)

One row per AC, in order: Verb-ACs → SustainAdv → EffAdv → ScalAdv → Noun-ACs → SustainAdj → EffAdj → ScalAdj.

Columns: AC ID | VANA Source | VANA Word | Criteria | Eval Type | Dataset Description | Grader Description | Threshold

- **Dataset**: "Sample of {agent outputs / principle applications / component states} from a test run of {system_name}"
- **Grader — Deterministic**: "Automated test: check for presence and correctness of output artifact"
- **Grader — Manual**: "Human Director (Investment Analyst) reviews output against criteria checklist"
- **Grader — AI-Graded**: "Claude grades sample outputs against criteria rubric (95% agreement threshold with human graders)"

---

## Step 7: Failure Modes from T0.P1 (§7)

Read `T0.P1-ultimate-blockers.md`. Find `UBS(R)` and `UBS(A)` rows.

For each UBS row (Iteration 1):
- **Failure Mode**: blocker name from row label (synthesize from col 4 UD)
- **Trigger**: col 3 (ACT) — how the blocker operates — 1 sentence
- **Detection**: col 11 (UB.MECH) — how detected — 1 sentence
- **Recovery**: col 15 (ELSE) — what to do — 1-2 sentences
- **Escalation**: "Alert Human Director if recovery fails after 1 attempt"
- **Degradation**: "Log error and halt pipeline; do not proceed with corrupted data"

Repeat for Iterations 2-4 with "(same as I1 — expand as system matures)".

---

## Step 8: Agent Behavioral Boundaries from T0.P0 + T0.P5 (§8)

**Always:** T0.P5 STEP.n(R) col 3 — 3-5 key autonomous actions
**Ask First:** T0.P5 STEP.n(A) col 3 + any EO scope modification, schema change, or PM delivery
**Never:** Proceeding with invalid data | Modifying raw/ source | Delivering without Analyst approval | Acting outside EO scope

Repeat for Iterations 2-4 with "(same as I1 — tighten as scope expands)".

**Model Selection:** Steps requiring data integrity judgment → Opus | Routine file ops → Haiku | NL synthesis → Sonnet

---

## Step 9: Iteration Plan (§9)

**Master Scope Mapping:** One row per AC from §2-§5.

| Iteration | ACs |
|-----------|-----|
| I1 | Verb-ACs, SustainAdv-ACs, Noun-ACs, SustainAdj-ACs |
| I2 | EffAdv-ACs, EffAdj-ACs |
| I3 | ScalAdv-ACs, ScalAdj-ACs |
| I4 | SPAWNED Verb-ACs, Hardening Noun-ACs, any `[NEEDS REVIEW]` deferred ACs |

All Status fields: "To Do"

I4 Gate Criteria: "All I1-I3 ACs pass eval + Human Director sign-off on SPAWNED scope"

---

## Step 10: Integration Contracts (§10)

**INPUT CONTRACT:** Copy table from learn-input §3 (fields: source, schema, validation, error, sla, version).
**OUTPUT CONTRACT:** Copy table from learn-input §4 (fields: consumer, schema, validation, error, sla, version).
