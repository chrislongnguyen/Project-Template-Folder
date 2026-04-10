# VANA Extraction Rules — /learn:spec

> Detailed per-step extraction procedures. Referenced by SKILL.md. Do not modify section numbering.

---

## Step 1: Load System Identity (§1)

From `2-LEARN/_cross/input/learn-input-{system-slug}.md`:
- `system_name`, `system_slug`, `system_abbrev`, `eo`, `topic_list`
- `input_contract`, `output_contract` (§3 and §4 tables)
- `user_persona_r`, `user_persona_a`, `anti_persona`

From `T0.P0-overview-and-summary.md`:
- RACI table (Workstream Contract) for roles C and I
- Learning Book number (infer from directory name if not explicit)

---

## Step 1.5: 8-Component System Design + Environment + EOP Design (§3.1, §3.3, §3.5)

Cross-reference T0.P3 (principles) × T0.P4 (components) × T0.P0 (user/RACI) to fill the system design tables.

**§3.1 — 8-Component Table:**
For each of the 8 components (EI, EU, EA, EO, EP, EOE, EOT, EOP):
- **Current State**: synthesize from T0.P0 context + T0.P4 current layer descriptions
- **Target State**: synthesize from T0.P4 target descriptions + T0.P3 principles
- **Governing Principle(s)**: reference P[n](pillar) from T0.P3 that most directly governs this component

**§3.3 — Effective Operating Environment (EOE):**
- Discover the environment types relevant to this sub-system from T0.P0 context + T0.P1/P2 analysis. Do not assume a fixed number — the sub-system may have 1 type or several.
- **DERISK column**: from T0.P1 UBS analysis — what environmental factors must be controlled for safety
- **OPTIMIZE column**: from T0.P2 UDS analysis — what environmental factors amplify output

**§3.5 — EOP Design:**
- **Decision Matrix**: UBS elements to disable (from §2.1) and UDS elements to amplify (from §2.2)
- **Stage 1 DERISK steps**: from T0.P5 STEP.n rows tagged with Sustainability principles
- **Stage 2 OPTIMIZE steps**: from T0.P5 STEP.n rows tagged with Efficiency/Scalability principles
- **RACI per step**: R from STEP.n(R), A from STEP.n(A), C and I from T0.P0 RACI

Note: This step front-loads the system design while agent context is freshest. Steps 2-5 (ACs) derive from this design.

---

## Step 2: Verb ACs from T0.P5 (§4.1)

Read `T0.P5-steps-to-apply.md`. Find all `STEP.n(R)` rows.

For each row:
- **VANA Word**: dominant verb from col 3 (ACT) — one word (`Initialize`, `Acquire`, `Validate`)
- **Criteria**: "The agent {verb} {object}, producing {measurable output}." — 1 sentence
- **Source**: `T0.P5:{row_label}:Col3`
- **Eval type**: Deterministic (file/code/artifact) | Manual (quality judgment) | AI-Graded (NL quality)
- **Threshold**: Deterministic → 100% | Manual → PM approval | AI-Graded → 95% agreement
- **Iteration**: Iteration 1

IDs: Verb-AC1, Verb-AC2, …

**SPAWNED ACs (Iteration 4):** Scan `STEP.n(A)` col 16 (NEXT) for scope expansions. Create SPAWNED-AC rows continuing the Verb-ACn sequence. Set VANA Element = `Verb (SPAWNED)` in §9.

---

## Step 3: Adverb ACs from T0.P3 (§4.2)

Read `T0.P3-principles.md`. Find all `P[n](pillar)(role)` rows (enabling principles only — not `P_F`).

Bucket by pillar: S → §4.2.1 SustainAdv (Iteration 1) | E → §4.2.2 EffAdv (Iteration 2) | Sc → §4.2.3 ScalAdv (Iteration 3)

For each row:
- **VANA Word**: single adverb from principle name (e.g., `Traceably`, `Atomically`)
- **Criteria**: "The system demonstrates {principle} by {observable behavior from col 1 REL}."
- **Source**: `T0.P3:{row_label}:Col1`
- **Eval type**: Manual | AI-Graded — threshold 90% agreement
- **Iteration**: per pillar bucket

