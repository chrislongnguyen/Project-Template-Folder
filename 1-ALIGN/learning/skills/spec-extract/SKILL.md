---
name: spec-extract
description: >
  Extracts content from approved T0 Effective Learning pages (P0-P5) and
  populates 1-ALIGN/learning/templates/vana-spec-template.md to produce a VANA-SPEC file.
  Run after /learn:review approves all 6 T0 pages.
argument-hint: <system-slug>
context: fork
model: opus
allowed-tools: Read, Glob, Write, Bash
---

# /spec:extract — VANA-SPEC Generator

You are populating a **VANA-SPEC** (Verb-Adverb-Noun-Adjective Specification) for a system.
You read the 6 approved T0 Effective Learning pages and extract structured data into the VANA-SPEC template.
This spec is the handoff document from the Learn pipeline to the Build pipeline (GSD / dev work).

## Arguments

Parse `{system-slug}` from the invocation (e.g., `data-foundation`).
If missing, check for a single `1-ALIGN/learning/input/learn-input-*.md` file. If exactly one exists, use it.

---

## Injected Context

### Learn Input Metadata
!`cat 1-ALIGN/learning/input/learn-input-*.md 2>/dev/null`

### VANA-SPEC Template
!`cat 1-ALIGN/learning/templates/vana-spec-template.md 2>/dev/null`

---

## Pre-Checks

1. Verify `1-ALIGN/learning/output/{system-slug}/T0.P0-overview-and-summary.md` exists. If not, error: "Run /learn:structure first."
2. Collect all 6 T0 page files and check frontmatter `status:` field on each:
   - If any page is missing `status: approved`, error: "Page T0.P{m} is not approved. Run /learn:review first."
3. Read `1-ALIGN/learning/templates/vana-spec-template.md`. If missing, error: "1-ALIGN/learning/templates/vana-spec-template.md not found."
4. Create `1-ALIGN/learning/specs/{system-slug}/` directory if it doesn't exist: `mkdir -p 1-ALIGN/learning/specs/{system-slug}`.

---

## Extraction Procedure

### Step 1: Load System Identity (from learn-input + T0.P0)

From `1-ALIGN/learning/input/learn-input-{system-slug}.md`:
- `system_name` — from "system_name:" field
- `system_slug` — the argument passed in
- `system_abbrev` — from "subject_abbreviation:" field
- `eo` — from "eo:" field (full text)
- `topic_list` — from Topics table (e.g., "T0–T5")
- `input_contract` — §3 Input Contract table
- `output_contract` — §4 Output Contract table
- `user_persona_r` — from "user_persona_r:" field
- `user_persona_a` — from "user_persona_a:" field
- `anti_persona` — from "anti_persona:" field

From `1-ALIGN/learning/output/{system-slug}/T0.P0-overview-and-summary.md`:
- RACI table (Workstream Contract section) for roles C and I
- Learning Book number (infer from directory name if not explicit — ask if ambiguous)

### Step 2: Extract Verb ACs from T0.P5 (§2)

Read `1-ALIGN/learning/output/{system-slug}/T0.P5-steps-to-apply.md`. Find all rows where the row label is `STEP.n(R)` (Responsible = agent steps).

For each `STEP.n(R)` row:
- **VANA Word**: Extract the single dominant verb from col 3 (ACT). One word or compound-word (e.g., `Initialize`, `Acquire`, `Refactor`, `Validate`). This is the grammar handle — the sentence criteria goes in the next column.
- **Criteria**: Synthesize col 3 (ACT — "Success Actions") into one testable statement:
  - Format: "The agent {verb} {object}, producing {measurable output}."
  - Keep it concise — 1 sentence, checkable by test.
  - Example: "The agent builds acquisition functions (pull_fred, pull_worldbank, pull_imf) with embedded provenance recording, producing working scripts that pull data + write pull.log + write .meta.json in a single call."
- **Source**: `T0.P5:{row_label}:Col3`
- **Eval type**:
  - If output is a file, code, or structured artifact → `Deterministic`
  - If output is quality judgment → `Manual`
  - If output is natural language quality → `AI-Graded`
- **Threshold**: For Deterministic: `100% pass rate`. For Manual: `PM approval`. For AI-Graded: `95% agreement`.
- **Iteration**: `I1`

Assign sequential Verb-AC IDs: Verb-AC1, Verb-AC2, etc.