IDs: SustainAdv-AC1, EffAdv-AC1, ScalAdv-AC1, …

---

## Step 4: Noun ACs from T0.P4 (§4.3)

Read `T0.P4-components.md`. Group components into EOT layers as discovered during LEARN (§3.1 8-Component table, EOT row). The number of layers varies per sub-system — there may be 1, 2, 3, or more. Layer names are sub-system-specific — derive from T0.P4 component groupings, never assume a fixed count or use generic labels.

For each component row:
- **VANA Word**: single noun from component name (`Repository`, `Pipeline`, `Schema`)
- **Criteria**: "The {component} is installed, configured, and operational: {key functionality from col 3 ACT}."
- **Source**: `T0.P4:{row_label}:Col3`
- **Eval type**: Deterministic — threshold 100% installed and functional
- **Iteration**: Iteration 1

IDs: Noun-AC1, Noun-AC2, … (continuous across layers)

**Hardening ACs (Iteration 4):** Read T0.P0 RACI(I) role. Create 2-3 Noun (Hardening) rows (e.g., `Audit-Trail`, `Recovery`, `Trust-Gate`) continuing the Noun-ACn sequence. Set VANA Element = `Noun (Hardening)` in §9.

---

## Step 5: Adjective ACs — P3 × P4 Cross-Reference (§4.4)

For each P4 component row, read col 6 (UD.EP) to find referenced P3 principles.

For each component × principle pair:
- **VANA Word**: single adjective capturing quality (`Provenance-embedded`, `Tidy`, `Idempotent`)
- **Criteria**: "{component} satisfies {principle}: {quality attribute from P3 ACT + P4 ACT}."
- **Source**: `T0.P3+P4:{principle_row}+{component_row}`
- **Eval type**: Manual | AI-Graded — threshold 90% agreement

IDs by pillar: SustainAdj-AC1, EffAdj-AC1, ScalAdj-AC1, …

---

## Step 6: AC-TEST-MAP (§5)

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

Repeat for Iterations 2-4 with "(same as Iteration 1 — expand as system matures)".

---

## Step 8: Agent Behavioral Boundaries from T0.P0 + T0.P5 (§8)

**Always:** T0.P5 STEP.n(R) col 3 — 3-5 key autonomous actions
**Ask First:** T0.P5 STEP.n(A) col 3 + any EO scope modification, schema change, or PM delivery
**Never:** Proceeding with invalid data | Modifying raw/ source | Delivering without Analyst approval | Acting outside EO scope

Repeat for Iterations 2-4 with "(same as Iteration 1 — tighten as scope expands)".

**Model Selection:** Steps requiring data integrity judgment → Opus | Routine file ops → Haiku | NL synthesis → Sonnet

---

## Step 9: Iteration Plan (§9)

**Master Scope Mapping:** One row per AC from §4.1-§4.4.

| Iteration | ACs |
|-----------|-----|
| Iteration 1 | Verb-ACs, SustainAdv-ACs, Noun-ACs, SustainAdj-ACs |
| Iteration 2 | EffAdv-ACs, EffAdj-ACs |
| Iteration 3 | ScalAdv-ACs, ScalAdj-ACs |
| Iteration 4 | SPAWNED Verb-ACs, Hardening Noun-ACs, any `[NEEDS REVIEW]` deferred ACs |

All Status fields: "To Do"

Iteration 4 Gate Criteria: "All Iteration 1-Iteration 3 ACs pass eval + Human Director sign-off on SPAWNED scope"

---

## Step 10: Integration Contracts (§6)

**INPUT CONTRACT:** Copy table from learn-input §3 (fields: source, schema, validation, error, sla, version).
**OUTPUT CONTRACT:** Copy table from learn-input §4 (fields: consumer, schema, validation, error, sla, version).

## Links

- [[CLAUDE]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[blocker]]
- [[iteration]]
- [[schema]]
- [[workstream]]