**SPAWNED ACs (I4):** Also read T0.P5 `STEP.n(A)` rows — find col 16 (NEXT) cells that describe scope expansions beyond I1-I3 (e.g., multi-domain support, production deployment, PM-facing dashboards). For each, create a SPAWNED-AC row:
- **VANA Word**: Single verb (e.g., `Schedule`, `Distribute`, `Govern`)
- **Criteria**: Format: `SPAWNED-AC{n}: {criteria derived from NEXT cell}`
- **Source**: `T0.P5:{row_label}:Col16`
- **Eval type / Threshold**: Same rules as above
- **Iteration**: `I4`

Assign IDs by continuing the Verb-ACn sequence (e.g., if I1 ends at Verb-AC3, SPAWNED ACs are Verb-AC4, Verb-AC5, etc.). Set VANA Element = `Verb (SPAWNED)` in §9 to distinguish them. These go in the §2 table alongside the I1 Verb-ACs — same table, continuous ID sequence.

### Step 3: Extract Adverb ACs from T0.P3 (§3)

Read `1-ALIGN/learning/output/{system-slug}/T0.P3-principles.md`. Find all rows where the row label is `P[n](pillar)(role)` (enabling principles, NOT `P_F` failure principles).

Bucket by pillar:
- **S** (Sustainability) → §3.1 SustainAdv — Iteration I1
- **E** (Efficiency) → §3.2 EffAdv — Iteration I2
- **Sc** (Scalability) → §3.3 ScalAdv — Iteration I3

For each enabling principle row:
- **VANA Word**: Extract a single adverb from the principle name (e.g., `Traceably`, `Efficiently`, `Scalably`, `Atomically`). Derive from the principle's core quality attribute — how the system does the work.
- **Criteria**: Derive from col 1 (REL) — what observable behavior demonstrates this principle is applied.
  - Format: "The system demonstrates {principle name} by {observable behavior from REL cell}."
  - Keep concise, testable.
- **Source**: `T0.P3:{row_label}:Col1`
- **Eval type**: Typically `Manual` (quality principles) or `AI-Graded`.
- **Threshold**: For Manual: `Human Director approval`. For AI-Graded: `90% agreement`.
- **Iteration**: per pillar assignment above.

Assign sequential IDs: SustainAdv-AC1, EffAdv-AC1, ScalAdv-AC1, etc.

### Step 4: Extract Noun ACs from T0.P4 (§4)

Read `1-ALIGN/learning/output/{system-slug}/T0.P4-components.md`. Find all component rows. Note the 3-layer structure from the "3-Layer Causal Stack" section (layer names and descriptions).

Bucket rows by layer prefix in row label (e.g., `INFRA.n`, `PIPELINE.n`, `QUALITY.n` — or whatever 3 layers this system uses).

For each component row:
- **VANA Word**: Extract a single noun from the component name (e.g., `Repository`, `Pipeline`, `Schema`, `Catalogue`). This is the grammar handle.
- **Criteria**: Derive from col 3 (ACT) — what it means for this component to be installed and functional.
  - Format: "The {component name} is installed, configured, and operational: {key functionality from ACT cell}."
  - Keep concise, 1–2 sentences.
- **Source**: `T0.P4:{row_label}:Col3`
- **Eval type**: `Deterministic` — components are either present/absent.
- **Threshold**: `100% installed and functional`.
- **Iteration**: I1.

Assign sequential IDs: Noun-AC1, Noun-AC2, etc. (continuous across all layers).

**Hardening ACs (I4):** Also read T0.P0 RACI I (Informed) role. What does the PM need to trust the output? Create 2–3 Hardening-AC rows:
- **VANA Word**: Single noun (e.g., `Audit-Trail`, `Recovery`, `Trust-Gate`)
- **Criteria**: Quality gates for production readiness (e.g., audit log completeness, disaster recovery, PM-facing access controls)
- **Source**: `T0.P0:RACI(I)`
- **Eval type**: `Deterministic`
- **Threshold**: `100% pass rate`
- **Iteration**: `I4`

Assign IDs by continuing the Noun-ACn sequence (e.g., if I1 ends at Noun-AC7, Hardening ACs are Noun-AC8, Noun-AC9, etc.). Set VANA Element = `Noun (Hardening)` in §9 to distinguish them. These go in the §4 table after the last INTEL component — same table, continuous ID sequence.

### Step 5: Extract Adjective ACs — P3 × P4 Cross-Reference (§5)

For each P4 component layer, identify which P3 principles govern its quality:
- Look at col 6 (UD.EP) in P4 rows — these reference specific principles (e.g., `P1(S)(R)`, `P2(E)(A)`)
- The cross-reference is: "This component must satisfy these quality principles."

For each component × principle pair:
- **VANA Word**: Extract a single adjective that captures the quality attribute (e.g., `Provenance-embedded`, `Tidy`, `Idempotent`, `Partitioned`). Compound-words allowed.
- **Criteria**: "{component} satisfies {principle}: {quality attribute — synthesize from P3 col 3 (ACT) and P4 col 3 (ACT)}."
- **Source**: `T0.P3+P4:{principle_row}+{component_row}`
- **Eval type**: `Manual` (quality judgment) or `AI-Graded`.
- **Threshold**: Manual: `Human Director approval`. AI-Graded: `90% agreement`.

Assign by pillar: SustainAdj-AC1, EffAdj-AC1, ScalAdj-AC1, etc.

### Step 6: Build AC-TEST-MAP (§6)

One row per AC from §2–§5 in order:
- All Verb-ACs first
- Then SustainAdv-ACs, EffAdv-ACs, ScalAdv-ACs
- Then Noun-ACs
- Then SustainAdj-ACs, EffAdj-ACs, ScalAdj-ACs

For each row:
- **VANA Source**: section reference (§2, §3.1, §3.2, §3.3, §4, §5.1, §5.2, §5.3)
- **Eval Type**: as assigned above
- **Dataset Description**: "Sample of {agent outputs / principle applications / component states} from a test run of {system_name}"
- **Grader Description**:
  - Deterministic: "Automated test: check for presence and correctness of output artifact"
  - Manual: "Human Director (Investment Analyst) reviews output against criteria checklist"
  - AI-Graded: "Claude grades sample outputs against criteria rubric (95% agreement threshold with human graders)"
- **Threshold**: as assigned above

### Step 7: Extract Failure Modes from T0.P1 (§7)

Read `1-ALIGN/learning/output/{system-slug}/T0.P1-ultimate-blockers.md`. Find UBS(R) and UBS(A) rows.

For each UBS row, create a failure mode entry for Iteration 1:
- **Failure Mode**: the blocker name (from row label concept — synthesize from col 4 UD)
- **Trigger**: col 3 (ACT) — "how the blocker operates when active" — synthesize to 1 sentence
- **Detection**: col 11 (UB.MECH) — "how the blocker gets detected" — synthesize to 1 sentence
- **Recovery**: col 15 (ELSE) — "what to do when the blocker fires" — synthesize to 1-2 sentences
- **Escalation**: "Alert Human Director (Investment Analyst) if recovery fails after 1 attempt"
- **Degradation**: "Log error and halt pipeline; do not proceed with corrupted data"
- **Timeout**: "If detection does not fire within {n} seconds of pipeline step, assume failure"

Repeat the same failure modes for Iterations 2–4 with the note "(same as I1 — expand as system matures)".

### Step 8: Extract Agent Behavioral Boundaries from T0.P0 + T0.P5 (§8)

**Always (safe, no approval needed):** Synthesize from T0.P5 STEP.n(R) col 3 (ACT) — these are what the agent does autonomously. Pick 3–5 key recurring autonomous actions.

**Ask First (needs approval):** Synthesize from T0.P5 STEP.n(A) col 3 (ACT) — these are Accountable-role steps that require the Analyst's decision. Also include: any action that modifies the EO scope, any schema change, any delivery to the PM.

**Never (hard stops):**
- Proceeding with data that has failed schema validation
- Modifying source data in the raw/ store
- Delivering data to PM without Analyst approval
- Any action outside the EO scope (no analytics — only data preparation)
- Any action not covered by the source-inventory.yaml

Repeat the same boundaries for Iterations 2–4 with "(same as I1 — tighten as scope expands)".

**Model Selection Guidance:** Derive from T0.P5 STEP.n(R) types:
- Steps requiring data integrity judgment → Highest-capability (Opus)
- Routine file operations (mkdir, git commit) → Fastest (Haiku)
- Natural language synthesis (Data Health Reports) → Best reasoning (Sonnet)

### Step 9: Build Iteration Plan (§9)

**Master Scope Mapping:** One row per AC from §2–§5.
- Verb-ACs → I1
- SustainAdv-ACs → I1
- Noun-ACs → I1
- SustainAdj-ACs → I1
- EffAdv-ACs → I2
- EffAdj-ACs → I2
- ScalAdv-ACs → I3
- ScalAdj-ACs → I3
- Any AC marked `[NEEDS REVIEW]` during extraction → I4 (deferred until source is resolved)
- All Status fields: "To Do"

**I4 — Leadership iteration** covers three categories. SPAWNED and Hardening ACs are already in §2 and §4 tables (extracted in Steps 2 and 4). In §9, they appear in the Master Scope Mapping with Iteration = I4. Additionally:
1. **Deferred ACs** — any AC that could not be populated from source pages (marked `[NEEDS REVIEW]`). List them by ID with the note: "Deferred from I{n} — requires [reason]."

If no `[NEEDS REVIEW]` ACs exist and the source pages are complete, I4 will contain only SPAWNED and Hardening ACs (already populated in §2 and §4).

**Iteration Sequencing:** Use the standard 4-iteration table from the template. For I4 Gate Criteria, write: "All I1–I3 ACs pass eval + Human Director sign-off on SPAWNED scope".

### Step 10: Populate Integration Contracts from learn-input (§10)

**INPUT CONTRACT:** Copy the table from learn-input §3 Input Contract (fields: source, schema, validation, error, sla, version).

**OUTPUT CONTRACT:** Copy the table from learn-input §4 Output Contract (fields: consumer, schema, validation, error, sla, version).

---

## Write Output

Write the fully populated VANA-SPEC to:
```
1-ALIGN/learning/specs/{system-slug}/vana-spec.md
```

Preserve:
- All HTML comment derivation hints from the template (they become spec documentation)
- The canonical source warning header at the top
- Section structure and numbering exactly as in the template

Replace all `{placeholder}` values with extracted content.
Do not add extra sections. Do not modify the template structure.

---

## Completion Report

```
/spec:extract complete.

System:   {system_name}
Output:   1-ALIGN/learning/specs/{system-slug}/vana-spec.md

Sections populated:
  §1  System Identity           — ✓
  §2  Verb ACs                  — {N} ACs extracted (STEP.n(R) rows from T0.P5)
  §3  Adverb ACs                — {N} ACs extracted ({n}S + {n}E + {n}Sc from T0.P3)
  §4  Noun ACs                  — {N} ACs extracted ({n} INFRA + {n} PIPELINE + {n} QUALITY from T0.P4)
  §5  Adjective ACs             — {N} ACs extracted (P3 × P4 cross-reference)
  §6  AC-TEST-MAP               — {total} rows (MECE — covers all §2–§5 ACs)
  §7  Failure Modes             — {N} failure modes × 4 iterations (T0.P1 UBS)
  §8  Agent Boundaries          — Always/Ask/Never × 4 iterations
  §9  Iteration Plan            — {total} ACs assigned (I1: {n}, I2: {n}, I3: {n}, I4: {n} SPAWNED + {n} Hardening)
  §10 Integration Contracts     — Input + Output contracts from learn-input

Total ACs: {grand_total}

Next: /spec:handoff {system-slug}   ← review the spec with Human Director before building
```

---

## Hard Rules

1. **Gate enforced.** All 6 T0 pages must have `status: approved`. Any non-approved page → halt.
2. **No hallucination.** All content must derive from the page files or learn-input. Do not invent facts.
3. **No placeholder left.** Every `{placeholder}` in the template must be replaced. Use `[NEEDS REVIEW]` only if the source genuinely lacks content.
4. **Template structure is sacred.** Do not reorder sections, rename ACs, or modify the template hierarchy.
5. **MECE AC coverage.** Every P3 enabling principle → at least one Adverb AC. Every P4 component → at least one Noun AC. Every STEP.n(R) → at least one Verb AC. I4 must have SPAWNED ACs (§2) + Hardening ACs (§4).
6. **Concise criteria.** AC criteria must be 1–2 sentences, checkable, unambiguous.
7. **Traceability.** Every AC has a `Source (Page:Row:Col)` reference that can be verified against the page files.
8. **Path escaping.** Any file path containing `{placeholder}` syntax (e.g., `raw/{source}/{series}/{date}/`) must be wrapped in backticks in the output markdown. Markdown interprets bare `{...}` as empty — backtick-wrapping preserves the literal text.
9. **VANA Word required.** Every AC row must have a single-word (or compound-word) VANA grammar handle in the "VANA Word" column. Verbs are imperative (Initialize, Acquire). Adverbs end in -ly or describe manner (Traceably, Atomically). Nouns name the component (Repository, Pipeline). Adjectives describe quality (Provenance-embedded, Tidy).
